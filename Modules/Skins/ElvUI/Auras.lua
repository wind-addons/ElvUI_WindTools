local W, F, E, L = unpack(select(2, ...))
local A = E:GetModule("Auras")
local S = W:GetModule("Skins")

local _G = _G

function S:ElvUI_Auras_SkinIcon(_, button)
    self:CreateShadow(button)
end

function S:ElvUI_Auras()
    if not E.private.auras.enable then
        return
    end
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.auras) then
        return
    end

    self:SecureHook(A, "CreateIcon", "ElvUI_Auras_SkinIcon")
    self:SecureHook(A, "UpdateAura", "ElvUI_Auras_SkinIcon")
    self:SecureHook(A, "UpdateTempEnchant", "ElvUI_Auras_SkinIcon")
end

S:AddCallback("ElvUI_Auras")
