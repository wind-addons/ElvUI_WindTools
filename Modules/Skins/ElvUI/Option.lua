local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:ElvUI_OptionsUI()
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.option) then
        return
    end

    hooksecurefunc(
        E,
        "ToggleOptionsUI",
        function()
            if not InCombatLockdown() then
                local frame = E:Config_GetWindow()
                frame:CreateShadow()
            end
        end
    )
end

S:AddCallback("ElvUI_OptionsUI")
