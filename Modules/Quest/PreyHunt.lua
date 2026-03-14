local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local PH = W:NewModule("PreyHunt", "AceHook-3.0", "AceEvent-3.0") ---@class PreyHunt: AceModule, AceHook-3.0, AceEvent-3.0

local _G = _G
local format = format
local pairs = pairs

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local PROGRESS_UI_WIDGET_TYPE = Enum.UIWidgetVisualizationType.PreyHuntProgress

function PH:HandleWidget(container, widgetID, widgetType)
	if widgetType and widgetType ~= PROGRESS_UI_WIDGET_TYPE then
		return
	end

	local frame = container.widgetFrames[widgetID]
	if not frame or not frame.widgetType or frame.widgetType ~= PROGRESS_UI_WIDGET_TYPE then
		return
	end

	if not frame.StageText then
		frame.StageText = frame:CreateFontString(nil, "OVERLAY")
		frame.StageText:SetJustifyH("CENTER")
		F.InternalizeMethod(frame.StageText, "SetAlpha", true)
	end

	frame:SetShown(not self.db.enable or not self.db.progressWidget.hide)

	if self.db.enable and self.db.progressWidget.stageText.enable then
		F.SetFontWithDB(frame.StageText, self.db.progressWidget.stageText)
		frame.StageText:ClearAllPoints()
		frame.StageText:Point(
			"BOTTOM",
			frame,
			"TOP",
			self.db.progressWidget.stageText.xOffset,
			self.db.progressWidget.stageText.yOffset
		)
		local prefix = self.db.progressWidget.stageText.label and L["Stage"] .. ": " or ""
		local template = prefix .. self.db.progressWidget.stageText.template
		frame.StageText:SetText(format(template, frame.progressState or 0))
		frame.StageText:Show()
	else
		frame.StageText:Hide()
	end
end

function PH:RefreshPreyHuntStage()
	for _, frame in pairs(_G.UIWidgetPowerBarContainerFrame.widgetFrames) do
		if frame and frame.widgetType and frame.widgetType == PROGRESS_UI_WIDGET_TYPE then
			self:HandleWidget(_G.UIWidgetPowerBarContainerFrame, frame.widgetID, frame.widgetType)
		end
	end
end

function PH:ADDON_LOADED(_, addonName)
	if addonName ~= "Blizzard_UIWidgets" then
		return
	end
	self:UnregisterEvent("ADDON_LOADED")

	self:HookWidgets()
end

function PH:HookWidgets()
	if not self:IsHooked(_G.UIWidgetPowerBarContainerFrame, "ProcessWidget") then
		self:SecureHook(_G.UIWidgetPowerBarContainerFrame, "ProcessWidget", "HandleWidget")
	end
end

function PH:ProfileUpdate()
	self.db = E.db.WT.quest.preyHunt

	if not self.db.enable then
		if self.initialized then
			self:RefreshPreyHuntStage()
		end
		return
	end

	if not self.initialized then
		if C_AddOns_IsAddOnLoaded("Blizzard_UIWidgets") then
			self:HookWidgets()
		else
			self:RegisterEvent("ADDON_LOADED")
		end

		self.initialized = true
	end

	self:RefreshPreyHuntStage()
end

PH.Initialize = PH.ProfileUpdate

W:RegisterModule(PH:GetName())
