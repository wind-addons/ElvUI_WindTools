local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:WorldMapFrame()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.worldmap) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.worldMap) then return end

    S:CreateBackdropShadow(_G.WorldMapFrame)

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
        if QuestMapFrame.DetailsFrame.RewardsFrame.backdrop then
            QuestMapFrame.DetailsFrame.RewardsFrame.backdrop:SetTemplate("Transparent")
        elseif QuestMapFrame.DetailsFrame.RewardsFrame then
            QuestMapFrame.DetailsFrame.RewardsFrame:CreateBackdrop("Transparent")
        end
    end
end

S:AddCallback('WorldMapFrame')