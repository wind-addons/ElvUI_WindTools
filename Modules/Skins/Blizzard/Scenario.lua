local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:SkinMawBuffsContainer(container)
    container:StripTextures()
    container:GetHighlightTexture():Kill()
    container:GetPushedTexture():Kill()
    local pushed = container:CreateTexture()
    self:Reposition(pushed, container, 0, -11, -11, -17, -4)
    pushed:SetBlendMode("ADD")
    local vr, vg, vb = unpack(E.media.rgbvaluecolor)
    pushed:SetColorTexture(vr, vg, vb, 0.2)
    container:SetPushedTexture(pushed)
    container.SetHighlightAtlas = E.noop
    container.SetPushedAtlas = E.noop
    container.SetWidth = E.noop
    container.SetPushedTextOffset = E.noop

    container:CreateBackdrop("Transparent")
    self:Reposition(container.backdrop, container, 1, -10, -10, -16, -3)
    self:CreateBackdropShadow(container)

    local blockList = container.List
    blockList:StripTextures()
    blockList:CreateBackdrop("Transparent")
    self:Reposition(blockList.backdrop, blockList, 1, -11, -11, -6, -6)
    self:CreateBackdropShadow(blockList)
end

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
            hooksecurefunc(
                bar,
                "SetStatusBarAtlas",
                function(frame)
                    frame:SetStatusBarTexture(E.media.normTex)
                    frame:SetStatusBarColor(unpack(E.media.rgbvaluecolor))
                end
            )
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
    self:SkinMawBuffsContainer(ScenarioBlocksFrame.MawBuffsBlock.Container)
    self:SkinMawBuffsContainer(MawBuffsBelowMinimapFrame.Container)
end

S:AddCallback("ScenarioStage")
