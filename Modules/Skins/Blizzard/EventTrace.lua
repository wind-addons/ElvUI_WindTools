local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_EventTrace", nil, "eventLog", "eventTrace")

function S:Blizzard_EventTrace()
	self:CreateBackdropShadow(_G.EventTrace)
	self:HandleResizeButton(_G.EventTrace.ResizeButton)
end
