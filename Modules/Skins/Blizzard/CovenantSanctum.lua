local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_CovenantSanctum", nil, "covenantSanctum")

function S:Blizzard_CovenantSanctum()
	self:CreateShadow(_G.CovenantSanctumFrame)
end
