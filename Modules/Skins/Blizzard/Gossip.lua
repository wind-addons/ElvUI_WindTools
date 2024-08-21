local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:GossipFrame()
	if not self:CheckDB("gossip") then
		return
	end

	self:CreateShadow(_G.GossipFrame)
	self:CreateShadow(_G.ItemTextFrame)
end

S:AddCallback("GossipFrame")
