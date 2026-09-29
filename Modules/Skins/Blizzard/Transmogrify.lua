local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_Transmog")
data.toggle = "transmogrify"

local _G = _G

function S:Blizzard_Transmog()
	self:CreateShadow(_G.TransmogFrame)
end

