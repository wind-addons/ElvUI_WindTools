local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("TaxiFrame")
data.toggle = "taxi"

local _G = _G

function S:TaxiFrame()
	self:CreateShadow(_G.TaxiFrame)
end

