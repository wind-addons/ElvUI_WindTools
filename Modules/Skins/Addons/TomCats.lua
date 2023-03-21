local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins
local ES = E.Skins
local TT = E:GetModule("Tooltip")

local _G = _G

local pairs = pairs
local select = select
local strsplit = strsplit
local tonumber = tonumber
local unpack = unpack

local GetItemQualityColor = GetItemQualityColor
local MerchantFrame = MerchantFrame
local UnitGUID = UnitGUID

local atlasToQuality = {
    ["auctionhouse-itemicon-border-gray"] = 0,
    ["auctionhouse-itemicon-border-white"] = 1,
    ["auctionhouse-itemicon-border-green"] = 2,
    ["auctionhouse-itemicon-border-blue"] = 3,
    ["auctionhouse-itemicon-border-purple"] = 4,
    ["auctionhouse-itemicon-border-orange"] = 5,
    ["auctionhouse-itemicon-border-artifact"] = 6,
    ["auctionhouse-itemicon-border-account"] = 8
}

function S:TomCats_Config()
    self:ESProxy("HandleButton", _G.TomCats_Config.discoveriesButton)
    self:ESProxy("HandleSliderFrame", _G.TomCats_ConfigIconSizeSlider)
    self:ESProxy("HandleCheckBox", _G.TomCats_Config.checkBox_minimapButton)
    self:ESProxy("HandleCheckBox", _G.TomCats_Config.checkBox_betaFeatures)
    self:ESProxy("HandleCheckBox", _G.TomCats_Config.checkBox_mapIconAnimation)
    self:ESProxy("HandleCheckBox", _G.TomCats_Config.checkBox_lunarFestivalMinimapButton)
    self:ESProxy("HandleCheckBox", _G.TomCats_Config.checkBox_loveIsInTheAirMinimapButton)
    self:ESProxy("HandleCheckBox", _G.TomCats_Config.checkBox_hallowsEndMinimapButton)
    self:ESProxy("HandleCheckBox", _G.TomCats_Config.checkBox_hallowsEndArrow)
    self:ESProxy("HandleCheckBox", _G.TomCats_Config.checkBox_hallowsEndAutomated)
end

function S:TomCats_HandleTomCatsIcon(icon)
    if not icon or not icon:IsShown() then
        return
    end

    if not icon.__windSkin then
        local maskNum = icon.Icon:GetNumMaskTextures()
        for i = maskNum, 1 do
            icon.Icon:RemoveMaskTexture(icon.Icon:GetMaskTexture(i))
        end

        self:ESProxy("HandleIcon", icon.Icon, true)
        icon.IconBorder:SetAlpha(0)
        icon.__windSkin = true
    end

    local atlas = icon.IconBorder:IsShown() and icon.IconBorder:GetAtlas()
    local quality = atlas and atlasToQuality[atlas]

    if quality then
        local r, g, b = GetItemQualityColor(quality)
        icon.Icon.backdrop:SetBackdropBorderColor(r, g, b)
    else
        icon.Icon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
    end

    if icon.CategoryIcon then
        icon.CategoryIcon:SetFrameLevel(icon:GetFrameLevel() + 2)
        self:TomCats_HandleTomCatsIcon(icon.CategoryIcon)
    end
end

function S:TomCats_SkinTooltipItems(tt, owner)
    for _, item in pairs(tt.Loot) do
        self:TomCats_HandleTomCatsIcon(item)
    end
end

function S:TomCats_HeaderCollapseButton_SetNormalAtlas(button, atlas)
    if atlas == "Campaign_HeaderIcon_Closed" then
        return button:SetNormalTexture(E.Media.Textures.PlusButton)
    elseif atlas == "Campaign_HeaderIcon_Open" then
        return button:SetNormalTexture(E.Media.Textures.MinusButton)
    end

    self.hooks[button].SetNormalAtlas(button, atlas)
end

function S:TomCats_HeaderCollapseButton_SetPushedAtlas(button, atlas)
    if atlas == "Campaign_HeaderIcon_ClosedPressed" then
        return button:SetPushedTexture(E.Media.Textures.PlusButton)
    elseif atlas == "Campaign_HeaderIcon_OpenPressed" then
        return button:SetPushedTexture(E.Media.Textures.MinusButton)
    end

    self.hooks[button].SetPushedAtlas(button, atlas)
end

function S:TomCats()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.tomCats then
        return
    end

    self:TomCats_Config()
    TT:SetStyle(_G.TomCatsVignetteTooltip)
    self:SecureHook(_G.TomCatsVignetteTooltip, "SetOwner", "TomCats_SkinTooltipItems")
    if _G.TomCatsVignettesSection and _G.TomCatsVignettesSection.Header then
        local header = _G.TomCatsVignettesSection.Header
        self:RawHook(header, "SetNormalAtlas", "TomCats_HeaderCollapseButton_SetNormalAtlas", true)
        self:RawHook(header, "SetPushedAtlas", "TomCats_HeaderCollapseButton_SetPushedAtlas", true)
        header:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
        header.SetHighlightTexture = E.noop
        header:SetSize(16, 16)
        header.topPadding = 16
        F.SetFontOutline(header.text)
    end
end

S:AddCallbackForAddon("TomCats")
