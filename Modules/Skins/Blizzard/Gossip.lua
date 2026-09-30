local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallback("GossipFrame", "gossip")

function S:GossipFrame()
	self:CreateShadow(_G.GossipFrame)
	self:CreateShadow(_G.ItemTextFrame)
end
