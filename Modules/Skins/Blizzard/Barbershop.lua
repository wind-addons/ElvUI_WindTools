local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_CharacterCustomize()
    if not self:CheckDB("barber", "barberShop") then
        return
    end
    local frame = _G.CharCustomizeFrame

    self:CreateBackdropShadowAfterElvUISkins(frame.SmallButtons.ResetCameraButton)
    self:CreateBackdropShadowAfterElvUISkins(frame.SmallButtons.ZoomOutButton)
    self:CreateBackdropShadowAfterElvUISkins(frame.SmallButtons.ZoomInButton)
    self:CreateBackdropShadowAfterElvUISkins(frame.SmallButtons.RotateLeftButton)
    self:CreateBackdropShadowAfterElvUISkins(frame.SmallButtons.RotateRightButton)

    hooksecurefunc(
        frame,
        "SetSelectedCatgory",
        function(list)
            for button in list.selectionPopoutPool:EnumerateActive() do
                if not button.windStyle then
                    self:CreateBackdropShadowAfterElvUISkins(button.DecrementButton)
                    self:CreateBackdropShadowAfterElvUISkins(button.IncrementButton)
                    self:CreateBackdropShadowAfterElvUISkins(button.SelectionPopoutButton)
                    self:CreateBackdropShadowAfterElvUISkins(button.SelectionPopoutButton.Popout)
                    button.windStyle = true
                end
            end
        end
    )
end

function S:Blizzard_BarbershopUI()
    if not self:CheckDB("barber", "barberShop") then
        return
    end

    local frame = _G.BarberShopFrame

    self:CreateBackdropShadowAfterElvUISkins(frame.ResetButton)
    self:CreateBackdropShadowAfterElvUISkins(frame.CancelButton)
    self:CreateBackdropShadowAfterElvUISkins(frame.AcceptButton)
end

S:AddCallbackForAddon("Blizzard_CharacterCustomize")
S:AddCallbackForAddon("Blizzard_BarbershopUI")
