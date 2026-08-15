local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local LSM = E.Libs.LSM
local CH = E:GetModule("Chat")
local LO = E:GetModule("Layout")

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

local headerBackdropFrames = {}
local hookedScrollBars = {}
local hookedSessionWindows = {}
local scrollBarAlphaApplyingStates = {}
local scrollBarBaseAlphas = {}
local scrollBarHiddenByMode = {}
local skinnedSessionWindows = {}
local windowLeavePendingStates = {}
local windowMouseOverStates = {}

local function IsSessionMouseOver(sessionWindow)
	if not sessionWindow then
		return false
	end

	return DoesAncestryIncludeAny(sessionWindow, GetMouseFoci())
end

local function IsScrollBarMouseOver(scrollBar)
	if not scrollBar then
		return false
	end

	return DoesAncestryIncludeAny(scrollBar, GetMouseFoci())
end

function S:DamageMeter_GetScrollBarTargetAlpha(scrollBar)
	if not scrollBar then
		return nil
	end

	local mode = self.db.damageMeter.scrollBar
	if mode == "default" then
		return nil
	end

	local baseAlpha = scrollBarBaseAlphas[scrollBar] or 1
	if mode == "hide" then
		return 0
	end

	return IsScrollBarMouseOver(scrollBar) and baseAlpha or 0
end

function S:DamageMeter_EnforceScrollBarAlpha(scrollBar)
	if not scrollBar or scrollBarAlphaApplyingStates[scrollBar] then
		return
	end

	local targetAlpha = self:DamageMeter_GetScrollBarTargetAlpha(scrollBar)
	if targetAlpha == nil then
		return
	end

	local currentAlpha = scrollBar:GetAlpha()
	if currentAlpha == targetAlpha then
		return
	end

	scrollBarAlphaApplyingStates[scrollBar] = true
	scrollBar:SetAlpha(targetAlpha)
	scrollBarAlphaApplyingStates[scrollBar] = nil
end

function S:DamageMeter_ForceHideScrollBar(scrollBar)
	self:DamageMeter_EnforceScrollBarAlpha(scrollBar)
	scrollBar:Hide()
	scrollBarHiddenByMode[scrollBar] = true
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

function S:DamageMeter_GetWindowBackdrop(frame)
	if not frame then
		return nil
	end

	if frame.backdrop then
		return frame.backdrop
	end

	local background = frame.GetBackground and frame:GetBackground()
	return background and background.backdrop
end

function S:DamageMeter_ApplyChatBackdrop(backdrop, texturePath)
	if not backdrop then
		return
	end

	local panelColor = E.db.chat.panelColor
	backdrop:SetBackdropColor(panelColor.r, panelColor.g, panelColor.b, panelColor.a)

	local texture = backdrop.windDamageMeterTexture
	if not texture then
		texture = backdrop:CreateTexture(nil, "OVERLAY")
		backdrop.windDamageMeterTexture = texture
	end

	texture:SetDrawLayer("OVERLAY")
	texture:SetInside()
	texture:SetTexture(texturePath)
	texture:SetAlpha(E.db.general.backdropfadecolor.a or 0.5)
	texture:SetShown(texturePath ~= nil and texturePath ~= "")
end

function S:DamageMeter_ApplyChatHeaderBackdrop(sessionWindow)
	local headerBackdrop = self:DamageMeter_GetHeaderBackdrop(sessionWindow)
	if not headerBackdrop then
		return
	end

	local tabStyle = E.db.chat.panelTabTransparency and "Transparent" or nil
	local glossTexture = not tabStyle and true or nil
	headerBackdrop:SetTemplate(tabStyle, glossTexture)

	local panelTexture = headerBackdrop.windDamageMeterTexture
	if panelTexture then
		panelTexture:Hide()
	end
end

function S:DamageMeter_ApplyChatHeaderText(sessionWindow)
	local fontDB = {
		name = E.db.chat.tabFont,
		size = E.db.chat.tabFontSize,
		style = E.db.chat.tabFontOutline,
	}

	local valueColor = E.media.rgbvaluecolor
	local typeName = sessionWindow:GetDamageMeterTypeName()
	if typeName then
		F.SetFontWithDB(typeName, fontDB)
		typeName:SetTextColor(valueColor.r, valueColor.g, valueColor.b)
	end

	local sessionName = sessionWindow:GetSessionName()
	if sessionName then
		F.SetFontWithDB(sessionName, fontDB)
		sessionName:SetTextColor(valueColor.r, valueColor.g, valueColor.b)
	end

	local sessionTimer = sessionWindow:GetSessionTimerFontString()
	if sessionTimer then
		F.SetFontWithDB(sessionTimer, fontDB)
		sessionTimer:SetTextColor(valueColor.r, valueColor.g, valueColor.b)
	end
end

function S:DamageMeter_ApplyChatHeaderIcons(sessionWindow)
	local getMinimizeButton = sessionWindow.GetMinimizeButton
	local minimizeButton = getMinimizeButton and getMinimizeButton(sessionWindow)
	if not minimizeButton then
		return
	end

	local valueColor = E.media.rgbvaluecolor
	local normalTexture = minimizeButton:GetNormalTexture()
	local pushedTexture = minimizeButton:GetPushedTexture()

	if normalTexture then
		normalTexture:SetDesaturated(true)
		normalTexture:SetVertexColor(valueColor.r, valueColor.g, valueColor.b)
	end

	if pushedTexture then
		pushedTexture:SetDesaturated(true)
		pushedTexture:SetVertexColor(valueColor.r, valueColor.g, valueColor.b)
	end
end

function S:DamageMeter_ApplyAppearance(sessionWindow)
	local appearance = self.db.damageMeter.appearance
	if appearance == "default" then
		return
	end

	local texturePath = appearance == "chatRight" and E.db.chat.panelBackdropNameRight
		or E.db.chat.panelBackdropNameLeft

	self:DamageMeter_ApplyChatBackdrop(self:DamageMeter_GetWindowBackdrop(sessionWindow), texturePath)
	self:DamageMeter_ApplyChatHeaderBackdrop(sessionWindow)

	local sourceWindow = sessionWindow.SourceWindow
	if sourceWindow then
		self:DamageMeter_ApplyChatBackdrop(self:DamageMeter_GetWindowBackdrop(sourceWindow), texturePath)
	end

	self:DamageMeter_ApplyChatHeaderText(sessionWindow)
	self:DamageMeter_ApplyChatHeaderIcons(sessionWindow)
end

function S:DamageMeter_RefreshBackdropMode(frame, isMouseOver)
	local backdrop = self:DamageMeter_GetWindowBackdrop(frame)
	if not backdrop then
		return false
	end

	local mode = self.db.damageMeter.windowBackdrop
	local useBlizzardAlpha = self.db.damageMeter.appearance == "default"
	local frameBackgroundAlpha = 1
	if useBlizzardAlpha and frame.GetBackgroundAlpha then
		frameBackgroundAlpha = frame:GetBackgroundAlpha() or 1
	end
	local alpha
	local shown

	if mode == "always" then
		alpha = frameBackgroundAlpha
		shown = true
	elseif mode == "hide" then
		alpha = 0
		shown = false
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

	local minimizeButton = sessionWindow.GetMinimizeButton and sessionWindow:GetMinimizeButton()
	if minimizeButton then
		minimizeButton:SetShown(true)
		self:DamageMeter_FadeAlpha(minimizeButton, alpha)
		minimizeButton:EnableMouse(alpha > 0)
	end
end

function S:DamageMeter_RefreshScrollBarMode(frame)
	local scrollBar = frame:GetScrollBar()
	if not scrollBar then
		return
	end

	local currentAlpha = scrollBar:GetAlpha()
	if currentAlpha > 0 then
		scrollBarBaseAlphas[scrollBar] = currentAlpha
	end

	local mode = self.db.damageMeter.scrollBar
	if mode == "hide" then
		self:DamageMeter_ForceHideScrollBar(scrollBar)
		return
	end

	if scrollBarHiddenByMode[scrollBar] then
		scrollBarHiddenByMode[scrollBar] = nil
		scrollBar:Show()
	end

	if mode == "default" then
		return
	end

	self:DamageMeter_EnforceScrollBarAlpha(scrollBar)
end

function S.DamageMeter_OnScrollBarScriptShow(scrollBar)
	if S.db.damageMeter.scrollBar == "hide" then
		S:DamageMeter_ForceHideScrollBar(scrollBar)
		return
	end

	S:DamageMeter_EnforceScrollBarAlpha(scrollBar)
end

function S:DamageMeter_OnScrollBarSetAlpha(scrollBar, alpha)
	if scrollBarAlphaApplyingStates[scrollBar] then
		return
	end

	if alpha and alpha > 0 then
		scrollBarBaseAlphas[scrollBar] = alpha
	end

	self:DamageMeter_EnforceScrollBarAlpha(scrollBar)
end

function S.DamageMeter_OnScrollBarEnter(scrollBar)
	S:DamageMeter_EnforceScrollBarAlpha(scrollBar)
end

function S.DamageMeter_OnScrollBarLeave(scrollBar)
	S:DamageMeter_EnforceScrollBarAlpha(scrollBar)
end

function S:DamageMeter_HookScrollBar(frame)
	local scrollBar = frame:GetScrollBar()
	if not scrollBar then
		return
	end

	if not hookedScrollBars[scrollBar] then
		scrollBar:HookScript("OnEnter", S.DamageMeter_OnScrollBarEnter)
		scrollBar:HookScript("OnLeave", S.DamageMeter_OnScrollBarLeave)
		scrollBar:HookScript("OnShow", S.DamageMeter_OnScrollBarScriptShow)
		hookedScrollBars[scrollBar] = true
	end

	if not self:IsHooked(scrollBar, "SetAlpha") then
		self:SecureHook(scrollBar, "SetAlpha", "DamageMeter_OnScrollBarSetAlpha")
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
	local scrollBox = frame:GetScrollBox()
	if scrollBox and not self:IsHooked(scrollBox, "Update") then
		self:SecureHook(scrollBox, "Update", "DamageMeter_ScrollBoxUpdate")
		self:DamageMeter_ScrollBoxUpdate(scrollBox)
	end

	self:DamageMeter_HookScrollBar(frame)
	self:DamageMeter_RefreshScrollBarMode(frame)
end

function S:DamageMeter_SourceWindowRefresh(sourceWindow)
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
	self:DamageMeter_RefreshScrollBarMode(sessionWindow)
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

	sessionWindow:HookScript("OnEnter", function()
		S.DamageMeter_OnSessionWindowEnter(sessionWindow)
	end)
	sessionWindow:HookScript("OnLeave", function()
		S.DamageMeter_OnSessionWindowLeave(sessionWindow)
	end)

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

		if sourceWindow.ForEachEntryFrame then
			sourceWindow:ForEachEntryFrame(S.DamageMeter_HandleEntry)
		end
	end

	self:DamageMeter_ApplyAppearance(sessionWindow)
	self:DamageMeter_ApplyWindowModes(sessionWindow, IsSessionMouseOver(sessionWindow), true)
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

function S.DamageMeter_RefreshSessionWindowAppearance(sessionWindow)
	if not sessionWindow then
		return
	end

	S:DamageMeter_ApplyAppearance(sessionWindow)
end

function S.DamageMeter_RefreshAppearance()
	if not _G.DamageMeter or S.db.damageMeter.appearance == "default" then
		return
	end

	_G.DamageMeter:ForEachSessionWindow(S.DamageMeter_RefreshSessionWindowAppearance)
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
	self:SecureHook(CH, "Panels_ColorUpdate", "DamageMeter_RefreshAppearance")
	self:SecureHook(CH, "SetupChat", "DamageMeter_RefreshAppearance")
	self:SecureHook(LO, "SetChatTabStyle", "DamageMeter_RefreshAppearance")
	E.valueColorUpdateFuncs.WindToolsDamageMeter = S.DamageMeter_RefreshAppearance
	S:DamageMeter_SetupSessionWindow()
end

S:AddCallbackForAddon("Blizzard_DamageMeter")
