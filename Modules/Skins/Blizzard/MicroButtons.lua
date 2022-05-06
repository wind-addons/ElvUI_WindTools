local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local MICRO_BUTTONS = MICRO_BUTTONS

function S:MicroButtons()
    if not self:CheckDB(nil, "microButtons") then
        return
    end

    for i = 1, #MICRO_BUTTONS do
        if _G[MICRO_BUTTONS[i]].backdrop then
            self:CreateBackdropShadow(_G[MICRO_BUTTONS[i]], true)
        end
    end
end

S:AddCallback("MicroButtons")