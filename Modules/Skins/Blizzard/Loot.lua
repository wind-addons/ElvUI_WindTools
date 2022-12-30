local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G
local pairs = pairs
local unpack = unpack

local C_LootHistory_GetNumItems = C_LootHistory.GetNumItems

function S:LootHistoryFrame_FullUpdate()
    local numItems = C_LootHistory_GetNumItems()
    for i = 1, numItems do
        local frame = _G.LootHistoryFrame.itemFrames[i]
        if frame and not frame.__windSkin then
            frame:SetWidth(256)
            F.SetFontWithDB(frame.WinnerRoll, E.private.WT.skins.rollResult)

            frame.ToggleButton:SetNormalTexture(E.Media.Textures.ArrowUp)
            frame.ToggleButton:SetPushedTexture("")
            frame.ToggleButton:SetDisabledTexture(E.Media.Textures.ArrowUp)
            frame.ToggleButton:SetHighlightTexture(E.Media.Textures.ArrowUp)

            local normalTex, disabledTex, pushedTex, highlightTex =
                frame.ToggleButton:GetNormalTexture(),
                frame.ToggleButton:GetDisabledTexture(),
                frame.ToggleButton:GetPushedTexture(),
                frame.ToggleButton:GetHighlightTexture()

            normalTex:SetRotation(ES.ArrowRotation.down)

            pushedTex:SetTexture("")
            pushedTex.SetTexture = E.noop
            pushedTex:Hide()

            highlightTex:SetRotation(ES.ArrowRotation.down)
            highlightTex:SetVertexColor(unpack(E.media.rgbvaluecolor))

            disabledTex:SetRotation(ES.ArrowRotation.down)
            disabledTex:SetAlpha(0.5)

            frame.ToggleButton.SetNormalTexture = function(self, texture)
                if texture == "Interface\\Buttons\\UI-MinusButton-UP" then
                    normalTex:SetRotation(ES.ArrowRotation.up)
                    self:SetHighlightTexture(nil, ES.ArrowRotation.up)
                elseif texture == "Interface\\Buttons\\UI-PlusButton-UP" then
                    normalTex:SetRotation(ES.ArrowRotation.down)
                    self:SetHighlightTexture(nil, ES.ArrowRotation.down)
                end
            end

            frame.ToggleButton.SetPushedTexture = E.noop

            frame.ToggleButton.SetDisabledTexture = function(self, texture)
                if texture == "Interface\\Buttons\\UI-MinusButton-Disabled" then
                    disabledTex:SetRotation(ES.ArrowRotation.up)
                elseif texture == "Interface\\Buttons\\UI-PlusButton-Disabled" then
                    disabledTex:SetRotation(ES.ArrowRotation.down)
                end
            end

            frame.ToggleButton.SetHighlightTexture = function(self, _, arrow)
                highlightTex:SetRotation(arrow)
            end

            frame.__windSkin = true
        end
    end

    for _, frame in pairs(_G.LootHistoryFrame.unusedPlayerFrames) do
        if frame and not frame.__windSkin then
            frame:SetWidth(256)
            F.SetFontWithDB(frame.RollText, E.private.WT.skins.rollResult)
            frame.__windSkin = true
        end
    end

    for _, frame in pairs(_G.LootHistoryFrame.usedPlayerFrames) do
        if frame and not frame.__windSkin then
            frame:SetWidth(256)
            F.SetFontWithDB(frame.RollText, E.private.WT.skins.rollResult)
            frame.__windSkin = true
        end
    end
end

function S:LootFrame()
    if not self:CheckDB("loot") then
        return
    end

    F.SetFontOutline(_G.BonusRollFrame.PromptFrame.InfoFrame.Cost)
    F.SetFontOutline(_G.BonusRollFrame.PromptFrame.InfoFrame.Label)

    self:CreateShadow(_G.BonusRollFrame)
    self:CreateBackdropShadow(_G.BonusRollLootWonFrame)
    self:CreateBackdropShadow(_G.BonusRollMoneyWonFrame)

    self:CreateShadow(_G.LootHistoryFrame)
    self:CreateShadow(_G.LootHistoryFrame.ResizeButton)

    _G.LootHistoryFrame.ResizeButton:SetTemplate("Transparent")
    _G.LootHistoryFrame:SetWidth(300)
    _G.LootHistoryFrame.ResizeButton:SetWidth(300)

    self:SecureHook("LootHistoryFrame_FullUpdate")
end

S:AddCallback("LootFrame")
