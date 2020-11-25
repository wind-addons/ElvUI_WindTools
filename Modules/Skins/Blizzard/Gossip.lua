local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:GossipFrame()
    if not self:CheckDB("gossip") then
        return
    end

    self:CreateBackdropShadow(_G.GossipFrame)
    self:CreateBackdropShadow(_G.ItemTextFrame)
end

S:AddCallback("GossipFrame")
