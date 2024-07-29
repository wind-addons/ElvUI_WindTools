local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local next = next
local pairs = pairs
local tostring = tostring
local unpack = unpack

-- modified from ElvUI Auction House Skin
local function HandleListIcon(frame)
    if not frame.tableBuilder then
        return
    end

    for i = 1, 22 do
        local row = frame.tableBuilder.rows[i]
        if row then
            for j = 1, 5 do
                local cell = row.cells and row.cells[j]
                if cell and cell.Icon then
                    if not cell.__windSkin then
                        S:ESProxy("HandleIcon", cell.Icon)

                        if cell.IconBorder then
                            cell.IconBorder:Kill()
                        end

                        cell.__windSkin = true
                    end
                end
            end
        end
    end
end

-- modified from ElvUI Auction House Skin
local function HandleHeaders(frame)
    local maxHeaders = frame.HeaderContainer:GetNumChildren()
    for i, header in next, {frame.HeaderContainer:GetChildren()} do
        if not header.__windSkin then
            header:DisableDrawLayer("BACKGROUND")

            if not header.backdrop then
                header:CreateBackdrop("Transparent")
            end

            header.__windSkin = true
        end

        if header.backdrop then
            header.backdrop:Point("BOTTOMRIGHT", i < maxHeaders and -5 or 0, -2)
        end
    end

    HandleListIcon(frame)
end

local function HandleTab(tab)
    S:ESProxy("HandleTab", tab)
    tab.Text:ClearAllPoints()
    tab.Text:SetPoint("CENTER", tab, "CENTER", 0, 0)
    tab.Text.__SetPoint = tab.Text.SetPoint
    tab.Text.SetPoint = E.noop
end

local function buyIconName(frame)
    S:ESProxy("HandleIcon", frame.Icon, true)
    S:ESProxy("HandleIconBorder", frame.QualityBorder, frame.Icon.backdrop)
end

local function viewGroup(frame)
    if frame.GroupTitle then
        frame.GroupTitle:StripTextures()
        S:ESProxy("HandleButton", frame.GroupTitle)
    end
end

local function viewItem(frame)
    if frame.Icon.GetNumPoints and frame.Icon:GetNumPoints() > 0 then
        local pointsCache = {}

        for i = 1, frame.Icon:GetNumPoints() do
            local point, relativeTo, relativePoint, xOfs, yOfs = frame.Icon:GetPoint(i)

            if relativePoint == "TOPLEFT" then
                xOfs = xOfs + 2
                yOfs = yOfs - 2
            elseif relativePoint == "BOTTOMRIGHT" then
                xOfs = xOfs - 2
                yOfs = yOfs + 2
            end

            pointsCache[i] = {point, relativeTo, relativePoint, xOfs, yOfs}
        end

        frame.Icon:ClearAllPoints()

        for i = 1, #pointsCache do
            local pointData = pointsCache[i]
            frame.Icon:SetPoint(pointData[1], pointData[2], pointData[3], pointData[4], pointData[5])
        end
    end

    frame.EmptySlot:SetTexture(nil)
    frame.EmptySlot:Hide()

    frame:GetHighlightTexture():SetTexture(E.Media.Textures.White8x8)
    frame:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.3)

    frame.IconSelectedHighlight:SetTexture(E.Media.Textures.White8x8)
    frame.IconSelectedHighlight:SetVertexColor(1, 1, 1, 0.4)

    frame:GetPushedTexture():SetTexture(E.Media.Textures.White8x8)
    frame:GetPushedTexture():SetVertexColor(1, 1, 0, 0.3)

    S:ESProxy("HandleIcon", frame.Icon, true)
    S:ESProxy("HandleIconBorder", frame.IconBorder, frame.Icon.backdrop)
end

local function configRadioButtonGroup(frame)
    for _, child in pairs(frame.radioButtons) do
        S:ESProxy("HandleRadioButton", child.RadioButton)
    end
end

local function configCheckbox(frame)
    S:ESProxy("HandleCheckBox", frame.CheckBox)
end

local function dropDownInternal(frame)
    S:ESProxy("HandleDropDownBox", frame)
end

local function keyBindingConfig(frame)
    S:ESProxy("HandleButton", frame.Button)
end

local function bagUse(frame)
    frame.View:CreateBackdrop("Transparent")
    S:ESProxy("HandleTrimScrollBar", frame.View.ScrollBar)

    for _, child in pairs({frame:GetChildren()}) do
        if child ~= frame.View then
            S:ESProxy("HandleButton", child)
        end
    end
end

local function configNumericInput(frame)
    S:ESProxy("HandleEditBox", frame.InputBox)
    frame.InputBox:SetTextInsets(0, 0, 0, 0)
end

local function configMoneyInput(frame)
    S:ESProxy("HandleEditBox", frame.MoneyInput.CopperBox)
    S:ESProxy("HandleEditBox", frame.MoneyInput.GoldBox)
    S:ESProxy("HandleEditBox", frame.MoneyInput.SilverBox)

    frame.MoneyInput.CopperBox:SetTextInsets(3, 0, 0, 0)
    frame.MoneyInput.GoldBox:SetTextInsets(3, 0, 0, 0)
    frame.MoneyInput.SilverBox:SetTextInsets(3, 0, 0, 0)

    frame.MoneyInput.CopperBox:SetHeight(24)
    frame.MoneyInput.GoldBox:SetHeight(24)
    frame.MoneyInput.SilverBox:SetHeight(24)

    frame.MoneyInput.CopperBox.Icon:ClearAllPoints()
    frame.MoneyInput.CopperBox.Icon:SetPoint("RIGHT", frame.MoneyInput.CopperBox, "RIGHT", -10, 0)
    frame.MoneyInput.GoldBox.Icon:ClearAllPoints()
    frame.MoneyInput.GoldBox.Icon:SetPoint("RIGHT", frame.MoneyInput.GoldBox, "RIGHT", -10, 0)
    frame.MoneyInput.SilverBox.Icon:ClearAllPoints()
    frame.MoneyInput.SilverBox.Icon:SetPoint("RIGHT", frame.MoneyInput.SilverBox, "RIGHT", -10, 0)
end

local function configMinMax(frame)
    S:ESProxy("HandleEditBox", frame.MinBox)
    S:ESProxy("HandleEditBox", frame.MaxBox)
end

local function filterKeySelector(frame)
    S:ESProxy("HandleDropDownBox", frame)
end

local function undercutScan(frame)
    for _, child in pairs({frame:GetChildren()}) do
        if child:IsObjectType("Button") then
            S:ESProxy("HandleButton", child)
        end
    end
end

local function saleItem(frame)
    frame.Icon:StripTextures()

    S:ESProxy("HandleIcon", frame.Icon.Icon, true)
    S:ESProxy("HandleIconBorder", frame.Icon.IconBorder, frame.Icon.Icon.backdrop)

    S:ESProxy("HandleButton", frame.MaxButton)
    frame.MaxButton:ClearAllPoints()
    frame.MaxButton:SetPoint("TOPLEFT", frame.Quantity, "TOPRIGHT", 0, 0)
    S:ESProxy("HandleButton", frame.PostButton)
    S:ESProxy("HandleButton", frame.SkipButton)

    for _, child in pairs({frame:GetChildren()}) do
        if child:IsObjectType("Button") and child.Icon then
            S:ESProxy("HandleButton", child)
        end
    end
end

local function bottomTabButtons(frame)
    for _, details in ipairs(_G.Auctionator.Tabs.State.knownTabs) do
        local tabButtonFrameName = "AuctionatorTabs_" .. details.name
        local tabButton = _G[tabButtonFrameName]

        if tabButton and not tabButton.__windSkin then
            S:ESProxy("HandleTab", tabButton, nil, "Transparent")
            S:ReskinTab(tabButton)
            tabButton.Text:SetWidth(tabButton:GetWidth())
            if details.tabOrder > 1 then
                local pointData = {tabButton:GetPoint(1)}
                pointData[4] = -5
                tabButton:ClearAllPoints()
                tabButton:SetPoint(unpack(pointData))
            end

            tabButton.__windSkin = true
        end
    end
end

local function sellingTabPricesContainer(frame)
    HandleTab(frame.CurrentPricesTab)
    HandleTab(frame.PriceHistoryTab)
    HandleTab(frame.YourHistoryTab)
end

local function resultsListing(frame)
    frame.ScrollArea:SetTemplate("Transparent")
    S:ESProxy("HandleTrimScrollBar", frame.ScrollArea.ScrollBar)

    HandleHeaders(frame)
    hooksecurefunc(frame, "UpdateTable", HandleHeaders)
end

local function shoppingTabFrame(frame)
    S:ESProxy("HandleButton", frame.NewListButton)
    S:ESProxy("HandleButton", frame.ImportButton)
    S:ESProxy("HandleButton", frame.ExportButton)
    S:ESProxy("HandleButton", frame.ExportCSV)

    frame.ShoppingResultsInset:StripTextures()
end

local function shoppingTabSearchOptions(frame)
    S:ESProxy("HandleEditBox", frame.SearchString)
    S:ESProxy("HandleButton", frame.ResetSearchStringButton)
    S:ESProxy("HandleButton", frame.SearchButton)
    S:ESProxy("HandleButton", frame.MoreButton)
    S:ESProxy("HandleButton", frame.AddToListButton)
end

local function shoppingTabContainer(frame)
    frame.Inset:StripTextures()
    frame.Inset:SetTemplate("Transparent")
    S:ESProxy("HandleTrimScrollBar", frame.ScrollBar)
end

local function shoppingTabContainerTabs(frame)
    HandleTab(frame.ListsTab)
    HandleTab(frame.RecentsTab)
end

local function sellingTab(frame)
    frame.BagInset:StripTextures()
    frame.HistoricalPriceInset:StripTextures()
end

local function cancellingFrame(frame)
    S:ESProxy("HandleEditBox", frame.SearchFilter)

    for _, child in pairs({frame:GetChildren()}) do
        if child:IsObjectType("Button") and child.Icon then
            S:ESProxy("HandleButton", child)
        end
    end

    frame.HistoricalPriceInset:StripTextures()
    frame.HistoricalPriceInset:SetTemplate("Transparent")
end

local function configTab(frame)
    frame.Bg:SetTexture(nil)
    frame.NineSlice:SetTemplate("Transparent")

    S:ESProxy("HandleButton", frame.OptionsButton)
    S:ESProxy("HandleButton", frame.ScanButton)

    S:ESProxy("HandleEditBox", frame.DiscordLink.InputBox)
    S:ESProxy("HandleEditBox", frame.BugReportLink.InputBox)
end

local function shoppingItem(frame)
    frame:StripTextures()
    frame:SetTemplate("Transparent")
    S:CreateShadow(frame)

    S:ESProxy("HandleEditBox", frame.SearchContainer.SearchString)
    S:ESProxy("HandleButton", frame.SearchContainer.ResetSearchStringButton)
    frame.SearchContainer.ResetSearchStringButton:SetSize(20, 20)
    frame.SearchContainer.ResetSearchStringButton:ClearAllPoints()
    frame.SearchContainer.ResetSearchStringButton:SetPoint("LEFT", frame.SearchContainer.SearchString, "RIGHT", 3, 0)
    S:ESProxy("HandleCheckBox", frame.SearchContainer.IsExact)

    S:ESProxy("HandleButton", frame.FilterKeySelector.ResetButton)
    frame.FilterKeySelector.ResetButton:SetSize(20, 20)
    frame.FilterKeySelector.ResetButton:ClearAllPoints()
    frame.FilterKeySelector.ResetButton:SetPoint("LEFT", frame.FilterKeySelector, "RIGHT", 0, 3)

    S:ESProxy("HandleButton", frame.LevelRange.ResetButton)
    frame.LevelRange.ResetButton:SetSize(20, 20)
    frame.LevelRange.ResetButton:ClearAllPoints()
    frame.LevelRange.ResetButton:SetPoint("LEFT", frame.LevelRange.MaxBox, "RIGHT", 3, 0)

    S:ESProxy("HandleButton", frame.ItemLevelRange.ResetButton)
    frame.ItemLevelRange.ResetButton:SetSize(20, 20)
    frame.ItemLevelRange.ResetButton:ClearAllPoints()
    frame.ItemLevelRange.ResetButton:SetPoint("LEFT", frame.ItemLevelRange.MaxBox, "RIGHT", 3, 0)

    S:ESProxy("HandleButton", frame.PriceRange.ResetButton)
    frame.PriceRange.ResetButton:SetSize(20, 20)
    frame.PriceRange.ResetButton:ClearAllPoints()
    frame.PriceRange.ResetButton:SetPoint("LEFT", frame.PriceRange.MaxBox, "RIGHT", 3, 0)

    S:ESProxy("HandleButton", frame.CraftedLevelRange.ResetButton)
    frame.CraftedLevelRange.ResetButton:SetSize(20, 20)
    frame.CraftedLevelRange.ResetButton:ClearAllPoints()
    frame.CraftedLevelRange.ResetButton:SetPoint("LEFT", frame.CraftedLevelRange.MaxBox, "RIGHT", 3, 0)

    S:ESProxy("HandleButton", frame.Finished)
    S:ESProxy("HandleButton", frame.Cancel)
    S:ESProxy("HandleButton", frame.ResetAllButton)
end

local function exportTextFrame(frame)
    frame:StripTextures()
    frame:SetTemplate("Transparent")
    S:CreateShadow(frame)

    S:ESProxy("HandleButton", frame.Close)
    S:ESProxy("HandleTrimScrollBar", frame.ScrollBar)
end

local function listExportFrame(frame)
    frame:StripTextures()
    frame:SetTemplate("Transparent")
    S:CreateShadow(frame)

    S:ESProxy("HandleButton", frame.SelectAll)
    S:ESProxy("HandleButton", frame.UnselectAll)
    S:ESProxy("HandleButton", frame.Export)
    S:ESProxy("HandleCloseButton", frame.CloseDialog)
    S:ESProxy("HandleTrimScrollBar", frame.ScrollBar)
end

local function listImportFrame(frame)
    frame:StripTextures()
    frame:SetTemplate("Transparent")
    S:CreateShadow(frame)

    S:ESProxy("HandleButton", frame.Import)
    S:ESProxy("HandleCloseButton", frame.CloseDialog)
    S:ESProxy("HandleTrimScrollBar", frame.ScrollBar)
end

local function splashFrame(frame)
    frame:StripTextures()
    frame:SetTemplate("Transparent")
    S:CreateShadow(frame)

    S:ESProxy("HandleCloseButton", frame.Close)
    S:ESProxy("HandleCheckBox", frame.HideCheckbox.CheckBox)
    S:ESProxy("HandleTrimScrollBar", frame.ScrollBar)

    if E.private.WT.misc.moveFrames.enable and not W.Modules.MoveFrames.StopRunning then
        W.Modules.MoveFrames:HandleFrame(frame)
    end
end

local function itemHistoryFrame(frame)
    frame:StripTextures()
    frame:SetTemplate("Transparent")
    S:CreateShadow(frame)

    S:ESProxy("HandleButton", frame.Close)
    S:ESProxy("HandleButton", frame.Dock)
end

local function configSellingFrame(frame)
    S:ESProxy("HandleButton", frame.UnhideAll)
end

local function craftingInfoObjectiveTrackerFrame(frame)
    S:ESProxy("HandleButton", frame.SearchButton)
end

local function craftingInfoProfessionsFrame(frame)
    S:ESProxy("HandleButton", frame.SearchButton)
end

local function buyCommodity(frame)
    S:ESProxy("HandleButton", frame.BackButton)
    frame:StripTextures()

    local container = frame.DetailsContainer
    if not container then
        return
    end

    S:ESProxy("HandleButton", container.BuyButton)
    S:ESProxy("HandleEditBox", container.Quantity)
    container.Quantity:SetTextInsets(0, 0, 0, 0)

    for _, child in pairs({frame:GetChildren()}) do
        if child:IsObjectType("Button") and child.iconAtlas and child.iconAtlas == "UI-RefreshButton" then
            S:ESProxy("HandleButton", child)
            break
        end
    end
end

local function tryPostHook(...)
    local frame, method, hookFunc = ...
    if frame and method and _G[frame] and _G[frame][method] then
        hooksecurefunc(
            _G[frame],
            method,
            function(frame, ...)
                if not frame.__windSkin then
                    hookFunc(frame, ...)
                    frame.__windSkin = true
                end
            end
        )
    else
        S:Log("debug", "Failed to hook: " .. tostring(frame) .. " " .. tostring(method))
    end
end

function S:Auctionator()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.auctionator then
        return
    end

    self:DisableAddOnSkin("Auctionator")

    -- widgets
    tryPostHook("AuctionatorBuyIconNameTemplateMixin", "SetItem", buyIconName)
    tryPostHook("AuctionatorGroupsViewGroupMixin", "SetName", viewGroup)
    tryPostHook("AuctionatorGroupsViewItemMixin", "SetItemInfo", viewItem)
    tryPostHook("AuctionatorConfigCheckboxMixin", "OnLoad", configCheckbox)
    tryPostHook("AuctionatorConfigHorizontalRadioButtonGroupMixin", "SetupRadioButtons", configRadioButtonGroup)
    tryPostHook("AuctionatorConfigMinMaxMixin", "OnLoad", configMinMax)
    tryPostHook("AuctionatorConfigMoneyInputMixin", "OnLoad", configMoneyInput)
    tryPostHook("AuctionatorConfigNumericInputMixin", "OnLoad", configNumericInput)
    tryPostHook("AuctionatorConfigRadioButtonGroupMixin", "SetupRadioButtons", configRadioButtonGroup)
    tryPostHook("AuctionatorDropDownInternalMixin", "Initialize", dropDownInternal)
    tryPostHook("AuctionatorFilterKeySelectorMixin", "OnLoad", filterKeySelector)
    tryPostHook("AuctionatorKeyBindingConfigMixin", "OnLoad", keyBindingConfig)
    tryPostHook("AuctionatorResultsListingMixin", "OnShow", resultsListing)
    tryPostHook("AuctionatorSaleItemMixin", "OnLoad", saleItem)
    tryPostHook("AuctionatorShoppingTabFrameMixin", "OnLoad", shoppingTabFrame)
    tryPostHook("AuctionatorShoppingTabSearchOptionsMixin", "OnLoad", shoppingTabSearchOptions)
    tryPostHook("AuctionatorShoppingTabListsContainerMixin", "OnLoad", shoppingTabContainer)
    tryPostHook("AuctionatorShoppingTabRecentsContainerMixin", "OnLoad", shoppingTabContainer)
    tryPostHook("AuctionatorShoppingTabContainerTabsMixin", "OnLoad", shoppingTabContainerTabs)
    tryPostHook("AuctionatorBagUseMixin", "OnLoad", bagUse)
    tryPostHook("AuctionatorSellingTabPricesContainerMixin", "OnLoad", sellingTabPricesContainer)
    tryPostHook("AuctionatorTabContainerMixin", "OnLoad", bottomTabButtons)
    tryPostHook("AuctionatorUndercutScanMixin", "OnLoad", undercutScan)

    -- tab frames
    tryPostHook("AuctionatorCancellingFrameMixin", "OnLoad", cancellingFrame)
    tryPostHook("AuctionatorConfigTabMixin", "OnLoad", configTab)
    tryPostHook("AuctionatorSellingTabMixin", "OnLoad", sellingTab)

    -- frames
    tryPostHook("AuctionatorConfigSellingFrameMixin", "OnLoad", configSellingFrame)
    tryPostHook("AuctionatorExportTextFrameMixin", "OnLoad", exportTextFrame)
    tryPostHook("AuctionatorListExportFrameMixin", "OnLoad", listExportFrame)
    tryPostHook("AuctionatorListImportFrameMixin", "OnLoad", listImportFrame)
    tryPostHook("AuctionatorItemHistoryFrameMixin", "Init", itemHistoryFrame)
    tryPostHook("AuctionatorCraftingInfoObjectiveTrackerFrameMixin", "OnLoad", craftingInfoObjectiveTrackerFrame)
    tryPostHook("AuctionatorCraftingInfoProfessionsFrameMixin", "OnLoad", craftingInfoProfessionsFrame)
    tryPostHook("AuctionatorShoppingItemMixin", "OnLoad", shoppingItem)
    tryPostHook("AuctionatorSplashScreenMixin", "OnLoad", splashFrame)
    tryPostHook("AuctionatorBuyCommodityFrameTemplateMixin", "OnLoad", buyCommodity)
end

S:AddCallbackForAddon("Auctionator")
