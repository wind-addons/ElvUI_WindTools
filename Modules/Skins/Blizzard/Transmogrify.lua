local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_Transmog()
	if not self:CheckDB("transmogrify") then
		return
	end

	self:CreateShadow(_G.TransmogFrame)
end

S:AddCallbackForAddon("Blizzard_Transmog")
