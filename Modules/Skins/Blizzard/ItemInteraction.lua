local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_ItemInteractionUI()
	if not self:CheckDB("itemInteraction") then
		return
	end

	self:CreateShadow(_G.ItemInteractionFrame)
end

S:AddCallbackForAddon("Blizzard_ItemInteractionUI")
