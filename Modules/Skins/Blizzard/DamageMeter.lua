local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local LSM = E.Libs.LSM

local _G = _G

local CreateFrame = CreateFrame
local GetMouseFoci = GetMouseFoci
local hooksecurefunc = hooksecurefunc
local issecretvalue = issecretvalue
local RunNextFrame = RunNextFrame

local Enum_OnUpdateMode_RunAlways = Enum.OnUpdateMode.RunAlways

local data = S:AddCallbackForAddon("Blizzard_DamageMeter", nil, function()
	return E.private.skins.blizzard.enable and E.private.skins.blizzard.damageMeter and S.db.damageMeter.enable and true
		or false
end)

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

local function DoesAccessibleAncestryInclude(ancestry, frame)
	local currentFrame = frame
	while currentFrame do
		if issecretvalue(currentFrame) then
			return false
		end

		if not currentFrame.CanBeAccessedInContext or not currentFrame:CanBeAccessedInContext() then
			return false
		end

		if currentFrame == ancestry then
			return true
		end

		currentFrame = currentFrame:GetParent()
	end

	return false
end

local function DoesAccessibleAncestryIncludeAny(ancestry, frames)
	if not ancestry or not frames then
		return false
	end

	for i = 1, #frames do
		if DoesAccessibleAncestryInclude(ancestry, frames[i]) then
			return true
		end
	end

	return false
end

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

	if DoesAccessibleAncestryIncludeAny(sessionWindow, mouseFoci) then
		return true
	end

	local resizeButton = sessionWindow.GetResizeButton and sessionWindow:GetResizeButton()
	if resizeButton and DoesAccessibleAncestryIncludeAny(resizeButton, mouseFoci) then
		return true
	end

	local scrollBar = sessionWindow.GetScrollBar and sessionWindow:GetScrollBar()
	if scrollBar and DoesAccessibleAncestryIncludeAny(scrollBar, mouseFoci) then
		return true
	end

	return false
end

local function StartSessionWindowMouseOver(sessionWindow)
	if not sessionWindow then
		return
	end

	windowLeavePendingStates[sessionWindow] = nil
	data:ApplyWindowModes(sessionWindow, true)
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
				data:ApplyWindowModes(trackedWindow, IsSessionMouseOver(trackedWindow))
			end
		end
	end)
	visibilityWatcher:SetOnUpdateMode(Enum_OnUpdateMode_RunAlways)
end

function data:GetWindowBackdropTargetAlpha(sessionWindow, isMouseOver)
	local mode = S.db.damageMeter.windowBackdrop
	local frameBackgroundAlpha = sessionWindow.GetBackgroundAlpha and (sessionWindow:GetBackgroundAlpha() or 1) or 1

	if mode == "always" then
		return frameBackgroundAlpha
	elseif mode == "hide" then
		return 0
	end

	return isMouseOver and frameBackgroundAlpha or 0
end

function data:GetScrollBarTargetAlpha(scrollBar)
	if not scrollBar then
		return nil
	end

	local mode = S.db.damageMeter.scrollBar
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

function data:EnforceScrollBarAlpha(scrollBar)
	if not scrollBar or scrollBarAlphaApplyingStates[scrollBar] then
		return
	end

	local targetAlpha = data:GetScrollBarTargetAlpha(scrollBar)
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

function data:ForceHideScrollBar(scrollBar)
	data:EnforceScrollBarAlpha(scrollBar)
	scrollBar:Hide()
	scrollBarHiddenByMode[scrollBar] = true
end

function data:FadeAlpha(frame, targetAlpha)
	if not frame or not frame.SetAlpha then
		return
	end

	local currentAlpha = frame:GetAlpha()
	if currentAlpha == targetAlpha then
		return
	end

	E:UIFrameFadeRemoveFrame(frame)

	local fadeTime = S.db.damageMeter.fadeTime
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

function data:OnBackgroundSetAlpha() -- self is the session window background, not data
	local background = self
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

	local targetAlpha = data:GetWindowBackdropTargetAlpha(sessionWindow, isMouseOver)
	if backdrop:GetAlpha() == targetAlpha then
		return
	end

	backdropAlphaApplyingStates[background] = true
	E:UIFrameFadeRemoveFrame(backdrop)
	backdrop:SetAlpha(targetAlpha)
	backdropAlphaApplyingStates[background] = nil
end

function data:HookBackground(sessionWindow)
	local background = GetSessionBackground(sessionWindow)
	if not background then
		return
	end

	backgroundSessionWindows[background] = sessionWindow

	if not S:IsHooked(background, "SetAlpha") then
		S:SecureHook(background, "SetAlpha", data.OnBackgroundSetAlpha)
	end
end

function data:RefreshBackdropMode(sessionWindow, isMouseOver)
	local background = GetSessionBackground(sessionWindow)
	local backdrop = background and background.backdrop
	if not backdrop then
		return false
	end

	data:FadeAlpha(backdrop, data:GetWindowBackdropTargetAlpha(sessionWindow, isMouseOver))

	return true
end

function data:FadeHeaderButtonVisuals(button, widgetAlpha)
	if not button then
		return
	end

	-- ElvUI replacements (data:HandleTypeDropdown / data:HandleSettingsDropdown)
	if button.customArrow then
		data:FadeAlpha(button.customArrow, widgetAlpha)
	end

	if button.customIcon then
		data:FadeAlpha(button.customIcon, widgetAlpha)
	end

	if button.GetNormalTexture then
		local normalTexture = button:GetNormalTexture()
		if normalTexture then
			data:FadeAlpha(normalTexture, widgetAlpha)
		end
	end

	if button.GetPushedTexture then
		local pushedTexture = button:GetPushedTexture()
		if pushedTexture then
			data:FadeAlpha(pushedTexture, widgetAlpha)
		end
	end

	if button.GetHighlightTexture then
		local highlightTexture = button:GetHighlightTexture()
		if highlightTexture then
			data:FadeAlpha(highlightTexture, widgetAlpha)
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

function data:AnchorTypeDropdown(sessionWindow, showSessionTimer)
	local typeDropdown = sessionWindow.GetDamageMeterTypeDropdown and sessionWindow:GetDamageMeterTypeDropdown()
	if not typeDropdown then
		return
	end

	if showSessionTimer then
		local sessionTimer = sessionWindow.GetSessionTimerFontString and sessionWindow:GetSessionTimerFontString()
		if sessionTimer then
			typeDropdown:Point(
				"TOPLEFT",
				sessionTimer,
				"TOPRIGHT",
				ELVUI_TYPE_DROPDOWN_TIMER_X,
				ELVUI_TYPE_DROPDOWN_TIMER_Y
			)
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

function data:RefreshSessionTimer(sessionWindow, widgetAlpha)
	local sessionTimer = sessionWindow.GetSessionTimerFontString and sessionWindow:GetSessionTimerFontString()
	if not sessionTimer then
		return
	end

	local showSessionTimer = S.db.damageMeter.sessionTimer ~= false
	if showSessionTimer then
		sessionTimer:Show()
		data:FadeAlpha(sessionTimer, widgetAlpha)
	else
		sessionTimer:Hide()
	end

	data:AnchorTypeDropdown(sessionWindow, showSessionTimer)
end

function data:AnchorSettingsDropdown(sessionWindow, attachToMinimizeButton)
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

function data:RefreshMinimizeButton(sessionWindow, widgetAlpha)
	local minimizeButton = sessionWindow.GetMinimizeButton and sessionWindow:GetMinimizeButton()
	if not minimizeButton then
		return
	end

	local showMinimizeButton = S.db.damageMeter.minimizeButton ~= false
	local isMinimized = sessionWindow.IsMinimized and sessionWindow:IsMinimized()
	local attachToMinimizeButton = showMinimizeButton or isMinimized
	if attachToMinimizeButton then
		minimizeButton:Show()
		data:FadeHeaderButtonVisuals(minimizeButton, widgetAlpha)
	else
		minimizeButton:Hide()
	end

	data:AnchorSettingsDropdown(sessionWindow, attachToMinimizeButton)
end

function data:RefreshHeaderMode(sessionWindow, isMouseOver)
	if not sessionWindow then
		return
	end

	local headerPartMode = S.db.damageMeter.headerPart
	local headerBackdropMode = S.db.damageMeter.headerBackdrop
	local widgetAlpha = headerPartMode == "always" and 1 or (isMouseOver and 1 or 0)
	local headerBackdropAlpha = headerBackdropMode == "hide" and 0 or 1

	local header = GetSessionHeader(sessionWindow)
	if header then
		data:FadeAlpha(header, headerBackdropAlpha)
	end

	data:RefreshSessionTimer(sessionWindow, widgetAlpha)

	for i = 1, #headerVisualGetters do
		local element = GetHeaderWidget(sessionWindow, headerVisualGetters[i])
		if element and element.SetAlpha then
			data:FadeAlpha(element, widgetAlpha)
		end
	end

	-- Fade ElvUI/Blizzard textures only. Leave the DropdownButtons and MinimizeButton
	-- at ElvUI's alpha so OnMouseDown_Intrinsic still receives the click.
	if sessionWindow.GetDamageMeterTypeDropdown then
		data:FadeHeaderButtonVisuals(sessionWindow:GetDamageMeterTypeDropdown(), widgetAlpha)
	end

	if sessionWindow.GetSettingsDropdown then
		data:FadeHeaderButtonVisuals(sessionWindow:GetSettingsDropdown(), widgetAlpha)
	end

	data:RefreshMinimizeButton(sessionWindow, widgetAlpha)
end

function data:RefreshScrollBarMode(frame)
	local scrollBar = frame.GetScrollBar and frame:GetScrollBar()
	if not scrollBar then
		return
	end

	local currentAlpha = scrollBar:GetAlpha()
	if currentAlpha > 0 then
		scrollBarBaseAlphas[scrollBar] = currentAlpha
	end

	local mode = S.db.damageMeter.scrollBar
	if mode == "hide" then
		data:ForceHideScrollBar(scrollBar)
		return
	end

	if scrollBarHiddenByMode[scrollBar] then
		scrollBarHiddenByMode[scrollBar] = nil
		scrollBar:Show()
	end

	if mode == "default" then
		return
	end

	data:EnforceScrollBarAlpha(scrollBar)
end

function data:OnScrollBarScriptShow() -- self is the scroll bar, not data
	if S.db.damageMeter.scrollBar == "hide" then
		data:ForceHideScrollBar(self)
		return
	end

	data:EnforceScrollBarAlpha(self)
end

function data:OnScrollBarSetAlpha(alpha) -- self is the scroll bar, not data
	local scrollBar = self
	if scrollBarAlphaApplyingStates[scrollBar] then
		return
	end

	if alpha and alpha > 0 then
		scrollBarBaseAlphas[scrollBar] = alpha
	end

	data:EnforceScrollBarAlpha(scrollBar)
end

function data:OnScrollBarEnter() -- self is the scroll bar, not data
	StartSessionWindowMouseOver(scrollBarSessionWindows[self])
	data:EnforceScrollBarAlpha(self)
end

function data:OnScrollBarLeave() -- self is the scroll bar, not data
	data.OnSessionWindowLeave(scrollBarSessionWindows[self])
	data:EnforceScrollBarAlpha(self)
end

function data:HookScrollBar(frame)
	local scrollBar = frame.GetScrollBar and frame:GetScrollBar()
	if not scrollBar then
		return
	end

	scrollBarSessionWindows[scrollBar] = frame

	if not hookedScrollBars[scrollBar] then
		scrollBar:HookScript("OnEnter", data.OnScrollBarEnter)
		scrollBar:HookScript("OnLeave", data.OnScrollBarLeave)
		scrollBar:HookScript("OnShow", data.OnScrollBarScriptShow)
		hookedScrollBars[scrollBar] = true
	end

	if not S:IsHooked(scrollBar, "SetAlpha") then
		S:SecureHook(scrollBar, "SetAlpha", data.OnScrollBarSetAlpha)
	end
end

function data:ApplyEntryStyle(entry)
	if not entry then
		return
	end

	local barDB = S.db.damageMeter.bar
	local statusBarTexture = entry:GetStatusBarTexture()
	if statusBarTexture then
		statusBarTexture:SetTexture(LSM:Fetch("statusbar", barDB.texture))
		statusBarTexture:SetAlpha(barDB.alpha)
	end

	F.SetFontWithDB(entry:GetName(), barDB.font.name)
	F.SetFontWithDB(entry:GetValue(), barDB.font.value)
end

function data:HandleEntry() -- self is the entry, not data
	data:ApplyEntryStyle(self)
end

function data:HookHeaderWidgetMouseOver(sessionWindow, element)
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
		data.OnSessionWindowLeave(sessionWindow)
	end)
end

function data:HookEntryMouseOver(sessionWindow, entry)
	data:HookHeaderWidgetMouseOver(sessionWindow, entry)
end

function data:HookSessionWindowMouseOver(sessionWindow)
	if not sessionWindow or sessionWindow.__windDamageMeterWindowHooked then
		return
	end

	sessionWindow:HookScript("OnEnter", data.OnSessionWindowEnter)
	sessionWindow:HookScript("OnLeave", data.OnSessionWindowLeave)
	StartVisibilityTracking(sessionWindow)

	sessionWindow.__windDamageMeterWindowHooked = true
end

function data:OnSetupEntry(entry) -- self is the session window, not data
	data:HookEntryMouseOver(self, entry)
end

function data:ScrollBoxUpdate() -- self is the scroll box, not data
	local scrollBox = self
	if not scrollBox or not scrollBox.ForEachFrame then
		return
	end

	scrollBox:ForEachFrame(data.HandleEntry)
end

function data:OnScrollBoxEnter() -- self is the scroll box, not data
	StartSessionWindowMouseOver(scrollBoxSessionWindows[self])
end

function data:OnScrollBoxLeave() -- self is the scroll box, not data
	data.OnSessionWindowLeave(scrollBoxSessionWindows[self])
end

function data:HookScrollBox(frame)
	local scrollBox = frame.GetScrollBox and frame:GetScrollBox()
	if scrollBox then
		scrollBoxSessionWindows[scrollBox] = frame

		if not S:IsHooked(scrollBox, "Update") then
			S:SecureHook(scrollBox, "Update", data.ScrollBoxUpdate)
			data.ScrollBoxUpdate(scrollBox)
		end

		if not hookedScrollBoxes[scrollBox] then
			scrollBox:HookScript("OnEnter", data.OnScrollBoxEnter)
			scrollBox:HookScript("OnLeave", data.OnScrollBoxLeave)
			hookedScrollBoxes[scrollBox] = true
		end
	end

	data:HookScrollBar(frame)
	data:RefreshScrollBarMode(frame)
end

function data:SourceWindowRefresh() -- self is the source window, not data
	if self and self.ForEachEntryFrame then
		self:ForEachEntryFrame(data.HandleEntry)
	end
end

function data:ApplyWindowModes(sessionWindow, isMouseOver, force)
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
	data:RefreshBackdropMode(sessionWindow, isMouseOver)
	data:RefreshHeaderMode(sessionWindow, isMouseOver)
	data:RefreshScrollBarMode(sessionWindow)
end

function data:RefreshAllSessionWindows()
	if not S.db or not S.db.damageMeter or not S.db.damageMeter.enable then
		return
	end

	local damageMeter = _G.DamageMeter
	if not damageMeter or not damageMeter.ForEachSessionWindow then
		return
	end

	damageMeter:ForEachSessionWindow(function(sessionWindow)
		data:ApplyWindowModes(sessionWindow, nil, true)
	end)
end

---Entry point kept on the module for Options
function S:DamageMeter_RefreshAllSessionWindows()
	data:RefreshAllSessionWindows()
end

function data:OnSessionWindowEnter() -- self is the session window, not data
	windowLeavePendingStates[self] = nil
	data:ApplyWindowModes(self, true)
end

function data:OnSessionWindowLeave() -- self is the session window, not data
	local sessionWindow = self
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
			data:ApplyWindowModes(sessionWindow, nil, true)
		end
	end)
end

function data:HookSessionWindowMixin()
	if data.sessionWindowMixinHooked then
		return
	end

	local mixin = _G.DamageMeterSessionWindowMixin
	if not mixin or not mixin.OnEnter then
		return
	end

	hooksecurefunc(mixin, "OnEnter", data.OnSessionWindowEnter)
	if mixin.SetupEntry then
		hooksecurefunc(mixin, "SetupEntry", data.OnSetupEntry)
	end

	data.sessionWindowMixinHooked = true
end

function data:ApplyConfigToSessionWindow(sessionWindow)
	if not sessionWindow then
		return
	end

	data:HookSessionWindowMixin()
	data:HookSessionWindowMouseOver(sessionWindow)
	data:HookBackground(sessionWindow)
	data:HookScrollBox(sessionWindow)

	if sessionWindow.ForEachEntryFrame then
		sessionWindow:ForEachEntryFrame(function(entry)
			data:ApplyEntryStyle(entry)
			data:HookEntryMouseOver(sessionWindow, entry)
		end)
	end

	local localPlayerEntry = sessionWindow.GetLocalPlayerEntry and sessionWindow:GetLocalPlayerEntry()
	if localPlayerEntry then
		data:ApplyEntryStyle(localPlayerEntry)
		data:HookEntryMouseOver(sessionWindow, localPlayerEntry)
	end

	local sourceWindow = GetSessionSourceWindow(sessionWindow)
	if sourceWindow then
		if not S:IsHooked(sourceWindow, "Refresh") then
			S:SecureHook(sourceWindow, "Refresh", data.SourceWindowRefresh)
		end

		if sourceWindow.ForEachEntryFrame then
			sourceWindow:ForEachEntryFrame(data.HandleEntry)
		end
	end

	if sessionWindow.SetMinimized and not S:IsHooked(sessionWindow, "SetMinimized") then
		S:SecureHook(sessionWindow, "SetMinimized", data.OnSetMinimized)
	end

	data:ApplyWindowModes(sessionWindow, IsSessionMouseOver(sessionWindow), true)
end

function data:OnSetMinimized() -- self is the session window, not data
	data:ApplyWindowModes(self, nil, true)
end

function data:DisableShadowMouse(frame)
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

function data:HandleSessionWindow() -- self is the session window, not data
	local sessionWindow = self
	if not sessionWindow then
		return
	end

	if not skinnedSessionWindows[sessionWindow] then
		local background = GetSessionBackground(sessionWindow)
		if background then
			S:CreateBackdropShadow(background)
			data:DisableShadowMouse(background)
		end

		local sourceBackground = GetSourceWindowBackground(GetSessionSourceWindow(sessionWindow))
		if sourceBackground then
			S:CreateBackdropShadow(sourceBackground)
			data:DisableShadowMouse(sourceBackground)
		end

		skinnedSessionWindows[sessionWindow] = true
	end

	data:ApplyConfigToSessionWindow(sessionWindow)
end

function data:SetupSessionWindow() -- self is DamageMeter when hooked, not data
	_G.DamageMeter:ForEachSessionWindow(data.HandleSessionWindow)
end

function S:Blizzard_DamageMeter()
	data:HookSessionWindowMixin()
	self:SecureHook(_G.DamageMeter, "SetupSessionWindow", data.SetupSessionWindow)
	data:SetupSessionWindow()
end
