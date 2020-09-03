local W, F, E, L = unpack(select(2, ...))
local RCM = W:NewModule("RightClickMenu", "AceHook-3.0")
local ES = E:GetModule("Skins")
local WS = W:GetModule("Skins")

local supportedTypes = {
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

local function RightClickMenu_OnShow(menu)
    local parent = menu:GetParent() or menu
    local width = parent:GetWidth()
    local height = 32
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

function RCM:UpdateButton(index, name, onClick, closeAfterFunction)
    local button = self.menu.buttons[index]
    if not button then
        return
    end

    button.Text:SetText(name)
    button.Text:Show()

    button:SetScript(
        "OnClick",
        function()
            onClick()
            if closeAfterFunction then
                CloseDropDownMenus()
            end
        end
    )

    button:Show()
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
            break
        end

        local text = _G[button:GetName() .. "NormalText"]
        text:ClearAllPoints()
        text:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
        text:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
        button.Text = text

        button:SetScript("OnEnable", nil)
        button:SetScript("OnDisable", nil)
        button:SetScript("OnClick", nil)

        button:Point("TOPLEFT", frame, "TOPLEFT", 16, -16 * i)
        self:SkinButton(button)
        button:Hide()
        frame.buttons[i] = button
    end

    self.menu = frame

    self:UpdateButton(
        1,
        "Test",
        function()
            print(2)
        end,
        false
    )
end

function RCM:ShowMenu(frame)
    local dropdown = frame.dropdown
    if not dropdown then
        return
    end

    -- 预组队伍右键
    -- dropdown.Button == _G.LFGListFrameDropDownButton

    if dropdown.which and supportedTypes[dropdown.which] then
        local dropdownFullName
        if dropdown.name then
            if dropdown.server and not dropdown.name:find("-") then
                dropdownFullName = dropdown.name .. "-" .. dropdown.server
            else
                dropdownFullName = dropdown.name
            end
        end
        self.menu:SetParent(frame)
        self.menu:SetFrameStrata(frame:GetFrameStrata())
        self.menu:SetFrameLevel(frame:GetFrameLevel() + 2)

        local dropDownListHeight = frame:GetHeight()
        local menuHeight = self.menu:GetHeight()
        if menuHeight < 1 then
            menuHeight = RightClickMenu_OnShow(self.menu)
        end

        frame:SetHeight(dropDownListHeight + menuHeight - 5)

        self.menu:ClearAllPoints()
        self.menu:Point("BOTTOMLEFT", 0, 0)
        self.menu:Point("BOTTOMRIGHT", 0, 0)
        self.menu:Show()
    end
end

function RCM:CloseMenu()
    if self.menu then
        self.menu:Hide()
    end
end

function RCM:Initialize()
    self:CreateMenu()
    self:SecureHookScript(_G.DropDownList1, "OnShow", "ShowMenu")
    self:SecureHookScript(_G.DropDownList1, "OnHide", "CloseMenu")
end

function RCM:ProfileUpdate()
end

W:RegisterModule(RCM:GetName())
