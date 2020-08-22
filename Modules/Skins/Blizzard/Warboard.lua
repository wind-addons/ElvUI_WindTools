local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_WarboardUI()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.Warboard) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.warboard) then
        return
    end

    S:CreateShadow(_G.WarboardQuestChoiceFrame)
end

S:AddCallbackForAddon("Blizzard_WarboardUI")
