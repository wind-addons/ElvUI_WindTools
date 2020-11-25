local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:BlizzardQuestFrames()
    if not self:CheckDB("quest") then
        return
    end

    self:CreateBackdropShadow(_G.QuestFrame)
    self:CreateBackdropShadow(_G.QuestModelScene)
    self:CreateBackdropShadow(_G.QuestLogPopupDetailFrame)

    F.SetFontOutline(_G.QuestNPCModelNameText)
end

S:AddCallback("BlizzardQuestFrames")
