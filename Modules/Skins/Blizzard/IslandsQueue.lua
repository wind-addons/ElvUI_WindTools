local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_IslandsQueueUI()
	if not self:CheckDB("tooltip") then
		return
	end

	self:CreateShadow(_G.IslandsQueueFrameTooltip:GetParent())
end

S:AddCallbackForAddon("Blizzard_IslandsQueueUI")
