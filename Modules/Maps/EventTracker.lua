local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local MF = W.Modules.MoveFrames
local C = W.Utilities.Color
local LSM = E.Libs.LSM
local ET = W:NewModule("EventTracker", "AceEvent-3.0", "AceHook-3.0")

local _G = _G
local ceil = ceil
local date = date
local floor = floor
local format = format
local ipairs = ipairs
local pairs = pairs
local type = type
local unpack = unpack
local tinsert = tinsert
local math_pow = math.pow

local CreateFrame = CreateFrame
local EventRegistry = EventRegistry
local GetCurrentRegion = GetCurrentRegion
local GetServerTime = GetServerTime
local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo
local PlaySoundFile = PlaySoundFile

local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_Map_GetMapInfo = C_Map.GetMapInfo
local C_Map_GetPlayerMapPosition = C_Map.GetPlayerMapPosition
local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local C_Timer_NewTicker = C_Timer.NewTicker
local C_NamePlate_GetNamePlates = C_NamePlate.GetNamePlates

local LeftButtonIcon = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t"

local eventList = {
	-- TWW
	-- "TWWProfessions",
	"KhazAlgarEmissary",
	"EcologicalSuccession",
	"Nightfall",
	"TheaterTroupe",
	"RingingDeeps",
	"SpreadingTheLight",
	"UnderworldOperative",
	-- DF
	"RadiantEchoes",
	"CommunityFeast",
	"SiegeOnDragonbaneKeep",
	"ResearchersUnderFire",
	"TimeRiftThaldraszus",
	"SuperBloom",
	"BigDig",
	"IskaaranFishingNet",
}

local env = {
	fishingNetPosition = {
		-- Waking Shores
		[1] = { map = 2022, x = 0.63585, y = 0.75349 },
		[2] = { map = 2022, x = 0.64514, y = 0.74178 },
		-- Lava
		[3] = { map = 2022, x = 0.33722, y = 0.65047 },
		[4] = { map = 2022, x = 0.34376, y = 0.64763 },
		-- Thaldraszus
		[5] = { map = 2025, x = 0.56782, y = 0.65178 },
		[6] = { map = 2025, x = 0.57756, y = 0.65491 },
		-- Ohn'ahran Plains
		[7] = { map = 2023, x = 0.80522, y = 0.78433 },
		[8] = { map = 2023, x = 0.80467, y = 0.77742 },
	},
	fishingNetWidgetIDToIndex = {
		-- data mining: https://wow.tools/dbc/?dbc=uiwidget&build=10.0.5.47621#page=1&colFilter[3]=exact%3A2087
		-- Waking Shores
		[4203] = 1,
		[4317] = 2,
	},
	radiantEchoesZoneRotation = {
		C_Map_GetMapInfo(32),
		C_Map_GetMapInfo(70),
		C_Map_GetMapInfo(115),
	},
	twwProfessionsWeekly = {
		[4620669] = 84133, -- 鍊金
		[4620670] = 84127, -- 鍛造
		[4620672] = 84084, -- 附魔
		[4620673] = 84128, -- 工程
		-- [4620675] = 84134, -- 草藥
		[4620676] = 84129, -- 銘文
		[4620677] = 84130, -- 珠寶
		[4620678] = 84131, -- 製皮
		-- [4620679] = 84128, -- 採礦
		-- [4620680] = 84132, -- 剝皮
		[4620681] = 84132, -- 裁縫
	},
}

local colorPlatte = {
	blue = {
		{ r = 0.32941, g = 0.52157, b = 0.93333, a = 1 },
		{ r = 0.25882, g = 0.84314, b = 0.86667, a = 1 },
	},
	red = {
		{ r = 0.92549, g = 0.00000, b = 0.54902, a = 1 },
		{ r = 0.98824, g = 0.40392, b = 0.40392, a = 1 },
	},
	green = {
		{ r = 0.40392, g = 0.92549, b = 0.54902, a = 1 },
		{ r = 0.00000, g = 0.98824, b = 0.40392, a = 1 },
	},
	purple = {
		{ r = 0.27843, g = 0.46275, b = 0.90196, a = 1 },
		{ r = 0.55686, g = 0.32941, b = 0.91373, a = 1 },
	},
	bronze = {
		{ r = 0.83000, g = 0.42000, b = 0.10000, a = 1 },
		{ r = 0.56500, g = 0.40800, b = 0.16900, a = 1 },
	},
	running = {
		{ r = 0.06667, g = 0.60000, b = 0.55686, a = 1 },
		{ r = 0.21961, g = 0.93725, b = 0.49020, a = 1 },
	},
	radiantEchoes = {
		{ r = 0.26275, g = 0.79608, b = 1.00000, a = 1 },
		{ r = 1.00000, g = 0.96078, b = 0.86275, a = 1 },
	},
}

local function secondToTime(second)
	local hour = floor(second / 3600)
	local min = floor((second - hour * 3600) / 60)
	local sec = floor(second - hour * 3600 - min * 60)

	if hour == 0 then
		return format("%02d:%02d", min, sec)
	else
		return format("%02d:%02d:%02d", hour, min, sec)
	end
end

local function reskinStatusBar(bar)
	bar:SetFrameLevel(bar:GetFrameLevel() + 1)
	bar:StripTextures()
	bar:CreateBackdrop("Transparent")
	bar:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(bar)
end

local function getGradientText(text, colorTable)
	if not text or not colorTable then
		return text
	end
	return E:TextGradient(
		text,
		colorTable[1].r,
		colorTable[1].g,
		colorTable[1].b,
		colorTable[2].r,
		colorTable[2].g,
		colorTable[2].b
	)
end

local function worldMapIDSetter(idOrFunc)
	return function(...)
		if not _G.WorldMapFrame or not _G.WorldMapFrame:IsShown() or not _G.WorldMapFrame.SetMapID then
			return
		end

		local id = type(idOrFunc) == "function" and idOrFunc(...) or idOrFunc
		_G.WorldMapFrame:SetMapID(id)
	end
end

local functionFactory = {
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
			self.icon:SetTexCoord(unpack(E.TexCoords))
			self.icon:SetSize(22, 22)
			self.icon:ClearAllPoints()
			self.icon:SetPoint("LEFT", self, "LEFT", 0, 0)

			ET:SetFont(self.name, 13)
			self.name:ClearAllPoints()
			self.name:SetPoint("LEFT", self, "LEFT", 30, 0)
			self.name:SetText(self.args.label)

			self.completed:ClearAllPoints()
			self.completed:SetSize(16, 16)
			self.completed:SetPoint("RIGHT", self, "RIGHT", 0, 0)
			self.completed:SetTexCoord(F.GetRoleTexCoord("PENDING"))
		end,
		ticker = {
			interval = 2,
			dateUpdater = function(self)
				local completed = 0
				if self.args.questIDs then
					local questIDs = type(self.args.questIDs) == "function" and self.args:questIDs()
						or self.args.questIDs
					-- lower than 0 means all quests need to be completed
					if self.args.checkAllCompleted then
						completed = 1 - #questIDs
					end

					for _, questID in pairs(questIDs) do
						if C_QuestLog_IsQuestFlaggedCompleted(questID) then
							completed = completed + 1
						end
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
						if data.questID then
							local isCompleted = C_QuestLog_IsQuestFlaggedCompleted(data.questID)
							local color = isCompleted and "success" or "danger"
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
							C.StringByTemplate(L["Completed"], "success"),
							1,
							1,
							1
						)
					else
						_G.GameTooltip:AddDoubleLine(
							L["Weekly Reward"],
							C.StringByTemplate(L["Not Completed"], "danger"),
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
			onLeave = function(self)
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

			reskinStatusBar(self.statusBar)

			self.statusBar.spark = self.statusBar:CreateTexture(nil, "ARTWORK", nil, 1)
			self.statusBar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
			self.statusBar.spark:SetBlendMode("ADD")
			self.statusBar.spark:SetPoint("CENTER", self.statusBar:GetStatusBarTexture(), "RIGHT", 0, 0)
			self.statusBar.spark:SetSize(4, 26)

			self:SetScript("OnMouseDown", function()
				if self.args.onClick then
					self.args:onClick()
				end
			end)
		end,
		setup = function(self)
			self.icon:SetTexture(self.args.icon)
			self.icon:SetTexCoord(unpack(E.TexCoords))
			self.icon:SetSize(22, 22)
			self.icon:ClearAllPoints()
			self.icon:SetPoint("LEFT", self, "LEFT", 0, 0)

			self.statusBar:ClearAllPoints()
			self.statusBar:SetPoint("TOPLEFT", self, "LEFT", 26, 2)
			self.statusBar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 6)

			ET:SetFont(self.timerText, 13)
			self.timerText:ClearAllPoints()
			self.timerText:SetPoint("TOPRIGHT", self, "TOPRIGHT", -2, -6)

			ET:SetFont(self.name, 13)
			self.name:ClearAllPoints()
			self.name:SetPoint("TOPLEFT", self, "TOPLEFT", 30, -6)
			self.name:SetText(self.args.label)

			ET:SetFont(self.runningTip, 10)
			self.runningTip:SetText(self.args.runningText)
			self.runningTip:SetPoint("CENTER", self.statusBar, "BOTTOM", 0, 0)
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
					self.timerText:SetText(C.StringByTemplate(secondToTime(self.timeLeft), "success"))
					self.statusBar:SetMinMaxValues(0, self.args.duration)
					self.statusBar:SetValue(self.timeOver)
					local tex = self.statusBar:GetStatusBarTexture()
					local platte = self.args.runningBarColor or colorPlatte.running
					tex:SetGradient("HORIZONTAL", C.CreateColorFromTable(platte[1]), C.CreateColorFromTable(platte[2]))
					if self.args.runningTextUpdater then
						self.runningTip:SetText(self.args:runningTextUpdater())
					end
					self.runningTip:Show()
					if self.args.flash then
						E:Flash(self.runningTip, 1, true)
					end
				else
					-- normal tracking timer
					self.timerText:SetText(secondToTime(self.timeLeft))
					self.statusBar:SetMinMaxValues(0, self.args.interval)
					self.statusBar:SetValue(self.timeLeft)

					if type(self.args.barColor[1]) == "number" then
						self.statusBar:SetStatusBarColor(unpack(self.args.barColor))
					else
						local tex = self.statusBar:GetStatusBarTexture()
						tex:SetGradient(
							"HORIZONTAL",
							C.CreateColorFromTable(self.args.barColor[1]),
							C.CreateColorFromTable(self.args.barColor[2])
						)
					end

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
					local gradientName = getGradientText(self.args.eventName, self.args.barColor)
					F.Print(
						format(
							L["%s will be started in %s!"],
							eventIconString .. " " .. gradientName,
							secondToTime(self.timeLeft)
						)
					)

					if self.args.soundFile then
						PlaySoundFile(LSM:Fetch("sound", self.args.soundFile), "Master")
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
				_G.GameTooltip:AddDoubleLine(L["Interval"], secondToTime(self.args.interval), 1, 1, 1)
				_G.GameTooltip:AddDoubleLine(L["Duration"], secondToTime(self.args.duration), 1, 1, 1)
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
						C.StringByTemplate(self.args.runningText, "success"),
						1,
						1,
						1
					)
				else
					_G.GameTooltip:AddDoubleLine(L["Status"], C.StringByTemplate(L["Waiting"], "greyLight"), 1, 1, 1)
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
							local color = isCompleted and "success" or "danger"
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
							C.StringByTemplate(L["Completed"], "success"),
							1,
							1,
							1
						)
					else
						_G.GameTooltip:AddDoubleLine(
							L["Weekly Reward"],
							C.StringByTemplate(L["Not Completed"], "danger"),
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
			onLeave = function(self)
				_G.GameTooltip:Hide()
			end,
		},
	},
	triggerTimer = {
		init = function(self)
			self.icon = self:CreateTexture(nil, "ARTWORK")
			self.icon:CreateBackdrop("Transparent")
			self.icon.backdrop:SetOutside(self.icon, 1, 1)
			self.statusBar = CreateFrame("StatusBar", nil, self)
			self.name = self.statusBar:CreateFontString(nil, "OVERLAY")
			self.timerText = self.statusBar:CreateFontString(nil, "OVERLAY")
			self.runningTip = self.statusBar:CreateFontString(nil, "OVERLAY")

			reskinStatusBar(self.statusBar)

			self.statusBar.spark = self.statusBar:CreateTexture(nil, "ARTWORK", nil, 1)
			self.statusBar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
			self.statusBar.spark:SetBlendMode("ADD")
			self.statusBar.spark:SetPoint("CENTER", self.statusBar:GetStatusBarTexture(), "RIGHT", 0, 0)
			self.statusBar.spark:SetSize(4, 26)
		end,
		setup = function(self)
			self.icon:SetTexture(self.args.icon)
			self.icon:SetTexCoord(unpack(E.TexCoords))
			self.icon:SetSize(22, 22)
			self.icon:ClearAllPoints()
			self.icon:SetPoint("LEFT", self, "LEFT", 0, 0)

			self.statusBar:ClearAllPoints()
			self.statusBar:SetPoint("TOPLEFT", self, "LEFT", 26, 2)
			self.statusBar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 6)

			ET:SetFont(self.timerText, 13)
			self.timerText:ClearAllPoints()
			self.timerText:SetPoint("TOPRIGHT", self, "TOPRIGHT", -2, -6)

			ET:SetFont(self.name, 13)
			self.name:ClearAllPoints()
			self.name:SetPoint("TOPLEFT", self, "TOPLEFT", 30, -6)
			self.name:SetText(self.args.label)

			ET:SetFont(self.runningTip, 10)
			self.runningTip:SetText(self.args.runningText)
			self.runningTip:SetPoint("CENTER", self.statusBar, "BOTTOM", 0, 0)
		end,
		ticker = {
			interval = 0.3,
			dateUpdater = function(self)
				if not C_QuestLog_IsQuestFlaggedCompleted(70871) then
					self.netTable = nil
					return
				end

				local db = ET:GetPlayerDB("iskaaranFishingNet")
				if not db then
					return
				end

				self.netTable = {}
				local now = GetServerTime()
				for netIndex = 1, #env.fishingNetPosition do
					-- update db from old version
					if type(db[netIndex]) ~= "table" then
						db[netIndex] = nil
					end

					if not db[netIndex] or db[netIndex].time == 0 then
						self.netTable[netIndex] = "NOT_STARTED"
					else
						self.netTable[netIndex] = {
							left = db[netIndex].time - now,
							duration = db[netIndex].duration,
						}
					end
				end
			end,
			uiUpdater = function(self)
				local done = {}
				local notStarted = {}
				local waiting = {}

				if self.netTable then
					for netIndex, timeData in pairs(self.netTable) do
						if type(timeData) == "string" then
							if timeData == "NOT_STARTED" then
								tinsert(notStarted, netIndex)
							end
						elseif type(timeData) == "table" then
							if timeData.left <= 0 then
								tinsert(done, netIndex)
							else
								tinsert(waiting, netIndex)
							end
						end
					end
				end

				local tip = ""

				if #done == #env.fishingNetPosition then
					tip = C.StringByTemplate(L["All nets can be collected"], "success")
					self.timerText:SetText("")

					self.statusBar:GetStatusBarTexture():SetGradient(
						"HORIZONTAL",
						C.CreateColorFromTable(colorPlatte.running[1]),
						C.CreateColorFromTable(colorPlatte.running[2])
					)
					self.statusBar:SetMinMaxValues(0, 1)
					self.statusBar:SetValue(1)

					E:Flash(self.runningTip, 1, true)
				elseif #waiting > 0 then
					if #done > 0 then
						local netsText = ""
						for i = 1, #done do
							netsText = netsText .. "#" .. done[i]
							if i ~= #done then
								netsText = netsText .. ", "
							end
						end
						tip = C.StringByTemplate(format(L["Net %s can be collected"], netsText), "success")
					else
						tip = L["Waiting"]
					end

					local maxTimeIndex
					for _, index in pairs(waiting) do
						if not maxTimeIndex or self.netTable[index].left > self.netTable[maxTimeIndex].left then
							maxTimeIndex = index
						end
					end

					if type(self.args.barColor[1]) == "number" then
						self.statusBar:SetStatusBarColor(unpack(self.args.barColor))
					else
						self.statusBar:GetStatusBarTexture():SetGradient(
							"HORIZONTAL",
							C.CreateColorFromTable(self.args.barColor[1]),
							C.CreateColorFromTable(self.args.barColor[2])
						)
					end

					self.timerText:SetText(secondToTime(self.netTable[maxTimeIndex].left))
					self.statusBar:SetMinMaxValues(0, self.netTable[maxTimeIndex].duration)
					self.statusBar:SetValue(self.netTable[maxTimeIndex].left)

					E:StopFlash(self.runningTip)
				else
					self.timerText:SetText("")
					self.statusBar:GetStatusBarTexture():SetGradient(
						"HORIZONTAL",
						C.CreateColorFromTable(colorPlatte.running[1]),
						C.CreateColorFromTable(colorPlatte.running[2])
					)
					self.statusBar:SetMinMaxValues(0, 1)

					if #done > 0 then
						local netsText = ""
						for i = 1, #done do
							netsText = netsText .. "#" .. done[i]
							if i ~= #done then
								netsText = netsText .. ", "
							end
						end
						tip = C.StringByTemplate(format(L["Net %s can be collected"], netsText), "success")
						self.statusBar:SetValue(1)
					else
						tip = C.StringByTemplate(L["No Nets Set"], "danger")
						self.statusBar:SetValue(0)
					end

					E:StopFlash(self.runningTip)
				end

				self.runningTip:SetText(tip)
			end,
			alert = function(self)
				if not ET.playerEnteredWorld then
					return
				end

				if not self.netTable then
					return
				end

				local db = ET:GetPlayerDB("iskaaranFishingNet")
				if not db then
					return
				end

				if not self.args["alertCache"] then
					self.args["alertCache"] = {}
				end

				local needAnnounce = false
				local readyNets = {}
				local bonusReady = false

				for netIndex, timeData in pairs(self.netTable) do
					if type(timeData) == "table" and timeData.left <= 0 then
						if not self.args["alertCache"][netIndex] then
							self.args["alertCache"][netIndex] = {}
						end

						if not self.args["alertCache"][netIndex][db[netIndex].time] then
							self.args["alertCache"][netIndex][db[netIndex].time] = true
							local hour = self.args.disableAlertAfterHours
							if not hour or hour == 0 or (hour * 60 * 60 + timeData.left) > 0 then
								readyNets[netIndex] = true
								if netIndex > 2 then
									bonusReady = true
								end
								needAnnounce = true
							end
						end
					end
				end

				if needAnnounce then
					local netsText = ""

					if readyNets[1] and readyNets[2] then
						netsText = netsText .. format(L["Net #%d"], 1) .. ", " .. format(L["Net #%d"], 2)
					elseif readyNets[1] then
						netsText = netsText .. format(L["Net #%d"], 1)
					elseif readyNets[2] then
						netsText = netsText .. format(L["Net #%d"], 2)
					end

					if bonusReady then
						if readyNets[1] or readyNets[2] then
							netsText = netsText .. ", "
						end
						netsText = netsText .. L["Bonus Net"]
					end

					local eventIconString = F.GetIconString(self.args.icon, 16, 16)
					local gradientName = getGradientText(self.args.eventName, self.args.barColor)

					F.Print(format(eventIconString .. " " .. gradientName .. " " .. L["%s can be collected"], netsText))

					if self.args.soundFile then
						PlaySoundFile(LSM:Fetch("sound", self.args.soundFile), "Master")
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

				if not self.netTable or #self.netTable == 0 then
					_G.GameTooltip:AddLine(C.StringByTemplate(L["No Nets Set"], "danger"))
					_G.GameTooltip:Show()
					return
				end
				_G.GameTooltip:AddLine(L["Fishing Nets"])

				local netIndex1Status -- Always
				local netIndex2Status -- Always
				local bonusNetStatus -- Bonus
				local bonusTimeLeft = 0

				for netIndex, timeData in pairs(self.netTable) do
					local text
					if type(timeData) == "table" then
						if timeData.left <= 0 then
							text = C.StringByTemplate(L["Can be collected"], "success")
						else
							text = C.StringByTemplate(secondToTime(timeData.left), "info")
						end

						-- only show latest bonus net
						if netIndex > 2 and timeData.left > bonusTimeLeft then
							bonusTimeLeft = timeData.left
							bonusNetStatus = text
						end
					else
						if timeData == "NOT_STARTED" then
							text = C.StringByTemplate(L["Can be set"], "warning")
						end
					end

					if netIndex == 1 then
						netIndex1Status = text
					elseif netIndex == 2 then
						netIndex2Status = text
					end
				end

				_G.GameTooltip:AddDoubleLine(format(L["Net #%d"], 1), netIndex1Status)
				_G.GameTooltip:AddDoubleLine(format(L["Net #%d"], 2), netIndex2Status)
				if bonusNetStatus then
					_G.GameTooltip:AddDoubleLine(L["Bonus Net"], bonusNetStatus)
				else -- no bonus net
					_G.GameTooltip:AddDoubleLine(L["Bonus Net"], C.StringByTemplate(L["Not Set"], "danger"))
				end

				if self.args.onClickHelpText then
					_G.GameTooltip:AddLine(" ")
					_G.GameTooltip:AddLine(LeftButtonIcon .. " " .. self.args.onClickHelpText, 1, 1, 1)
				end

				_G.GameTooltip:Show()
			end,
			onLeave = function(self)
				_G.GameTooltip:Hide()
			end,
		},
	},
}

local eventData = {
	-- TWW
	TWWProfessions = {
		dbKey = "twwProfessions",
		args = {
			icon = 1392955,
			type = "weekly",
			questProgress = function()
				local prof1, prof2 = GetProfessions()
				local quests = {}

				for _, prof in pairs({ prof1, prof2 }) do
					if prof then
						local name, iconID = GetProfessionInfo(prof)
						tinsert(quests, {
							questID = env.twwProfessionsWeekly[iconID],
							label = F.GetIconString(iconID, 14, 14) .. " " .. name,
						})
					end
				end

				return quests
			end,
			hasWeeklyReward = false,
			eventName = L["Professions Weekly"],
			location = C_Map_GetMapInfo(2339).name,
			label = L["Professions Weekly"],
			onClick = worldMapIDSetter(2339),
			onClickHelpText = L["Click to show location"],
		},
	},
	KhazAlgarEmissary = {
		dbKey = "khazAlgarEmissary",
		args = {
			icon = 236681,
			type = "weekly",
			questIDs = {
				82449, -- 世界之魂的呼喚
				82452, -- 世界之魂：世界任務
				82453, -- 世界之魂：安可！
				82482, -- 世界之魂：嗅聞
				82483, -- 世界之魂：散布光芒
				82485, -- 世界之魂：燼釀酒莊
				82486, -- 世界之魂：培育所
				82487, -- 世界之魂：石庫
				82488, -- 世界之魂：暗焰裂縫
				82489, -- 世界之魂：破曉者號
				82490, -- 世界之魂：聖焰隱修院
				82491, -- 世界之魂：『回音之城』厄拉卡拉
				82492, -- 世界之魂：蛛絲城
				82493, -- 世界之魂：破曉者號
				82494, -- 世界之魂：『回音之城』厄拉卡拉
				82495, -- 世界之魂：燼釀酒莊
				82496, -- 世界之魂：蛛絲城
				82497, -- 世界之魂：石庫
				82498, -- 世界之魂：暗焰裂縫
				82499, -- 世界之魂：聖焰隱修院
				82500, -- 世界之魂：培育所
				82501, -- 世界之魂：破曉者號
				82502, -- 世界之魂：『回音之城』厄拉卡拉
				82503, -- 世界之魂：燼釀酒莊
				82504, -- 世界之魂：蛛絲城
				82505, -- 世界之魂：石庫
				82506, -- 世界之魂：暗焰裂縫
				82507, -- 世界之魂：聖焰隱修院
				82508, -- 世界之魂：培育所
				82509, -- 世界之魂：奈幽巴宮殿
				82510, -- 世界之魂：奈幽巴宮殿
				82511, -- 世界之魂：甦醒機械
				82512, -- 世界之魂：世界首領
				82516, -- 世界之魂：締結合約
				82659, -- 世界之魂：奈幽巴宮殿
				82678, -- 文庫：第一張圓盤
				82679, -- 文庫：尋覓歷史
				82708, -- 探究：奈幽蟲族威脅
			},
			hasWeeklyReward = true,
			eventName = L["Khaz Algar Emissary"],
			location = C_Map_GetMapInfo(2339).name,
			label = L["Khaz Algar Emissary"],
			onClick = worldMapIDSetter(2339),
			onClickHelpText = L["Click to show location"],
		},
	},
	EcologicalSuccession = {
		dbKey = "ecologicalSuccession",
		args = {
			icon = 6921877,
			type = "weekly",
			questIDs = {
				85460, -- 生態重構
			},
			hasWeeklyReward = true,
			eventName = L["Ecological Succession"],
			location = C_Map_GetMapInfo(2371).name,
			label = L["Ecological Succession"],
			onClick = worldMapIDSetter(2371),
			onClickHelpText = L["Click to show location"],
		},
	},
	Nightfall = {
		dbKey = "nightFall",
		args = {
			icon = 6694198,
			type = "loopTimer",
			questIDs = {
				91173,
				89295,
			},
			hasWeeklyReward = true,
			duration = 15 * 60,
			interval = 60 * 60,
			barColor = colorPlatte.blue,
			flash = true,
			runningBarColor = colorPlatte.purple,
			eventName = L["Nightfall"],
			location = C_Map_GetMapInfo(2215).name,
			label = L["Nightfall"],
			runningText = L["Running"],
			startTimestamp = (function()
				local timestampTable = {
					[1] = 1724976005, -- NA
					[2] = 1724976005, -- KR
					[3] = 1724976005, -- EU
					[4] = 1724976005, -- TW
					[5] = 1724976005, -- CN
					[72] = 1724976000,
				}

				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = worldMapIDSetter(2215),
			onClickHelpText = L["Click to show location"],
		},
	},
	TheaterTroupe = {
		dbKey = "theaterTroupe",
		args = {
			icon = 5788303,
			type = "loopTimer",
			questIDs = {
				83240, -- 劇團
			},
			hasWeeklyReward = true,
			duration = 15 * 60,
			interval = 60 * 60,
			barColor = colorPlatte.bronze,
			flash = true,
			runningBarColor = colorPlatte.green,
			eventName = L["Theater Troupe"],
			location = C_Map_GetMapInfo(2248).name,
			label = L["Theater Troupe"],
			runningText = L["Performing"],
			startTimestamp = (function()
				local timestampTable = {
					[1] = 1724976005, -- NA
					[2] = 1724976005, -- KR
					[3] = 1724976005, -- EU
					[4] = 1724976005, -- TW
					[5] = 1724976005, -- CN
					[72] = 1724976000,
				}

				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = worldMapIDSetter(2248),
			onClickHelpText = L["Click to show location"],
		},
	},
	RingingDeeps = {
		dbKey = "ringingDeeps",
		args = {
			icon = 2120036,
			type = "weekly",
			questIDs = {
				83333, -- 應付麻煩
			},
			hasWeeklyReward = true,
			eventName = L["Ringing Deeps"],
			location = C_Map_GetMapInfo(2214).name,
			label = L["Ringing Deeps"],
			onClick = worldMapIDSetter(2214),
			onClickHelpText = L["Click to show location"],
		},
	},
	SpreadingTheLight = {
		dbKey = "spreadingTheLight",
		args = {
			icon = 5927633,
			type = "weekly",
			questIDs = {
				76586, -- 散布光芒
			},
			hasWeeklyReward = true,
			eventName = L["Spreading The Light"],
			location = C_Map_GetMapInfo(2215).name,
			label = L["Spreading The Light"],
			onClick = worldMapIDSetter(2215),
			onClickHelpText = L["Click to show location"],
		},
	},
	UnderworldOperative = {
		dbKey = "underworldOperative",
		args = {
			icon = 5309857,
			type = "weekly",
			questIDs = {
				80670, -- 織絲者之眼
				80671, -- 將軍之刃
				80672, -- 輔臣之手
			},
			hasWeeklyReward = true,
			eventName = L["Underworld Operative"],
			location = C_Map_GetMapInfo(2255).name,
			label = L["Underworld Operative"],
			onClick = worldMapIDSetter(2255),
			onClickHelpText = L["Click to show location"],
		},
	},
	-- DF
	RadiantEchoes = {
		dbKey = "radiantEchoes",
		args = {
			icon = 3015740,
			type = "loopTimer",
			questProgress = {
				{
					questID = 78938,
					mapID = 32,
					label = function()
						return format(
							L["Daily Quest at %s"],
							C.StringByTemplate(env.radiantEchoesZoneRotation[1].name, "info")
						)
					end,
				},
				{
					questID = 82676,
					mapID = 70,
					label = function()
						return format(
							L["Daily Quest at %s"],
							C.StringByTemplate(env.radiantEchoesZoneRotation[2].name, "info")
						)
					end,
				},
				{
					questID = 82689,
					mapID = 115,
					label = function()
						return format(
							L["Daily Quest at %s"],
							C.StringByTemplate(env.radiantEchoesZoneRotation[3].name, "info")
						)
					end,
				},
			},
			questIDs = { 82676, 82689, 78938 },
			hasWeeklyReward = false,
			duration = 60 * 60, -- always on
			interval = 60 * 60,
			barColor = colorPlatte.blue,
			flash = false,
			runningBarColor = colorPlatte.radiantEchoes,
			eventName = L["Radiant Echoes"],
			currentMapIndex = function(args)
				return floor((GetServerTime() - args.startTimestamp) / args.interval) % 3 + 1
			end,
			currentLocation = function(args)
				return env.radiantEchoesZoneRotation[args:currentMapIndex()].name
			end,
			nextLocation = function(args)
				return env.radiantEchoesZoneRotation[args:currentMapIndex() % 3 + 1].name
			end,
			label = L["Echoes"],
			runningText = L["In Progress"],
			runningTextUpdater = function(args)
				local map = env.radiantEchoesZoneRotation[args:currentMapIndex()]
				local isCompleted = false
				for _, data in pairs(args.questProgress) do
					if data.mapID == map.mapID then
						if C_QuestLog_IsQuestFlaggedCompleted(data.questID) then
							isCompleted = true
						end
						break
					end
				end

				if not isCompleted then
					local iconTex = [[Interface\ICONS\Achievement_Quests_Completed_Daily_08]]
					return map.name .. " " .. F.GetTextureString(iconTex, 14, 14, true)
				end

				return map.name
			end,
			filter = function(args)
				if args.stopAlertIfPlayerNotEnteredDragonlands and not C_QuestLog_IsQuestFlaggedCompleted(67700) then
					return false
				end
				return true
			end,
			startTimestamp = (function()
				local timestampTable = {
					[1] = 1723269640, -- NA
					[2] = 1723266040, -- KR
					[3] = 1723262440, -- EU
					[4] = 1723266040, -- TW
					[5] = 1723266040, -- CN
					[72] = 1675767600,
				}

				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = worldMapIDSetter(function(args)
				return env.radiantEchoesZoneRotation[args:currentMapIndex()].mapID
			end),
			onClickHelpText = L["Click to show location"],
		},
	},
	CommunityFeast = {
		dbKey = "communityFeast",
		args = {
			icon = 4687629,
			type = "loopTimer",
			questIDs = { 70893 },
			hasWeeklyReward = true,
			duration = 16 * 60,
			interval = 1.5 * 60 * 60,
			barColor = colorPlatte.blue,
			flash = true,
			eventName = L["Community Feast"],
			location = C_Map_GetMapInfo(2024).name,
			label = L["Feast"],
			runningText = L["Cooking"],
			filter = function(args)
				if args.stopAlertIfPlayerNotEnteredDragonlands and not C_QuestLog_IsQuestFlaggedCompleted(67700) then
					return false
				end
				return true
			end,
			startTimestamp = (function()
				local timestampTable = {
					[1] = 1675765800, -- NA
					[2] = 1675767600, -- KR
					[3] = 1676017800, -- EU
					[4] = 1675767600, -- TW
					[5] = 1675767600, -- CN
					[72] = 1675767600,
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = worldMapIDSetter(2024),
			onClickHelpText = L["Click to show location"],
		},
	},
	SiegeOnDragonbaneKeep = {
		dbKey = "siegeOnDragonbaneKeep",
		args = {
			icon = 236469,
			type = "loopTimer",
			questIDs = { 70866 },
			hasWeeklyReward = true,
			duration = 10 * 60,
			interval = 2 * 60 * 60,
			eventName = L["Siege On Dragonbane Keep"],
			label = L["Dragonbane Keep"],
			location = C_Map_GetMapInfo(2022).name,
			barColor = colorPlatte.red,
			flash = true,
			runningText = L["In Progress"],
			filter = function(args)
				if args.stopAlertIfPlayerNotEnteredDragonlands and not C_QuestLog_IsQuestFlaggedCompleted(67700) then
					return false
				end
				return true
			end,
			startTimestamp = (function()
				local timestampTable = {
					[1] = 1670770800, -- NA
					[2] = 1670770800, -- KR
					[3] = 1670774400, -- EU
					[4] = 1670770800, -- TW
					[5] = 1670770800, -- CN
					[72] = 1670770800, -- TR
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = worldMapIDSetter(2022),
			onClickHelpText = L["Click to show location"],
		},
	},
	ResearchersUnderFire = {
		dbKey = "researchersUnderFire",
		args = {
			--icon = 3922918,
			icon = 5140835,
			type = "loopTimer",
			questIDs = { 75627, 75628, 75629, 75630 },
			hasWeeklyReward = true,
			duration = 25 * 60,
			interval = 1 * 60 * 60,
			eventName = L["Researchers Under Fire"],
			label = L["Researchers"],
			location = C_Map_GetMapInfo(2133).name,
			barColor = colorPlatte.green,
			flash = true,
			runningText = L["In Progress"],
			filter = function(args)
				if args.stopAlertIfPlayerNotEnteredDragonlands and not C_QuestLog_IsQuestFlaggedCompleted(67700) then
					return false
				end
				return true
			end,
			startTimestamp = (function()
				local timestampTable = {
					[1] = 1670333460, -- NA
					[2] = 1702240245, -- KR
					[3] = 1683804640, -- EU
					[4] = 1670704240, -- TW
					[5] = 1670704240, -- CN
					[72] = 1670702460, -- TR
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = worldMapIDSetter(2133),
			onClickHelpText = L["Click to show location"],
		},
	},
	TimeRiftThaldraszus = {
		dbKey = "timeRiftThaldraszus",
		args = {
			icon = 237538,
			type = "loopTimer",
			--questIDs = { 0 },
			hasWeeklyReward = false,
			duration = 15 * 60,
			interval = 1 * 60 * 60,
			eventName = L["Time Rift Thaldraszus"],
			label = L["Time Rift"],
			location = C_Map_GetMapInfo(2025).name,
			barColor = colorPlatte.bronze,
			flash = true,
			runningText = L["In Progress"],
			filter = function(args)
				if args.stopAlertIfPlayerNotEnteredDragonlands and not C_QuestLog_IsQuestFlaggedCompleted(67700) then
					return false
				end
				return true
			end,
			startTimestamp = (function()
				local timestampTable = {
					[1] = 1701831615, -- NA
					[2] = 1701853215, -- KR
					[3] = 1701828015, -- EU
					[4] = 1701824400, -- TW
					[5] = 1701824400, -- CN
					[72] = 1701852315, -- TR
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = worldMapIDSetter(2025),
			onClickHelpText = L["Click to show location"],
		},
	},
	SuperBloom = {
		dbKey = "superBloom",
		args = {
			icon = 3939983,
			type = "loopTimer",
			questIDs = { 78319 },
			hasWeeklyReward = true,
			duration = 15 * 60,
			interval = 1 * 60 * 60,
			eventName = L["Superbloom Emerald Dream"],
			label = L["Superbloom"],
			location = C_Map_GetMapInfo(2200).name,
			barColor = colorPlatte.green,
			flash = true,
			runningText = L["In Progress"],
			filter = function(args)
				if args.stopAlertIfPlayerNotEnteredDragonlands and not C_QuestLog_IsQuestFlaggedCompleted(67700) then
					return false
				end
				return true
			end,
			startTimestamp = (function()
				local timestampTable = {
					[1] = 1701828010, -- NA
					[2] = 1701828010, -- KR
					[3] = 1701828010, -- EU
					[4] = 1701828010, -- TW
					[5] = 1701828010, -- CN
					[72] = 1701828010, -- TR
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = worldMapIDSetter(2200),
			onClickHelpText = L["Click to show location"],
		},
	},
	BigDig = {
		dbKey = "bigDig",
		args = {
			icon = 4549135,
			type = "loopTimer",
			questIDs = { 79226 },
			hasWeeklyReward = true,
			duration = 15 * 60,
			interval = 1 * 60 * 60,
			eventName = L["The Big Dig"],
			label = L["Big Dig"],
			location = C_Map_GetMapInfo(2024).name,
			barColor = colorPlatte.purple,
			flash = true,
			runningText = L["In Progress"],
			filter = function(args)
				if args.stopAlertIfPlayerNotEnteredDragonlands and not C_QuestLog_IsQuestFlaggedCompleted(67700) then
					return false
				end
				return true
			end,
			startTimestamp = (function()
				local timestampTable = {
					-- need more accurate Timers
					[1] = 1701826200, -- NA
					[2] = 1701826200, -- KR
					[3] = 1701826200, -- EU
					[4] = 1701826200, -- TW
					[5] = 1701826200, -- CN
					[72] = 1701826200, -- TR
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = worldMapIDSetter(2024),
			onClickHelpText = L["Click to show location"],
		},
	},
	IskaaranFishingNet = {
		dbKey = "iskaaranFishingNet",
		args = {
			icon = 2159815,
			type = "triggerTimer",
			filter = function()
				return C_QuestLog_IsQuestFlaggedCompleted(70871)
			end,
			barColor = colorPlatte.purple,
			flash = true,
			eventName = L["Iskaaran Fishing Net"],
			label = L["Fishing Net"],
			events = {
				{
					"UNIT_SPELLCAST_SUCCEEDED",
					function(unit, _, spellID)
						if not unit or unit ~= "player" then
							return
						end

						local map = C_Map_GetBestMapForUnit("player")
						if not map then
							return
						end

						local position = C_Map_GetPlayerMapPosition(map, "player")

						if not position then
							return
						end

						local lengthMap = {}

						for i, netPos in ipairs(env.fishingNetPosition) do
							if map == netPos.map then
								local length = math_pow(position.x - netPos.x, 2) + math_pow(position.y - netPos.y, 2)
								lengthMap[i] = length
							end
						end

						local min
						local netIndex = 0
						for i, length in pairs(lengthMap) do
							if not min or length < min then
								min = length
								netIndex = i
							end
						end

						if not min or netIndex <= 0 then
							return
						end

						local db = ET:GetPlayerDB("iskaaranFishingNet")

						if spellID == 377887 then -- Get Fish
							if db[netIndex] then
								db[netIndex] = nil
							end
						elseif spellID == 377883 then -- Set Net
							E:Delay(0.5, function()
								local namePlates = C_NamePlate_GetNamePlates(true)
								if #namePlates > 0 then
									for _, namePlate in ipairs(namePlates) do
										if
											namePlate
											and namePlate.UnitFrame
											and namePlate.UnitFrame.WidgetContainer
										then
											local container = namePlate.UnitFrame.WidgetContainer
											if container.timerWidgets then
												for id, widget in pairs(container.timerWidgets) do
													if
														env.fishingNetWidgetIDToIndex[id]
														and env.fishingNetWidgetIDToIndex[id] == netIndex
													then
														if widget.Bar and widget.Bar.value and widget.Bar.range then
															db[netIndex] = {
																time = GetServerTime() + widget.Bar.value,
																duration = widget.Bar.range,
															}
														end
													end
												end
											end
										end
									end
								end
							end)
						end
					end,
				},
			},
			onClick = worldMapIDSetter(2024),
			onClickHelpText = L["Click to show location"],
		},
	},
}

local trackers = {
	pool = {},
}

function trackers:get(event)
	if self.pool[event] then
		self.pool[event]:Show()
		return self.pool[event]
	end

	local data = eventData[event]

	local frame = CreateFrame("Frame", "WTEventTracker" .. event, ET.frame)
	frame:SetSize(220, 30)

	frame.dbKey = data.dbKey
	frame.args = data.args

	if functionFactory[data.args.type] then
		local functions = functionFactory[data.args.type]

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
				functions.tooltip.onEnter(frame, data.args)
			end)

			frame:SetScript("OnLeave", function()
				functions.tooltip.onLeave(frame, data.args)
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

function trackers:disable(event)
	if self.pool[event] then
		self.pool[event]:Hide()
	end
end

ET.eventHandlers = {
	["PLAYER_ENTERING_WORLD"] = {
		function()
			E:Delay(10, function()
				ET.playerEnteredWorld = true
			end)
		end,
	},
}

function ET:HandlerEvent(event, ...)
	if self.eventHandlers[event] then
		for _, handler in ipairs(self.eventHandlers[event]) do
			handler(...)
		end
	end
end

function ET:AddEventHandler(event, handler)
	if not self.eventHandlers[event] then
		self.eventHandlers[event] = {}
	end

	tinsert(self.eventHandlers[event], handler)
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

	frame:SetHeight(30)
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
		self.frame:SetPoint("TOPLEFT", _G.WorldMapFrame, "BOTTOMLEFT", -2, -self.db.style.backdropYOffset)
		self.frame:SetPoint("TOPRIGHT", _G.WorldMapFrame, "BOTTOMRIGHT", 2, -self.db.style.backdropYOffset)

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
		self.frame:SetPoint("TOPLEFT", _G.WorldMapFrame.backdrop, "BOTTOMLEFT", 1, -self.db.style.backdropYOffset)
		self.frame:SetPoint("TOPRIGHT", _G.WorldMapFrame.backdrop, "BOTTOMRIGHT", -1, -self.db.style.backdropYOffset)

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
	for _, event in ipairs(eventList) do
		local data = eventData[event]
		local tracker = self.db[data.dbKey].enable and trackers:get(event) or trackers:disable(event)
		if tracker then
			if tracker.profileUpdate then
				tracker.profileUpdate()
			end

			tracker:SetSize(self.db.style.trackerWidth, self.db.style.trackerHeight)

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

			tracker:SetPoint(
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

	self.frame:SetHeight(
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

	for event in pairs(self.eventHandlers) do
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
