local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:WorldMapFrame()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.worldmap) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.worldmap) then return end

    S:CreateTabShadow(_G.WorldMapFrame)

    local QuestScrollFrame = _G.QuestScrollFrame
    if QuestScrollFrame.Background then QuestScrollFrame.Background:Kill() end
    if QuestScrollFrame.DetailFrame and QuestScrollFrame.DetailFrame.backdrop then
        QuestScrollFrame.DetailFrame.backdrop:SetTemplate("Transparent")
    end

    local QuestMapFrame = _G.QuestMapFrame
    if QuestMapFrame.DetailsFrame then
        if QuestMapFrame.DetailsFrame.backdrop then
            QuestMapFrame.DetailsFrame.backdrop:SetTemplate("Transparent")
        end
        if QuestMapFrame.DetailsFrame.RewardsFrame then
            QuestMapFrame.DetailsFrame.RewardsFrame:SetTemplate("Transparent")
        end
    end
end

S:AddCallback('WorldMapFrame')