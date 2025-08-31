local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_ItemUpgradeUI()
	if not self:CheckDB("itemUpgrade") then
		return
	end

	self:CreateBackdropShadow(_G.ItemUpgradeFrame)
end

S:AddCallbackForAddon("Blizzard_ItemUpgradeUI")
