local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_CharacterCustomize()
    if not self:CheckDB("barber", "barberShop") then
        return
    end
    local frame = _G.CharCustomizeFrame

    self:CreateBackdropShadow(frame.SmallButtons.ResetCameraButton)
    self:CreateBackdropShadow(frame.SmallButtons.ZoomOutButton)
    self:CreateBackdropShadow(frame.SmallButtons.ZoomInButton)
    self:CreateBackdropShadow(frame.SmallButtons.RotateLeftButton)
    self:CreateBackdropShadow(frame.SmallButtons.RotateRightButton)

    hooksecurefunc(
        frame,
        "SetSelectedCatgory",
        function(list)
            for button in list.selectionPopoutPool:EnumerateActive() do
                if not button.windStyle then
                    self:CreateBackdropShadow(button.DecrementButton)
                    self:CreateBackdropShadow(button.IncrementButton)
                    self:CreateBackdropShadow(button.SelectionPopoutButton)
                    self:CreateBackdropShadow(button.SelectionPopoutButton.Popout)
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

    self:CreateBackdropShadow(frame.ResetButton)
    self:CreateBackdropShadow(frame.CancelButton)
    self:CreateBackdropShadow(frame.AcceptButton)
end

S:AddCallbackForAddon("Blizzard_CharacterCustomize")
S:AddCallbackForAddon("Blizzard_BarbershopUI")
