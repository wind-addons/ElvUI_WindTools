local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_GenericTraitUI()
	if not self:CheckDB("majorFactions") then
		return
	end

	self:CreateShadow(_G.GenericTraitFrame)
end

S:AddCallbackForAddon("Blizzard_GenericTraitUI")
