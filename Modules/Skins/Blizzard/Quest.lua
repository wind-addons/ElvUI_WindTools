local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:BlizzardQuestFrames()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.quest) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.quest) then
        return
    end

    S:CreateShadow(_G.QuestFrame)
    S:CreateShadow(_G.QuestModelScene)

    F.SetFontOutline(QuestNPCModelNameText)
end

S:AddCallback("BlizzardQuestFrames")
