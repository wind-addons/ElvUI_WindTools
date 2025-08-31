local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_ItemInteractionUI()
	if not self:CheckDB("itemInteraction") then
		return
	end

	self:CreateShadow(_G.ItemInteractionFrame)
end

S:AddCallbackForAddon("Blizzard_ItemInteractionUI")
