local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_FlightMap()
	if not self:CheckDB("taxi", "flightMap") then
		return
	end

	self:CreateShadow(_G.FlightMapFrame)
end

S:AddCallbackForAddon("Blizzard_FlightMap")
