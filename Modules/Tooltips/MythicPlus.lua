local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local ET = E:GetModule("Tooltip")
local T = W.Modules.Tooltips

local format = format
local strrep = strrep
local time = time
local pairs = pairs

local UnitGUID = UnitGUID

local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local C_ChallengeMode_GetSpecificDungeonOverallScoreRarityColor =
	C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor
local C_PlayerInfo_GetPlayerMythicPlusRatingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary

local HIGHLIGHT_FONT_COLOR = HIGHLIGHT_FONT_COLOR

local mythicPlusDataCache = {}

function T:GetMythicPlusData(unit)
	local guid = UnitGUID(unit)
	if not guid then
		return
	end
	local now = time()
	if mythicPlusDataCache[guid] and now - mythicPlusDataCache[guid].updated < 60 then
		return mythicPlusDataCache[guid]
	end

	local data = C_PlayerInfo_GetPlayerMythicPlusRatingSummary(unit)
	if not data then
		return
	end
	data.updated = now

	if data and data.runs then
		local highestScore, highestScoreDungeonID, highestScoreDungeonIndex
		for i, run in pairs(data.runs) do
			local metadata = W.MythicPlusMapData[run.challengeModeID]

			if not highestScore or run.mapScore > highestScore then
				highestScore = run.mapScore
				highestScoreDungeonID = run.challengeModeID
				highestScoreDungeonIndex = i
			end

			if metadata and metadata.timers then
				local sec = run.bestRunDurationMS / 1000
				local timers = metadata.timers
				run.upgrades = (sec <= timers[1] and 3) or (sec <= timers[2] and 2) or (run.finishedSuccess and 1) or 0
			end

			run.mapScoreColor = C_ChallengeMode_GetSpecificDungeonOverallScoreRarityColor(run.mapScore)
				or HIGHLIGHT_FONT_COLOR
			run.bestRunLevelColor = run.finishedSuccess and "ffffff" or "aaaaaa"
		end

		if highestScore then
			data.highestScoreDungeonID = highestScoreDungeonID
			data.highestScoreDungeonIndex = highestScoreDungeonIndex
		end
	end

	data.currentSeasonScoreColor = (
		ET.db.dungeonScoreColor and C_ChallengeMode_GetDungeonScoreRarityColor(data.currentSeasonScore)
	) or HIGHLIGHT_FONT_COLOR

	mythicPlusDataCache[guid] = data
	return data
end

function T:AddMythicInfo(mod, tt, unit)
	local db = self.profiledb and self.profiledb.elvUITweaks and self.profiledb.elvUITweaks.betterMythicPlusInfo

	if not db or not db.enable then
		return self.hooks[mod].AddMythicInfo(mod, tt, unit)
	end

	local data = self:GetMythicPlusData(unit)
	if not data or not data.currentSeasonScore or data.currentSeasonScore <= 0 then
		return self.hooks[mod].AddMythicInfo(mod, tt, unit)
	end

	if ET.db.dungeonScore then
		tt:AddDoubleLine(
			L["M+ Score"],
			data.currentSeasonScore,
			nil,
			nil,
			nil,
			data.currentSeasonScoreColor.r,
			data.currentSeasonScoreColor.g,
			data.currentSeasonScoreColor.b
		)
	end

	if ET.db.mythicBestRun then
		local mapData = data.highestScoreDungeonID and W.MythicPlusMapData[data.highestScoreDungeonID]
		local run = data.highestScoreDungeonIndex and data.runs and data.runs[data.highestScoreDungeonIndex]
		if mapData and run then
			local bestRunLevelText
			if run.finishedSuccess and run.mapScoreColor then
				bestRunLevelText = run.mapScoreColor:WrapTextInColorCode(run.bestRunLevel)
			else
				bestRunLevelText = format("|cff%s%s|r", run.bestRunLevelColor, run.bestRunLevel)
			end
			if bestRunLevelText then
				if run.upgrades and run.upgrades > 0 then
					bestRunLevelText = strrep("+", run.upgrades) .. bestRunLevelText
				end

				local right =
					format("%s %s", F.CreateColorString(mapData.abbr, E.db.general.valuecolor), bestRunLevelText)

				if db.icon.enable then
					local iconString = F.GetIconString(mapData.tex, db.icon.height, db.icon.width, true)
					right = iconString .. " " .. right
				end
				tt:AddDoubleLine(
					L["M+ Best Run"],
					right,
					nil,
					nil,
					nil,
					HIGHLIGHT_FONT_COLOR.r,
					HIGHLIGHT_FONT_COLOR.g,
					HIGHLIGHT_FONT_COLOR.b
				)
			end
		end
	end
end
