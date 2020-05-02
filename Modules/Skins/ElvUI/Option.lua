local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:ElvUI_Option()
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.option) then return end

    hooksecurefunc(E, "ToggleOptionsUI", function()
        local frame = E:Config_GetWindow()
        frame:CreateShadow()
    end)
end

S:AddCallback('ElvUI_Option')