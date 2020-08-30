local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:GossipFrame()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.gossip) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.gossip) then
        return
    end

    S:CreateShadow(_G.ItemTextFrame)
    S:CreateShadow(_G.GossipFrame)
end

S:AddCallback("GossipFrame")
