local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:SpellBookFrame()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.spellbook) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.spellBook) then
        return
    end

    S:CreateShadow(_G.SpellBookFrame)
    for i = 1, 5 do
        S:CreateBackdropShadow(_G["SpellBookFrameTabButton" .. i])
    end
    for i = 1, MAX_SKILLLINE_TABS do
        S:CreateShadow(_G["SpellBookSkillLineTab" .. i])
    end
end

S:AddCallback("SpellBookFrame")
