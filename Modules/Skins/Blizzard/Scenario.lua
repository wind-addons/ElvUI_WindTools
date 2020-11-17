local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:ScenarioStage_CustomizeBlock(stageBlock, scenarioType, widgetSetID, textureKitID)
    if widgetSetID then
        return
    end

    if not stageBlock.backdrop then
        stageBlock:CreateBackdrop("Transparent")
        self:CreateBackdropShadow(stageBlock)
    end

    stageBlock.NormalBG:StripTextures()
    stageBlock.FinalBG:StripTextures()
    stageBlock.backdrop:ClearAllPoints()
    stageBlock.backdrop:Point("TOPLEFT", stageBlock.NormalBG, "TOPLEFT", 4, -4)
    stageBlock.backdrop:Point("BOTTOMRIGHT", stageBlock.NormalBG, "BOTTOMRIGHT", -20, 6)
end

function S:ScenarioStage()
    if not self:CheckDB(nil, "scenario") then
        return
    end

    self:SecureHook("ScenarioStage_CustomizeBlock")
end

S:AddCallback("ScenarioStage")
