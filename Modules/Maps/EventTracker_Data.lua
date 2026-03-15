local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local C = W.Utilities.Color
local ET = W:GetModule("EventTracker") ---@class EventTracker

local _G = _G
local floor = floor
local format = format
local pairs = pairs
local tinsert = tinsert
local type = type

local GetCurrentRegion = GetCurrentRegion
local GetProfessionInfo = GetProfessionInfo
local GetProfessions = GetProfessions
local GetServerTime = GetServerTime

local C_Map_GetMapInfo = C_Map.GetMapInfo
local C_QuestLog_GetTitleForQuestID = C_QuestLog.GetTitleForQuestID
local C_QuestLog_IsOnQuest = C_QuestLog.IsOnQuest
local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted

local function GetWorldMapIDSetter(idOrFunc)
	return function(...)
		if not _G.WorldMapFrame or not _G.WorldMapFrame:IsShown() or not _G.WorldMapFrame.SetMapID then
			return
		end

		local id = type(idOrFunc) == "function" and idOrFunc(...) or idOrFunc
		_G.WorldMapFrame:SetMapID(id)
	end
end

ET.Meta = {
	radiantEchoesZoneRotation = { C_Map_GetMapInfo(32), C_Map_GetMapInfo(70), C_Map_GetMapInfo(115) },
	ProfessionsWeeklyMN = {
		[4620669] = 93690, -- 炼金术
		[4620670] = 93691, -- 锻造
		[4620672] = { 93698, 93699 }, -- 附魔
		[4620673] = 93692, -- 工程学
		[4620675] = { 93700, 93702, 93703, 93704 }, -- 草药学
		[4620676] = 93693, -- 铭文
		[4620677] = 93694, -- 珠宝
		[4620678] = 93695, -- 制皮
		[4620679] = { 93705, 93706, 93708, 93709 }, -- 采矿
		[4620680] = { 93710, 93711, 93714 }, -- 剥皮
		[4620681] = 93696, -- 裁缝
	},
}

---@alias EventTracker.ColorPalette table<string, [ColorTemplate, ColorTemplate]>
ET.ColorPalette = {
	blue = { "blue-500", "cyan-400" },
	red = { "rose-500", "red-400" },
	green = { "lime-400", "emerald-500" },
	purple = { "blue-600", "violet-500" },
	bronze = { "amber-400", "yellow-700" },
	running = { "teal-600", "emerald-400" },
	radiantEchoes = { "sky-400", "yellow-100" },
	gray = { "neutral-400", "neutral-700" },
	default = { "neutral-50", "neutral-200" },
}

---@alias EventKey
---|"WeeklyMN"
---|"ProfessionsWeeklyMN"
---|"StormarionAssault"
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

---@type EventKey[]
ET.EventList = {
	-- Midnight
	"WeeklyMN",
	"ProfessionsWeeklyMN",
	"StormarionAssault",
	-- TWW
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
}

---Gets the display name for a weekly event based on the provided iconID, name, and position.
---@param iconID number
---@param name string
---@param position? string|number
local function WeeklyName(iconID, name, position)
	local name = F.GetIconString(iconID, 14, 16, true) .. " " .. name
	if type(position) == "number" then
		position = C_Map_GetMapInfo(position).name
	end

	if position then
		name = format("%s (%s)", name, C.StringByTemplate(position, "cyan-400"))
	end

	return name
end

---@alias EventTracker.EventData { [EventKey]: table }
ET.EventData = {
	-- MN
	WeeklyMN = {
		dbKey = "weeklyMN",
		args = {
			icon = 236681,
			type = "weekly",
			questIDs = {
				[WeeklyName(7578704, L["Liadrin 4 > 1"], 2393)] = {
					-- https://www.wowhead.com/npc=256203/lady-liadrin
					93766, -- 至暗之夜：世界任务
					93767, -- 至暗之夜：奥术秘社
					93769, -- 至暗之夜：住宅
					93889, -- 至暗之夜：萨瑟利尔的聚会
					93890, -- 至暗之夜：丰饶
					93891, -- 至暗之夜：哈籁尼尔的传说
					93892, -- 至暗之夜：斯托玛兰突袭战
					93909, -- 至暗之夜：地下堡
					93910, -- 至暗之夜：狩猎
					93911, -- 至暗之夜：地下城
					93912, -- 至暗之夜：团队副本
					93913, -- 至暗之夜：世界首领
					94457, -- 至暗之夜：战场
				},
				[WeeklyName(5554512, L["Dungeon"], 2393)] = {
					-- https://www.wowhead.com/npc=256210/halduron-brightwing
					93751, -- 风行者之塔
					93752, -- 密谋小径
					93753, -- 魔导师平台
					93754, -- 迈萨拉洞窟
					93755, -- 纳洛拉克的洞穴
					93756, -- 夺目谷
					93757, -- 虚空之痕竞技场
					93758, -- 节点希纳斯
				},
				[WeeklyName(2066011, L["Soiree"], 2395)] = {
					-- https://www.wowhead.com/item=268489/surplus-bag-of-party-favors
					90573, -- 加固符文石：魔导师
					90574, -- 加固符文石：血骑士
					90575, -- 加固符文石：远行者
					90576, -- 加固符文石：径巷之影
				},
				[WeeklyName(7385004, L["Legend"], 2413)] = {
					-- https://www.wowhead.com/quest=89268
					89268, -- 失落的传说
				},
				[WeeklyName(7636650, L["Abundance"], 2437)] = {
					-- https://www.wowhead.com/quest=89507/abundant-offerings
					89507, -- 丰饶贡品
				},
			},
			questProgress = function(args)
				local questIDs = type(args.questIDs) == "function" and args:questIDs() or args.questIDs
				local progress = {}

				for storylineName, storylineQuests in pairs(questIDs) do
					local weeklyQuestID, status
					for _, questID in pairs(storylineQuests) do
						if C_QuestLog_IsQuestFlaggedCompleted(questID) then
							status = "completed"
							break
						end

						if C_QuestLog_IsOnQuest(questID) then
							weeklyQuestID = questID
							status = "inProgress"
							break
						end
					end

					local questName = weeklyQuestID and C_QuestLog_GetTitleForQuestID(weeklyQuestID)
					questName = questName and questName .. " - " or ""
					local rightText = status == "inProgress"
							and questName .. C.StringByTemplate(L["In Progress"], "yellow-400")
						or status == "completed" and questName .. C.StringByTemplate(L["Completed"], "green-500")
						or C.StringByTemplate(L["Not Accepted"], "rose-500")

					tinsert(progress, { label = storylineName, rightText = rightText })
				end

				return progress
			end,
			eventName = format("%s (%s)", L["Weekly Quest"], L["[ABBR] Midnight"]),
			location = C_Map_GetMapInfo(2537).name,
			label = format("%s (%s)", L["Weekly Quest"], L["[ABBR] Midnight"]),
			onClick = GetWorldMapIDSetter(2537),
			onClickHelpText = L["Click to show location"],
		},
	},
	ProfessionsWeeklyMN = {
		dbKey = "professionsWeeklyMN",
		args = {
			icon = 1392955,
			type = "weekly",
			questProgress = function()
				local prof1, prof2 = GetProfessions()
				local quests = {}

				for _, prof in pairs({ prof1, prof2 }) do
					if prof then
						local name, iconID = GetProfessionInfo(prof)
						local questData = ET.Meta.ProfessionsWeeklyMN[iconID]
						if questData then
							tinsert(quests, {
								questID = questData,
								label = F.GetIconString(iconID, 14, 14) .. " " .. name,
							})
						end
					end
				end

				return quests
			end,
			hasWeeklyReward = false,
			eventName = L["Professions Weekly"],
			location = C_Map_GetMapInfo(2393).name,
			label = L["Professions Weekly"],
			onClick = GetWorldMapIDSetter(2393),
			onClickHelpText = L["Click to show location"],
		},
	},
	StormarionAssault = {
		dbKey = "stormarionAssault",
		args = {
			icon = 7431083,
			type = "loopTimer",
			questIDs = { 90962 },
			hasWeeklyReward = true,
			duration = 15 * 60,
			interval = 30 * 60,
			eventName = L["Stormarion Assault"],
			label = L["Stormarion Assault"],
			location = C_Map_GetMapInfo(2405).name,
			flash = true,
			runningBarColor = ET.ColorPalette.purple,
			runningText = L["In Progress"],
			filter = function(args)
				if args.stopAlertIfPlayerNotEnteredMidnight and not C_QuestLog_IsQuestFlaggedCompleted(91281) then
					return false
				end
				return true
			end,
			startTimestamp = 1772728200,
			onClick = GetWorldMapIDSetter(2405),
			onClickHelpText = L["Click to show location"],
		},
	},
	-- TWW
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
			onClick = GetWorldMapIDSetter(2339),
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
			onClick = GetWorldMapIDSetter(2371),
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
					[90] = 1757134800, -- Midnight PTR
				}

				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = GetWorldMapIDSetter(2215),
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
			flash = true,
			runningBarColor = ET.ColorPalette.bronze,
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
					[90] = 1757134800, -- Midnight PTR
				}

				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = GetWorldMapIDSetter(2248),
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
			onClick = GetWorldMapIDSetter(2214),
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
			onClick = GetWorldMapIDSetter(2215),
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
			onClick = GetWorldMapIDSetter(2255),
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
					[72] = 1675767600, -- PTR
					[90] = 1675767600, -- Midnight PTR
				}

				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = GetWorldMapIDSetter(function(args)
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
			flash = true,
			runningBarColor = ET.ColorPalette.blue,
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
					[72] = 1675767600, -- PTR
					[90] = 1675767600, -- Midnight PTR
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = GetWorldMapIDSetter(2024),
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
			flash = true,
			runningBarColor = ET.ColorPalette.red,
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
					[72] = 1670770800, -- PTR
					[90] = 1670770800, -- Midnight PTR
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = GetWorldMapIDSetter(2022),
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
			flash = true,
			runningBarColor = ET.ColorPalette.green,
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
					[72] = 1670702460, -- PTR
					[90] = 1670702460, -- Midnight PTR
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = GetWorldMapIDSetter(2133),
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
			flash = true,
			runningBarColor = ET.ColorPalette.bronze,
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
					[72] = 1701852315, -- PTR
					[90] = 1701852315, -- Midnight PTR
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = GetWorldMapIDSetter(2025),
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
			flash = true,
			runningBarColor = ET.ColorPalette.green,
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
					[72] = 1701828010, -- PTR
					[90] = 1701828010, -- Midnight PTR
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = GetWorldMapIDSetter(2200),
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
			flash = true,
			runningBarColor = ET.ColorPalette.purple,
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
					[72] = 1701826200, -- PTR
					[90] = 1701826200, -- Midnight PTR
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and W.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)(),
			onClick = GetWorldMapIDSetter(2024),
			onClickHelpText = L["Click to show location"],
		},
	},
}
