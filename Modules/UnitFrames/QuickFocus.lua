local W, F, E, L = unpack(select(2, ...))
local QF = W:NewModule("QuickFocus", "AceHook-3.0", "AceEvent-3.0")

local _G = _G
local format = format
local next = next
local strmatch = strmatch
local strsub = strsub

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local SetOverrideBindingClick = SetOverrideBindingClick

local Pending = {}

function QF:SetupFrame(frame)
    if not frame or frame.WTQuickFocus then
        return
    end

    if frame:GetName() and strmatch(frame:GetName(), "oUF_NPs") then
        return
    end

    if not InCombatLockdown() then
        frame:SetAttribute(self.db.modifier .. "-type" .. strsub(self.db.button, 7, 7), "focus")
        frame.WTQuickFocus = true
        Pending[frame] = nil
    else
        Pending[frame] = true
    end
end

function QF:CreateFrameHook(name, _, template)
    if name and template == "SecureUnitButtonTemplate" then
        self:SetupFrame(_G[name])
    end
end

function QF:PLAYER_REGEN_ENABLED()
    if next(Pending) then
        for frame in next, Pending do
            self:SetupFrame(frame)
        end
    end
end

function QF:GROUP_ROSTER_UPDATE()
    for _, object in next, E.oUF.objects do
        if not object.WTQuickFocus then
            self:SetupFrame(object)
        end
    end
end

function QF:Initialize()
    self.db = E.private.WT.unitFrames.quickFocus
    if not self.db or not self.db.enable then
        return
    end

    local button = CreateFrame("Button", "WTQuickFocusButton", E.UIParent, "SecureActionButtonTemplate")
    button:SetAttribute("type1", "macro")
    button:SetAttribute("macrotext", "/focus mouseover")
    SetOverrideBindingClick(button, true, self.db.modifier .. "-" .. self.db.button, "WTQuickFocusButton")

    self:SecureHook("CreateFrame", "CreateFrameHook")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("GROUP_ROSTER_UPDATE")
    self:GROUP_ROSTER_UPDATE()
end

W:RegisterModule(QF:GetName())
