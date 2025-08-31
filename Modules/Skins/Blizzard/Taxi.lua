local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:TaxiFrame()
	if not self:CheckDB("taxi") then
		return
	end

	self:CreateShadow(_G.TaxiFrame)
end

S:AddCallback("TaxiFrame")
