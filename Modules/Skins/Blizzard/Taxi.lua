local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:TaxiFrame()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.taxi) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.taxi) then
        return
    end

    S:CreateShadow(_G.TaxiFrame)
end

S:AddCallback("TaxiFrame")
