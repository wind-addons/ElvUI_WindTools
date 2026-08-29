local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local LSM = E.Libs.LSM

local _G = _G

local CreateFrame = CreateFrame
local DoesAncestryIncludeAny = DoesAncestryIncludeAny
local GetMouseFoci = GetMouseFoci
local hooksecurefunc = hooksecurefunc
local RunNextFrame = RunNextFrame

-- FontStrings only. ElvUI never SetAlpha/HookScript/SetShown the dropdown buttons;
-- doing that blocks SessionDropdown OnMouseDown_Intrinsic (see DropdownButton.lua).
local headerVisualGetters = {
	{ getter = "GetDamageMeterTypeName", key = "TypeName" },
	{ getter = "GetSessionName", key = "SessionName" },
}

local function GetSessionHeader(sessionWindow)
	if not sessionWindow then
		return nil
	end

	if sessionWindow.GetHeader then
		return sessionWindow:GetHeader()
	end

	return sessionWindow.Header
end

local function GetSessionBackground(sessionWindow)
	if not sessionWindow then
		return nil
	end

	if sessionWindow.GetBackground then
		return sessionWindow:GetBackground()
	end

	local minimizeContainer = sessionWindow.MinimizeContainer
	return minimizeContainer and minimizeContainer.Background
end

local function GetSessionSourceWindow(sessionWindow)
	if not sessionWindow then
		return nil
	end

	if sessionWindow.GetSourceWindow then
		return sessionWindow:GetSourceWindow()
	end

	return nil
end

local function GetSourceWindowBackground(sourceWindow)
	if not sourceWindow then
		return nil
	end

	if sourceWindow.GetBackground then
		return sourceWindow:GetBackground()
	end

	return sourceWindow.Background
end

local function GetHeaderWidget(sessionWindow, spec)
	if sessionWindow[spec.getter] then
		return sessionWindow[spec.getter](sessionWindow)
	end

	return sessionWindow[spec.key]
end

local headerMenuDropdownGetters = {
	"GetSessionDropdown",
	"GetDamageMeterTypeDropdown",
	"GetSettingsDropdown",
}

local function IsHeaderMenuActive(sessionWindow)
	if not sessionWindow then
		return false
	end

	for i = 1, #headerMenuDropdownGetters do
		local getterName = headerMenuDropdownGetters[i]
		local dropdown = sessionWindow[getterName] and sessionWindow[getterName](sessionWindow)
		if dropdown and dropdown.IsMenuOpen and dropdown:IsMenuOpen() then
			return true
		end
	end

	return false
end

local backdropAlphaApplyingStates = {}
local backgroundSessionWindows = {}
local hookedScrollBars = {}
local hookedScrollBoxes = {}
local scrollBarAlphaApplyingStates = {}
local scrollBarBaseAlphas = {}
local scrollBarHiddenByMode = {}
local scrollBarSessionWindows = {}
local scrollBoxSessionWindows = {}
local skinnedSessionWindows = {}
local trackedSessionWindows = {}
local visibilityWatcher
local windowLeavePendingStates = {}
local windowMouseOverStates = {}

local function IsSessionMouseOver(sessionWindow)
	if not sessionWindow then
		return false
	end

	if sessionWindow.IsResizing and sessionWindow:IsResizing() then
		return true
	end

	if IsHeaderMenuActive(sessionWindow) then
		return true
	end

	local mouseFoci = GetMouseFoci()
	if not mouseFoci then
		return false
	end

	if DoesAncestryIncludeAny(sessionWindow, mouseFoci) then
		return true
	end

	local resizeButton = sessionWindow.GetResizeButton and sessionWindow:GetResizeButton()
	if resizeButton and DoesAncestryIncludeAny(resizeButton, mouseFoci) then
		return true
	end

	local scrollBar = sessionWindow.GetScrollBar and sessionWindow:GetScrollBar()
	if scrollBar and DoesAncestryIncludeAny(scrollBar, mouseFoci) then
		return true
	end

	return false
end

local function StartSessionWindowMouseOver(sessionWindow)
	if not sessionWindow then
		return
	end

	windowLeavePendingStates[sessionWindow] = nil
	S:DamageMeter_ApplyWindowModes(sessionWindow, true)
end

local function StartVisibilityTracking(sessionWindow)
	if not sessionWindow then
		return
	end

	trackedSessionWindows[sessionWindow] = true

	if visibilityWatcher then
		return
	end

	visibilityWatcher = CreateFrame("Frame")
	visibilityWatcher:SetScript("OnUpdate", function()
		for trackedWindow in pairs(trackedSessionWindows) do
			if trackedWindow:IsShown() then
				S:DamageMeter_ApplyWindowModes(trackedWindow, IsSessionMouseOver(trackedWindow))
			end
		end
	end)
end

function S:DamageMeter_GetWindowBackdropTargetAlpha(sessionWindow, isMouseOver)
	local mode = self.db.damageMeter.windowBackdrop
	local frameBackgroundAlpha = sessionWindow.GetBackgroundAlpha and (sessionWindow:GetBackgroundAlpha() or 1) or 1

	if mode == "always" then
		return frameBackgroundAlpha
	elseif mode == "hide" then
		return 0
	end

	return isMouseOver and frameBackgroundAlpha or 0
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

	local sessionWindow = scrollBarSessionWindows[scrollBar]
	local isMouseOver = sessionWindow and windowMouseOverStates[sessionWindow]
	if isMouseOver == nil and sessionWindow then
		isMouseOver = IsSessionMouseOver(sessionWindow)
	end

	return isMouseOver and baseAlpha or 0
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

	E:UIFrameFadeRemoveFrame(frame)

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

function S:DamageMeter_OnBackgroundSetAlpha(background)
	if backdropAlphaApplyingStates[background] then
		return
	end

	local sessionWindow = backgroundSessionWindows[background]
	local backdrop = background and background.backdrop
	if not sessionWindow or not backdrop then
		return
	end

	local isMouseOver = windowMouseOverStates[sessionWindow]
	if isMouseOver == nil then
		isMouseOver = IsSessionMouseOver(sessionWindow)
	end

	local targetAlpha = self:DamageMeter_GetWindowBackdropTargetAlpha(sessionWindow, isMouseOver)
	if backdrop:GetAlpha() == targetAlpha then
		return
	end

	backdropAlphaApplyingStates[background] = true
	E:UIFrameFadeRemoveFrame(backdrop)
	backdrop:SetAlpha(targetAlpha)
	backdropAlphaApplyingStates[background] = nil
end

function S:DamageMeter_HookBackground(sessionWindow)
	local background = GetSessionBackground(sessionWindow)
	if not background then
		return
	end

	backgroundSessionWindows[background] = sessionWindow

	if not self:IsHooked(background, "SetAlpha") then
		self:SecureHook(background, "SetAlpha", "DamageMeter_OnBackgroundSetAlpha")
	end
end

function S:DamageMeter_RefreshBackdropMode(sessionWindow, isMouseOver)
	local background = GetSessionBackground(sessionWindow)
	local backdrop = background and background.backdrop
	if not backdrop then
		return false
	end

	self:DamageMeter_FadeAlpha(backdrop, self:DamageMeter_GetWindowBackdropTargetAlpha(sessionWindow, isMouseOver))

	return true
end

function S:DamageMeter_FadeHeaderButtonVisuals(button, widgetAlpha)
	if not button then
		return
	end

	-- ElvUI replacements (DamageMeter_HandleTypeDropdown / HandleSettingsDropdown)
	if button.customArrow then
		self:DamageMeter_FadeAlpha(button.customArrow, widgetAlpha)
	end

	if button.customIcon then
		self:DamageMeter_FadeAlpha(button.customIcon, widgetAlpha)
	end

	if button.GetNormalTexture then
		local normalTexture = button:GetNormalTexture()
		if normalTexture then
			self:DamageMeter_FadeAlpha(normalTexture, widgetAlpha)
		end
	end

	if button.GetPushedTexture then
		local pushedTexture = button:GetPushedTexture()
		if pushedTexture then
			self:DamageMeter_FadeAlpha(pushedTexture, widgetAlpha)
		end
	end

	if button.GetHighlightTexture then
		local highlightTexture = button:GetHighlightTexture()
		if highlightTexture then
			self:DamageMeter_FadeAlpha(highlightTexture, widgetAlpha)
		end
	end
end

-- ElvUI HandleSessionTimer: TOPLEFT header 3, -9
-- ElvUI HandleTypeDropdown: TOPLEFT SessionTimer TOPRIGHT 0, 4
local ELVUI_SESSION_TIMER_HEADER_X, ELVUI_SESSION_TIMER_HEADER_Y = 3, -9
local ELVUI_TYPE_DROPDOWN_TIMER_X, ELVUI_TYPE_DROPDOWN_TIMER_Y = 0, 4

-- Blizzard MinimizeButton: TOPRIGHT Header -3, -5
-- Blizzard SettingsDropdown: RIGHT MinimizeButton LEFT -2, -2
-- ElvUI HandleSettingsDropdown: NudgePoint(2, 1)
local BLIZZARD_MINIMIZE_HEADER_X, BLIZZARD_MINIMIZE_HEADER_Y = -3, -5
local BLIZZARD_SETTINGS_MINIMIZE_X, BLIZZARD_SETTINGS_MINIMIZE_Y = -2, -2
local ELVUI_SETTINGS_NUDGE_X, ELVUI_SETTINGS_NUDGE_Y = 2, 1

function S:DamageMeter_AnchorTypeDropdown(sessionWindow, showSessionTimer)
	local typeDropdown = sessionWindow.GetDamageMeterTypeDropdown and sessionWindow:GetDamageMeterTypeDropdown()
	if not typeDropdown then
		return
	end

	if showSessionTimer then
		local sessionTimer = sessionWindow.GetSessionTimerFontString and sessionWindow:GetSessionTimerFontString()
		if sessionTimer then
			typeDropdown:Point("TOPLEFT", sessionTimer, "TOPRIGHT", ELVUI_TYPE_DROPDOWN_TIMER_X, ELVUI_TYPE_DROPDOWN_TIMER_Y)
		end
		return
	end

	local header = GetSessionHeader(sessionWindow)
	if header then
		typeDropdown:Point(
			"TOPLEFT",
			header,
			ELVUI_SESSION_TIMER_HEADER_X + ELVUI_TYPE_DROPDOWN_TIMER_X,
			ELVUI_SESSION_TIMER_HEADER_Y + ELVUI_TYPE_DROPDOWN_TIMER_Y
		)
	end
end

function S:DamageMeter_RefreshSessionTimer(sessionWindow, widgetAlpha)
	local sessionTimer = sessionWindow.GetSessionTimerFontString and sessionWindow:GetSessionTimerFontString()
	if not sessionTimer then
		return
	end

	local showSessionTimer = self.db.damageMeter.sessionTimer ~= false
	if showSessionTimer then
		sessionTimer:Show()
		self:DamageMeter_FadeAlpha(sessionTimer, widgetAlpha)
	else
		sessionTimer:Hide()
	end

	self:DamageMeter_AnchorTypeDropdown(sessionWindow, showSessionTimer)
end

function S:DamageMeter_AnchorSettingsDropdown(sessionWindow, attachToMinimizeButton)
	local settingsDropdown = sessionWindow.GetSettingsDropdown and sessionWindow:GetSettingsDropdown()
	if not settingsDropdown then
		return
	end

	-- SessionDropdown stays on SettingsDropdown LEFT (Blizzard XML + ElvUI NudgePoint).
	if attachToMinimizeButton then
		local minimizeButton = sessionWindow.GetMinimizeButton and sessionWindow:GetMinimizeButton()
		if minimizeButton then
			settingsDropdown:ClearAllPoints()
			settingsDropdown:Point(
				"RIGHT",
				minimizeButton,
				"LEFT",
				BLIZZARD_SETTINGS_MINIMIZE_X + ELVUI_SETTINGS_NUDGE_X,
				BLIZZARD_SETTINGS_MINIMIZE_Y + ELVUI_SETTINGS_NUDGE_Y
			)
		end
		return
	end

	local header = GetSessionHeader(sessionWindow)
	if header then
		settingsDropdown:ClearAllPoints()
		settingsDropdown:Point("TOPRIGHT", header, BLIZZARD_MINIMIZE_HEADER_X, BLIZZARD_MINIMIZE_HEADER_Y)
	end
end

function S:DamageMeter_RefreshMinimizeButton(sessionWindow, widgetAlpha)
	local minimizeButton = sessionWindow.GetMinimizeButton and sessionWindow:GetMinimizeButton()
	if not minimizeButton then
		return
	end

	local showMinimizeButton = self.db.damageMeter.minimizeButton ~= false
	local isMinimized = sessionWindow.IsMinimized and sessionWindow:IsMinimized()
	local attachToMinimizeButton = showMinimizeButton or isMinimized
	if attachToMinimizeButton then
		minimizeButton:Show()
		self:DamageMeter_FadeHeaderButtonVisuals(minimizeButton, widgetAlpha)
	else
		minimizeButton:Hide()
	end

	self:DamageMeter_AnchorSettingsDropdown(sessionWindow, attachToMinimizeButton)
end

function S:DamageMeter_RefreshHeaderMode(sessionWindow, isMouseOver)
	if not sessionWindow then
		return
	end

	local headerPartMode = self.db.damageMeter.headerPart
	local headerBackdropMode = self.db.damageMeter.headerBackdrop
	local widgetAlpha = headerPartMode == "always" and 1 or (isMouseOver and 1 or 0)
	local headerBackdropAlpha = headerBackdropMode == "hide" and 0 or 1

	local header = GetSessionHeader(sessionWindow)
	if header then
		self:DamageMeter_FadeAlpha(header, headerBackdropAlpha)
	end

	self:DamageMeter_RefreshSessionTimer(sessionWindow, widgetAlpha)

	for i = 1, #headerVisualGetters do
		local element = GetHeaderWidget(sessionWindow, headerVisualGetters[i])
		if element and element.SetAlpha then
			self:DamageMeter_FadeAlpha(element, widgetAlpha)
		end
	end

	-- Fade ElvUI/Blizzard textures only. Leave the DropdownButtons and MinimizeButton
	-- at ElvUI's alpha so OnMouseDown_Intrinsic still receives the click.
	if sessionWindow.GetDamageMeterTypeDropdown then
		self:DamageMeter_FadeHeaderButtonVisuals(sessionWindow:GetDamageMeterTypeDropdown(), widgetAlpha)
	end

	if sessionWindow.GetSettingsDropdown then
		self:DamageMeter_FadeHeaderButtonVisuals(sessionWindow:GetSettingsDropdown(), widgetAlpha)
	end

	self:DamageMeter_RefreshMinimizeButton(sessionWindow, widgetAlpha)
end

function S:DamageMeter_RefreshScrollBarMode(frame)
	local scrollBar = frame.GetScrollBar and frame:GetScrollBar()
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
	StartSessionWindowMouseOver(scrollBarSessionWindows[scrollBar])
	S:DamageMeter_EnforceScrollBarAlpha(scrollBar)
end

function S.DamageMeter_OnScrollBarLeave(scrollBar)
	S.DamageMeter_OnSessionWindowLeave(scrollBarSessionWindows[scrollBar])
	S:DamageMeter_EnforceScrollBarAlpha(scrollBar)
end

function S:DamageMeter_HookScrollBar(frame)
	local scrollBar = frame.GetScrollBar and frame:GetScrollBar()
	if not scrollBar then
		return
	end

	scrollBarSessionWindows[scrollBar] = frame

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

function S:DamageMeter_HookHeaderWidgetMouseOver(sessionWindow, element)
	if not sessionWindow or not element or element.__windDamageMeterMouseOverHooked then
		return
	end

	element.__windDamageMeterMouseOverHooked = true

	if not element.HookScript or not element.EnableMouse then
		return
	end

	element:HookScript("OnEnter", function()
		StartSessionWindowMouseOver(sessionWindow)
	end)
	element:HookScript("OnLeave", function()
		S.DamageMeter_OnSessionWindowLeave(sessionWindow)
	end)
end

function S:DamageMeter_HookEntryMouseOver(sessionWindow, entry)
	self:DamageMeter_HookHeaderWidgetMouseOver(sessionWindow, entry)
end

function S:DamageMeter_HookSessionWindowMouseOver(sessionWindow)
	if not sessionWindow or sessionWindow.__windDamageMeterWindowHooked then
		return
	end

	sessionWindow:HookScript("OnEnter", S.DamageMeter_OnSessionWindowEnter)
	sessionWindow:HookScript("OnLeave", S.DamageMeter_OnSessionWindowLeave)
	StartVisibilityTracking(sessionWindow)

	sessionWindow.__windDamageMeterWindowHooked = true
end

function S.DamageMeter_OnSetupEntry(sessionWindow, entry)
	S:DamageMeter_HookEntryMouseOver(sessionWindow, entry)
end

function S:DamageMeter_ScrollBoxUpdate(scrollBox)
	if not scrollBox or not scrollBox.ForEachFrame then
		return
	end

	scrollBox:ForEachFrame(S.DamageMeter_HandleEntry)
end

function S.DamageMeter_OnScrollBoxEnter(scrollBox)
	StartSessionWindowMouseOver(scrollBoxSessionWindows[scrollBox])
end

function S.DamageMeter_OnScrollBoxLeave(scrollBox)
	S.DamageMeter_OnSessionWindowLeave(scrollBoxSessionWindows[scrollBox])
end

function S:DamageMeter_HookScrollBox(frame)
	local scrollBox = frame.GetScrollBox and frame:GetScrollBox()
	if scrollBox then
		scrollBoxSessionWindows[scrollBox] = frame

		if not self:IsHooked(scrollBox, "Update") then
			self:SecureHook(scrollBox, "Update", "DamageMeter_ScrollBoxUpdate")
			self:DamageMeter_ScrollBoxUpdate(scrollBox)
		end

		if not hookedScrollBoxes[scrollBox] then
			scrollBox:HookScript("OnEnter", S.DamageMeter_OnScrollBoxEnter)
			scrollBox:HookScript("OnLeave", S.DamageMeter_OnScrollBoxLeave)
			hookedScrollBoxes[scrollBox] = true
		end
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

	StartVisibilityTracking(sessionWindow)
	self:DamageMeter_RefreshBackdropMode(sessionWindow, isMouseOver)
	self:DamageMeter_RefreshHeaderMode(sessionWindow, isMouseOver)
	self:DamageMeter_RefreshScrollBarMode(sessionWindow)
end

function S:DamageMeter_RefreshAllSessionWindows()
	if not self.db or not self.db.damageMeter or not self.db.damageMeter.enable then
		return
	end

	local damageMeter = _G.DamageMeter
	if not damageMeter or not damageMeter.ForEachSessionWindow then
		return
	end

	damageMeter:ForEachSessionWindow(function(sessionWindow)
		S:DamageMeter_ApplyWindowModes(sessionWindow, nil, true)
	end)
end

function S.DamageMeter_OnSessionWindowEnter(sessionWindow)
	windowLeavePendingStates[sessionWindow] = nil
	S:DamageMeter_ApplyWindowModes(sessionWindow, true)
end

function S.DamageMeter_OnSessionWindowLeave(sessionWindow)
	if not sessionWindow or IsHeaderMenuActive(sessionWindow) then
		return
	end

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

function S:DamageMeter_HookSessionWindowMixin()
	if self.damageMeterSessionWindowMixinHooked then
		return
	end

	local mixin = _G.DamageMeterSessionWindowMixin
	if not mixin or not mixin.OnEnter then
		return
	end

	hooksecurefunc(mixin, "OnEnter", S.DamageMeter_OnSessionWindowEnter)
	if mixin.SetupEntry then
		hooksecurefunc(mixin, "SetupEntry", S.DamageMeter_OnSetupEntry)
	end

	self.damageMeterSessionWindowMixinHooked = true
end

function S:DamageMeter_ApplyConfigToSessionWindow(sessionWindow)
	if not sessionWindow then
		return
	end

	self:DamageMeter_HookSessionWindowMixin()
	self:DamageMeter_HookSessionWindowMouseOver(sessionWindow)
	self:DamageMeter_HookBackground(sessionWindow)
	self:DamageMeter_HookScrollBox(sessionWindow)

	if sessionWindow.ForEachEntryFrame then
		sessionWindow:ForEachEntryFrame(function(entry)
			S:DamageMeter_ApplyEntryStyle(entry)
			S:DamageMeter_HookEntryMouseOver(sessionWindow, entry)
		end)
	end

	local localPlayerEntry = sessionWindow.GetLocalPlayerEntry and sessionWindow:GetLocalPlayerEntry()
	if localPlayerEntry then
		self:DamageMeter_ApplyEntryStyle(localPlayerEntry)
		self:DamageMeter_HookEntryMouseOver(sessionWindow, localPlayerEntry)
	end

	local sourceWindow = GetSessionSourceWindow(sessionWindow)
	if sourceWindow then
		if not self:IsHooked(sourceWindow, "Refresh") then
			self:SecureHook(sourceWindow, "Refresh", "DamageMeter_SourceWindowRefresh")
		end

		if sourceWindow.ForEachEntryFrame then
			sourceWindow:ForEachEntryFrame(S.DamageMeter_HandleEntry)
		end
	end

	if sessionWindow.SetMinimized and not self:IsHooked(sessionWindow, "SetMinimized") then
		self:SecureHook(sessionWindow, "SetMinimized", "DamageMeter_OnSetMinimized")
	end

	self:DamageMeter_ApplyWindowModes(sessionWindow, IsSessionMouseOver(sessionWindow), true)
end

function S:DamageMeter_OnSetMinimized(sessionWindow)
	self:DamageMeter_ApplyWindowModes(sessionWindow, nil, true)
end

function S:DamageMeter_DisableShadowMouse(frame)
	local backdrop = frame and frame.backdrop
	local shadow = backdrop and backdrop.shadow
	if not shadow then
		return
	end

	shadow:EnableMouse(false)
	if shadow.SetMouseClickEnabled then
		shadow:SetMouseClickEnabled(false)
	end
	if shadow.SetMouseMotionEnabled then
		shadow:SetMouseMotionEnabled(false)
	end
end

function S.DamageMeter_HandleSessionWindow(sessionWindow)
	if not sessionWindow then
		return
	end

	if not skinnedSessionWindows[sessionWindow] then
		local background = GetSessionBackground(sessionWindow)
		if background then
			S:CreateBackdropShadow(background)
			S:DamageMeter_DisableShadowMouse(background)
		end

		local sourceBackground = GetSourceWindowBackground(GetSessionSourceWindow(sessionWindow))
		if sourceBackground then
			S:CreateBackdropShadow(sourceBackground)
			S:DamageMeter_DisableShadowMouse(sourceBackground)
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

	self:DamageMeter_HookSessionWindowMixin()
	self:SecureHook(_G.DamageMeter, "SetupSessionWindow", "DamageMeter_SetupSessionWindow")
	S:DamageMeter_SetupSessionWindow()
end

S:AddCallbackForAddon("Blizzard_DamageMeter")
