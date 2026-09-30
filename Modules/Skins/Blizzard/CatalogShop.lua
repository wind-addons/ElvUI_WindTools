local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_CatalogShop()
	if not self:CheckDB("catalogShop") then
		return
	end

	if E.private.skins.blizzard.tooltip and _G.CatalogShopTooltip then
		self:ReskinTooltip(_G.CatalogShopTooltip)
	end

	local CatalogShopFrame = _G.CatalogShopFrame
	if not CatalogShopFrame then
		return
	end

	self:CreateShadow(CatalogShopFrame)

	local CatalogShopDetailsFrame = CatalogShopFrame.CatalogShopDetailsFrame
	if CatalogShopDetailsFrame then
		self:CreateShadow(CatalogShopDetailsFrame)
	end

	local ProductDetailsContainerFrame = CatalogShopFrame.ProductDetailsContainerFrame
	if ProductDetailsContainerFrame then
		local BackButton = ProductDetailsContainerFrame.BackButton
		if BackButton then
			self:CreateBackdropShadow(BackButton, true)
		end
	end
end

S:AddCallback("Blizzard_CatalogShop")
