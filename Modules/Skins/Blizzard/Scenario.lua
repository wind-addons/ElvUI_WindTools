local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

local hooksecurefunc = hooksecurefunc
local pairs = pairs
local select = select
local unpack = unpack

local C_ChallengeMode_GetAffixInfo = C_ChallengeMode.GetAffixInfo

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

function S:Scenario_ChallengeMode_ShowBlock()
    local block = _G.ScenarioChallengeModeBlock

    if not block then
        return
    end

    -- Affix icon
    for _, child in pairs {block:GetChildren()} do
        if not child.windStyle and child.affixID then
            child.Border:SetAlpha(0)
            local texPath = select(3, C_ChallengeMode_GetAffixInfo(child.affixID))
            child:CreateBackdrop("Transparent")
            child.backdrop:ClearAllPoints()
            child.backdrop:SetOutside(child.Portrait)
            child.Portrait:SetTexture(texPath)
            child.Portrait:SetTexCoord(unpack(E.TexCoords))
            child.windStyle = true
        end
    end

    if block.windStyle then
        return
    end
    
    -- Block background
    block.TimerBG:Hide()
    block.TimerBGBack:Hide()

    block:CreateBackdrop("Transparent")
    block.backdrop:ClearAllPoints()
    block.backdrop:SetInside(block, 6, 2)
    self:CreateBackdropShadow(block)

    -- Time bar
    block.StatusBar:CreateBackdrop()
    block.StatusBar.backdrop:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.6)
    block.StatusBar:SetStatusBarTexture(E.media.normTex)
    block.StatusBar:SetStatusBarColor(unpack(E.media.rgbvaluecolor))
    block.StatusBar:SetHeight(10)

    select(3, block:GetRegions()):Hide()

    block.windStyle = true
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
    self:SecureHook("Scenario_ChallengeMode_ShowBlock")
    self:SecureHook(_G.SCENARIO_CONTENT_TRACKER_MODULE, "Update", "ScenarioStageWidgetContainer")
    self:SkinMawBuffsContainer(_G.ScenarioBlocksFrame.MawBuffsBlock.Container)
    self:SkinMawBuffsContainer(_G.MawBuffsBelowMinimapFrame.Container)
end

S:AddCallback("ScenarioStage")
