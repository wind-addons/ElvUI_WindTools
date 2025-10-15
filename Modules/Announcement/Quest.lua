local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local A = W:GetModule("Announcement") ---@class Announcement
local C = W.Utilities.Color
local cache = W.Utilities.Cache

local _G = _G
local format = format
local pairs = pairs
local strfind = strfind

local GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
local GetQuestLink = GetQuestLink
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard

local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetQuestTagInfo = C_QuestLog.GetQuestTagInfo

local IGNORE_PATTERN = "WINDTOOLS_IGNORE"

local cachedQuests

local ignoreTagIDs = {
	[128] = true, -- Emissary
	[265] = true, -- Hidden
}

local function GetQuests()
	local quests = {}

	for questIndex = 1, C_QuestLog_GetNumQuestLogEntries() do
		local questInfo = C_QuestLog_GetInfo(questIndex)
		if questInfo then
			local skip = questInfo.isHeader or questInfo.isBounty or questInfo.isHidden
			-- isHeader: Quest category header (e.g., "Highmountain-Highmountain Tribe" quests, "Highmountain" should be excluded)
			-- isBounty: Bounty quests (e.g., "The Nightfallen" quests)
			-- isHidden: Auto-accepted weekly quests (e.g., "Conqueror's Reward" weekly PvP quest)

			local tagInfo = C_QuestLog_GetQuestTagInfo(questInfo.questID)

			if tagInfo and ignoreTagIDs[tagInfo.tagID] then
				skip = true
			end

			if questInfo.isOnMap and tagInfo and tagInfo.worldQuestType then
				skip = false
			end

			if questInfo.isOnMap and tagInfo and tagInfo.tagID == 128 then
				skip = false
			end

			if not skip then
				-- Base quest information, used for generating sentences later
				quests[questInfo.questID] = {
					title = questInfo.title,
					questID = questInfo.questID,
					level = questInfo.level,
					suggestedGroup = questInfo.suggestedGroup,
					isComplete = questInfo.isComplete,
					frequency = questInfo.frequency,
					tag = tagInfo and tagInfo.tagName,
					worldQuestType = tagInfo and tagInfo.worldQuestType,
					link = GetQuestLink(questInfo.questID),
				}

				-- Quest progress information (e.g. Kill bears 1/2)
				for queryIndex = 1, GetNumQuestLeaderBoards(questIndex) do
					local queryText = GetQuestLogLeaderBoard(queryIndex, questIndex)
					if queryText then
						local _, _, numItems, numNeeded, itemName = strfind(queryText, "(%d+)/(%d+) ?(.*)")
						quests[questInfo.questID][queryIndex] = {
							item = itemName,
							numItems = numItems,
							numNeeded = numNeeded,
						}
					end
				end
			end
		end
	end

	return quests
end

do
	local ERR_QUEST_ADD_ITEM_SII = ERR_QUEST_ADD_ITEM_SII
	local ERR_QUEST_ADD_FOUND_SII = ERR_QUEST_ADD_FOUND_SII
	local ERR_QUEST_ADD_KILL_SII = ERR_QUEST_ADD_KILL_SII
	local ERR_QUEST_UNKNOWN_COMPLETE = ERR_QUEST_UNKNOWN_COMPLETE
	local ERR_QUEST_OBJECTIVE_COMPLETE_S = ERR_QUEST_OBJECTIVE_COMPLETE_S

	function A:UpdateBlizzardQuestAnnouncement()
		local enable = false

		if not (self.db.enable and self.db.quest and self.db.quest.enable and self.db.quest.disableBlizzard) then
			enable = true
		end

		_G.ERR_QUEST_ADD_ITEM_SII = enable and ERR_QUEST_ADD_ITEM_SII or IGNORE_PATTERN
		_G.ERR_QUEST_ADD_FOUND_SII = enable and ERR_QUEST_ADD_FOUND_SII or IGNORE_PATTERN
		_G.ERR_QUEST_ADD_KILL_SII = enable and ERR_QUEST_ADD_KILL_SII or IGNORE_PATTERN
		_G.ERR_QUEST_UNKNOWN_COMPLETE = enable and ERR_QUEST_UNKNOWN_COMPLETE or IGNORE_PATTERN
		_G.ERR_QUEST_OBJECTIVE_COMPLETE_S = enable and ERR_QUEST_OBJECTIVE_COMPLETE_S or IGNORE_PATTERN
	end
end

function A:Quest()
	local config = self.db.quest
	if not config or not config.enable then
		return
	end

	local currentQuests = GetQuests()

	if not cachedQuests then
		cachedQuests = currentQuests
		return
	end

	for id, questData in pairs(currentQuests) do
		local mainInfo = ""
		local extraInfo = ""
		local mainInfoColored = ""
		local extraInfoColored = ""
		local needAnnounce = false
		local isDetailInfo = false

		if questData.frequency == 1 and config.daily.enable then -- Daily
			extraInfo = extraInfo .. "[" .. _G.DAILY .. "]"
			extraInfoColored = extraInfoColored .. C.StringWithRGB("[" .. _G.DAILY .. "]", config.daily.color)
		elseif questData.frequency == 2 and config.weekly.enable then -- Weekly
			extraInfo = extraInfo .. "[" .. _G.WEEKLY .. "]"
			extraInfoColored = extraInfoColored .. C.StringWithRGB("[" .. _G.WEEKLY .. "]", config.weekly.color)
		end

		if questData.suggestedGroup > 1 and config.suggestedGroup.enable then -- Group
			extraInfo = extraInfo .. "[" .. questData.suggestedGroup .. "]"
			extraInfoColored = extraInfoColored
				.. C.StringWithRGB("[" .. questData.suggestedGroup .. "]", config.suggestedGroup.color)
		end

		if questData.level and config.level.enable then -- Level
			if not config.level.hideOnMax or questData.level ~= W.MaxLevelForPlayerExpansion then
				extraInfo = extraInfo .. "[" .. questData.level .. "]"
				extraInfoColored = extraInfoColored
					.. C.StringWithRGB("[" .. questData.level .. "]", config.level.color)
			end
		end

		if questData.tag and config.tag then -- Tag, usually is "Dungeon", "Profession", etc.
			extraInfo = extraInfo .. "[" .. questData.tag .. "]"
			extraInfoColored = extraInfoColored .. C.StringWithRGB("[" .. questData.tag .. "]", config.tag.color)
		end

		local previousQuestData = cachedQuests[id]
		if previousQuestData then
			if not previousQuestData.isComplete then -- Not completed before
				if questData.isComplete then
					mainInfo = questData.title .. " " .. C.StringWithRGB(L["Completed"], { r = 0.5, g = 1, b = 0.5 })
					mainInfoColored = questData.link
						.. " "
						.. C.StringWithRGB(L["Completed"], { r = 0.5, g = 1, b = 0.5 })
					needAnnounce = true
				elseif #previousQuestData > 0 and #questData > 0 then
					for queryIndex = 1, #questData do
						local previousQueryData, queryData = previousQuestData[queryIndex], questData[queryIndex]
						if
							queryData
							and previousQueryData
							and queryData.numItems
							and previousQueryData.numItems
							and queryData.numItems > previousQueryData.numItems
						then -- Got new progress on this sub-goal
							local progressColor = F.GetProgressColor(queryData.numItems / queryData.numNeeded)
							local subGoalIsCompleted = queryData.numItems == queryData.numNeeded
							if config.includeDetails or subGoalIsCompleted then
								local progressInfo = format("%d/%d", queryData.numItems, queryData.numNeeded)
								local progressInfoColored = progressInfo
								if subGoalIsCompleted then
									progressInfoColored =
										format("%s |T%s:0|t", progressInfoColored, W.Media.Icons.complete)
								else
									isDetailInfo = true
								end

								local messagePrefix = format("%s %s ", questData.link, queryData.item)
								mainInfo = messagePrefix .. progressInfo
								mainInfoColored = messagePrefix .. C.StringWithRGB(progressInfoColored, progressColor)
								needAnnounce = true
							end
						end
					end
				end
			end
		else -- New quest
			if not questData.worldQuestType then -- Ignore world quests for avoid spam
				mainInfo = questData.link .. " " .. L["Accepted"]
				mainInfoColored = questData.link
					.. " "
					.. C.StringWithRGB(L["Accepted"], { r = 1, g = 1, b = 1 })
					.. format(" |T%s:0|t", W.Media.Icons.accept)
				needAnnounce = true
			end
		end

		if needAnnounce then
			local message = extraInfo .. mainInfo
			if not E.db.WT.quest.switchButtons.enable or not config.paused then
				self:SendMessage(message, self:GetChannel(config.channel))
			end

			if not isDetailInfo or self.db.quest.disableBlizzard then -- only show details if system do not show that
				local messageColored = extraInfoColored .. mainInfoColored
				_G.UIErrorsFrame:AddMessage(messageColored)
			end
		end
	end

	cachedQuests = currentQuests
end

W:RegisterUIErrorHandler(function(params)
	if A.db and A.db.enable and A.db.quest and A.db.quest.enable and A.db.quest.disableBlizzard then
		if params.message and params.message == IGNORE_PATTERN then
			return "skip"
		end
	end
end, 100)
