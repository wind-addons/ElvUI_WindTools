local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_StableUI", nil, "stable")

function S:Blizzard_StableUI()
	self:CreateShadow(_G.StableFrame)
end
