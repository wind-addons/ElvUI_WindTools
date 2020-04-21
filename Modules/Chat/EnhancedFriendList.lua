-- 原创模块
local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")
local EFL = E:NewModule('Wind_EnhancedFriendsList', 'AceHook-3.0')

local pairs = pairs
local strmatch = strmatch
local strsplit = strsplit
local format = format
local BNConnected = BNConnected
local GetQuestDifficultyColor = GetQuestDifficultyColor
local C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
local C_ClassColor_GetClassColor = C_ClassColor.GetClassColor
local C_FriendList_GetFriendInfoByIndex = C_FriendList.GetFriendInfoByIndex

local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE
local LOCALIZED_CLASS_NAMES_FEMALE = LOCALIZED_CLASS_NAMES_FEMALE
local MAX_PLAYER_LEVEL_TABLE = MAX_PLAYER_LEVEL_TABLE

-- Enhanced
local MediaPath = 'Interface\\Addons\\ElvUI_WindTools\\Texture\\FriendList\\'
EFL.GameIcons = {
    Alliance = {
        Default = BNet_GetClientTexture(BNET_CLIENT_WOW),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-WoW',
        Flat = MediaPath .. 'GameIcons\\Flat\\Alliance',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\Alliance',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\Alliance'
    },
    Horde = {
        Default = BNet_GetClientTexture(BNET_CLIENT_WOW),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-WoW',
        Flat = MediaPath .. 'GameIcons\\Flat\\Horde',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\Horde',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\Horde'
    },
    Neutral = {
        Default = BNet_GetClientTexture(BNET_CLIENT_WOW),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-WoW',
        Flat = MediaPath .. 'GameIcons\\Flat\\WoW',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\WoW',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\WoW'
    },
    D3 = {
        Default = BNet_GetClientTexture(BNET_CLIENT_D3),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-D3',
        Flat = MediaPath .. 'GameIcons\\Flat\\D3',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\D3',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\D3'
    },
    WTCG = {
        Default = BNet_GetClientTexture(BNET_CLIENT_WTCG),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-WTCG',
        Flat = MediaPath .. 'GameIcons\\Flat\\Hearthstone',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\Hearthstone',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\Hearthstone'
    },
    S1 = {
        Default = BNet_GetClientTexture(BNET_CLIENT_SC),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-SC',
        Flat = MediaPath .. 'GameIcons\\Flat\\SC',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\SC',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\SC'
    },
    S2 = {
        Default = BNet_GetClientTexture(BNET_CLIENT_SC2),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-SC2',
        Flat = MediaPath .. 'GameIcons\\Flat\\SC2',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\SC2',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\SC2'
    },
    App = {
        Default = BNet_GetClientTexture(BNET_CLIENT_APP),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-Battlenet',
        Flat = MediaPath .. 'GameIcons\\Flat\\BattleNet',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\BattleNet',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\BattleNet'
    },
    BSAp = {
        Default = BNet_GetClientTexture(BNET_CLIENT_APP),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-Battlenet',
        Flat = MediaPath .. 'GameIcons\\Flat\\BattleNet',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\BattleNet',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\BattleNet'
    },
    Hero = {
        Default = BNet_GetClientTexture(BNET_CLIENT_HEROES),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-HotS',
        Flat = MediaPath .. 'GameIcons\\Flat\\Heroes',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\Heroes',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\Heroes'
    },
    Pro = {
        Default = BNet_GetClientTexture(BNET_CLIENT_OVERWATCH),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-Overwatch',
        Flat = MediaPath .. 'GameIcons\\Flat\\Overwatch',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\Overwatch',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\Overwatch'
    },
    DST2 = {
        Default = BNet_GetClientTexture(BNET_CLIENT_DESTINY2),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-Destiny2',
        Flat = MediaPath .. 'GameIcons\\Launcher\\Destiny2',
        Gloss = MediaPath .. 'GameIcons\\Launcher\\Destiny2',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\Destiny2'
    },
    VIPR = {
        Default = BNet_GetClientTexture(BNET_CLIENT_COD),
        BlizzardChat = BNet_GetClientTexture(BNET_CLIENT_COD),
        Flat = BNet_GetClientTexture(BNET_CLIENT_COD),
        Gloss = BNet_GetClientTexture(BNET_CLIENT_COD),
        Launcher = BNet_GetClientTexture(BNET_CLIENT_COD)
    },
    ODIN = {
        Default = BNet_GetClientTexture(BNET_CLIENT_COD_MW),
        BlizzardChat = BNet_GetClientTexture(BNET_CLIENT_COD_MW),
        Flat = BNet_GetClientTexture(BNET_CLIENT_COD_MW),
        Gloss = BNet_GetClientTexture(BNET_CLIENT_COD_MW),
        Launcher = BNet_GetClientTexture(BNET_CLIENT_COD_MW)
    },
    W3 = {
        Default = BNet_GetClientTexture(BNET_CLIENT_WC3),
        BlizzardChat = BNet_GetClientTexture(BNET_CLIENT_WC3),
        Flat = BNet_GetClientTexture(BNET_CLIENT_WC3),
        Gloss = BNet_GetClientTexture(BNET_CLIENT_WC3),
        Launcher = BNet_GetClientTexture(BNET_CLIENT_WC3)
    }
}
EFL.StatusIcons = {
    Default = {
        Online = FRIENDS_TEXTURE_ONLINE,
        Offline = FRIENDS_TEXTURE_OFFLINE,
        DND = FRIENDS_TEXTURE_DND,
        AFK = FRIENDS_TEXTURE_AFK
    },
    Square = {
        Online = MediaPath .. 'StatusIcons\\Square\\Online',
        Offline = MediaPath .. 'StatusIcons\\Square\\Offline',
        DND = MediaPath .. 'StatusIcons\\Square\\DND',
        AFK = MediaPath .. 'StatusIcons\\Square\\AFK'
    },
    D3 = {
        Online = MediaPath .. 'StatusIcons\\D3\\Online',
        Offline = MediaPath .. 'StatusIcons\\D3\\Offline',
        DND = MediaPath .. 'StatusIcons\\D3\\DND',
        AFK = MediaPath .. 'StatusIcons\\D3\\AFK'
    }
}

local MaxLevel = {
    [BNET_CLIENT_WOW .. "C"] = MAX_PLAYER_LEVEL_TABLE[0],
    [BNET_CLIENT_WOW] = MAX_PLAYER_LEVEL_TABLE[#MAX_PLAYER_LEVEL_TABLE]
}

local BNClientColor = {
    [BNET_CLIENT_CLNT] = {r = .509, g = .772, b = 1}, -- 未知
    [BNET_CLIENT_APP] = {r = .509, g = .772, b = 1}, -- 战网
    [BNET_CLIENT_WC3] = {r = .796, g = .247, b = .145}, -- 魔兽争霸重置版 3
    [BNET_CLIENT_SC] = {r = .749, g = .501, b = .878}, -- 星际争霸 1
    [BNET_CLIENT_SC2] = {r = .749, g = .501, b = .878}, -- 星际争霸 2
    [BNET_CLIENT_D3] = {r = .768, g = .121, b = .231}, -- 暗黑破坏神 3
    [BNET_CLIENT_WOW] = {r = .866, g = .690, b = .180}, -- 魔兽世界
    [BNET_CLIENT_WTCG] = {r = 1, g = .694, b = 0}, -- 炉石传说
    [BNET_CLIENT_HEROES] = {r = 0, g = .8, b = 1}, -- 风暴英雄
    [BNET_CLIENT_OVERWATCH] = {r = 1, g = 1, b = 1}, -- 守望先锋
    [BNET_CLIENT_COD] = {r = 0, g = .8, b = 0}, -- 使命召唤
    [BNET_CLIENT_COD_MW] = {r = 0, g = .8, b = 0}, -- 使命召唤：现代战争 2
    -- 命运 2 因为已经分家了，不会出现了，下面为自定客户端代码
    [BNET_CLIENT_WOW .. "C"] = {r = .866, g = .690, b = .180}, -- 魔兽世界怀旧版
    ["BSAp"] = {r = .509, g = .772, b = 1} -- 手机战网 App
}

local function GetClassColor(className)
    for class, localizedName in pairs(LOCALIZED_CLASS_NAMES_MALE) do
        if className == localizedName then return C_ClassColor_GetClassColor(class) end
    end

    -- 德语及法语有分性别的职业名
    if E.locale == "deDE" or E.locale == "frFR" then
        for class, localizedName in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
            if className == localizedName then return C_ClassColor_GetClassColor(class) end
        end
    end
end

function EFL:UpdateFriendButton(button)
    if button.buttonType == FRIENDS_BUTTON_TYPE_DIVIDER then return end

    local game, realID, name, server, class, area, level, faction, lastOnline

    -- 获取好友游戏情况
    if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
        -- 角色游戏好友
        game = BNET_CLIENT_WOW
        local friendInfo = C_FriendList_GetFriendInfoByIndex(button.id)
        name, server = strsplit("-", friendInfo.name) -- 如果是同一个服务器，server 为 nil
    elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET and BNConnected() then
        -- 战网好友
        local friendAccountInfo = C_BattleNet_GetFriendAccountInfo(button.id)
        realID = friendAccountInfo.accountName

        local gameAccountInfo = friendAccountInfo.gameAccountInfo
        game = gameAccountInfo.clientProgram

        -- 如果是魔兽正式服/怀旧服，进一步获取角色信息
        if game == BNET_CLIENT_WOW then
            name = gameAccountInfo.characterName or ""
            level = gameAccountInfo.characterLevel or 0
            faction = gameAccountInfo.factionName or ""
            class = gameAccountInfo.className or ""
            area = gameAccountInfo.areaName or ""
            lastOnline = gameAccountInfo.lastOnlineTime or 0

            if gameAccountInfo.wowProjectID == 2 then
                game = BNET_CLIENT_WOW .. "C" -- 标注怀旧服好友
                server = BNET_FRIEND_TOOLTIP_WOW_CLASSIC -- 暂时用经典版来代替服务器
            else
                server = gameAccountInfo.realmDisplayName or ""
            end
        end
    end

    if game and game ~= "" then
        local buttonTitle, buttonText
        local realIDString = realID and WT:ColorStrWithPack(realID, BNClientColor[game]) or realID or ""
        local nameString = class and WT:ColorStrWithPack(name, GetClassColor(class)) or name
        local levelString = level and MaxLevel[game] and level <= MaxLevel[game] and
                                WT:ColorStrWithPack(": " .. level, GetQuestDifficultyColor(level)) or ""

        
        if nameString and realIDString ~= "" then
            buttonTitle = realIDString .. "(" .. nameString .. levelString .. ")"
        elseif nameString then
            buttonTitle = nameString .. levelString
        else
            buttonTitle = realIDString
        end

        button.name:SetText(buttonTitle)

        if area then
            buttonText = WT:ColorStrWithPack(area.." - "..server, {r = 1, g = 1, b=1})
            button.info:SetText(buttonText)
        end
    end

    button.name:SetShadowColor(0, 0, 0, 0)
    button.name.SetShadowColor = E.noop
    button.name:SetFont(LSM:Fetch('font', self.db.enhanced.NameFont), self.db.enhanced.NameFontSize,
                        self.db.enhanced.NameFontFlag)

    button.info:SetShadowColor(0, 0, 0, 0)
    button.info.SetShadowColor = E.noop
    button.info:SetFont(LSM:Fetch('font', self.db.enhanced.InfoFont), self.db.enhanced.InfoFontSize,
                        self.db.enhanced.InfoFontFlag)
end

function EFL:UpdateFriends(button)
    local nameText, nameColor, infoText, broadcastText, _, Cooperate
    if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
        local name, level, class, area, connected, status = GetFriendInfo(button.id)
        local classc = EFL:ClassColor(class)
        broadcastText = nil
        if connected and classc then
            if self.db.enhanced.enabled then
                button.status:SetTexture(
                    EFL.StatusIcons[self.db["enhanced"].StatusIconPack][(status == CHAT_FLAG_DND and 'DND' or status ==
                        CHAT_FLAG_AFK and 'AFK' or 'Online')])
            end
            nameText = format('%s%s - (%s - %s %s)', classc:GenerateHexColorMarkup(), name, class, LEVEL, level)
            nameColor = FRIENDS_WOW_NAME_COLOR
            Cooperate = true
        else
            if self.db.enhanced.enabled then
                button.status:SetTexture(EFL.StatusIcons[self.db["enhanced"].StatusIconPack].Offline)
            end
            nameText = name
            nameColor = FRIENDS_GRAY_COLOR
        end
        infoText = area
    elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET and BNConnected() then
        local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline,
              isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(button.id)
        local realmName, realmID, faction, race, class, zoneName, level, gameText
        broadcastText = messageText
        local characterName = toonName
        if presenceName then
            nameText = presenceName
            if isOnline then characterName = BNet_GetValidatedCharacterName(characterName, battleTag, client) end
        else
            nameText = UNKNOWN
        end

        if characterName then
            local accountInfo = C_BattleNet.GetFriendAccountInfo(button.id);
            local gameAccountInfo = C_BattleNet.GetGameAccountInfoByID(toonID);
            realmName = gameAccountInfo.realmName or "";
            realmID = gameAccountInfo.realmID or 0;
            faction = gameAccountInfo.factionName or "";
            race = gameAccountInfo.raceName or "";
            class = gameAccountInfo.className or "";
            zoneName = gameAccountInfo.areaName or "";
            level = gameAccountInfo.characterLevel or "";
            gameText = gameAccountInfo.richPresence or "";
            lastOnline = accountInfo.lastOnlineTime or 0;

            local classc = EFL:ClassColor(class)
            if client == BNET_CLIENT_WOW and classc then
                if (level == nil or tonumber(level) == nil) then level = 0 end
                local diff = level ~= 0 and
                                 format('|cFF%02x%02x%02x', GetQuestDifficultyColor(level).r * 255,
                                        GetQuestDifficultyColor(level).g * 255, GetQuestDifficultyColor(level).b * 255) or
                                 '|cFFFFFFFF'
                nameText = format('%s |cFFFFFFFF(|r%s%s|r - %s %s%s|r|cFFFFFFFF)|r', nameText,
                                  classc:GenerateHexColorMarkup(), characterName, LEVEL, diff, level)
                Cooperate = CanCooperateWithGameAccount(accountInfo) and realmName ~= "" -- 拿不到服务器名字的为怀旧服
            else
                nameText = format('|cFF%s%s|r', EFL.ClientColor[client] or 'FFFFFF', nameText)
            end
        end

        if isOnline then
            if self.db.enhanced.enabled then
                button.status:SetTexture(
                    EFL.StatusIcons[self.db["enhanced"].StatusIconPack][(isDND and 'DND' or isAFK and 'AFK' or 'Online')])
            end
            if client == BNET_CLIENT_WOW then
                if not zoneName or zoneName == '' then
                    infoText = UNKNOWN
                else
                    if realmName == EFL.MyRealm then
                        infoText = zoneName
                    else
                        infoText = format('%s - %s', zoneName, realmName)
                        if realmName == "" and realmID ~= 0 then
                            infoText = gameText -- 拿不到服务器名字的为怀旧服
                        end
                    end
                end

                if faction ~= "" then
                    if self.db.enhanced.enabled then
                        button.gameIcon:SetTexture(EFL.GameIcons[faction][self.db["enhanced"].GameIcon[faction]])
                    end
                end
            else
                infoText = gameText
                if self.db.enhanced.enabled then
                    button.gameIcon:SetTexture(EFL.GameIcons[client][self.db["enhanced"].GameIcon[client]])
                end
            end
            nameColor = FRIENDS_BNET_NAME_COLOR
        else
            if self.db.enhanced.enabled then
                button.status:SetTexture(EFL.StatusIcons[self.db["enhanced"].StatusIconPack].Offline)
            end
            nameColor = FRIENDS_GRAY_COLOR
            if lastOnline == 0 then
                infoText = FRIENDS_LIST_OFFLINE
            elseif lastOnline == nil then
                infoText = FRIENDS_LIST_ONLINE
            else
                infoText = format(BNET_LAST_ONLINE_TIME, FriendsFrame_GetLastOnline(lastOnline))
            end
        end
    end

    if button.summonButton:IsShown() then
        button.gameIcon:SetPoint('TOPRIGHT', -50, -2)
    else
        button.gameIcon:SetPoint('TOPRIGHT', -21, -2)
    end

    if button.Favorite:IsShown() then
        button.Favorite:SetPoint("TOPLEFT", button.name, "TOPLEFT", button.name:GetStringWidth(), 0);
    end
    if nameText then
        button.name:SetText(nameText)
        button.name:SetTextColor(nameColor:GetRGB())
        button.name:SetFont(LSM:Fetch('font', self.db["enhanced"].NameFont), self.db["enhanced"].NameFontSize,
                            self.db["enhanced"].NameFontFlag)
    end

    if infoText then
        button.info:SetText(infoText)
        button.info:SetTextColor(unpack(Cooperate and {1, .96, .45} or {.49, .52, .54}))
        button.info:SetFont(LSM:Fetch('font', self.db["enhanced"].InfoFont), self.db["enhanced"].InfoFontSize,
                            self.db["enhanced"].InfoFontFlag)
    end
end

function EFL:Initialize()
    if not E.db.WindTools["Chat"]["Enhanced Friend List"]["enabled"] then return end

    self.db = E.db.WindTools["Chat"]["Enhanced Friend List"]
    tinsert(WT.UpdateAll, function() EFL.db = E.db.WindTools["Chat"]["Enhanced Friend List"]["enhanced"] end)

    EFL:SecureHook("FriendsFrame_UpdateFriendButton", 'UpdateFriendButton')
end

local function InitializeCallback() EFL:Initialize() end

E:RegisterModule(EFL:GetName(), InitializeCallback)
