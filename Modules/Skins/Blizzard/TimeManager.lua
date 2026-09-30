local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_TimeManager", nil, "timemanager", "timeManager")

function S:Blizzard_TimeManager()
	self:CreateShadow(_G.TimeManagerFrame)
	self:CreateBackdropShadow(_G.StopwatchFrame)
	_G.StopwatchTicker:ClearAllPoints()
	_G.StopwatchTicker:Point("BOTTOMRIGHT", _G.StopwatchFrame, "BOTTOMRIGHT", -49, 1)
end
