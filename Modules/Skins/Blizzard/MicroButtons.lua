local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local MICRO_BUTTONS = MICRO_BUTTONS

local _G = _G

function S:MicroButtons()
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.microButtons) then
        return
    end

    for i = 1, #MICRO_BUTTONS do
        if _G[MICRO_BUTTONS[i]].backdrop then
            S:CreateShadow(_G[MICRO_BUTTONS[i]].backdrop)
        end
    end
end

S:AddCallback("MicroButtons")