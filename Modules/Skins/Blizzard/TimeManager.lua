local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_TimeManager")
data.toggle = "timemanager"
data.private = "timeManager"

local _G = _G

function S:Blizzard_TimeManager()
	self:CreateShadow(_G.TimeManagerFrame)
	self:CreateBackdropShadow(_G.StopwatchFrame)
	_G.StopwatchTicker:ClearAllPoints()
	_G.StopwatchTicker:Point("BOTTOMRIGHT", _G.StopwatchFrame, "BOTTOMRIGHT", -49, 1)
end

