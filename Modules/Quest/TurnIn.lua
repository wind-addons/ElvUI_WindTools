local W, F, E, L = unpack((select(2, ...)))
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
local AcknowledgeAutoAcceptQuest = AcknowledgeAutoAcceptQuest
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
local C_Minimap_IsFilteredOut = C_Minimap.IsFilteredOut
local C_Minimap_IsTrackingHiddenQuests = C_Minimap.IsTrackingHiddenQuests
local C_QuestInfoSystem_GetQuestClassification = C_QuestInfoSystem.GetQuestClassification
local C_QuestLog_GetQuestTagInfo = C_QuestLog.GetQuestTagInfo
local C_QuestLog_IsQuestFlaggedCompletedOnAccount = C_QuestLog.IsQuestFlaggedCompletedOnAccount
local C_QuestLog_IsQuestTrivial = C_QuestLog.IsQuestTrivial
local C_QuestLog_IsRepeatableQuest = C_QuestLog.IsRepeatableQuest
local C_QuestLog_IsWorldQuest = C_QuestLog.IsWorldQuest

local Enum_GossipOptionRecFlags_QuestLabelPrepend = Enum.GossipOptionRecFlags.QuestLabelPrepend
local Enum_MinimapTrackingFilter_AccountCompletedQuests = Enum.MinimapTrackingFilter.AccountCompletedQuests
local Enum_QuestClassification_Calling = Enum.QuestClassification.Calling
local Enum_QuestClassification_Recurring = Enum.QuestClassification.Recurring

local QUEST_STRING = "cFF0000FF.-" .. TRANSMOG_SOURCE_2
local SKIP_STRING = "^.+|cFFFF0000<.+>|r"
local DELVE_STRING = "%(" .. DELVE_LABEL .. "%)"

local choiceQueue = nil

local ignoreQuestNPC = {
	[4311] = true, -- 霍加爾‧雷斧
	[14847] = true, -- 薩杜斯‧帕里歐教授
	[43929] = true, -- 布靈登4000型
	[45400] = true, -- 菲歐娜的馬車
	[77789] = true, -- 布靈登5000型
	[87391] = true, -- 命運扭曲者瑟蕾絲
	[88570] = true, -- 命運扭曲者提克拉
	[93538] = true, -- 博學者達莉諾絲
	[98489] = true, -- 船難俘虜
	[101462] = true, -- 劫福斯
	[101880] = true, -- 塔克塔克
	[103792] = true, -- 格利夫塔
	[105387] = true, -- 安德斯
	[107934] = true, -- 招募員小李
	[108868] = true, -- 塔陸亞
	[111243] = true, -- 大法師朗達拉克
	[114719] = true, -- 商人愷倫
	[119388] = true, -- 哈圖恩族長
	[121263] = true, -- 大工藝師羅穆爾
	[124312] = true, -- 大主教圖拉揚
	[126954] = true, -- 大主教圖拉揚
	[127037] = true, -- 納比魯
	[135690] = true, -- 恐衛上將黛特賽爾
	[141584] = true, -- 祖爾凡
	[142063] = true, -- 泰茲蘭
	[143388] = true, -- 德露莎‧虛牙
	[143555] = true, -- 山德‧銀法
	[150563] = true, -- 史卡吉特
	[150987] = true, -- 尚恩‧威克斯
	[154534] = true, -- 芙菈斯
	[160248] = true, -- 文獻管理員費恩
	[162804] = true, -- 維娜里
	[168430] = true, -- 達提莉絲
	[223875] = true, -- 法林‧洛薩
}

local ignoreGossipNPC = {
	[45400] = true, -- 菲歐娜的馬車
	-- Bodyguards
	[86682] = true, -- 退役的戈利安百夫長
	[86927] = true, -- 暴風之盾死亡騎士
	[86933] = true, -- 戰爭之矛魔導師
	[86934] = true, -- 薩塔防衛者
	[86945] = true, -- 日誓術士
	[86946] = true, -- 流亡的魔爪祭司
	[86964] = true, -- 血鬃縛地者
	-- Sassy Imps
	[95139] = true, -- 魔化小鬼
	[95141] = true, -- 魔化小鬼
	[95142] = true, -- 魔化小鬼
	[95143] = true, -- 魔化小鬼
	[95144] = true, -- 魔化小鬼
	[95145] = true, -- 魔化小鬼
	[95146] = true, -- 魔化小鬼
	[95200] = true, -- 魔化小鬼
	[95201] = true, -- 魔化小鬼
	-- Misc NPCs
	[79740] = true, -- 將領佐格 (部落)
	[79953] = true, -- 索恩妮中尉 (聯盟)
	[84268] = true, -- 索恩妮中尉 (聯盟)
	[84511] = true, -- 索恩妮中尉 (聯盟)
	[84684] = true, -- 索恩妮中尉 (聯盟)
	[117871] = true, -- 戰事參謀維朵莉亞
	[150122] = true, -- 榮譽堡法師
	[150131] = true, -- 索爾瑪法師
	[155101] = true, -- 元素精華融合器
	[155261] = true, -- 尚恩‧威克斯
	[165196] = true, -- 希奧塔
	[171589] = true, -- 德瑞文將軍
	[171787] = true, -- 軍政官阿德雷特斯
	[171795] = true, -- 月莓女士
	[171821] = true, -- 武鬥士梅維斯
	[172558] = true, -- 伊萊雅‧引路者
	[172572] = true, -- 瑟莉絲蒂‧佩利溫哥
	[173021] = true, -- 刻符牛頭人
	[175513] = true, -- 納撒亞審判官
	[180458] = true, -- 戴納瑟斯王的幻象
	[182681] = true, -- 強化控制臺
	[183262] = true, -- 回響的創始機諾
	[184587] = true, -- 塔皮克斯
}

local smartChatNPCs = {
	[93188] = true, -- 蒙加
	[96782] = true, -- 魯西安‧提亞斯
	[97004] = true, -- 『赤紅』傑克‧芬朵
	[107486] = true, -- 長舌造謠者
	[167839] = true, -- 部分注入的殘存之魂
}

local followerAssignees = {
	[135614] = true, -- 馬迪亞斯‧肖爾大師
	[138708] = true, -- 迦羅娜‧半血
}

local darkmoonNPC = {
	[54334] = true, -- 暗月馬戲團秘法師 (聯盟)
	[55382] = true, -- 暗月馬戲團秘法師 (部落)
	[57850] = true, -- 傳送學家法蘇羅寶布
}

local itemBlacklist = {
	-- Inscription weapons
	[79340] = true, -- 銘刻紅鶴法杖
	[79341] = true, -- 銘刻玉蛟法杖
	[79343] = true, -- 銘刻白虎法杖
	-- Darkmoon Faire artifacts
	[71635] = true, -- 灌魔水晶
	[71636] = true, -- 怪異的蛋
	[71637] = true, -- 詭秘魔典
	[71638] = true, -- 華麗武器
	[71715] = true, -- 戰略論
	[71716] = true, -- 預卜者的符文
	[71951] = true, -- 墮落者旌旗
	[71952] = true, -- 奪來的徽記
	[71953] = true, -- 逝去冒險者的日記
	-- Tiller Gifts
	[79264] = true, -- 紅寶石裂片
	[79265] = true, -- 藍羽
	[79266] = true, -- 玉貓
	[79267] = true, -- 可愛的蘋果
	[79268] = true, -- 溼地百合
	-- Garrison scouting missives
	[122399] = true, -- 偵察文件：麥奈洛克
	[122400] = true, -- 偵察文件：永茂林野地
	[122401] = true, -- 偵察文件：石怒崖
	[122402] = true, -- 偵察文件：鋼鐵軍火廠
	[122403] = true, -- 偵察文件：麥奈洛克
	[122404] = true, -- 偵察文件：永茂林野地
	[122405] = true, -- 偵察文件：石怒崖
	[122406] = true, -- 偵察文件：鋼鐵軍火廠
	[122407] = true, -- 偵察文件：司凱堤斯
	[122408] = true, -- 偵察文件：司凱堤斯
	[122409] = true, -- 偵察文件：命運之柱
	[122410] = true, -- 偵察文件：撒塔斯港
	[122411] = true, -- 偵察文件：命運之柱
	[122412] = true, -- 偵察文件：撒塔斯港
	[122413] = true, -- 偵察文件：失落的維爾安祖
	[122414] = true, -- 偵察文件：失落的維爾安祖
	[122415] = true, -- 偵察文件：索奎薩爾高地
	[122416] = true, -- 偵察文件：索奎薩爾高地
	[122417] = true, -- 偵察文件：暗潮棲息地
	[122418] = true, -- 偵察文件：暗潮棲息地
	[122419] = true, -- 偵察文件：戈利安試煉場
	[122420] = true, -- 偵察文件：戈利安試煉場
	[122421] = true, -- 偵察文件：莫克戈爾哨站
	[122422] = true, -- 偵察文件：莫克戈爾哨站
	[122423] = true, -- 偵察文件：破碎絕壁
	[122424] = true, -- 偵察文件：破碎絕壁
	-- Misc
	[88604] = true, -- 納特的釣魚手冊
}

local ignoreInstances = {
	[1571] = true, -- 枯法者
	[1626] = true, -- 群星庭院
}

local cashRewards = {
	[45724] = 1e5, -- 勇士的獎金
	[64491] = 2e6, -- 皇家的獎賞
	-- Items from the Sixtrigger brothers quest chain in Stormheim
	[138123] = 15, -- 亮晶晶的碎礦
	[138125] = 16, -- 晶瑩剔透的寶石
	[138127] = 15, -- 神秘硬幣
	[138129] = 11, -- 無價絲布樣本
	[138131] = 24, -- 發芽魔豆
	[138133] = 27, -- 無盡好奇藥劑
}

local function IsAccountCompleted(questID)
	return C_Minimap_IsFilteredOut(Enum_MinimapTrackingFilter_AccountCompletedQuests)
		and C_QuestLog_IsQuestFlaggedCompletedOnAccount(questID)
end

local function IsQuestRepeatable(questID)
	if C_QuestLog_IsWorldQuest(questID) then
		return true
	end

	if C_QuestLog_IsRepeatableQuest(questID) then
		return true
	end

	local classification = C_QuestInfoSystem_GetQuestClassification(questID)
	return classification == Enum_QuestClassification_Recurring or classification == Enum_QuestClassification_Calling
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
			local isWorldQuest = C_QuestLog_IsWorldQuest(questID)
			local skipRepeatable = self.db.onlyRepeatable and not IsQuestRepeatable(questID)
			if isComplete and not isWorldQuest and not skipRepeatable then
				if not self:IsPaused("COMPLETE") then
					SelectActiveQuest(index)
				end
			end
		end
	end

	local available = GetNumAvailableQuests()
	if available > 0 then
		for index = 1, available do
			local isTrivial, _, _, _, questID = GetAvailableQuestInfo(index)
			local skipRepeatable = self.db.onlyRepeatable and not IsQuestRepeatable(questID)
			if
				not IsAccountCompleted(questID)
				and (not isTrivial or C_Minimap_IsTrackingHiddenQuests())
				and not skipRepeatable
				and not self:IsPaused("ACCEPT")
			then
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

	local numActiveQuests = C_GossipInfo_GetNumActiveQuests()
	if numActiveQuests > 0 then
		for _, gossipQuestUIInfo in ipairs(C_GossipInfo_GetActiveQuests()) do
			local questID = gossipQuestUIInfo.questID
			local isWorldQuest = C_QuestLog_IsWorldQuest(questID)
			local skipRepeatable = self.db.onlyRepeatable and not IsQuestRepeatable(questID)
			if gossipQuestUIInfo.isComplete and not isWorldQuest and not skipRepeatable then
				if not self:IsPaused("COMPLETE") then
					C_GossipInfo_SelectActiveQuest(questID)
				end
			end
		end
	end

	local gossipOptions = C_GossipInfo_GetOptions() or C_GossipInfo_GetActiveDelveGossip()
	local numGossipOptions = gossipOptions and #gossipOptions
	for index, gossipOption in ipairs(gossipOptions) do
		if strfind(gossipOption.name, SKIP_STRING) then
			return
		end
	end

	local numAvailableQuests = C_GossipInfo_GetNumAvailableQuests()
	if numAvailableQuests > 0 then
		for _, gossipQuestUIInfo in ipairs(C_GossipInfo_GetAvailableQuests()) do
			local isTrivial = gossipQuestUIInfo.isTrivial
			local questID = gossipQuestUIInfo.questID
			local skipRepeatable = self.db.onlyRepeatable and not IsQuestRepeatable(questID)

			if
				not IsAccountCompleted(questID)
				and (not isTrivial or C_Minimap_IsTrackingHiddenQuests() or (isTrivial and npcID == 64337))
				and not skipRepeatable
				and not self:IsPaused("ACCEPT")
			then
				C_GossipInfo_SelectAvailableQuest(questID)
			end
		end
	end

	if not numGossipOptions or numGossipOptions <= 0 then
		return
	end

	local firstGossipOptionID = gossipOptions[1].gossipOptionID

	if not (self.db and self.db.smartChat) then
		return
	end

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
					local questNameFound = strfind(name, "cFF0000FF") and strfind(name, QUEST_STRING)
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
		local maybeQuestIndexes = {}
		for index, gossipOption in ipairs(gossipOptions) do
			if
				gossipOption.name
				and (
					gossipOption.flags == Enum_GossipOptionRecFlags_QuestLabelPrepend
					or strfind(gossipOption.name, QUEST_STRING)
				)
			then
				tinsert(maybeQuestIndexes, index)
			end
		end

		if #maybeQuestIndexes == 1 then
			local index = maybeQuestIndexes[1]
			local status = gossipOptions[index] and gossipOptions[index].status
			if status and status == 0 then
				return C_GossipInfo_SelectOption(gossipOptions[index].gossipOptionID)
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
	if
		QuestIsFromAreaTrigger()
		or QuestGetAutoAccept()
		or C_Minimap_IsTrackingHiddenQuests()
		or not C_QuestLog_IsQuestTrivial(questID)
	then
		if self:IsIgnoredNPC() then
			return
		end

		if questID and self.db.onlyRepeatable and not IsQuestRepeatable(questID) then
			return
		end

		AcceptQuest()
	end
end

function TI:QUEST_ACCEPT_CONFIRM()
	if self:IsPaused("ACCEPT") then
		return
	end

	if self.db.onlyRepeatable then
		local questID = GetQuestID()
		if questID and not IsQuestRepeatable(questID) then
			return
		end
	end

	AcceptQuest()
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
	if self.db.onlyRepeatable and questID and not IsQuestRepeatable(questID) then
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

	if self.db.onlyRepeatable then
		local questID = GetQuestID()
		if questID and not IsQuestRepeatable(questID) then
			return
		end
	end

	local choices = GetNumQuestChoices()
	if choices <= 1 then
		GetQuestReward(1)
	elseif choices > 1 and self.db and self.db.selectReward then
		local bestSellPrice, bestIndex = 0

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

		if self.db.onlyRepeatable then
			if questID and not IsQuestRepeatable(questID) then
				return
			end
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
