local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local LSM = E.Libs.LSM

local _G = _G
local next = next

local CreateFrame = CreateFrame
local DoesAncestryIncludeAny = DoesAncestryIncludeAny
local GetMouseFoci = GetMouseFoci
local RunNextFrame = RunNextFrame

local headerElements = {
	"SessionTimer",
	"DamageMeterTypeDropdown",
	"SessionDropdown",
	"SettingsDropdown",
}

local windowMouseOverStates = {}
local windowLeavePendingStates = {}
local hookedSessionWindows = {}
local skinnedSessionWindows = {}
local headerBackdropFrames = {}

local function IsSessionMouseOver(sessionWindow)
	if not sessionWindow then
		return false
	end

	if DoesAncestryIncludeAny and GetMouseFoci then
		return DoesAncestryIncludeAny(sessionWindow, GetMouseFoci())
	end

	return sessionWindow:IsMouseOver()
end

function S:DamageMeter_FadeAlpha(frame, targetAlpha)
	if not frame or not frame.SetAlpha then
		return
	end

	local currentAlpha = frame:GetAlpha()
	if currentAlpha == targetAlpha then
		return
	end

	local fadeTime = self.db.damageMeter.fadeTime
	if fadeTime > 0 then
		if targetAlpha > currentAlpha then
			E:UIFrameFadeIn(frame, fadeTime, currentAlpha, targetAlpha)
		else
			E:UIFrameFadeOut(frame, fadeTime, currentAlpha, targetAlpha)
		end
	else
		frame:SetAlpha(targetAlpha)
	end
end

function S:DamageMeter_GetHeaderBackdrop(sessionWindow)
	if not sessionWindow then
		return nil
	end

	local headerBackdrop = headerBackdropFrames[sessionWindow]
	if headerBackdrop then
		return headerBackdrop
	end

	local header = sessionWindow.Header
	if not header then
		return nil
	end

	header:SetTexture(nil)
	header:SetAlpha(0)

	headerBackdrop = CreateFrame("Frame", nil, sessionWindow)
	headerBackdrop:SetFrameStrata(sessionWindow:GetFrameStrata())
	headerBackdrop:SetFrameLevel(sessionWindow:GetFrameLevel())
	headerBackdrop:SetTemplate("Transparent")
	headerBackdrop:SetAlpha(0)
	headerBackdrop:ClearAllPoints()
	headerBackdrop:SetPoint("TOPLEFT", header)
	headerBackdrop:SetPoint("BOTTOMRIGHT", header)

	self:CreateShadow(headerBackdrop)

	headerBackdropFrames[sessionWindow] = headerBackdrop

	return headerBackdrop
end

function S:DamageMeter_RefreshBackdropMode(frame, isMouseOver)
	local backdrop = frame and frame.backdrop
	if not backdrop then
		return false
	end

	local mode = self.db.damageMeter.windowBackdrop
	local frameBackgroundAlpha = frame.GetBackgroundAlpha and (frame:GetBackgroundAlpha() or 1) or 1
	local alpha
	local shown

	if mode == "always" then
		alpha = frameBackgroundAlpha
		shown = true
	else
		alpha = isMouseOver and frameBackgroundAlpha or 0
		shown = isMouseOver == true
	end

	self:DamageMeter_FadeAlpha(backdrop, alpha)

	return shown
end

function S:DamageMeter_RefreshHeaderMode(sessionWindow, isMouseOver)
	if not sessionWindow then
		return
	end

	local headerPartMode = self.db.damageMeter.headerPart
	local headerBackdropMode = self.db.damageMeter.headerBackdrop
	local alpha = headerPartMode == "always" and 1 or (isMouseOver and 1 or 0)

	local headerBackdrop = self:DamageMeter_GetHeaderBackdrop(sessionWindow)
	if headerBackdrop then
		local headerBackdropAlpha = headerBackdropMode == "hide" and 0 or alpha
		self:DamageMeter_FadeAlpha(headerBackdrop, headerBackdropAlpha)
	end

	for _, key in next, headerElements do
		local element = sessionWindow[key]
		if element then
			if element.SetShown then
				element:SetShown(true)
			end

			if element.SetAlpha then
				self:DamageMeter_FadeAlpha(element, alpha)
			end

			if element.EnableMouse then
				element:EnableMouse(alpha > 0)
			end
		end
	end
end

function S:DamageMeter_ApplyEntryStyle(entry)
	if not entry then
		return
	end

	local barDB = self.db.damageMeter.bar
	local statusBarTexture = entry:GetStatusBarTexture()
	if statusBarTexture then
		statusBarTexture:SetTexture(LSM:Fetch("statusbar", barDB.texture))
		statusBarTexture:SetAlpha(barDB.alpha)
	end

	F.SetFontWithDB(entry:GetName(), barDB.font.name)
	F.SetFontWithDB(entry:GetValue(), barDB.font.value)
end

function S.DamageMeter_HandleEntry(entry)
	S:DamageMeter_ApplyEntryStyle(entry)
end

function S:DamageMeter_ScrollBoxUpdate(scrollBox)
	if not scrollBox or not scrollBox.ForEachFrame then
		return
	end

	scrollBox:ForEachFrame(S.DamageMeter_HandleEntry)
end

function S:DamageMeter_HookScrollBox(frame)
	local scrollBox = frame and frame.GetScrollBox and frame:GetScrollBox()
	if scrollBox and not self:IsHooked(scrollBox, "Update") then
		self:SecureHook(scrollBox, "Update", "DamageMeter_ScrollBoxUpdate")
		self:DamageMeter_ScrollBoxUpdate(scrollBox)
	end
end

function S:DamageMeter_SourceWindowRefresh(sourceWindow)
	self:DamageMeter_HookScrollBox(sourceWindow)
	if sourceWindow and sourceWindow.ForEachEntryFrame then
		sourceWindow:ForEachEntryFrame(S.DamageMeter_HandleEntry)
	end
end

function S:DamageMeter_ApplyWindowModes(sessionWindow, isMouseOver, force)
	if not sessionWindow then
		return
	end

	if isMouseOver == nil then
		isMouseOver = IsSessionMouseOver(sessionWindow)
	end

	if not force and windowMouseOverStates[sessionWindow] == isMouseOver then
		return
	end

	windowMouseOverStates[sessionWindow] = isMouseOver

	self:DamageMeter_RefreshBackdropMode(sessionWindow, isMouseOver)
	self:DamageMeter_RefreshHeaderMode(sessionWindow, isMouseOver)

	local sourceWindow = sessionWindow.SourceWindow
	if sourceWindow then
		self:DamageMeter_RefreshBackdropMode(sourceWindow, isMouseOver)
	end
end

function S.DamageMeter_OnSessionWindowEnter(sessionWindow)
	windowLeavePendingStates[sessionWindow] = nil
	S:DamageMeter_ApplyWindowModes(sessionWindow, true)
end

function S.DamageMeter_OnSessionWindowLeave(sessionWindow)
	if windowLeavePendingStates[sessionWindow] then
		return
	end

	windowLeavePendingStates[sessionWindow] = true

	RunNextFrame(function()
		windowLeavePendingStates[sessionWindow] = nil
		if sessionWindow:IsShown() then
			S:DamageMeter_ApplyWindowModes(sessionWindow, nil, true)
		end
	end)
end

function S:DamageMeter_HookSessionWindowInteractions(sessionWindow)
	if not sessionWindow or hookedSessionWindows[sessionWindow] then
		return
	end

	sessionWindow:HookScript("OnEnter", S.DamageMeter_OnSessionWindowEnter)
	sessionWindow:HookScript("OnLeave", S.DamageMeter_OnSessionWindowLeave)

	hookedSessionWindows[sessionWindow] = true
end

function S:DamageMeter_ApplyConfigToSessionWindow(sessionWindow)
	if not sessionWindow then
		return
	end

	self:DamageMeter_HookSessionWindowInteractions(sessionWindow)
	self:DamageMeter_HookScrollBox(sessionWindow)

	if sessionWindow.ForEachEntryFrame then
		sessionWindow:ForEachEntryFrame(S.DamageMeter_HandleEntry)
	end

	local localPlayerEntry = sessionWindow.GetLocalPlayerEntry and sessionWindow:GetLocalPlayerEntry()
	if localPlayerEntry then
		self:DamageMeter_ApplyEntryStyle(localPlayerEntry)
	end

	local sourceWindow = sessionWindow.SourceWindow
	if sourceWindow then
		if not self:IsHooked(sourceWindow, "Refresh") then
			self:SecureHook(sourceWindow, "Refresh", "DamageMeter_SourceWindowRefresh")
		end

		self:DamageMeter_HookScrollBox(sourceWindow)

		if sourceWindow.ForEachEntryFrame then
			sourceWindow:ForEachEntryFrame(S.DamageMeter_HandleEntry)
		end
	end

	self:DamageMeter_ApplyWindowModes(sessionWindow, IsSessionMouseOver(sessionWindow))
end

function S.DamageMeter_HandleSessionWindow(sessionWindow)
	if not sessionWindow then
		return
	end

	if not skinnedSessionWindows[sessionWindow] then
		S:CreateBackdropShadow(sessionWindow)

		local sourceWindow = sessionWindow.SourceWindow
		if sourceWindow then
			S:CreateBackdropShadow(sourceWindow)
		end

		skinnedSessionWindows[sessionWindow] = true
	end

	S:DamageMeter_ApplyConfigToSessionWindow(sessionWindow)
end

function S:DamageMeter_SetupSessionWindow()
	_G.DamageMeter:ForEachSessionWindow(S.DamageMeter_HandleSessionWindow)
end

function S:Blizzard_DamageMeter()
	if
		not E.private.skins.blizzard.enable
		or not E.private.skins.blizzard.damageMeter
		or not self.db.damageMeter.enable
	then
		return
	end

	self:SecureHook(_G.DamageMeter, "SetupSessionWindow", "DamageMeter_SetupSessionWindow")
	S:DamageMeter_SetupSessionWindow()
end

S:AddCallbackForAddon("Blizzard_DamageMeter")
