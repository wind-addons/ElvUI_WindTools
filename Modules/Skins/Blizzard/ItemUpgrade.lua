local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_ItemUpgradeUI")
data.toggle = "itemUpgrade"

local _G = _G

function S:Blizzard_ItemUpgradeUI()
	self:CreateBackdropShadow(_G.ItemUpgradeFrame)
end

