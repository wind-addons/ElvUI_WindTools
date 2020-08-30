local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_AzeriteEssenceUI()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.azeriteEssence) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.azeriteEssence) then
        return
    end

    S:CreateShadow(_G.AzeriteEssenceUI)
end

S:AddCallbackForAddon("Blizzard_AzeriteEssenceUI")
