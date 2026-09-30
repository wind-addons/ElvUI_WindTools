local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_ItemUpgradeUI", nil, "itemUpgrade")

function S:Blizzard_ItemUpgradeUI()
	self:CreateBackdropShadow(_G.ItemUpgradeFrame)
end
