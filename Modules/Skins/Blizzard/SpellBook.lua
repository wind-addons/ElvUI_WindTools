local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local MAX_SKILLLINE_TABS = MAX_SKILLLINE_TABS

function S:SpellBookFrame()
    if not self:CheckDB("spellbook", "spellBook") then
        return
    end

    self:CreateShadow(_G.SpellBookFrame)

    for i = 1, 5 do
        self:ReskinTab(_G["SpellBookFrameTabButton" .. i])
    end

    for i = 1, MAX_SKILLLINE_TABS do
        self:CreateShadow(_G["SpellBookSkillLineTab" .. i])
    end
end

S:AddCallback("SpellBookFrame")
