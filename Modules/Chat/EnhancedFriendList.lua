-- 原作：EnhancedFriendList
-- 原作者：Awbee (http://www.wowinterface.com/downloads/info8679-EnhancedFriendList.html)
-- 修改：houshuu, SomeBlu
-------------------
-- 主要修改条目：
-- 模块化, 精简代码
-- 染色逻辑
-- 添加新的 rgb 函数

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")
local EFL = E:NewModule('Wind_EnhancedFriendsList', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')

-- Enhanced
local MediaPath = 'Interface\\Addons\\ElvUI_WindTools\\Texture\\FriendList\\'
EFL.GameIcons = {
    Alliance = {
        Default = BNet_GetClientTexture(BNET_CLIENT_WOW),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-WoW',
        Flat = MediaPath .. 'GameIcons\\Flat\\Alliance',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\Alliance',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\Alliance',
    },
    Horde = {
        Default = BNet_GetClientTexture(BNET_CLIENT_WOW),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-WoW',
        Flat = MediaPath .. 'GameIcons\\Flat\\Horde',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\Horde',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\Horde',
    },
    Neutral = {
        Default = BNet_GetClientTexture(BNET_CLIENT_WOW),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-WoW',
        Flat = MediaPath .. 'GameIcons\\Flat\\WoW',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\WoW',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\WoW',
    },
    D3 = {
        Default = BNet_GetClientTexture(BNET_CLIENT_D3),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-D3',
        Flat = MediaPath .. 'GameIcons\\Flat\\D3',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\D3',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\D3',
    },
    WTCG = {
        Default = BNet_GetClientTexture(BNET_CLIENT_WTCG),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-WTCG',
        Flat = MediaPath .. 'GameIcons\\Flat\\Hearthstone',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\Hearthstone',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\Hearthstone',
    },
    S1 = {
        Default = BNet_GetClientTexture(BNET_CLIENT_SC),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-SC',
        Flat = MediaPath .. 'GameIcons\\Flat\\SC',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\SC',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\SC',
    },
    S2 = {
        Default = BNet_GetClientTexture(BNET_CLIENT_SC2),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-SC2',
        Flat = MediaPath .. 'GameIcons\\Flat\\SC2',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\SC2',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\SC2',
    },
    App = {
        Default = BNet_GetClientTexture(BNET_CLIENT_APP),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-Battlenet',
        Flat = MediaPath .. 'GameIcons\\Flat\\BattleNet',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\BattleNet',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\BattleNet',
    },
    BSAp = {
        Default = BNet_GetClientTexture(BNET_CLIENT_APP),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-Battlenet',
        Flat = MediaPath .. 'GameIcons\\Flat\\BattleNet',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\BattleNet',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\BattleNet',
    },
    Hero = {
        Default = BNet_GetClientTexture(BNET_CLIENT_HEROES),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-HotS',
        Flat = MediaPath .. 'GameIcons\\Flat\\Heroes',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\Heroes',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\Heroes',
    },
    Pro = {
        Default = BNet_GetClientTexture(BNET_CLIENT_OVERWATCH),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-Overwatch',
        Flat = MediaPath .. 'GameIcons\\Flat\\Overwatch',
        Gloss = MediaPath .. 'GameIcons\\Gloss\\Overwatch',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\Overwatch',
    },
    DST2 = {
        Default = BNet_GetClientTexture(BNET_CLIENT_DESTINY2),
        BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-Destiny2',
        Flat = MediaPath .. 'GameIcons\\Launcher\\Destiny2',
        Gloss = MediaPath .. 'GameIcons\\Launcher\\Destiny2',
        Launcher = MediaPath .. 'GameIcons\\Launcher\\Destiny2',
    },
}
EFL.StatusIcons = {
    Default = {
        Online = FRIENDS_TEXTURE_ONLINE,
        Offline = FRIENDS_TEXTURE_OFFLINE,
        DND = FRIENDS_TEXTURE_DND,
        AFK = FRIENDS_TEXTURE_AFK,
    },
    Square = {
        Online = MediaPath .. 'StatusIcons\\Square\\Online',
        Offline = MediaPath .. 'StatusIcons\\Square\\Offline',
        DND = MediaPath .. 'StatusIcons\\Square\\DND',
        AFK = MediaPath .. 'StatusIcons\\Square\\AFK',
    },
    D3 = {
        Online = MediaPath .. 'StatusIcons\\D3\\Online',
        Offline = MediaPath .. 'StatusIcons\\D3\\Offline',
        DND = MediaPath .. 'StatusIcons\\D3\\DND',
        AFK = MediaPath .. 'StatusIcons\\D3\\AFK',
    },
}
EFL.ClientColor = {
    S1 = 'C495DD',
    S2 = 'C495DD',
    D3 = 'C41F3B',
    Pro = 'FFFFFF',
    WTCG = 'FFB100',
    Hero = '00CCFF',
    App = '82C5FF',
    BSAp = '82C5FF',
}
function EFL:ClassColor(class)
    for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
        if class == v then
            class = k;
            break ;
        end
    end
    if GetLocale() ~= "enUS" then
        for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
            if class == v then
                class = k;
                break ;
            end
        end
    end
    return (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class];
end

function EFL:UpdateFriends(button)
    local nameText, nameColor, infoText, broadcastText, _, Cooperate
    if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
        local name, level, class, area, connected, status = GetFriendInfo(button.id)
        local classc = EFL:ClassColor(class)
        broadcastText = nil
        if connected and classc then
            button.status:SetTexture(EFL.StatusIcons[self.db["enhanced"].StatusIconPack][(status == CHAT_FLAG_DND and 'DND' or status == CHAT_FLAG_AFK and 'AFK' or 'Online')])
            nameText = format('%s%s - (%s - %s %s)', classc:GenerateHexColorMarkup(), name, class, LEVEL, level)
            nameColor = FRIENDS_WOW_NAME_COLOR
            Cooperate = true
        else
            button.status:SetTexture(EFL.StatusIcons[self.db["enhanced"].StatusIconPack].Offline)
            nameText = name
            nameColor = FRIENDS_GRAY_COLOR
        end
        infoText = area
    elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET and BNConnected() then
        local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(button.id)
        local realmName, realmID, faction, race, class, zoneName, level, gameText
        broadcastText = messageText
        local characterName = toonName
        if presenceName then
            nameText = presenceName
            if isOnline then
                characterName = BNet_GetValidatedCharacterName(characterName, battleTag, client)
            end
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

            local classc = EFL:ClassColor(class)
            if client == BNET_CLIENT_WOW and classc then
                if (level == nil or tonumber(level) == nil) then
                    level = 0
                end
                local diff = level ~= 0 and format('|cFF%02x%02x%02x', GetQuestDifficultyColor(level).r * 255, GetQuestDifficultyColor(level).g * 255, GetQuestDifficultyColor(level).b * 255) or '|cFFFFFFFF'
                nameText = format('%s |cFFFFFFFF(|r%s%s|r - %s %s%s|r|cFFFFFFFF)|r', nameText, classc:GenerateHexColorMarkup(), characterName, LEVEL, diff, level)
                Cooperate = CanCooperateWithGameAccount(accountInfo) and realmName ~= "" --拿不到服务器名字的为怀旧服
            else
                nameText = format('|cFF%s%s|r', EFL.ClientColor[client] or 'FFFFFF', nameText)
            end
        end

        if isOnline then
            button.status:SetTexture(EFL.StatusIcons[self.db["enhanced"].StatusIconPack][(isDND and 'DND' or isAFK and 'AFK' or 'Online')])
            if client == BNET_CLIENT_WOW then
                if not zoneName or zoneName == '' then
                    infoText = UNKNOWN
                else
                    if realmName == EFL.MyRealm then
                        infoText = zoneName
                    else
                        infoText = format('%s - %s', zoneName, realmName)
                        if realmName == "" and realmID ~= 0 then
                            infoText = gameText --拿不到服务器名字的为怀旧服
                        end
                    end
                end

                if faction ~= "" then
                    button.gameIcon:SetTexture(EFL.GameIcons[faction][self.db["enhanced"].GameIcon[faction]])
                end
            else
                infoText = gameText
                button.gameIcon:SetTexture(EFL.GameIcons[client][self.db["enhanced"].GameIcon[client]])
            end
            nameColor = FRIENDS_BNET_NAME_COLOR
        else
            button.status:SetTexture(EFL.StatusIcons[self.db["enhanced"].StatusIconPack].Offline)
            nameColor = FRIENDS_GRAY_COLOR
            infoText = lastOnline == 0 and FRIENDS_LIST_OFFLINE or format(BNET_LAST_ONLINE_TIME, FriendsFrame_GetLastOnlineText(lastOnline))
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
        button.name:SetFont(LSM:Fetch('font', self.db["enhanced"].NameFont), self.db["enhanced"].NameFontSize, self.db["enhanced"].NameFontFlag)
    end

    if infoText then
        button.info:SetText(infoText)
        button.info:SetTextColor(unpack(Cooperate and { 1, .96, .45 } or { .49, .52, .54 }))
        button.info:SetFont(LSM:Fetch('font', self.db["enhanced"].InfoFont), self.db["enhanced"].InfoFontSize, self.db["enhanced"].InfoFontFlag)
    end
end

function EFL:Initialize()
    -- 总开关
    if not E.db.WindTools["Chat"]["Enhanced Friend List"]["enabled"] then
        return
    end

    self.db = E.db.WindTools["Chat"]["Enhanced Friend List"]
    tinsert(WT.UpdateAll, function()
        EFL.db = E.db.WindTools["Chat"]["Enhanced Friend List"]["enhanced"]
    end)

    if self.db["enhanced"]["enabled"] then
        -- 检查是否要进行增强
        EFL:SecureHook("FriendsFrame_UpdateFriendButton", 'UpdateFriends')
    end
end

local function InitializeCallback()
    EFL:Initialize()
end

E:RegisterModule(EFL:GetName(), InitializeCallback)
