local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_CovenantSanctum()
	if not self:CheckDB("covenantSanctum") then
		return
	end

	self:CreateShadow(_G.CovenantSanctumFrame)
end

S:AddCallbackForAddon("Blizzard_CovenantSanctum")
