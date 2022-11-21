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
    self:ESProxy("HandleButton", _G.TomCats_ConfigDiscoveries.discoveriesButton)
    self:ESProxy("HandleButton", _G.TomCats_ConfigDiscoveries.discoveriesResetCounterButton)
    self:ESProxy("HandleSliderFrame", _G.TomCats_ConfigIconSizeSlider)
    self:ESProxy("HandleCheckBox", _G.TomCats_Config.checkBox_betaFeatures)
    self:ESProxy("HandleCheckBox", _G.TomCats_Config.checkBox_loveIsInTheAirMinimapButton)
    self:ESProxy("HandleCheckBox", _G.TomCats_Config.checkBox_lunarFestivalMinimapButton)
    self:ESProxy("HandleCheckBox", _G.TomCats_Config.checkBox_mapIconAnimation)
    self:ESProxy("HandleCheckBox", _G.TomCats_Config.checkBox_minimapButton)
    self:ESProxy("HandleCheckBox", _G.TomCats_Config.checkBox_primalStorms)
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

local function IsStormVendor()
    local stormVendors = {
        [195899] = true,
        [195912] = true
    }

    local guid = UnitGUID("NPC")
    if guid then
        local creatureID = select(6, strsplit("-", guid))
        return creatureID and stormVendors[tonumber(creatureID)]
    end

    return false
end

do
    local primalStormsTransmogFrame
    function S:TomCats_PrimalStormsTransmogFrame()
        if IsStormVendor() then
            if not primalStormsTransmogFrame then
                for _, frame in pairs({_G.UIParent:GetChildren()}) do
                    if not primalStormsTransmogFrame then
                        if frame and frame.title and frame.icon and frame.headerBar and frame.items then
                            primalStormsTransmogFrame = frame
                        end
                    end
                end
            end

            if not primalStormsTransmogFrame then
                return
            end

            if not primalStormsTransmogFrame.__windSkin then
                primalStormsTransmogFrame:ClearAllPoints()
                primalStormsTransmogFrame:SetPoint("TOPLEFT", MerchantFrame, "TOPRIGHT", 4, 0)

                if not primalStormsTransmogFrame.MoveFrame then
                    if E.private.WT.misc.moveFrames.enable and not W.Modules.MoveFrames.StopRunning then
                        local MF = W.Modules.MoveFrames
                        MF:HandleFrame(primalStormsTransmogFrame, MerchantFrame)
                    end
                end

                if primalStormsTransmogFrame.icon then
                    if primalStormsTransmogFrame.icon.Background then
                        primalStormsTransmogFrame.icon.Background:SetAlpha(0)
                    end

                    if primalStormsTransmogFrame.icon.Border then
                        primalStormsTransmogFrame.icon.Border:SetAlpha(0)
                    end

                    if primalStormsTransmogFrame.icon.logo then
                        primalStormsTransmogFrame.icon.logo:ClearAllPoints()
                        primalStormsTransmogFrame.icon.logo:SetPoint("CENTER", primalStormsTransmogFrame, "BOTTOM")
                    end

                    primalStormsTransmogFrame.icon.__windSkin = true
                end

                if primalStormsTransmogFrame.headerBar then
                    primalStormsTransmogFrame.headerBar:SetAlpha(0)
                end

                if primalStormsTransmogFrame.footerBar then
                    primalStormsTransmogFrame.footerBar:SetAlpha(0)
                end

                if primalStormsTransmogFrame.title then
                    F.SetFontOutline(primalStormsTransmogFrame.title)
                end

                primalStormsTransmogFrame:SetTemplate("Transparent")
                self:CreateShadow(primalStormsTransmogFrame)
            end

            if primalStormsTransmogFrame.items then
                for _, item in pairs(primalStormsTransmogFrame.items) do
                    if item and not item.__windSkin then
                        if item.itemLabel then
                            F.SetFontOutline(item.itemLabel)
                        end
                        if item.button then
                            self:ESProxy("HandleButton", item.button)
                        end

                        item.__windSkin = true
                    end
                end
            end
        end
    end
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

    local primalStormsFrame
    for _, frame in pairs({_G.UIParent:GetChildren()}) do
        if not primalStormsFrame then
            if frame and frame.title and frame.icon and frame.headerBar and frame.footerBar then
                primalStormsFrame = frame
            end
        end
    end

    if primalStormsFrame then
        if primalStormsFrame.icon then
            if primalStormsFrame.icon.Background then
                primalStormsFrame.icon.Background:SetAlpha(0)
            end

            if primalStormsFrame.icon.Border then
                primalStormsFrame.icon.Border:SetAlpha(0)
            end

            if primalStormsFrame.icon.logo then
                primalStormsFrame.icon.logo:ClearAllPoints()
                primalStormsFrame.icon.logo:SetPoint("CENTER", primalStormsFrame, "BOTTOM")
            end
        end

        if primalStormsFrame.headerBar then
            primalStormsFrame.headerBar:SetAlpha(0)
        end

        if primalStormsFrame.footerBar then
            primalStormsFrame.footerBar:SetAlpha(0)
        end

        if primalStormsFrame.title then
            F.SetFontOutline(primalStormsFrame.title)
        end

        primalStormsFrame:SetTemplate("Transparent")
        self:CreateShadow(primalStormsFrame)
    end

    self:SecureHookScript(MerchantFrame, "OnShow", "TomCats_PrimalStormsTransmogFrame")
end

S:AddCallbackForAddon("TomCats")
