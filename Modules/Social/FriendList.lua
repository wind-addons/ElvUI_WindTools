local W, F, E, L = unpack(select(2, ...))
local FL = W:NewModule("FriendList", "AceHook-3.0")

local _G = _G
local format = format
local pairs = pairs
local strmatch = strmatch
local strsplit = strsplit

local BNConnected = BNConnected
local BNet_GetClientTexture = BNet_GetClientTexture
local FriendsFrame_Update = FriendsFrame_Update
local GetQuestDifficultyColor = GetQuestDifficultyColor

local C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
local C_ClassColor_GetClassColor = C_ClassColor.GetClassColor
local C_FriendList_GetFriendInfoByIndex = C_FriendList.GetFriendInfoByIndex

local BNET_CLIENT_WOW = BNET_CLIENT_WOW
local BNET_CLIENT_SC2 = BNET_CLIENT_SC2
local BNET_CLIENT_D3 = BNET_CLIENT_D3
local BNET_CLIENT_WTCG = BNET_CLIENT_WTCG
local BNET_CLIENT_APP = BNET_CLIENT_APP
local BNET_CLIENT_HEROES = BNET_CLIENT_HEROES
local BNET_CLIENT_OVERWATCH = BNET_CLIENT_OVERWATCH
local BNET_CLIENT_CLNT = BNET_CLIENT_CLNT
local BNET_CLIENT_SC = BNET_CLIENT_SC
local BNET_CLIENT_DESTINY2 = BNET_CLIENT_DESTINY2
local BNET_CLIENT_COD = BNET_CLIENT_COD
local BNET_CLIENT_COD_MW = BNET_CLIENT_COD_MW
local BNET_CLIENT_COD_MW2 = BNET_CLIENT_COD_MW2
local BNET_CLIENT_COD_BOCW = BNET_CLIENT_COD_BOCW
local BNET_CLIENT_WC3 = BNET_CLIENT_WC3
local BNET_CLIENT_ARCADE = BNET_CLIENT_ARCADE
local BNET_CLIENT_CRASH4 = BNET_CLIENT_CRASH4
local BNET_CLIENT_D2 = BNET_CLIENT_D2

local CINEMATIC_NAME_2 = CINEMATIC_NAME_2

local WOW_PROJECT_MAINLINE = WOW_PROJECT_MAINLINE
local WOW_PROJECT_CLASSIC = WOW_PROJECT_CLASSIC
local WOW_PROJECT_CLASSIC_TBC = 5

local FRIENDS_TEXTURE_AFK, FRIENDS_TEXTURE_DND = FRIENDS_TEXTURE_AFK, FRIENDS_TEXTURE_DND
local FRIENDS_TEXTURE_OFFLINE, FRIENDS_TEXTURE_ONLINE = FRIENDS_TEXTURE_OFFLINE, FRIENDS_TEXTURE_ONLINE
local LOCALIZED_CLASS_NAMES_FEMALE = LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE

local FRIENDS_BUTTON_TYPE_DIVIDER = FRIENDS_BUTTON_TYPE_DIVIDER
local FRIENDS_BUTTON_TYPE_WOW = FRIENDS_BUTTON_TYPE_WOW
local FRIENDS_BUTTON_TYPE_BNET = FRIENDS_BUTTON_TYPE_BNET
local BNET_FRIEND_TOOLTIP_WOW_CLASSIC = BNET_FRIEND_TOOLTIP_WOW_CLASSIC

local MediaPath = "Interface\\Addons\\ElvUI_WindTools\\Media\\FriendList\\"

local cache = {}

local GameIcons = {
    ["Alliance"] = {Default = BNet_GetClientTexture(BNET_CLIENT_WOW), Modern = MediaPath .. "GameIcons\\Alliance"},
    ["Horde"] = {Default = BNet_GetClientTexture(BNET_CLIENT_WOW), Modern = MediaPath .. "GameIcons\\Horde"},
    ["Neutral"] = {Default = BNet_GetClientTexture(BNET_CLIENT_WOW), Modern = MediaPath .. "GameIcons\\WoW"},
    [BNET_CLIENT_WOW] = {Default = BNet_GetClientTexture(BNET_CLIENT_WOW), Modern = MediaPath .. "GameIcons\\WoWSL"},
    [BNET_CLIENT_WOW .. "C"] = {
        Default = BNet_GetClientTexture(BNET_CLIENT_WOW),
        Modern = MediaPath .. "GameIcons\\WoW"
    },
    [BNET_CLIENT_WOW .. "C_TBC"] = {
        Default = BNet_GetClientTexture(BNET_CLIENT_WOW),
        Modern = MediaPath .. "GameIcons\\WoWC"
    },
    [BNET_CLIENT_D2] = {Default = BNet_GetClientTexture(BNET_CLIENT_D2), Modern = MediaPath .. "GameIcons\\D2"},
    [BNET_CLIENT_D3] = {Default = BNet_GetClientTexture(BNET_CLIENT_D3), Modern = MediaPath .. "GameIcons\\D3"},
    [BNET_CLIENT_WTCG] = {Default = BNet_GetClientTexture(BNET_CLIENT_WTCG), Modern = MediaPath .. "GameIcons\\HS"},
    [BNET_CLIENT_SC] = {Default = BNet_GetClientTexture(BNET_CLIENT_SC), Modern = MediaPath .. "GameIcons\\SC"},
    [BNET_CLIENT_SC2] = {Default = BNet_GetClientTexture(BNET_CLIENT_SC2), Modern = MediaPath .. "GameIcons\\SC2"},
    [BNET_CLIENT_APP] = {Default = BNet_GetClientTexture(BNET_CLIENT_APP), Modern = MediaPath .. "GameIcons\\App"},
    ["BSAp"] = {Default = BNet_GetClientTexture(BNET_CLIENT_APP), Modern = MediaPath .. "GameIcons\\Mobile"},
    [BNET_CLIENT_HEROES] = {
        Default = BNet_GetClientTexture(BNET_CLIENT_HEROES),
        Modern = MediaPath .. "GameIcons\\HotS"
    },
    [BNET_CLIENT_OVERWATCH] = {
        Default = BNet_GetClientTexture(BNET_CLIENT_OVERWATCH),
        Modern = MediaPath .. "GameIcons\\OW"
    },
    [BNET_CLIENT_COD] = {Default = BNet_GetClientTexture(BNET_CLIENT_COD), Modern = MediaPath .. "GameIcons\\COD"},
    [BNET_CLIENT_COD_BOCW] = {
        Default = BNet_GetClientTexture(BNET_CLIENT_COD_BOCW),
        Modern = MediaPath .. "GameIcons\\COD_CW"
    },
    [BNET_CLIENT_COD_MW] = {
        Default = BNet_GetClientTexture(BNET_CLIENT_COD_MW),
        Modern = MediaPath .. "GameIcons\\COD_MW"
    },
    [BNET_CLIENT_COD_MW2] = {
        Default = BNet_GetClientTexture(BNET_CLIENT_COD_MW2),
        Modern = MediaPath .. "GameIcons\\COD_MW2"
    },
    [BNET_CLIENT_WC3] = {Default = BNet_GetClientTexture(BNET_CLIENT_WC3), Modern = MediaPath .. "GameIcons\\WC3"},
    [BNET_CLIENT_CLNT] = {
        Default = BNet_GetClientTexture(BNET_CLIENT_CLNT),
        Modern = BNet_GetClientTexture(BNET_CLIENT_CLNT)
    },
    [BNET_CLIENT_CRASH4] = {
        Default = BNet_GetClientTexture(BNET_CLIENT_CRASH4),
        Modern = MediaPath .. "GameIcons\\CRASH4"
    },
    [BNET_CLIENT_ARCADE] = {
        Default = BNet_GetClientTexture(BNET_CLIENT_ARCADE),
        Modern = BNet_GetClientTexture(BNET_CLIENT_ARCADE)
    }
}

local StatusIcons = {
    Default = {
        Online = FRIENDS_TEXTURE_ONLINE,
        Offline = FRIENDS_TEXTURE_OFFLINE,
        DND = FRIENDS_TEXTURE_DND,
        AFK = FRIENDS_TEXTURE_AFK
    },
    Square = {
        Online = MediaPath .. "StatusIcons\\Square\\Online",
        Offline = MediaPath .. "StatusIcons\\Square\\Offline",
        DND = MediaPath .. "StatusIcons\\Square\\DND",
        AFK = MediaPath .. "StatusIcons\\Square\\AFK"
    },
    D3 = {
        Online = MediaPath .. "StatusIcons\\D3\\Online",
        Offline = MediaPath .. "StatusIcons\\D3\\Offline",
        DND = MediaPath .. "StatusIcons\\D3\\DND",
        AFK = MediaPath .. "StatusIcons\\D3\\AFK"
    }
}

local MaxLevel = {
    [BNET_CLIENT_WOW .. "C"] = 60,
    [BNET_CLIENT_WOW .. "C_TBC"] = 70,
    [BNET_CLIENT_WOW] = W.MaxLevelForPlayerExpansion
}

local BNColor = {
    [BNET_CLIENT_CLNT] = {r = 0.509, g = 0.772, b = 1}, -- 未知
    [BNET_CLIENT_APP] = {r = 0.509, g = 0.772, b = 1}, -- 战网
    [BNET_CLIENT_WC3] = {r = 0.796, g = 0.247, b = 0.145}, -- 魔兽争霸重置版 3
    [BNET_CLIENT_SC] = {r = 0.749, g = 0.501, b = 0.878}, -- 星际争霸 1
    [BNET_CLIENT_SC2] = {r = 0.749, g = 0.501, b = 0.878}, -- 星际争霸 2
    [BNET_CLIENT_D3] = {r = 0.768, g = 0.121, b = 0.231}, -- 暗黑破坏神 3
    [BNET_CLIENT_WOW] = {r = 0.866, g = 0.690, b = 0.180}, -- 魔兽世界
    [BNET_CLIENT_WTCG] = {r = 1, g = 0.694, b = 0}, -- 炉石传说
    [BNET_CLIENT_HEROES] = {r = 0, g = 0.8, b = 1}, -- 风暴英雄
    [BNET_CLIENT_OVERWATCH] = {r = 1, g = 1, b = 1}, -- 守望先锋
    [BNET_CLIENT_COD] = {r = 0, g = 0.8, b = 0}, -- 使命召唤
    [BNET_CLIENT_COD_MW] = {r = 0, g = 0.8, b = 0}, -- 使命召唤：现代战争 2
    [BNET_CLIENT_COD_BOCW] = {r = 0, g = 0.8, b = 0}, -- 使命召唤：冷战
    -- 命运 2 因为已经分家了，不会出现了，下面为自定客户端代码
    [BNET_CLIENT_WOW .. "C"] = {r = 0.866, g = 0.690, b = 0.180}, -- 魔兽世界怀旧版
    ["BSAp"] = {r = 0.509, g = 0.772, b = 1} -- 手机战网 App
}

local function GetClassColor(className)
    for class, localizedName in pairs(LOCALIZED_CLASS_NAMES_MALE) do
        if className == localizedName then
            return C_ClassColor_GetClassColor(class)
        end
    end

    -- 德语及法语有分性别的职业名
    if W.Locale == "deDE" or W.Locale == "frFR" then
        for class, localizedName in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
            if className == localizedName then
                return C_ClassColor_GetClassColor(class)
            end
        end
    end
end

function FL:UpdateFriendButton(button)
    if not self.db.enable then
        if cache.name and cache.info then
            F.SetFontWithDB(button.name, cache.name)
            F.SetFontWithDB(button.info, cache.info)
        end
        return
    end

    if button.buttonType == FRIENDS_BUTTON_TYPE_DIVIDER then
        return
    end

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
        if friendAccountInfo then
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

            -- Fetch version if friend playing WoW
            if game == BNET_CLIENT_WOW then
                name = gameAccountInfo.characterName or ""
                level = gameAccountInfo.characterLevel or 0
                faction = gameAccountInfo.factionName or nil
                class = gameAccountInfo.className or ""
                area = gameAccountInfo.areaName or ""

                if gameAccountInfo.wowProjectID == WOW_PROJECT_CLASSIC then
                    game = BNET_CLIENT_WOW .. "C" -- Classic
                    local serverStrings = {strsplit(" - ", gameAccountInfo.richPresence)}
                    server = serverStrings[#serverStrings] or BNET_FRIEND_TOOLTIP_WOW_CLASSIC
                    server = server .. "*"
                elseif gameAccountInfo.wowProjectID == WOW_PROJECT_CLASSIC_TBC then
                    game = BNET_CLIENT_WOW .. "C_TBC" -- TBC
                    local serverStrings = {strsplit(" - ", gameAccountInfo.richPresence)}
                    server =
                        serverStrings[#serverStrings] or
                        BNET_FRIEND_TOOLTIP_WOW_CLASSIC .. " (" .. CINEMATIC_NAME_2 .. ")"
                    server = server .. "*"
                else
                    server = gameAccountInfo.realmDisplayName or ""
                end
            end
        end
    end

    -- 状态图标
    if status then
        button.status:SetTexture(StatusIcons[self.db.textures.status][status])
    end

    if game and game ~= "" then
        local buttonTitle, buttonText

        -- 名字
        local realIDString =
            realID and self.db.useGameColor and BNColor[game] and F.CreateColorString(realID, BNColor[game]) or realID

        local nameString = name
        local classColor = GetClassColor(class)
        if self.db.useClassColor and classColor then
            nameString = F.CreateColorString(name, classColor)
        end

        if self.db.level then
            if level and level ~= 0 and MaxLevel[game] and (level ~= MaxLevel[game] or not self.db.hideMaxLevel) then
                nameString = nameString .. F.CreateColorString(": " .. level, GetQuestDifficultyColor(level))
            end
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
                buttonText = F.CreateColorString(area .. " - " .. server, self.db.areaColor)
            else
                buttonText = F.CreateColorString(area, self.db.areaColor)
            end

            button.info:SetText(buttonText)
        end

        -- 游戏图标
        local iconGroup = self.db.textures.factionIcon and faction or game
        local iconTex = GameIcons[iconGroup][self.db.textures.game] or BNet_GetClientTexture(game)
        button.gameIcon:SetTexture(iconTex)
        button.gameIcon:Show() -- 普通角色好友暴雪隐藏了
        button.gameIcon:SetAlpha(1)

        if button.summonButton:IsShown() then
            button.gameIcon:Hide()
        else
            button.gameIcon:Show()
            button.gameIcon:Point("TOPRIGHT", -21, -2)
        end
    end

    -- 字体风格
    if not cache.name then
        local name, size, style = button.name:GetFont()
        cache.name = {
            name = name,
            size = size,
            style = style
        }
    end

    if not cache.info then
        local name, size, style = button.info:GetFont()
        cache.info = {
            name = name,
            size = size,
            style = style
        }
    end

    F.SetFontOutline(button.name)
    F.SetFontWithDB(button.name, self.db.nameFont)

    F.SetFontOutline(button.info)
    F.SetFontWithDB(button.info, self.db.infoFont)

    if button.Favorite:IsShown() then
        button.Favorite:ClearAllPoints()
        button.Favorite:Point("LEFT", button.name, "LEFT", button.name:GetStringWidth(), 0)
    end
end

function FL:Initialize()
    if not E.db.WT.social.friendList.enable then
        return
    end

    self.db = E.db.WT.social.friendList

    self:SecureHook("FriendsFrame_UpdateFriendButton", "UpdateFriendButton")
    self.initialized = true
end

function FL:ProfileUpdate()
    self.db = E.db.WT.social.friendList

    if self.db and self.db.enable and not self.initialized then
        self:SecureHook("FriendsFrame_UpdateFriendButton", "UpdateFriendButton")
    end

    FriendsFrame_Update()
end

W:RegisterModule(FL:GetName())
