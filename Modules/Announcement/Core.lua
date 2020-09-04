local W, F, E, L = unpack(select(2, ...))
local A = W:NewModule("Announcement", "AceEvent-3.0")

local _G = _G
local pairs = pairs
local tinsert, xpcall, next, assert, format, strsub = tinsert, xpcall, next, assert, format, strsub
local SendChatMessage, C_ChatInfo_SendAddonMessage = SendChatMessage, C_ChatInfo.SendAddonMessage
local IsInGroup, IsInRaid = IsInGroup, IsInRaid
local UnitIsGroupLeader, UnitIsGroupAssistant = UnitIsGroupLeader, UnitIsGroupAssistant
local IsEveryoneAssistant = IsEveryoneAssistant

local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME

--[[
    发送消息
    @param {string} text 欲发送的字符串
    @param {string} channel 频道
    @param {boolean} raid_warning 允许使用团队警告
    @param {string} whisper_target 密语目标
]]
function A:SendMessage(text, channel, raid_warning, whisper_target)
    -- 忽视不通告讯息
    if channel == "NONE" then
        return
    end
    -- 聊天框输出
    if channel == "SELF" then
        _G.ChatFrame1:AddMessage(text)
        return
    end
    -- 密语
    if channel == "WHISPER" then
        if whisper_target then
            SendChatMessage(text, channel, nil, whisper_target)
        end
        return
    end
    -- 表情频道前置冒号以优化显示
    if channel == "EMOTE" then
        text = ": " .. text
    end
    -- 如果允许团队警告
    if channel == "RAID" and raid_warning and IsInRaid(LE_PARTY_CATEGORY_HOME) then
        if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant() then
            channel = "RAID_WARNING"
        end
    end

    SendChatMessage(text, channel)
end

--[[
    获取最适合的频道
    @param {object} channelDB 频道配置
    @return {string} 频道
]]
function A:GetChannel(channelDB)
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
        return channelDB.instance
    elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
        return channelDB.raid
    elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
        return channelDB.party
    elseif channelDB.solo then
        return channelDB.solo
    end
    return "NONE"
end

function A:SendAddonMessage(message)
    if not IsInGroup() then
        return
    end
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
        C_ChatInfo_SendAddonMessage(self.Prefix, message, "INSTANCE")
    elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
        C_ChatInfo_SendAddonMessage(self.Prefix, message, "RAID")
    elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
        C_ChatInfo_SendAddonMessage(self.Prefix, message, "PARTY")
    end
end

function A:GetPetInfo(petName)
    E.ScanTooltip:SetOwner(_G.UIParent, "ANCHOR_NONE")
    E.ScanTooltip:ClearLines()
    E.ScanTooltip:SetUnit(petName)
    local details = E.ScanTooltip.TextLeft2:GetText()

    if not details then
        return
    end

    local delimiter = W.ChineseLocale and "的" or "'s"
    local raw = {F.SplitCJKString(delimiter, details)}

    local owner, role = raw[1], raw[#raw]
    if owner and role then
        return owner, role
    end

    return nil, nil
end

function A:Initialize()
    self.db = E.db.WT.announcement

    if not self.db.enable or self.initialized then
        return
    end

    for _, event in pairs(self.EventList) do
        A:RegisterEvent(event)
    end

    self.initialized = true
end

function A:ProfileUpdate()
    self:Initialize()

    if self.db.enable or not self.initialized then
        return
    end

    -- 禁用模块后反注册事件
    for _, event in pairs(self.EventList) do
        A:UnregisterEvent(event)
    end

    self.initialized = false
end

W:RegisterModule(A:GetName())
