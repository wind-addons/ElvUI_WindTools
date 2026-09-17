local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local PH = W:NewModule("PreyHunt", "AceHook-3.0", "AceEvent-3.0") ---@class PreyHunt: AceModule, AceHook-3.0, AceEvent-3.0
local C = W.Utilities.Color

local _G = _G
local format = format
local ipairs = ipairs
local math_huge = math.huge
local pairs = pairs
local table_concat = table.concat
local tonumber = tonumber
local tostring = tostring

local AccumulateOp = AccumulateOp
local GetTime = GetTime

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_QuestLog_AddQuestWatch = C_QuestLog.AddQuestWatch
local C_QuestLog_AddWorldQuestWatch = C_QuestLog.AddWorldQuestWatch
local C_QuestLog_GetActivePreyQuest = C_QuestLog.GetActivePreyQuest
local C_QuestLog_GetDistanceSqToQuest = C_QuestLog.GetDistanceSqToQuest
local C_QuestLog_GetNextWaypointForMap = C_QuestLog.GetNextWaypointForMap
local C_QuestLog_GetQuestTagInfo = C_QuestLog.GetQuestTagInfo
local C_QuestLog_GetQuestsOnMap = C_QuestLog.GetQuestsOnMap
local C_QuestLog_GetTitleForQuestID = C_QuestLog.GetTitleForQuestID
local C_QuestLog_IsOnMap = C_QuestLog.IsOnMap
local C_QuestLog_IsWorldQuest = C_QuestLog.IsWorldQuest
local C_SuperTrack_GetSuperTrackedQuestID = C_SuperTrack.GetSuperTrackedQuestID
local C_SuperTrack_SetSuperTrackedQuestID = C_SuperTrack.SetSuperTrackedQuestID
local C_TaskQuest_GetQuestsOnMap = C_TaskQuest.GetQuestsOnMap
local C_VignetteInfo_GetVignetteInfo = C_VignetteInfo.GetVignetteInfo
local C_VignetteInfo_GetVignettes = C_VignetteInfo.GetVignettes
local Enum_QuestWatchType_Automatic = Enum.QuestWatchType.Automatic

local PREY_UI_WIDGET_TYPE = Enum.UIWidgetVisualizationType.PreyHuntProgress
local PREY_WORLD_QUEST_TYPE = Enum.QuestTagType.Prey
local AUTO_TRACK_THROTTLE = 2

local VIGNETTE_DATA = {
	[7667] = { atlas = "Vehicle-Trap-Gold", name = L["Trap"] },
	[7443] = { atlas = "poi-prey", name = L["Anguish"] },
}

local function NotifyStartTracking(questID)
	local title = tostring(C_QuestLog_GetTitleForQuestID(questID) or questID)
	title = C.StringByTemplate(title, "indigo-300")
	local tag = C.StringByTemplate(format("[%s]", L["Prey Hunt"]), "amber-500")
	F.Print(format("%s %s", tag, format(L["Start tracking %s."], title)))
end

local function QuestHasMapIcon(questID, mapID)
	local x, y = C_QuestLog_GetNextWaypointForMap(questID, mapID)
	if x and y then
		return true
	end

	local quests = C_QuestLog_GetQuestsOnMap(mapID)
	if quests then
		for _, info in ipairs(quests) do
			if info.questID == questID then
				return true
			end
		end
	end

	return false
end

function PH:HandleWidget(container, widgetID, widgetType)
	if widgetType and widgetType ~= PREY_UI_WIDGET_TYPE then
		return
	end

	local frame = container.widgetFrames[widgetID]
	if not frame or not frame.widgetType or frame.widgetType ~= PREY_UI_WIDGET_TYPE then
		return
	end

	if not frame.StageText then
		frame.StageText = frame:CreateFontString(nil, "OVERLAY")
		frame.StageText:SetJustifyH("CENTER")
		F.InternalizeMethod(frame.StageText, "SetAlpha", true)
	end

	if not frame.VignetteText then
		frame.VignetteText = frame:CreateFontString(nil, "OVERLAY")
		frame.VignetteText:SetJustifyH("CENTER")
		F.InternalizeMethod(frame.VignetteText, "SetAlpha", true)
	end

	frame:SetShown(not self.db.enable or not self.db.progressWidget.hide)

	if self.db.enable then
		if self.db.progressWidget.stageText.enable then
			F.SetFontWithDB(frame.StageText, self.db.progressWidget.stageText)
			F.SetFontColorWithDB(frame.StageText, self.db.progressWidget.stageText.color)
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
			frame.StageText:SetText(format(template, tonumber(frame.progressState or 1) + 1))
			frame.StageText:Show()
		else
			frame.StageText:Hide()
		end

		if self.db.progressWidget.vignetteText.enable then
			F.SetFontWithDB(frame.VignetteText, self.db.progressWidget.vignetteText)
			frame.VignetteText:ClearAllPoints()
			frame.VignetteText:Point(
				"BOTTOM",
				frame.StageText,
				"TOP",
				self.db.progressWidget.vignetteText.xOffset,
				self.db.progressWidget.vignetteText.yOffset + 3
			)
			self:RefreshVignetteText()
			frame.VignetteText:Show()
			self:RegisterVignetteEvent()
		else
			frame.VignetteText:Hide()
			self:UnregisterVignetteEvent()
		end
	else
		frame.StageText:Hide()
		frame.VignetteText:Hide()
		self:UnregisterVignetteEvent()
	end
end

function PH:GetVignetteData()
	return VIGNETTE_DATA
end

function PH:RefreshVignetteText()
	local ids = C_VignetteInfo_GetVignettes()
	local vignetteCounts = {}
	local hasAny = false

	if ids then
		for vignetteID, data in pairs(VIGNETTE_DATA) do
			if self.db.progressWidget.vignetteText.ids[vignetteID] then
				local count = AccumulateOp(ids, function(id)
					local info = C_VignetteInfo_GetVignetteInfo(id)
					return (info and info.vignetteID == vignetteID) and 1 or 0
				end)
				if count > 0 then
					vignetteCounts[#vignetteCounts + 1] = format("|A:%s:14:14|a x %d", data.atlas, count)
					hasAny = true
				end
			end
		end
	end

	for _, frame in pairs(_G.UIWidgetPowerBarContainerFrame.widgetFrames) do
		if frame and frame.widgetType and frame.widgetType == PREY_UI_WIDGET_TYPE and frame.VignetteText then
			if hasAny then
				frame.VignetteText:SetText(
					C.StringByTemplate(format(L["%s nearby"], table_concat(vignetteCounts, ", ")), "orange-500")
				)
				frame.VignetteText:Show()
			else
				frame.VignetteText:Hide()
			end
		end
	end
end

function PH:VIGNETTE_MINIMAP_UPDATED()
	if not self.db or not self.db.enable or not self.db.progressWidget.vignetteText.enable then
		return
	end

	self:RefreshVignetteText()
end

function PH:RegisterVignetteEvent()
	if not self.vignetteEventsRegistered then
		self:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
		self.vignetteEventsRegistered = true
	end
end

function PH:UnregisterVignetteEvent()
	if self.vignetteEventsRegistered then
		self:UnregisterEvent("VIGNETTE_MINIMAP_UPDATED")
		self.vignetteEventsRegistered = false
	end
end

function PH:RefreshPreyHuntStage()
	for _, frame in pairs(_G.UIWidgetPowerBarContainerFrame.widgetFrames) do
		if frame and frame.widgetType and frame.widgetType == PREY_UI_WIDGET_TYPE then
			self:HandleWidget(_G.UIWidgetPowerBarContainerFrame, frame.widgetID, frame.widgetType)
		end
	end
end

function PH:TryAutoTrack()
	local db = self.db
	if not db or not db.enable then
		return
	end

	local autoTrack = db.autoTrack
	if not autoTrack.enable or (not autoTrack.worldQuest and not autoTrack.stageQuest) then
		return
	end

	local activePreyQuestID = C_QuestLog_GetActivePreyQuest()
	if not activePreyQuestID or activePreyQuestID == 0 then
		return
	end

	local now = GetTime()
	if self.lastAutoTrackTime and (now - self.lastAutoTrackTime) < AUTO_TRACK_THROTTLE then
		return
	end
	self.lastAutoTrackTime = now

	local mapID = C_Map_GetBestMapForUnit("player")
	if not mapID then
		return
	end

	local superTrackedID = C_SuperTrack_GetSuperTrackedQuestID()
	local bestQuestID
	local bestDistSq = math_huge

	if autoTrack.worldQuest then
		local tasks = C_TaskQuest_GetQuestsOnMap(mapID)
		if tasks then
			for _, info in ipairs(tasks) do
				if C_QuestLog_IsWorldQuest(info.questID) then
					local tagInfo = C_QuestLog_GetQuestTagInfo(info.questID)
					if tagInfo and tagInfo.worldQuestType == PREY_WORLD_QUEST_TYPE then
						local distSq = C_QuestLog_GetDistanceSqToQuest(info.questID)
						if distSq and distSq < bestDistSq then
							bestDistSq = distSq
							bestQuestID = info.questID
						end
					end
				end
			end
		end
	end

	if bestQuestID then
		C_QuestLog_AddWorldQuestWatch(bestQuestID, Enum_QuestWatchType_Automatic)

		if superTrackedID ~= bestQuestID then
			C_SuperTrack_SetSuperTrackedQuestID(bestQuestID)
			if autoTrack.notify then
				NotifyStartTracking(bestQuestID)
			end
		end
		return
	end

	if autoTrack.stageQuest and C_QuestLog_IsOnMap(activePreyQuestID) and QuestHasMapIcon(activePreyQuestID, mapID) then
		C_QuestLog_AddQuestWatch(activePreyQuestID)

		if superTrackedID ~= activePreyQuestID then
			C_SuperTrack_SetSuperTrackedQuestID(activePreyQuestID)
			if autoTrack.notify then
				NotifyStartTracking(activePreyQuestID)
			end
		end
	end
end

function PH:UpdateAutoTrackEvents()
	local shouldRegister = self.db
		and self.db.enable
		and self.db.autoTrack.enable
		and (self.db.autoTrack.worldQuest or self.db.autoTrack.stageQuest)

	if shouldRegister then
		if not self.autoTrackEventsRegistered then
			self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "TryAutoTrack")
			self:RegisterEvent("QUEST_LOG_UPDATE", "TryAutoTrack")
			self.autoTrackEventsRegistered = true
		end
	else
		if self.autoTrackEventsRegistered then
			self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
			self:UnregisterEvent("QUEST_LOG_UPDATE")
			self.autoTrackEventsRegistered = false
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

	self:UpdateAutoTrackEvents()

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
