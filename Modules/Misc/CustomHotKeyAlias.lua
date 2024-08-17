local W, F, E, L, V, P, G = unpack((select(2, ...)))
local M = W.Modules.Misc
local AB = E.ActionBars

local pairs = pairs

local buttons = {}

local function SetHotKeyText(_, button)
    if not button or not button.HotKey or not button.HotKey.GetText then
        return
    end

    -- cache the original hotkey text
    if not buttons[button] then
        buttons[button] = button.HotKey:GetText()
    end

    local bind = buttons[button]

    if E.db and E.db.WT and E.db.WT.misc and E.db.WT.misc.customHotKeyAlias and E.db.WT.misc.customHotKeyAlias.enable then
        if E.db.WT.misc.customHotKeyAlias.list[bind] then
            button.HotKey:SetText(E.db.WT.misc.customHotKeyAlias.list[bind])
            return true
        end
    end

    button.HotKey:SetText(bind)
end

local AB_FixKeybindText = AB.FixKeybindText
AB.FixKeybindText = function(...)
    if not SetHotKeyText(...) then
        AB_FixKeybindText(...)
    end
end

function M:UpdateAllHotKeyText()
    for button in pairs(buttons) do
        AB:FixKeybindText(button)
    end
end
