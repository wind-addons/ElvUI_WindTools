local W, F, E, L = unpack(select(2, ...))
local RCM = W:NewModule("RightClickMenu", "AceHook-3.0", "AceEvent-3.0")
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

local function CustomButtonOnEnter(self) -- UIDropDownMenuTemplates.xml#155
    _G[self:GetName() .. "Highlight"]:Show()
end

local function CustomButtonOnLeave(self) -- UIDropDownMenuTemplates.xml#178
    _G[self:GetName() .. "Highlight"]:Hide()
end

function RCM:CreateMenu()
    if self.menu then
        return
    end

    
    local menu = CreateFrame("Button", "WTRightClickMenuFrame", E.UIParent, "UIDropDownListTemplate")
    -- _G[menu:GetName() .. "Backdrop"]:Hide()
    menu:Point("CENTER", 0, 0)
    menu.buttons = {}
    for i = 1, UIDROPDOWNMENU_MAXBUTTONS do
        local b = CreateFrame("Button", "WTRightClickMenuFrameButton" .. i, menu, "UIDropDownMenuButtonTemplate")
        local text = _G[b:GetName().."NormalText"]
        text:Point("TOPLEFT", b, "TOPLEFT", 0, 0)
        text:Point("BOTTOMRIGHT", b, "BOTTOMRIGHT", 0, 0)
        text:Show()
        menu.buttons[i] = b
    end

    self.menu = menu
end

function RCM:ShowMenu(frame)
    -- local dropdown = frame.dropdown
    -- if not dropdown or not dropdown.which or not supportedTypes[dropdown.which] then
    --     return
    -- end

    local button1 = self.menu.buttons[1]
    local text = _G[button1:GetName() .. "NormalText"]
    text:SetText("Button #1")
    text:Show()
    button1:SetScript("OnClick", function() print("button1") end)
    button1:Size(60,20)
    button1:Show()

    self.menu:Size(button1:GetSize())
    -- self.menu:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
    -- self.menu:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    self.menu:Show()
end

function RCM:CloseMenu()
    if self.menu then
        self.menu:Hide()
    end
end

function RCM:Initialize()
end

function RCM:ProfileUpdate()
end

W:RegisterModule(RCM:GetName())
