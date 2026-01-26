local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local TT = E:GetModule("Tooltip")
local DT = E:GetModule("DataTexts")
local S = W.Modules.Skins ---@class Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local type = type

local function styleIconsInLine(line, text)
    if not line then
        return
    end

    -- Get text, checking for secret values first
    local lineText = line:GetText()
    if E:IsSecretValue(lineText) then
        return
    end

    text = text or lineText

    -- Early exit if text is nil or not a string
    if text == nil or type(text) ~= "string" then
        return
    end

    -- Style the text
    local styledText = S:StyleTextureString(text)

    -- Validate styledText before comparison
    if styledText == nil or type(styledText) ~= "string" then
        return
    end

    -- Check if styledText is a secret value before comparison
    if E:IsSecretValue(styledText) then
        return
    end

    if styledText ~= text then
        F.CallMethod(line, "SetText", styledText)
    end
end

local function StyleTooltipWidgetContainer(tt)
    if not tt or (tt == E.ScanTooltip or tt.IsEmbedded or not tt.NineSlice) or tt:IsForbidden() then
        return
    end

    if not tt.widgetContainer or not tt.widgetContainer.widgetPools then
        return
    end

    for frame in tt.widgetContainer.widgetPools:EnumerateActive() do
        if not frame.__windSkin then
            if frame.Text then
                F.InternalizeMethod(frame.Text, "SetText")
                hooksecurefunc(frame.Text, "SetText", styleIconsInLine)
                F.SetFont(frame.Text)
                frame.Text:SetText(frame.Text:GetText())
            end

            frame.__windSkin = true
        end
    end
end

function S:ReskinTooltip(tt)
    if not tt or (tt == E.ScanTooltip or tt.IsEmbedded or not tt.NineSlice) or tt:IsForbidden() then
        return
    end

    if tt.__windSkin then
        return
    end

    -- Tooltip lines
    for i = 1, tt:GetNumRegions() do
        local region = select(i, tt:GetRegions())
        if region:GetObjectType() == "FontString" then
            F.InternalizeMethod(region, "SetText")
            hooksecurefunc(region, "SetText", styleIconsInLine)
            F.SetFont(region)
        end
    end

    -- TextLeft and TextRight
    for _, key in pairs { "TextLeft", "TextRight" } do
        for i = 1, 50 do
            local line = _G[tt:GetName() .. key .. i]
            if line then
                F.InternalizeMethod(line, "SetText")
                hooksecurefunc(line, "SetText", styleIconsInLine)
                F.SetFont(line)
            end
        end
    end

    tt.__windSkin = true
end

function S:Tooltips()
    if not self:CheckDB("tooltips", "tooltipIcons") and not self:CheckDB("tooltips", "tooltipFont") then
        return
    end

    local tooltips = {
        -- Blizzard
        _G.GameTooltip,
        _G.ItemRefTooltip,
        _G.ItemRefShoppingTooltip1,
        _G.ItemRefShoppingTooltip2,
        _G.AutoCompleteBox,
        _G.FriendsTooltip,
        _G.FloatingBattlePetTooltip,
        _G.FloatingPetBattleAbilityTooltip,
        _G.FloatingGarrisonFollowerAbilityTooltip,
        _G.GarrisonFollowerAbilityWithoutCountersTooltip,
        _G.IMECandidatesFrame,
        _G.PetBattlePrimaryAbilityTooltip,
        _G.PetBattlePrimaryUnitTooltip,
        _G.QueueStatusFrame,
        _G.QuestScrollFrame and _G.QuestScrollFrame.StoryTooltip,
        _G.QuestScrollFrame and _G.QuestScrollFrame.CampaignTooltip,
        _G.DropDownList1MenuBackdrop,
        _G.DropDownList2MenuBackdrop,
        _G.ItemRefShoppingTooltip1,
        _G.ItemRefShoppingTooltip2,
        _G.FriendsTooltip,
        _G.EmbeddedItemTooltip,
        _G.ReputationParagonTooltip,
        _G.GameTooltip,
        _G.WorldMapTooltip,
        _G.ShoppingTooltip1,
        _G.ShoppingTooltip2,
        _G.QuickKeybindTooltip,
        -- ours
        E.ConfigTooltip,
        E.SpellBookTooltip,
        DT.tooltip,
        -- libs
        _G.LibDBIconTooltip,
        _G.SettingsTooltip,
    }

    for _, tt in pairs(tooltips) do
        if tt and not tt.IsEmbedded and not tt:IsForbidden() then
            self:ReskinTooltip(tt)
        end
    end

    self:SecureHook(TT, "SetStyle", function(_, tt, _, isEmbedded)
        if not isEmbedded then
            self:ReskinTooltip(tt)
        end
    end)

    hooksecurefunc("GameTooltip_AddWidgetSet", StyleTooltipWidgetContainer)

    self:SecureHook(_G.QueueStatusFrame, "Update", "CreateShadow")
    self:CreateBackdropShadow(_G.GameTooltipStatusBar)

    self:SecureHook(TT, "GameTooltip_SetDefaultAnchor", function(_, tt)
        if tt.StatusBar and tt.StatusBar.backdrop then
            self:CreateBackdropShadow(tt.StatusBar)
        end
    end)
end
