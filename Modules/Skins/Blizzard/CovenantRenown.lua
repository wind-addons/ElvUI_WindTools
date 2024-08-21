local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_CovenantRenown()
	if not self:CheckDB("covenantRenown") then
		return
	end

	self:CreateShadow(_G.CovenantRenownFrame)
end

S:AddCallbackForAddon("Blizzard_CovenantRenown")
