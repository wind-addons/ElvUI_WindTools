local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:HelpFrame()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.help) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.help) then return end

    S:CreateShadow(_G.HelpFrame)
    S:CreateShadow(_G.HelpFrame.Header)
    _G.HelpFrame.Header.backdrop:SetTemplate("Transparent")
end

S:AddCallback('HelpFrame')