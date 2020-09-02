local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:BlizzardQuestFrames()
    if not self:CheckDB("quest") then
        return
    end

    self:CreateShadow(_G.QuestFrame)
    self:CreateShadow(_G.QuestModelScene)

    F.SetFontOutline(_G.QuestNPCModelNameText)
end

S:AddCallback("BlizzardQuestFrames")
