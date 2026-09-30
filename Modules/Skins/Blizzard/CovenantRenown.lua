local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_CovenantRenown", nil, "covenantRenown")

function S:Blizzard_CovenantRenown()
	self:CreateShadow(_G.CovenantRenownFrame)
end
