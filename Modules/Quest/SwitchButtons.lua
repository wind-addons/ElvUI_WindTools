local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")
local SB = W:NewModule("SwitchButtons", "AceHook-3.0", "AceEvent-3.0")

local CreateFrame = CreateFrame

function SB:UpdateLayout()
    if not self.db and not self.bar then
        return
    end

    local xOffset = 0

    if self.db.announcement then
        if not self.bar.announcement then
            local button = CreateFrame("CheckButton", nil, self.bar, "UICheckButtonTemplate")
            local buttonText = button:CreateFontString()

            ES:HandleCheckBox(button)
            button:Size(2 * self.db.font.size)
            buttonText:FontTemplate()
            buttonText:Point("LEFT", button, "RIGHT", 0, 0)
            buttonText:SetJustifyV("MIDDLE")
            buttonText:SetJustifyH("LEFT")
            buttonText:SetText(L["[ABBR] Announcement"])

            button.text = buttonText
            button.buttonSize = buttonText:GetStringWidth() + 2 * self.db.font.size
            self.bar.announcement = button
        end
        self.bar.announcement:Show()
        self.bar.announcement:Point("LEFT", xOffset, 0)
        xOffset = xOffset + self.bar.announcement.buttonSize
    else
        if self.bar.announcement then
            self.bar.announcement:Hide()
        end
    end

    if self.db.turnIn then
        if not self.bar.turnIn then
            local button = CreateFrame("CheckButton", nil, self.bar, "UICheckButtonTemplate")
            local buttonText = button:CreateFontString()
            ES:HandleCheckBox(button)
            button:Size(2 * self.db.font.size)

            buttonText:FontTemplate()
            buttonText:Point("LEFT", button, "RIGHT", 0, 0)
            buttonText:SetJustifyV("MIDDLE")
            buttonText:SetJustifyH("LEFT")
            buttonText:SetText(L["[ABBR] Turn In"])

            button.text = buttonText
            button.buttonSize = buttonText:GetStringWidth() + 2 * self.db.font.size
            self.bar.turnIn = button
        end
        self.bar.turnIn:Show()
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

    self.bar:Size(xOffset+1, 20)
    self.barAnchor:Size(xOffset+1, 20)
end

function SB:CreateBar()
    if self.bar then
        return
    end

    local frame = CreateFrame("Frame", nil, E.UIParent)
    frame:Point("LEFT", ObjectiveFrameMover, "LEFT", 0, -2)
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
            return E.private.WT.maps.quest.switchButtons.enable
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
end

W:RegisterModule(SB:GetName())
