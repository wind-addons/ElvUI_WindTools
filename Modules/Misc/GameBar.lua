local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local GB = W:NewModule("GameBar", "AceTimer-3.0", "AceHook-3.0")

local date = date
local tonumber = tonumber
local format = format
local CreateFrame = CreateFrame

local ButtonTypes = {
    CHARACTER = {
        name = L["Character"],
        icon = W.Media.Icons.barCharacter,
        func = function()
            print("character")
        end
    },
    SPELLS = {
        name = L["Spells"],
        icon = W.Media.Icons.barSpells,
        func = function()
            print("Spells")
        end
    },
    FRIENDS = {
        name = L["Friends"],
        icon = W.Media.Icons.barFriends,
        func = function()
            print("character")
        end
    },
    GUILD = {
        name = L["Guild"],
        icon = W.Media.Icons.barGuild,
        func = function()
            print("Guild")
        end
    },
    ENCOUNTERJOURNAL = {
        name = L["Encounter Journal"],
        icon = W.Media.Icons.barJournal,
        func = function()
            print("Encounter Journal")
        end
    },
    PETJOURNAL = {
        name = L["Pet Journal"],
        icon = W.Media.Icons.barJournal,
        func = function()
            print("Pet Journal")
        end
    },
    PVE = {
        name = L["PVE"],
        icon = W.Media.Icons.barPVE,
        func = function()
            print("PVE")
        end
    }
}

-------------------------
-- 条
function GB:ConstructBar()
    if self.bar then
        return
    end

    local bar = CreateFrame("Frame", "WTGameBar", E.UIParent)
    bar:Size(800, 60)
    bar:Point("TOP", 0, -20)

    local middlePanel = CreateFrame("Frame", "WTGameBarMiddlePanel", bar)
    middlePanel:Size(81, 50)
    middlePanel:Point("CENTER")
    middlePanel:CreateBackdrop("Transparent")
    bar.middlePanel = middlePanel

    local leftPanel = CreateFrame("Frame", "WTGameBarLeftPanel", bar)
    leftPanel:Size(300, 40)
    leftPanel:Point("RIGHT", middlePanel, "LEFT", -10, 0)
    leftPanel:CreateBackdrop("Transparent")
    bar.leftPanel = leftPanel

    local rightPanel = CreateFrame("Frame", "WTGameBarRightPanel", bar)
    rightPanel:Size(300, 40)
    rightPanel:Point("LEFT", middlePanel, "RIGHT", 10, 0)
    rightPanel:CreateBackdrop("Transparent")
    bar.rightPanel = rightPanel

    if E.private.WT.skins.enable and E.private.WT.skins.windtools then
        S:CreateShadow(leftPanel.backdrop)
        S:CreateShadow(middlePanel.backdrop)
        S:CreateShadow(rightPanel.backdrop)
    end

    self.bar = bar
end

-------------------------
-- 时间
function GB:ConstructTimeArea()
    local normalTime = self.bar.middlePanel:CreateFontString(nil, "OVERLAY")
    normalTime:Point("CENTER")
    F.SetFontWithDB(normalTime, self.db.time.font)
    self.bar.middlePanel.normalTime = normalTime

    local flashTime = self.bar.middlePanel:CreateFontString(nil, "OVERLAY")
    flashTime:Point("CENTER")
    F.SetFontWithDB(flashTime, self.db.time.font)
    self.bar.middlePanel.flashTime = flashTime

    self:UpdateTimeFormat()
    self:ScheduleTimer("SetUpTimeAreaTimer", 60 - tonumber(date("%S")))
end

function GB:SetUpTimeAreaTimer()
    self:UpdateTime()
    self.timeAreaUpdateTimer = self:ScheduleRepeatingTimer("UpdateTime", 60)
end

function GB:UpdateTimeFormat()
    local normalColor = {r = 1, g = 1, b = 1}
    local hoverColor = {r = 1, g = 1, b = 1}

    if self.db.normalColor == "CUSTOM" then
        normalColor = self.db.customNormalColor
    elseif self.db.normalColor == "CLASS" then
        normalColor = E:ClassColor(E.myclass, true)
    elseif self.db.normalColor == "VALUE" then
        normalColor = {
            r = E.media.rgbvaluecolor[1],
            g = E.media.rgbvaluecolor[2],
            b = E.media.rgbvaluecolor[3]
        }
    end

    if self.db.hoverColor == "CUSTOM" then
        hoverColor = self.db.customHoverColor
    elseif self.db.hoverColor == "CLASS" then
        hoverColor = E:ClassColor(E.myclass, true)
    elseif self.db.hoverColor == "VALUE" then
        hoverColor = {
            r = E.media.rgbvaluecolor[1],
            g = E.media.rgbvaluecolor[2],
            b = E.media.rgbvaluecolor[3]
        }
    end

    local normalTimeFormat = F.CreateColorString("%s %s", normalColor)
    local flashTimeFormat =
        F.CreateColorString("%s", normalColor) ..
        F.CreateColorString(":", hoverColor) .. F.CreateColorString("%s", normalColor)

    self.bar.middlePanel.normalTime.format = normalTimeFormat
    self.bar.middlePanel.flashTime.format = flashTimeFormat
end

function GB:UpdateTime()
    local panel = self.bar.middlePanel
    local hour, min = date("%H"), date("%M")

    if self.db.time.twentyFour then
        hour = date("%I")
    end

    panel.normalTime:SetText(format(panel.normalTime.format, hour, min))
    panel.flashTime:SetText(format(panel.flashTime.format, hour, min))
end

function GB:UpdateTimeArea()
    local panel = self.bar.middlePanel

    F.SetFontWithDB(panel.normalTime, self.db.time.font)
    F.SetFontWithDB(panel.flashTime, self.db.time.font)

    panel.flashTime:SetText("55:55")

    self.bar.middlePanel:SetWidth(panel.flashTime:GetStringWidth() * 1.309)
    self.bar.middlePanel:SetHeight(panel.flashTime:GetStringHeight() * 1.927)

    if self.db.time.flash then
        E:Flash(panel.flashTime, 1, true)
        panel.normalTime:Show()
        panel.flashTime:Show()
    else
        E:StopFlash(panel.flashTime)
        panel.normalTime:Hide()
        panel.flashTime:Show()
    end

    self:UpdateTime()
end

-------------------------
-- 按钮
function GB:ButtonOnEnter(button)
    E:UIFrameFadeIn(button.hoverTex, self.db.fadeTime, button.hoverTex:GetAlpha(), 1)
end

function GB:ButtonOnLeave(button)
    E:UIFrameFadeOut(button.hoverTex, self.db.fadeTime, button.hoverTex:GetAlpha(), 0)
end

function GB:ConstructButton()
    if not self.bar then
        return
    end

    local button = CreateFrame("Button", nil, self.bar, "SecureActionButtonTemplate, BackdropTemplate")
    button:Size(self.db.buttonSize)

    local normalTex = button:CreateTexture(nil, "ARTWORK")
    normalTex:Point("CENTER")
    normalTex:Size(self.db.buttonSize)
    button.normalTex = normalTex

    local hoverTex = button:CreateTexture(nil, "ARTWORK")
    hoverTex:Point("CENTER")
    hoverTex:Size(self.db.buttonSize)
    hoverTex:SetAlpha(0)
    button.hoverTex = hoverTex

    self:HookScript(button, "OnEnter", "ButtonOnEnter")
    self:HookScript(button, "OnLeave", "ButtonOnLeave")

    tinsert(self.buttons, button)
end

function GB:UpdateButton(button, config)
    button:Size(self.db.buttonSize)
    button.name = config.name
    button:SetScript(
        "OnClick",
        function()
            config.func()
        end
    )

    -- 普通状态
    local r, g, b = 1, 1, 1
    if self.db.normalColor == "CUSTOM" then
        r = self.db.customNormalColor.r
        g = self.db.customNormalColor.g
        b = self.db.customNormalColor.b
    elseif self.db.normalColor == "CLASS" then
        local classColor = E:ClassColor(E.myclass, true)
        r = classColor.r
        g = classColor.g
        b = classColor.b
    elseif self.db.normalColor == "VALUE" then
        r, g, b = unpack(E.media.rgbvaluecolor)
    end

    button.normalTex:SetTexture(config.icon)
    button.normalTex:Size(self.db.buttonSize)
    button.normalTex:SetVertexColor(r, g, b)

    -- 鼠标滑过状态
    r, g, b = 1, 1, 1
    if self.db.hoverColor == "CUSTOM" then
        r = self.db.customHoverColor.r
        g = self.db.customHoverColor.g
        b = self.db.customHoverColor.b
    elseif self.db.hoverColor == "CLASS" then
        local classColor = E:ClassColor(E.myclass, true)
        r = classColor.r
        g = classColor.g
        b = classColor.b
    elseif self.db.hoverColor == "VALUE" then
        r, g, b = unpack(E.media.rgbvaluecolor)
    end

    button.hoverTex:SetTexture(config.icon)
    button.hoverTex:Size(self.db.buttonSize)
    button.hoverTex:SetVertexColor(r, g, b)
end

function GB:ConstructButtons()
    if self.buttons then
        return
    end

    self.buttons = {}
    for i = 1, 12 do
        self:ConstructButton()
    end
end

function GB:UpdateButtons()
    for i = 1, 6 do
        self:UpdateButton(self.buttons[i], ButtonTypes[self.db.left[i]])
        self:UpdateButton(self.buttons[i + 6], ButtonTypes[self.db.right[i]])
    end
end

-------------------------
-- 排列
function GB:UpdateLayout()
    if self.db.backdrop then
        self.bar.leftPanel.backdrop:Show()
        self.bar.middlePanel.backdrop:Show()
        self.bar.rightPanel.backdrop:Show()
    else
        self.bar.leftPanel.backdrop:Hide()
        self.bar.middlePanel.backdrop:Hide()
        self.bar.rightPanel.backdrop:Hide()
    end

    local numLeftButtons, numRightButtons = 0, 0

    -- 左面板
    local isFirst = true
    local lastButton = nil
    for i = 1, 6 do
        local button = self.buttons[i]
        if button.name ~= "NONE" then
            button:ClearAllPoints()
            if isFirst then
                button:Point("LEFT", self.bar.leftPanel, "LEFT", self.db.backdropSpacing, 0)
                isFirst = false
            else
                button:Point("LEFT", lastButton, "RIGHT", self.db.spacing, 0)
            end
            lastButton = button
            numLeftButtons = numLeftButtons + 1
        end
    end

    local panelWidth =
        self.db.backdropSpacing * 2 + (numLeftButtons - 1) * self.db.spacing + numLeftButtons * self.db.buttonSize
    local panelHeight = self.db.backdropSpacing * 2 + self.db.buttonSize
    self.bar.leftPanel:Size(panelWidth, panelHeight)

    -- 右面板
    isFirst = true
    lastButton = nil
    for i = 1, 6 do
        local button = self.buttons[i + 6]
        if button.name ~= "NONE" then
            button:ClearAllPoints()
            if isFirst then
                button:Point("LEFT", self.bar.rightPanel, "LEFT", self.db.backdropSpacing, 0)
                isFirst = false
            else
                button:Point("LEFT", lastButton, "RIGHT", self.db.spacing, 0)
            end
            lastButton = button
            numRightButtons = numRightButtons + 1
        end
    end

    panelWidth =
        self.db.backdropSpacing * 2 + (numRightButtons - 1) * self.db.spacing + numRightButtons * self.db.buttonSize
    self.bar.rightPanel:Size(panelWidth, panelHeight)
end

function GB:Test()
    self:ConstructBar()
    self:ConstructTimeArea()
    self:ConstructButtons()
    self:UpdateTimeArea()
    self:UpdateButtons()
    self:UpdateLayout()
end

function GB:Initialize()
    self.db = E.db.WT.misc.gameBar
    if not self.db or not self.db.enable then
        return
    end
end

W:RegisterModule(GB:GetName())
