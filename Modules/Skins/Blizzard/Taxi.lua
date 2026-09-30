local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallback("TaxiFrame", "taxi")

function S:TaxiFrame()
	self:CreateShadow(_G.TaxiFrame)
end
