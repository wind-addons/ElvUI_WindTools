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
    stageBlock.backdrop:ClearAllPoints()
    stageBlock.backdrop:Point("TOPLEFT", stageBlock.NormalBG, "TOPLEFT", 4, -6)
    stageBlock.backdrop:Point("BOTTOMRIGHT", stageBlock.NormalBG, "BOTTOMRIGHT", -8, 8)
    self:CreateShadow(stageBlock.backdrop)
end

function S:ScenarioStage()
    if not self:CheckDB(nil, "scenario") then
        return
    end

    self:SecureHook("ScenarioStage_CustomizeBlock")
end

S:AddCallback("ScenarioStage")
