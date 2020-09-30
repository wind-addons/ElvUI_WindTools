local W, F, E, L = unpack(select(2, ...))
local CM = W:NewModule("ContextMenu", "AceHook-3.0")

local _G = _G
local format = format
local gsub = gsub
local max = max
local pairs = pairs
local select = select
local strbyte = strbyte
local strlower = strlower
local strsub = strsub
local tonumber = tonumber
local unpack = unpack
local wipe = wipe

local AbbreviateNumbers = AbbreviateNumbers
local CanGuildInvite = CanGuildInvite
local CloseDropDownMenus = CloseDropDownMenus
local CreateFrame = CreateFrame
local GetAverageItemLevel = GetAverageItemLevel
local GetCombatRatingBonus = GetCombatRatingBonus
local GetCritChance = GetCritChance
local GetHaste = GetHaste
local GetMasteryEffect = GetMasteryEffect
local GetRangedCritChance = GetRangedCritChance
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetSpellCritChance = GetSpellCritChance
local GetVersatilityBonus = GetVersatilityBonus
local GuildInvite = GuildInvite
local SendChatMessage = SendChatMessage
local UnitClass = UnitClass
local UnitHealthMax = UnitHealthMax
local UnitPlayerControlled = UnitPlayerControlled

local C_Club_GetGuildClubId = C_Club.GetGuildClubId
local C_FriendList_AddFriend = C_FriendList.AddFriend
local C_FriendList_SendWho = C_FriendList.SendWho

local CR_VERSATILITY_DAMAGE_DONE = CR_VERSATILITY_DAMAGE_DONE
local HP = HP
local ITEM_LEVEL_ABBR = ITEM_LEVEL_ABBR
local STAT_CRITICAL_STRIKE = STAT_CRITICAL_STRIKE
local STAT_HASTE = STAT_HASTE
local STAT_MASTERY = STAT_MASTERY
local STAT_VERSATILITY = STAT_VERSATILITY
local TEXT_MODE_A_STRING_RESULT_CRITICAL = TEXT_MODE_A_STRING_RESULT_CRITICAL
local UIDROPDOWNMENU_MAXBUTTONS = UIDROPDOWNMENU_MAXBUTTONS

local PredefinedType = {
    GUILD_INVITE = {
        name = L["Guild Invite"],
        supportTypes = {
            PARTY = true,
            PLAYER = true,
            RAID_PLAYER = true,
            RAID = true,
            FRIEND = true,
            CHAT_ROSTER = true,
            TARGET = true,
            FOCUS = true,
            COMMUNITIES_WOW_MEMBER = true,
            RAF_RECRUIT = true
        },
        func = function(frame)
            if frame.chatTarget then
                GuildInvite(frame.chatTarget)
            elseif frame.name then
                local playerName = frame.name
                if frame.server and frame.server ~= E.myrealm then
                    playerName = playerName .. "-" .. frame.server
                end
                GuildInvite(playerName)
            else
                F.DebugMessage(CM, L["Cannot get the name."])
            end
        end,
        isHidden = function(frame)
            -- 无邀请权限时不显示
            if not CanGuildInvite() then
                return true
            end

            -- 公会频道不需要这个功能
            if frame.communityClubID then
                if tonumber(frame.communityClubID) == tonumber(C_Club_GetGuildClubId()) then
                    return true
                end
            end

            -- 目标为 NPC 时不显示
            if frame.unit and frame.unit == "target" then
                if not UnitPlayerControlled("target") then
                    return true
                end
            end

            -- 焦点为 NPC 时不显示
            if frame.unit and frame.unit == "focus" then
                if not UnitPlayerControlled("focus") then
                    return true
                end
            end

            -- 忽略自己
            if frame.name == E.myname then
                if not frame.server or frame.server == E.myrealm then
                    return true
                end
            end

            return false
        end
    },
    ARMORY = {
        name = L["Armory"],
        supportTypes = {
            SELF = true,
            PARTY = true,
            PLAYER = true,
            RAID_PLAYER = true,
            RAID = true,
            FRIEND = true,
            GUILD = true,
            GUILD_OFFLINE = true,
            CHAT_ROSTER = true,
            TARGET = true,
            ARENAENEMY = true,
            FOCUS = true,
            WORLD_STATE_SCORE = true,
            COMMUNITIES_WOW_MEMBER = true,
            COMMUNITIES_GUILD_MEMBER = true,
            RAF_RECRUIT = true
        },
        func = function(frame)
            local name = frame.name
            local server = frame.server or E.myrealm

            if name and server then
                local link = CM:GetArmoryBaseURL() .. server .. "/" .. name
                E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, link)
            else
                F.DebugMessage(CM, L["Cannot get the armory link."])
            end
        end,
        isHidden = function(frame)
            -- 目标为 NPC 时不显示
            if frame.unit and frame.unit == "target" then
                if not UnitPlayerControlled("target") then
                    return true
                end
            end

            -- 焦点为 NPC 时不显示
            if frame.unit and frame.unit == "focus" then
                if not UnitPlayerControlled("focus") then
                    return true
                end
            end

            return false
        end
    },
    WHO = {
        name = _G.WHO,
        supportTypes = {
            PARTY = true,
            PLAYER = true,
            RAID_PLAYER = true,
            RAID = true,
            FRIEND = true,
            GUILD = true,
            GUILD_OFFLINE = true,
            CHAT_ROSTER = true,
            TARGET = true,
            ARENAENEMY = true,
            FOCUS = true,
            WORLD_STATE_SCORE = true,
            COMMUNITIES_WOW_MEMBER = true,
            COMMUNITIES_GUILD_MEMBER = true,
            RAF_RECRUIT = true
        },
        func = function(frame)
            if frame.chatTarget then
                C_FriendList_SendWho(frame.chatTarget)
            elseif frame.name then
                local playerName = frame.name
                if frame.server and frame.server ~= E.myrealm then
                    playerName = playerName .. "-" .. frame.server
                end
                C_FriendList_SendWho(playerName)
            else
                F.DebugMessage(CM, L["Cannot get the name."])
            end
        end,
        isHidden = function(frame)
            -- 目标为 NPC 时不显示
            if frame.unit and frame.unit == "target" then
                if not UnitPlayerControlled("target") then
                    return true
                end
            end

            -- 焦点为 NPC 时不显示
            if frame.unit and frame.unit == "focus" then
                if not UnitPlayerControlled("focus") then
                    return true
                end
            end

            -- 忽略自己
            if frame.name == E.myname then
                if not frame.server or frame.server == E.myrealm then
                    return true
                end
            end

            return false
        end
    },
    ADDFRIEND = {
        name = _G.ADD_FRIEND,
        supportTypes = {
            PARTY = true,
            PLAYER = true,
            RAID_PLAYER = true,
            RAID = true,
            FRIEND = true,
            GUILD = true,
            GUILD_OFFLINE = true,
            CHAT_ROSTER = true,
            TARGET = true,
            FOCUS = true,
            WORLD_STATE_SCORE = true,
            COMMUNITIES_WOW_MEMBER = true,
            COMMUNITIES_GUILD_MEMBER = true,
            RAF_RECRUIT = true
        },
        func = function(frame)
            if frame.chatTarget then
                C_FriendList_AddFriend(frame.chatTarget)
            elseif frame.name then
                local playerName = frame.name
                if frame.server and frame.server ~= E.myrealm then
                    playerName = playerName .. "-" .. frame.server
                end
                C_FriendList_AddFriend(playerName)
            else
                F.DebugMessage(CM, L["Cannot get the name."])
            end
        end,
        isHidden = function(frame)
            -- 目标为 NPC 时不显示
            if frame.unit and frame.unit == "target" then
                if not UnitPlayerControlled("target") then
                    return true
                end
            end

            -- 焦点为 NPC 时不显示
            if frame.unit and frame.unit == "focus" then
                if not UnitPlayerControlled("focus") then
                    return true
                end
            end

            -- 忽略自己
            if frame.name == E.myname then
                if not frame.server or frame.server == E.myrealm then
                    return true
                end
            end

            return false
        end
    },
    REPORT_STATS = {
        name = L["Report Stats"],
        supportTypes = {
            PARTY = true,
            PLAYER = true,
            RAID_PLAYER = true,
            FRIEND = true,
            BN_FRIEND = true,
            GUILD = true,
            CHAT_ROSTER = true,
            TARGET = true,
            FOCUS = true,
            COMMUNITIES_WOW_MEMBER = true,
            COMMUNITIES_GUILD_MEMBER = true,
            RAF_RECRUIT = true
        },
        func = function(frame)
            local name

            if frame.chatTarget then
                name = frame.chatTarget
            elseif frame.name then
                if frame.server and frame.server ~= E.myrealm then
                    name = frame.name .. "-" .. frame.server
                end
            end

            if not name then
                F.DebugMessage(CM, L["Cannot get the name."])
            end

            local CRITICAL = gsub(TEXT_MODE_A_STRING_RESULT_CRITICAL or STAT_CRITICAL_STRIKE, "[()]", "")

            SendChatMessage(
                format(
                    "(%s) %s: %.1f %s: %s",
                    select(2, GetSpecializationInfo(GetSpecialization())) .. select(1, UnitClass("player")),
                    ITEM_LEVEL_ABBR,
                    select(2, GetAverageItemLevel()),
                    HP,
                    AbbreviateNumbers(UnitHealthMax("player"))
                ),
                "WHISPER",
                nil,
                name
            )
            -- 致命
            SendChatMessage(
                format(" - %s: %.2f%%", CRITICAL, max(GetRangedCritChance(), GetCritChance(), GetSpellCritChance(2))),
                "WHISPER",
                nil,
                name
            )
            -- 加速
            SendChatMessage(format(" - %s: %.2f%%", STAT_HASTE, GetHaste()), "WHISPER", nil, name)
            -- 精通
            SendChatMessage(format(" - %s: %.2f%%", STAT_MASTERY, GetMasteryEffect()), "WHISPER", nil, name)

            -- 臨機應變
            SendChatMessage(
                format(
                    " - %s: %.2f%%",
                    STAT_VERSATILITY,
                    GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
                ),
                "WHISPER",
                nil,
                name
            )
            -- 汲取
            --SendChatMessage(format(" - %s:%.2f%%", STAT_LIFESTEAL, GetLifesteal()), "WHISPER", nil, name)
        end,
        isHidden = function(frame)
            -- 目标为 NPC 时不显示
            if frame.unit and frame.unit == "target" then
                if not UnitPlayerControlled("target") then
                    return true
                end
            end

            -- 焦点为 NPC 时不显示
            if frame.unit and frame.unit == "focus" then
                if not UnitPlayerControlled("focus") then
                    return true
                end
            end

            -- 忽略自己
            if frame.name == E.myname then
                if not frame.server or frame.server == E.myrealm then
                    return true
                end
            end

            return false
        end
    }
}

local function ContextMenu_OnShow(menu)
    local parent = menu:GetParent() or menu
    local width = parent:GetWidth()
    local height = 16
    for i = 1, #menu.buttons do
        local button = menu.buttons[i]
        if button:IsShown() then
            button:SetWidth(width - 32)
            height = height + 16
        end
    end
    menu:SetHeight(height)
    return height
end

local function ContextMenuButton_OnEnter(button)
    _G[button:GetName() .. "Highlight"]:Show()
end

local function ContextMenuButton_OnLeave(button)
    _G[button:GetName() .. "Highlight"]:Hide()
end

function CM:GetArmoryBaseURL()
    local host = "https://worldofwarcraft.com/"

    local language = strlower(W.Locale)
    local languageURL = format("%s-%s/", strsub(language, 1, 2), strsub(language, 3, 4))
    host = host .. languageURL .. "character/"

    local serverLocation = "us"

    if W.Locale ~= "enUS" then
        if W.Locale == "zhTW" or W.Locale == "zhTW" then
            serverLocation = "tw"
        elseif W.Locale == "koKR" then
            serverLocation = "kr"
        else
            serverLocation = "eu"
        end
    end

    if self.db and self.db.armoryOverride[E.myrealm] then
        serverLocation = self.db.armoryOverride[E.myrealm]
    end

    host = host .. serverLocation .. "/"

    return host
end

function CM:SkinDropDownList(frame)
    local Backdrop = _G[frame:GetName() .. "Backdrop"]
    local menuBackdrop = _G[frame:GetName() .. "MenuBackdrop"]

    if Backdrop then
        Backdrop:Kill()
    end

    if menuBackdrop then
        menuBackdrop:Kill()
    end
end

function CM:SkinButton(button)
    local r, g, b = unpack(E.media.rgbvaluecolor)

    local highlight = _G[button:GetName() .. "Highlight"]
    highlight:SetTexture(E.Media.Textures.Highlight)
    highlight:SetBlendMode("BLEND")
    highlight:SetDrawLayer("BACKGROUND")
    highlight:SetVertexColor(r, g, b)

    button:SetScript("OnEnter", ContextMenuButton_OnEnter)
    button:SetScript("OnLeave", ContextMenuButton_OnLeave)

    _G[button:GetName() .. "Check"]:SetAlpha(0)
    _G[button:GetName() .. "UnCheck"]:SetAlpha(0)
    _G[button:GetName() .. "Icon"]:SetAlpha(0)
    _G[button:GetName() .. "ColorSwatch"]:SetAlpha(0)
    _G[button:GetName() .. "ExpandArrow"]:SetAlpha(0)
    _G[button:GetName() .. "InvisibleButton"]:SetAlpha(0)
end

function CM:CreateMenu()
    if self.menu then
        return
    end

    local frame = CreateFrame("Button", "WTContextMenu", E.UIParent, "UIDropDownListTemplate")
    self:SkinDropDownList(frame)
    frame:Hide()

    frame:SetScript("OnShow", ContextMenu_OnShow)
    frame:SetScript("OnHide", nil)
    frame:SetScript("OnClick", nil)
    frame:SetScript("OnUpdate", nil)

    frame.buttons = {}

    for i = 1, UIDROPDOWNMENU_MAXBUTTONS do
        local button = _G["WTContextMenuButton" .. i]
        if not button then
            button = CreateFrame("Button", "WTContextMenuButton" .. i, frame, "UIDropDownMenuButtonTemplate")
        end

        local text = _G[button:GetName() .. "NormalText"]
        text:ClearAllPoints()
        text:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
        text:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
        button.Text = text

        button:SetScript("OnEnable", nil)
        button:SetScript("OnDisable", nil)
        button:SetScript("OnClick", nil)

        self:SkinButton(button)
        button:Hide()

        frame.buttons[i] = button
    end

    self.menu = frame
end

function CM:UpdateButton(index, config, closeAfterFunction)
    local button = self.menu.buttons[index]
    if not button then
        return
    end

    button.Text:SetText(config.name)
    button.Text:Show()

    button.supportTypes = config.supportTypes
    button.isHidden = config.isHidden

    button:SetScript(
        "OnClick",
        function()
            config.func(self.cache)
            if closeAfterFunction then
                CloseDropDownMenus()
            end
        end
    )
end

function CM:UpdateMenu()
    if not self.db then
        return
    end

    local buttonIndex = 1

    if self.db.addFriend then
        self:UpdateButton(buttonIndex, PredefinedType.ADDFRIEND, true)
        buttonIndex = buttonIndex + 1
    end

    if self.db.guildInvite then
        self:UpdateButton(buttonIndex, PredefinedType.GUILD_INVITE, true)
        buttonIndex = buttonIndex + 1
    end

    if self.db.armory then
        self:UpdateButton(buttonIndex, PredefinedType.ARMORY, true)
        buttonIndex = buttonIndex + 1
    end

    if self.db.reportStats then
        self:UpdateButton(buttonIndex, PredefinedType.REPORT_STATS, true)
        buttonIndex = buttonIndex + 1
    end

    if self.db.who then
        self:UpdateButton(buttonIndex, PredefinedType.WHO, true)
        buttonIndex = buttonIndex + 1
    end

    for i, button in pairs(self.menu.buttons) do
        if i >= buttonIndex then
            button:SetScript("OnClick", nil)
            button.Text:Hide()
            button.supportTypes = nil
        end
    end
end

function CM:DisplayButtons()
    -- 自动隐藏不符合条件的按钮
    local buttonOrder = 0
    for _, button in pairs(self.menu.buttons) do
        if button.supportTypes and button.supportTypes[self.cache.which] then
            if not button.isHidden(self.cache) then
                buttonOrder = buttonOrder + 1
                button:Show()
                button:ClearAllPoints()
                button:Point("TOPLEFT", self.menu, "TOPLEFT", 16, -16 * buttonOrder)
            else
                button:Hide()
            end
        else
            button:Hide()
        end
    end

    return buttonOrder > 0
end

function CM:ShowMenu(frame)
    local dropdown = frame.dropdown
    if not dropdown or not self.db.enable then
        return
    end

    -- 预组队伍右键
    -- dropdown.Button == _G.LFGListFrameDropDownButton

    wipe(self.cache)
    self.cache = {
        which = dropdown.which,
        name = dropdown.name,
        unit = dropdown.unit,
        server = dropdown.server,
        chatTarget = dropdown.chatTarget,
        communityClubID = dropdown.communityClubID
    }

    if self.cache.which then
        if self:DisplayButtons() then
            self.menu:SetParent(frame)
            self.menu:SetFrameStrata(frame:GetFrameStrata())
            self.menu:SetFrameLevel(frame:GetFrameLevel() + 2)

            local menuHeight = ContextMenu_OnShow(self.menu)
            frame:SetHeight(frame:GetHeight() + menuHeight)

            self.menu:ClearAllPoints()
            self.menu:Point("BOTTOMLEFT", 0, 16)
            self.menu:Point("BOTTOMRIGHT", 0, 16)
            self.menu:Show()
        end
    end
end

function CM:CloseMenu()
    if self.menu then
        self.menu:Hide()
    end
end

function CM:Initialize()
    self.db = E.db.WT.social.contextMenu
    if not self.db.enable or self.Initialized then
        return
    end

    self.cache = {}
    self:CreateMenu()
    self:UpdateMenu()
    self:SecureHookScript(_G.DropDownList1, "OnShow", "ShowMenu")
    self:SecureHookScript(_G.DropDownList1, "OnHide", "CloseMenu")

    self.tempButton = CreateFrame("Button", "WTContextMenuTempButton", E.UIParent, "SecureActionButtonTemplate")
    self.tempButton:SetAttribute("type1", "macro")

    self.Initialized = true
end

function CM:ProfileUpdate()
    self.db = E.db.WT.social.contextMenu
    if self.db and self.db.enable then
        if not self.Initialized then
            self:Initialize()
        else
            self:UpdateMenu()
        end
    end
end

W:RegisterModule(CM:GetName())
