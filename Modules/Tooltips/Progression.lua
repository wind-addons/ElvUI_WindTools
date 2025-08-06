local W, F, E, L = unpack((select(2, ...)))
local ET = E:GetModule("Tooltip")
local T = W.Modules.Tooltips
local Async = W.Utilities.Async

local _G = _G
local format = format
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local next = next
local pairs = pairs
local select = select
local sort = sort
local tinsert = tinsert
local tonumber = tonumber

local AchievementFrame_LoadUI = AchievementFrame_LoadUI
local ClearAchievementComparisonUnit = ClearAchievementComparisonUnit
local GetAchievementComparisonInfo = GetAchievementComparisonInfo
local GetComparisonStatistic = GetComparisonStatistic
local GetMaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion
local GetStatistic = GetStatistic
local GetTime = GetTime
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local MuteSoundFile = MuteSoundFile
local SetAchievementComparisonUnit = SetAchievementComparisonUnit
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitLevel = UnitLevel
local UnitName = UnitName
local UnmuteSoundFile = UnmuteSoundFile

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local MAX_PLAYER_LEVEL = GetMaxLevelForPlayerExpansion()

local starIconString = format("|T%s:0|t ", W.Media.Icons.star)

local comparingGUIDs = {}
local cache = {}

local inspectHistory = {}
local lastUpdatedPlayer = { guid = nil, name = nil }

local difficulties = {
	{ name = L["Raid Finder"], abbr = L["[ABBR] Raid Finder"], color = "ff8000" },
	{ name = L["Normal"], abbr = L["[ABBR] Normal"], color = "1eff00" },
	{ name = L["Heroic"], abbr = L["[ABBR] Heroic"], color = "0070dd" },
	{ name = L["Mythic"], abbr = L["[ABBR] Mythic"], color = "a335ee" },
}

local function AchievementFrameComparison_SetUnit(unit)
	T.comparisonLoaded = true
	lastUpdatedPlayer.guid = UnitGUID(unit)
	lastUpdatedPlayer.name = UnitName(unit)
end

local function OnAchievementShow(frame)
	-- It maybe closed by other addons, wait for a while to check if it is still open
	E:Delay(0.2, function()
		if not frame:IsShown() or InCombatLockdown() then
			return
		end

		local headerNameFrame = _G.AchievementFrameComparisonHeaderName
		local targetName = headerNameFrame and headerNameFrame:GetText()
		if not targetName then
			return
		end

		if targetName == lastUpdatedPlayer.name then
			local runTime = inspectHistory[lastUpdatedPlayer.guid] or 0
			if GetTime() - runTime < 1.5 then
				ClearAchievementComparisonUnit()
				HideUIPanel(frame)
			end
		end
	end)
end

local function SortTableWithID(tbl)
	sort(tbl, function(a, b)
		return a[1] < b[1]
	end)
end

local function GetBossKillTimes(guid, achievementID)
	local func = guid == E.myguid and GetStatistic or GetComparisonStatistic
	return tonumber(func(achievementID), 10) or 0
end

local function UpdateSpecialAchievement(guid, id, completed, month, day, year)
	local completedString = "|cff888888" .. L["Not Completed"] .. "|r"
	if completed then
		completedString = gsub(L["%month%-%day%-%year%"], "%%year%%", 2000 + year)
		completedString = gsub(completedString, "%%month%%", month)
		completedString = gsub(completedString, "%%day%%", day)
	end
	cache[guid].info.special[id] = completedString
end

local function UpdateProgression(guid, unit)
	local db = E.private.WT.tooltips.progression

	cache[guid] = cache[guid] or {}
	cache[guid].info = cache[guid].info or {}
	cache[guid].timer = GetTime()

	-- Achievements
	if db.specialAchievement.enable then
		cache[guid].info.special = {}
		for id in pairs(W.MythicPlusSeasonAchievementData) do
			if db.specialAchievement[id] then
				if guid == E.myguid then
					Async.WithAchievementID(id, function(data)
						UpdateSpecialAchievement(guid, id, data[4], data[5], data[6], data[7])
					end)
				else
					inspectHistory[guid] = GetTime()
					UpdateSpecialAchievement(guid, id, GetAchievementComparisonInfo(id))
				end
			end
		end
	end

	-- Raid
	if db.raid.enable then
		cache[guid].info.raids = {}
		for id in pairs(W.RaidData) do
			if db.raid[id] then
				local tempInfo = {}
				local bosses = W.RaidData[id].achievements
				for difficulty = #bosses, 1, -1 do
					local alreadyKilled = 0
					for _, achievementID in pairs(bosses[difficulty]) do
						if GetBossKillTimes(guid, achievementID) > 0 then
							alreadyKilled = alreadyKilled + 1
						end
					end

					if alreadyKilled > 0 then
						tempInfo[difficulty] = format("%d/%d", alreadyKilled, #bosses[difficulty])
						if alreadyKilled == #bosses[difficulty] then
							break -- It is not necessary to check the next level if all bosses are killed
						end
					end
				end

				if next(tempInfo) then
					cache[guid].info.raids[id] = tempInfo
				end
			end
		end
	end

	-- Mythic Plus
	if db.mythicPlus.enable then
		cache[guid].info.mythicPlus = {}
		local data = T:GetMythicPlusData(unit)
		if data then
			for _, run in pairs(data.runs) do
				local bestRunLevelText = format("|cff%s%s|r", run.bestRunLevelColor, run.bestRunLevel)
				if run.upgrades and run.upgrades > 0 then
					for _ = 1, run.upgrades do
						bestRunLevelText = "+" .. bestRunLevelText
					end
				end
				cache[guid].info.mythicPlus[run.challengeModeID] =
					format("%s %s", bestRunLevelText, run.mapScoreColor:WrapTextInColorCode(run.mapScore))
			end

			cache[guid].info.mythicPlus.highestScoreDungeonID = data.highestScoreDungeonID
		end
	end
end

local function SetProgressionInfo(tt, guid)
	if not cache[guid] then
		return
	end

	local db = E.private.WT.tooltips.progression

	-- Special Achievement
	if db.specialAchievement.enable and cache[guid].info.special and next(cache[guid].info.special) then
		tt:AddLine(" ")
		if db.header == "TEXTURE" then
			tt:AddLine(F.GetCustomHeader("SpecialAchievements", 0.618), 0, 0, true)
		elseif db.header == "TEXT" then
			tt:AddLine(L["Special Achievements"])
		end

		local lines = {}

		for id, data in pairs(W.MythicPlusSeasonAchievementData) do
			if db.specialAchievement[id] then
				local left = format(
					"%s %s",
					F.GetIconString(data.tex, ET.db.textFontSize, ET.db.textFontSize + 3, true),
					data.abbr
				)
				local right = cache[guid].info.special[id]

				if right then
					tinsert(lines, { data.sortIndex, left, right })
				end
			end
		end

		SortTableWithID(lines)

		for _, line in ipairs(lines) do
			tt:AddDoubleLine(line[2], line[3], nil, nil, nil, 1, 1, 1)
		end
	end

	-- Raid
	if db.raid.enable and cache[guid].info.raids and next(cache[guid].info.raids) then
		tt:AddLine(" ")
		if db.header == "TEXTURE" then
			tt:AddLine(F.GetCustomHeader("Raids", 0.618), 0, 0, true)
		elseif db.header == "TEXT" then
			tt:AddLine(L["Raids"])
		end

		local lines = {}
		for id, data in pairs(W.RaidData) do
			if db.raid[id] and cache[guid].info.raids[id] then
				local group = {}
				for difficulty = #W.RaidData[id].achievements, 1, -1 do
					if cache[guid].info.raids[id] and cache[guid].info.raids[id][difficulty] then
						local diff = difficulties[difficulty]
						local left = format(
							"%s %s |cff%s%s|r",
							F.GetIconString(data.tex, ET.db.textFontSize, ET.db.textFontSize + 3, true),
							data.abbr,
							diff.color,
							diff.name
						)

						local right = format("|cff%s%s|r", diff.color, diff.abbr)
							.. " "
							.. cache[guid].info.raids[id][difficulty]
						tinsert(group, { left, right })
					end
				end

				tinsert(lines, { id, group })
			end
		end

		SortTableWithID(lines)

		for _, line in ipairs(lines) do
			for _, group in ipairs(line[2]) do
				tt:AddDoubleLine(group[1], group[2], nil, nil, nil, 1, 1, 1)
			end
		end
	end

	-- Mythic Plus
	local displayMythicPlus = false
	if db.mythicPlus.showNoRecord then
		displayMythicPlus = true
	else
		for name, _ in pairs(cache[guid].info.mythicPlus) do
			if db.mythicPlus[name] then
				displayMythicPlus = true
				break
			end
		end
	end

	if db.mythicPlus.enable and cache[guid].info.mythicPlus and displayMythicPlus then
		local highestScoreDungeonID = cache[guid].info.mythicPlus.highestScoreDungeonID

		tt:AddLine(" ")
		if db.header == "TEXTURE" then
			tt:AddLine(F.GetCustomHeader("MythicPlus", 0.618), 0, 0, true)
		elseif db.header == "TEXT" then
			tt:AddLine(L["Mythic Dungeons"])
		end

		local lines = {}

		for id, data in pairs(W.MythicPlusMapData) do
			if db.mythicPlus[id] then
				local left = format(
					"%s %s",
					F.GetIconString(data.tex, ET.db.textFontSize, ET.db.textFontSize + 3, true),
					data.abbr
				)
				local right = cache[guid].info.mythicPlus[id]

				if not right and db.mythicPlus.showNoRecord then
					right = "|cff888888" .. L["No Record"] .. "|r"
				end

				if right then
					if db.mythicPlus.markHighestScore and highestScoreDungeonID and highestScoreDungeonID == id then
						right = starIconString .. right
					end
					tinsert(lines, { id, left, right })
				end
			end
		end

		SortTableWithID(lines)

		for _, line in ipairs(lines) do
			tt:AddDoubleLine(line[2], line[3], nil, nil, nil, 1, 1, 1)
		end
	end
end

function T:Progression(tt, unit, guid)
	if not E.private.WT.tooltips.progression.enable then
		return
	end

	if E.private.WT.tooltips.progression.disableInCombat and InCombatLockdown() then
		return
	end

	local level = UnitLevel(unit)
	if not level or not level == MAX_PLAYER_LEVEL then
		return
	end

	if not cache[guid] or (GetTime() - cache[guid].timer) > 120 then
		if guid == E.myguid then
			UpdateProgression(guid, unit)
		else
			ClearAchievementComparisonUnit()

			if not self.comparisonLoaded and select(2, C_AddOns_IsAddOnLoaded("Blizzard_AchievementUI")) then
				MuteSoundFile(567511)
				MuteSoundFile(567509)
				_G.AchievementFrame_DisplayComparison(unit)
				ClearAchievementComparisonUnit()
				HideUIPanel(_G.AchievementFrame)
				E:Delay(0.5, function()
					UnmuteSoundFile(567511)
					UnmuteSoundFile(567509)
					HideUIPanel(_G.AchievementFrame)
				end)
			end

			comparingGUIDs[guid] = true

			if SetAchievementComparisonUnit(unit) then
				T:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
			end

			return
		end
	end

	SetProgressionInfo(tt, guid)
end

function T:INSPECT_ACHIEVEMENT_READY(_, guid)
	self:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")

	if not comparingGUIDs[guid] then
		return
	end

	comparingGUIDs[guid] = nil

	local unit = "mouseover"

	if UnitExists(unit) then
		UpdateProgression(guid, unit)
		_G.GameTooltip:SetUnit(unit)
	end

	comparingGUIDs[guid] = nil

	ClearAchievementComparisonUnit()
end

function T:AchievementFrameComparison_UpdateStatusBars(id)
	if id and id == "summary" then
		return
	end
	self.hooks.AchievementFrameComparison_UpdateStatusBars(id)
end

function T:InitializeProgression()
	if not E.private.WT.tooltips.progression.enable then
		return
	end

	if not C_AddOns_IsAddOnLoaded("Blizzard_AchievementUI") then
		AchievementFrame_LoadUI()
		if select(2, C_AddOns_IsAddOnLoaded("Blizzard_AchievementUI")) then
			self:RawHook("AchievementFrameComparison_UpdateStatusBars", true)
		end
	end

	hooksecurefunc("AchievementFrameComparison_SetUnit", AchievementFrameComparison_SetUnit)
	hooksecurefunc(_G.AchievementFrame, "Show", OnAchievementShow)
	hooksecurefunc(_G.AchievementFrame, "SetShown", OnAchievementShow)
end

T:AddInspectInfoCallback(2, "Progression", true)
T:AddCallback("InitializeProgression")
