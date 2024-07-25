local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

local hooksecurefunc = hooksecurefunc
local pairs = pairs
local select = select
local unpack = unpack

local C_ChallengeMode_GetAffixInfo = C_ChallengeMode.GetAffixInfo
local scenarioStageBlock

local function SkinMawBuffsContainer(container)
    container:StripTextures()
    container:GetHighlightTexture():Kill()
    container:GetPushedTexture():Kill()
    local pushed = container:CreateTexture()
    S:Reposition(pushed, container, 0, -11, -11, -17, -4)
    pushed:SetBlendMode("ADD")
    local vr, vg, vb = unpack(E.media.rgbvaluecolor)
    pushed:SetColorTexture(vr, vg, vb, 0.2)
    container:SetPushedTexture(pushed)
    container.SetHighlightAtlas = E.noop
    container.SetPushedAtlas = E.noop
    container.SetWidth = E.noop
    container.SetPushedTextOffset = E.noop

    container:CreateBackdrop("Transparent")
    S:Reposition(container.backdrop, container, 1, -10, -10, -16, -3)
    S:CreateBackdropShadow(container)

    local blockList = container.List
    blockList:StripTextures()
    blockList:CreateBackdrop("Transparent")
    S:Reposition(blockList.backdrop, blockList, 1, -11, -11, -6, -6)
    S:CreateBackdropShadow(blockList)
end

local function ScenarioObjectiveTrackerStage_UpdateStageBlock(block)
    block.NormalBG:SetTexture("")
    block.FinalBG:SetTexture("")

    if not block.backdrop then
        block:CreateBackdrop("Transparent")
        block.backdrop:ClearAllPoints()
        block.backdrop:SetInside(block.GlowTexture, 4, 2)
        S:CreateShadow(block.backdrop)
    end
end

local function ScenarioObjectiveTrackerChallengeMode_SetUpAffixes(block)
    for frame in block.affixPool:EnumerateActive() do
        if not frame.__windSkin and frame.affixID then
            frame.Border:SetAlpha(0)
            local texPath = select(3, C_ChallengeMode_GetAffixInfo(frame.affixID))
            frame:CreateBackdrop("Transparent")
            frame.backdrop:ClearAllPoints()
            frame.backdrop:SetOutside(frame.Portrait)
            frame.Portrait:SetTexture(texPath)
            frame.Portrait:SetTexCoord(unpack(E.TexCoords))
            frame.__windSkin = true
        end
    end
end

local function ScenarioObjectiveTrackerChallengeMode_Activate(block)
    if block.__windSkin then
        return
    end

    -- Block background
    block.TimerBG:Hide()
    block.TimerBGBack:Hide()

    block:CreateBackdrop("Transparent")
    block.backdrop:ClearAllPoints()
    block.backdrop:SetInside(block, 6, 2)
    S:CreateBackdropShadow(block)

    -- Time bar
    block.StatusBar:CreateBackdrop()
    block.StatusBar.backdrop:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.6)
    block.StatusBar:SetStatusBarTexture(E.media.normTex)
    block.StatusBar:SetStatusBarColor(unpack(E.media.rgbvaluecolor))
    block.StatusBar:SetHeight(12)

    select(3, block:GetRegions()):Hide()

    block.__windSkin = true
end

local function ScenarioObjectiveTracker_AddBlock(_, block)
    if block then
        -- Stage block
        if block.Stage and block.WidgetContainer then
            scenarioStageBlock = block
            if not block.__windHooked then
                hooksecurefunc(block, "UpdateStageBlock", ScenarioObjectiveTrackerStage_UpdateStageBlock)
                block.__windHooked = true
            end
        end

        -- Challenge mode block
        if block.DeathCount and not block.__windHooked then
            hooksecurefunc(block, "Activate", ScenarioObjectiveTrackerChallengeMode_Activate)
            hooksecurefunc(block, "SetUpAffixes", ScenarioObjectiveTrackerChallengeMode_SetUpAffixes)
            if block:IsActive() then
                ScenarioObjectiveTrackerChallengeMode_Activate(block)
                ScenarioObjectiveTrackerChallengeMode_SetUpAffixes(block)
            end
            block.__windHooked = true
        end
    end
end

local function ScenarioObjectiveTracker_Update(_, block)
    local contianer = scenarioStageBlock and scenarioStageBlock.WidgetContainer
    if not contianer or not contianer.widgetFrames then
        return
    end

    for _, widgetFrame in pairs(contianer.widgetFrames) do
        if widgetFrame.Frame then
            widgetFrame.Frame:SetAlpha(0)
        end

        local bar = widgetFrame.TimerBar

        if bar and not bar.__windSkin then
            bar.__SetStatusBarTexture = bar.SetStatusBarTexture
            hooksecurefunc(
                bar,
                "SetStatusBarTexture",
                function(frame)
                    if frame.__SetStatusBarTexture then
                        frame:__SetStatusBarTexture(E.media.normTex)
                        frame:SetStatusBarColor(unpack(E.media.rgbvaluecolor))
                    end
                end
            )
            bar:CreateBackdrop("Transparent")
            bar.__windSkin = true
        end

        if widgetFrame.CurrencyContainer then
            for currencyFrame in widgetFrame.currencyPool:EnumerateActive() do
                if not currencyFrame.__windSkin then
                    currencyFrame.Icon:SetTexCoord(unpack(E.TexCoords))
                    currencyFrame.__windSkin = true
                end
            end
        end
    end
end

function S:ScenarioStage()
    if not self:CheckDB(nil, "scenario") then
        return
    end

    hooksecurefunc(_G.ScenarioObjectiveTracker, "Update", ScenarioObjectiveTracker_Update)
    hooksecurefunc(_G.ScenarioObjectiveTracker, "AddBlock", ScenarioObjectiveTracker_AddBlock)
    SkinMawBuffsContainer(_G.ScenarioObjectiveTracker.MawBuffsBlock.Container)
end

S:AddCallback("ScenarioStage")
