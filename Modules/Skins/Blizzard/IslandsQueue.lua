local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_IslandsQueueUI")
data.toggle = "tooltip"

local _G = _G

function S:Blizzard_IslandsQueueUI()
	self:CreateShadow(_G.IslandsQueueFrameTooltip:GetParent())
end

