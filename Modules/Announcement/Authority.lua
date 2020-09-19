local W, F, E, L = unpack(select(2, ...))
local A = W:GetModule("Announcement")

local C_ChatInfo_RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix
local C_ChatInfo_SendAddonMessage = C_ChatInfo.SendAddonMessage

-- 前缀
local prefix = "WT_AS"

-- 基础信息
local guidSplitted = {strsplit("-", E.myguid)}
local myServerID, myPlayerUID = tonumber(guidSplitted[2], 10), tonumber(guidSplitted[3], 16)
guidSplitted = nil

-- 频道分级, 优先高级别的玩家
local channelLevel = {
    EMOTE = 1,
    PARTY = 2,
    INSTANCE_CHAT = 3,
    RAID = 4,
    RAID_WARNING = 5
}

-- 缓存是否有权限
local noAuthority = {}

-- 缓存个人配置
local myLevels = {}

local function GetBestChannel()
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
        return "INSTANCE_CHAT"
    elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
        return "RAID"
    elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
        return "PARTY"
    end
end

function A:InitilizeAuthority()
    local successfulRequest = C_ChatInfo_RegisterAddonMessagePrefix(prefix)
    assert(successfulRequest, L["The addon message prefix registration is failed."])
end

function A:CheckAuthority(type)
    return IsInGroup() and authority[type] or true
end

function A:SendAddonMessage(message)
    if not IsInGroup() then
        return
    end

    C_ChatInfo_SendAddonMessage(prefix, message, GetBestChannel())
end

function A:UpdatePartyInfo()
    if not IsInGroup() then
        return
    end

    self:SendInterruptConfig()
end

-- 打断:
-- INTERRUPT_PLAYER
-- INTERRUPT_OTHERS
function A:SendInterruptConfig()
    local config = self.db.interrupt

    if not config.enable then
        return
    end

    -- 自己打断
    local channel = self:GetChannel(config.player.channel)
    local level = channelLevel[channel]
    if level then
        myLevels["INTERRUPT_PLAYER"] = level
        self:SendAddonMessage(format("INTERRUPT_PLAYER=%s;%d;%d", level, myServerID, myPlayerUID))
    end

    -- 他人打断
    channel = self:GetChannel(config.others.channel)
    level = channelLevel[channel]
    if level then
        myLevels["INTERRUPT_OTHERS"] = level
        self:SendAddonMessage(format("INTERRUPT_OTHERS=%s;%d;%d", level, myServerID, myPlayerUID))
    end
end

function A:ReceiveInterruptConfig(key, level, serverID, playerUID)
    if noAuthority[configKey] then
        return
    end

    local configKey = "INTERRUPT_" .. key
    if level > myLevels[configKey] then -- 等级比较
        noAuthority[configKey] = true
    elseif level == myLevels[configKey] then
        if serverID > myServerID then -- 服务器 ID 比较
            noAuthority[configKey] = true
        elseif serverID == myServerID then
            if playerUID > myPlayerUID then -- 玩家 ID 比较
                noAuthority[configKey] = true
            end
        end
    end
end
