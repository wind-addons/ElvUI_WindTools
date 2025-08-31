local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_IslandsQueueUI()
	if not self:CheckDB("tooltip") then
		return
	end

	self:CreateShadow(_G.IslandsQueueFrameTooltip:GetParent())
end

S:AddCallbackForAddon("Blizzard_IslandsQueueUI")
