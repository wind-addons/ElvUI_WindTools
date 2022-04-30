local W, F, E, L = unpack(select(2, ...))
local TI = W:NewModule("TurnIn", "AceEvent-3.0")

local _G = _G
local format = format
local ipairs = ipairs
local next = next
local select = select
local strlen = strlen
local strmatch = strmatch
local strupper = strupper
local tonumber = tonumber
local wipe = wipe

local AcceptQuest = AcceptQuest
local AcknowledgeAutoAcceptQuest = AcknowledgeAutoAcceptQuest
local CloseQuest = CloseQuest
local CompleteQuest = CompleteQuest
local GetAutoQuestPopUp = GetAutoQuestPopUp
local GetInstanceInfo = GetInstanceInfo
local GetItemInfo = GetItemInfo
local GetNumAutoQuestPopUps = GetNumAutoQuestPopUps
local GetNumQuestChoices = GetNumQuestChoices
local GetNumQuestItems = GetNumQuestItems
local GetNumTrackingTypes = GetNumTrackingTypes
local GetQuestID = GetQuestID
local GetQuestItemInfo = GetQuestItemInfo
local GetQuestItemLink = GetQuestItemLink
local GetQuestReward = GetQuestReward
local GetTrackingInfo = GetTrackingInfo
local IsModifierKeyDown = IsModifierKeyDown
local IsQuestCompletable = IsQuestCompletable
local QuestGetAutoAccept = QuestGetAutoAccept
local QuestInfoItem_OnClick = QuestInfoItem_OnClick
local QuestIsFromAreaTrigger = QuestIsFromAreaTrigger
local ShowQuestComplete = ShowQuestComplete
local ShowQuestOffer = ShowQuestOffer
local StaticPopup_FindVisible = StaticPopup_FindVisible
local StaticPopup_OnClick = StaticPopup_OnClick
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitName = UnitName
local UnitPlayerControlled = UnitPlayerControlled

local C_GossipInfo_GetActiveQuests = C_GossipInfo.GetActiveQuests
local C_GossipInfo_GetAvailableQuests = C_GossipInfo.GetAvailableQuests
local C_GossipInfo_GetNumActiveQuests = C_GossipInfo.GetNumActiveQuests
local C_GossipInfo_GetNumAvailableQuests = C_GossipInfo.GetNumAvailableQuests
local C_GossipInfo_GetNumOptions = C_GossipInfo.GetNumOptions
local C_GossipInfo_GetOptions = C_GossipInfo.GetOptions
local C_GossipInfo_SelectActiveQuest = C_GossipInfo.SelectActiveQuest
local C_GossipInfo_SelectAvailableQuest = C_GossipInfo.SelectAvailableQuest
local C_GossipInfo_SelectOption = C_GossipInfo.SelectOption
local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetQuestTagInfo = C_QuestLog.GetQuestTagInfo
local C_QuestLog_IsQuestTrivial = C_QuestLog.IsQuestTrivial
local C_QuestLog_IsWorldQuest = C_QuestLog.IsWorldQuest

local quests, choiceQueue = {}, nil

local ignoreQuestNPC = {
    [14847] = true, -- 薩杜斯‧帕里歐教授
    [43929] = true, -- 布靈登4000型
    [45400] = true, -- 菲歐娜的馬車
    [87391] = true, -- 命運扭曲者瑟蕾絲
    [88570] = true, -- 命運扭曲者提克拉
    [93538] = true, -- 博學者達莉諾絲
    [98489] = true, -- 船難俘虜
    [101462] = true, -- 劫福斯
    [101880] = true, -- 塔克塔克
    [103792] = true, -- 格利夫塔
    [105387] = true, -- 安德斯
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
    [168430] = true -- 達提莉絲
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
    [184587] = true -- 塔皮克斯
}

local rogueClassHallInsignia = {
    [93188] = true, -- 蒙加
    [96782] = true, -- 魯西安‧提亞斯
    [97004] = true, -- 『赤紅』傑克‧芬朵
    [107486] = true, -- 長舌造謠者
    [167839] = true -- 部分注入的殘存之魂
}

local followerAssignees = {
    [135614] = true, -- 馬迪亞斯‧肖爾大師
    [138708] = true -- 迦羅娜‧半血
}

local darkmoonNPC = {
    [54334] = true, -- 暗月馬戲團秘法師 (聯盟)
    [55382] = true, -- 暗月馬戲團秘法師 (部落)
    [57850] = true -- 傳送學家法蘇羅寶布
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
    [88604] = true -- 納特的釣魚手冊
}

local ignoreProgressNPC = {
    [119388] = true,
    [127037] = true,
    [126954] = true,
    [124312] = true,
    [141584] = true,
    [326027] = true, -- 运输站回收生成器DX-82
    [150563] = true -- 斯卡基特，麦卡贡订单日常
}

local cashRewards = {
    [45724] = 1e5, -- Champion's Purse
    [64491] = 2e6, -- Royal Reward
    -- Items from the Sixtrigger brothers quest chain in Stormheim
    [138127] = 15, -- Mysterious Coin, 15 copper
    [138129] = 11, -- Swatch of Priceless Silk, 11 copper
    [138131] = 24, -- Magical Sprouting Beans, 24 copper
    [138123] = 15, -- Shiny Gold Nugget, 15 copper
    [138125] = 16, -- Crystal Clear Gemstone, 16 copper
    [138133] = 27 -- Elixir of Endless Wonder, 27 copper
}

local function IsTrackingHidden()
    for index = 1, GetNumTrackingTypes() do
        local name, _, active = GetTrackingInfo(index)
        if name == (_G.MINIMAP_TRACKING_TRIVIAL_QUESTS or _G.MINIMAP_TRACKING_HIDDEN_QUESTS) then
            return active
        end
    end
end

local function IsWorldQuestType(questID)
    local tagInfo = C_QuestLog_GetQuestTagInfo(questID)
    return tagInfo.worldQuestType and true or false
end

local function IsIgnored()
    local npcID = TI:GetNPCID()

    if ignoreQuestNPC[npcID] then
        return true
    end

    if TI.db and TI.db.modifierKeyPause and IsModifierKeyDown() then
        return true
    end

    if TI.db and TI.db.customIgnoreNPCs and TI.db.customIgnoreNPCs[npcID] then
        return true
    end

    return false
end

local function AttemptAutoComplete(event)
    if event == "PLAYER_REGEN_ENABLED" then
        TI:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end

    if GetNumAutoQuestPopUps() > 0 then
        if UnitIsDeadOrGhost("player") then
            TI:RegisterEvent("PLAYER_REGEN_ENABLED")
            return
        end

        local questID, popUpType = GetAutoQuestPopUp(1)
        if not C_QuestLog_IsWorldQuest(questID) then
            if popUpType == "OFFER" then
                ShowQuestOffer(questID)
            elseif popUpType == "COMPLETE" then
                ShowQuestComplete(questID)
            end
        end
    end
end

local function GetQuestLogQuests(onlyComplete)
    wipe(quests)

    for index = 1, C_QuestLog_GetNumQuestLogEntries() do
        local questInfo = C_QuestLog_GetInfo(index)
        if not questInfo.isHeader then
            if onlyComplete and questInfo.isComplete or not onlyComplete then
                quests[questInfo.title] = questInfo.questID
            end
        end
    end

    return quests
end

function TI:GetNPCID(unit)
    return tonumber(strmatch(UnitGUID(unit or "npc") or "", "Creature%-.-%-.-%-.-%-.-%-(.-)%-"))
end

function TI:QUEST_GREETING()
    if IsIgnored() then
        return
    end

    local active = C_GossipInfo_GetNumActiveQuests()
    if active > 0 then
        for index, questInfo in ipairs(C_GossipInfo_GetActiveQuests()) do
            local questID = questInfo.questID
            local isWorldQuest = questID and C_QuestLog_IsWorldQuest(questID)
            if questInfo.isComplete and (not questID or not isWorldQuest) then
                C_GossipInfo_SelectActiveQuest(index)
            end
        end
    end

    local available = C_GossipInfo_GetNumAvailableQuests()
    if available > 0 then
        for index = 1, available do
            local info = C_GossipInfo_GetAvailableQuests(index)
            if not info.isTrivial and not info.isIgnored or IsTrackingHidden() then
                C_GossipInfo_SelectActiveQuest(index)
            end
        end
    end
end

function TI:GOSSIP_SHOW()
    if IsIgnored() then
        return
    end

    local npcID = self:GetNPCID()

    local active = C_GossipInfo_GetNumActiveQuests()
    if active > 0 then
        local logQuests = GetQuestLogQuests(true)
        for index = 1, active do
            local info = C_GossipInfo_GetActiveQuests()[index]
            if info.isComplete then
                local questID = logQuests[info.title]
                if not questID then
                    C_GossipInfo_SelectActiveQuest(index)
                else
                    if not IsWorldQuestType(questID) then
                        C_GossipInfo_SelectActiveQuest(index)
                    end
                end
            end
        end
    end

    local available = C_GossipInfo_GetNumAvailableQuests()
    if available > 0 then
        for index = 1, available do
            local info = C_GossipInfo_GetAvailableQuests()[index]
            if not info.isTrivial and not info.isIgnored or IsTrackingHidden() then
                C_GossipInfo_SelectAvailableQuest(index)
            elseif info.isTrivial and npcID == 64337 then
                C_GossipInfo_SelectAvailableQuest(index)
            end
        end
    end

    if rogueClassHallInsignia[npcID] then
        if not self.db or not self.db.rogueClassHallInsignia then
            return
        end
        return C_GossipInfo_SelectOption(1)
    end

    if available == 0 and active == 0 then
        if C_GossipInfo_GetNumOptions() == 1 then
            if npcID == 57850 then
                return C_GossipInfo_SelectOption(1)
            end

            local _, instance, _, _, _, _, _, mapID = GetInstanceInfo()
            if instance ~= "raid" and not ignoreGossipNPC[npcID] and not (instance == "scenario" and mapID == 1626) then
                local info = C_GossipInfo_GetOptions()
                if info.type == "gossip" then
                    C_GossipInfo_SelectOption(1)
                    return
                end
            end
        elseif followerAssignees[npcID] and C_GossipInfo_GetNumOptions() > 1 and self.db and self.db.followerAssignees then
            return C_GossipInfo_SelectOption(1)
        end
    end
end

function TI:GOSSIP_CONFIRM()
    local npcID = self:GetNPCID()
    if npcID and darkmoonNPC[npcID] and self.db and self.db.darkmoon then
        local dialog = StaticPopup_FindVisible("GOSSIP_CONFIRM")
        StaticPopup_OnClick(dialog, 1)
    end
end

function TI:QUEST_DETAIL()
    if IsIgnored() then
        return
    end

    if QuestIsFromAreaTrigger() then
        AcceptQuest()
    elseif QuestGetAutoAccept() then
        AcknowledgeAutoAcceptQuest()
    elseif not C_QuestLog_IsQuestTrivial(GetQuestID()) or IsTrackingHidden() then
        AcceptQuest()
    end
end

function TI:QUEST_ACCEPT_CONFIRM()
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
    if IsQuestCompletable() then
        local tagInfo = C_QuestLog_GetQuestTagInfo(GetQuestID())
        if tagInfo and tagInfo.tagID == 153 or tagInfo and tagInfo.worldQuestType then
            return
        end

        if IsIgnored() then
            return
        end

        local requiredItems = GetNumQuestItems()
        if requiredItems > 0 then
            for index = 1, requiredItems do
                local link = GetQuestItemLink("required", index)
                if link then
                    local id = tonumber(strmatch(link, "item:(%d+)"))
                    if itemBlacklist[id] then
                        return
                    end
                else
                    choiceQueue = "QUEST_PROGRESS"
                    return
                end
            end
        end

        CompleteQuest()
    end
end

function TI:QUEST_COMPLETE()
    if IsIgnored() then
        return
    end

    -- Blingtron 6000 only!
    local npcID = self:GetNPCID()
    if npcID == 43929 or npcID == 77789 then
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
                local itemSellPrice = select(11, GetItemInfo(link))
                itemSellPrice = cashRewards[tonumber(strmatch(link, "item:(%d+):"))] or itemSellPrice

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

function TI:PLAYER_LOGIN()
    AttemptAutoComplete("PLAYER_LOGIN")
end

function TI:QUEST_AUTOCOMPLETE()
    AttemptAutoComplete("QUEST_AUTOCOMPLETE")
end

function TI:PLAYER_REGEN_ENABLED()
    AttemptAutoComplete("PLAYER_REGEN_ENABLED")
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
    if not self.db.enable or self.Initialized then
        return
    end

    self:RegisterEvent("QUEST_GREETING")
    self:RegisterEvent("GOSSIP_SHOW")
    self:RegisterEvent("GOSSIP_CONFIRM")
    self:RegisterEvent("QUEST_DETAIL")
    self:RegisterEvent("QUEST_ACCEPT_CONFIRM")
    self:RegisterEvent("QUEST_ACCEPTED")
    self:RegisterEvent("QUEST_ITEM_UPDATE")
    self:RegisterEvent("QUEST_PROGRESS")
    self:RegisterEvent("QUEST_COMPLETE")
    self:RegisterEvent("PLAYER_LOGIN")
    self:RegisterEvent("QUEST_AUTOCOMPLETE")

    self.Initialized = true
end

function TI:ProfileUpdate()
    self:Initialize()

    if self.Initialized and not self.db.enable then
        self:UnregisterEvent("QUEST_GREETING")
        self:UnregisterEvent("GOSSIP_SHOW")
        self:UnregisterEvent("GOSSIP_CONFIRM")
        self:UnregisterEvent("QUEST_DETAIL")
        self:UnregisterEvent("QUEST_ACCEPT_CONFIRM")
        self:UnregisterEvent("QUEST_ACCEPTED")
        self:UnregisterEvent("QUEST_ITEM_UPDATE")
        self:UnregisterEvent("QUEST_PROGRESS")
        self:UnregisterEvent("QUEST_COMPLETE")
        self:UnregisterEvent("PLAYER_LOGIN")
        self:UnregisterEvent("QUEST_AUTOCOMPLETE")
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        self.Initialized = false
    end
end

W:RegisterModule(TI:GetName())
