local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local MF = W.Modules.MoveFrames ---@type MoveFrames
local C = W.Utilities.Color
local ET = W:NewModule("EventTracker", "NumyAceEvent-3.0", "AceHook-3.0") ---@class EventTracker : AceModule, NumyAceEvent-3.0, AceHook-3.0

local _G = _G
local ceil = ceil
local date = date
local floor = floor
local format = format
local ipairs = ipairs
local next = next
local pairs = pairs
local type = type
local unpack = unpack
local wipe = wipe

local CreateFrame = CreateFrame
local EventRegistry = EventRegistry
local GetServerTime = GetServerTime
local UiMapPoint_CreateFromCoordinates = UiMapPoint.CreateFromCoordinates

local C_AreaPoiInfo_GetAreaPOIInfo = C_AreaPoiInfo.GetAreaPOIInfo
local C_Map_CanSetUserWaypointOnMap = C_Map.CanSetUserWaypointOnMap
local C_Map_OpenWorldMap = C_Map.OpenWorldMap
local C_Map_SetUserWaypoint = C_Map.SetUserWaypoint
local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local C_EventScheduler_GetOngoingEvents = C_EventScheduler.GetOngoingEvents
local C_EventScheduler_GetScheduledEvents = C_EventScheduler.GetScheduledEvents
local C_EventScheduler_GetEventUiMapID = C_EventScheduler.GetEventUiMapID
local C_EventScheduler_GetEventZoneName = C_EventScheduler.GetEventZoneName
local C_EventScheduler_HasData = C_EventScheduler.HasData
local C_EventScheduler_RequestEvents = C_EventScheduler.RequestEvents
local C_SuperTrack_SetSuperTrackedUserWaypoint = C_SuperTrack.SetSuperTrackedUserWaypoint
local C_Timer_NewTicker = C_Timer.NewTicker

local LeftButtonIcon = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t"
local CURSED_SURGE_MAP_ID = 2512
local cursedSurgeActiveEvent = {}
local cursedSurgeNextEvent = {}
local cursedSurgeNameCache = {}

ET.schedulerGeneration = 0
ET.scheduledEventsCache = nil
ET.ongoingEventsCache = nil

function ET:RefreshSchedulerCache()
	if not C_EventScheduler_HasData() then
		self.scheduledEventsCache = nil
		self.ongoingEventsCache = nil
		C_EventScheduler_RequestEvents()
		return false
	end

	self.scheduledEventsCache = C_EventScheduler_GetScheduledEvents()
	self.ongoingEventsCache = C_EventScheduler_GetOngoingEvents()
	self.schedulerGeneration = self.schedulerGeneration + 1
	return true
end

local function SecondToTime(second)
	local hour = floor(second / 3600)
	local min = floor((second - hour * 3600) / 60)
	local sec = floor(second - hour * 3600 - min * 60)

	if hour == 0 then
		return format("%02d:%02d", min, sec)
	else
		return format("%02d:%02d:%02d", hour, min, sec)
	end
end

local function ReskinStatusBar(bar)
	bar:SetFrameLevel(bar:GetFrameLevel() + 1)
	bar:StripTextures()
	bar:CreateBackdrop("Transparent")
	bar:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(bar)
end

---Resolve Area POI info. Scheduler POIs use a nil map ID first (WoWUI EventScheduler).
---@param areaPoiID number
---@param uiMapID? number
---@return table?
function ET:GetAreaPOIInfo(areaPoiID, uiMapID)
	if not areaPoiID then
		return
	end

	return C_AreaPoiInfo_GetAreaPOIInfo(uiMapID, areaPoiID)
		or (uiMapID and C_AreaPoiInfo_GetAreaPOIInfo(nil, areaPoiID))
end

local function GetCursedSurgeName(_, eventInfo)
	local areaPoiID = eventInfo and eventInfo.areaPoiID
	if not areaPoiID then
		return L["Cursed Surges"]
	end

	local cachedName = cursedSurgeNameCache[areaPoiID]
	if cachedName then
		return cachedName
	end

	local poiInfo = ET:GetAreaPOIInfo(areaPoiID)
	local eventName = (poiInfo and poiInfo.name) or C_EventScheduler_GetEventZoneName(areaPoiID) or L["Cursed Surges"]
	cursedSurgeNameCache[areaPoiID] = eventName
	return eventName
end

local function GetCursedSurgePosition(args, eventInfo)
	local areaPoiID = eventInfo and eventInfo.areaPoiID
	-- Cursed Surges use fixed locations on Coiled Isle. The live POI position
	-- is not reliable for upcoming events, so keep the static coordinates as
	-- the source of truth for waypoints.
	return args.eventCoordinates and args.eventCoordinates[areaPoiID]
end

local function FillCursedSurgeEvent(eventTable, areaPoiID, startTime, endTime, args)
	eventTable.areaPoiID = areaPoiID
	eventTable.startTime = startTime
	eventTable.endTime = endTime
	eventTable.position = GetCursedSurgePosition(args, eventTable)
	return eventTable
end

local function GetCursedSurgeEvents(args, now)
	local hasActiveEvent = false
	local hasNextEvent = false

	local scheduledEvents = ET.scheduledEventsCache
	if type(scheduledEvents) == "table" then
		for _, eventInfo in ipairs(scheduledEvents) do
			local areaPoiID = eventInfo and eventInfo.areaPoiID
			local startTime = eventInfo and eventInfo.startTime
			local endTime = eventInfo and eventInfo.endTime
			if areaPoiID and args.eventAreaPoiIDs[areaPoiID] and startTime then
				if startTime <= now and endTime then
					local eventEndTime = endTime
					local durationEndTime = startTime + args.duration
					if eventEndTime > durationEndTime then
						eventEndTime = durationEndTime
					end

					if now < eventEndTime then
						if not hasActiveEvent or startTime > cursedSurgeActiveEvent.startTime then
							FillCursedSurgeEvent(cursedSurgeActiveEvent, areaPoiID, startTime, eventEndTime, args)
							hasActiveEvent = true
						end
					end
				end

				if startTime > now and not hasNextEvent then
					FillCursedSurgeEvent(cursedSurgeNextEvent, areaPoiID, startTime, nil, args)
					hasNextEvent = true
				end
			end
		end
	end

	if not hasActiveEvent then
		local ongoingEvents = ET.ongoingEventsCache
		if type(ongoingEvents) == "table" then
			for _, eventInfo in ipairs(ongoingEvents) do
				local areaPoiID = eventInfo and eventInfo.areaPoiID
				if areaPoiID and args.eventAreaPoiIDs[areaPoiID] then
					FillCursedSurgeEvent(cursedSurgeActiveEvent, areaPoiID, now, now + args.duration, args)
					hasActiveEvent = true
					break
				end
			end
		end
	end

	return hasActiveEvent and cursedSurgeActiveEvent or nil, hasNextEvent and cursedSurgeNextEvent or nil
end

function ET:SetCursedSurgeWaypoint(args)
	local eventInfo = args.currentEvent or args.nextEvent
	local position = eventInfo and (eventInfo.position or args.eventCoordinates[eventInfo.areaPoiID])

	if not position then
		return
	end

	local mapID = eventInfo.areaPoiID and C_EventScheduler_GetEventUiMapID(eventInfo.areaPoiID) or CURSED_SURGE_MAP_ID
	if not mapID then
		mapID = CURSED_SURGE_MAP_ID
	end

	C_Map_OpenWorldMap(mapID)

	if C_Map_CanSetUserWaypointOnMap(mapID) then
		C_Map_SetUserWaypoint(UiMapPoint_CreateFromCoordinates(mapID, position[1], position[2]))
		E:Delay(0.1, C_SuperTrack_SetSuperTrackedUserWaypoint, true)
	end
end

local function ClearScheduledLoopState(self)
	self.isRunning = false
	self.isCompleted = false
	self.timeLeft = 0
	self.timeOver = 0
	self.nextEventIndex = nil
	self.nextEventTimestamp = nil
	self.cachedEventPoiID = nil
	self.cachedEventStartTime = nil
	self.args.currentLocation = nil
	self.args.nextLocation = nil
	self.args.currentEvent = nil
	self.args.nextEvent = nil
end

local function UpdateScheduledLoopTimer(self)
	local args = self.args
	local now = GetServerTime()

	if not ET.scheduledEventsCache and not ET.ongoingEventsCache then
		if not ET:RefreshSchedulerCache() then
			ClearScheduledLoopState(self)
			return
		end
	end

	local activeEvent, nextEvent = GetCursedSurgeEvents(args, now)
	if activeEvent then
		self.isRunning = true
		self.isCompleted = false
		self.timeLeft = activeEvent.endTime - now
		self.timeOver = args.duration - self.timeLeft
		self.nextEventTimestamp = nextEvent and nextEvent.startTime
		args.currentEvent = activeEvent
		args.nextEvent = nextEvent
		if self.cachedEventPoiID ~= activeEvent.areaPoiID or self.cachedEventStartTime ~= activeEvent.startTime then
			self.cachedEventPoiID = activeEvent.areaPoiID
			self.cachedEventStartTime = activeEvent.startTime
			self.nextEventIndex = format("%s:%s", activeEvent.areaPoiID, activeEvent.startTime)
			args.currentLocation = GetCursedSurgeName(args, activeEvent)
			args.nextLocation = nextEvent and GetCursedSurgeName(args, nextEvent)
		end
	elseif nextEvent then
		self.isRunning = false
		self.isCompleted = false
		self.timeLeft = nextEvent.startTime - now
		self.timeOver = 0
		self.nextEventTimestamp = nextEvent.startTime
		args.currentEvent = nil
		args.nextEvent = nextEvent
		if self.cachedEventPoiID ~= nextEvent.areaPoiID or self.cachedEventStartTime ~= nextEvent.startTime then
			self.cachedEventPoiID = nextEvent.areaPoiID
			self.cachedEventStartTime = nextEvent.startTime
			self.nextEventIndex = format("%s:%s", nextEvent.areaPoiID, nextEvent.startTime)
			args.currentLocation = nil
			args.nextLocation = GetCursedSurgeName(args, nextEvent)
		end
	else
		ClearScheduledLoopState(self)
	end
end

local function IsQuestIDCompleted(questID)
	if type(questID) == "table" then
		for _, id in ipairs(questID) do
			if C_QuestLog_IsQuestFlaggedCompleted(id) then
				return true
			end
		end
		return false
	end

	return C_QuestLog_IsQuestFlaggedCompleted(questID)
end

local function AreAllQuestProgressCompleted(questProgress)
	if not questProgress then
		return false
	end

	for _, data in ipairs(questProgress) do
		if not data.questID or not IsQuestIDCompleted(data.questID) then
			return false
		end
	end

	return true
end

local function AreAllStorylinesCompleted(questIDs)
	local completedStorylines, totalStorylines = 0, 0

	for _, storylineQuests in pairs(questIDs) do
		totalStorylines = totalStorylines + 1
		for _, questID in pairs(storylineQuests) do
			if C_QuestLog_IsQuestFlaggedCompleted(questID) then
				completedStorylines = completedStorylines + 1
				break
			end
		end
	end

	return completedStorylines == totalStorylines
end

local function CountCompletedQuestIDs(questIDs)
	local completed = 0
	for _, questID in pairs(questIDs) do
		if C_QuestLog_IsQuestFlaggedCompleted(questID) then
			completed = completed + 1
		end
	end
	return completed
end

local function ResolveQuestProgress(args)
	local questProgress = args.questProgress
	if type(questProgress) == "function" then
		questProgress = questProgress(args)
	end
	return questProgress
end

local function AddLocationTooltipLines(args)
	for _, locationContext in ipairs({
		{ L["Location"], args.location },
		{ L["Current Location"], args.currentLocation },
		{ L["Next Location"], args.nextLocation },
	}) do
		local left, right = unpack(locationContext)
		if right then
			right = type(right) == "function" and right(args) or right
			_G.GameTooltip:AddDoubleLine(left, right, 1, 1, 1)
		end
	end
end

local function AddQuestProgressTooltipLines(questProgress, useRightText)
	if not questProgress then
		return
	end

	_G.GameTooltip:AddLine(" ")
	_G.GameTooltip:AddLine(L["Quest Progress"])
	for _, data in ipairs(questProgress) do
		if useRightText or data.questID then
			local isCompleted = data.isCompleted
			if not isCompleted and data.questID then
				isCompleted = IsQuestIDCompleted(data.questID)
			end

			local color = isCompleted and "green-500" or "rose-500"
			local leftText = type(data.label) == "function" and data:label() or data.label
			local rightText = useRightText
					and (data.rightText or C.StringByTemplate(
						isCompleted and L["Completed"] or L["Not Completed"],
						color
					))
				or C.StringByTemplate(isCompleted and L["Completed"] or L["Not Completed"], color)

			if type(leftText) == "string" then
				_G.GameTooltip:AddDoubleLine(leftText, rightText, 1, 1, 1)
			end
		end
	end
end

local function AddWeeklyRewardTooltipLine(isCompleted)
	if isCompleted then
		_G.GameTooltip:AddDoubleLine(L["Weekly Reward"], C.StringByTemplate(L["Completed"], "green-500"), 1, 1, 1)
	else
		_G.GameTooltip:AddDoubleLine(L["Weekly Reward"], C.StringByTemplate(L["Not Completed"], "rose-500"), 1, 1, 1)
	end
end

local function AddClickHelpTooltipLine(helpText)
	if helpText then
		_G.GameTooltip:AddLine(" ")
		_G.GameTooltip:AddLine(LeftButtonIcon .. " " .. helpText, 1, 1, 1)
	end
end

local function IsTrackerAlertEnabled(frame)
	return frame:IsShown()
		and ET.db
		and ET.db.enable
		and frame.dbKey
		and ET.db[frame.dbKey]
		and ET.db[frame.dbKey].enable
end

local function PruneAlertCache(alertCache, currentEventIndex)
	if not alertCache then
		return
	end

	local alreadyAlerted = currentEventIndex and alertCache[currentEventIndex]
	wipe(alertCache)
	if alreadyAlerted then
		alertCache[currentEventIndex] = true
	end
end

local FunctionFactory = {
	weekly = {
		init = function(self)
			self.icon = self:CreateTexture(nil, "ARTWORK")
			self.icon:CreateBackdrop("Transparent")
			self.icon.backdrop:SetOutside(self.icon, 1, 1)
			self.name = self:CreateFontString(nil, "OVERLAY")
			self.completed = self:CreateTexture(nil, "ARTWORK")
			self.completed:SetTexture(W.Media.Textures.ROLES)

			self:SetScript("OnMouseDown", function()
				if self.args.onClick then
					self.args:onClick()
				end
			end)
		end,
		setup = function(self)
			self.icon:SetTexture(self.args.icon)
			self.icon:SetTexCoords()
			self.icon:Size(22)
			self.icon:ClearAllPoints()
			self.icon:Point("LEFT", self, "LEFT", 0, 0)

			ET:SetFont(self.name, 13)
			self.name:ClearAllPoints()
			self.name:Point("LEFT", self, "LEFT", 30, 0)
			self.name:SetText(self.args.label)

			self.completed:ClearAllPoints()
			self.completed:Size(16)
			self.completed:Point("RIGHT", self, "RIGHT", 0, 0)
			self.completed:SetTexCoord(F.GetRoleTexCoord("PENDING"))
		end,
		ticker = {
			interval = 2,
			dateUpdater = function(self)
				if self.args.questProgress and not self.args.questIDs then
					self.isCompleted = AreAllQuestProgressCompleted(ResolveQuestProgress(self.args))
					return
				end

				if not self.args.questIDs then
					return
				end

				local questIDs = type(self.args.questIDs) == "function" and self.args:questIDs() or self.args.questIDs

				if not questIDs or type(questIDs) ~= "table" then
					return
				end

				if type(next(questIDs)) ~= "number" then
					self.isCompleted = AreAllStorylinesCompleted(questIDs)
					return
				end

				local completed = CountCompletedQuestIDs(questIDs)
				if self.args.checkAllCompleted then
					completed = completed - #questIDs + 1
				end

				self.isCompleted = completed > 0
			end,
			uiUpdater = function(self)
				self.icon:SetDesaturated(self.args.desaturate and self.isCompleted)
				local texCoord = self.isCompleted and { F.GetRoleTexCoord("READY") } or { F.GetRoleTexCoord("REFUSE") }
				self.completed:SetTexCoord(unpack(texCoord))
				self.completed:SetDesaturated(self.isCompleted)
			end,
			alert = E.noop,
		},
		tooltip = {
			onEnter = function(self)
				_G.GameTooltip:ClearLines()
				_G.GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 8)
				_G.GameTooltip:SetText(F.GetIconString(self.args.icon, 16, 16) .. " " .. self.args.eventName, 1, 1, 1)

				_G.GameTooltip:AddLine(" ")
				AddLocationTooltipLines(self.args)

				if self.args.questProgress then
					AddQuestProgressTooltipLines(ResolveQuestProgress(self.args), true)
				end

				if self.args.hasWeeklyReward then
					AddWeeklyRewardTooltipLine(self.isCompleted)
				end

				AddClickHelpTooltipLine(self.args.onClickHelpText)
				_G.GameTooltip:Show()
			end,
			onLeave = function()
				_G.GameTooltip:Hide()
			end,
		},
	},
	loopTimer = {
		init = function(self)
			self.icon = self:CreateTexture(nil, "ARTWORK")
			self.icon:CreateBackdrop("Transparent")
			self.icon.backdrop:SetOutside(self.icon, 1, 1)
			self.statusBar = CreateFrame("StatusBar", nil, self)
			self.name = self.statusBar:CreateFontString(nil, "OVERLAY")
			self.timerText = self.statusBar:CreateFontString(nil, "OVERLAY")
			self.runningTip = self.statusBar:CreateFontString(nil, "OVERLAY")

			ReskinStatusBar(self.statusBar)

			self.statusBar.spark = self.statusBar:CreateTexture(nil, "ARTWORK", nil, 1)
			self.statusBar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
			self.statusBar.spark:SetBlendMode("ADD")
			self.statusBar.spark:Point("CENTER", self.statusBar:GetStatusBarTexture(), "RIGHT", 0, 0)
			self.statusBar.spark:Size(4, 26)

			self:SetScript("OnMouseDown", function()
				if self.args.onClick then
					self.args:onClick()
				end
			end)
		end,
		setup = function(self)
			self.icon:SetTexture(self.args.icon)
			self.icon:SetTexCoords()
			self.icon:Size(22)
			self.icon:ClearAllPoints()
			self.icon:Point("LEFT", self, "LEFT", 0, 0)

			self.statusBar:ClearAllPoints()
			self.statusBar:Point("TOPLEFT", self, "LEFT", 26, 2)
			self.statusBar:Point("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 6)

			ET:SetFont(self.timerText, 13)
			self.timerText:ClearAllPoints()
			self.timerText:Point("TOPRIGHT", self, "TOPRIGHT", -2, -6)

			ET:SetFont(self.name, 13)
			self.name:ClearAllPoints()
			self.name:Point("TOPLEFT", self, "TOPLEFT", 30, -6)
			self.name:SetText(self.args.label)

			ET:SetFont(self.runningTip, 10)
			self.runningTip:SetText(self.args.runningText)
			self.runningTip:Point("CENTER", self.statusBar, "BOTTOM", 0, 0)
		end,
		ticker = {
			interval = 0.3,
			dateUpdater = function(self)
				if self.args.scheduler then
					UpdateScheduledLoopTimer(self)
					return
				end

				local completed = 0
				if self.args.questIDs and type(self.args.questIDs) == "table" then
					completed = CountCompletedQuestIDs(self.args.questIDs)
					if self.args.checkAllCompleted then
						completed = completed - #self.args.questIDs + 1
					end
				end
				self.isCompleted = completed > 0

				local timeSinceStart = GetServerTime() - self.args.startTimestamp
				self.timeOver = timeSinceStart % self.args.interval
				self.nextEventIndex = floor(timeSinceStart / self.args.interval) + 1
				self.nextEventTimestamp = self.args.startTimestamp + self.args.interval * self.nextEventIndex

				if self.timeOver < self.args.duration then
					self.timeLeft = self.args.duration - self.timeOver
					self.isRunning = true
				else
					self.timeLeft = self.args.interval - self.timeOver
					self.isRunning = false
				end
			end,
			uiUpdater = function(self)
				self.icon:SetDesaturated(self.args.desaturate and self.isCompleted)

				if self.isRunning then
					self.timerText:SetText(C.StringByTemplate(SecondToTime(self.timeLeft), "green-500"))
					self.statusBar:SetMinMaxValues(0, self.args.duration)
					self.statusBar:SetValue(self.timeOver)

					local palette = self.args.runningBarColor or ET.ColorPalette.running
					self.statusBar:GetStatusBarTexture():SetGradient(
						"HORIZONTAL",
						C.CreateColorFromTemplate(palette[1]),
						C.CreateColorFromTemplate(palette[2])
					)
					if self.args.runningTextUpdater then
						self.runningTip:SetText(self.args:runningTextUpdater())
					end
					self.runningTip:Show()
					if self.args.flash and not self.runningTipFlashing then
						E:Flash(self.runningTip, 1, true)
						self.runningTipFlashing = true
					end
				else
					self.timerText:SetText(SecondToTime(self.timeLeft))
					self.statusBar:SetMinMaxValues(0, self.args.interval)
					self.statusBar:SetValue(self.timeLeft)

					local palette = self.args.barColor or ET.ColorPalette.gray ---@type [ColorTemplate, ColorTemplate]
					self.statusBar:GetStatusBarTexture():SetGradient(
						"HORIZONTAL",
						C.CreateColorFromTemplate(palette[1]),
						C.CreateColorFromTemplate(palette[2])
					)

					if self.args.flash and self.runningTipFlashing then
						E:StopFlash(self.runningTip)
						self.runningTipFlashing = false
					end
					self.runningTip:Hide()
				end
			end,
			alert = function(self)
				if not ET.playerEnteredWorld or not IsTrackerAlertEnabled(self) then
					return
				end

				if self.args.scheduler and not self.nextEventIndex then
					return
				end

				if not self.args.alertCache then
					self.args.alertCache = {}
				end

				if self.alertCacheEventIndex ~= self.nextEventIndex then
					PruneAlertCache(self.args.alertCache, self.nextEventIndex)
					self.alertCacheEventIndex = self.nextEventIndex
				end

				if self.args.alertCache[self.nextEventIndex] then
					return
				end

				if not self.args.alertSecond or self.isRunning then
					return
				end

				if self.args.stopAlertIfCompleted and self.isCompleted then
					return
				end

				if self.args.filter and not self.args:filter() then
					return
				end

				if self.timeLeft <= self.args.alertSecond then
					self.args.alertCache[self.nextEventIndex] = true
					local eventIconString = F.GetIconString(self.args.icon, 16, 16)
					local eventName = C.StringByTemplate(self.args.eventName, "yellow-500")
					local remainTime = C.StringByTemplate(SecondToTime(self.timeLeft), "emerald-500")
					F.Print(format(L["%s will be started in %s!"], eventIconString .. " " .. eventName, remainTime))

					if self.args.soundFile then
						F.PlayLSMSound(self.args.soundFile)
					end
				end
			end,
		},
		tooltip = {
			onEnter = function(self)
				_G.GameTooltip:ClearLines()
				_G.GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 8)
				_G.GameTooltip:SetText(F.GetIconString(self.args.icon, 16, 16) .. " " .. self.args.eventName, 1, 1, 1)

				_G.GameTooltip:AddLine(" ")
				AddLocationTooltipLines(self.args)

				_G.GameTooltip:AddLine(" ")
				_G.GameTooltip:AddDoubleLine(L["Interval"], SecondToTime(self.args.interval), 1, 1, 1)
				_G.GameTooltip:AddDoubleLine(L["Duration"], SecondToTime(self.args.duration), 1, 1, 1)
				if self.nextEventTimestamp then
					_G.GameTooltip:AddDoubleLine(
						L["Next Event"],
						date("%m/%d %H:%M:%S", self.nextEventTimestamp),
						1,
						1,
						1
					)
				end

				_G.GameTooltip:AddLine(" ")
				if self.isRunning then
					_G.GameTooltip:AddDoubleLine(
						L["Status"],
						C.StringByTemplate(self.args.runningText, "green-500"),
						1,
						1,
						1
					)
				else
					_G.GameTooltip:AddDoubleLine(L["Status"], C.StringByTemplate(L["Waiting"], "gray-400"), 1, 1, 1)
				end

				if self.args.questProgress then
					AddQuestProgressTooltipLines(ResolveQuestProgress(self.args), false)
				end

				if self.args.hasWeeklyReward then
					AddWeeklyRewardTooltipLine(self.isCompleted)
				end

				AddClickHelpTooltipLine(self.args.onClickHelpText)
				_G.GameTooltip:Show()
			end,
			onLeave = function()
				_G.GameTooltip:Hide()
			end,
		},
	},
}

local Trackers = {
	pool = {},
}

function Trackers:CancelTicker(frame)
	if frame and frame.tickerInstance then
		frame.tickerInstance:Cancel()
		frame.tickerInstance = nil
	end
end

function Trackers:CancelAllTickers()
	for _, frame in pairs(self.pool) do
		self:CancelTicker(frame)
		if frame.args and frame.args.alertCache then
			wipe(frame.args.alertCache)
		end
	end
end

function Trackers:StartTicker(frame)
	if not frame or not frame.tickFunc or not frame.tickerInterval or frame.tickerInstance then
		return
	end

	frame.tickerInstance = C_Timer_NewTicker(frame.tickerInterval, frame.tickFunc)
end

function Trackers:RefreshSchedulerTrackers()
	for _, frame in pairs(self.pool) do
		if frame.args and frame.args.scheduler and frame.tickFunc and frame:IsShown() then
			frame.tickFunc()
		end
	end
end

--- Get or create a tracker frame
---@param event EventKey The key of the event defined in EventData
---@return Frame The tracker frame
function Trackers:Acquire(event)
	local frame = self.pool[event]
	if frame then
		frame:Show()
		if not frame.tickerInstance then
			self:StartTicker(frame)
		end
		return frame
	end

	local data = ET.EventData[event]

	frame = CreateFrame("Frame", "WTEventTracker" .. event, ET.frame)
	frame:Size(220, 30)

	frame.dbKey = data.dbKey
	frame.args = data.args

	if FunctionFactory[data.args.type] then
		local functions = FunctionFactory[data.args.type]

		if functions.init then
			functions.init(frame)
		end

		if functions.setup then
			functions.setup(frame)
			frame.profileUpdate = function()
				functions.setup(frame)
			end
		end

		if functions.ticker then
			frame.tickerInterval = functions.ticker.interval
			frame.tickFunc = function()
				if not (ET and ET.db and ET.db.enable) then
					return
				end
				functions.ticker.dateUpdater(frame)
				if IsTrackerAlertEnabled(frame) then
					functions.ticker.alert(frame)
				end
				if _G.WorldMapFrame:IsShown() and frame:IsShown() then
					functions.ticker.uiUpdater(frame)
				end
			end
			self:StartTicker(frame)
		end

		if functions.tooltip then
			frame:SetScript("OnEnter", function()
				functions.tooltip.onEnter(frame)
			end)

			frame:SetScript("OnLeave", function()
				functions.tooltip.onLeave()
			end)
		end
	end

	self.pool[event] = frame

	return frame
end

---Disable a tracker frame
---@param event EventKey The key of the event defined in EventData
function Trackers:Disable(event)
	local frame = self.pool[event]
	if not frame then
		return
	end

	self:CancelTicker(frame)
	if frame.args and frame.args.alertCache then
		wipe(frame.args.alertCache)
	end
	frame:Hide()
end

function ET:SetFont(target, size)
	if not target or not size then
		return
	end

	if not self.db or not self.db.font then
		return
	end

	F.SetFontWithDB(target, {
		name = self.db.font.name,
		size = floor(size * self.db.font.scale),
		style = self.db.font.outline,
	})
end

function ET:ConstructFrame()
	if not _G.WorldMapFrame or self.frame then
		return
	end

	local frame = CreateFrame("Frame", "WTEventTracker", _G.WorldMapFrame)

	frame:Height(30)
	frame:SetFrameStrata("MEDIUM")

	MF:InternalHandle(frame, _G.WorldMapFrame)

	self.frame = frame
end

function ET:PLAYER_ENTERING_WORLD()
	E:Delay(10, function()
		ET.playerEnteredWorld = true
	end)
end

function ET:EVENT_SCHEDULER_UPDATE()
	if not self:RefreshSchedulerCache() then
		return
	end

	Trackers:RefreshSchedulerTrackers()
end

function ET:OnWorldMapSizeChanged()
	E:Delay(0.1, self.UpdateTrackers, self)
end

function ET:UpdateTrackers()
	self:ConstructFrame()
	if not self.frame then
		return
	end

	self.frame:ClearAllPoints()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.worldmap) then
		self.frame:Point("TOPLEFT", _G.WorldMapFrame, "BOTTOMLEFT", -2, -self.db.style.backdropYOffset)
		self.frame:Point("TOPRIGHT", _G.WorldMapFrame, "BOTTOMRIGHT", 2, -self.db.style.backdropYOffset)

		if self.db.style.backdrop then
			if not self.frame.backdrop then
				self.frame.backdrop = CreateFrame("Frame", nil, self.frame, "TooltipBackdropTemplate")
				self.frame.backdrop:SetAllPoints(self.frame)
			end
			self.frame.backdrop:Show()
		else
			if self.frame.backdrop then
				self.frame.backdrop:Hide()
			end
		end
	else
		self.frame:Point("TOPLEFT", _G.WorldMapFrame.backdrop, "BOTTOMLEFT", 1, -self.db.style.backdropYOffset)
		self.frame:Point("TOPRIGHT", _G.WorldMapFrame.backdrop, "BOTTOMRIGHT", -1, -self.db.style.backdropYOffset)

		if self.db.style.backdrop then
			if not self.frame.backdrop then
				self.frame:CreateBackdrop("Transparent")
				S:CreateShadowModule(self.frame.backdrop)
			end
			self.frame.backdrop:Show()
		else
			if self.frame.backdrop then
				self.frame.backdrop:Hide()
			end
		end
	end

	local maxWidth = ceil(self.frame:GetWidth()) - self.db.style.backdropSpacing * 2
	local row, col = 1, 1
	for _, event in ipairs(self.EventList) do
		local data = self.EventData[event]
		local tracker = self.db[data.dbKey].enable and Trackers:Acquire(event) or Trackers:Disable(event)
		if tracker then
			if tracker.profileUpdate then
				tracker.profileUpdate()
			end

			tracker:Size(self.db.style.trackerWidth, self.db.style.trackerHeight)

			tracker.args.desaturate = self.db[data.dbKey].desaturate
			tracker.args.soundFile = self.db[data.dbKey].sound and self.db[data.dbKey].soundFile

			if self.db[data.dbKey].alert then
				tracker.args.alert = true
				tracker.args.alertSecond = self.db[data.dbKey].second
				tracker.args.stopAlertIfCompleted = self.db[data.dbKey].stopAlertIfCompleted
				tracker.args.stopAlertIfPlayerNotEnteredDragonlands =
					self.db[data.dbKey].stopAlertIfPlayerNotEnteredDragonlands
				tracker.args.stopAlertIfPlayerNotEnteredMidnight =
					self.db[data.dbKey].stopAlertIfPlayerNotEnteredMidnight
			else
				tracker.args.alertSecond = nil
				tracker.args.stopAlertIfCompleted = nil
			end

			tracker:ClearAllPoints()

			local currentWidth = self.db.style.trackerWidth * col + self.db.style.trackerHorizontalSpacing * (col - 1)
			if currentWidth > maxWidth then
				row = row + 1
				col = 1
			end

			tracker:Point(
				"TOPLEFT",
				self.frame,
				"TOPLEFT",
				self.db.style.backdropSpacing
					+ self.db.style.trackerWidth * (col - 1)
					+ self.db.style.trackerHorizontalSpacing * (col - 1),
				-self.db.style.backdropSpacing
					- self.db.style.trackerHeight * (row - 1)
					- self.db.style.trackerVerticalSpacing * (row - 1)
			)

			col = col + 1

			if tracker.tickFunc then
				tracker.tickFunc()
			end
		end
	end

	self.frame:Height(
		self.db.style.backdropSpacing * 2
			+ self.db.style.trackerHeight * row
			+ self.db.style.trackerVerticalSpacing * (row - 1)
	)
end

function ET:TearDown()
	Trackers:CancelAllTickers()

	if self.frame then
		self.frame:Hide()
	end

	if not self.initialized then
		return
	end

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("EVENT_SCHEDULER_UPDATE")
	EventRegistry:UnregisterCallback("WorldMapOnShow", self)
	EventRegistry:UnregisterCallback("WorldMapMinimized", self)
	EventRegistry:UnregisterCallback("WorldMapMaximized", self)

	if _G.QuestMapFrame then
		self:Unhook(_G.QuestMapFrame, "Show")
		self:Unhook(_G.QuestMapFrame, "Hide")
	end

	self.initialized = false
end

function ET:Initialize()
	self.db = E.db.WT.maps.eventTracker

	if not self.db or not self.db.enable or self.initialized then
		return
	end

	self:UpdateTrackers()

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("EVENT_SCHEDULER_UPDATE")
	self:RefreshSchedulerCache()

	EventRegistry:RegisterCallback("WorldMapOnShow", self.UpdateTrackers, self)
	EventRegistry:RegisterCallback("WorldMapMinimized", self.OnWorldMapSizeChanged, self)
	EventRegistry:RegisterCallback("WorldMapMaximized", self.OnWorldMapSizeChanged, self)
	self:SecureHook(_G.QuestMapFrame, "Show", "UpdateTrackers")
	self:SecureHook(_G.QuestMapFrame, "Hide", "UpdateTrackers")

	self.initialized = true
end

function ET:ProfileUpdate()
	self.db = E.db.WT.maps.eventTracker

	if not self.db or not self.db.enable then
		self:TearDown()
		return
	end

	if not self.initialized then
		self:Initialize()
	else
		self:UpdateTrackers()
	end

	if self.frame then
		self.frame:SetShown(true)
	end
end

W:RegisterModule(ET:GetName())
