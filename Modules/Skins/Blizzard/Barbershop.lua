local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_BarbershopUI()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.barber) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.barberShop) then
        return
    end

    local frame = _G.BarberShopFrame

    S:CreateShadow(frame.ResetButton)
    S:CreateShadow(frame.CancelButton)
    S:CreateShadow(frame.AcceptButton)
end

S:AddCallbackForAddon("Blizzard_BarbershopUI")

function S:Blizzard_CharacterCustomize()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.barber) then
        return
    end -- yes, it belongs also to tbe BarberUI
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.barberShop) then
        return
    end
    local frame = _G.CharCustomizeFrame

    S:CreateShadow(frame.SmallButtons.ResetCameraButton)
    S:CreateShadow(frame.SmallButtons.ZoomOutButton)
    S:CreateShadow(frame.SmallButtons.ZoomInButton)
    S:CreateShadow(frame.SmallButtons.RotateLeftButton)
    S:CreateShadow(frame.SmallButtons.RotateRightButton)
end

S:AddCallbackForAddon("Blizzard_CharacterCustomize")
