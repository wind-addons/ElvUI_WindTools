local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_EventTrace()
	if not self:CheckDB("eventLog", "eventTrace") then
		return
	end

	self:CreateBackdropShadow(_G.EventTrace)
end

S:AddCallbackForAddon("Blizzard_EventTrace")
