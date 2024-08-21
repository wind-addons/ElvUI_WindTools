local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local UIParentLoadAddOn = UIParentLoadAddOn

function S:Blizzard_EventTrace()
	if not self:CheckDB("eventLog", "eventTrace") then
		return
	end

	self:CreateBackdropShadow(_G.EventTrace)
end

S:AddCallbackForAddon("Blizzard_EventTrace")
