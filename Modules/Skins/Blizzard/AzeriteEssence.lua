local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_AzeriteEssenceUI", nil, "azeriteEssence")

function S:Blizzard_AzeriteEssenceUI()
	self:CreateShadow(_G.AzeriteEssenceUI)
end
