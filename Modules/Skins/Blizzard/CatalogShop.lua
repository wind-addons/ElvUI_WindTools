local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local ES = E:GetModule("Skins")

local _G = _G

function S:Blizzard_CatalogShop()
	if not self:CheckDB("catalogShop") then
		return
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
end

S:AddCallback("Blizzard_CatalogShop")
