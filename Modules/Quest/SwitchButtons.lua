local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")
local SB = W:NewModule("SwitchButtons", "AceHook-3.0", "AceEvent-3.0")

local CreateFrame = CreateFrame

function SB:CreateButton(text)
    if not self.db or not self.bar then
        return
    end

    local button = CreateFrame("CheckButton", nil, self.bar, "UICheckButtonTemplate")
    ES:HandleCheckBox(button)

    button.originalText = text
    button.text = button:CreateFontString()
    button.text:Point("LEFT", button, "RIGHT", 0, -1)
    F.SetFontWithDB(button.text, self.db.font)
    button.text:SetText(F.CreateColorString(button.originalText, self.db.font.color))
    button.text:SetJustifyV("MIDDLE")

    return button
end

function SB:UpdateButton(button)
    if not self.db or not button then
        return
    end

    F.SetFontWithDB(button.text, self.db.font)

    button.buttonSize = 0

    if self.db.font.size < 7 then
        button:Size(16)
        button.buttonSize = button.buttonSize + 16
    elseif self.db.font.size <= 12 then
        button:Size(self.db.font.size + 9)
        button.buttonSize = self.db.font.size + 9
    else
        button:Size(self.db.font.size + 12)
        button.buttonSize = self.db.font.size + 12
    end

    button.text:SetText(F.CreateColorString(button.originalText, self.db.font.color))
    button.buttonSize = button.buttonSize + button.text:GetStringWidth()
    button:Show()
end

function SB:UpdateLayout()
    if not self.db and not self.bar then
        return
    end

    local xOffset = 0

    if self.db.announcement then
        if not self.bar.announcement then
            self.bar.announcement = self:CreateButton(L["[ABBR] Announcement"])
            self.bar.announcement:SetChecked(not E.db.WT.announcement.quest.paused)
            self.bar.announcement:SetScript(
                "OnClick",
                function()
                    E.db.WT.announcement.quest.paused = not self.bar.announcement:GetChecked()
                end
            )
        end

        self:UpdateButton(self.bar.announcement)

        self.bar.announcement:Point("LEFT", xOffset, 0)
        xOffset = xOffset + self.bar.announcement.buttonSize
    else
        if self.bar.announcement then
            self.bar.announcement:Hide()
        end
    end

    if self.db.turnIn then
        if not self.bar.turnIn then
            self.bar.turnIn = self:CreateButton(L["[ABBR] Turn In"])
            self.bar.turnIn:SetChecked(E.db.WT.quest.turnIn.enable)
            self.bar.turnIn:SetScript(
                "OnClick",
                function()
                    E.db.WT.quest.turnIn.enable = self.bar.turnIn:GetChecked()
                    W:GetModule("TurnIn"):ProfileUpdate()
                end
            )
        end

        self:UpdateButton(self.bar.turnIn)

        self.bar.turnIn:Point("LEFT", xOffset, 0)
        xOffset = xOffset + self.bar.turnIn.buttonSize
    else
        if self.bar.turnIn then
            self.bar.turnIn:Hide()
        end
    end

    if self.db.backdrop then
        self.bar.backdrop:Show()
    else
        self.bar.backdrop:Hide()
    end

    if xOffset ~= 0 then
        self.bar:Show()
        self.barAnchor:Show()
        self.bar:Size(xOffset + 1, 20)
        self.barAnchor:Size(xOffset + 1, 20)
    else
        self.bar:Hide()
        self.barAnchor:Hide()
    end
end

function SB:CreateBar()
    if self.bar then
        return
    end

    local frame = CreateFrame("Frame", nil, E.UIParent)
    frame:Point("RIGHT", ObjectiveFrameMover, "RIGHT", 0, -2)
    frame:SetFrameStrata("BACKGROUND")
    self.barAnchor = frame

    frame = CreateFrame("Frame", nil, E.UIParent)
    frame:SetFrameStrata("LOW")
    frame:CreateBackdrop("Transparent")
    frame:ClearAllPoints()
    frame:SetPoint("CENTER", self.barAnchor, "CENTER", 0, 0)
    self.bar = frame

    self:UpdateLayout()

    if E.private.WT.skins.windtools then
        S:CreateShadow(self.bar.backdrop)
    end

    E:CreateMover(
        self.barAnchor,
        "WTSwitchButtonBarAnchor",
        L["Switch Buttons Bar"],
        nil,
        nil,
        nil,
        "ALL,WINDTOOLS",
        function()
            return E.db.WT.quest.switchButtons.enable
        end
    )
end

function SB:Initialize()
    self.db = E.db.WT.quest.switchButtons
    if not self.db.enable then
        return
    end

    self:CreateBar()
end

function SB:ProfileUpdate()
    self.db = E.db.WT.quest.switchButtons
    if not self.db.enable then
        if self.bar then
            self.bar:Hide()
        end
    else
        if not self.bar then
            self:CreateBar()
        else
            self.bar:Show()
            self:UpdateLayout()
        end

        if self.db.announcement then
            self.bar.announcement:SetChecked(E.db.WT.announcement.quest.enable)
        end

        if self.db.turnIn then
            self.bar.turnIn:SetChecked(E.db.WT.quest.turnIn.enable)
        end
    end
end

W:RegisterModule(SB:GetName())
