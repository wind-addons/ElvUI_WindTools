local W, F, E, L = unpack(select(2, ...))
local OT = W:NewModule("ObjectiveTracker", "AceHook-3.0", "AceEvent-3.0")
local C = W.Utilities.Color
local S = W.Modules.Skins
local LSM = E.Libs.LSM

local _G = _G
local format = format
local max = max
local pairs = pairs
local strmatch = strmatch
local tonumber = tonumber

local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local ObjectiveTracker_Update = ObjectiveTracker_Update

local C_QuestLog_GetTitleForQuestID = C_QuestLog.GetTitleForQuestID

do
    local replaceRule = {
        [L["Tazavesh: Streets of Wonder"]] = L["[ABBR] Tazavesh: Streets of Wonder"],
        [L["Tazavesh: So'leah's Gambit"]] = L["[ABBR] Tazavesh: So'leah's Gambit"],
        [L["Tazavesh: Streets of Wonder"]] = L["[ABBR] Tazavesh: Streets of Wonder"],
        [L["Torghast, Tower of the Damned"]] = L["[ABBR] Torghast, Tower of the Damned"]
    }

    function OT:ShortTitle(title)
        if not title then
            return
        end

        title =
            F.Strings.Replace(
            title,
            {
                ["，"] = ", ",
                ["。"] = "."
            }
        )

        for longName, shortName in pairs(replaceRule) do
            if longName == title then
                return shortName
            end
        end
        return title
    end
end

local function SetTextColorHook(text)
    if not text.windHooked then
        text.__WindSetTextColor = text.SetTextColor
        text.SetTextColor = function(self, r, g, b, a)
            local rgbTable = {r = r, g = g, b = b, a = a}

            if C.IsRGBEqual(_G.OBJECTIVE_TRACKER_COLOR["Header"], rgbTable) then
                if OT.db and OT.db.enable and OT.db.titleColor and OT.db.titleColor.enable then
                    r = OT.db.titleColor.classColor and W.ClassColor.r or OT.db.titleColor.customColorNormal.r
                    g = OT.db.titleColor.classColor and W.ClassColor.g or OT.db.titleColor.customColorNormal.g
                    b = OT.db.titleColor.classColor and W.ClassColor.b or OT.db.titleColor.customColorNormal.b
                end
            elseif C.IsRGBEqual(_G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"], rgbTable) then
                if OT.db and OT.db.enable and OT.db.titleColor and OT.db.titleColor.enable then
                    r = OT.db.titleColor.classColor and W.ClassColor.r or OT.db.titleColor.customColorHighlight.r
                    g = OT.db.titleColor.classColor and W.ClassColor.g or OT.db.titleColor.customColorHighlight.g
                    b = OT.db.titleColor.classColor and W.ClassColor.b or OT.db.titleColor.customColorHighlight.b
                end
            end
            self:__WindSetTextColor(r, g, b, a)
        end
        text:SetTextColor(C.ExtractColorFromTable(_G.OBJECTIVE_TRACKER_COLOR["Header"], {a = 1}))
        text.windHooked = true
    end
end

function OT:CosmeticBar(header)
    local bar = header.windCosmeticBar

    if not self.db.cosmeticBar.enable then
        if bar then
            bar:Hide()
            bar.backdrop:Hide()
        end
        return
    end

    if not bar then
        bar = header:CreateTexture()
        local backdrop = CreateFrame("Frame", nil, header)
        backdrop:SetFrameStrata("BACKGROUND")
        backdrop:SetTemplate()
        backdrop:SetOutside(bar, 1, 1)
        backdrop.Center:SetAlpha(0)
        S:CreateShadow(backdrop, 2, nil, nil, nil, true)
        bar.backdrop = backdrop
        header.windCosmeticBar = bar
    end

    -- Border
    if self.db.cosmeticBar.border == "NONE" then
        bar.backdrop:Hide()
    else
        if self.db.cosmeticBar.border == "SHADOW" then
            bar.backdrop.shadow:Show()
        else
            bar.backdrop.shadow:Hide()
        end
        bar.backdrop:Show()
    end

    -- Texture
    bar:SetTexture(LSM:Fetch("statusbar", self.db.cosmeticBar.texture) or E.media.normTex)

    -- Color
    if self.db.cosmeticBar.color.mode == "CLASS" then
        bar:SetVertexColor(C.ExtractColorFromTable(W.ClassColor))
    elseif self.db.cosmeticBar.color.mode == "NORMAL" then
        bar:SetVertexColor(C.ExtractColorFromTable(self.db.cosmeticBar.color.normalColor))
    elseif self.db.cosmeticBar.color.mode == "GRADIENT" then
        bar:SetVertexColor(1, 1, 1)
        bar:SetGradient(
            "HORIZONTAL",
            C.CreateColorFromTable(self.db.cosmeticBar.color.gradientColor1),
            C.CreateColorFromTable(self.db.cosmeticBar.color.gradientColor2)
        )
    end

    bar.backdrop:SetAlpha(self.db.cosmeticBar.borderAlpha)

    -- Position
    bar:ClearAllPoints()
    bar:SetPoint("LEFT", header.Text, "LEFT", self.db.cosmeticBar.offsetX, self.db.cosmeticBar.offsetY)

    -- Size
    local width = self.db.cosmeticBar.width
    local height = self.db.cosmeticBar.height
    if self.db.cosmeticBar.widthMode == "DYNAMIC" then
        width = width + header.Text:GetStringWidth()
    end
    if self.db.cosmeticBar.heightMode == "DYNAMIC" then
        height = height + header.Text:GetStringHeight()
    end

    bar:SetSize(max(width, 1), max(height, 1))

    bar:Show()
end

function OT:ChangeQuestHeaderStyle()
    local frame = _G.ObjectiveTrackerFrame.MODULES
    if not self.db or not frame then
        return
    end

    for i = 1, #frame do
        local modules = frame[i]
        if modules and modules.Header and modules.Header.Text then
            self:CosmeticBar(modules.Header)
            F.SetFontWithDB(modules.Header.Text, self.db.header)
            modules.Header.Text:SetShadowColor(0, 0, 0, 0)
            modules.Header.Text.SetShadowColor = E.noop

            local r = self.db.header.classColor and W.ClassColor.r or self.db.header.color.r
            local g = self.db.header.classColor and W.ClassColor.g or self.db.header.color.g
            local b = self.db.header.classColor and W.ClassColor.b or self.db.header.color.b

            modules.Header.Text:SetTextColor(r, g, b)
            if self.db.header.shortHeader then
                modules.Header.Text:SetText(self:ShortTitle(modules.Header.Text:GetText()))
            end
        end
    end
end

function OT:HandleTitleText(text)
    F.SetFontWithDB(text, self.db.title)
    local height = text:GetStringHeight() + 2
    if height ~= text:GetHeight() then
        text:SetHeight(height)
    end
    SetTextColorHook(text)
end

function OT:HandleInfoText(text)
    self:ColorfulProgression(text)
    F.SetFontWithDB(text, self.db.info)
    text:SetHeight(text:GetStringHeight())

    local line = text:GetParent()
    local dash = line.Dash or line.Icon

    if self.db.noDash and dash then
        dash:Hide()
        text:ClearAllPoints()
        text:Point("TOPLEFT", dash, "TOPLEFT", 0, 0)
    else
        if dash.SetText then
            F.SetFontWithDB(dash, self.db.info)
        end
        if line.Check and line.Check:IsShown() or line.state and line.state == "COMPLETED" or line.dashStyle == 2 then
            dash:Hide()
        else
            dash:Show()
        end
        text:ClearAllPoints()
        text:Point("TOPLEFT", dash, "TOPRIGHT", -1, 0)
    end
end

function OT:ChangeQuestFontStyle(_, block)
    if not self.db or not block then
        return
    end

    if block.HeaderText then
        self:HandleTitleText(block.HeaderText)
    end

    if block.currentLine then
        if block.currentLine.objectiveKey == 0 then -- 世界任务标题
            self:HandleTitleText(block.currentLine.Text)
        else
            self:HandleInfoText(block.currentLine.Text)
        end
    end
end

function OT:ScenarioObjectiveBlock_UpdateCriteria()
    if _G.ScenarioObjectiveBlock then
        local childs = {_G.ScenarioObjectiveBlock:GetChildren()}
        for _, child in pairs(childs) do
            if child.Text then
                self:HandleInfoText(child.Text)
            end
        end
    end
end

function OT:ColorfulProgression(text)
    if not self.db or not text then
        return
    end

    local info = text:GetText()
    if not info then
        return
    end

    local current, required, details = strmatch(info, "^(%d-)/(%d-) (.+)")

    if not (current and required and details) then
        details, current, required = strmatch(info, "(.+): (%d-)/(%d-)$")
    end

    if not (current and required and details) then
        return
    end

    local oldHeight = text:GetHeight()
    local progress = tonumber(current) / tonumber(required)

    if self.db.colorfulProgress then
        info = F.CreateColorString(current .. "/" .. required, F.GetProgressColor(progress))
        info = info .. " " .. details
    end

    if self.db.percentage then
        local percentage = format("[%.f%%]", progress * 100)
        if self.db.colorfulPercentage then
            percentage = F.CreateColorString(percentage, F.GetProgressColor(progress))
        end
        info = info .. " " .. percentage
    end

    text:SetText(info)
end

function OT:UpdateTextWidth()
    if self.db.noDash then
        _G.OBJECTIVE_DASH_STYLE_SHOW = 2
    else
        _G.OBJECTIVE_DASH_STYLE_SHOW = 1
    end
end

function OT:UpdateBackdrop()
    if not _G.ObjectiveTrackerBlocksFrame then
        return
    end

    local db = self.db.backdrop
    local backdrop = _G.ObjectiveTrackerBlocksFrame.backdrop

    if not db.enable then
        if backdrop then
            backdrop:Hide()
        end
        return
    end

    if not backdrop then
        if self.db.backdrop.enable then
            _G.ObjectiveTrackerBlocksFrame:CreateBackdrop()
            backdrop = _G.ObjectiveTrackerBlocksFrame.backdrop
            S:CreateShadow(backdrop)
        end
    end

    backdrop:Show()
    backdrop:SetTemplate(db.transparent and "Transparent")
    backdrop:ClearAllPoints()
    backdrop:SetPoint(
        "TOPLEFT",
        _G.ObjectiveTrackerBlocksFrame,
        "TOPLEFT",
        db.topLeftOffsetX - 30,
        db.topLeftOffsetY + 10
    )
    backdrop:SetPoint(
        "BOTTOMRIGHT",
        _G.ObjectiveTrackerBlocksFrame,
        "BOTTOMRIGHT",
        db.bottomRightOffsetX + 10,
        db.bottomRightOffsetY - 10
    )
end

function OT:Initialize()
    self.db = E.private.WT.quest.objectiveTracker
    if not self.db.enable then
        return
    end

    self:UpdateTextWidth()
    self:UpdateBackdrop()

    if not self.initialized then
        local trackerModules = {
            _G.UI_WIDGET_TRACKER_MODULE,
            _G.BONUS_OBJECTIVE_TRACKER_MODULE,
            _G.WORLD_QUEST_TRACKER_MODULE,
            _G.CAMPAIGN_QUEST_TRACKER_MODULE,
            _G.QUEST_TRACKER_MODULE,
            _G.ACHIEVEMENT_TRACKER_MODULE
        }

        for _, module in pairs(trackerModules) do
            self:SecureHook(module, "AddObjective", "ChangeQuestFontStyle")
        end

        self:SecureHook("ObjectiveTracker_Update", "ChangeQuestHeaderStyle")
        self:SecureHook(_G.SCENARIO_CONTENT_TRACKER_MODULE, "UpdateCriteria", "ScenarioObjectiveBlock_UpdateCriteria")

        self.initialized = true
    end

    E:Delay(
        1,
        function()
            for _, child in pairs {_G.ObjectiveTrackerBlocksFrame:GetChildren()} do
                if child and child.HeaderText then
                    SetTextColorHook(child.HeaderText)
                end
            end
        end
    )

    ObjectiveTracker_Update()
end

W:RegisterModule(OT:GetName())
