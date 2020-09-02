local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_CharacterCustomize()
    if not self:CheckDB("barber", "barberShop") then
        return
    end
    local frame = _G.CharCustomizeFrame

    self:CreateShadow(frame.SmallButtons.ResetCameraButton)
    self:CreateShadow(frame.SmallButtons.ZoomOutButton)
    self:CreateShadow(frame.SmallButtons.ZoomInButton)
    self:CreateShadow(frame.SmallButtons.RotateLeftButton)
    self:CreateShadow(frame.SmallButtons.RotateRightButton)
end

function S:Blizzard_BarbershopUI()
    if not self:CheckDB("barber", "barberShop") then
        return
    end

    local frame = _G.BarberShopFrame

    self:CreateShadow(frame.ResetButton)
    self:CreateShadow(frame.CancelButton)
    self:CreateShadow(frame.AcceptButton)
end

S:AddCallbackForAddon("Blizzard_CharacterCustomize")
S:AddCallbackForAddon("Blizzard_BarbershopUI")
