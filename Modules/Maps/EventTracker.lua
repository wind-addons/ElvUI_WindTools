local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local MF = W.Modules.MoveFrames ---@type MoveFrames
local C = W.Utilities.Color
local ET = W:NewModule("EventTracker", "AceEvent-3.0", "AceHook-3.0") ---@class EventTracker : AceModule, AceEvent-3.0, AceHook-3.0

local _G = _G
local ceil = ceil
local date = date
local floor = floor
local format = format
local ipairs = ipairs
local next = next
local pairs = pairs
local tinsert = tinsert
local type = type
local unpack = unpack

local CreateFrame = CreateFrame
local EventRegistry = EventRegistry
local GetServerTime = GetServerTime

local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local C_Timer_NewTicker = C_Timer.NewTicker

local LeftButtonIcon = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t"

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
				if not self.args.questIDs then
					return
				end

				local questIDs = type(self.args.questIDs) == "function" and self.args:questIDs() or self.args.questIDs

				if not questIDs or type(questIDs) ~= "table" then
					return
				end

				if type(questIDs) == "table" and type(next(questIDs)) ~= "number" then
					local completedStorylines, totalStorylines = 0, 0

					for _, storylineQuests in pairs(questIDs) do
						totalStorylines = totalStorylines + 1
						local storylineCompleted = false

						for _, questID in pairs(storylineQuests) do
							if C_QuestLog_IsQuestFlaggedCompleted(questID) then
								storylineCompleted = true
								break
							end
						end

						if storylineCompleted then
							completedStorylines = completedStorylines + 1
						end
					end

					self.isCompleted = (completedStorylines == totalStorylines)
					return
				end

				local completed = 0
				if self.args.checkAllCompleted then
					completed = 1 - #questIDs
				end

				for _, questID in pairs(questIDs) do
					if C_QuestLog_IsQuestFlaggedCompleted(questID) then
						completed = completed + 1
					end
				end

				self.isCompleted = (completed > 0)
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

				-- Location, Current Location, Next Location
				for _, locationContext in ipairs({
					{ L["Location"], self.args.location },
					{ L["Current Location"], self.args.currentLocation },
					{ L["Next Location"], self.args.nextLocation },
				}) do
					local left, right = unpack(locationContext)
					if right then
						right = type(right) == "function" and right(self.args) or right
						_G.GameTooltip:AddDoubleLine(left, right, 1, 1, 1)
					end
				end

				if self.args.questProgress then
					local questProgress = self.args.questProgress
					if type(questProgress) == "function" then
						questProgress = questProgress(self.args)
					end

					_G.GameTooltip:AddLine(" ")
					_G.GameTooltip:AddLine(L["Quest Progress"])
					for _, data in ipairs(questProgress) do
						local isCompleted = data.isCompleted
							or data.questID and C_QuestLog_IsQuestFlaggedCompleted(data.questID)
						local color = isCompleted and "green-500" or "rose-500"
						local textL = type(data.label) == "function" and data:label() or data.label
						local textR = data.rightText
							or C.StringByTemplate(isCompleted and L["Completed"] or L["Not Completed"], color)
						if type(textL) == "string" then
							_G.GameTooltip:AddDoubleLine(textL, textR, 1, 1, 1)
						end
					end
				end

				if self.args.hasWeeklyReward then
					if self.isCompleted then
						_G.GameTooltip:AddDoubleLine(
							L["Weekly Reward"],
							C.StringByTemplate(L["Completed"], "green-500"),
							1,
							1,
							1
						)
					else
						_G.GameTooltip:AddDoubleLine(
							L["Weekly Reward"],
							C.StringByTemplate(L["Not Completed"], "rose-500"),
							1,
							1,
							1
						)
					end
				end

				if self.args.onClickHelpText then
					_G.GameTooltip:AddLine(" ")
					_G.GameTooltip:AddLine(LeftButtonIcon .. " " .. self.args.onClickHelpText, 1, 1, 1)
				end

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
				local completed = 0
				if self.args.questIDs and (type(self.args.questIDs) == "table") then
					-- lower than 0 means all quests need to be completed
					if self.args.checkAllCompleted then
						completed = 1 - #self.args.questIDs
					end

					for _, questID in pairs(self.args.questIDs) do
						if C_QuestLog_IsQuestFlaggedCompleted(questID) then
							completed = completed + 1
						end
					end
				end
				self.isCompleted = (completed > 0)

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
					-- event ending tracking timer
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
					if self.args.flash then
						E:Flash(self.runningTip, 1, true)
					end
				else
					-- normal tracking timer
					self.timerText:SetText(SecondToTime(self.timeLeft))
					self.statusBar:SetMinMaxValues(0, self.args.interval)
					self.statusBar:SetValue(self.timeLeft)

					local palette = self.args.barColor or ET.ColorPalette.gray ---@type [ColorTemplate, ColorTemplate]
					self.statusBar:GetStatusBarTexture():SetGradient(
						"HORIZONTAL",
						C.CreateColorFromTemplate(palette[1]),
						C.CreateColorFromTemplate(palette[2])
					)

					if self.args.flash then
						E:StopFlash(self.runningTip)
					end
					self.runningTip:Hide()
				end
			end,
			alert = function(self)
				if not ET.playerEnteredWorld then
					return
				end

				if not self.args["alertCache"] then
					self.args["alertCache"] = {}
				end

				if self.args["alertCache"][self.nextEventIndex] then
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
					self.args["alertCache"][self.nextEventIndex] = true
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

				-- Location, Current Location, Next Location
				for _, locationContext in ipairs({
					{ L["Location"], self.args.location },
					{ L["Current Location"], self.args.currentLocation },
					{ L["Next Location"], self.args.nextLocation },
				}) do
					local left, right = unpack(locationContext)
					if right then
						right = type(right) == "function" and right(self.args) or right
						_G.GameTooltip:AddDoubleLine(left, right, 1, 1, 1)
					end
				end

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
					local questProgress = self.args.questProgress
					if type(questProgress) == "function" then
						questProgress = questProgress(self.args)
					end

					_G.GameTooltip:AddLine(" ")
					_G.GameTooltip:AddLine(L["Quest Progress"])
					for _, data in ipairs(questProgress) do
						if data.questID then
							local isCompleted = C_QuestLog_IsQuestFlaggedCompleted(data.questID)
							local color = isCompleted and "green-500" or "rose-500"
							local label = type(data.label) == "function" and data:label() or data.label
							if type(label) == "string" then
								_G.GameTooltip:AddDoubleLine(
									label,
									C.StringByTemplate(isCompleted and L["Completed"] or L["Not Completed"], color),
									1,
									1,
									1
								)
							end
						end
					end
				end

				if self.args.hasWeeklyReward then
					if self.isCompleted then
						_G.GameTooltip:AddDoubleLine(
							L["Weekly Reward"],
							C.StringByTemplate(L["Completed"], "green-500"),
							1,
							1,
							1
						)
					else
						_G.GameTooltip:AddDoubleLine(
							L["Weekly Reward"],
							C.StringByTemplate(L["Not Completed"], "rose-500"),
							1,
							1,
							1
						)
					end
				end

				if self.args.onClickHelpText then
					_G.GameTooltip:AddLine(" ")
					_G.GameTooltip:AddLine(LeftButtonIcon .. " " .. self.args.onClickHelpText, 1, 1, 1)
				end

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

--- Get or create a tracker frame
---@param event EventKey The key of the event defined in EventData
---@return Frame The tracker frame
function Trackers:Acquire(event)
	if self.pool[event] then
		self.pool[event]:Show()
		return self.pool[event]
	end

	local data = ET.EventData[event]

	local frame = CreateFrame("Frame", "WTEventTracker" .. event, ET.frame)
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
			frame.tickFunc = function()
				functions.ticker.dateUpdater(frame)
				functions.ticker.alert(frame)
				if _G.WorldMapFrame:IsShown() and frame:IsShown() then
					functions.ticker.uiUpdater(frame)
				end
			end

			frame.tickerInstance = C_Timer_NewTicker(functions.ticker.interval, function()
				if not (ET and ET.db and ET.db.enable) then
					return
				end
				frame.tickFunc()
			end)
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

	if data.args.events then
		for _, e in ipairs(data.args.events) do
			ET:AddEventHandler(e[1], e[2])
		end
	end

	self.pool[event] = frame

	return frame
end

---Disable a tracker frame
---@param event EventKey The key of the event defined in EventData
function Trackers:Disable(event)
	if self.pool[event] then
		self.pool[event]:Hide()
	end
end

ET.EventHandlers = {
	["PLAYER_ENTERING_WORLD"] = {
		function()
			E:Delay(10, function()
				ET.playerEnteredWorld = true
			end)
		end,
	},
}

function ET:HandlerEvent(event, ...)
	if self.EventHandlers[event] then
		for _, handler in ipairs(self.EventHandlers[event]) do
			---@diagnostic disable-next-line: redundant-parameter -- Prepared for future events
			handler(...)
		end
	end
end

function ET:AddEventHandler(event, handler)
	if not self.EventHandlers[event] then
		self.EventHandlers[event] = {}
	end

	tinsert(self.EventHandlers[event], handler)
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

function ET:GetPlayerDB(key)
	local globalDB = E.global.WT.maps.eventTracker

	if not globalDB then
		return
	end

	if not globalDB[E.myrealm] then
		globalDB[E.myrealm] = {}
	end

	if not globalDB[E.myrealm][E.myname] then
		globalDB[E.myrealm][E.myname] = {}
	end

	if not globalDB[E.myrealm][E.myname][key] then
		globalDB[E.myrealm][E.myname][key] = {}
	end

	return globalDB[E.myrealm][E.myname][key]
end

function ET:UpdateTrackers()
	self:ConstructFrame()
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
				tracker.args.disableAlertAfterHours = self.db[data.dbKey].disableAlertAfterHours
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

			tracker.tickFunc()
		end
	end

	self.frame:Height(
		self.db.style.backdropSpacing * 2
			+ self.db.style.trackerHeight * row
			+ self.db.style.trackerVerticalSpacing * (row - 1)
	)
end

function ET:Initialize()
	self.db = E.db.WT.maps.eventTracker

	if not self.db or not self.db.enable or self.initialized then
		return
	end

	self:UpdateTrackers()

	for event in pairs(self.EventHandlers) do
		self:RegisterEvent(event, "HandlerEvent")
	end

	EventRegistry:RegisterCallback("WorldMapOnShow", self.UpdateTrackers, self)
	EventRegistry:RegisterCallback("WorldMapMinimized", E.Delay, E, 0.1, self.UpdateTrackers, self)
	EventRegistry:RegisterCallback("WorldMapMaximized", E.Delay, E, 0.1, self.UpdateTrackers, self)
	self:SecureHook(_G.QuestMapFrame, "Show", "UpdateTrackers")
	self:SecureHook(_G.QuestMapFrame, "Hide", "UpdateTrackers")

	self.initialized = true
end

function ET:ProfileUpdate()
	self:Initialize()

	if self.frame then
		self.frame:SetShown(self.db.enable)
	end
end

W:RegisterModule(ET:GetName())
