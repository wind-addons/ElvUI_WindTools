local W ---@class WindTools
local F ---@type Functions
local E, L ---@type table, table
W, F, E, L = unpack((select(2, ...)))

local pairs = pairs
local tinsert = tinsert
local tostring = tostring

local GetCurrentRegionName = GetCurrentRegionName
local GetLFGDungeonInfo = GetLFGDungeonInfo
local GetLocale = GetLocale
local GetMaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion
local GetRealmID = GetRealmID
local GetRealmName = GetRealmName
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID

local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_CVar_GetCVarBool = C_CVar.GetCVarBool

E.myClassColor = E.myClassColor or E:ClassColor(E.myclass, true)

-- WindTools
W.Title = L["WindTools"]
W.PlainTitle = gsub(W.Title, "|c........([^|]+)|r", "%1")

-- Environment
W.Locale = GetLocale()
W.ChineseLocale = strsub(W.Locale, 0, 2) == "zh"
W.AsianLocale = W.ChineseLocale or W.Locale == "koKR"
W.SupportElvUIVersion = 13.97
W.UseKeyDown = C_CVar_GetCVarBool("ActionButtonUseKeyDown")

-- Game
W.MaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion()

-- Mythic+
W.MythicPlusMapData = {
	-- https://wago.tools/db2/MapChallengeMode
	-- https://wago.tools/db2/GroupFinderActivityGrp
	[378] = { abbr = L["[ABBR] Halls of Atonement"], activityID = 261, timers = { 1152, 1536, 1920 } },
	[391] = { abbr = L["[ABBR] Tazavesh: Streets of Wonder"], activityID = 280, timers = { 1152, 1536, 1920 } },
	[392] = { abbr = L["[ABBR] Tazavesh: So'leah's Gambit"], activityID = 281, timers = { 1080, 1440, 1800 } },
	[499] = { abbr = L["[ABBR] Priory of the Sacred Flame"], activityID = 324, timers = { 1170, 1560, 1950 } },
	[503] = { abbr = L["[ABBR] Ara-Kara, City of Echoes"], activityID = 323, timers = { 1080, 1440, 1800 } },
	[505] = { abbr = L["[ABBR] The Dawnbreaker"], activityID = 326, timers = { 1116, 1488, 1860 } },
	[525] = { abbr = L["[ABBR] Operation: Floodgate"], activityID = 371, timers = { 1188, 1584, 1980 } },
	[542] = { abbr = L["[ABBR] Eco-Dome Al'dani"], activityID = 381, timers = { 1116, 1488, 1860 } },
}

-- Histories (for localization)
-- [247] = { abbr = L["[ABBR] The MOTHERLODE!!"], activityID = 140, timers = { 1188, 1584, 1980 } },
-- [370] = { abbr = L["[ABBR] Operation: Mechagon - Workshop"], activityID = 257, timers = { 1118, 1536, 1920 } },
-- [382] = { abbr = L["[ABBR] Theater of Pain"], activityID = 266, timers = { 1224, 1632, 2040 } },
-- [499] = { abbr = L["[ABBR] Priory of the Sacred Flame"], activityID = 324, timers = { 1170, 1560, 1950 } },
-- [500] = { abbr = L["[ABBR] The Rookery"], activityID = 325, timers = { 1044, 1392, 1740 } },
-- [504] = { abbr = L["[ABBR] Darkflame Cleft"], activityID = 322, timers = { 1116, 1488, 1860 } },
-- [506] = { abbr = L["[ABBR] Cinderbrew Meadery"], activityID = 327, timers = { 1188, 1584, 1980 } },
-- [525] = { abbr = L["[ABBR] Operation: Floodgate"], activityID = 371, timers = { 1188, 1584, 1980 } },
-- [501] = { abbr = L["[ABBR] The Stonevault"], activityID = 328, timers = { 1188, 1584, 1980 } },
-- [502] = { abbr = L["[ABBR] City of Threads"], activityID = 329, timers = { 1260, 1680, 2100 } },
-- [503] = { abbr = L["[ABBR] Ara-Kara, City of Echoes"], activityID = 323, timers = { 1080, 1440, 1800 } },
-- [505] = { abbr = L["[ABBR] The Dawnbreaker"], activityID = 326, timers = { 1116, 1488, 1860 } },

W.MythicPlusSeasonAchievementData = {
	[20525] = { sortIndex = 1, abbr = L["[ABBR] The War Within Keystone Master: Season One"] },
	[20526] = { sortIndex = 2, abbr = L["[ABBR] The War Within Keystone Hero: Season One"] },
	[41533] = { sortIndex = 3, abbr = L["[ABBR] The War Within Keystone Master: Season Two"] },
	[40952] = { sortIndex = 4, abbr = L["[ABBR] The War Within Keystone Hero: Season Two"] },
	[41973] = { sortIndex = 5, abbr = L["[ABBR] The War Within Keystone Master: Season Three"] },
	[42171] = { sortIndex = 6, abbr = L["[ABBR] The War Within Keystone Hero: Season Three"] },
	[42172] = { sortIndex = 7, abbr = L["[ABBR] The War Within Keystone Legend: Season Three"] },
}

-- https://www.wowhead.com/achievements/character-statistics/dungeons-and-raids/the-war-within/
-- var a=""; document.querySelectorAll("tbody.clickable > tr a.listview-cleartext").forEach((h) => a+=h.href.match(/achievement=([0-9]*)/)[1]+',');console.log(a);
-- ID: https://wago.tools/db2/LFGDungeons?filter%5BTypeID%5D=2&filter%5BSubtype%5D=2&page=5
W.RaidData = {
	[2645] = {
		abbr = L["[ABBR] Nerub-ar Palace"],
		tex = 5779391,
		achievements = {
			{ 40267, 40271, 40275, 40279, 40283, 40287, 40291, 40295 },
			{ 40268, 40272, 40276, 40280, 40284, 40288, 40292, 40296 },
			{ 40269, 40273, 40277, 40281, 40285, 40289, 40293, 40297 },
			{ 40270, 40274, 40278, 40282, 40286, 40290, 40294, 40298 },
		},
	},
	[2779] = {
		abbr = L["[ABBR] Liberation of Undermine"],
		tex = 6422371,
		achievements = {
			{ 41299, 41303, 41307, 41311, 41315, 41319, 41323, 41327 },
			{ 41300, 41304, 41308, 41312, 41316, 41320, 41324, 41328 },
			{ 41301, 41305, 41309, 41313, 41317, 41321, 41325, 41329 },
			{ 41302, 41306, 41310, 41314, 41318, 41322, 41326, 41330 },
		},
	},
	[2805] = {
		abbr = L["[ABBR] Manaforge Omega"],
		tex = 7049159,
		achievements = {
			-- from NDui_Plus
			{ 41633, 41637, 41641, 41645, 41649, 41653, 41657, 41661 },
			{ 41634, 41638, 41642, 41646, 41650, 41654, 41658, 41662 },
			{ 41635, 41639, 41643, 41647, 41651, 41655, 41659, 41663 },
			{ 41636, 41640, 41644, 41648, 41652, 41656, 41660, 41664 },
		},
	},
}

W.SpecializationInfo = {}

W.RealRegion = (function()
	local region = GetCurrentRegionName()
	if region == "KR" and W.ChineseLocale then
		region = "TW" -- Fix taiwan server region issue
	end

	return region
end)()

W.CurrentRealmID = GetRealmID()
W.CurrentRealmName = GetRealmName()

function W:InitializeMetadata()
	for id in pairs(W.MythicPlusMapData) do
		local name, _, timeLimit, tex = C_ChallengeMode_GetMapUIInfo(id)
		W.MythicPlusMapData[id].name = name
		W.MythicPlusMapData[id].tex = tex
		W.MythicPlusMapData[id].idString = tostring(id)
		W.MythicPlusMapData[id].timeLimit = timeLimit
		if W.MythicPlusMapData[id].timers then
			W.MythicPlusMapData[id].timers[#W.MythicPlusMapData[id].timers] = timeLimit
		end

		-- debug: print mythic+ map data
		-- E:Delay(3, function()
		-- 	print("MythicPlusMapData", id, name, "Tex:", F.GetTextureString(tex, 16, 16, true))
		-- 	for i, timer in pairs(W.MythicPlusMapData[id].timers) do
		-- 		local mm = floor(timer / 60)
		-- 		local ss = timer % 60
		-- 		print("  Timer", i, ":", format("%02d:%02d", mm, ss))
		-- 	end
		-- end)
	end

	for id in pairs(W.MythicPlusSeasonAchievementData) do
		W.Utilities.Async.WithAchievementID(id, function(data)
			W.MythicPlusSeasonAchievementData[id].name = data[2]
			W.MythicPlusSeasonAchievementData[id].tex = data[10]
			W.MythicPlusSeasonAchievementData[id].idString = tostring(id)
		end)
	end

	for id in pairs(W.RaidData) do
		local result = { GetLFGDungeonInfo(id) }
		W.RaidData[id].name = result[1]
		W.RaidData[id].idString = tostring(id)
	end

	for classID = 1, 13 do
		local class = {}
		for specIndex = 1, 4 do
			local data = { GetSpecializationInfoForClassID(classID, specIndex) }
			if #data > 0 then
				tinsert(class, { specID = data[1], name = data[2], icon = data[4], role = data[5] })
			end
		end

		tinsert(W.SpecializationInfo, class)
	end

	-- debug: check all achievements
	-- for i, data in ipairs(W.RaidData[2805].achievements) do
	-- 	for j, id in ipairs(data) do
	-- 		W.Utilities.Async.WithAchievementID(id, function(data)
	-- 			E:Delay(1.3 * (i - 1) + j * 0.1, print, data[1], data[2])
	-- 		end)
	-- 	end
	-- end
end
