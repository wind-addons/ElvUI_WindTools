local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:SpellBookFrame()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.spellbook) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.spellbook) then return end

    S:CreateShadow(_G.SpellBookFrame)
    for i = 1, 5 do S:CreateTabShadow(_G["SpellBookFrameTabButton" .. i]) end
    for i = 1, MAX_SKILLLINE_TABS do S:CreateTabShadow(_G["SpellBookSkillLineTab" .. i], true) end
end

S:AddCallback('SpellBookFrame')

