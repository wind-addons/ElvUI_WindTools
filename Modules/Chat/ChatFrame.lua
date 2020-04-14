-- 原创模块
-- 部分功能改自TinyChat
-- https://nga.178.com/read.php?tid=10240957
-- 部分修改来源于爱不易
local E, L, V, P, G = unpack(ElvUI) -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local WT = E:GetModule("WindTools")
local CF = E:NewModule('Wind_ChatFrame', 'AceHook-3.0', 'AceEvent-3.0')
local S = E:GetModule('Skins')
local M = E:GetModule('Misc')

local _G = _G
local select = select
local match = string.match
local format = format
local pairs = pairs
local unpack = unpack
local tostring = tostring
local hooksecurefunc = hooksecurefunc
local ceil = ceil
local tonumber = tonumber

local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME

local GetItemInfo = GetItemInfo
local GetSpellInfo = GetSpellInfo
local GetLocale = GetLocale
local CreateFrame = CreateFrame
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local IsInGuild = IsInGuild
local CanEditOfficerNote = CanEditOfficerNote
local UnitIsGroupAssistant = UnitIsGroupAssistant
local IsEveryoneAssistant = IsEveryoneAssistant
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitInBattleground = UnitInBattleground
local UnitFullName = UnitFullName

local ClientLang = GetLocale()

-------------------------------------
-- 物品等级，图标
local ItemLevelTooltip = CreateFrame("GameTooltip", "Wind_ChatLinkTooltip", UIParent, "GameTooltipTemplate")
local ItemLevelPattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)")
local ItemPowerPattern = gsub(CHALLENGE_MODE_ITEM_POWER_LEVEL, "%%d", "(%%d+)")
local ItemNamePattern = gsub(CHALLENGE_MODE_KEYSTONE_NAME, "%%s", "(.+)")

local IconString = "|T%s:18:21:0:0:64:64:5:59:10:54"

local SearchArmorType = {
    INVTYPE_HEAD = true,
    INVTYPE_SHOULDER = true,
    INVTYPE_CHEST = true,
    INVTYPE_WRIST = true,
    INVTYPE_HAND = true,
    INVTYPE_WAIST = true,
    INVTYPE_LEGS = true,
    INVTYPE_FEET = true
}

local abbrList = {
    INVTYPE_HEAD = L["Head_Abbr"],
    INVTYPE_NECK = L["Neck_Abbr"],
    INVTYPE_SHOULDER = L["Shoulders_Abbr"],
    INVTYPE_CLOAK = L["Back_Abbr"],
    INVTYPE_CHEST = L["Chest_Abbr"],
    INVTYPE_WRIST = L["Wrist_Abbr"],
    INVTYPE_HAND = L["Hands_Abbr"],
    INVTYPE_WAIST = L["Waist_Abbr"],
    INVTYPE_LEGS = L["Legs_Abbr"],
    INVTYPE_FEET = L["Feet_Abbr"],
    INVTYPE_HOLDABLE = L["Held In Off-hand_Abbr"],
    INVTYPE_FINGER = L["Finger_Abbr"],
    INVTYPE_TRINKET = L["Trinket_Abbr"]
}

local function AddItemInfo(Hyperlink)
    local id = match(Hyperlink, "Hitem:(%d-):")
    if (not id) then return end
    id = tonumber(id)

    -- 获取物品实际等级
    if CF.db.link.add_level or CF.db.link.add_slot then
        local text, level, extraname, slot
        local link = match(Hyperlink, "|H(.-)|h")
        ItemLevelTooltip:SetOwner(UIParent, "ANCHOR_NONE")
        ItemLevelTooltip:ClearLines()
        ItemLevelTooltip:SetHyperlink(link)

        if CF.db.link.add_level then
            for i = 2, 5 do
                local leftText = _G[ItemLevelTooltip:GetName() .. "TextLeft" .. i]
                if leftText then
                    text = leftText:GetText() or ""
                    level = match(text, ItemLevelPattern)
                    if (level) then break end
                    level = match(text, ItemPowerPattern)
                    if (level) then
                        extraname = match(_G[ItemLevelTooltip:GetName() .. "TextLeft1"]:GetText(), ItemNamePattern)
                        break
                    end
                end
            end
        end

        -- 获取是护甲还是武器
        local type = select(6, GetItemInfo(id))
        -- 护甲类
        if type == _G.ARMOR and CF.db.link.add_armor_category then
            local equipLoc = select(9, GetItemInfo(id))
            if equipLoc ~= "" then
                if SearchArmorType[equipLoc] then
                    -- 如果有护甲分类的
                    local armorType = select(7, GetItemInfo(id))
                    if ClientLang == "zhTW" or ClientLang == "zhCN" then
                        slot = armorType .. (abbrList[equipLoc] or _G[equipLoc])
                    else
                        slot = armorType .. " " .. (abbrList[equipLoc] or _G[equipLoc])
                    end

                else
                    slot = abbrList[equipLoc] or _G[equipLoc]
                end
            end
        end

        -- 武器类
        if type == _G.WEAPON and CF.db.link.add_weapon_category then
            local equipLoc = select(9, GetItemInfo(id))
            if equipLoc ~= "" then
                local weaponType = select(7, GetItemInfo(id))
                slot = weaponType or abbrList[equipLoc] or _G[equipLoc]
            end
        end

        if (level and extraname) then
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. level .. ":%1:" .. extraname .. "]|h")
        elseif (level and slot) then
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. level .. "-" .. slot .. ":%1]|h")
        elseif (level) then
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. level .. ":%1]|h")
        elseif (slot) then
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. slot .. ":%1]|h")
        end
    end

    -- 腐化信息+
    if CF.db.link.add_corruption_rank then
        local corruptionInfo = E:GetModule("Wind_CorruptionRank"):Corruption_Search(Hyperlink)

        if corruptionInfo then
            local spellName = GetSpellInfo(corruptionInfo.spellID)
            local levelText = corruptionInfo.level
            levelText = levelText:gsub("%s?%(.-%)", "")
            if levelText ~= "" then
                -- 阿拉伯数字貌似好看点？
                spellName = spellName .. string.len(levelText)
            end
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[%1/" .. spellName .. "]|h")
        end
    end

    if CF.db.link.add_icon then
        local texture = GetItemIcon(id)
        local icon = format(IconString .. ":255:255:255|t", texture)
        Hyperlink = icon .. " " .. Hyperlink
    end

    return Hyperlink
end

local function AddSpellInfo(Hyperlink)
    -- 法术图标也要！
    local id = match(Hyperlink, "Hspell:(%d-):")
    if (not id) then return end

    if CF.db.link.add_icon then
        local texture = GetSpellTexture(tonumber(id))
        local icon = format(IconString .. ":255:255:255|t", texture)
        Hyperlink = icon .. " " .. Hyperlink
    end

    return Hyperlink
end

function CF:InitializeLink()
    if not self.db.link.enabled then return end

    local function filter(self, event, msg, ...)
        msg = msg:gsub("(|Hitem:%d+:.-|h.-|h)", AddItemInfo)
        msg = msg:gsub("(|Hspell:%d+:%d+|h.-|h)", AddSpellInfo)
        return false, msg, ...
    end

    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", filter)
end

-------------------------------------
-- Tab 智能切换

-- 频道循环列表
local ChannelList = {
    "SAY", "YELL", "PARTY", "INSTANCE_CHAT", "RAID", "RAID_WARNING", "BATTLEGROUND", "GUILD", "OFFICER"
}
local ChannelListWithWhisper = {
    "SAY", "YELL", "PARTY", "INSTANCE_CHAT", "RAID", "RAID_WARNING", "BATTLEGROUND", "GUILD", "OFFICER", "WHISPER",
    "BN_WHISPER"
}

-- 缓存 Index 方便查找
local NumberOfChannelList = #ChannelList
local NumberOfChannelListWithWhisper = #ChannelListWithWhisper

local IndexOfChannelList = {}
local IndexOfChannelListWithWhisper = {}

for k, v in pairs(ChannelList) do IndexOfChannelList[v] = k end
for k, v in pairs(ChannelListWithWhisper) do IndexOfChannelListWithWhisper[v] = k end

-- 用于锁定对象
local nextChatType
local nextTellTarget

function CF:CheckAvailability(type)
    if type == "YELL" then
        return self.db.smart_tab.use_yell
    elseif type == "PARTY" then
        return IsInGroup(LE_PARTY_CATEGORY_HOME)
    elseif type == "INSTANCE_CHAT" then
        return IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
    elseif type == "RAID" then
        return IsInRaid()
    elseif type == "RAID_WARNING" then
        if self.db.smart_tab.use_raid_warning and IsInRaid() then
            if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant() then
                return true
            end
        end
        return false
    elseif type == "BATTLEGROUND" then
        return UnitInBattleground("player")
    elseif type == "GUILD" then
        return IsInGuild()
    elseif type == "OFFICER" then
        return self.db.smart_tab.use_officer and IsInGuild() and CanEditOfficerNote()
    end

    return true
end

function CF:RefreshWhisperTargets()
    if not self.db.smart_tab.whisper_targets then return 0 end

    local newTargets = {}
    local currentTime = time()
    local expirationTime = self.db.smart_tab.whisper_history_time and 60 * self.db.smart_tab.whisper_history_time or 600

    local numberOfTargets = 0

    for target, data in pairs(self.db.smart_tab.whisper_targets) do
        local targetTime, targetType = unpack(data)
        if (currentTime - targetTime) < expirationTime then
            newTargets[target] = {targetTime, targetType}
            numberOfTargets = numberOfTargets + 1
        end
    end

    wipe(self.db.smart_tab.whisper_targets)
    self.db.smart_tab.whisper_targets = newTargets

    return numberOfTargets
end

function CF:UpdateWhisperTargets(target, chatTime, type)
    if not self.db.smart_tab.whisper_targets then return end
    local currentTime = chatTime or time()

    -- 本服玩家去除服务器名
    local name, server = strsplit("-", target)
    if (server) and (server == self.ServerName) then target = name end

    self.db.smart_tab.whisper_targets[target] = {currentTime, type}
end

function CF:GetNextWhisper(currentTarget)
    local chatType = "NONE"
    local tellTarget = nil
    local oldTime = 0
    local limit = time()
    local needSwitch = false

    if self:RefreshWhisperTargets() ~= 0 then
        -- 设定一定要早于当前密语历史目标
        if currentTarget and self.db.smart_tab.whisper_targets[currentTarget] then
            limit = self.db.smart_tab.whisper_targets[currentTarget][1]
        end

        -- 当前不是密语状况下就算一个历史数据也要切换过去
        if not currentTarget then needSwitch = true end

        -- 遍历历史寻找到 早一个历史目标 或者 初始化频道变换的目标
        for target, data in pairs(self.db.smart_tab.whisper_targets) do
            local targetTime, targetType = unpack(data)
            if (targetTime > oldTime and targetTime < limit) or needSwitch then
                tellTarget = target
                chatType = targetType
                oldTime = targetTime
                needSwitch = false
            end
        end
    end

    return chatType, tellTarget
end

-- 仅用来密语独立循环使用
function CF:GetLastWhisper()
    local chatType = "NONE"
    local tellTarget = nil
    local oldTime = 0
    local limit = time()
    local needSwitch = false

    if self:RefreshWhisperTargets() ~= 0 then
        -- 遍历历史寻找到 最后一个历史目标
        for target, data in pairs(self.db.smart_tab.whisper_targets) do
            local targetTime, targetType = unpack(data)
            if (targetTime > oldTime) then
                tellTarget = target
                chatType = targetType
                oldTime = targetTime
            end
        end
    end

    return chatType, tellTarget
end

function CF:GetNext(chatType, currentTarget)
    local newChatType, newTarget, nextIndex

    if chatType == "CHANNEL" then chatType = "SAY" end

    if self.db.smart_tab.whisper_cycle then
        if chatType == "WHISPER" or chatType == "BN_WHISPER" then
            -- 密语+战网聊天限定进行寻找
            newChatType, newTarget = self:GetNextWhisper(currentTarget)
            if newChatType == "NONE" then
                -- 如果没有更早的目标，就尝试获取表内最后一个
                newChatType, newTarget = self:GetLastWhisper()
                if newChatType == "NONE" then
                    -- 如果表内为空，则什么都不改变
                    newChatType = chatType
                    newTarget = currentTarget
                    UIErrorsFrame:AddMessage(L["There is no more whisper targets"], 1, 0, 0, 53, 5);
                end
            end
        else
            -- 常规的频道变换
            nextIndex = IndexOfChannelList[chatType] % NumberOfChannelList + 1
            while (not CF:CheckAvailability(ChannelList[nextIndex])) do
                nextIndex = nextIndex % NumberOfChannelList + 1
            end
            newChatType = ChannelListWithWhisper[nextIndex]
        end
    else
        if chatType == "WHISPER" or chatType == "BN_WHISPER" then
            -- 如果当前就在密语状况中，直接查找下一个密语目标
            newChatType, newTarget = self:GetNextWhisper(currentTarget)
            if newChatType == "NONE" then
                -- 如果当前用户已经是密语循环的最后或者没有密语历史目标，跳到说
                newChatType = ChannelListWithWhisper[1]
            end
        else
            -- 正常的一个频道循环
            nextIndex = IndexOfChannelListWithWhisper[chatType] % NumberOfChannelListWithWhisper + 1
            while (not CF:CheckAvailability(ChannelListWithWhisper[nextIndex])) do
                nextIndex = nextIndex % NumberOfChannelListWithWhisper + 1
            end
            -- 一旦循环到密语部分，就进行特殊处理
            newChatType = ChannelListWithWhisper[nextIndex]
            if newChatType == "WHISPER" or newChatType == "BN_WHISPER" then
                -- 查找下一个密语目标
                newChatType, newTarget = self:GetNextWhisper(tellTarget)
                if newChatType == "NONE" then
                    -- 如果当前用户已经是密语循环的最后或者没有密语历史目标，跳到说
                    newChatType = ChannelListWithWhisper[1]
                end
            end
        end
    end

    return newChatType, newTarget
end

function CF:TabPressed()
    if strsub(tostring(self:GetText()), 1, 1) == "/" then return end

    nextChatType, nextTellTarget = nil, nil
    nextChatType, nextTellTarget = CF:GetNext(self:GetAttribute("chatType"), self:GetAttribute("tellTarget"))
end

function CF:SetNewChat()
    self:SetAttribute("chatType", nextChatType)

    if nextTellTarget then self:SetAttribute("tellTarget", nextTellTarget) end

    ACTIVE_CHAT_EDIT_BOX = self
    LAST_ACTIVE_CHAT_EDIT_BOX = self

    ChatEdit_UpdateHeader(self)
end

-- 接收密语
function CF:CHAT_MSG_WHISPER(_, _, author)
    -- 自己别给自己发
    if author == self.PlayerName .. "-" .. self.ServerName then return end
    self:UpdateWhisperTargets(author, nil, "WHISPER")
end

-- 发送密语
function CF:CHAT_MSG_WHISPER_INFORM(_, _, author)
    -- 自己别给自己发
    if author == self.PlayerName .. "-" .. self.ServerName then return end
    self:UpdateWhisperTargets(author, nil, "WHISPER")
end

-- 接收战网聊天
function CF:CHAT_MSG_BN_WHISPER(_, _, author) self:UpdateWhisperTargets(author, nil, "BN_WHISPER") end

-- 发送战网聊天
function CF:CHAT_MSG_BN_WHISPER_INFORM(_, _, author) self:UpdateWhisperTargets(author, nil, "BN_WHISPER") end

function CF:InitializeSmartTab()
    if not self.db.smart_tab.enabled then return end
    -- 缓存 { 密语对象 = {时间, 方式} }
    if not self.db.smart_tab.whisper_targets then self.db.smart_tab.whisper_targets = {} end
    self:RefreshWhisperTargets()
    self.PlayerName, self.ServerName = UnitFullName("player")

    hooksecurefunc("ChatEdit_CustomTabPressed", CF.TabPressed)
    hooksecurefunc("ChatEdit_SecureTabPressed", CF.SetNewChat)

    self:RegisterEvent("CHAT_MSG_WHISPER")
    self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
    self:RegisterEvent("CHAT_MSG_BN_WHISPER")
    self:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
end

-------------------------------------
-- 表情

local emotes = {
    {key = "angel", zhTW = "天使", zhCN = "天使"}, {key = "angry", zhTW = "生氣", zhCN = "生气"},
    {key = "biglaugh", zhTW = "大笑", zhCN = "大笑"}, {key = "clap", zhTW = "鼓掌", zhCN = "鼓掌"},
    {key = "cool", zhTW = "酷", zhCN = "酷"}, {key = "cry", zhTW = "哭", zhCN = "哭"},
    {key = "cutie", zhTW = "可愛", zhCN = "可爱"}, {key = "despise", zhTW = "鄙視", zhCN = "鄙视"},
    {key = "dreamsmile", zhTW = "美夢", zhCN = "美梦"}, {key = "embarrass", zhTW = "尷尬", zhCN = "尴尬"},
    {key = "evil", zhTW = "邪惡", zhCN = "邪恶"}, {key = "excited", zhTW = "興奮", zhCN = "兴奋"},
    {key = "faint", zhTW = "暈", zhCN = "晕"}, {key = "fight", zhTW = "打架", zhCN = "打架"},
    {key = "flu", zhTW = "流感", zhCN = "流感"}, {key = "freeze", zhTW = "呆", zhCN = "呆"},
    {key = "frown", zhTW = "皺眉", zhCN = "皱眉"}, {key = "greet", zhTW = "致敬", zhCN = "致敬"},
    {key = "grimace", zhTW = "鬼臉", zhCN = "鬼脸"}, {key = "growl", zhTW = "齜牙", zhCN = "龇牙"},
    {key = "happy", zhTW = "開心", zhCN = "开心"}, {key = "heart", zhTW = "心", zhCN = "心"},
    {key = "horror", zhTW = "恐懼", zhCN = "恐惧"}, {key = "ill", zhTW = "生病", zhCN = "生病"},
    {key = "innocent", zhTW = "無辜", zhCN = "无辜"}, {key = "kongfu", zhTW = "功夫", zhCN = "功夫"},
    {key = "love", zhTW = "花痴", zhCN = "花痴"}, {key = "mail", zhTW = "郵件", zhCN = "邮件"},
    {key = "makeup", zhTW = "化妝", zhCN = "化妆"}, {key = "mario", zhTW = "馬里奧", zhCN = "马里奥"},
    {key = "meditate", zhTW = "沉思", zhCN = "沉思"}, {key = "miserable", zhTW = "可憐", zhCN = "可怜"},
    {key = "okay", zhTW = "好", zhCN = "好"}, {key = "pretty", zhTW = "漂亮", zhCN = "漂亮"},
    {key = "puke", zhTW = "吐", zhCN = "吐"}, {key = "shake", zhTW = "握手", zhCN = "握手"},
    {key = "shout", zhTW = "喊", zhCN = "喊"}, {key = "shuuuu", zhTW = "閉嘴", zhCN = "闭嘴"},
    {key = "shy", zhTW = "害羞", zhCN = "害羞"}, {key = "sleep", zhTW = "睡覺", zhCN = "睡觉"},
    {key = "smile", zhTW = "微笑", zhCN = "微笑"}, {key = "suprise", zhTW = "吃驚", zhCN = "吃惊"},
    {key = "surrender", zhTW = "失敗", zhCN = "失败"}, {key = "sweat", zhTW = "流汗", zhCN = "流汗"},
    {key = "tear", zhTW = "流淚", zhCN = "流泪"}, {key = "tears", zhTW = "悲劇", zhCN = "悲剧"},
    {key = "think", zhTW = "想", zhCN = "想"}, {key = "titter", zhTW = "偷笑", zhCN = "偷笑"},
    {key = "ugly", zhTW = "猥瑣", zhCN = "猥琐"}, {key = "victory", zhTW = "勝利", zhCN = "胜利"},
    {key = "volunteer", zhTW = "雷鋒", zhCN = "雷锋"}, {key = "wronged", zhTW = "委屈", zhCN = "委屈"},
    -- 指定了texture一般用於BLIZ自帶的素材
    {key = "wrong", zhTW = "錯", zhCN = "错", texture = "Interface\\RaidFrame\\ReadyCheck-NotReady"},
    {key = "right", zhTW = "對", zhCN = "对", texture = "Interface\\RaidFrame\\ReadyCheck-Ready"},
    {key = "question", zhTW = "疑問", zhCN = "疑问", texture = "Interface\\RaidFrame\\ReadyCheck-Waiting"},
    {key = "skull", zhTW = "骷髏", zhCN = "骷髅", texture = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull"},
    {key = "sheep", zhTW = "羊", zhCN = "羊", texture = "Interface\\TargetingFrame\\UI-TargetingFrame-Sheep"}
}

local function EmoteButton_OnClick(self, button)
    local editBox = ChatEdit_ChooseBoxForSend()
    ChatEdit_ActivateChat(editBox)
    editBox:SetText(editBox:GetText():gsub("{$", "") .. self.emote)
    if (button == "LeftButton") then self:GetParent():Hide() end
end

local function EmoteButton_OnEnter(self) self:GetParent().title:SetText(self.emote) end

local function EmoteButton_OnLeave(self) self:GetParent().title:SetText("") end

local function ReplaceEmote(value)
    local emote = value:gsub("[%{%}]", "")
    for _, v in ipairs(emotes) do
        if (emote == v.key or emote == v.zhCN or emote == v.zhTW) then
            return "|T" .. (v.texture or "Interface\\AddOns\\ElvUI_WindTools\\Texture\\Emotes\\" .. v.key) .. ":" ..
                       CF.db.emote.size .. "|t"
        end
    end
    return value
end

function CF:CreateInterface()
    local button
    local width, height, column, space = 20, 20, 10, 6
    local index = 0
    -- 创建 ElvUI 风格框体
    local frame = CreateFrame("Frame", "Wind_CustomEmoteFrame", UIParent, "UIPanelDialogTemplate")
    _G.Wind_CustomEmoteFrameTitleBG:Hide()
    _G.Wind_CustomEmoteFrameDialogBG:Hide()
    frame:StripTextures()
    frame:CreateBackdrop('Transparent')
    frame:CreateShadow()
    S:HandleCloseButton(_G.Wind_CustomEmoteFrameClose)

    -- 定位
    frame:SetWidth(column * (width + space) + 24)
    frame:SetClampedToScreen(true)
    frame:SetFrameStrata("DIALOG")
    frame:SetPoint("LEFT", ChatFrame1, "RIGHT", 60, 0)

    -- 拖动
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")

    frame:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" and not self.isMoving then
            self:StartMoving();
            self.isMoving = true;
        end
    end)
    frame:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" and self.isMoving then
            self:StopMovingOrSizing();
            self.isMoving = false;
        elseif button == "RightButton" and not self.isMoving then
            -- 右键复原
            self:ClearAllPoints()
            self:SetPoint("LEFT", ChatFrame1, "RIGHT", 60, 0)
        end
    end)
    frame:SetScript("OnHide", function(self)
        if (self.isMoving) then
            self:StopMovingOrSizing();
            self.isMoving = false;
        end
    end)

    -- 标题
    frame.title = frame:CreateFontString(nil, "ARTWORK", "ChatFontNormal")
    frame.title:SetPoint("TOP", frame, "TOP", 0, -9)
    frame.title:FontTemplate(E.media.normFont, 16, newStyle)

    -- 帮助提示
    local tipsButton = CreateFrame("Frame", nil, frame)
    tipsButton:SetSize(25, 25)
    tipsButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -4)
    tipsButton.text = tipsButton:CreateFontString(nil, "ARTWORK")
    tipsButton.text:SetPoint("CENTER", 0, 0)
    tipsButton.text:FontTemplate(E.media.normFont, 14, newStyle)
    tipsButton.text:SetText("?")
    tipsButton:SetScript("OnEnter", function() frame.title:SetText(L["Move (L\124\124R) Reset"]) end)
    tipsButton:SetScript("OnLeave", function() frame.title:SetText("") end)

    -- 建立表情
    for _, v in ipairs(emotes) do
        button = CreateFrame("Button", nil, frame)
        button.emote = "{" .. (v[ClientLang] or v.key) .. "}"
        button:SetSize(width, height)
        if (v.texture) then
            button:SetNormalTexture(v.texture)
        else
            button:SetNormalTexture("Interface\\AddOns\\ElvUI_WindTools\\Texture\\Emotes\\" .. v.key)
        end
        button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
        button:SetPoint("TOPLEFT", 16 + (index % column) * (width + space),
                        -36 - floor(index / column) * (height + space))
        button:SetScript("OnMouseUp", EmoteButton_OnClick)
        button:SetScript("OnEnter", EmoteButton_OnEnter)
        button:SetScript("OnLeave", EmoteButton_OnLeave)
        index = index + 1
    end
    frame:SetHeight(ceil(index / column) * (height + space) + 46)
    frame:Hide()
    -- 让输入框支持当输入 { 时自动弹出聊天表情选择框
    hooksecurefunc("ChatEdit_OnTextChanged", function(self, userInput)
        local text = self:GetText()
        if (userInput and (strsub(text, -1) == "{" or strsub(text, -1) == "｛")) then frame:Show() end
    end)
end

function CF:HandleEmoteWithBubble()
    hooksecurefunc(M, "SkinBubble", function(self, frame)
        print(frame.text:GetText())
        if frame.text then frame.text:SetText(self.text:gsub("%{.-%}", ReplaceEmote)) end
    end)
end

function CF:InitializeEmote()
    if not self.db.emote.enabled then return end

    local function filter(self, event, msg, ...)
        msg = msg:gsub("%{.-%}", ReplaceEmote)
        return false, msg, ...
    end

    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", filter)

    self:CreateInterface()
    -- self:HandleEmoteWithBubble()
end

-------------------------------------
-- 初始化
function CF:Initialize()
    if not E.db.WindTools["Chat"]["Chat Frame"]["enabled"] then return end
    self.db = E.db.WindTools["Chat"]["Chat Frame"]

    tinsert(WT.UpdateAll, function() CF.db = E.db.WindTools["Chat"]["Chat Frame"] end)

    self:InitializeLink()
    self:InitializeSmartTab()
    self:InitializeEmote()
end

local function InitializeCallback() CF:Initialize() end

E:RegisterModule(CF:GetName(), InitializeCallback)
