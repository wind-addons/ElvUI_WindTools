local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:Blizzard_BarbershopUI()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.barber) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.barberShop) then return end

    S:CreateShadow(_G.BarberShopFrame)
end

S:AddCallbackForAddon('Blizzard_BarbershopUI')