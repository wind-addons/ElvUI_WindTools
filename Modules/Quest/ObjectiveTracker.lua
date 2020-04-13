-- 原创模块
local E, L, V, P, G = unpack(ElvUI); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")
local OT = E:NewModule('Wind_ObjectiveTacker', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local _G = _G

-- QuickQuest, by p3lim
-- Import from NDui
local strmatch = string.match
local tonumber, next = tonumber, next
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
    [143555] = true -- 山德·希尔伯曼，祖达萨PVP军需官
}

local ignoreGossipNPC = {
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
    [150131] = true -- 萨尔玛法师
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

local function GetNPCID() return tonumber(string.match(UnitGUID('npc') or '', 'Creature%-.-%-.-%-.-%-.-%-(.-)%-')) end

local function IsTrackingHidden()
    for index = 1, GetNumTrackingTypes() do
        local name, _, active = GetTrackingInfo(index)
        if (name == (MINIMAP_TRACKING_TRIVIAL_QUESTS or MINIMAP_TRACKING_HIDDEN_QUESTS)) then return active end
    end
end

local function GetAvailableGossipQuestInfo(index)
    local name, level, isTrivial, frequency, isRepeatable, isLegendary, isIgnored =
        select(((index * 7) - 7) + 1, GetGossipAvailableQuests())
    return name, level, isTrivial, isIgnored, isRepeatable, frequency == 2, frequency == 3, isLegendary
end

local function GetActiveGossipQuestInfo(index)
    local name, level, isTrivial, isComplete, isLegendary, isIgnored =
        select(((index * 6) - 6) + 1, GetGossipActiveQuests())
    return name, level, isTrivial, isIgnored, isComplete, isLegendary
end

local function AttemptAutoComplete(event)
    if (GetNumAutoQuestPopUps() > 0) then
        if (UnitIsDeadOrGhost("player")) then
            OT:RegisterEvent("PLAYER_REGEN_ENABLED")
            return
        end

        local questID, popUpType = GetAutoQuestPopUp(1)
        local _, _, worldQuest = GetQuestTagInfo(questID)
        if not worldQuest then
            if (popUpType == "OFFER") then
                ShowQuestOffer(GetQuestLogIndexByID(questID))
            else
                ShowQuestComplete(GetQuestLogIndexByID(questID))
            end
        end
    else
        C_Timer.After(1, AttemptAutoComplete)
    end

    if (event == "PLAYER_REGEN_ENABLED") then OT:UnregisterEvent("PLAYER_REGEN_ENABLED") end
end

local function GetQuestLogQuests(onlyComplete)
    wipe(quests)

    for index = 1, GetNumQuestLogEntries() do
        local title, _, _, isHeader, _, isComplete, _, questID = GetQuestLogTitle(index)
        if (not isHeader) then
            if (onlyComplete and isComplete or not onlyComplete) then quests[title] = questID end
        end
    end

    return quests
end

function OT:QUEST_GREETING()
    local npcID = GetNPCID()
    if (ignoreQuestNPC[npcID]) then return end

    local active = GetNumActiveQuests()
    if (active > 0) then
        local logQuests = GetQuestLogQuests(true)
        for index = 1, active do
            local name, complete = GetActiveTitle(index)
            if (complete) then
                local questID = logQuests[name]
                if (not questID) then
                    SelectActiveQuest(index)
                else
                    local _, _, worldQuest = GetQuestTagInfo(questID)
                    if (not worldQuest) then SelectActiveQuest(index) end
                end
            end
        end
    end

    local available = GetNumAvailableQuests()
    if (available > 0) then
        for index = 1, available do
            local isTrivial, _, _, _, isIgnored = GetAvailableQuestInfo(index)
            if ((not isTrivial and not isIgnored) or IsTrackingHidden()) then SelectAvailableQuest(index) end
        end
    end
end

function OT:GOSSIP_SHOW()
    local npcID = GetNPCID()
    if (ignoreQuestNPC[npcID]) then return end

    local active = GetNumGossipActiveQuests()
    if (active > 0) then
        local logQuests = GetQuestLogQuests(true)
        for index = 1, active do
            local name, _, _, _, complete = GetActiveGossipQuestInfo(index)
            if (complete) then
                local questID = logQuests[name]
                if (not questID) then
                    SelectGossipActiveQuest(index)
                else
                    local _, _, worldQuest = GetQuestTagInfo(questID)
                    if (not worldQuest) then SelectGossipActiveQuest(index) end
                end
            end
        end
    end

    local available = GetNumGossipAvailableQuests()
    if (available > 0) then
        for index = 1, available do
            local _, _, trivial, ignored = GetAvailableGossipQuestInfo(index)
            if ((not trivial and not ignored) or IsTrackingHidden()) then
                SelectGossipAvailableQuest(index)
            elseif (trivial and npcID == 64337) then
                SelectGossipAvailableQuest(index)
            end
        end
    end

    if (rogueClassHallInsignia[npcID]) then return SelectGossipOption(1) end

    if (available == 0 and active == 0) then
        if GetNumGossipOptions() == 1 then
            if (npcID == 57850) then return SelectGossipOption(1) end

            local _, instance, _, _, _, _, _, mapID = GetInstanceInfo()
            if (instance ~= "raid" and not ignoreGossipNPC[npcID] and not (instance == "scenario" and mapID == 1626)) then
                local _, type = GetGossipOptions()
                if (type == "gossip") then
                    SelectGossipOption(1)
                    return
                end
            end
        elseif followerAssignees[npcID] and GetNumGossipOptions() > 1 then
            return SelectGossipOption(1)
        end
    end
end

function OT:GOSSIP_CONFIRM()
    local npcID = GetNPCID()
    if (npcID and darkmoonNPC[npcID]) then
        local dialog = StaticPopup_FindVisible("GOSSIP_CONFIRM")
        StaticPopup_OnClick(dialog, 1)
    end
end

function OT:QUEST_DETAIL() if (not QuestGetAutoAccept()) then AcceptQuest() end end

function OT:QUEST_ACCEPT_CONFIRM() AcceptQuest() end

function OT:QUEST_ACCEPTED() if (QuestFrame:IsShown() and QuestGetAutoAccept()) then CloseQuest() end end

function OT:QUEST_ITEM_UPDATE() if (choiceQueue and OT[choiceQueue]) then OT[choiceQueue]() end end

function OT:QUEST_PROGRESS()
    if (IsQuestCompletable()) then
        local id, _, worldQuest = GetQuestTagInfo(GetQuestID())
        if id == 153 or worldQuest then return end
        local npcID = GetNPCID()
        if ignoreProgressNPC[npcID] then return end

        local requiredItems = GetNumQuestItems()
        if (requiredItems > 0) then
            for index = 1, requiredItems do
                local link = GetQuestItemLink("required", index)
                if (link) then
                    local id = tonumber(strmatch(link, "item:(%d+)"))
                    for _, itemID in next, itemBlacklist do if (itemID == id) then return end end
                else
                    choiceQueue = "QUEST_PROGRESS"
                    return
                end
            end
        end

        CompleteQuest()
    end
end

function OT:QUEST_COMPLETE()
    -- Blingtron 6000 only!
    local npcID = GetNPCID()
    if npcID == 43929 or npcID == 77789 then return end

    local choices = GetNumQuestChoices()
    if (choices <= 1) then
        GetQuestReward(1)
    elseif (choices > 1) then
        local bestValue, bestIndex = 0

        for index = 1, choices do
            local link = GetQuestItemLink("choice", index)
            if (link) then
                local _, _, _, _, _, _, _, _, _, _, value = GetItemInfo(link)
                value = cashRewards[tonumber(strmatch(link, "item:(%d+):"))] or value

                if (value > bestValue) then bestValue, bestIndex = value, index end
            else
                choiceQueue = "QUEST_COMPLETE"
                return GetQuestItemInfo("choice", index)
            end
        end

        local button = bestIndex and QuestInfoRewardsFrame.RewardButtons[bestIndex]
        if button then QuestInfoItem_OnClick(button) end
    end
end

function OT:PLAYER_LOGIN() AttemptAutoComplete("PLAYER_LOGIN") end

function OT:QUEST_AUTOCOMPLETE() AttemptAutoComplete("QUEST_AUTOCOMPLETE") end

function OT:PLAYER_REGEN_ENABLED() AttemptAutoComplete("PLAYER_REGEN_ENABLED") end

function OT:CreateSwitchButton()
    if self.SwitchButton then return end

    local holder = _G.ObjectiveFrameHolder
    local button = CreateFrame("Frame", nil, UIParent)

    button:SetHeight(20)
    button:SetWidth(60)
    button.text = button:CreateFontString(nil, "OVERLAY")
    button.text:FontTemplate()
    button:SetScript("OnMouseDown", function(self, mouseButton)
        if mouseButton == 'LeftButton' then
            OT.db.auto_turn_in.auto = not OT.db.auto_turn_in.auto
            OT:RefreshAutoTurnIn()
            OT:RefreshSwitchButton()
        end
    end)

    button:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 250)
    self.SwitchButton = button
end

function OT:RefreshAutoTurnIn()
    if self.db.auto_turn_in.auto then
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
    else
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
    end
end

function OT:RefreshSwitchButton()
    local sbdb = self.db.auto_turn_in.switch_button

    -- 按钮显隐操作
    local fade = _G.ObjectiveTrackerFrame.collapsed and sbdb.fade_with_objective_tracker

    if not InCombatLockdown() then
        if sbdb.enabled and not fade then
            self.SwitchButton:Show()
        else
            self.SwitchButton:Hide()
            return
        end
    end

    self.SwitchButton.text:FontTemplate(LSM:Fetch('font', sbdb.font), sbdb.size, sbdb.style)
    self.SwitchButton.text:SetPoint("CENTER", 0, 0)

    local button_width = self.SwitchButton.text:GetStringWidth() + 2
    local button_height = self.SwitchButton.text:GetStringHeight() + 2
    self.SwitchButton:SetSize(button_width, button_height)

    if self.db.auto_turn_in.auto then
        self.SwitchButton.text:SetText(WT:ColorStrWithPack(sbdb.enabled_text, sbdb.enabled_color))
    else
        self.SwitchButton.text:SetText(WT:ColorStrWithPack(sbdb.disabled_text, sbdb.disabled_color))
    end
end

function OT:ChangeFonts()
    local function setHeader()
        local frame = _G.ObjectiveTrackerFrame.MODULES
        if frame then
            for i = 1, #frame do
                local modules = frame[i]
                if modules then
                    local text = modules.Header.Text
                    if OT.db.title then
                        text:FontTemplate(LSM:Fetch('font', OT.db.header.font), OT.db.header.size, OT.db.header.style)
                    end
                end
            end
        end
    end

    local function setText(self, block)
        local text = block.HeaderText
        if text then
            if OT.db.title then
                text:FontTemplate(LSM:Fetch('font', OT.db.title.font), OT.db.title.size, OT.db.title.style)
            end
            for objectiveKey, line in pairs(block.lines) do
                if OT.db.info then
                    line.Text:FontTemplate(LSM:Fetch('font', OT.db.info.font), OT.db.info.size, OT.db.info.style)
                end
            end
        end
    end

    local function hookWQText(self)
        for _, block in pairs(WORLD_QUEST_TRACKER_MODULE.usedBlocks) do
            for objectiveKey, line in pairs(block.lines) do
                if objectiveKey == 0 then
                    if OT.db.title then
                        line.Text:FontTemplate(LSM:Fetch('font', OT.db.title.font), OT.db.title.size, OT.db.title.style)
                    end
                elseif objectiveKey then
                    if OT.db.info then
                        line.Text:FontTemplate(LSM:Fetch('font', OT.db.info.font), OT.db.info.size, OT.db.info.style)
                    end
                end
            end
        end
    end

    local function hookScenarioText(self)
        local s = _G.ScenarioObjectiveBlock
        if s and s.lines then
            for k, v in pairs(s.lines) do
                if v.Text and OT.db and OT.db.info then
                    v.Text:FontTemplate(LSM:Fetch('font', OT.db.info.font), OT.db.info.size, OT.db.info.style)
                end
            end
        end
    end

    hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", setText)
    hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "Update", hookWQText)
    hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, "Update", hookScenarioText)
    hooksecurefunc("ObjectiveTracker_Update", setHeader)

    hooksecurefunc("ScenarioBlocksFrame_SetupStageBlock", function(scenarioCompleted)
        ScenarioStageBlock.CompleteLabel:FontTemplate(LSM:Fetch('font', OT.db.title.font), nil, OT.db.title.style)
    end)

    hooksecurefunc("ScenarioStage_CustomizeBlock", function(stageBlock, scenarioType, widgetSetID, textureKitID)
        if stageBlock.Stage and OT.db and OT.db.title then
            stageBlock.Stage:FontTemplate(LSM:Fetch('font', OT.db.title.font), OT.db.title.size, OT.db.title.style)
        end
    end)
end

function OT:ChangeColors()
    if not IsAddOnLoaded("Blizzard_ObjectiveTracker") then return end

    -- Title color
    if self.db.title.color.enabled then
        local db = self.db.title.color
        local class_color = _G.RAID_CLASS_COLORS[E.myclass]

        local cr = db.class_color and class_color.r or db.custom_color.r
        local cg = db.class_color and class_color.g or db.custom_color.g
        local cb = db.class_color and class_color.b or db.custom_color.b
        _G.OBJECTIVE_TRACKER_COLOR["Header"] = {r = cr, g = cg, b = cb}

        local cr = db.class_color and class_color.r or db.custom_color_highlight.r
        local cg = db.class_color and class_color.g or db.custom_color_highlight.g
        local cb = db.class_color and class_color.b or db.custom_color_highlight.b
        _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"] = {r = cr, g = cg, b = cb}
    end
end

function OT:PLAYER_ENTERING_WORLD()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    C_Timer.After(1.5, function() OT:RefreshSwitchButton() end)
end

function OT:Initialize()
    if not E.db.WindTools.Quest["Objective Tracker"].enabled then return end
    if not IsAddOnLoaded("Blizzard_ObjectiveTracker") then return end

    self.db = E.db.WindTools.Quest["Objective Tracker"]
    tinsert(WT.UpdateAll, function()
        OT.db = E.db.WindTools.Quest["Objective Tracker"]
        OT:ChangeColors()
        OT:CreateSwitchButton()
        OT:RefreshAutoTurnIn()
        OT:RefreshSwitchButton()
    end)

    self:ChangeFonts()
    self:ChangeColors()

    self:CreateSwitchButton()
    E:CreateMover(self.SwitchButton, "Wind_TurnInSwitchButton", L["Auto Turn In Button"], nil, nil, nil,
                  'WINDTOOLS,ALL', function() return OT.db.auto_turn_in.switch_button.enabled; end)

    WT.UpdateSwitchButton = function() OT:RefreshSwitchButton() end

    hooksecurefunc(_G.ObjectiveTrackerFrame.BlocksFrame, "Show", function() OT:RefreshSwitchButton() end)
    hooksecurefunc(_G.ObjectiveTrackerFrame.BlocksFrame, "Hide", function() OT:RefreshSwitchButton() end)

    self:RefreshAutoTurnIn()
    self:RefreshSwitchButton()

    self:RegisterEvent("PLAYER_ENTERING_WORLD")

end

local function InitializeCallback() OT:Initialize() end

E:RegisterModule(OT:GetName(), InitializeCallback)
