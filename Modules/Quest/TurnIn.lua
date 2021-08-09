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

local quests, choiceQueue = {}

local ignoreQuestNPC = {
    [88570] = true, -- Fate-Twister Tiklal
    [87391] = true, -- Fate-Twister Seress
    [111243] = true, -- Archmage Lan'dalock
    [108868] = true, -- Hunter's order hall
    [101462] = true, -- Reaves
    [43929] = true, -- 4000
    [14847] = true, -- DarkMoon
    [119388] = true, -- 酋长哈顿
    [114719] = true, -- 商人塞林
    [121263] = true, -- 大技师罗姆尔
    [126954] = true, -- 图拉扬
    [124312] = true, -- 图拉扬
    [103792] = true, -- 格里伏塔
    [101880] = true, -- 泰克泰克
    [141584] = true, -- 祖尔温
    [142063] = true, -- 特兹兰
    [143388] = true, -- 德鲁扎
    [98489] = true, -- 海难俘虏
    [135690] = true, -- 亡灵舰长
    [105387] = true, -- 安杜斯
    [93538] = true, -- 达瑞妮斯
    [154534] = true, -- 大杂院阿畅
    [150987] = true, -- 肖恩·维克斯，斯坦索姆
    [150563] = true, -- 斯卡基特，麦卡贡订单日常
    [143555] = true, -- 山德·希尔伯曼，祖达萨PVP军需官
    [168430] = true, -- 戴克泰丽丝，格里恩挑战
    [160248] = true, -- 档案员费安，罪魂碎片
    [127037] = true, -- 纳毕鲁
    [326027] = true, -- 运输站回收生成器DX-82
    [45400] = true -- Fiona's Caravan
}

local ignoreGossipNPC = {
    [45400] = true, -- Fiona's Caravan
    -- Bodyguards
    [86945] = true, -- Aeda Brightdawn (Horde)
    [86933] = true, -- Vivianne (Horde)
    [86927] = true, -- Delvar Ironfist (Alliance)
    [86934] = true, -- Defender Illona (Alliance)
    [86682] = true, -- Tormmok
    [86964] = true, -- Leorajh
    [86946] = true, -- Talonpriest Ishaal
    -- Sassy Imps
    [95139] = true,
    [95141] = true,
    [95142] = true,
    [95143] = true,
    [95144] = true,
    [95145] = true,
    [95146] = true,
    [95200] = true,
    [95201] = true,
    -- Misc NPCs
    [79740] = true, -- Warmaster Zog (Horde)
    [79953] = true, -- Lieutenant Thorn (Alliance)
    [84268] = true, -- Lieutenant Thorn (Alliance)
    [84511] = true, -- Lieutenant Thorn (Alliance)
    [84684] = true, -- Lieutenant Thorn (Alliance)
    [117871] = true, -- War Councilor Victoria (Class Challenges @ Broken Shore)
    [155101] = true, -- 元素精华融合器
    [155261] = true, -- 肖恩·维克斯，斯坦索姆
    [150122] = true, -- 荣耀堡法师
    [150131] = true, -- 萨尔玛法师
    [173021] = true, -- 刻符牛头人
    [171589] = true, -- 德莱文将军
    [171787] = true, -- 文官阿得赖斯提斯
    [171795] = true, -- 月莓女勋爵
    [171821] = true, -- 德拉卡女男爵
    [172558] = true, -- 艾拉·引路者（导师）
    [172572] = true, -- 瑟蕾丝特·贝利文科（导师）
    [175513] = true -- 纳斯利亚审判官，傲慢
}

local rogueClassHallInsignia = {
    [97004] = true, -- "Red" Jack Findle
    [96782] = true, -- Lucian Trias
    [93188] = true -- Mongar
}

local followerAssignees = {
    [138708] = true, -- 半兽人迦罗娜
    [135614] = true -- 马迪亚斯·肖尔大师
}

local darkmoonNPC = {
    [57850] = true, -- Teleportologist Fozlebub
    [55382] = true, -- Darkmoon Faire Mystic Mage (Horde)
    [54334] = true -- Darkmoon Faire Mystic Mage (Alliance)
}

local itemBlacklist = {
    -- Inscription weapons
    [31690] = 79343, -- Inscribed Tiger Staff
    [31691] = 79340, -- Inscribed Crane Staff
    [31692] = 79341, -- Inscribed Serpent Staff
    -- Darkmoon Faire artifacts
    [29443] = 71635, -- Imbued Crystal
    [29444] = 71636, -- Monstrous Egg
    [29445] = 71637, -- Mysterious Grimoire
    [29446] = 71638, -- Ornate Weapon
    [29451] = 71715, -- A Treatise on Strategy
    [29456] = 71951, -- Banner of the Fallen
    [29457] = 71952, -- Captured Insignia
    [29458] = 71953, -- Fallen Adventurer's Journal
    [29464] = 71716, -- Soothsayer's Runes
    -- Tiller Gifts
    ["progress_79264"] = 79264, -- Ruby Shard
    ["progress_79265"] = 79265, -- Blue Feather
    ["progress_79266"] = 79266, -- Jade Cat
    ["progress_79267"] = 79267, -- Lovely Apple
    ["progress_79268"] = 79268, -- Marsh Lily
    -- Garrison scouting missives
    ["38180"] = 122424, -- Scouting Missive: Broken Precipice
    ["38193"] = 122423, -- Scouting Missive: Broken Precipice
    ["38182"] = 122418, -- Scouting Missive: Darktide Roost
    ["38196"] = 122417, -- Scouting Missive: Darktide Roost
    ["38179"] = 122400, -- Scouting Missive: Everbloom Wilds
    ["38192"] = 122404, -- Scouting Missive: Everbloom Wilds
    ["38194"] = 122420, -- Scouting Missive: Gorian Proving Grounds
    ["38202"] = 122419, -- Scouting Missive: Gorian Proving Grounds
    ["38178"] = 122402, -- Scouting Missive: Iron Siegeworks
    ["38191"] = 122406, -- Scouting Missive: Iron Siegeworks
    ["38184"] = 122413, -- Scouting Missive: Lost Veil Anzu
    ["38198"] = 122414, -- Scouting Missive: Lost Veil Anzu
    ["38177"] = 122403, -- Scouting Missive: Magnarok
    ["38190"] = 122399, -- Scouting Missive: Magnarok
    ["38181"] = 122421, -- Scouting Missive: Mok'gol Watchpost
    ["38195"] = 122422, -- Scouting Missive: Mok'gol Watchpost
    ["38185"] = 122411, -- Scouting Missive: Pillars of Fate
    ["38199"] = 122409, -- Scouting Missive: Pillars of Fate
    ["38187"] = 122412, -- Scouting Missive: Shattrath Harbor
    ["38201"] = 122410, -- Scouting Missive: Shattrath Harbor
    ["38186"] = 122408, -- Scouting Missive: Skettis
    ["38200"] = 122407, -- Scouting Missive: Skettis
    ["38183"] = 122416, -- Scouting Missive: Socrethar's Rise
    ["38197"] = 122415, -- Scouting Missive: Socrethar's Rise
    ["38176"] = 122405, -- Scouting Missive: Stonefury Cliffs
    ["38189"] = 122401, -- Scouting Missive: Stonefury Cliffs
    -- Misc
    [31664] = 88604 -- Nat's Fishing Journal
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
                    for _, itemID in next, itemBlacklist do
                        if itemID == id then
                            return
                        end
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
        local bestSellPrice, bestIndex = 0

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
