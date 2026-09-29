local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_EventTrace")
data.toggle = "eventLog"
data.private = "eventTrace"

local _G = _G

function S:Blizzard_EventTrace()
	self:CreateBackdropShadow(_G.EventTrace)
	self:HandleResizeButton(_G.EventTrace.ResizeButton)
end

