local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local UF = E:GetModule("UnitFrames")

local _G = _G

function S:ElvUI_UnitFrames_SkinCastBar(_, frame)
    self:CreateShadow(frame.Castbar)
    if not frame.db.castbar.iconAttached then
        self:CreateShadow(frame.Castbar.ButtonIcon.bg)
    end
end

function S:ElvUI_CastBars()
    if not E.private.unitframe.enable then
        return
    end
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.castBars) then
        return
    end

    self:SecureHook(UF, "Configure_Castbar", "ElvUI_UnitFrames_SkinCastBar")
end

S:AddCallback("ElvUI_CastBars")
