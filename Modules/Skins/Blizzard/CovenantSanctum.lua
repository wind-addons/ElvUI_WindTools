local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_CovenantSanctum()
	if not self:CheckDB("covenantSanctum") then
		return
	end

	self:CreateShadow(_G.CovenantSanctumFrame)
end

S:AddCallbackForAddon("Blizzard_CovenantSanctum")
