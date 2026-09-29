local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_FlightMap")
data.toggle = "taxi"
data.private = "flightMap"

local _G = _G

function S:Blizzard_FlightMap()
	self:CreateShadow(_G.FlightMapFrame)
end

