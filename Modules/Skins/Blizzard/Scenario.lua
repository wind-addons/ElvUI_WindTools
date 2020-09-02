local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:ScenarioStage_CustomizeBlock(stageBlock, scenarioType, widgetSetID, textureKitID)
    if widgetSetID then
        return
    end
    if not stageBlock.backdrop then
        stageBlock:CreateBackdrop("Transparent")
    end

    stageBlock.NormalBG:StripTextures()
    stageBlock.backdrop:SetPoint("TOPLEFT", stageBlock.NormalBG, "TOPLEFT", 4, -4)
    stageBlock.backdrop:SetPoint("BOTTOMRIGHT", stageBlock.NormalBG, "BOTTOMRIGHT", -4, 4)
    self:CreateShadow(stageBlock.backdrop)
end

function S:ScenarioStage()
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.scenario) then
        return
    end

    S:SecureHook("ScenarioStage_CustomizeBlock")
end

S:AddCallback("ScenarioStage")
