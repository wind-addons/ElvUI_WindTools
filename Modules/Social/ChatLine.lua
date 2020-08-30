local W, F, E, L = unpack(select(2, ...))
local CL = W:NewModule("ChatLine", "AceHook-3.0")
local CH = E:GetModule("Chat")

local BetterDate = BetterDate
local time = time
local ipairs = ipairs

local cache = {}
local initRecord = {}

local abbrStrings

local abbrStrings = {
    GUILD = L["[ABBR] Guild"],
    PARTY = L["[ABBR] Party"],
    RAID = L["[ABBR] Raid"],
    OFFICER = L["[ABBR] Officer"],
    PARTY_LEADER = L["[ABBR] Party Leader"],
    RAID_LEADER = L["[ABBR] Raid Leader"],
    RAID_WARNING = L["[ABBR] Raid Warning"],
    INSTANCE_CHAT = L["[ABBR] Instance"],
    INSTANCE_CHAT_LEADER = L["[ABBR] Instance Leader"],
    PET_BATTLE_COMBAT_LOG = _G.PET_BATTLE_COMBAT_LOG
}

local roleIcons

function CL:UpdateRoleIcons()
    if not self.db then
        return
    end

    local sizeString = format(":%d:%d", self.db.roleIconSize, self.db.roleIconSize)

    roleIcons = {
        TANK = E:TextureString(W.Media.Icons.ffxivTank, sizeString),
        HEALER = E:TextureString(W.Media.Icons.ffxivHealer, sizeString),
        DAMAGER = E:TextureString(W.Media.Icons.ffxivDPS, sizeString)
    }
end

function CL:ShortChannel()
    local noBracketsString
    local abbr

    if CL.db then

        if CL.db.removeBrackets then
            noBracketsString = "|Hchannel:%s|h%s|h"
        end

        if CL.db.abbreviation == "SHORT" then
            abbr = abbrStrings[strupper(self)]
        elseif CL.db.abbreviation == "NONE" then
            return ""
        end
    end

    return format(noBracketsString or "|Hchannel:%s|h[%s]|h", self, abbr or gsub(self, "channel:", ""))
end

function CL:HandleShortChannels(msg)
    msg = gsub(msg, "|Hchannel:(.-)|h%[(.-)%]|h", CL.ShortChannel)
    msg = gsub(msg, "CHANNEL:", "")
    msg = gsub(msg, "^(.-|h) " .. L["whispers"], "%1")
    msg = gsub(msg, "^(.-|h) " .. L["says"], "%1")
    msg = gsub(msg, "^(.-|h) " .. L["yells"], "%1")
    msg = gsub(msg, "<" .. _G.AFK .. ">", "[|cffFF0000" .. L["AFK"] .. "|r] ")
    msg = gsub(msg, "<" .. _G.DND .. ">", "[|cffE7E716" .. L["DND"] .. "|r] ")

    local raidWarningString = ""
    if CL.db and CL.db.removeBrackets then
        if CL.db.abbreviation == "SHORT" then
            raidWarningString = abbrStrings["RAID_WARNING"]
        end
    else
        if CL.db.abbreviation == "SHORT" then
            raidWarningString = "[" .. abbrStrings["RAID_WARNING"] .. "]"
        end
    end
    msg = gsub(msg, "^%[" .. _G.RAID_WARNING .. "%]", raidWarningString)
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

    self.OldAddMessage(self, msg, infoR, infoG, infoB, infoID, accessID, typeID)
end

function CL:ToggleReplacement()
    if not self.db then
        return
    end

    if self.db.abbreviation ~= "DEFAULT" or self.db.removeBrackets then
        if not initRecord.HandleShortChannels then
            cache.HandleShortChannels = CH.HandleShortChannels -- 备份
            CH.HandleShortChannels = CL.HandleShortChannels -- 替换
            initRecord.HandleShortChannels = true
        end
    else
        if initRecord.HandleShortChannels then
            if cache.HandleShortChannels then
                CH.HandleShortChannels = cache.HandleShortChannels -- 还原
            end
            initRecord.HandleShortChannels = false
        end
    end

    if self.db.removeBrackets then
        if not initRecord.ChatFrame_AddMessage then
            for _, frameName in ipairs(_G.CHAT_FRAMES) do
                local frame = _G[frameName]
                local id = frame:GetID()
                if id ~= 2 and frame.OldAddMessage then
                    frame.AddMessage = CL.AddMessage
                end
            end

            initRecord.ChatFrame_AddMessage = true
        end
    else
        if initRecord.ChatFrame_AddMessage then
            for _, frameName in ipairs(_G.CHAT_FRAMES) do
                local frame = _G[frameName]
                local id = frame:GetID()
                if id ~= 2 and frame.OldAddMessage then
                    frame.AddMessage = CH.AddMessage
                end
            end
            initRecord.ChatFrame_AddMessage = false
        end
    end
end

function CL:Initialize()
    self.db = E.db.WT.social.chatLine
    if not self.db or not self.db.enable or not E.private.chat.enable then
        return
    end

    self:UpdateRoleIcons()
    self:ToggleReplacement()
end

function CL:ProfileUpdate()
    self.db = E.db.WT.social.chatLine

    self:UpdateRoleIcons()
    self:ToggleReplacement()
end

W:RegisterModule(CL:GetName())
