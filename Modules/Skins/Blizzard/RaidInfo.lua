local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:RaidInfoFrame()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.nonraid) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.raidInfo) then return end

    S:CreateShadow(_G.RaidInfoFrame)
end

S:AddCallback('RaidInfoFrame')