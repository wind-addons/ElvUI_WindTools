local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local DL = W:NewModule("DamageMeterLayout", "AceEvent-3.0", "AceHook-3.0")
local S = W.Modules.Skins ---@type Skins
local C = W.Utilities.Color

local _G = _G
local format = format
local pairs = pairs
local select = select
local tinsert = tinsert
local tonumber = tonumber
local unpack = unpack
local wipe = wipe

local CreateFrame = CreateFrame
local GetInstanceInfo = GetInstanceInfo
local UnitAffectingCombat = UnitAffectingCombat

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_ChallengeMode_IsChallengeModeActive = C_ChallengeMode.IsChallengeModeActive

local ELVUI_SKIN_VISUAL_LEFT_INSET, ELVUI_SKIN_VISUAL_RIGHT_INSET = 0, 0
local OFFSCREEN_ANCHOR_X, OFFSCREEN_ANCHOR_Y = 100000, -100000

function DL:StoreOriginalState(windowIndex, sessionWindow)
	if self.originalState[windowIndex] then
		return
	end

	local state = { width = sessionWindow:GetWidth(), height = sessionWindow:GetHeight(), points = {} }
	state.clampedToScreen = sessionWindow:IsClampedToScreen()
	for i = 1, sessionWindow:GetNumPoints() do
		local point, relativeTo, relativePoint, xOffset, yOffset = sessionWindow:GetPoint(i)
		if not relativeTo then
			relativeTo = _G.UIParent
		end
		tinsert(state.points, { point, relativeTo, relativePoint, xOffset, yOffset })
	end

	self.originalState[windowIndex] = state
end

function DL:RestoreOriginalState(windowIndex, sessionWindow)
	local state = self.originalState[windowIndex]
	if not state then
		return
	end

	sessionWindow:ClearAllPoints()
	if #state.points > 0 then
		for i = 1, #state.points do
			local pointData = state.points[i]
			sessionWindow:SetPoint(unpack(pointData))
		end
	else
		sessionWindow:Point("CENTER")
	end

	sessionWindow:Size(state.width or sessionWindow:GetWidth(), state.height or sessionWindow:GetHeight())
	sessionWindow:SetClampedToScreen(state.clampedToScreen ~= false)

	self.originalState[windowIndex] = nil
end

function DL:MoveWindowOffscreen(sessionWindow)
	if not sessionWindow then
		return
	end

	sessionWindow:ClearAllPoints()
	sessionWindow:Point("TOPLEFT", _G.UIParent, "TOPLEFT", OFFSCREEN_ANCHOR_X, OFFSCREEN_ANCHOR_Y)
	if not sessionWindow:IsShown() then
		sessionWindow:Show()
	end
end

function DL:TakeoverSessionWindow(windowIndex)
	local sessionWindow = _G["DamageMeterSessionWindow" .. windowIndex]
	if not sessionWindow then
		return nil
	end

	self:StoreOriginalState(windowIndex, sessionWindow)
	sessionWindow:SetClampedToScreen(false)

	self.managedMeters[windowIndex] = sessionWindow

	return sessionWindow
end

function DL:ReleaseSessionWindow(windowIndex)
	local sessionWindow = self.managedMeters[windowIndex] or _G["DamageMeterSessionWindow" .. windowIndex]
	if not sessionWindow then
		self.managedMeters[windowIndex] = nil
		self.originalState[windowIndex] = nil
		return
	end

	self:RestoreOriginalState(windowIndex, sessionWindow)
	self.managedMeters[windowIndex] = nil
end

function DL:ReleaseAllMeters()
	for i = 1, _G.DamageMeter:GetMaxSessionWindowCount() do
		self:ReleaseSessionWindow(i)
	end

	wipe(self.managedMeters)
end

function DL:UpdateContainerStyle()
	if not self.container or not self.db then
		return
	end

	self.container:Size(self.db.width, self.db.height)
	self.container.backdrop:SetShown(self.db.backdrop)
	self.container.backdrop.shadow:SetShown(self.db.shadow)
end

function DL:UpdatePreviewState(layout)
	if not self.previewFrame or not self.previewFrame.Text then
		return
	end

	if self.isPreviewing then
		local displayIndex = self.previewLayoutIndex or self.db.activeLayout or 1
		local displayLayout = layout or self.db.layouts[displayIndex]
		local layoutName = (displayLayout and displayLayout.name) or format(L["Layout %d"], displayIndex)
		self.previewFrame.Text:SetText(format(L["Previewing: %s"], layoutName))
		self.previewFrame:Show()
	else
		self.previewFrame:Hide()
	end
end

function DL:GetLayoutAssignments(layout)
	if not layout or not layout.meters then
		return {}, {}
	end

	local usedWindows = {}
	local assignments = {}
	local visibleAssignments = {}

	for i = 1, #layout.meters do
		local meter = layout.meters[i]
		local windowIndex = meter and tonumber(meter.windowIndex) or nil
		if
			windowIndex
			and windowIndex >= 1
			and windowIndex <= _G.DamageMeter:GetMaxSessionWindowCount()
			and not usedWindows[windowIndex]
		then
			local sessionWindow = _G["DamageMeterSessionWindow" .. windowIndex]
			if sessionWindow then
				local hidden = meter and meter.hidden == true
				usedWindows[windowIndex] = true
				local assignment = {
					windowIndex = windowIndex,
					sessionWindow = sessionWindow,
					hidden = hidden,
					weight = meter.weight,
				}

				tinsert(assignments, assignment)

				if not hidden then
					tinsert(visibleAssignments, assignment)
				end
			end
		end
	end

	if #visibleAssignments == 0 then
		return assignments, visibleAssignments
	end

	local totalWeight = 0
	for i = 1, #visibleAssignments do
		totalWeight = totalWeight + visibleAssignments[i].weight
	end

	if totalWeight <= 0 then
		totalWeight = #visibleAssignments
		for i = 1, #visibleAssignments do
			visibleAssignments[i].weight = 1
		end
	end

	for i = 1, #visibleAssignments do
		visibleAssignments[i].ratio = visibleAssignments[i].weight / totalWeight
	end

	return assignments, visibleAssignments
end

function DL:FadeManagedMeters(duration, targetAlpha, startAlpha)
	for _, sessionWindow in pairs(self.managedMeters) do
		if sessionWindow:IsShown() then
			E:UIFrameFadeRemoveFrame(sessionWindow)
			if startAlpha then
				sessionWindow:SetAlpha(startAlpha)
			end

			local beginAlpha = startAlpha or sessionWindow:GetAlpha()
			local isIncreasing = targetAlpha >= beginAlpha
			if isIncreasing then
				E:UIFrameFadeIn(sessionWindow, duration, beginAlpha, targetAlpha)
			else
				E:UIFrameFadeOut(sessionWindow, duration, beginAlpha, targetAlpha)
			end
		end
	end
end

---@param layoutIndex? number
function DL:UpdateLayoutDirect(layoutIndex)
	if not self.db or not self.container then
		return
	end

	if layoutIndex then
		self.db.activeLayout = layoutIndex
	end

	local activeLayout = self.db.layouts and self.db.layouts[self.db.activeLayout]
	self:UpdatePreviewState(activeLayout)

	if not activeLayout then
		self.appliedLayout = nil
		self.container:SetAlpha(1)
		self.container:Hide()
		return
	end

	self.appliedLayout = self.db.activeLayout

	local assignments, visibleAssignments = self:GetLayoutAssignments(activeLayout)
	local activeWindows = {}

	for i = 1, #assignments do
		local assignment = assignments[i]
		activeWindows[assignment.windowIndex] = true
		if not self.managedMeters[assignment.windowIndex] then
			assignment.sessionWindow = self:TakeoverSessionWindow(assignment.windowIndex)
		else
			assignment.sessionWindow = self.managedMeters[assignment.windowIndex]
		end
	end

	for windowIndex in pairs(self.managedMeters) do
		if not activeWindows[windowIndex] then
			self:ReleaseSessionWindow(windowIndex)
		end
	end

	for i = 1, #assignments do
		local assignment = assignments[i]
		if assignment.hidden and assignment.sessionWindow then
			self:MoveWindowOffscreen(assignment.sessionWindow)
		end
	end

	if #visibleAssignments == 0 then
		self.container:SetAlpha(1)
		self.container:Hide()
		return
	end

	local visualRegionWidth = self.container:GetWidth() - activeLayout.outerPadding * 2
	local visualRegionHeight = self.container:GetHeight() - activeLayout.outerPadding * 2
	local spacingTotal = activeLayout.innerPadding * (#visibleAssignments - 1)
	local isHorizontal = activeLayout.direction == "HORIZONTAL"
	local distributable = isHorizontal and visualRegionWidth - spacingTotal or visualRegionHeight - spacingTotal
	local usedVisual = 0

	for i = 1, #visibleAssignments do
		local assignment = visibleAssignments[i]
		local sessionWindow = assignment.sessionWindow
		if sessionWindow then
			local visual = (i == #visibleAssignments) and (distributable - usedVisual)
				or E:Round(distributable * assignment.ratio)
			local frameStartX, frameStartY, frameWidth, frameHeight

			if isHorizontal then
				local visualStartX = activeLayout.outerPadding + usedVisual + (i - 1) * activeLayout.innerPadding
				frameStartX = visualStartX - ELVUI_SKIN_VISUAL_LEFT_INSET
				frameStartY = -activeLayout.outerPadding
				frameWidth = visual + ELVUI_SKIN_VISUAL_LEFT_INSET + ELVUI_SKIN_VISUAL_RIGHT_INSET
				frameHeight = visualRegionHeight
			else
				local visualStartY = activeLayout.outerPadding + usedVisual + (i - 1) * activeLayout.innerPadding
				frameStartX = activeLayout.outerPadding - ELVUI_SKIN_VISUAL_LEFT_INSET
				frameStartY = -visualStartY
				frameWidth = visualRegionWidth + ELVUI_SKIN_VISUAL_LEFT_INSET + ELVUI_SKIN_VISUAL_RIGHT_INSET
				frameHeight = visual
			end

			sessionWindow:ClearAllPoints()
			sessionWindow:Point("TOPLEFT", self.container, "TOPLEFT", frameStartX, frameStartY)
			sessionWindow:Size(frameWidth, frameHeight)
			if not sessionWindow:IsShown() then
				sessionWindow:Show()
			end

			usedVisual = usedVisual + visual
		end
	end

	if not self.container:IsShown() then
		self.container:SetAlpha(1)
		self.container:Show()
	end
end

---@param layoutIndex? number
function DL:UpdateLayout(layoutIndex)
	if not self.db or not self.container then
		return
	end

	local targetLayout = layoutIndex or self.db.activeLayout

	if layoutIndex then
		self.db.activeLayout = layoutIndex
	end

	if self.isAnimating then
		self.pendingLayoutIndex = targetLayout
		return
	end

	local useAnimation = self.db.animation.enable
		and self.db.animation.duration >= 0.05
		and self.appliedLayout
		and targetLayout ~= self.appliedLayout

	if not useAnimation then
		self:UpdateLayoutDirect(targetLayout)
		return
	end

	self.isAnimating = true
	self.pendingLayoutIndex = nil

	local duration = self.db.animation.duration
	local _, currentVisible = self:GetLayoutAssignments(self.db.layouts[self.appliedLayout])
	local _, targetVisible = self:GetLayoutAssignments(self.db.layouts[targetLayout])
	local containerVisibilityChanges = (#currentVisible > 0) ~= (#targetVisible > 0)

	if containerVisibilityChanges then
		E:UIFrameFadeRemoveFrame(self.container)
		E:UIFrameFadeOut(self.container, duration, self.container:GetAlpha(), 0)
	end

	self:FadeManagedMeters(duration, 0)

	E:Delay(duration, function()
		self.isAnimating = nil

		local resolvedLayout = self.pendingLayoutIndex or targetLayout
		self.pendingLayoutIndex = nil

		self:UpdateLayoutDirect(resolvedLayout)

		if containerVisibilityChanges and self.container:IsShown() then
			E:UIFrameFadeRemoveFrame(self.container)
			self.container:SetAlpha(0)
			E:UIFrameFadeIn(self.container, duration, 0, 1)
		end

		self:FadeManagedMeters(duration, 1, 0)
	end)
end

function DL:AutoSwitch(force)
	if self.isPreviewing then
		return
	end

	local targetLayout = self.db.activeLayout

	if self.db.autoSwitch and self.db.autoSwitch.enable then
		local rules = self.db.autoSwitch.rules or {}
		local instanceType, difficulty = select(2, GetInstanceInfo())
		local isInDelve = difficulty == 208
		local isInCombat = UnitAffectingCombat("player")
		local isInChallengeMode = C_ChallengeMode_IsChallengeModeActive()

		targetLayout = instanceType == "raid" and rules.raid
			or isInDelve and rules.delve
			or isInChallengeMode and rules.mythicPlus
			or isInCombat and rules.combat
			or not isInCombat and rules.outOfCombat
			or targetLayout
	end

	if force or targetLayout ~= self.db.activeLayout then
		self:UpdateLayout(targetLayout)
	end
end

function DL:Preview(layoutIndex)
	if not self.db or not self.db.enable then
		return
	end

	self.isPreviewing = true
	self.previewLayoutIndex = tonumber(layoutIndex) or tonumber(self.db.activeLayout)
	self:UpdateLayout(self.previewLayoutIndex)
end

function DL:IsPreviewing()
	return self.isPreviewing == true
end

function DL:StopPreview()
	if not self.isPreviewing then
		return
	end

	self.isPreviewing = false
	self.previewLayoutIndex = nil

	if self.db and self.db.autoSwitch and self.db.autoSwitch.enable then
		self:AutoSwitch(true)
	else
		self:UpdateLayout()
	end
end

function DL:HookDamageMeter()
	if not self:IsHooked(_G.DamageMeter, "SetupSessionWindow") then
		self:SecureHook(_G.DamageMeter, "SetupSessionWindow", function()
			F.TaskManager:OutOfCombat(self.UpdateLayout, self)
		end)
	end
end

function DL:CreateContainer()
	if self.container then
		return
	end

	local MainFrame = CreateFrame("Frame", "WTDamageMeterLayout", E.UIParent, "BackdropTemplate")
	MainFrame:SetClampedToScreen(false)
	MainFrame:EnableMouse(false)
	MainFrame:SetFrameStrata("LOW")
	MainFrame:Point("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -20, 20)
	MainFrame:Size(600, 200)
	MainFrame:CreateBackdrop("Transparent")
	S:CreateShadow(MainFrame.backdrop, nil, nil, nil, nil, true)

	MainFrame:Hide()

	E:CreateMover(
		MainFrame,
		"WTDamageMeterLayoutMover",
		format("%s - %s", W.Title, L["Damage Meter Layout"]),
		nil,
		nil,
		nil,
		"ALL,WINDTOOLS",
		function()
			return E.db.WT.combat.damageMeterLayout.enable
		end,
		"WindTools,combat,damageMeterLayout"
	)

	self.container = MainFrame

	local PreviewFrame = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
	PreviewFrame:EnableMouse(false)
	PreviewFrame:SetFrameStrata("DIALOG")
	PreviewFrame:SetFrameLevel(MainFrame:GetFrameLevel() + 20)
	PreviewFrame:Point("TOPLEFT", MainFrame, "TOPLEFT", -4, 4)
	PreviewFrame:Point("BOTTOMRIGHT", MainFrame, "BOTTOMRIGHT", 4, -4)
	PreviewFrame:SetTemplate("Default")
	S:CreateShadow(PreviewFrame)
	S:BindShadowColorWithBorder(PreviewFrame)
	PreviewFrame:SetBackdropColor(0, 0, 0, 0)
	PreviewFrame:SetBackdropBorderColor(C.ExtractRGBFromTemplate("rose-500"))

	PreviewFrame.Text = PreviewFrame:CreateFontString(nil, "OVERLAY")
	F.SetFont(PreviewFrame.Text, E.media.normFont, 14, "OUTLINE")
	PreviewFrame.Text:SetTextColor(C.ExtractRGBFromTemplate("rose-500"))
	PreviewFrame.Text:Point("BOTTOM", PreviewFrame, "TOP", 0, 6)

	PreviewFrame:Hide()

	self.previewFrame = PreviewFrame
end

function DL:Disable()
	self:StopPreview()
	self.isAnimating = nil
	self.pendingLayoutIndex = nil
	self.appliedLayout = nil
	self:ReleaseAllMeters()

	if self.container then
		E:UIFrameFadeRemoveFrame(self.container)
		self.container:SetAlpha(1)
		self.container:Hide()
	end

	if self.previewFrame then
		self.previewFrame:Hide()
	end

	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	self:UnregisterEvent("ADDON_LOADED")
end

function DL:Enable()
	if not self.db or not self.db.enable then
		return
	end

	self:CreateContainer()
	self:UpdateContainerStyle()

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "ForceSwitch")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "AutoSwitch")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "AutoSwitch")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "AutoSwitch")

	if not C_AddOns_IsAddOnLoaded("Blizzard_DamageMeter") then
		self:RegisterEvent("ADDON_LOADED")
	else
		self:HookDamageMeter()
	end

	if self.isPreviewing then
		self:UpdateLayout(self.previewLayoutIndex or self.db.activeLayout)
	else
		self:ForceSwitch()
	end
end

function DL:ForceSwitch()
	self:AutoSwitch(true)
end

function DL:ADDON_LOADED(_, addonName)
	if addonName ~= "Blizzard_DamageMeter" then
		return
	end

	self:UnregisterEvent("ADDON_LOADED")
	self:HookDamageMeter()
	self:ForceSwitch()
end

function DL:Initialize()
	if E.private.skins.blizzard.enable and E.private.skins.blizzard.damageMeter then
		ELVUI_SKIN_VISUAL_LEFT_INSET = 13
		ELVUI_SKIN_VISUAL_RIGHT_INSET = 18
	end

	self.db = E.db.WT.combat.damageMeterLayout
	self.originalState = self.originalState or {}
	self.managedMeters = self.managedMeters or {}

	self:Enable()
end

function DL:ProfileUpdate()
	self.db = E.db.WT.combat.damageMeterLayout

	if self.db.enable then
		self:Enable()
	else
		self:Disable()
	end
end

W:RegisterModule(DL:GetName())
