local W, F, E, L = unpack(select(2, ...))
local CL = W:NewModule("ChatLine", "AceHook-3.0")
local CH = E:GetModule("Chat")

local BetterDate = BetterDate
local time = time
local ipairs = ipairs

local cache = {}
local initialized = {}

local WIND_DEFAULT_STRINGS = {
    GUILD = L["[ABBR] Guild"],
    PARTY = L["[ABBR] Party"],
    RAID = L["[ABBR] Raid"],
    OFFICER = L["[ABBR] Officer"],
    PARTY_LEADER = L["[ABBR] Party Leader"],
    RAID_LEADER = L["[ABBR] Raid Leader"],
    INSTANCE_CHAT = L["[ABBR] Instance"],
    INSTANCE_CHAT_LEADER = L["[ABBR] Instance Leader"],
    PET_BATTLE_COMBAT_LOG = _G.PET_BATTLE_COMBAT_LOG
}

local rolePaths

function CL:UpdateRoleIcons()
    if not self.db then return end

    local sizeString = format(":%d:%d", self.db.roleIconSize, self.db.roleIconSize)

    rolePaths = {
        TANK = E:TextureString(W.Media.Icons.ffxivTank, sizeString),
        HEALER = E:TextureString(W.Media.Icons.ffxivHealer, sizeString),
        DAMAGER = E:TextureString(W.Media.Icons.ffxivDPS, sizeString)
    }
end

function CL:ShortChannel()
    local noBracketsString

    if CL.db and CL.db.removeBrackets then
        noBracketsString = "|Hchannel:%s|h%s|h"
    end

    return format(
        noBracketsString or "|Hchannel:%s|h[%s]|h",
        self,
        WIND_DEFAULT_STRINGS[strupper(self)] or gsub(self, "channel:", "")
    )
end

function CL:HandleShortChannels(msg)
    msg = gsub(msg, "|Hchannel:(.-)|h%[(.-)%]|h", CL.ShortChannel)
    msg = gsub(msg, "CHANNEL:", "")
    msg = gsub(msg, "^(.-|h) " .. L["whispers"], "%1")
    msg = gsub(msg, "^(.-|h) " .. L["says"], "%1")
    msg = gsub(msg, "^(.-|h) " .. L["yells"], "%1")
    msg = gsub(msg, "<" .. _G.AFK .. ">", "[|cffFF0000" .. L["AFK"] .. "|r] ")
    msg = gsub(msg, "<" .. _G.DND .. ">", "[|cffE7E716" .. L["DND"] .. "|r] ")
    msg = gsub(msg, "^%[" .. _G.RAID_WARNING .. "%]", "[" .. L["[ABBR] Raid Warning"] .. "]")
    return msg
end

function CL:AddMessage(msg, infoR, infoG, infoB, infoID, accessID, typeID, isHistory, historyTime)
    local historyTimestamp  --we need to extend the arguments on AddMessage so we can properly handle times without overriding
    if isHistory == "ElvUI_ChatHistory" then
        historyTimestamp = historyTime
    end

    if CH.db.timeStampFormat and CH.db.timeStampFormat ~= "NONE" then
        local timeStamp = BetterDate(CH.db.timeStampFormat, historyTimestamp or time())
        timeStamp = gsub(timeStamp, " ", "")
        timeStamp = gsub(timeStamp, "AM", " AM")
        timeStamp = gsub(timeStamp, "PM", " PM")
        if CH.db.useCustomTimeColor then
            local color = CH.db.customTimeColor
            local hexColor = E:RGBToHex(color.r, color.g, color.b)
            msg = format("%s%s|r %s", hexColor, timeStamp, msg)
        else
            msg = format("%s %s", timeStamp, msg)
        end
    end

    if CH.db.copyChatLines then
        msg = format("|Hcpl:%s|h%s|h %s", self:GetID(), E:TextureString(E.Media.Textures.ArrowRight, ":14"), msg)
    end

    msg = rolePaths["TANK"]..rolePaths["HEALER"]..rolePaths["DAMAGER"]..msg
    self.OldAddMessage(self, msg, infoR, infoG, infoB, infoID, accessID, typeID)
end

function CL:Initialize()
    self.db = E.db.WT.social.chatLine
    if not self.db or not self.db.enable or not E.private.chat.enable then
        return
    end

    self:UpdateRoleIcons()

    if self.db.abbreviation then
        cache.HandleShortChannels = CH.HandleShortChannels
        CH.HandleShortChannels = CL.HandleShortChannels
        initialized.abbreviation = true
    end

    if self.db.removeBrackets then
        for _, frameName in ipairs(_G.CHAT_FRAMES) do
            local frame = _G[frameName]
            local id = frame:GetID()
            if id ~= 2 and frame.OldAddMessage then
                frame.AddMessage = CL.AddMessage
            end
        end

        initialized.removeBrackets = true
    end
end

function CL:ProfileUpdate()
    self.db = E.db.WT.social.chatLine

    if self.db.enable and self.db.abbreviation then
        if not initialized.abbreviation then
            if not cache.HandleShortChannels then
                cache.HandleShortChannels = CH.HandleShortChannels
            end

            CH.HandleShortChannels = CL.HandleShortChannels
            initialized.abbreviation = true
        end
    else
        if initialized.abbreviation then
            CH.HandleShortChannels = cache.HandleShortChannels
            initialized.abbreviation = false
        end
    end

    if self.db.enable and self.db.removeBrackets then
        if not initialized.removeBrackets then
            for _, frameName in ipairs(_G.CHAT_FRAMES) do
                local frame = _G[frameName]
                local id = frame:GetID()
                if id ~= 2 and frame.OldAddMessage then
                    frame.AddMessage = CL.AddMessage
                end
            end

            initialized.removeBrackets = true
        end
    else
        if initialized.removeBrackets then
            for _, frameName in ipairs(_G.CHAT_FRAMES) do
                local frame = _G[frameName]
                local id = frame:GetID()
                if id ~= 2 and frame.OldAddMessage then
                    frame.AddMessage = CH.AddMessage
                end
            end

            initialized.removeBrackets = false
        end
    end
end

W:RegisterModule(CL:GetName())
