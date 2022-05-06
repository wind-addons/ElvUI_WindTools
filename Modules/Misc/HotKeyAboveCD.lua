local W, F, E, L = unpack(select(2, ...))
local M = W.Modules.Misc
local AB = E.ActionBars

local hooksecurefunc = hooksecurefunc

local function HotKeyTweak(button)
    if button.windHotKeyFrame or not button.cooldown then
        return
    end
    button.windHotKeyFrame = CreateFrame("Frame", nil, button)
    button.windHotKeyFrame:SetAllPoints(button)
    button.windHotKeyFrame:SetFrameStrata("LOW")
    button.windHotKeyFrame:SetFrameLevel(button.cooldown:GetFrameLevel() + 1)
    button.HotKey:SetParent(button.windHotKeyFrame)
end

function M:HotKeyAboveCD()
    if not E.private.actionbar.enable or not E.db.cooldown.enable or not E.private.WT.misc.hotKeyAboveCD then
        return
    end

    hooksecurefunc(
        E,
        "CreateCooldownTimer",
        function(_, button)
            if button and button.cooldown and AB.handledbuttons[button] then
                HotKeyTweak(button)
            end
        end
    )
    for button in pairs(AB.handledbuttons) do
        HotKeyTweak(button)
    end
end

M:AddCallback("HotKeyAboveCD")
