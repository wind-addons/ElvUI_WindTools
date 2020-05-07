-- 原创模块
local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")
local EFL = E:NewModule('Wind_EnhancedFriendsList', 'AceHook-3.0')

local format = format
local pairs = pairs
local strmatch = strmatch
local strsplit = strsplit

local BNConnected = BNConnected
local BNet_GetClientTexture = BNet_GetClientTexture
local C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
local C_ClassColor_GetClassColor = C_ClassColor.GetClassColor
local C_FriendList_GetFriendInfoByIndex = C_FriendList.GetFriendInfoByIndex
local GetQuestDifficultyColor = GetQuestDifficultyColor

local BNET_CLIENT_APP = BNET_CLIENT_APP
local BNET_CLIENT_CLNT = BNET_CLIENT_CLNT
local BNET_CLIENT_COD = BNET_CLIENT_COD
local BNET_CLIENT_COD_MW = BNET_CLIENT_COD_MW
local BNET_CLIENT_D3 = BNET_CLIENT_D3
local BNET_CLIENT_HEROES = BNET_CLIENT_HEROES
local BNET_CLIENT_OVERWATCH = BNET_CLIENT_OVERWATCH
local BNET_CLIENT_SC = BNET_CLIENT_SC
local BNET_CLIENT_SC2 = BNET_CLIENT_SC2
local BNET_CLIENT_WC3 = BNET_CLIENT_WC3
local BNET_CLIENT_WOW = BNET_CLIENT_WOW
local BNET_CLIENT_WTCG = BNET_CLIENT_WTCG
local FRIENDS_TEXTURE_AFK = FRIENDS_TEXTURE_AFK
local FRIENDS_TEXTURE_DND = FRIENDS_TEXTURE_DND
local FRIENDS_TEXTURE_OFFLINE = FRIENDS_TEXTURE_OFFLINE
local FRIENDS_TEXTURE_ONLINE = FRIENDS_TEXTURE_ONLINE
local LOCALIZED_CLASS_NAMES_FEMALE = LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE
local MAX_PLAYER_LEVEL_TABLE = MAX_PLAYER_LEVEL_TABLE

local MediaPath = "Interface\\Addons\\ElvUI_WindTools\\Texture\\FriendList\\"

local GameIcons = {
    ["Alliance"] = {Default = BNet_GetClientTexture(BNET_CLIENT_WOW), Modern = MediaPath .. 'GameIcons\\Alliance'},
    ["Horde"] = {Default = BNet_GetClientTexture(BNET_CLIENT_WOW), Modern = MediaPath .. 'GameIcons\\Horde'},
    ["Neutral"] = {Default = BNet_GetClientTexture(BNET_CLIENT_WOW), Modern = MediaPath .. 'GameIcons\\WoW'},
    [BNET_CLIENT_WOW] = {Default = BNet_GetClientTexture(BNET_CLIENT_WOW), Modern = MediaPath .. 'GameIcons\\WoW'},
    [BNET_CLIENT_WOW .. "C"] = {
        Default = BNet_GetClientTexture(BNET_CLIENT_WOW),
        Modern = MediaPath .. 'GameIcons\\WoW'
    },
    [BNET_CLIENT_D3] = {Default = BNet_GetClientTexture(BNET_CLIENT_D3), Modern = MediaPath .. 'GameIcons\\D3'},
    [BNET_CLIENT_WTCG] = {Default = BNet_GetClientTexture(BNET_CLIENT_WTCG), Modern = MediaPath .. 'GameIcons\\HS'},
    [BNET_CLIENT_SC] = {Default = BNet_GetClientTexture(BNET_CLIENT_SC), Modern = MediaPath .. 'GameIcons\\SC'},
    [BNET_CLIENT_SC2] = {Default = BNet_GetClientTexture(BNET_CLIENT_SC2), Modern = MediaPath .. 'GameIcons\\SC2'},
    [BNET_CLIENT_APP] = {Default = BNet_GetClientTexture(BNET_CLIENT_APP), Modern = MediaPath .. 'GameIcons\\App'},
    ["BSAp"] = {Default = BNet_GetClientTexture(BNET_CLIENT_APP), Modern = MediaPath .. 'GameIcons\\MApp'},
    [BNET_CLIENT_HEROES] = {
        Default = BNet_GetClientTexture(BNET_CLIENT_HEROES),
        Modern = MediaPath .. 'GameIcons\\HotS'
    },
    [BNET_CLIENT_OVERWATCH] = {
        Default = BNet_GetClientTexture(BNET_CLIENT_OVERWATCH),
        Modern = MediaPath .. 'GameIcons\\OW'
    },
    [BNET_CLIENT_COD] = {Default = BNet_GetClientTexture(BNET_CLIENT_COD), Modern = MediaPath .. 'GameIcons\\COD'},
    [BNET_CLIENT_COD_MW] = {
        Default = BNet_GetClientTexture(BNET_CLIENT_COD_MW),
        Modern = MediaPath .. 'GameIcons\\COD_MW'
    },
    [BNET_CLIENT_WC3] = {Default = BNet_GetClientTexture(BNET_CLIENT_WC3), Modern = MediaPath .. 'GameIcons\\WC3'}
}

local StatusIcons = {
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

local BNColor = {
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

    local game, realID, name, server, class, area, level, faction, status

    -- 获取好友游戏情况
    if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
        -- 角色游戏好友
        game = BNET_CLIENT_WOW
        local friendInfo = C_FriendList_GetFriendInfoByIndex(button.id)
        name, server = strsplit("-", friendInfo.name) -- 如果是同一个服务器，server 为 nil
        level = friendInfo.level
        class = friendInfo.className
        area = friendInfo.area
        faction = E.myfaction -- 同一阵营才能加好友的吧？

        if friendInfo.connected then
            if friendInfo.afk then
                status = "AFK"
            elseif friendInfo.dnd then
                status = "DND"
            else
                status = "Online"
            end
        else
            status = "Offline"
        end

    elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET and BNConnected() then
        -- 战网好友
        local friendAccountInfo = C_BattleNet_GetFriendAccountInfo(button.id)
        realID = friendAccountInfo.accountName

        local gameAccountInfo = friendAccountInfo.gameAccountInfo
        game = gameAccountInfo.clientProgram

        if gameAccountInfo.isOnline then
            if friendAccountInfo.isAFK or gameAccountInfo.isGameAFK then
                status = "AFK"
            elseif friendAccountInfo.isDND or gameAccountInfo.isGameBusy then
                status = "DND"
            else
                status = "Online"
            end
        else
            status = "Offline"
        end

        -- 如果是魔兽正式服/怀旧服，进一步获取角色信息
        if game == BNET_CLIENT_WOW then
            name = gameAccountInfo.characterName or ""
            level = gameAccountInfo.characterLevel or 0
            faction = gameAccountInfo.factionName or nil
            class = gameAccountInfo.className or ""
            area = gameAccountInfo.areaName or ""

            if gameAccountInfo.wowProjectID == 2 then
                game = BNET_CLIENT_WOW .. "C" -- 标注怀旧服好友
                server = BNET_FRIEND_TOOLTIP_WOW_CLASSIC -- 暂时用经典版来代替服务器
            else
                server = gameAccountInfo.realmDisplayName or ""
            end
        end
    end

    -- 状态图标
    if status then button.status:SetTexture(StatusIcons[self.db.textures.status][status]) end

    if game and game ~= "" then
        local buttonTitle, buttonText

        -- 名字
        local realIDString = realID and self.db.nameStyle.useGameColor and WT:ColorStrWithPack(realID, BNColor[game]) or
                                 realID
        local nameString =
            class and self.db.nameStyle.useClassColor and WT:ColorStrWithPack(name, GetClassColor(class)) or name

        if level and MaxLevel[game] and (level ~= MaxLevel[game] or not self.db.nameStyle.hideMaxLevel) then
            nameString = nameString .. WT:ColorStrWithPack(": " .. level, GetQuestDifficultyColor(level))
        end

        if nameString and realIDString then
            buttonTitle = realIDString .. " \124\124 " .. nameString
        elseif nameString then
            buttonTitle = nameString
        else
            buttonTitle = realIDString or ""
        end

        button.name:SetText(buttonTitle)

        -- 地区
        if area then
            if server and server ~= E.myrealm then
                buttonText = WT:ColorStrWithPack(area .. " - " .. server, self.db.infoStyle.areaColor)
            else
                buttonText = WT:ColorStrWithPack(area, self.db.infoStyle.areaColor)
            end

            button.info:SetText(buttonText)
        end

        -- 游戏图标
        button.gameIcon:SetTexture(GameIcons[faction or game][self.db.textures.game])
        button.gameIcon:Show() -- 普通角色好友暴雪隐藏了

        if button.summonButton:IsShown() then
            button.gameIcon:SetPoint('TOPRIGHT', -50, -2)
        else
            button.gameIcon:SetPoint('TOPRIGHT', -21, -2)
        end
    end

    -- 字体风格
    WT.ClearTextShadow(button.name)
    WT.SetFont(button.name, self.db.nameStyle)

    WT.ClearTextShadow(button.info)
    WT.SetFont(button.info, self.db.infoStyle)

    if button.Favorite:IsShown() then
        button.Favorite:ClearAllPoints()
        button.Favorite:SetPoint("LEFT", button.name, "LEFT", button.name:GetStringWidth(), 0)
    end
end

function EFL:Initialize()
    if not E.db.WindTools["Chat"]["Enhanced Friend List"]["enabled"] then return end

    self.db = E.db.WindTools["Chat"]["Enhanced Friend List"]
    tinsert(WT.UpdateAll, function() EFL.db = E.db.WindTools["Chat"]["Enhanced Friend List"] end)

    self:SecureHook("FriendsFrame_UpdateFriendButton", 'UpdateFriendButton')
end

local function InitializeCallback() EFL:Initialize() end

E:RegisterModule(EFL:GetName(), InitializeCallback)
