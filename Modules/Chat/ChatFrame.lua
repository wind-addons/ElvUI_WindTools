-- 原创模块
-- 部分功能改自TinyChat
-- https://nga.178.com/read.php?tid=10240957
-- 部分修改来源于爱不易
local E, L, V, P, G = unpack(ElvUI) -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local WT = E:GetModule("WindTools")
local CF = E:NewModule('Wind_ChatFrame', 'AceHook-3.0', 'AceEvent-3.0')

local _G = _G
local select = select
local match = string.match
local format = format
local pairs = pairs
local unpack = unpack
local tostring = tostring
local hooksecurefunc = hooksecurefunc

local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME

local GetItemInfo = GetItemInfo
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local IsInGuild = IsInGuild
local CanEditOfficerNote = CanEditOfficerNote
local UnitIsGroupAssistant = UnitIsGroupAssistant
local IsEveryoneAssistant = IsEveryoneAssistant
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitInBattleground = UnitInBattleground
local UnitFullName = UnitFullName

-------------------------------------
-- 物品等级，图标
local ItemLevelTooltip = CreateFrame("GameTooltip", "ChatLinkLevelTooltip",
                                     UIParent, "GameTooltipTemplate")

local ItemLevelPattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)")
local ItemPowerPattern = gsub(CHALLENGE_MODE_ITEM_POWER_LEVEL, "%%d", "(%%d+)")
local ItemNamePattern = gsub(CHALLENGE_MODE_KEYSTONE_NAME, "%%s", "(.+)")

local IconString = "|T%s:18:21:0:0:64:64:5:59:10:54"

local function AddLinkInfo(Hyperlink)
    local link = match(Hyperlink, "|H(.-)|h")
    local texture = select(10, GetItemInfo(link))
    if (not texture) then return end
    -- 获取物品实际等级
    if CF.db.item_link.add_level then
        local text, level, extraname
        ItemLevelTooltip:SetOwner(UIParent, "ANCHOR_NONE")
        ItemLevelTooltip:ClearLines()
        ItemLevelTooltip:SetHyperlink(link)
        for i = 2, 4 do
            text =
                _G[ItemLevelTooltip:GetName() .. "TextLeft" .. i]:GetText() or
                    ""
            level = match(text, ItemLevelPattern)
            if (level) then break end
            level = match(text, ItemPowerPattern)
            if (level) then
                extraname = match(
                                _G[ItemLevelTooltip:GetName() .. "TextLeft1"]:GetText(),
                                ItemNamePattern)
                break
            end
        end

        if (level and extraname) then
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h",
                                       "|h[" .. level .. ":%1:" .. extraname ..
                                           "]|h")
        elseif (level) then
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h",
                                       "|h[" .. level .. ":%1]|h")
        end
    end

    if CF.db.item_link.add_icon then
        local icon = format(IconString .. ":255:255:255|t", texture)
        Hyperlink = icon .. " " .. Hyperlink
    end

    return Hyperlink
end

function CF:FilterLinkLevel(event, msg, ...)
    if true then msg = msg:gsub("(|Hitem:%d+:.-|h.-|h)", AddLinkInfo) end
    return false, msg, ...
end

function CF:InitializeItemLink()
    if not self.db.item_link.enabled then return end
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", CF.FilterLinkLevel)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", CF.FilterLinkLevel)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", CF.FilterLinkLevel)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", CF.FilterLinkLevel)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", CF.FilterLinkLevel)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM",
                                    CF.FilterLinkLevel)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", CF.FilterLinkLevel)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", CF.FilterLinkLevel)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", CF.FilterLinkLevel)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", CF.FilterLinkLevel)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", CF.FilterLinkLevel)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", CF.FilterLinkLevel)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", CF.FilterLinkLevel)
end

-------------------------------------
-- Tab 智能切换

-- 频道循环列表
local ChannelList = {
    "SAY", "YELL", "PARTY", "INSTANCE_CHAT", "RAID", "RAID_WARNING",
    "BATTLEGROUND", "GUILD", "OFFICER"
}
local ChannelListWithWhisper = {
    "SAY", "YELL", "PARTY", "INSTANCE_CHAT", "RAID", "RAID_WARNING",
    "BATTLEGROUND", "GUILD", "OFFICER", "WHISPER", "BN_WHISPER"
}

-- 缓存 Index 方便查找
local NumberOfChannelList = #ChannelList
local NumberOfChannelListWithWhisper = #ChannelListWithWhisper

local IndexOfChannelList = {}
local IndexOfChannelListWithWhisper = {}

for k, v in pairs(ChannelList) do IndexOfChannelList[v] = k end
for k, v in pairs(ChannelListWithWhisper) do IndexOfChannelListWithWhisper[v] =
    k end

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
            if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or
                IsEveryoneAssistant() then return true end
        end
        return false
    elseif type == "BATTLEGROUND" then
        return UnitInBattleground("player")
    elseif type == "GUILD" then
        return IsInGuild()
    elseif type == "OFFICER" then
        return self.db.smart_tab.use_officer and IsInGuild() and
                   CanEditOfficerNote()
    end

    return true
end

function CF:RefreshWhisperTargets()
    if not self.db.smart_tab.whisper_targets then return 0 end

    local newTargets = {}
    local currentTime = time()
    local expirationTime = self.db.smart_tab.whisper_history_time and 60 *
                               self.db.smart_tab.whisper_history_time or 600

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
                    UIErrorsFrame:AddMessage(
                        L["There is no more whisper targets"], 1, 0, 0, 53, 5);
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
            nextIndex = IndexOfChannelListWithWhisper[chatType] %
                            NumberOfChannelListWithWhisper + 1
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
    nextChatType, nextTellTarget = CF:GetNext(self:GetAttribute("chatType"),
                                              self:GetAttribute("tellTarget"))
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
function CF:CHAT_MSG_BN_WHISPER(_, _, author)
    self:UpdateWhisperTargets(author, nil, "BN_WHISPER")
end

-- 发送战网聊天
function CF:CHAT_MSG_BN_WHISPER_INFORM(_, _, author)
    self:UpdateWhisperTargets(author, nil, "BN_WHISPER")
end

function CF:InitializeSmartTab()
    if not self.db.smart_tab.enabled then return end
    -- 缓存 { 密语对象 = {时间, 方式} }
    if not self.db.smart_tab.whisper_targets then
        self.db.smart_tab.whisper_targets = {}
    end
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
-- 初始化
function CF:Initialize()
    if not E.db.WindTools["Chat"]["Chat Frame"] then return end
    self.db = E.db.WindTools["Chat"]["Chat Frame"]

    tinsert(WT.UpdateAll,
            function() CF.db = E.db.WindTools["Chat"]["Chat Frame"] end)

    self:InitializeItemLink()
    self:InitializeSmartTab()

end

local function InitializeCallback() CF:Initialize() end

E:RegisterModule(CF:GetName(), InitializeCallback)
