local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local InCombatLockdown = InCombatLockdown

function S:ElvUI_SkinOptionsUI()
    if not InCombatLockdown() then
        self:CreateShadow(E:Config_GetWindow())
    end
end

function S:ElvUI_OptionsUI()
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.option) then
        return
    end

    S:SecureHook(E, "ToggleOptionsUI", "ElvUI_SkinOptionsUI")
end

S:AddCallback("ElvUI_OptionsUI")
