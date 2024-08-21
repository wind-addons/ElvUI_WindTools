local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:TaxiFrame()
	if not self:CheckDB("taxi") then
		return
	end

	self:CreateShadow(_G.TaxiFrame)
end

S:AddCallback("TaxiFrame")
