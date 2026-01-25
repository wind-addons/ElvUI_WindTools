local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local TT = E:GetModule("Tooltip")
local DT = E:GetModule("DataTexts")
local S = W.Modules.Skins ---@class Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local pcall = pcall
local type = type

-- Safe comparison that handles tainted/secret values
local function SafeNotEqual(a, b)
    if a == nil or b == nil then return false end
    local success, result = pcall(function() return a ~= b end)
    if success then
        return result
    end
    return false
end

local function styleIconsInLine(line, text)
    if not line then
        return
    end

    -- Get text with pcall protection for tainted values
    local success, lineText = pcall(function() return line:GetText() end)
    if not success then
        return
    end

    text = text or lineText

    -- Early exit if text is nil or not a string (handles secret values)
    if text == nil or type(text) ~= "string" then
        return
    end

    -- Style the text with protection
    local styledText = S:StyleTextureString(text)

    -- Validate styledText before comparison
    if styledText == nil or type(styledText) ~= "string" then
        return
    end

    -- Use safe comparison to handle any remaining tainted values
    if SafeNotEqual(styledText, text) then
        pcall(function() F.CallMethod(line, "SetText", styledText) end)
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

function S:StyleIconsInTooltip(tt)
    if tt:IsForbidden() or not tt.NumLines or not E.db.general.cropIcon then
        return
    end

    for i = 2, tt:NumLines() do
        styleIconsInLine(_G[tt:GetName() .. "TextLeft" .. i])
        styleIconsInLine(_G[tt:GetName() .. "TextRight" .. i])
    end

    for i = 1, 30 do
        local texture = _G[tt:GetName() .. "Texture" .. i] ---@type Texture?
        if texture and texture:IsShown() then
            self:TryCropTexture(texture)
        else
            break
        end
    end
end

---@param tt table GameTooltip like frame
function S:ReskinTooltip(tt)
    if not tt or (tt == E.ScanTooltip or tt.IsEmbedded or not tt.NineSlice) or tt:IsForbidden() then
        return
    end

    self:CreateShadow(tt)

    if tt.TopOverlay then
        tt.TopOverlay:StripTextures()
    end

    if tt.BottomOverlay then
        tt.BottomOverlay:StripTextures()
    end

    local CompareHeader = tt.CompareHeader
    if CompareHeader and not CompareHeader.__windSkin then
        CompareHeader:SetTemplate("Transparent")
        self:CreateShadow(CompareHeader)
        F.Move(CompareHeader, 0, 2)
        F.SetFont(CompareHeader.Label)
        CompareHeader.__windSkin = true
    end

    if not self:IsHooked(tt, "Show") then
        StyleTooltipWidgetContainer(tt)
        self:SecureHook(tt, "Show", "StyleIconsInTooltip")
    end
end

function S:TooltipFrames()
    if not self:CheckDB("tooltip", "tooltips") then
        return
    end

    -- Tooltip list from ElvUI
    local tooltips = {
        _G.ItemRefTooltip,
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

S:AddCallback("TooltipFrames")
