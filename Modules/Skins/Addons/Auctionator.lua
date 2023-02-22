local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local next = next
local pairs = pairs
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

local function reskin(func)
    return function(frame, ...)
        if frame.__windSkin then
            return
        end

        func(frame, ...)

        frame.__windSkin = true
    end
end

local function bagClassListing(frame)
    frame.SectionTitle:StripTextures()
    S:ESProxy("HandleButton", frame.SectionTitle)
end

local function bagItemContainer(frame)
    if frame.buttonPool and frame.buttonPool.creatorFunc then
        local func = frame.buttonPool.creatorFunc
        frame.buttonPool.creatorFunc = function(...)
            local button = func(...)

            button.Icon:ClearAllPoints()
            button.Icon:SetSize(frame.iconSize - 4, frame.iconSize - 4)
            button.Icon:SetPoint("CENTER", button, "CENTER", 0, 0)

            button.EmptySlot:SetTexture(nil)
            button.EmptySlot:Hide()

            button:GetHighlightTexture():SetTexture(E.Media.Textures.White8x8)
            button:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.3)

            button:GetPushedTexture():SetTexture(E.Media.Textures.White8x8)
            button:GetPushedTexture():SetVertexColor(1, 1, 0, 0.3)

            S:ESProxy("HandleIcon", button.Icon, true)
            S:ESProxy("HandleIconBorder", button.IconBorder, button.Icon.backdrop)

            return button
        end
    end
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

local function sellingBagFrame(frame)
    frame:CreateBackdrop("Transparent")
    S:ESProxy("HandleScrollBar", frame.ScrollBar)
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

local function scrollListShoppingList(frame)
    frame.Inset:StripTextures()
    frame.Inset:SetTemplate("Transparent")

    S:ESProxy("HandleTrimScrollBar", frame.ScrollBar)
end

local function scrollListRecents(frame)
    frame.Inset:StripTextures()
    frame.Inset:SetTemplate("Transparent")
    S:ESProxy("HandleTrimScrollBar", frame.ScrollBar)
end

local function tabRecentsContainer(frame)
    HandleTab(frame.ListTab)
    HandleTab(frame.RecentsTab)
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

local function shoppingTab(frame)
    if frame.OneItemSearch then
        S:ESProxy("HandleEditBox", frame.OneItemSearch.SearchBox)
        S:ESProxy("HandleButton", frame.OneItemSearch.SearchButton)
        S:ESProxy("HandleButton", frame.OneItemSearch.ExtendedButton)
    end

    S:ESProxy("HandleDropDownBox", frame.ListDropdown)

    S:ESProxy("HandleButton", frame.AddItem)
    S:ESProxy("HandleButton", frame.ManualSearch)
    S:ESProxy("HandleButton", frame.SortItems)
    S:ESProxy("HandleButton", frame.Import)
    S:ESProxy("HandleButton", frame.Export)
    S:ESProxy("HandleButton", frame.ExportCSV)

    frame.ShoppingResultsInset:StripTextures()
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

    S:ESProxy("HandleDropDownBox", frame.QualityContainer.DropDown.DropDown)
    S:ESProxy("HandleButton", frame.QualityContainer.ResetQualityButton)
    frame.QualityContainer.ResetQualityButton:SetSize(20, 20)
    frame.QualityContainer.ResetQualityButton:ClearAllPoints()
    frame.QualityContainer.ResetQualityButton:SetPoint("LEFT", frame.QualityContainer.DropDown.DropDown, "RIGHT", 0, 3)

    if frame.TierContainer then
        frame.TierContainer:ClearAllPoints()
        frame.TierContainer:SetPoint("TOPLEFT", frame.QualityContainer, "BOTTOMLEFT", 0, -20)
        S:ESProxy("HandleDropDownBox", frame.TierContainer.DropDown.DropDown)
        S:ESProxy("HandleButton", frame.TierContainer.ResetTierButton)
        frame.TierContainer.ResetTierButton:SetSize(20, 20)
        frame.TierContainer.ResetTierButton:ClearAllPoints()
        frame.TierContainer.ResetTierButton:SetPoint("LEFT", frame.TierContainer.DropDown.DropDown, "RIGHT", 0, 3)
    end

    S:ESProxy("HandleButton", frame.Finished)
    S:ESProxy("HandleButton", frame.Cancel)
    S:ESProxy("HandleButton", frame.ResetAllButton)
end

local function exportTextFrame(frame)
    frame:StripTextures()
    frame:SetTemplate("Transparent")
    S:CreateShadow(frame)

    S:ESProxy("HandleButton", frame.Close)
    S:ESProxy("HandleScrollBar", frame.ScrollFrame.ScrollBar)
end

local function listExportFrame(frame)
    frame:StripTextures()
    frame:SetTemplate("Transparent")
    S:CreateShadow(frame)

    S:ESProxy("HandleButton", frame.SelectAll)
    S:ESProxy("HandleButton", frame.UnselectAll)
    S:ESProxy("HandleButton", frame.Export)
    S:ESProxy("HandleCloseButton", frame.CloseDialog)
    S:ESProxy("HandleScrollBar", frame.ScrollFrame.ScrollBar)
end

local function listImportFrame(frame)
    frame:StripTextures()
    frame:SetTemplate("Transparent")
    S:CreateShadow(frame)

    S:ESProxy("HandleButton", frame.Import)
    S:ESProxy("HandleCloseButton", frame.CloseDialog)
    S:ESProxy("HandleScrollBar", frame.ScrollFrame.ScrollBar)
end

local function splashFrame(frame)
    frame:StripTextures()
    frame:SetTemplate("Transparent")
    S:CreateShadow(frame)

    S:ESProxy("HandleCloseButton", frame.Close)
    S:ESProxy("HandleCheckBox", frame.HideCheckbox.CheckBox)
    S:ESProxy("HandleScrollBar", frame.ScrollFrame.ScrollBar)

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

function S:Auctionator()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.auctionator then
        return
    end

    self:DisableAddOnSkin("Auctionator")

    -- widgets
    hooksecurefunc(_G.AuctionatorBagClassListingMixin, "Init", reskin(bagClassListing))
    hooksecurefunc(_G.AuctionatorBagItemContainerMixin, "OnLoad", reskin(bagItemContainer))
    hooksecurefunc(_G.AuctionatorConfigCheckboxMixin, "OnLoad", reskin(configCheckbox))
    hooksecurefunc(
        _G.AuctionatorConfigHorizontalRadioButtonGroupMixin,
        "SetupRadioButtons",
        reskin(configRadioButtonGroup)
    )
    hooksecurefunc(_G.AuctionatorConfigMinMaxMixin, "OnLoad", reskin(configMinMax))
    hooksecurefunc(_G.AuctionatorConfigMoneyInputMixin, "OnLoad", reskin(configMoneyInput))
    hooksecurefunc(_G.AuctionatorConfigNumericInputMixin, "OnLoad", reskin(configNumericInput))
    hooksecurefunc(_G.AuctionatorConfigRadioButtonGroupMixin, "SetupRadioButtons", reskin(configRadioButtonGroup))
    hooksecurefunc(_G.AuctionatorDropDownInternalMixin, "Initialize", reskin(dropDownInternal))
    hooksecurefunc(_G.AuctionatorFilterKeySelectorMixin, "OnLoad", reskin(filterKeySelector))
    hooksecurefunc(_G.AuctionatorKeyBindingConfigMixin, "OnLoad", reskin(keyBindingConfig))
    hooksecurefunc(_G.AuctionatorResultsListingMixin, "OnShow", reskin(resultsListing))
    hooksecurefunc(_G.AuctionatorSaleItemMixin, "OnLoad", reskin(saleItem))
    hooksecurefunc(_G.AuctionatorScrollListRecentsMixin, "OnLoad", reskin(scrollListRecents))
    hooksecurefunc(_G.AuctionatorScrollListShoppingListMixin, "OnLoad", reskin(scrollListShoppingList))
    hooksecurefunc(_G.AuctionatorSellingBagFrameMixin, "OnLoad", reskin(sellingBagFrame))
    hooksecurefunc(_G.AuctionatorSellingTabPricesContainerMixin, "OnLoad", reskin(sellingTabPricesContainer))
    hooksecurefunc(_G.AuctionatorShoppingTabRecentsContainerMixin, "OnLoad", reskin(tabRecentsContainer))
    hooksecurefunc(_G.AuctionatorTabContainerMixin, "OnLoad", reskin(bottomTabButtons))
    hooksecurefunc(_G.AuctionatorUndercutScanMixin, "OnLoad", reskin(undercutScan))

    -- tab frames
    hooksecurefunc(_G.AuctionatorCancellingFrameMixin, "OnLoad", reskin(cancellingFrame))
    hooksecurefunc(_G.AuctionatorConfigTabMixin, "OnLoad", reskin(configTab))
    hooksecurefunc(_G.AuctionatorSellingTabMixin, "OnLoad", reskin(sellingTab))
    hooksecurefunc(_G.AuctionatorShoppingTabMixin, "OnLoad", reskin(shoppingTab))

    -- frames
    hooksecurefunc(_G.AuctionatorConfigSellingFrameMixin, "OnLoad", reskin(configSellingFrame))
    hooksecurefunc(_G.AuctionatorExportTextFrameMixin, "OnLoad", reskin(exportTextFrame))
    hooksecurefunc(_G.AuctionatorListExportFrameMixin, "OnLoad", reskin(listExportFrame))
    hooksecurefunc(_G.AuctionatorListImportFrameMixin, "OnLoad", reskin(listImportFrame))
    hooksecurefunc(_G.AuctionatorItemHistoryFrameMixin, "Init", reskin(itemHistoryFrame))
    hooksecurefunc(_G.AuctionatorShoppingItemMixin, "OnLoad", reskin(shoppingItem))
    hooksecurefunc(_G.AuctionatorSplashScreenMixin, "OnLoad", reskin(splashFrame))
end

S:AddCallbackForAddon("Auctionator")
