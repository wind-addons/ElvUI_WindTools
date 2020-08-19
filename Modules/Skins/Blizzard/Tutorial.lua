local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_BarbershopUI()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.tutorials) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.tutorial) then
        return
    end

    S:CreateShadow(_G.TutorialFrame)
end

S:AddCallback('TutorialFrame')
