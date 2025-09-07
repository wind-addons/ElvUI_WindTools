local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local C = W.Utilities.Color
local ET = W:GetModule("EventTracker") ---@class EventTracker

local _G = _G
local type = type
local floor = floor
local format = format
local ipairs = ipairs
local pairs = pairs
local tinsert = tinsert
local math_pow = math.pow

local GetCurrentRegion = GetCurrentRegion
local GetServerTime = GetServerTime
local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo

local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_Map_GetMapInfo = C_Map.GetMapInfo
local C_Map_GetPlayerMapPosition = C_Map.GetPlayerMapPosition
local C_NamePlate_GetNamePlates = C_NamePlate.GetNamePlates
local C_QuestLog_GetTitleForQuestID = C_QuestLog.GetTitleForQuestID
local C_QuestLog_IsOnQuest = C_QuestLog.IsOnQuest
local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted

local function worldMapIDSetter(idOrFunc)
	return function(...)
		if not _G.WorldMapFrame or not _G.WorldMapFrame:IsShown() or not _G.WorldMapFrame.SetMapID then
			return
		end

		local id = type(idOrFunc) == "function" and idOrFunc(...) or idOrFunc
		_G.WorldMapFrame:SetMapID(id)
	end
end

ET.Meta = {
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
	ProfessionsTWW = {
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

---@type table<string, RGBA[]>
ET.ColorPalette = {
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

---@alias EventKey
---|"ProfessionsWeeklyTWW"
---|"WeeklyTWW"
---|"EcologicalSuccession"
---|"Nightfall"
---|"TheaterTroupe"
---|"RingingDeeps"
---|"SpreadingTheLight"
---|"UnderworldOperative"
---|"RadiantEchoes"
---|"CommunityFeast"
---|"SiegeOnDragonbaneKeep"
---|"ResearchersUnderFire"
---|"TimeRiftThaldraszus"
---|"SuperBloom"
---|"BigDig"
---|"IskaaranFishingNet"

---@type EventKey[]
ET.EventList = {
	-- TWW
	-- "ProfessionsWeeklyTWW",
	"WeeklyTWW",
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

---@type { [EventKey]: table }
ET.EventData = {
	-- TWW
	ProfessionsWeeklyTWW = {
		dbKey = "professionsWeeklyTWW",
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
							questID = ET.Meta.ProfessionsWeeklyTWW[iconID],
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
	WeeklyTWW = {
		dbKey = "weeklyTWW",
		args = {
			icon = 236681,
			type = "weekly",
			questIDs = {
				[F.GetIconString(6025441, 14, 16, true) .. " " .. L["Delves Weekly"]] = {
					82706, -- 探究：世界性研究
					82708, -- 豐碩探究
					82709, -- 豐碩探究
					82710, -- 豐碩探究
					82711, -- 豐碩探究
					82712, -- 豐碩探究
					82746, -- 豐碩探究
				},
				[F.GetIconString(1411833, 14, 16, true) .. " " .. L["Archives Weekly"]] = {
					82678, -- 文庫：第一張圓盤
					82679, -- 文庫：尋覓歷史
				},
				[F.GetIconString(134015, 14, 16, true) .. " " .. L["Weekend Event"]] = {
					83345, -- 戰鬥的呼喚
					83347, -- 征戰使節
					83357, -- 箇中翹楚
					83358, -- 競技場的呼喚
					83359, -- 穿越時光的破碎之路
					83360, -- 穿越時光的魔化之路
					83362, -- 穿越時光的隱蔽之路
					83363, -- 穿越時光的燃燒之路
					83364, -- 穿越時光的破碎之路
					83365, -- 穿越時光的冰封之路
					83366, -- 世界任務正等著你
					84776, -- 來探究吧
				},
				[F.GetIconString(5554512, 14, 16, true) .. " " .. L["Dungeon Weekly"]] = {
					-- https://www.wowhead.com/npc=226623/biergoth
					83432, -- 培育所
					83436, -- 燼釀酒莊
					83443, -- 暗焰裂縫
					83457, -- 石庫
					83458, -- 聖焰隱修院
					83459, -- 破曉者號
					83465, -- 『回音之城』厄拉卡拉
					83469, -- 蛛絲城
					86203, -- 水閘行動
				},
			},
			questProgress = function(args)
				local questIDs = type(args.questIDs) == "function" and args:questIDs() or args.questIDs
				local progress = {}

				for storylineName, storylineQuests in pairs(questIDs) do
					local weeklyQuestID, status
					for _, questID in pairs(storylineQuests) do
						if C_QuestLog_IsQuestFlaggedCompleted(questID) then
							weeklyQuestID = questID
							status = "completed"
							break
						end

						if C_QuestLog_IsOnQuest(questID) then
							weeklyQuestID = questID
							status = "inProgress"
							break
						end
					end

					local rightText = ""
					local questName = weeklyQuestID and C_QuestLog_GetTitleForQuestID(weeklyQuestID)

					if questName then
						if status == "inProgress" then
							rightText = format("%s - %s", questName, C.StringByTemplate(L["In Progress"], "yellow-400"))
						elseif status == "completed" then
							rightText = format("%s - %s", questName, C.StringByTemplate(L["Completed"], "green-500"))
						end
					else
						rightText = C.StringByTemplate(L["Not Accepted"], "rose-500")
					end

					tinsert(progress, { label = storylineName, rightText = rightText })
				end

				return progress
			end,
			eventName = format("%s (%s)", L["Weekly Quest"], L["[ABBR] The War Within"]),
			location = C_Map_GetMapInfo(2339).name,
			label = format("%s (%s)", L["Weekly Quest"], L["[ABBR] The War Within"]),
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
				91173, -- 聖焰不滅
			},
			hasWeeklyReward = true,
			duration = 15 * 60,
			interval = 60 * 60,
			barColor = ET.ColorPalette.blue,
			flash = true,
			runningBarColor = ET.ColorPalette.purple,
			eventName = L["Nightfall"],
			location = C_Map_GetMapInfo(2215).name,
			label = L["Nightfall"],
			runningText = L["Running"],
			startTimestamp = (function()
				local timestampTable = {
					[1] = 1757134800, -- NA
					[2] = 1757134800, -- KR
					[3] = 1757134800, -- EU
					[4] = 1757134800, -- TW
					[5] = 1757134800, -- CN
					[72] = 1757134800, -- PTR
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
			barColor = ET.ColorPalette.bronze,
			flash = true,
			runningBarColor = ET.ColorPalette.green,
			eventName = L["Theater Troupe"],
			location = C_Map_GetMapInfo(2248).name,
			label = L["Theater Troupe"],
			runningText = L["Performing"],
			startTimestamp = (function()
				local timestampTable = {
					[1] = 1757134800, -- NA
					[2] = 1757134800, -- KR
					[3] = 1757134800, -- EU
					[4] = 1757134800, -- TW
					[5] = 1757134800, -- CN
					[72] = 1757134800, -- PTR
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
							C.StringByTemplate(ET.Meta.radiantEchoesZoneRotation[1].name, "sky-400")
						)
					end,
				},
				{
					questID = 82676,
					mapID = 70,
					label = function()
						return format(
							L["Daily Quest at %s"],
							C.StringByTemplate(ET.Meta.radiantEchoesZoneRotation[2].name, "sky-400")
						)
					end,
				},
				{
					questID = 82689,
					mapID = 115,
					label = function()
						return format(
							L["Daily Quest at %s"],
							C.StringByTemplate(ET.Meta.radiantEchoesZoneRotation[3].name, "sky-400")
						)
					end,
				},
			},
			questIDs = { 82676, 82689, 78938 },
			hasWeeklyReward = false,
			duration = 60 * 60, -- always on
			interval = 60 * 60,
			barColor = ET.ColorPalette.blue,
			flash = false,
			runningBarColor = ET.ColorPalette.radiantEchoes,
			eventName = L["Radiant Echoes"],
			currentMapIndex = function(args)
				return floor((GetServerTime() - args.startTimestamp) / args.interval) % 3 + 1
			end,
			currentLocation = function(args)
				return ET.Meta.radiantEchoesZoneRotation[args:currentMapIndex()].name
			end,
			nextLocation = function(args)
				return ET.Meta.radiantEchoesZoneRotation[args:currentMapIndex() % 3 + 1].name
			end,
			label = L["Echoes"],
			runningText = L["In Progress"],
			runningTextUpdater = function(args)
				local map = ET.Meta.radiantEchoesZoneRotation[args:currentMapIndex()]
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
				return ET.Meta.radiantEchoesZoneRotation[args:currentMapIndex()].mapID
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
			barColor = ET.ColorPalette.blue,
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
			barColor = ET.ColorPalette.red,
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
			barColor = ET.ColorPalette.green,
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
			barColor = ET.ColorPalette.bronze,
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
			barColor = ET.ColorPalette.green,
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
			barColor = ET.ColorPalette.purple,
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
			barColor = ET.ColorPalette.purple,
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

						for i, netPos in ipairs(ET.Meta.fishingNetPosition) do
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

						local db = ET:GetPlayerDB("iskaaranFishingNet") --[[@as table]]

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
														ET.Meta.fishingNetWidgetIDToIndex[id]
														and ET.Meta.fishingNetWidgetIDToIndex[id] == netIndex
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
