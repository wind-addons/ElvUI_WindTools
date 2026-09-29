local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("GossipFrame")
data.toggle = "gossip"

local _G = _G

function S:GossipFrame()
	self:CreateShadow(_G.GossipFrame)
	self:CreateShadow(_G.ItemTextFrame)
end

