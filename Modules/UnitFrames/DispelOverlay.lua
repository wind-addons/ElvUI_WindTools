local W, _, E = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI
local DispelOverlay = W:NewModule("DispelOverlay", "AceHook-3.0") ---@class DispelOverlay: AceModule, AceHook-3.0
local UF = E.UnitFrames

local hooksecurefunc = hooksecurefunc
local next = next
local type = type

local CreateFrame = CreateFrame

local PULSE_FROM_ALPHA = 0.5
local PULSE_TO_ALPHA = 1
local PULSE_DURATION = 0.5
local BORDER_SPEED = 1.25
local BORDER_THICKNESS = 3
local FILL_ALPHA = 0.2
local FILTER_STRING = "HARMFUL|DISPELLABLE"
local ALL_CANDIDATE_FILTERS = {}
local DISPEL_SLOT_KEY = "dispel"
local SUPPORTED_UNITS = {
	party = true,
	raid1 = true,
	raid2 = true,
	raid3 = true,
}
local BORDER_TEMPLATE = "WT_DispelAnimatedBorderTemplate"

local function DisableMouse(region)
	region:EnableMouse(false)
	region:SetMouseClickEnabled(false)
	region:SetMouseMotionEnabled(false)
end

local function CreateFillTexture(parent)
	local fillTexture = parent:CreateTexture(nil, "ARTWORK", nil, -6)
	fillTexture:SetAllPoints()
	fillTexture:SetAtlas("RaidFrame-Dispel-Fill")
	fillTexture:SetAlpha(FILL_ALPHA)
	parent.fillTexture = fillTexture
	return fillTexture
end

local function CreatePulseAnimation(region)
	local pulseAnimation = region:CreateAnimationGroup()
	local alphaAnimation = pulseAnimation:CreateAnimation("Alpha")
	alphaAnimation:SetFromAlpha(PULSE_FROM_ALPHA)
	alphaAnimation:SetToAlpha(PULSE_TO_ALPHA)
	alphaAnimation:SetDuration(PULSE_DURATION)
	pulseAnimation:SetLooping("BOUNCE")
	region.pulseAnimation = pulseAnimation
	return pulseAnimation
end

function DispelOverlay:CanLoad()
	local dispelStyle = Enum.CustomAuraButtonDispelTypeTextureStyle
	return E.Retail
		and type(MarchingAnts_CreateForTarget) == "function"
		and dispelStyle
		and dispelStyle.PreserveAsset ~= nil
end

function DispelOverlay:IsUnitEnabled(unitframeType)
	local database = self.db
	if not database or not database.enable or not SUPPORTED_UNITS[unitframeType] then
		return false
	end

	local unitConfig = database[unitframeType]
	return unitConfig and unitConfig.enable
end

function DispelOverlay:ColorFromDispel(color)
	if not color then
		return nil
	end

	if color.GetRGBA then
		return color
	end

	return CreateColor(color.r or 1, color.g or 1, color.b or 1, color.a or 1)
end

function DispelOverlay:GetBlackColorCurve()
	if self.blackColorCurve then
		return self.blackColorCurve
	end

	local curveType = Enum.LuaCurveType and Enum.LuaCurveType.Step
	local curve = E:CreateColorCurve(curveType)
	local black = CreateColor(0, 0, 0, 1)
	local dispelIndexes = E.oUF.Enum.DispelType
	for _, dispelIndex in next, dispelIndexes do
		curve:AddPoint(dispelIndex, black)
	end

	self.blackColorCurve = curve
	return curve
end

function DispelOverlay:GetDispelTextureOptions()
	local textureOptions = {
		style = Enum.CustomAuraButtonDispelTypeTextureStyle.PreserveAsset,
		showWhenHarmful = true,
		showWhenHelpful = false,
	}

	if self.db.color == "black" then
		textureOptions.customDispelColorCurve = self:GetBlackColorCurve()
	end

	return textureOptions
end

function DispelOverlay:GetHealthBackdrop(frame)
	local health = frame and frame.Health
	if not health then
		return nil
	end

	return health.backdrop or health
end

function DispelOverlay:GetBorderParent(frame)
	return (frame and frame.RaisedElementParent) or frame
end

function DispelOverlay:PrepareBorder(border)
	if not border or border.wtPrepared then
		return
	end

	-- IsVisible is secret under the aura button, so the mixin check cannot run.
	border.CheckResumePlaying = function(animatedBorder)
		if (animatedBorder.animSpeed or 1) > 0 then
			animatedBorder:Play()
		end
	end

	border.wtPrepared = true
end

function DispelOverlay:CreateBorder(parent, parentKey)
	local border = MarchingAnts_CreateForTarget(parent, BORDER_TEMPLATE, 0, 0, parentKey)
	border:SetClipsChildren(false)
	DisableMouse(border)
	self:PrepareBorder(border)
	border:SetupAssets()
	border:SetLineThickness(BORDER_THICKNESS, BORDER_THICKNESS)
	return border
end

function DispelOverlay:AnchorBorder(frame, border)
	local backdrop = self:GetHealthBackdrop(frame)
	local borderParent = self:GetBorderParent(frame)
	if not border or not backdrop or not borderParent or not border.AnchorAroundTarget then
		return
	end

	border:AnchorAroundTarget(backdrop, 0, 0)

	local castLevel = borderParent.CastBarLevel or borderParent:GetFrameLevel()
	border:SetFrameLevel(castLevel + 10)
end

function DispelOverlay:AnchorToBackdrop(region, frame)
	local backdrop = self:GetHealthBackdrop(frame)
	if not region or not backdrop then
		return
	end

	region:ClearAllPoints()
	region:SetAllPoints(backdrop)
end

function DispelOverlay:RegisterDispelTextures(auraButton, overlay)
	local fillTexture = overlay and overlay.fillTexture
	if not fillTexture or not auraButton.AddDispelTypeTexture then
		return
	end

	if auraButton.ClearDispelTypeTextures then
		auraButton:ClearDispelTypeTextures()
	end

	local textureOptions = self:GetDispelTextureOptions()
	auraButton:AddDispelTypeTexture(fillTexture, textureOptions)

	local border = overlay.border
	if not border then
		return
	end

	auraButton:AddDispelTypeTexture(border.Top, textureOptions)
	auraButton:AddDispelTypeTexture(border.Bottom, textureOptions)
	auraButton:AddDispelTypeTexture(border.Left, textureOptions)
	auraButton:AddDispelTypeTexture(border.Right, textureOptions)
end

function DispelOverlay:GetPreviewBorder(frame)
	if frame.WTDispelPreviewBorder then
		return frame.WTDispelPreviewBorder
	end

	local borderParent = self:GetBorderParent(frame)
	if not borderParent then
		return nil
	end

	local border = self:CreateBorder(borderParent, "WTDispelPreviewBorder")
	border:Hide()
	frame.WTDispelPreviewBorder = border
	return border
end

function DispelOverlay:ShowPreviewBorder(frame, borderColor)
	if not frame or not self.db or not self.db.enable then
		return
	end

	if self.db.animatedBorder == false then
		self:HidePreviewBorder(frame)
		return
	end

	local border = self:GetPreviewBorder(frame)
	if not border then
		return
	end

	self:AnchorBorder(frame, border)
	if borderColor then
		border:SetColor(borderColor)
	end
	border:Show()
	border:SetSpeed(BORDER_SPEED)
end

function DispelOverlay:CreateOverlayBorder(overlay)
	if overlay.border then
		return overlay.border
	end

	local border = self:CreateBorder(overlay, "WTDispelBorder")
	border:SetFrameStrata("HIGH")
	border:SetFrameLevel((overlay:GetFrameLevel() or 0) + 20)
	overlay.border = border
	return border
end

function DispelOverlay:ApplyOverlayBorder(frame)
	local overlay = frame and frame.WTDispelOverlayFrame
	local border = overlay and overlay.border
	if not border then
		return
	end

	if not self.db or not self.db.enable or self.db.animatedBorder == false then
		border:Hide()
		return
	end

	border:SetAlpha(self.testMode and 0 or 1)
	border:Show()
	border:SetSpeed(BORDER_SPEED)
end

function DispelOverlay:HidePreviewBorder(frame)
	local border = frame and frame.WTDispelPreviewBorder
	if border then
		border:Hide()
	end
end

function DispelOverlay:ResumeFlashing(overlay)
	local pulseAnimation = overlay.pulseAnimation
	if not pulseAnimation or not self.db or not self.db.enable then
		return
	end

	if not self.db.flashing then
		pulseAnimation:Stop()
		overlay:SetAlpha(1)
		return
	end

	pulseAnimation:Play()
end

function DispelOverlay:ApplyOverlayOptions(frame)
	local overlay = frame.WTDispelOverlayFrame
	if not overlay then
		return
	end

	self:AnchorToBackdrop(overlay, frame)

	local auraButton = overlay:GetParent()
	self:AnchorToBackdrop(auraButton, frame)
	self:ApplyOverlayBorder(frame)
	if auraButton and auraButton.AddDispelTypeTexture then
		self:RegisterDispelTextures(auraButton, overlay)
	end

	self:ResumeFlashing(overlay)
end

function DispelOverlay:BuildOverlay(frame, auraButton)
	if auraButton.wtDispelOverlay then
		frame.WTDispelOverlayFrame = auraButton.wtDispelOverlay
		self:ApplyOverlayOptions(frame)
		return
	end

	DisableMouse(auraButton)
	auraButton:SetClipsChildren(false)

	local overlay = CreateFrame("Frame", nil, auraButton)
	DisableMouse(overlay)
	overlay:SetClipsChildren(false)
	local healthLevel = frame.Health:GetFrameLevel()
	overlay:SetFrameLevel(healthLevel + 30)
	CreateFillTexture(overlay)

	auraButton.wtDispelOverlay = overlay
	frame.WTDispelOverlayFrame = overlay

	self:CreateOverlayBorder(overlay)
	CreatePulseAnimation(overlay)

	overlay:SetScript("OnShow", function(shownOverlay)
		DispelOverlay:ResumeFlashing(shownOverlay)
	end)

	self:ApplyOverlayOptions(frame)
	overlay:Show()
	auraButton:Hide()
end

function DispelOverlay:RaiseContainer(frame, container)
	local healthLevel = frame.Health:GetFrameLevel()
	container:SetFrameLevel(healthLevel + 20)
end

function DispelOverlay:GetContainer(frame)
	local container = frame.WTDispelOverlay
	if container then
		container.wtUnitFrame = frame
		container:SetClipsChildren(false)
		self:AnchorToBackdrop(container, frame)
		self:RaiseContainer(frame, container)
		return container
	end

	container = E:Auras_Create(frame, "DispelOverlay")
	DisableMouse(container)
	container:SetClipsChildren(false)
	self:AnchorToBackdrop(container, frame)
	container.wtUnitFrame = frame
	self:RaiseContainer(frame, container)

	hooksecurefunc(container, "Show", function(shownContainer)
		if not shownContainer.wtNeedsSlot then
			return
		end

		local owner = shownContainer.wtUnitFrame
		if owner then
			DispelOverlay:UpdateAuraSlot(shownContainer, owner)
		end
	end)

	frame.WTDispelOverlay = container
	self.activeContainers[frame] = container
	return container
end

function DispelOverlay:GetCandidateFilters(container)
	if self.db.display == "mine" then
		local candidateFilters = E:Auras_FilterSlot(container)
		E:Auras_CleanCandidates(container, candidateFilters)
		return container.candidates
	end

	return ALL_CANDIDATE_FILTERS
end

function DispelOverlay:UpdateAuraSlot(container, frame)
	if not container:IsShown() then
		container.wtNeedsSlot = true
		return
	end

	container.wtNeedsSlot = nil

	local candidateFilters = self:GetCandidateFilters(container)

	if container.known[DISPEL_SLOT_KEY] then
		container:SetAuraSlotCandidateFilters(DISPEL_SLOT_KEY, candidateFilters)
		return
	end

	container:AddAuraSlot(DISPEL_SLOT_KEY, FILTER_STRING, {
		initializeFrame = function(auraButton)
			self:BuildOverlay(frame, auraButton)
		end,
		candidateFilters = candidateFilters,
	})
	container.known[DISPEL_SLOT_KEY] = true
end

function DispelOverlay:GetTestColor()
	if self.db and self.db.color == "black" then
		return CreateColor(0, 0, 0, 1)
	end

	local debuffColors = E.Libs.Dispel:GetDebuffTypeColor()
	return self:ColorFromDispel(debuffColors and debuffColors.Magic) or CreateColor(0.2, 0.6, 1, 1)
end

function DispelOverlay:VisitHeaderChildren(header, callback)
	if not header or not header.GetNumChildren then
		return
	end

	for _, child in next, { header:GetChildren() } do
		if child.Health then
			callback(child)
		elseif child.GetNumChildren then
			for _, unitFrame in next, { child:GetChildren() } do
				if unitFrame.Health then
					callback(unitFrame)
				end
			end
		end
	end
end

function DispelOverlay:VisitGroupFrames(callback)
	for unitframeType in next, SUPPORTED_UNITS do
		self:VisitHeaderChildren(UF[unitframeType], callback)
	end
end

function DispelOverlay:GetTestPreview(frame)
	local preview = frame.WTDispelOverlayPreview
	if preview then
		return preview
	end

	local borderParent = self:GetBorderParent(frame)
	if not borderParent then
		return nil
	end

	preview = CreateFrame("Frame", nil, borderParent)
	DisableMouse(preview)
	preview:SetClipsChildren(false)
	CreateFillTexture(preview)
	CreatePulseAnimation(preview)

	preview:Hide()
	frame.WTDispelOverlayPreview = preview
	return preview
end

function DispelOverlay:ApplyTestPreview(frame)
	local preview = self:GetTestPreview(frame)
	if not preview then
		return
	end

	self:AnchorToBackdrop(preview, frame)

	local borderParent = self:GetBorderParent(frame)
	local castLevel = borderParent and (borderParent.CastBarLevel or borderParent:GetFrameLevel()) or frame:GetFrameLevel()
	preview:SetFrameLevel(castLevel + 5)

	local color = self:GetTestColor()
	local red, green, blue = color:GetRGB()
	preview.fillTexture:SetVertexColor(red, green, blue)
	preview.fillTexture:SetAlpha(FILL_ALPHA)

	self:ShowPreviewBorder(frame, color)

	if self.db and self.db.flashing then
		preview.pulseAnimation:Play()
	else
		preview.pulseAnimation:Stop()
		preview:SetAlpha(1)
	end

	preview:Show()
end

function DispelOverlay:HideTestPreview(frame)
	local preview = frame.WTDispelOverlayPreview
	if not preview then
		return
	end

	if preview.pulseAnimation then
		preview.pulseAnimation:Stop()
	end
	preview:SetAlpha(1)
	preview:Hide()
	self:HidePreviewBorder(frame)
	self:ApplyOverlayBorder(frame)
end

function DispelOverlay:UpdateTestMode()
	local showTest = self.testMode and self.db and self.db.enable
	self:VisitGroupFrames(function(frame)
		if showTest and self:IsUnitEnabled(frame.unitframeType) and frame:IsShown() then
			self:ApplyTestPreview(frame)
		else
			self:HideTestPreview(frame)
		end
	end)
end

function DispelOverlay:SetTestMode(enabled)
	self.testMode = enabled and true or false
	if self.testMode and not self.initialized then
		self:Initialize()
	end
	self:UpdateTestMode()
end

function DispelOverlay:ConfigureUnitFrame(_, frame)
	if not self.db or not frame or not frame.Health then
		return
	end

	local unitframeType = frame.unitframeType
	local container = frame.WTDispelOverlay
	if not self:IsUnitEnabled(unitframeType) then
		if container then
			container.allowEnable = false
			if frame.__unit then
				E:Auras_GroupUnit(container, frame.__unit)
			end
		end
		self:HideTestPreview(frame)
		self:HidePreviewBorder(frame)
		return
	end

	container = self:GetContainer(frame)
	container.allowEnable = true
	container.unitframeType = unitframeType
	self:UpdateAuraSlot(container, frame)
	self:ApplyOverlayOptions(frame)

	if frame.__unit then
		E:Auras_GroupUnit(container, frame.__unit)
	end

	if self.testMode and frame:IsShown() then
		self:ApplyTestPreview(frame)
	else
		self:HideTestPreview(frame)
		self:HidePreviewBorder(frame)
		self:ApplyOverlayBorder(frame)
	end
end

function DispelOverlay:ToggleContainer(_, frame, unit, shown)
	local container = frame and frame.WTDispelOverlay
	if not container or not self:IsUnitEnabled(frame.unitframeType) then
		return
	end

	E:Auras_ToggleActive(container, unit, shown)
end

function DispelOverlay:UpdateContainerUnit(_, frame, unit)
	local container = frame and frame.WTDispelOverlay
	if not container or not self:IsUnitEnabled(frame.unitframeType) then
		return
	end

	E:Auras_GroupUnit(container, unit)
end

function DispelOverlay:DispelListUpdated()
	if not self.db or not self.db.enable then
		return
	end

	for frame, container in next, self.activeContainers do
		if container.known and container.known[DISPEL_SLOT_KEY] and self:IsUnitEnabled(frame.unitframeType) then
			self:UpdateAuraSlot(container, frame)
		end
	end
end

function DispelOverlay:DisableOverlays()
	for frame, container in next, self.activeContainers do
		container.allowEnable = false
		if frame.__unit then
			E:Auras_GroupUnit(container, frame.__unit)
		end

		local overlay = frame.WTDispelOverlayFrame
		if overlay then
			if overlay.pulseAnimation then
				overlay.pulseAnimation:Stop()
			end
			overlay:SetAlpha(1)
			if overlay.border then
				overlay.border:Hide()
			end
		end

		self:HidePreviewBorder(frame)
	end
end

function DispelOverlay:Initialize()
	if not self:CanLoad() then
		return
	end

	self.db = E.db.WT.unitFrames.dispelOverlay
	if not self.db or not self.db.enable or self.initialized then
		return
	end

	self.activeContainers = self.activeContainers or {}

	self:SecureHook(UF, "ConfigureFrame", "ConfigureUnitFrame")
	self:SecureHook(UF, "Auras_ToggleContainer", "ToggleContainer")
	self:SecureHook(UF, "Configure_UnitAuras", "UpdateContainerUnit")
	self:SecureHook(E, "Auras_DispelUpdated", "DispelListUpdated")

	self.initialized = true
	UF:Update_AllFrames()
end

function DispelOverlay:ProfileUpdate()
	if not self:CanLoad() then
		return
	end

	self.db = E.db.WT.unitFrames.dispelOverlay
	if self.db and self.db.enable then
		if not self.initialized then
			self:Initialize()
		else
			UF:Update_AllFrames()
		end
	elseif self.initialized then
		self.testMode = false
		self:UpdateTestMode()
		self:UnhookAll()
		self.initialized = false
		self:DisableOverlays()
	end
end

W:RegisterModule(DispelOverlay:GetName())
