local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

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
		self:CreateShadow(products.PerksProgramFilter)
	end

	local footer = frame.FooterFrame
	if footer then
		for _, button in pairs({
			footer.TogglePlayerPreview,
			footer.ToggleMountSpecial,
		}) do
			self:CreateShadow(button)
			if button.shadow then
				button.shadow:SetAllPoints()
			end

			F.SetFontOutline(button.Text)
		end

		self:CreateBackdropShadow(footer.RotateButtonContainer.RotateLeftButton)
		self:CreateBackdropShadow(footer.RotateButtonContainer.RotateRightButton)

		self:CreateBackdropShadow(footer.LeaveButton)
		self:CreateBackdropShadow(footer.PurchaseButton)
		self:CreateBackdropShadow(footer.RefundButton)
		self:CreateBackdropShadow(footer.ViewCartButton)
		self:CreateBackdropShadow(footer.AddToCartButton)
		self:CreateBackdropShadow(footer.RemoveFromCartButton)
	end
end

S:AddCallbackForAddon("Blizzard_PerksProgram")
