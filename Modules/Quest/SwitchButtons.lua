local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins
local ES = E.Skins
local SB = W:NewModule("SwitchButtons", "AceHook-3.0", "AceEvent-3.0")

local _G = _G

local CreateFrame = CreateFrame
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

function SB:CreateButton(text)
    if not self.db or not self.bar then
        return
    end
    local button = CreateFrame("CheckButton", nil, self.bar, "UICheckButtonTemplate")
    ES:HandleCheckBox(button)
    if E.private.WT.skins.enable and E.private.WT.skins.windtools and E.private.WT.skins.shadow then
        S:CreateBackdropShadow(button)
    end
    button.originalText = text
    button.text = button:CreateFontString()
    F.SetFontWithDB(button.text, self.db.font)
    button.text:SetText(F.CreateColorString(button.originalText, self.db.font.color))
    button.text:SetJustifyV("MIDDLE")
    button.text:SetJustifyH("LEFT")
    button.text:Point("LEFT", button, "RIGHT")
    return button
end

function SB:UpdateButton(button, enable)
    if not self.db or not button then
        return
    end

    if enable then
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
        local checkedTexture = button:GetCheckedTexture()
        checkedTexture:SetVertexColor(self.db.font.color.r, self.db.font.color.g, self.db.font.color.b)
        button.buttonSize = button.buttonSize + button.text:GetStringWidth()
    end

    if enable ~= button:IsShown() then
        if enable then
            button:Show()
        else
            button:Hide()
        end
    end
end

function SB:UpdateLayout()
    if not self.db and not self.bar then
        return
    end

    local xOffset = 0

    if not self.bar.announcement then
        self.bar.announcement = self:CreateButton(L["[ABBR] Announcement"])
        self.bar.announcement:SetScript(
            "OnClick",
            function()
                E.db.WT.announcement.quest.paused = not self.bar.announcement:GetChecked()
            end
        )
    end

    if not self.bar.turnIn then
        self.bar.turnIn = self:CreateButton(L["[ABBR] Turn In"])
        self.bar.turnIn:SetScript(
            "OnClick",
            function()
                E.db.WT.quest.turnIn.enable = self.bar.turnIn:GetChecked()
                W:GetModule("TurnIn"):ProfileUpdate()
            end
        )
    end

    self:UpdateButton(self.bar.announcement, self.db.announcement)
    self:UpdateButton(self.bar.turnIn, self.db.turnIn)

    if self.db.announcement then
        self.bar.announcement:Point("LEFT", xOffset, 0)
        xOffset = xOffset + self.bar.announcement.buttonSize
        self.bar.announcement:SetChecked(E.db.WT.announcement.quest.enable and not E.db.WT.announcement.quest.paused)
    end

    if self.db.turnIn then
        self.bar.turnIn:Point("LEFT", xOffset, 0)
        xOffset = xOffset + self.bar.turnIn.buttonSize
        self.bar.turnIn:SetChecked(E.db.WT.quest.turnIn.enable)
    end

    if self.db.backdrop then
        self.bar.backdrop:Show()
        if self.bar.announcement.backdrop.shadow then
            self.bar.announcement.backdrop.shadow:Hide()
        end
        if self.bar.turnIn.backdrop.shadow then
            self.bar.turnIn.backdrop.shadow:Hide()
        end
    else
        self.bar.backdrop:Hide()
        if self.bar.announcement.backdrop.shadow then
            self.bar.announcement.backdrop.shadow:Show()
        end
        if self.bar.turnIn.backdrop.shadow then
            self.bar.turnIn.backdrop.shadow:Show()
        end
    end

    if xOffset ~= 0 then
        self.bar:Show()
        self.bar:Size(xOffset + 1, 20)
    else
        self.bar:Hide()
    end

    self:AutoHideWithObjectiveFrame()
end

function SB:CreateBar()
    if self.bar then
        return
    end

    local frame = CreateFrame("Frame", "WTSwitchButtonsBar", E.UIParent)
    frame:Point("RIGHT", _G.ObjectiveFrameMover, "RIGHT", 0, -2)
    frame:SetFrameStrata("LOW")
    frame:SetFrameLevel(5)
    frame:CreateBackdrop("Transparent")

    self.bar = frame

    self:UpdateLayout()

    if E.private.WT.skins.enable and E.private.WT.skins.windtools and E.private.WT.skins.shadow then
        S:CreateBackdropShadow(self.bar)
    end

    E:CreateMover(
        frame,
        "WTSwitchButtonBarMover",
        L["Switch Buttons Bar"],
        nil,
        nil,
        nil,
        "ALL,WINDTOOLS",
        function()
            return E.db.WT.quest.switchButtons.enable
        end,
        "WindTools,quest,switchButtons"
    )
end

function SB:AutoHideWithObjectiveFrame()
    if not self.db.enable or not self.bar then
        return
    end

    if self.db.hideWithObjectiveTracker then
        if self.bar.visibilitySet then
            UnregisterStateDriver(self.bar, "visibility")
            self.bar.visibilitySet = false
        end
        if _G.ObjectiveTrackerFrame.collapsed or not _G.ObjectiveTrackerFrame.HeaderMenu:IsShown() then
            self.bar:Hide()
            return
        end
    elseif not self.bar.visibilitySet then
        RegisterStateDriver(self.bar, "visibility", "[petbattle]hide;show")
        self.bar.visibilitySet = true
    end

    self.bar:Show()
end

function SB:PLAYER_ENTERING_WORLD()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UpdateLayout()
end

function SB:Initialize()
    self.db = E.db.WT.quest.switchButtons
    if not self.db.enable then
        return
    end

    self:SecureHook("ObjectiveTracker_Collapse", "AutoHideWithObjectiveFrame")
    self:SecureHook("ObjectiveTracker_Expand", "AutoHideWithObjectiveFrame")
    self:SecureHook(_G.ObjectiveTrackerFrame.HeaderMenu, "Show", "AutoHideWithObjectiveFrame")
    self:SecureHook(_G.ObjectiveTrackerFrame.HeaderMenu, "Hide", "AutoHideWithObjectiveFrame")
    self:CreateBar()

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
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
            self:AutoHideWithObjectiveFrame()
            self:UpdateLayout()
        end
    end
end

W:RegisterModule(SB:GetName())
