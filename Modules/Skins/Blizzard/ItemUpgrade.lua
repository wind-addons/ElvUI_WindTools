local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_ItemUpgradeUI()
	if not self:CheckDB("itemUpgrade") then
		return
	end

	self:CreateBackdropShadow(_G.ItemUpgradeFrame)
end

S:AddCallbackForAddon("Blizzard_ItemUpgradeUI")
