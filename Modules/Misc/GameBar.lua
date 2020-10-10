local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local GB = W:NewModule("GameBar", "AceHook-3.0")

local _G = _G
local date = date
local tonumber = tonumber
local format = format
local CreateFrame = CreateFrame
local ToggleCharacter = ToggleCharacter

local C_Timer_After = C_Timer.After
local C_Timer_NewTicker = C_Timer.NewTicker

local ButtonTypes = {
    NONE = {
        name = L["NONE"]
    },
    ACHIEVEMENT = {
        name = L["Achievement"],
        icon = W.Media.Icons.barAchievement,
        click = {
            LeftButton = _G.ToggleAchievementFrame
        }
    },
    CHARACTER = {
        name = L["Character"],
        icon = W.Media.Icons.barCharacter,
        click = {
            LeftButton = function()
                ToggleCharacter("PaperDollFrame")
            end
        }
    },
    COLLECTIONS = {
        name = L["Collections"],
        icon = W.Media.Icons.barCollections,
        click = {
            LeftButton = _G.ToggleCollectionsJournal
        }
    },
    ENCOUNTERJOURNAL = {
        name = L["Encounter Journal"],
        icon = W.Media.Icons.barEncounterJournal,
        click = {
            LeftButton = function()
                if not IsAddOnLoaded("Blizzard_EncounterJournal") then
                    _G.EncounterJournal_LoadUI()
                end

                ToggleFrame(_G.EncounterJournal)
            end
        }
    },
    FRIENDS = {
        name = L["Friends"],
        icon = W.Media.Icons.barFriends,
        click = {
            LeftButton = function()
                ToggleFriendsFrame(1)
            end
        }
    },
    HOME = {
        name = L["Home"],
        icon = W.Media.Icons.barHome,
        item = {
            item1 = GetItemInfo(6948),
            item2 = GetItemInfo(141605)
        }
    },
    PETJOURNAL = {
        name = L["Pet Journal"],
        icon = W.Media.Icons.barPetJournal,
        click = {
            LeftButton = function()
                ToggleCollectionsJournal(2)
            end
        }
    },
    GUILD = {
        name = L["Guild"],
        icon = W.Media.Icons.barGuild,
        click = {
            LeftButton = _G.ToggleGuildFrame
        }
    },
    PVE = {
        name = L["PVE"],
        icon = W.Media.Icons.barPVE,
        click = {
            LeftButton = _G.ToggleLFDParentFrame
        }
    },
    SCREENSHOT = {
        name = L["ScreenShot"],
        icon = W.Media.Icons.barScreenShot,
        click = {
            LeftButton = _G.Screenshot
        }
    },
    SPELLBOOK = {
        name = L["Spell Book"],
        icon = W.Media.Icons.barSpellBook,
        click = {
            LeftButton = function()
                if not _G.SpellBookFrame:IsShown() then
                    ShowUIPanel(_G.SpellBookFrame)
                else
                    HideUIPanel(_G.SpellBookFrame)
                end
            end
        }
    },
    TALENTS = {
        name = L["Talents"],
        icon = W.Media.Icons.barTalents,
        click = {
            LeftButton = function()
                if not _G.PlayerTalentFrame then
                    _G.TalentFrame_LoadUI()
                end

                local PlayerTalentFrame = _G.PlayerTalentFrame
                if not PlayerTalentFrame:IsShown() then
                    ShowUIPanel(PlayerTalentFrame)
                else
                    HideUIPanel(PlayerTalentFrame)
                end
            end
        }
    }
}

-------------------------
-- 条
function GB:ConstructBar()
    if self.bar then
        return
    end

    local bar = CreateFrame("Frame", "WTGameBar", E.UIParent, "SecureHandlerStateTemplate")
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
    self:UpdateTime()
    C_Timer_After(
        62 - tonumber(date("%S")),
        function()
            GB:SetUpTimeAreaTimer()
        end
    )
end

function GB:SetUpTimeAreaTimer()
    self:UpdateTime()
    self.timeAreaUpdateTimer =
        C_Timer_NewTicker(
        60,
        function()
            GB:UpdateTime()
        end
    )
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
    local flashTimeFormat = F.CreateColorString(":", hoverColor)

    self.bar.middlePanel.normalTime.format = normalTimeFormat
    self.bar.middlePanel.flashTime.format = flashTimeFormat
end

function GB:UpdateTime()
    print(date("%H:%M:%S"))

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
    else
        E:StopFlash(panel.flashTime)
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
    button:RegisterForClicks("AnyUp")

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
    if InCombatLockdown() then
        return
    end

    button:Size(self.db.buttonSize)
    button.name = config.name

    if config.click then
        function button:Click(mouseButton)
            local func = mouseButton and config.click[mouseButton] or config.click.LeftButton
            func()
        end
        button:SetAttribute("type*", "click")
        button:SetAttribute("clickbutton", button)
    elseif config.item then
        button:SetAttribute("type*", "item")
        button:SetAttribute("item1", config.item.item1)
        button:SetAttribute("item2", config.item.item2)
    end

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
        if button.name ~= L["NONE"] then
            button:Show()
            button:ClearAllPoints()
            if isFirst then
                button:Point("LEFT", self.bar.leftPanel, "LEFT", self.db.backdropSpacing, 0)
                isFirst = false
            else
                button:Point("LEFT", lastButton, "RIGHT", self.db.spacing, 0)
            end
            lastButton = button
            numLeftButtons = numLeftButtons + 1
        else
            button:Hide()
        end
    end

    if numLeftButtons == 0 then
        self.bar.leftPanel:Hide()
    else
        self.bar.leftPanel:Show()
        local panelWidth =
            self.db.backdropSpacing * 2 + (numLeftButtons - 1) * self.db.spacing + numLeftButtons * self.db.buttonSize
        local panelHeight = self.db.backdropSpacing * 2 + self.db.buttonSize
        self.bar.leftPanel:Size(panelWidth, panelHeight)
    end

    -- 右面板
    isFirst = true
    lastButton = nil
    for i = 1, 6 do
        local button = self.buttons[i + 6]
        if button.name ~= "NONE" then
            button:Show()
            button:ClearAllPoints()
            if isFirst then
                button:Point("LEFT", self.bar.rightPanel, "LEFT", self.db.backdropSpacing, 0)
                isFirst = false
            else
                button:Point("LEFT", lastButton, "RIGHT", self.db.spacing, 0)
            end
            lastButton = button
            numRightButtons = numRightButtons + 1
        else
            button:Hide()
        end
    end

    if numRightButtons == 0 then
        self.bar.rightPanel:Hide()
    else
        self.bar.rightPanel:Show()
        local panelWidth =
            self.db.backdropSpacing * 2 + (numRightButtons - 1) * self.db.spacing + numRightButtons * self.db.buttonSize
        local panelHeight = self.db.backdropSpacing * 2 + self.db.buttonSize
        self.bar.rightPanel:Size(panelWidth, panelHeight)
    end
end

function GB:Initialize()
    self.db = E.db.WT.misc.gameBar
    if not self.db or not self.db.enable then
        return
    end

    self:ConstructBar()
    self:ConstructTimeArea()
    self:ConstructButtons()
    self:UpdateTimeArea()
    self:UpdateButtons()
    self:UpdateLayout()

    self.Initialized = true
end

function GB:ProfileUpdate()
    self.db = E.db.WT.misc.gameBar
    if not self.db then
        return
    end

    if self.db.enable then
        if self.Initialized then
            self.bar:Show()
            self:UpdateTimeArea()
            self:UpdateButtons()
            self:UpdateLayout()
        else
            self.Initialize()
        end
    else
        if self.Initialized then
            self.bar:Hide()
        end
    end
end

function GB:GetAvailableButtons()
    local buttons = {}

    for buttonKey, buttonData in pairs(ButtonTypes) do
        buttons[buttonKey] = buttonData.name
    end

    return buttons
end

W:RegisterModule(GB:GetName())
