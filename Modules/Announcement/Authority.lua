local W, F, E, L = unpack(select(2, ...))
local A = W:GetModule("Announcement")

local C_ChatInfo_RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix
local C_ChatInfo_SendAddonMessage = C_ChatInfo.SendAddonMessage

-- 前缀
A.prefix = "WT_AS"

-- 基础信息
local myServerID, myPlayerUID

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

function A:InitializeAuthority()
    local successfulRequest = C_ChatInfo_RegisterAddonMessagePrefix(self.prefix)
    assert(successfulRequest, L["The addon message prefix registration is failed."])

    local guidSplitted = {strsplit("-", E.myguid)}
    myServerID = tonumber(guidSplitted[2], 10)
    myPlayerUID = tonumber(guidSplitted[3], 16)
end

function A:CheckAuthority(key)
    if IsInGroup() and noAuthority[key] then
        return false
    end

    return true
end

function A:SendMyLevel(key, value)
    if not IsInGroup() or not key or not value then
        return
    end

    if myLevels[key] and myLevels[key] > value then
        return
    end

    noAuthority[key] = nil
    myLevels[key] = value
    local message = format("%s=%s;%d;%d", key, value, myServerID, myPlayerUID)
    C_ChatInfo_SendAddonMessage(self.prefix, message, GetBestChannel())
end

function A:ReceiveLevel(message)
    local key, value, serverID, playerUID = strmatch(message, "^(.-)=([0-9]-);([0-9]-);([0-9]+)")
    value = tonumber(value)
    serverID = tonumber(serverID)
    playerUID = tonumber(playerUID)

    if noAuthority[key] then
        return
    end

    if not myLevels[key] then
        myLevels[key] = value
        noAuthority[key] = true
        return
    end

    if value > myLevels[key] then -- 等级比较
        noAuthority[key] = true
    elseif value == myLevels[key] then
        if serverID > myServerID then -- 服务器 ID 比较
            noAuthority[key] = true
        elseif serverID == myServerID then
            if playerUID > myPlayerUID then -- 玩家 ID 比较
                noAuthority[key] = true
            end
        end
    end
end

local waitSend = false
function A:UpdatePartyInfo()
    if waitSend then
        return
    end

    if not IsInGroup() then
        return
    end

    noAuthority = {}
    myLevels = {}

    waitSend = true
    C_Timer.After(
        0.2,
        function()
            A:SendInterruptConfig()
            waitSend = false
        end
    )
end

-- 打断:
-- INTERRUPT_PLAYER
-- INTERRUPT_OTHERS
function A:SendInterruptConfig()
    local config = self.db.interrupt

    if not config.enable then
        return
    end

    -- 他人打断
    local channel = self:GetChannel(config.others.channel)
    self:SendMyLevel("INTERRUPT_OTHERS", channelLevel[channel])
end
