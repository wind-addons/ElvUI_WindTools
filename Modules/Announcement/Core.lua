local W, F, E, L = unpack(select(2, ...))
local A = W:NewModule("Announcement", "AceEvent-3.0")

local _G = _G
local pairs = pairs
local tinsert, xpcall, next, assert, format = tinsert, xpcall, next, assert, format

A.EventFunctions = {}

--[[
    注册事件回调
    @param {string} eventName 事件名
    @param {function} submoduleFunctionName 事件回调函数
]]
function A:AddCallbackForEvent(eventName, submoduleFunctionName)
    local event = self.EventFunctions[eventName]
    if not event then
        self.EventFunctions[eventName] = {}
        event = self.EventFunctions[eventName]
    end

    tinsert(event, submoduleFunctionName)
end

function A:SendMessage(text, channel, raid_warning, whisper_target)
    -- 忽视不通告讯息
    if channel == "NONE" then
        return
    end
    -- 聊天框输出
    if channel == "SELF" then
        ChatFrame1:AddMessage(text)
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

function A:GetChannel(channel_db)
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
        return channel_db.instance
    elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
        return channel_db.raid
    elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
        return channel_db.party
    elseif channel_db.solo then
        return channel_db.solo
    end
    return "NONE"
end

function A:SendAddonMessage(message)
    if not IsInGroup() then
        return
    end
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
        C_ChatInfo.SendAddonMessage(self.Prefix, message, "INSTANCE")
    elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
        C_ChatInfo.SendAddonMessage(self.Prefix, message, "RAID")
    elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
        C_ChatInfo.SendAddonMessage(self.Prefix, message, "PARTY")
    end
end

function A:TransferEventInfo(event, data)
    local submodules = self.EventFunctions[event]
    if not submodules then
        return
    end

    for _, submodule in pairs(submodules) do
        if self[submodule] then
            self[submodule](self, event, data)
        end
    end
end

function A:Initialize()
    self.db = E.db.WT.announcement

    if not self.db.enable or self.Initialized then
        return
    end

    for event, _ in pairs(self.EventFunctions) do
        A:RegisterEvent(event)
    end

    self.Initialized = true
end

function A:ProfileUpdate()
    self.Initialize()

    if self.db.enable or not self.Initialized then
        return
    end

    -- 禁用模块后反注册事件
    for event, _ in pairs(mod.EventFunctions) do
        A:UnregisterEvent(event)
    end

    self.Initialized = false
end

W:RegisterModule(A:GetName())
