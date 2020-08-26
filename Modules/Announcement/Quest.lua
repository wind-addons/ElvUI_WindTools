local W, F, E, L = unpack(select(2, ...))
local A = W:GetModule("Announcement")

local _G = _G
local strfind = strfind

local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetQuestTagInfo = C_QuestLog.GetQuestTagInfo
local GetQuestLink = GetQuestLink

local maxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion()

local lastList

local function GetQuests()
	local quests = {}

	for questIndex = 1, C_QuestLog_GetNumQuestLogEntries() do
		local questInfo = C_QuestLog_GetInfo(questIndex)
		if not questInfo.isHeader then -- 去除任务分类(比如, "高嶺-高嶺部族"任务, "高嶺"要排除掉)
			local tagInfo = C_QuestLog_GetQuestTagInfo(questInfo.questID)

			-- 基础任务信息, 用于后续生成句子使用
			quests[questInfo.questID] = {
				title = questInfo.title,
				questID = questInfo.questID,
				level = questInfo.level,
				suggestedGroup = questInfo.suggestedGroup,
				isComplete = questInfo.isComplete,
				frequency = questInfo.frequency,
				tag = tagInfo and tagInfo.tagName,
				worldQuestType = tagInfo and tagInfo.worldQuestType,
				link = GetQuestLink(questInfo.questID)
			}

			-- 任务进度 (比如 1/2 杀死熊怪)
			for queryIndex = 1, GetNumQuestLeaderBoards(questIndex) do
				local queryText = GetQuestLogLeaderBoard(queryIndex, questIndex)
				local _, _, numItems, numNeeded, itemName = strfind(queryText, "(%d+)/(%d+) ?(.*)")
				quests[questInfo.questID][queryIndex] = {
					item = itemName,
					numItems = numItems,
					numNeeded = numNeeded
				}
			end
		end
	end

	return quests
end

function A:Quest()
	local config = self.db.quest
	if not config or not config.enable then
		return
	end

	local currentList = GetQuests()

	if not lastList then
		lastList = currentList
		return
	end

	for questID, questCache in pairs(currentList) do
		local mainInfo = ""
		local extraInfo = ""
		local mainInfoColored = ""
		local extraInfoColored = ""
		local needAnnounce = false
		local isDetailInfo = false

		if questCache.frequency == 1 and config.daily.enable then -- 每日
			extraInfo = extraInfo .. "[" .. _G.DAILY .. "]"
			extraInfoColored = extraInfoColored .. F.CreateColorString("[" .. _G.DAILY .. "]", config.daily.color)
		elseif questCache.frequency == 2 and config.weekly.enable then -- 每周
			extraInfo = extraInfo .. "[" .. _G.WEEKLY .. "]"
			extraInfoColored = extraInfoColored .. F.CreateColorString("[" .. _G.WEEKLY .. "]", config.weekly.color)
		end

		if questCache.suggestedGroup > 1 and config.suggestedGroup.enable then -- 多人
			extraInfo = extraInfo .. "[" .. questCache.suggestedGroup .. "]"
			extraInfoColored =
				extraInfoColored .. F.CreateColorString("[" .. questCache.suggestedGroup .. "]", config.suggestedGroup.color)
		end

		if questCache.level and config.level.enable then -- 等级
			if not config.hideMaxLevel or questCache.level ~= maxLevelForPlayerExpansion then
				extraInfo = extraInfo .. "[" .. questCache.level .. "]"
				extraInfoColored = extraInfoColored .. F.CreateColorString("[" .. questCache.level .. "]", config.level.color)
			end
		end

		if questCache.tag and config.tag then -- 任务分类
			extraInfo = extraInfo .. "[" .. questCache.tag .. "]"
			extraInfoColored = extraInfoColored .. F.CreateColorString("[" .. questCache.tag .. "]", config.tag.color)
		end

		local questCacheOld = lastList[questID]

		if questCacheOld then
			if not questCacheOld.isComplete then -- 之前未完成
				if questCache.isComplete then
					mainInfo = questCache.title .. " " .. F.CreateColorString(L["Completed"], {r = 0.5, g = 1, b = 0.5})
					mainInfoColored = questCache.link .. " " .. F.CreateColorString(L["Completed"], {r = 0.5, g = 1, b = 0.5})
					needAnnounce = true
				elseif #questCacheOld > 0 and #questCache > 0 then -- 循环记录的任务完成条件
					for queryIndex = 1, #questCache do
						if
							questCache[queryIndex] and questCacheOld[queryIndex] and questCache[queryIndex].numItems and
								questCacheOld[queryIndex].numItems and
								questCache[queryIndex].numItems > questCacheOld[queryIndex].numItems
						 then -- 任务有了新的进展
							local progressColor = {
								r = 1 - 0.5 * questCache[queryIndex].numItems / questCache[queryIndex].numNeeded,
								g = 0.5 + 0.5 * questCache[queryIndex].numItems / questCache[queryIndex].numNeeded,
								b = 0.5
							}

							local subGoalIsCompleted = questCache[queryIndex].numItems == questCache[queryIndex].numNeeded

							if config.includeDetails or subGoalIsCompleted then
								local progressInfo = questCache[queryIndex].numItems .. "/" .. questCache[queryIndex].numNeeded
								local progressInfoColored = progressInfo
								if subGoalIsCompleted then
									local redayCheckIcon = "|TInterface/RaidFrame/ReadyCheck-Ready:15:15:-1:2:64:64:6:60:8:60|t"
									progressInfoColored = progressInfoColored .. redayCheckIcon
								else
									isDetailInfo = true
								end

								mainInfo = "[" .. questCache.title .. "]" .. " " .. questCache[queryIndex].item .. " "
								mainInfoColored = questCache.link .. " " .. questCache[queryIndex].item .. " "

								mainInfo = mainInfo .. progressInfo
								mainInfoColored = mainInfoColored .. F.CreateColorString(progressInfoColored, progressColor)
								needAnnounce = true
							end
						end
					end
				end
			end
		else -- 新的任务
			if not questCache.worldQuestType then -- 屏蔽世界任务的接收, 路过不报告
				mainInfo = "[" .. questCache.title .. "]" .. " " .. L["Accepted"]
				mainInfoColored = questCache.link .. " " .. F.CreateColorString(L["Accepted"], {r = 1.000, g = 0.980, b = 0.396})
				needAnnounce = true
			end
		end

		if needAnnounce then
			local message = extraInfo .. mainInfo
			-- TODO: 疑似PTR无法发出带有链接的信息
			-- print(gsub(message, "\124", "\124\124"))
			self:SendMessage(message, self:GetChannel(config.channel))

			if not isDetailInfo then -- 具体进度系统会提示
				local messageColored = extraInfoColored .. mainInfoColored
				UIErrorsFrame:AddMessage(messageColored)
			end
		end
	end

	lastList = currentList
end
