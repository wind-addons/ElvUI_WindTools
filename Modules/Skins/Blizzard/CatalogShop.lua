local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local ES = E:GetModule("Skins")

local _G = _G

function S:Blizzard_CatalogShop()
	if not self:CheckDB("catalog") then
		return
	end

	self:CreateShadow(_G.CatalogShopFrame)
end

S:AddCallback("Blizzard_CatalogShop")
