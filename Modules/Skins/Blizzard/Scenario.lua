local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:ScenarioStage_CustomizeBlock(stageBlock, scenarioType, widgetSetID, textureKitID)
    stageBlock.NormalBG:SetTexture("")
    stageBlock.FinalBG:SetTexture("")

    if not stageBlock.backdrop then
        stageBlock:CreateBackdrop("Transparent")
        stageBlock.backdrop:ClearAllPoints()
        stageBlock.backdrop:SetInside(stageBlock.GlowTexture, 4, 2)
        self:CreateShadow(stageBlock.backdrop)
    end
end

function S:ScenarioStageWidgetContainer()
    local contianer = _G.ScenarioStageBlock.WidgetContainer
    if not contianer or not contianer.widgetFrames then
        return
    end

    for _, widgetFrame in pairs(contianer.widgetFrames) do
        if widgetFrame.Frame then
            widgetFrame.Frame:SetAlpha(0)
        end

        local bar = widgetFrame.TimerBar

        if bar and not bar.windStyle then
            hooksecurefunc(bar, "SetStatusBarAtlas", function(frame)
                frame:SetStatusBarTexture(E.media.normTex)
                frame:SetStatusBarColor(unpack(E.media.rgbvaluecolor))
            end)
            bar:CreateBackdrop("Transparent")
            bar.windStyle = true
        end

        if widgetFrame.CurrencyContainer then
            for currencyFrame in widgetFrame.currencyPool:EnumerateActive() do
                if not currencyFrame.windStyle then
                    currencyFrame.Icon:SetTexCoord(unpack(E.TexCoords))
                    currencyFrame.windStyle = true
                end
            end
        end
    end
end



function S:ScenarioStage()
    if not self:CheckDB(nil, "scenario") then
        return
    end

    self:SecureHook("ScenarioStage_CustomizeBlock")
    self:SecureHook(_G.SCENARIO_CONTENT_TRACKER_MODULE, "Update", "ScenarioStageWidgetContainer")
end

S:AddCallback("ScenarioStage")
