local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local TI = W:NewModule("TurnIn", "AceEvent-3.0")

local _G = _G
local format = format
local ipairs = ipairs
local select = select
local strfind = strfind
local strlen = strlen
local strmatch = strmatch
local strupper = strupper
local tinsert = tinsert
local tonumber = tonumber

local AcceptQuest = AcceptQuest
local CloseQuest = CloseQuest
local CompleteQuest = CompleteQuest
local GetActiveQuestID = GetActiveQuestID
local GetActiveTitle = GetActiveTitle
local GetAutoQuestPopUp = GetAutoQuestPopUp
local GetAvailableQuestInfo = GetAvailableQuestInfo
local GetInstanceInfo = GetInstanceInfo
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local GetNumActiveQuests = GetNumActiveQuests
local GetNumAutoQuestPopUps = GetNumAutoQuestPopUps
local GetNumAvailableQuests = GetNumAvailableQuests
local GetNumQuestChoices = GetNumQuestChoices
local GetNumQuestItems = GetNumQuestItems
local GetQuestID = GetQuestID
local GetQuestItemInfo = GetQuestItemInfo
local GetQuestItemLink = GetQuestItemLink
local GetQuestReward = GetQuestReward
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsModifierKeyDown = IsModifierKeyDown
local IsQuestCompletable = IsQuestCompletable
local IsShiftKeyDown = IsShiftKeyDown
local QuestGetAutoAccept = QuestGetAutoAccept
local QuestInfoItem_OnClick = QuestInfoItem_OnClick
local QuestIsFromAreaTrigger = QuestIsFromAreaTrigger
local SelectActiveQuest = SelectActiveQuest
local SelectAvailableQuest = SelectAvailableQuest
local ShowQuestComplete = ShowQuestComplete
local ShowQuestOffer = ShowQuestOffer
local StaticPopup_Hide = StaticPopup_Hide
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitName = UnitName
local UnitPlayerControlled = UnitPlayerControlled

local C_GossipInfo_GetActiveDelveGossip = C_GossipInfo.GetActiveDelveGossip
local C_GossipInfo_GetActiveQuests = C_GossipInfo.GetActiveQuests
local C_GossipInfo_GetAvailableQuests = C_GossipInfo.GetAvailableQuests
local C_GossipInfo_GetNumActiveQuests = C_GossipInfo.GetNumActiveQuests
local C_GossipInfo_GetNumAvailableQuests = C_GossipInfo.GetNumAvailableQuests
local C_GossipInfo_GetOptions = C_GossipInfo.GetOptions
local C_GossipInfo_SelectActiveQuest = C_GossipInfo.SelectActiveQuest
local C_GossipInfo_SelectAvailableQuest = C_GossipInfo.SelectAvailableQuest
local C_GossipInfo_SelectOption = C_GossipInfo.SelectOption
local C_Item_GetItemInfo = C_Item.GetItemInfo
local C_Minimap_IsTrackingHiddenQuests = C_Minimap.IsTrackingHiddenQuests
local C_QuestInfoSystem_GetQuestClassification = C_QuestInfoSystem.GetQuestClassification
local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetLogIndexForQuestID = C_QuestLog.GetLogIndexForQuestID
local C_QuestLog_GetQuestTagInfo = C_QuestLog.GetQuestTagInfo
local C_QuestLog_IsQuestFlaggedCompletedOnAccount = C_QuestLog.IsQuestFlaggedCompletedOnAccount
local C_QuestLog_IsQuestTrivial = C_QuestLog.IsQuestTrivial
local C_QuestLog_IsRepeatableQuest = C_QuestLog.IsRepeatableQuest
local C_QuestLog_IsWorldQuest = C_QuestLog.IsWorldQuest

local Enum_GossipOptionRecFlags_QuestLabelPrepend = Enum.GossipOptionRecFlags.QuestLabelPrepend
local Enum_QuestClassification_Calling = Enum.QuestClassification.Calling
local Enum_QuestClassification_Meta = Enum.QuestClassification.Meta
local Enum_QuestClassification_Recurring = Enum.QuestClassification.Recurring
local Enum_QuestFrequency_Default = Enum.QuestFrequency.Default

local DELVE_STRING = "^|cFF0000FF.-" .. DELVE_LABEL
local RED_QUEST_STRING = "^|cFF0000FF.-" .. QUESTS_LABEL
local SKIP_STRING_1 = "^.+|cFFFF0000<.+>|r"
local SKIP_STRING_2 = "|cnRED_FONT_COLOR"

local choiceQueue = nil

local ignoreQuestNPC = {
	[4311] = true, -- 霍加尔·雷斧
	[14847] = true, -- 萨杜斯·帕雷教授
	[43929] = true, -- 布林顿4000
	[45400] = true, -- 菲奥拉的马车
	[77789] = true, -- 布林顿5000
	[87391] = true, -- 命运扭曲者赛瑞斯
	[88570] = true, -- 命运扭曲者提拉尔
	[93538] = true, -- 博学者达瑞妮斯
	[98489] = true, -- 海难俘虏
	[101462] = true, -- 里弗斯
	[101880] = true, -- 泰克泰克
	[103792] = true, -- 格里伏塔
	[105387] = true, -- 安杜斯
	[107934] = true, -- 征募官李
	[108868] = true, -- 塔鲁瓦
	[111243] = true, -- 大法师兰达洛克
	[114719] = true, -- 商人塞林
	[119388] = true, -- 酋长哈顿
	[121263] = true, -- 大技师罗姆尔
	[124312] = true, -- 大主教图拉扬
	[126954] = true, -- 大主教图拉扬
	[127037] = true, -- 纳毕鲁
	[135690] = true, -- 亡灵舰长塔特赛尔
	[141584] = true, -- 祖尔温
	[142063] = true, -- 特兹兰
	[143388] = true, -- 德鲁扎·虚空之牙
	[143555] = true, -- 山德·希尔伯曼
	[150563] = true, -- 斯卡基特
	[150987] = true, -- 肖恩·维克斯
	[154534] = true, -- 阿畅
	[160248] = true, -- 档案员费安
	[162804] = true, -- 威·娜莉
	[168430] = true, -- 戴克泰丽丝
	[223875] = true, -- 菲琳·洛萨
}

local ignoreGossipNPC = {
	[45400] = true, -- 菲奥拉的马车
	-- Bodyguards
	[86682] = true, -- 高里亚退役百夫长
	[86927] = true, -- 暴风之盾死亡骑士
	[86933] = true, -- 战争之矛魔导师
	[86934] = true, -- 沙塔尔防御者
	[86945] = true, -- 誓日术士
	[86946] = true, -- 流亡者鸦爪祭司
	[86964] = true, -- 血鬃缚地者
	-- Sassy Imps
	[95139] = true, -- 邪能小鬼
	[95141] = true, -- 邪能小鬼
	[95142] = true, -- 邪能小鬼
	[95143] = true, -- 邪能小鬼
	[95144] = true, -- 邪能小鬼
	[95145] = true, -- 邪能小鬼
	[95146] = true, -- 邪能小鬼
	[95200] = true, -- 邪能小鬼
	[95201] = true, -- 邪能小鬼
	-- Misc NPCs
	[79740] = true, -- 战争大师佐格
	[79953] = true, -- 索恩中尉
	[84268] = true, -- 索恩中尉
	[84511] = true, -- 索恩中尉
	[84684] = true, -- 索恩中尉
	[117871] = true, -- 军事顾问维多利亚
	[150122] = true, -- 荣耀堡法师
	[150131] = true, -- 萨尔玛法师
	[155101] = true, -- 元素精华融合器
	[155261] = true, -- 肖恩·维克斯
	[165196] = true, -- 西塔尔
	[171589] = true, -- 德莱文将军
	[171787] = true, -- 文官阿得赖斯提斯
	[171795] = true, -- 月莓女勋爵
	[171821] = true, -- 剑斗士米维克斯
	[172558] = true, -- 艾拉·引路者
	[172572] = true, -- 瑟蕾丝特·贝利文科
	[173021] = true, -- 刻符牛头人
	[175513] = true, -- 纳斯利亚审判官
	[180458] = true, -- 德纳修斯大帝的幻象
	[182681] = true, -- 强化控制台
	[183262] = true, -- 回声机若源生体
	[184587] = true, -- 塔皮克斯
}

local smartChatNPCs = {
	[93188] = true, -- 墨戈
	[96782] = true, -- 鲁希安·提亚斯
	[97004] = true, -- “红发”杰克·芬德
	[107486] = true, -- 多嘴的造谣者
	[167839] = true, -- 灌注了一半的灵魂残迹
}

local smartChatNPCOverPossibility = {
	[241748] = 2, -- 伊特努丝
}

local followerAssignees = {
	[135614] = true, -- 马迪亚斯·肖尔大师
	[138708] = true, -- 半兽人迦罗娜
}

local darkmoonNPC = {
	[54334] = true, -- 暗月马戏团秘法师 (联盟)
	[55382] = true, -- 暗月马戏团秘法师 (部落)
	[57850] = true, -- 传送技师弗兹尔巴布
}

local itemBlacklist = {
	-- Inscription weapons
	[79340] = true, -- 铭文朱鹤杖
	[79341] = true, -- 铭文青龙杖
	[79343] = true, -- 铭文白虎杖
	-- Darkmoon Faire artifacts
	[71635] = true, -- 灌魔水晶
	[71636] = true, -- 怪异的蛋
	[71637] = true, -- 神秘的魔典
	[71638] = true, -- 精美的武器
	[71715] = true, -- 战略论
	[71716] = true, -- 占卜者符文
	[71951] = true, -- 阵亡者的旗帜
	[71952] = true, -- 收缴的徽记
	[71953] = true, -- 阵亡冒险者的日记
	-- Tiller Gifts
	[79264] = true, -- 红宝石碎片
	[79265] = true, -- 蓝色羽毛
	[79266] = true, -- 玉猫
	[79267] = true, -- 可爱的苹果
	[79268] = true, -- 泽地百合
	-- Garrison scouting missives
	[122399] = true, -- 斥候密报：玛戈纳洛克
	[122400] = true, -- 斥候密报：永茂丛林
	[122401] = true, -- 斥候密报：石怒崖
	[122402] = true, -- 斥候密报：钢铁军工厂
	[122403] = true, -- 斥候密报：玛戈纳洛克
	[122404] = true, -- 斥候密报：永茂丛林
	[122405] = true, -- 斥候密报：石怒崖
	[122406] = true, -- 斥候密报：钢铁军工厂
	[122407] = true, -- 斥候密报：斯克提斯
	[122408] = true, -- 斥候密报：斯克提斯
	[122409] = true, -- 斥候密报：命运之柱
	[122410] = true, -- 斥候密报：沙塔斯港口
	[122411] = true, -- 斥候密报：命运之柱
	[122412] = true, -- 斥候密报：沙塔斯港口
	[122413] = true, -- 斥候密报：失落的安苏鸦巢
	[122414] = true, -- 斥候密报：失落的安苏鸦巢
	[122415] = true, -- 斥候密报：索克雷萨高地
	[122416] = true, -- 斥候密报：索克雷萨高地
	[122417] = true, -- 斥候密报：黑潮栖木
	[122418] = true, -- 斥候密报：黑潮栖木
	[122419] = true, -- 斥候密报：高里亚试炼场
	[122420] = true, -- 斥候密报：高里亚试炼场
	[122421] = true, -- 斥候密报：莫高尔岗哨
	[122422] = true, -- 斥候密报：莫高尔岗哨
	[122423] = true, -- 斥候密报：破碎悬崖
	[122424] = true, -- 斥候密报：破碎悬崖
	-- Misc
	[88604] = true, -- 纳特的垂钓日志
}

local ignoreInstances = {
	[1571] = true, -- 枯法者
	[1626] = true, -- 群星庭院
}

local cashRewards = {
	[45724] = 1e5, -- 冠军的钱包
	[64491] = 2e6, -- 皇家赏金
	-- Items from the Sixtrigger brothers quest chain in Stormheim
	[138123] = 15, -- 闪亮的金块
	[138125] = 16, -- 晶莹剔透的宝石
	[138127] = 15, -- 神秘钱币
	[138129] = 11, -- 珍贵丝绸样本
	[138131] = 24, -- 萌芽魔豆
	[138133] = 27, -- 无尽奇迹药剂
}

---@param questID number
---@param context QuestTurnInContext?
local function IsRepeatableQuest(questID, context)
	if C_QuestLog_IsRepeatableQuest(questID) then
		return true
	end

	if C_QuestLog_IsWorldQuest(questID) then
		return true
	end

	local classification = C_QuestInfoSystem_GetQuestClassification(questID)
	if
		classification == Enum_QuestClassification_Recurring
		or classification == Enum_QuestClassification_Calling
		or classification == Enum_QuestClassification_Meta
	then
		return true
	end

	if context and context.gossipQuestUIInfo then
		if context.gossipQuestUIInfo.isRepeatable then
			return true
		end

		local frequency = context.gossipQuestUIInfo.frequency
		if frequency and frequency ~= Enum_QuestFrequency_Default then
			return true
		end
	end

	local questLogIndex = C_QuestLog_GetLogIndexForQuestID(questID)
	if questLogIndex then
		local info = C_QuestLog_GetInfo(questLogIndex)
		if info and info.frequency ~= Enum_QuestFrequency_Default then
			return true
		end
	end

	return false
end

---@class QuestTurnInContext
---@field gossipQuestUIInfo GossipQuestUIInfo?

---@param questID number?
---@param context QuestTurnInContext?
---@return boolean
function TI:EnableOnQuestID(questID, context)
	if not questID or not self.db or not self.db.enableCondition then
		return true -- Default to enabled
	end

	-- Repeatable
	if IsRepeatableQuest(questID, context) and self.db.enableCondition.repeatable then
		return true
	end

	-- Account completed
	if C_QuestLog_IsQuestFlaggedCompletedOnAccount(questID) and self.db.enableCondition.accountCompleted then
		return true
	end

	-- Other
	return self.db.enableCondition.other
end

function TI:GetNPCID(unit)
	return tonumber(strmatch(UnitGUID(unit or "npc") or "", "Creature%-.-%-.-%-.-%-.-%-(.-)%-"))
end

do
	local modiferFunctionTable = {
		["SHIFT"] = IsShiftKeyDown,
		["CTRL"] = IsControlKeyDown,
		["ALT"] = IsAltKeyDown,
		["Any"] = IsModifierKeyDown,
		["NONE"] = function()
			return false
		end,
	}

	function TI:IsPaused(moduleEvent)
		if not self.db or moduleEvent and self.db.mode ~= "ALL" and moduleEvent ~= self.db.mode then
			return true
		end

		local func = modiferFunctionTable[self.db.pauseModifier]
		if func and func() then
			return true
		end

		return false
	end
end

function TI:IsIgnoredNPC(npcID)
	npcID = npcID or self:GetNPCID()

	if npcID and ignoreQuestNPC[npcID] then
		return true
	end

	return npcID and self.db and self.db.customIgnoreNPCs and self.db.customIgnoreNPCs[npcID]
end

function TI:QUEST_GREETING()
	if self:IsIgnoredNPC() then
		return
	end

	local active = GetNumActiveQuests()
	if active > 0 then
		for index = 1, active do
			local _, isComplete = GetActiveTitle(index)
			local questID = GetActiveQuestID(index)
			if questID then
				local isWorldQuest = C_QuestLog_IsWorldQuest(questID)
				if isComplete and not isWorldQuest and self:EnableOnQuestID(questID) then
					if not self:IsPaused("COMPLETE") then
						---@diagnostic disable-next-line: redundant-parameter -- The API doc is wrong
						SelectActiveQuest(index)
					end
				end
			end
		end
	end

	local available = GetNumAvailableQuests()
	if available > 0 then
		for index = 1, available do
			local isTrivial, _, _, _, questID = GetAvailableQuestInfo(index)
			if
				self:EnableOnQuestID(questID)
				and (not isTrivial or C_Minimap_IsTrackingHiddenQuests())
				and not self:IsPaused("ACCEPT")
			then
				---@diagnostic disable-next-line: redundant-parameter -- The API doc is wrong
				SelectAvailableQuest(index)
			end
		end
	end
end

function TI:GOSSIP_SHOW()
	local npcID = self:GetNPCID()
	if self:IsPaused() or self:IsIgnoredNPC(npcID) then
		return
	end

	-- 1. Attempt to complete active quests first
	local numActiveQuests = C_GossipInfo_GetNumActiveQuests()
	if numActiveQuests > 0 then
		for _, gossipQuestUIInfo in ipairs(C_GossipInfo_GetActiveQuests()) do
			local questID = gossipQuestUIInfo.questID
			local isWorldQuest = C_QuestLog_IsWorldQuest(questID)
			if
				gossipQuestUIInfo.isComplete
				and not isWorldQuest
				and self:EnableOnQuestID(questID, { gossipQuestUIInfo = gossipQuestUIInfo })
			then
				if not self:IsPaused("COMPLETE") then
					C_GossipInfo_SelectActiveQuest(questID)
					return
				end
			end
		end
	end

	-- 2. Before accepting quests, check for skip strings in gossip options
	local gossipOptions = C_GossipInfo_GetOptions() or { C_GossipInfo_GetActiveDelveGossip() }
	for _, gossipOption in ipairs(gossipOptions) do
		if strfind(gossipOption.name, SKIP_STRING_1) or strfind(gossipOption.name, SKIP_STRING_2) then
			return
		end
	end

	-- 3. Attempt to accept available quests
	local numAvailableQuests = C_GossipInfo_GetNumAvailableQuests()
	if numAvailableQuests > 0 then
		for _, gossipQuestUIInfo in ipairs(C_GossipInfo_GetAvailableQuests()) do
			local isTrivial = gossipQuestUIInfo.isTrivial
			local questID = gossipQuestUIInfo.questID
			if
				self:EnableOnQuestID(questID, { gossipQuestUIInfo = gossipQuestUIInfo })
				and (not isTrivial or C_Minimap_IsTrackingHiddenQuests() or (isTrivial and npcID == 64337))
				and not self:IsPaused("ACCEPT")
			then
				C_GossipInfo_SelectAvailableQuest(questID)
				return
			end
		end
	end

	-- 4. Attempt to click the gossip options
	if not self.db or not self.db.smartChat then
		return
	end

	local numGossipOptions = gossipOptions and #gossipOptions
	if not numGossipOptions or numGossipOptions <= 0 then
		return
	end

	local firstGossipOptionID = gossipOptions[1].gossipOptionID --[[@as number]]
	if smartChatNPCs[npcID] then
		return C_GossipInfo_SelectOption(firstGossipOptionID)
	end

	if numActiveQuests == 0 and numAvailableQuests == 0 then
		if numGossipOptions == 1 then
			if npcID == 57850 then
				return C_GossipInfo_SelectOption(firstGossipOptionID)
			end

			local _, instance, _, _, _, _, _, mapID = GetInstanceInfo()
			if instance ~= "raid" and not ignoreGossipNPC[npcID] and not ignoreInstances[mapID] then
				local name, status = gossipOptions[1].name, gossipOptions[1].status
				if name and status and status == 0 then
					local questNameFound = strfind(name, RED_QUEST_STRING)
					local delveNameFound = strfind(name, DELVE_STRING)
					if questNameFound or delveNameFound then
						return C_GossipInfo_SelectOption(firstGossipOptionID)
					end
				end
			end
		elseif self.db and self.db.followerAssignees and followerAssignees[npcID] and numGossipOptions > 1 then
			return C_GossipInfo_SelectOption(firstGossipOptionID)
		end
	end

	if numGossipOptions > 0 then
		local maybeQuestOptions = {}
		for index, gossipOption in ipairs(gossipOptions) do
			local possibility
			if gossipOption.flags == Enum_GossipOptionRecFlags_QuestLabelPrepend then
				possibility = 1
			end

			if gossipOption.name and strfind(gossipOption.name, RED_QUEST_STRING) then
				possibility = 2
			end

			if possibility then
				tinsert(maybeQuestOptions, { possibility = possibility, index = index })
			end
		end

		if #maybeQuestOptions == 1 then
			local option = maybeQuestOptions[1]
			if smartChatNPCOverPossibility[npcID] and option.possibility < smartChatNPCOverPossibility[npcID] then
				return
			end

			local status = gossipOptions[option.index] and gossipOptions[option.index].status
			local optionID = gossipOptions[option.index] and gossipOptions[option.index].gossipOptionID
			if status and status == 0 and optionID then
				return C_GossipInfo_SelectOption(optionID)
			end
		end
	end
end

function TI:GOSSIP_CONFIRM(_, index)
	local npcID = self:GetNPCID()
	if self:IsPaused() or self:IsIgnoredNPC(npcID) then
		return
	end

	if not (self.db and self.db.smartChat) then
		return
	end

	if self.db and self.db.darkmoon and npcID and darkmoonNPC[npcID] then
		C_GossipInfo_SelectOption(index, "", true)
		StaticPopup_Hide("GOSSIP_CONFIRM")
	end
end

function TI:QUEST_DETAIL()
	if self:IsPaused("ACCEPT") then
		return
	end

	local questID = GetQuestID()

	if QuestGetAutoAccept() then
		if not self:IsIgnoredNPC() and self:EnableOnQuestID(questID) then
			AcknowledgeAutoAcceptQuest()
		end
	end

	if QuestIsFromAreaTrigger() and C_Minimap_IsTrackingHiddenQuests() or not C_QuestLog_IsQuestTrivial(questID) then
		if not self:IsIgnoredNPC() and self:EnableOnQuestID(questID) then
			E:Delay(0.3, function()
				AcceptQuest()
			end)
		end
	end
end

function TI:QUEST_ACCEPT_CONFIRM()
	if self:IsPaused("ACCEPT") then
		return
	end

	if self:EnableOnQuestID(GetQuestID()) then
		AcceptQuest()
	end
end

function TI:QUEST_ACCEPTED()
	if _G.QuestFrame:IsShown() and QuestGetAutoAccept() then
		CloseQuest()
	end
end

function TI:QUEST_ITEM_UPDATE()
	if choiceQueue and self[choiceQueue] then
		self[choiceQueue](self)
	end
end

function TI:QUEST_PROGRESS()
	if self:IsPaused("COMPLETE") then
		return
	end

	if not IsQuestCompletable() then
		return
	end

	local questID = GetQuestID()
	if not self:EnableOnQuestID(questID) then
		return
	end

	local tagInfo = C_QuestLog_GetQuestTagInfo(questID)
	if tagInfo and (tagInfo.tagID == 153 or tagInfo.worldQuestType) or self:IsIgnoredNPC() then
		return
	end

	local requiredItems = GetNumQuestItems()
	if requiredItems > 0 then
		for index = 1, requiredItems do
			local link = GetQuestItemLink("required", index)
			if link then
				local id = GetItemInfoFromHyperlink(link)
				if id and itemBlacklist[id] then
					return CloseQuest()
				end
			else
				choiceQueue = "QUEST_PROGRESS"
				return GetQuestItemInfo("required", index)
			end
		end
	end

	CompleteQuest()
end

function TI:QUEST_COMPLETE()
	if self:IsPaused("COMPLETE") then
		return
	end

	if self:IsIgnoredNPC() then
		return
	end

	local questID = GetQuestID()
	if not self:EnableOnQuestID(questID) then
		return
	end

	local choices = GetNumQuestChoices()
	if choices <= 1 then
		GetQuestReward(1)
	elseif choices > 1 and self.db and self.db.selectReward then
		local bestSellPrice, bestIndex = 0, nil

		for index = 1, choices do
			local link = GetQuestItemLink("choice", index)
			if link then
				local itemSellPrice = select(11, C_Item_GetItemInfo(link))
				itemSellPrice = cashRewards[GetItemInfoFromHyperlink(link)] or itemSellPrice

				if itemSellPrice > bestSellPrice then
					bestSellPrice, bestIndex = itemSellPrice, index
				end
			else
				choiceQueue = "QUEST_COMPLETE"
				return GetQuestItemInfo("choice", index)
			end
		end

		local button = bestIndex and _G.QuestInfoRewardsFrame.RewardButtons[bestIndex]
		if button then
			QuestInfoItem_OnClick(button)
		end
	end
end

function TI:AttemptAutoComplete(event)
	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end

	if self:IsPaused("COMPLETE") then
		return
	end

	if GetNumAutoQuestPopUps() > 0 then
		if UnitIsDeadOrGhost("player") then
			self:RegisterEvent("PLAYER_REGEN_ENABLED", "AttemptAutoComplete")
			return
		end

		local questID, popUpType = GetAutoQuestPopUp(1)
		if not self:EnableOnQuestID(questID) then
			return
		end

		if not C_QuestLog_IsWorldQuest(questID) then
			if popUpType == "OFFER" then
				ShowQuestOffer(questID)
			elseif popUpType == "COMPLETE" then
				ShowQuestComplete(questID)
			end
		end

		if _G.QuestObjectiveTracker then
			_G.QuestObjectiveTracker:RemoveAutoQuestPopUp(questID)
		end
	end
end

function TI:AddTargetToBlacklist()
	if not UnitExists("target") then
		F.Print(L["Target does not exist."])
		return
	end
	if UnitPlayerControlled("target") then
		F.Print(L["Target is not an NPC."])
		return
	end
	local npcID = self:GetNPCID("target")
	if npcID then
		local list = E.db.WT.quest.turnIn.customIgnoreNPCs
		list[npcID] = UnitName("target")
		F.Print(format(L["%s has been added to the ignore list."], list[npcID]))
	end
end

_G.SLASH_WINDTOOLS_TURN_IN1 = "/wti"
_G.SLASH_WINDTOOLS_TURN_IN2 = "/windturnin"
_G.SLASH_WINDTOOLS_TURN_IN3 = "/windquestturnin"

_G.SlashCmdList["WINDTOOLS_TURN_IN"] = function(msg)
	if msg and strlen(msg) > 0 then
		msg = strupper(msg)
		if msg == "ON" or msg == "1" or msg == "TRUE" or msg == "ENABLE" then
			TI.db.enable = true
		elseif msg == "OFF" or msg == "0" or msg == "FALSE" or msg == "DISABLE" then
			TI.db.enable = false
		elseif msg == "ADDTARGET" or msg == "ADD" or msg == "IGNORE" or msg == "ADD TARGET" then
			TI:AddTargetToBlacklist()
			return
		end
	else
		TI.db.enable = not TI.db.enable
	end
	TI:ProfileUpdate()
	local SB = W:GetModule("SwitchButtons")
	if SB then
		SB:ProfileUpdate()
	end

	F.Print(format("%s %s", L["Turn In"], TI.db.enable and L["Enabled"] or L["Disabled"]))
end

function TI:Initialize()
	self.db = E.db.WT.quest.turnIn
	if not self.db.enable or self.initialized then
		return
	end

	self:RegisterEvent("GOSSIP_CONFIRM")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("PLAYER_LOGIN", "AttemptAutoComplete")
	self:RegisterEvent("QUEST_ACCEPTED")
	self:RegisterEvent("QUEST_ACCEPT_CONFIRM")
	self:RegisterEvent("QUEST_COMPLETE")
	self:RegisterEvent("QUEST_DETAIL")
	self:RegisterEvent("QUEST_GREETING")
	self:RegisterEvent("QUEST_ITEM_UPDATE")
	self:RegisterEvent("QUEST_LOG_UPDATE", "AttemptAutoComplete")
	self:RegisterEvent("QUEST_PROGRESS")

	self.initialized = true
end

function TI:ProfileUpdate()
	self:Initialize()

	if self.initialized and not self.db.enable then
		self:UnregisterEvent("GOSSIP_CONFIRM")
		self:UnregisterEvent("GOSSIP_SHOW")
		self:UnregisterEvent("PLAYER_LOGIN")
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:UnregisterEvent("QUEST_ACCEPTED")
		self:UnregisterEvent("QUEST_ACCEPT_CONFIRM")
		self:UnregisterEvent("QUEST_COMPLETE")
		self:UnregisterEvent("QUEST_DETAIL")
		self:UnregisterEvent("QUEST_GREETING")
		self:UnregisterEvent("QUEST_ITEM_UPDATE")
		self:UnregisterEvent("QUEST_LOG_UPDATE")
		self:UnregisterEvent("QUEST_PROGRESS")
		self.initialized = false
	end
end

W:RegisterModule(TI:GetName())
