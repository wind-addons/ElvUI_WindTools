local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_PerksProgram()
    if not self:CheckDB("perks", "perksProgram") then
        return
    end

    local frame = _G.PerksProgramFrame

    local products = frame.ProductsFrame

    if products then
        self:CreateShadow(products.PerksProgramFilter.FilterDropDownButton)
        products.PerksProgramCurrencyFrame.Icon:CreateBackdrop()
        self:CreateBackdropShadow(products.PerksProgramCurrencyFrame.Icon)

        self:CreateShadow(products.ProductsScrollBoxContainer)
        self:CreateShadow(products.PerksProgramProductDetailsContainerFrame)
    end

    local footer = frame.FooterFrame
    if footer then
        self:CreateShadow(footer.TogglePlayerPreview)
        footer.TogglePlayerPreview.shadow:SetAllPoints()

        self:CreateBackdropShadow(footer.RotateButtonContainer.RotateLeftButton)
        self:CreateBackdropShadow(footer.RotateButtonContainer.RotateRightButton)

        self:CreateBackdropShadow(footer.LeaveButton)
        self:CreateBackdropShadow(footer.PurchaseButton)
        self:CreateBackdropShadow(footer.RefundButton)
    end
end

S:AddCallbackForAddon("Blizzard_PerksProgram")
