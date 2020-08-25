local W, F, E, L = unpack(select(2, ...))
local A = W:GetModule("Announcement")

local _G = _G
local strfind = strfind

local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetQuestTagInfo = C_QuestLog.GetQuestTagInfo
local GetQuestLink = GetQuestLink
local UnitLevel = UnitLevel

local lastList = lastList

local cache = {
	last = {},
	current = {}
}

local color = {
	daily = {r = 1.000, g = 0.980, b = 0.396},
	weekly = {r = 0.196, g = 1.000, b = 0.494},
	group = {r = 1.000, g = 0.220, b = 0.220},
	tag = {r = 0.490, g = 0.373, b = 1.000},
	level = {r = 0.773, g = 0.424, b = 0.941},
	accept = {r = 1.000, g = 0.980, b = 0.396}
}

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
	local currentList = GetQuests()

	if not lastList then
		lastList = currentList
		return
	end

	for questID, questCache in pairs(currentList) do
		local extraInfo = ""
		local mainInfo = ""

		if questCache.frequency == 1 then -- 每日
			extraInfo = extraInfo .. F.CreateColorString("[" .. _G.DAILY .. "]", color.daily)
		elseif questCache.frequency == 2 then -- 每周
			extraInfo = extraInfo .. F.CreateColorString("[" .. _G.WEEKLY .. "]", color.weekly)
		end

		if questCache.suggestedGroup > 1 then -- 多人
			extraInfo = extraInfo .. F.CreateColorString("[" .. questCache.suggestedGroup .. "]", color.group)
		end

		if questCache.level ~= UnitLevel("player") then -- 等级不同时, 添加等级信息
			extraInfo = extraInfo .. F.CreateColorString("[" .. questCache.level .. "]", color.level)
		end

		if questCache.tag then -- 任务分类
			extraInfo = extraInfo .. F.CreateColorString("[" .. questCache.tag .. "]", color.level)
		end

		local questCacheOld = lastList[questID]

		if questCacheOld then
			if not questCacheOld.isComplete then -- 之前未完成
				if #questCacheOld > 0 and #questCache > 0 then -- 循环记录的任务完成条件
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

							local progressInfo = questCache[queryIndex].numItems .. "/" .. questCache[queryIndex].numNeeded

							if questCache.isComplete or questCache[queryIndex].numItems == questCache[queryIndex].numNeeded then
								progressInfo =
									progressInfo .. "|TInterface/RaidFrame/ReadyCheck-Ready:15:15:-1:2:64:64:6:60:8:60|t" .. L["Completed!"]
							end

							mainInfo = mainInfo .. questCache.link .. " " .. F.CreateColorString(progressInfo, progressColor)
						end
					end
				end
			end
		elseif true then
			mainInfo = mainInfo .. questCache.link .. F.CreateColorString(L["Accepted"], color.accept)
		end

		if mainInfo ~= "" then
			UIErrorsFrame:AddMessage(extraInfo .. mainInfo)
			print(extraInfo .. " / main:" .. mainInfo)
		end
	end

	lastList = currentList
end

local disabledBlizzard = false

local function DisableBlizzardQuestStatus()
	if disabledBlizzard then
		return
	end

	local originalFunction = _G.QuestMapFrame_CheckQuestCriteria

	QuestMapFrame_CheckQuestCriteria = function(...)
		originalFunction(...)
		print(1)
		return false
	end
end
