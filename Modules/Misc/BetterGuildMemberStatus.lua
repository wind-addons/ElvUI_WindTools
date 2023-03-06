local W, F, E, L = unpack(select(2, ...))
local M = W.Modules.Misc
local C = W.Utilities.Color

local _G = _G
local format = format
local gsub = gsub
local strmatch = strmatch

local Ambiguate = Ambiguate
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter
local CreateFrame = CreateFrame
local GetGuildRosterInfo = GetGuildRosterInfo
local GetNumGuildMembers = GetNumGuildMembers
local IsInGuild = IsInGuild
local SendMessage = SendMessage

local C_Timer_After = C_Timer.After

local offlineMessageTemplate = "%s " .. _G.ERR_FRIEND_OFFLINE_S
local offlineMessagePattern = gsub(_G.ERR_FRIEND_OFFLINE_S, "%%s", "(.+)")
offlineMessagePattern = format("^%s$", offlineMessagePattern)

local onlineMessageTemplate = gsub(_G.ERR_FRIEND_ONLINE_SS, "%[%%s%]", "%%s")
onlineMessageTemplate = "%s " .. onlineMessageTemplate
local onlineMessagePattern = gsub(_G.ERR_FRIEND_ONLINE_SS, "|Hplayer:%%s|h%[%%s%]|h", "|Hplayer:(.+)|h%%[(.+)%%]|h")
onlineMessagePattern = format("^%s$", onlineMessagePattern)

local guildPlayerCache = {}
local blockedMessageCache = {}

local function updateGuildPlayerCache(self, event)
    if not (event == "PLAYER_ENTERING_WORLD" or event == "FORCE_UPDATE") then
        return
    end

    if not IsInGuild() then
        return
    end

    for i = 1, GetNumGuildMembers() do
        local name, _, _, _, _, _, _, _, _, _, className = GetGuildRosterInfo(i)
        name = Ambiguate(name, "none")
        guildPlayerCache[name] = className
    end
end

local function messageHandler(_, _, msg)
    local name, class, link, resultText

    if blockedMessageCache[msg] then
        return true
    end

    name = strmatch(msg, offlineMessagePattern)
    if not name then
        link, name = strmatch(msg, onlineMessagePattern)
    end

    if name then
        class = guildPlayerCache[name]
        if not class then
            updateGuildPlayerCache(nil, "FORCE_UPDATE")
            class = guildPlayerCache[name]
        end
    end

    if class then
        blockedMessageCache[msg] = true

        C_Timer_After(
            0.2,
            function()
                blockedMessageCache[msg] = nil
            end
        )

        local coloredName = F.CreateClassColorString(name, guildPlayerCache[name])
        local classIcon = F.GetClassIconStringWithStyle(class, "flat", 14, 14)

        if coloredName and classIcon then
            if link then
                resultText = format(onlineMessageTemplate, classIcon, link, coloredName)
                _G.ChatFrame1:AddMessage(resultText, C.RGBFromTemplate("success"))
            else
                resultText = format(offlineMessageTemplate, classIcon, coloredName)
                _G.ChatFrame1:AddMessage(resultText, C.RGBFromTemplate("danger"))
            end

            return true
        end
    end

    return false
end

function M:BetterGuildMemberStatus()
    if not E.private.WT.misc.betterGuildMemberStatus then
        return
    end

    local frame = CreateFrame("Frame")
    frame:SetScript("OnEvent", updateGuildPlayerCache)
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")

    ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", messageHandler)
end

M:AddCallback("BetterGuildMemberStatus")
