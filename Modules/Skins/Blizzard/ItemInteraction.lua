local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_ItemInteractionUI", nil, "itemInteraction")

function S:Blizzard_ItemInteractionUI()
	self:CreateShadow(_G.ItemInteractionFrame)
end
