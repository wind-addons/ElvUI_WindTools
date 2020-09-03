local W, F, E, L = unpack(select(2, ...))
local RCM = W:NewModule("RightClickMenu", "AceHook-3.0")

local fasfasfasf = {
    SELF = true,
    PARTY = true,
    PLAYER = true,
    RAID_PLAYER = true,
    RAID = true,
    FRIEND = true,
    BN_FRIEND = true,
    GUILD = true,
    GUILD_OFFLINE = true,
    CHAT_ROSTER = true,
    TARGET = true,
    ARENAENEMY = true,
    FOCUS = true,
    WORLD_STATE_SCORE = true,
    COMMUNITIES_WOW_MEMBER = true,
    COMMUNITIES_GUILD_MEMBER = true
}

local function URLEncode(str)
    str =
        gsub(
        str,
        "([^%w%.%- ])",
        function(c)
            return format("%%%02X", strbyte(c))
        end
    )
    return gsub(str, " ", "+")
end

local function GetArmoryBaseURL()
    local host = "https://worldofwarcraft.com/en-us/character/us/"

    if E:GetLocale() == "zhTW" then
        host = "https://worldofwarcraft.com/zh-tw/character/tw/"
    end

    return host
end

local PredefinedType = {
    GUILD_INVITE = {
        name = L["Guild Invite"],
        supportTypes = {
            PARTY = true,
            PLAYER = true,
            RAID_PLAYER = true,
            RAID = true,
            FRIEND = true,
            BN_FRIEND = true,
            CHAT_ROSTER = true,
            TARGET = true,
            FOCUS = true,
            COMMUNITIES_WOW_MEMBER = true,
            RAF_RECRUIT = true
        },
        func = function(frame)
            local playerName = frame.chatTarget or frame.name
            print(playerName)
        end,
        isHidden = function(frame)
            if frame.which == "TARGET" then
                local playerName = frame.name
                if not UnitPlayerControlled("target") then
                    return true
                end
            elseif frame.which == "FOCUS" then
                local playerName = frame.name
                if not UnitPlayerControlled("focus") then
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
            BN_FRIEND = true,
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
                local link = GetArmoryBaseURL() .. URLEncode(server) .. "/" .. URLEncode(name)
                E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, link)
            else
                print(L["Cannot get the armory link."])
            end
        end,
        isHidden = function(frame)
            if frame.which == "TARGET" then
                local playerName = frame.name
                if not UnitPlayerControlled("target") then
                    return true
                end
            elseif frame.which == "FOCUS" then
                local playerName = frame.name
                if not UnitPlayerControlled("focus") then
                    return true
                end
            end
            return false
        end
    }
}

local function RightClickMenu_OnShow(menu)
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

local function RightClickMenuButton_OnEnter(button)
    _G[button:GetName() .. "Highlight"]:Show()
end

local function RightClickMenuButton_OnLeave(button)
    _G[button:GetName() .. "Highlight"]:Hide()
end

function RCM:SkinDropDownList(frame)
    local Backdrop = _G[frame:GetName() .. "Backdrop"]
    local menuBackdrop = _G[frame:GetName() .. "MenuBackdrop"]

    if Backdrop then
        Backdrop:Kill()
    end

    if menuBackdrop then
        menuBackdrop:Kill()
    end
end

function RCM:SkinButton(button)
    local r, g, b = unpack(E.media.rgbvaluecolor)

    local highlight = _G[button:GetName() .. "Highlight"]
    highlight:SetTexture(E.Media.Textures.Highlight)
    highlight:SetBlendMode("BLEND")
    highlight:SetDrawLayer("BACKGROUND")
    highlight:SetVertexColor(r, g, b)

    button:SetScript("OnEnter", RightClickMenuButton_OnEnter)
    button:SetScript("OnLeave", RightClickMenuButton_OnLeave)

    _G[button:GetName() .. "Check"]:SetAlpha(0)
    _G[button:GetName() .. "UnCheck"]:SetAlpha(0)
    _G[button:GetName() .. "Icon"]:SetAlpha(0)
    _G[button:GetName() .. "ColorSwatch"]:SetAlpha(0)
    _G[button:GetName() .. "ExpandArrow"]:SetAlpha(0)
    _G[button:GetName() .. "InvisibleButton"]:SetAlpha(0)
end

function RCM:CreateMenu()
    if self.menu then
        return
    end

    local frame = CreateFrame("Button", "WTRightClickDropDownList", E.UIParent, "UIDropDownListTemplate")
    self:SkinDropDownList(frame)
    frame:Hide()

    frame:SetScript("OnShow", RightClickMenu_OnShow)
    frame:SetScript("OnHide", nil)
    frame:SetScript("OnClick", nil)
    frame:SetScript("OnUpdate", nil)

    frame.buttons = {}

    for i = 1, UIDROPDOWNMENU_MAXBUTTONS do
        local button = _G["WTRightClickDropDownListButton" .. i]
        if not button then
            button = CreateFrame("Button", "WTRightClickDropDownListButton" .. i, frame, "UIDropDownMenuButtonTemplate")
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

function RCM:UpdateButton(index, config, closeAfterFunction)
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
            config.func(_G.DropDownList1.dropdown)
            if closeAfterFunction then
                CloseDropDownMenus()
            end
        end
    )
end

function RCM:UpdateMenu()
    if not self.db then
        return
    end

    if self.db.guildInvite then
        self:UpdateButton(1, PredefinedType.GUILD_INVITE, true)
    end

    if self.db.armory then
        self:UpdateButton(2, PredefinedType.ARMORY, true)
    end

    -- btn:SetAttribute("type1", "macro");
    -- btn:SetAttribute("macrotext1", "/cast Frost Bolt");

    for i, button in pairs(self.menu.buttons) do
        if i >= 3 then
            button.supportTypes = nil
        end
    end
end

-- 自动隐藏不符合条件的按钮
function RCM:DisplayButtons(which)
    local buttonOrder = 1
    for i, button in pairs(self.menu.buttons) do
        if button.supportTypes and button.supportTypes[which] then
            if not button.isHidden(_G.DropDownList1.dropdown) then
                button:Show()
                button:ClearAllPoints()
                button:Point("TOPLEFT", self.menu, "TOPLEFT", 16, -16 * buttonOrder)
                buttonOrder = buttonOrder + 1
            end
        else
            button:Hide()
        end
    end

    return (buttonOrder ~= 1)
end

function RCM:ShowMenu(frame)
    local dropdown = frame.dropdown
    if not dropdown or not self.db.enable then
        return
    end

    -- 预组队伍右键
    -- dropdown.Button == _G.LFGListFrameDropDownButton

    if dropdown.which then
        if self:DisplayButtons(dropdown.which) then
            self.menu:SetParent(frame)
            self.menu:SetFrameStrata(frame:GetFrameStrata())
            self.menu:SetFrameLevel(frame:GetFrameLevel() + 2)

            local dropDownListHeight = frame:GetHeight()
            local menuHeight = RightClickMenu_OnShow(self.menu)

            frame:SetHeight(dropDownListHeight + menuHeight)

            self.menu:ClearAllPoints()
            self.menu:Point("BOTTOMLEFT", 0, 16)
            self.menu:Point("BOTTOMRIGHT", 0, 16)
            self.menu:Show()
        end
    end
end

function RCM:CloseMenu()
    if self.db.enable and self.menu then
        self.menu:Hide()
    end
end

function RCM:Initialize()
    self.db = E.db.WT.social.rightClickMenu
    if not self.db.enable or self.initialized then
        return
    end

    self:CreateMenu()
    self:UpdateMenu()
    self:SecureHookScript(_G.DropDownList1, "OnShow", "ShowMenu")
    self:SecureHookScript(_G.DropDownList1, "OnHide", "CloseMenu")

    self.initialized = true
end

function RCM:ProfileUpdate()
    self.db = E.db.WT.social.rightClickMenu
    if self.db.enable then
        if not self.initialized then
            self:Initialize()
        else
            self:UpdateMenu()
        end
    end
end

W:RegisterModule(RCM:GetName())
