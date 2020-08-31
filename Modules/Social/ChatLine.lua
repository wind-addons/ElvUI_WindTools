local W, F, E, L = unpack(select(2, ...))
local CL = W:NewModule("ChatLine", "AceHook-3.0")
local CH = E:GetModule("Chat")

local ipairs, pairs, wipe, time = ipairs, pairs, wipe, time
local strfind, strlen, strupper, strlower = strfind, strlen, strupper, strlower
local tostring,strsub, gsub, format = tostring, strsub, gsub, format

local BetterDate = BetterDate
local BNet_GetClientEmbeddedTexture = BNet_GetClientEmbeddedTexture
local BNet_GetValidatedCharacterName = BNet_GetValidatedCharacterName
local BNGetNumFriendInvites = BNGetNumFriendInvites
local C_BattleNet_GetAccountInfoByID = C_BattleNet_GetAccountInfoByID
local C_Club_GetInfoFromLastCommunityChatLine = C_Club_GetInfoFromLastCommunityChatLine
local C_SocialIsSocialEnabled = C_SocialIsSocialEnabled
local C_SocialGetLastItem = C_SocialGetLastItem
local Chat_GetChatCategory = Chat_GetChatCategory
local ChatEdit_SetLastTellTarget = ChatEdit_SetLastTellTarget
local ChatFrame_CanChatGroupPerformExpressionExpansion = ChatFrame_CanChatGroupPerformExpressionExpansion
local ChatFrame_GetMobileEmbeddedTexture = ChatFrame_GetMobileEmbeddedTexture
local ChatFrame_ResolvePrefixedChannelName = ChatFrame_ResolvePrefixedChannelName
local ChatHistory_GetAccessID = ChatHistory_GetAccessID
local FCF_StartAlertFlash = FCF_StartAlertFlash
local FCFManager_ShouldSuppressMessage = FCFManager_ShouldSuppressMessage
local FCFManager_ShouldSuppressMessageFlash = FCFManager_ShouldSuppressMessageFlash
local FlashClientIcon = FlashClientIcon
local GetAchievementInfo = GetAchievementInfo
local GetAchievementInfoFromHyperlink = GetAchievementInfoFromHyperlink
local GetCVar, GetCVarBool = GetCVar, GetCVarBool
local GetBNPlayerCommunityLink = GetBNPlayerCommunityLink
local GetBNPlayerLink = GetBNPlayerLink
local GetNumGroupMembers = GetNumGroupMembers
local GetPlayerCommunityLink = GetPlayerCommunityLink
local GetPlayerLink = GetPlayerLink
local GMError = GMError
local GMChatFrame_IsGM = GMChatFrame_IsGM
local InCombatLockdown = InCombatLockdown
local IsInGroup = IsInGroup
local IsInRaid =IsInRaid
local PlaySoundFile = PlaySoundFile
local RemoveExtraSpaces = RemoveExtraSpaces
local RemoveNewlines = RemoveNewlines
local Social_GetShareItemLink = Social_GetShareItemLink
local StaticPopup_Visible = StaticPopup_Visiblelocal
local UnitExists = UnitExists
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitIsUnit = UnitIsUnit
local UnitName = UnitName

local cache = {}
local lfgRoles = {}
local initRecord = {}

local PLAYER_REALM = E:ShortenRealm(E.myrealm)
local PLAYER_NAME = format("%s-%s", E.myname, PLAYER_REALM)

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

local historyTypes = { -- the events set on the chats are still in FindURL_Events, this is used to ignore some types only
	CHAT_MSG_WHISPER			= 'WHISPER',
	CHAT_MSG_WHISPER_INFORM		= 'WHISPER',
	CHAT_MSG_BN_WHISPER			= 'WHISPER',
	CHAT_MSG_BN_WHISPER_INFORM	= 'WHISPER',
	CHAT_MSG_GUILD				= 'GUILD',
	CHAT_MSG_GUILD_ACHIEVEMENT	= 'GUILD',
	CHAT_MSG_OFFICER		= 'OFFICER',
	CHAT_MSG_PARTY			= 'PARTY',
	CHAT_MSG_PARTY_LEADER	= 'PARTY',
	CHAT_MSG_RAID			= 'RAID',
	CHAT_MSG_RAID_LEADER	= 'RAID',
	CHAT_MSG_RAID_WARNING	= 'RAID',
	CHAT_MSG_INSTANCE_CHAT			= 'INSTANCE',
	CHAT_MSG_INSTANCE_CHAT_LEADER	= 'INSTANCE',
	CHAT_MSG_CHANNEL		= 'CHANNEL',
	CHAT_MSG_SAY			= 'SAY',
	CHAT_MSG_YELL			= 'YELL',
	CHAT_MSG_EMOTE			= 'EMOTE' -- this never worked, check it sometime.
}

local roleIcons

function CL:UpdateRoleIcons()
    if not self.db then
        return
    end

    local sizeString = format(":%d:%d", self.db.roleIconSize, self.db.roleIconSize)

    if self.db.roleIconStyle == "FFXIV" then
        roleIcons = {
            TANK = E:TextureString(W.Media.Icons.ffxivTank, sizeString),
            HEALER = E:TextureString(W.Media.Icons.ffxivHealer, sizeString),
            DAMAGER = E:TextureString(W.Media.Icons.ffxivDPS, sizeString)
        }
    elseif self.db.roleIconStyle == "DEFAULT" then
        roleIcons = {
            TANK = E:TextureString(E.Media.Textures.Tank, sizeString..':0:0:64:64:2:56:2:56'),
            HEALER = E:TextureString(E.Media.Textures.Healer, sizeString..':0:0:64:64:2:56:2:56'),
            DAMAGER = E:TextureString(E.Media.Textures.DPS, sizeString)
        }
    end
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

function CL:Test()
    F.Developer.Print(lfgRoles)
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

function CL:CheckLFGRoles()
    if not CH.db.lfgIcons or not IsInGroup() then
        return
    end
    wipe(lfgRoles)

    local playerRole = UnitGroupRolesAssigned("player")
    if playerRole then
        lfgRoles[PLAYER_NAME] = roleIcons[playerRole]
    end

    local unit = (IsInRaid() and "raid" or "party")
    for i = 1, GetNumGroupMembers() do
        if UnitExists(unit .. i) and not UnitIsUnit(unit .. i, "player") then
            local role = UnitGroupRolesAssigned(unit .. i)
            local name, realm = UnitName(unit .. i)

            if role and name then
                name = (realm and realm ~= "" and name .. "-" .. realm) or name .. "-" .. PLAYER_REALM
                lfgRoles[name] = roleIcons[role]
            end
        end
    end
end

E.NameReplacements = {}
function CL:ChatFrame_MessageEventHandler(
    frame,
    event,
    arg1,
    arg2,
    arg3,
    arg4,
    arg5,
    arg6,
    arg7,
    arg8,
    arg9,
    arg10,
    arg11,
    arg12,
    arg13,
    arg14,
    _,
    arg16,
    arg17,
    isHistory,
    historyTime,
    historyName,
    historyBTag)
    -- ElvUI Chat History Note: isHistory, historyTime, historyName, and historyBTag are passed from CH:DisplayChatHistory() and need to be on the end to prevent issues in other addons that listen on ChatFrame_MessageEventHandler.
    -- we also send isHistory and historyTime into CH:AddMessage so that we don't have to override the timestamp.
    if strsub(event, 1, 8) == "CHAT_MSG" then
        if arg16 then
            return true
        end -- hiding sender in letterbox: do NOT even show in chat window (only shows in cinematic frame)

        local notChatHistory, historySavedName  --we need to extend the arguments on CH.ChatFrame_MessageEventHandler so we can properly handle saved names without overriding
        if isHistory == "ElvUI_ChatHistory" then
            if historyBTag then
                arg2 = historyBTag
            end -- swap arg2 (which is a |k string) to btag name
            historySavedName = historyName
        else
            notChatHistory = true
        end

        local chatType = strsub(event, 10)
        local info = _G.ChatTypeInfo[chatType]

        local chatFilters = _G.ChatFrame_GetMessageEventFilters(event)
        if chatFilters then
            for _, filterFunc in next, chatFilters do
                local filter,
                    newarg1,
                    newarg2,
                    newarg3,
                    newarg4,
                    newarg5,
                    newarg6,
                    newarg7,
                    newarg8,
                    newarg9,
                    newarg10,
                    newarg11,
                    newarg12,
                    newarg13,
                    newarg14 =
                    filterFunc(
                    frame,
                    event,
                    arg1,
                    arg2,
                    arg3,
                    arg4,
                    arg5,
                    arg6,
                    arg7,
                    arg8,
                    arg9,
                    arg10,
                    arg11,
                    arg12,
                    arg13,
                    arg14
                )
                if filter then
                    return true
                elseif newarg1 then
                    arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 =
                        newarg1,
                        newarg2,
                        newarg3,
                        newarg4,
                        newarg5,
                        newarg6,
                        newarg7,
                        newarg8,
                        newarg9,
                        newarg10,
                        newarg11,
                        newarg12,
                        newarg13,
                        newarg14
                end
            end
        end

        arg2 = E.NameReplacements[arg2] or arg2

        -- data from populated guid info
        local nameWithRealm, realm
        local data = CH:GetPlayerInfoByGUID(arg12)
        if data then
            realm = data.realm
            nameWithRealm = data.nameWithRealm
        end

        -- fetch the name color to use
        local coloredName =
            historySavedName or
            CH:GetColoredName(
                event,
                arg1,
                arg2,
                arg3,
                arg4,
                arg5,
                arg6,
                arg7,
                arg8,
                arg9,
                arg10,
                arg11,
                arg12,
                arg13,
                arg14
            )

        local channelLength = strlen(arg4)
        local infoType = chatType
        if
            (chatType == "COMMUNITIES_CHANNEL") or
                ((strsub(chatType, 1, 7) == "CHANNEL") and (chatType ~= "CHANNEL_LIST") and
                    ((arg1 ~= "INVITE") or (chatType ~= "CHANNEL_NOTICE_USER")))
         then
            if arg1 == "WRONG_PASSWORD" then
                local staticPopup = _G[StaticPopup_Visible("CHAT_CHANNEL_PASSWORD") or ""]
                if staticPopup and strupper(staticPopup.data) == strupper(arg9) then
                    -- Don't display invalid password messages if we're going to prompt for a password (bug 102312)
                    return
                end
            end

            local found = 0
            for index, value in pairs(frame.channelList) do
                if channelLength > strlen(value) then
                    -- arg9 is the channel name without the number in front...
                    if ((arg7 > 0) and (frame.zoneChannelList[index] == arg7)) or (strupper(value) == strupper(arg9)) then
                        found = 1
                        infoType = "CHANNEL" .. arg8
                        info = _G.ChatTypeInfo[infoType]
                        if (chatType == "CHANNEL_NOTICE") and (arg1 == "YOU_LEFT") then
                            frame.channelList[index] = nil
                            frame.zoneChannelList[index] = nil
                        end
                        break
                    end
                end
            end
            if (found == 0) or not info then
                return true
            end
        end

        local chatGroup = Chat_GetChatCategory(chatType)
        local chatTarget
        if chatGroup == "CHANNEL" then
            chatTarget = tostring(arg8)
        elseif chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" then
            if not (strsub(arg2, 1, 2) == "|K") then
                chatTarget = strupper(arg2)
            else
                chatTarget = arg2
            end
        end

        if FCFManager_ShouldSuppressMessage(frame, chatGroup, chatTarget) then
            return true
        end

        if chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" then
            if frame.privateMessageList and not frame.privateMessageList[strlower(arg2)] then
                return true
            elseif
                frame.excludePrivateMessageList and frame.excludePrivateMessageList[strlower(arg2)] and
                    ((chatGroup == "WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline") or
                        (chatGroup == "BN_WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline"))
             then
                return true
            end
        end

        if frame.privateMessageList then
            -- Dedicated BN whisper windows need online/offline messages for only that player
            if
                (chatGroup == "BN_INLINE_TOAST_ALERT" or chatGroup == "BN_WHISPER_PLAYER_OFFLINE") and
                    not frame.privateMessageList[strlower(arg2)]
             then
                return true
            end

            -- HACK to put certain system messages into dedicated whisper windows
            if chatGroup == "SYSTEM" then
                local matchFound = false
                local message = strlower(arg1)
                for playerName in pairs(frame.privateMessageList) do
                    local playerNotFoundMsg = strlower(format(_G.ERR_CHAT_PLAYER_NOT_FOUND_S, playerName))
                    local charOnlineMsg = strlower(format(_G.ERR_FRIEND_ONLINE_SS, playerName, playerName))
                    local charOfflineMsg = strlower(format(_G.ERR_FRIEND_OFFLINE_S, playerName))
                    if message == playerNotFoundMsg or message == charOnlineMsg or message == charOfflineMsg then
                        matchFound = true
                        break
                    end
                end

                if not matchFound then
                    return true
                end
            end
        end

        if
            (chatType == "SYSTEM" or chatType == "SKILL" or chatType == "CURRENCY" or chatType == "MONEY" or
                chatType == "OPENING" or
                chatType == "TRADESKILLS" or
                chatType == "PET_INFO" or
                chatType == "TARGETICONS" or
                chatType == "BN_WHISPER_PLAYER_OFFLINE")
         then
            frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
        elseif chatType == "LOOT" then
            -- Append [Share] hyperlink if this is a valid social item and you are the looter.
            if arg12 == E.myguid and C_SocialIsSocialEnabled() then
                local itemID, creationContext = GetItemInfoFromHyperlink(arg1)
                if itemID and C_SocialGetLastItem() == itemID then
                    arg1 = arg1 .. " " .. Social_GetShareItemLink(creationContext, true)
                end
            end
            frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
        elseif strsub(chatType, 1, 7) == "COMBAT_" then
            frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
        elseif strsub(chatType, 1, 6) == "SPELL_" then
            frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
        elseif strsub(chatType, 1, 10) == "BG_SYSTEM_" then
            frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
        elseif strsub(chatType, 1, 11) == "ACHIEVEMENT" then
            -- Append [Share] hyperlink
            if arg12 == E.myguid and C_SocialIsSocialEnabled() then
                local achieveID = GetAchievementInfoFromHyperlink(arg1)
                if achieveID then
                    arg1 = arg1 .. " " .. Social_GetShareAchievementLink(achieveID, true)
                end
            end
            frame:AddMessage(
                format(arg1, GetPlayerLink(arg2, ("[%s]"):format(coloredName))),
                info.r,
                info.g,
                info.b,
                info.id,
                nil,
                nil,
                isHistory,
                historyTime
            )
        elseif strsub(chatType, 1, 18) == "GUILD_ACHIEVEMENT" then
            local message = format(arg1, GetPlayerLink(arg2, ("[%s]"):format(coloredName)))
            if C_SocialIsSocialEnabled() then
                local achieveID = GetAchievementInfoFromHyperlink(arg1)
                if achieveID then
                    local isGuildAchievement = select(12, GetAchievementInfo(achieveID))
                    if isGuildAchievement then
                        message = message .. " " .. Social_GetShareAchievementLink(achieveID, true)
                    end
                end
            end
            frame:AddMessage(message, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
        elseif chatType == "IGNORED" then
            frame:AddMessage(
                format(_G.CHAT_IGNORED, arg2),
                info.r,
                info.g,
                info.b,
                info.id,
                nil,
                nil,
                isHistory,
                historyTime
            )
        elseif chatType == "FILTERED" then
            frame:AddMessage(
                format(_G.CHAT_FILTERED, arg2),
                info.r,
                info.g,
                info.b,
                info.id,
                nil,
                nil,
                isHistory,
                historyTime
            )
        elseif chatType == "RESTRICTED" then
            frame:AddMessage(
                _G.CHAT_RESTRICTED_TRIAL,
                info.r,
                info.g,
                info.b,
                info.id,
                nil,
                nil,
                isHistory,
                historyTime
            )
        elseif chatType == "CHANNEL_LIST" then
            if channelLength > 0 then
                frame:AddMessage(
                    format(_G["CHAT_" .. chatType .. "_GET"] .. arg1, tonumber(arg8), arg4),
                    info.r,
                    info.g,
                    info.b,
                    info.id,
                    nil,
                    nil,
                    isHistory,
                    historyTime
                )
            else
                frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
            end
        elseif chatType == "CHANNEL_NOTICE_USER" then
            local globalstring = _G["CHAT_" .. arg1 .. "_NOTICE_BN"]
            if not globalstring then
                globalstring = _G["CHAT_" .. arg1 .. "_NOTICE"]
            end
            if not globalstring then
                GMError(("Missing global string for %q"):format("CHAT_" .. arg1 .. "_NOTICE_BN"))
                return
            end
            if arg5 ~= "" then
                -- TWO users in this notice (E.G. x kicked y)
                frame:AddMessage(
                    format(globalstring, arg8, arg4, arg2, arg5),
                    info.r,
                    info.g,
                    info.b,
                    info.id,
                    nil,
                    nil,
                    isHistory,
                    historyTime
                )
            elseif arg1 == "INVITE" then
                frame:AddMessage(
                    format(globalstring, arg4, arg2),
                    info.r,
                    info.g,
                    info.b,
                    info.id,
                    nil,
                    nil,
                    isHistory,
                    historyTime
                )
            else
                frame:AddMessage(
                    format(globalstring, arg8, arg4, arg2),
                    info.r,
                    info.g,
                    info.b,
                    info.id,
                    nil,
                    nil,
                    isHistory,
                    historyTime
                )
            end
            if arg1 == "INVITE" and GetCVarBool("blockChannelInvites") then
                frame:AddMessage(
                    _G.CHAT_MSG_BLOCK_CHAT_CHANNEL_INVITE,
                    info.r,
                    info.g,
                    info.b,
                    info.id,
                    nil,
                    nil,
                    isHistory,
                    historyTime
                )
            end
        elseif chatType == "CHANNEL_NOTICE" then
            local globalstring
            if arg1 == "TRIAL_RESTRICTED" then
                globalstring = _G.CHAT_TRIAL_RESTRICTED_NOTICE_TRIAL
            else
                globalstring = _G["CHAT_" .. arg1 .. "_NOTICE_BN"]
                if not globalstring then
                    globalstring = _G["CHAT_" .. arg1 .. "_NOTICE"]
                    if not globalstring then
                        GMError(("Missing global string for %q"):format("CHAT_" .. arg1 .. "_NOTICE"))
                        return
                    end
                end
            end
            local accessID = ChatHistory_GetAccessID(Chat_GetChatCategory(chatType), arg8)
            local typeID = ChatHistory_GetAccessID(infoType, arg8, arg12)
            frame:AddMessage(
                format(globalstring, arg8, ChatFrame_ResolvePrefixedChannelName(arg4)),
                info.r,
                info.g,
                info.b,
                info.id,
                accessID,
                typeID,
                isHistory,
                historyTime
            )
        elseif chatType == "BN_INLINE_TOAST_ALERT" then
            local globalstring = _G["BN_INLINE_TOAST_" .. arg1]
            if not globalstring then
                GMError(("Missing global string for %q"):format("BN_INLINE_TOAST_" .. arg1))
                return
            end
            local message
            if arg1 == "FRIEND_REQUEST" then
                message = globalstring
            elseif arg1 == "FRIEND_PENDING" then
                message = format(_G.BN_INLINE_TOAST_FRIEND_PENDING, BNGetNumFriendInvites())
            elseif arg1 == "FRIEND_REMOVED" or arg1 == "BATTLETAG_FRIEND_REMOVED" then
                message = format(globalstring, arg2)
            elseif arg1 == "FRIEND_ONLINE" or arg1 == "FRIEND_OFFLINE" then
                local accountInfo = C_BattleNet_GetAccountInfoByID(arg13)
                if not accountInfo then
                    return
                end
                local client = accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.clientProgram
                if client and client ~= "" then
                    local characterName =
                        BNet_GetValidatedCharacterName(
                        accountInfo.gameAccountInfo.characterName,
                        accountInfo.battleTag,
                        client
                    ) or ""
                    local characterNameText = BNet_GetClientEmbeddedTexture(client, 14) .. characterName
                    local linkDisplayText = ("[%s] (%s)"):format(arg2, characterNameText)
                    local playerLink =
                        GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(chatType), 0)
                    message = format(globalstring, playerLink)
                else
                    local linkDisplayText = ("[%s]"):format(arg2)
                    local playerLink =
                        GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(chatType), 0)
                    message = format(globalstring, playerLink)
                end
            else
                local linkDisplayText = ("[%s]"):format(arg2)
                local playerLink =
                    GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(chatType), 0)
                message = format(globalstring, playerLink)
            end
            frame:AddMessage(message, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
        elseif chatType == "BN_INLINE_TOAST_BROADCAST" then
            if arg1 ~= "" then
                arg1 = RemoveNewlines(RemoveExtraSpaces(arg1))
                local linkDisplayText = ("[%s]"):format(arg2)
                local playerLink =
                    GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(chatType), 0)
                frame:AddMessage(
                    format(_G.BN_INLINE_TOAST_BROADCAST, playerLink, arg1),
                    info.r,
                    info.g,
                    info.b,
                    info.id,
                    nil,
                    nil,
                    isHistory,
                    historyTime
                )
            end
        elseif chatType == "BN_INLINE_TOAST_BROADCAST_INFORM" then
            if arg1 ~= "" then
                frame:AddMessage(
                    _G.BN_INLINE_TOAST_BROADCAST_INFORM,
                    info.r,
                    info.g,
                    info.b,
                    info.id,
                    nil,
                    nil,
                    isHistory,
                    historyTime
                )
            end
        else
            local body

            if chatType == "WHISPER_INFORM" and GMChatFrame_IsGM and GMChatFrame_IsGM(arg2) then
                return
            end

            local showLink = 1
            if strsub(chatType, 1, 7) == "MONSTER" or strsub(chatType, 1, 9) == "RAID_BOSS" then
                showLink = nil
            else
                arg1 = gsub(arg1, "%%", "%%%%")
            end

            -- Search for icon links and replace them with texture links.
            arg1 =
                CH:ChatFrame_ReplaceIconAndGroupExpressions(
                arg1,
                arg17,
                not ChatFrame_CanChatGroupPerformExpressionExpansion(chatGroup)
            ) -- If arg17 is true, don't convert to raid icons

            --Remove groups of many spaces
            arg1 = RemoveExtraSpaces(arg1)

            --ElvUI: Get class colored name for BattleNet friend
            if chatType == "BN_WHISPER" or chatType == "BN_WHISPER_INFORM" then
                coloredName = historySavedName or CH:GetBNFriendColor(arg2, arg13)
            end

            local playerLink
            local playerLinkDisplayText = coloredName
            local relevantDefaultLanguage = frame.defaultLanguage
            if chatType == "SAY" or chatType == "YELL" then
                relevantDefaultLanguage = frame.alternativeDefaultLanguage
            end
            local usingDifferentLanguage = (arg3 ~= "") and (arg3 ~= relevantDefaultLanguage)
            local usingEmote = (chatType == "EMOTE") or (chatType == "TEXT_EMOTE")

            if usingDifferentLanguage or not usingEmote then
                playerLinkDisplayText = ("[%s]"):format(coloredName)
            end

            local isCommunityType = chatType == "COMMUNITIES_CHANNEL"
            local playerName, lineID, bnetIDAccount = arg2, arg11, arg13
            if isCommunityType then
                local isBattleNetCommunity = bnetIDAccount ~= nil and bnetIDAccount ~= 0
                local messageInfo, clubId, streamId = C_Club_GetInfoFromLastCommunityChatLine()

                if messageInfo ~= nil then
                    if isBattleNetCommunity then
                        playerLink =
                            GetBNPlayerCommunityLink(
                            playerName,
                            playerLinkDisplayText,
                            bnetIDAccount,
                            clubId,
                            streamId,
                            messageInfo.messageId.epoch,
                            messageInfo.messageId.position
                        )
                    else
                        playerLink =
                            GetPlayerCommunityLink(
                            playerName,
                            playerLinkDisplayText,
                            clubId,
                            streamId,
                            messageInfo.messageId.epoch,
                            messageInfo.messageId.position
                        )
                    end
                else
                    playerLink = playerLinkDisplayText
                end
            else
                if chatType == "BN_WHISPER" or chatType == "BN_WHISPER_INFORM" then
                    playerLink =
                        GetBNPlayerLink(playerName, playerLinkDisplayText, bnetIDAccount, lineID, chatGroup, chatTarget)
                elseif
                    ((chatType == "GUILD" or chatType == "TEXT_EMOTE") or arg14) and
                        (nameWithRealm and nameWithRealm ~= playerName)
                 then
                    playerName = nameWithRealm
                    playerLink = GetPlayerLink(playerName, playerLinkDisplayText, lineID, chatGroup, chatTarget)
                else
                    playerLink = GetPlayerLink(playerName, playerLinkDisplayText, lineID, chatGroup, chatTarget)
                end
            end

            local message = arg1
            if arg14 then --isMobile
                message = ChatFrame_GetMobileEmbeddedTexture(info.r, info.g, info.b) .. message
            end

            -- Player Flags
            local pflag, chatIcon, pluginChatIcon = "", nil, CH:GetPluginIcon(playerName)
            if type(chatIcon) == "function" then
                local icon, prettify = chatIcon()
                if prettify and not CH:MessageIsProtected(message) then
                    message = prettify(message)
                end
                chatIcon = icon or ""
            end

            if arg6 ~= "" then -- Blizzard Flags
                if arg6 == "GM" or arg6 == "DEV" then -- Blizzard Icon, this was sent by a GM or Dev.
                    pflag = [[|TInterface\ChatFrame\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t]]
                else -- Away/Busy
                    pflag = _G["CHAT_FLAG_" .. arg6] or ""
                end
            end
            -- LFG Role Flags
            local lfgRole = lfgRoles[playerName]
            if
                lfgRole and
                    (chatType == "PARTY_LEADER" or chatType == "PARTY" or chatType == "RAID" or
                        chatType == "RAID_LEADER" or
                        chatType == "INSTANCE_CHAT" or
                        chatType == "INSTANCE_CHAT_LEADER")
             then
                pflag = pflag .. lfgRole
            end
            -- Special Chat Icon
            if chatIcon then
                pflag = pflag .. chatIcon
            end
            -- Plugin Chat Icon
            if pluginChatIcon then
                pflag = pflag .. pluginChatIcon
            end

            if usingDifferentLanguage then
                local languageHeader = "[" .. arg3 .. "] "
                if showLink and (arg2 ~= "") then
                    body = format(_G["CHAT_" .. chatType .. "_GET"] .. languageHeader .. message, pflag .. playerLink)
                else
                    body = format(_G["CHAT_" .. chatType .. "_GET"] .. languageHeader .. message, pflag .. arg2)
                end
            else
                if not showLink or arg2 == "" then
                    if chatType == "TEXT_EMOTE" then
                        body = message
                    else
                        body = format(_G["CHAT_" .. chatType .. "_GET"] .. message, pflag .. arg2, arg2)
                    end
                else
                    if chatType == "EMOTE" then
                        body = format(_G["CHAT_" .. chatType .. "_GET"] .. message, pflag .. playerLink)
                    elseif chatType == "TEXT_EMOTE" and realm then
                        if info.colorNameByClass then
                            body =
                                gsub(
                                message,
                                arg2 .. "%-" .. realm,
                                pflag .. gsub(playerLink, "(|h|c.-)|r|h$", "%1-" .. realm .. "|r|h"),
                                1
                            )
                        else
                            body =
                                gsub(
                                message,
                                arg2 .. "%-" .. realm,
                                pflag .. gsub(playerLink, "(|h.-)|h$", "%1-" .. realm .. "|h"),
                                1
                            )
                        end
                    elseif chatType == "TEXT_EMOTE" then
                        body = gsub(message, arg2, pflag .. playerLink, 1)
                    elseif chatType == "GUILD_ITEM_LOOTED" then
                        body = gsub(message, "$s", GetPlayerLink(arg2, playerLinkDisplayText))
                    else
                        body = format(_G["CHAT_" .. chatType .. "_GET"] .. message, pflag .. playerLink)
                    end
                end
            end

            -- Add Channel
            if channelLength > 0 then
                body =
                    "|Hchannel:channel:" ..
                    arg8 .. "|h[" .. ChatFrame_ResolvePrefixedChannelName(arg4) .. "]|h " .. body
            end

            if CH.db.shortChannels and (chatType ~= "EMOTE" and chatType ~= "TEXT_EMOTE") then
                body = CH:HandleShortChannels(body)
            end

            for _, filter in ipairs(CH.PluginMessageFilters) do
                body = filter(body)
            end

            local accessID = ChatHistory_GetAccessID(chatGroup, chatTarget)
            local typeID = ChatHistory_GetAccessID(infoType, chatTarget, arg12 or arg13)

            local alertType =
                notChatHistory and not CH.SoundTimer and not strfind(event, "_INFORM") and
                CH.db.channelAlerts[historyTypes[event]]
            if
                alertType and alertType ~= "None" and arg2 ~= PLAYER_NAME and
                    (not CH.db.noAlertInCombat or not InCombatLockdown())
             then
                CH.SoundTimer = E:Delay(5, CH.ThrottleSound)
                PlaySoundFile(LSM:Fetch("sound", alertType), "Master")
            end

            frame:AddMessage(body, info.r, info.g, info.b, info.id, accessID, typeID, isHistory, historyTime)
        end

        if notChatHistory and (chatType == "WHISPER" or chatType == "BN_WHISPER") then
            ChatEdit_SetLastTellTarget(arg2, chatType)
            FlashClientIcon()
        end

        if notChatHistory and not frame:IsShown() then
            if
                (frame == _G.DEFAULT_CHAT_FRAME and info.flashTabOnGeneral) or
                    (frame ~= _G.DEFAULT_CHAT_FRAME and info.flashTab)
             then
                if not _G.CHAT_OPTIONS.HIDE_FRAME_ALERTS or chatType == "WHISPER" or chatType == "BN_WHISPER" then --BN_WHISPER FIXME
                    if not FCFManager_ShouldSuppressMessageFlash(frame, chatGroup, chatTarget) then
                        FCF_StartAlertFlash(frame) --This would taint if we were not using LibChatAnims
                    end
                end
            end
        end

        return true
    end
end

function CL:ToggleReplacement()
    if not self.db then
        return
    end

    -- HandleShortChannels
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

    -- ChatFrame_AddMessage
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

    -- ChatFrame_MessageEventHandler
    -- CheckLFGRoles
    if self.db.removeBrackets then
        if not initRecord.ChatFrame_MessageEventHandler then
            cache.ChatFrame_MessageEventHandler = CH.ChatFrame_MessageEventHandler
            CH.ChatFrame_MessageEventHandler = CL.ChatFrame_MessageEventHandler
            cache.CheckLFGRoles = CH.CheckLFGRoles
            CH.CheckLFGRoles = CL.CheckLFGRoles

            initRecord.ChatFrame_MessageEventHandler = true
        end
    else
        if initRecord.ChatFrame_MessageEventHandler then
            if cache.ChatFrame_MessageEventHandler then
                CH.ChatFrame_MessageEventHandler = cache.ChatFrame_MessageEventHandler
                CH.CheckLFGRoles = cache.CheckLFGRoles
            end
            
            initRecord.ChatFrame_MessageEventHandler = false
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
    self:CheckLFGRoles()
end

function CL:ProfileUpdate()
    self.db = E.db.WT.social.chatLine

    self:UpdateRoleIcons()
    self:ToggleReplacement()
    self:CheckLFGRoles()
end

W:RegisterModule(CL:GetName())
