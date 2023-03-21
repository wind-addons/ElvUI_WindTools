local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

function S:BlizzardQuestFrames()
    if not self:CheckDB("quest") then
        return
    end

    self:CreateShadow(_G.QuestFrame)
    self:CreateShadow(_G.QuestModelScene)
    self:CreateShadow(_G.QuestLogPopupDetailFrame)

    F.SetFontOutline(_G.QuestNPCModelNameText)
    self:CreateShadow(_G.QuestNPCModelTextFrame)
end

S:AddCallback("BlizzardQuestFrames")
