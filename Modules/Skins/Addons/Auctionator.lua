local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

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

local function reskin(func)
    return function(frame, ...)
        if frame.__windSkin then
            return
        end

        func(frame, ...)

        frame.__windSkin = true
    end
end

local function configMinMax(frame)
    S:ESProxy("HandleEditBox", frame.MinBox)
    S:ESProxy("HandleEditBox", frame.MaxBox)
end

local function filterKeySelector(frame)
    S:ESProxy("HandleDropDownBox", frame)
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
    S:ESProxy("HandleTab", frame.ListTab)
    frame.ListTab.Text:ClearAllPoints()
    frame.ListTab.Text:SetPoint("CENTER", frame.ListTab, "CENTER", 0, 0)
    frame.ListTab.Text.__SetPoint = frame.ListTab.Text.SetPoint
    frame.ListTab.Text.SetPoint = E.noop

    S:ESProxy("HandleTab", frame.RecentsTab)
    frame.RecentsTab.Text:ClearAllPoints()
    frame.RecentsTab.Text:SetPoint("CENTER", frame.RecentsTab, "CENTER", 0, 0)
    frame.RecentsTab.Text.__SetPoint = frame.RecentsTab.Text.SetPoint
    frame.RecentsTab.Text.SetPoint = E.noop
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

    frame.TierContainer:ClearAllPoints()
    frame.TierContainer:SetPoint("TOPLEFT", frame.QualityContainer, "BOTTOMLEFT", 0, -20)
    S:ESProxy("HandleDropDownBox", frame.TierContainer.DropDown.DropDown)
    S:ESProxy("HandleButton", frame.TierContainer.ResetTierButton)
    frame.TierContainer.ResetTierButton:SetSize(20, 20)
    frame.TierContainer.ResetTierButton:ClearAllPoints()
    frame.TierContainer.ResetTierButton:SetPoint("LEFT", frame.TierContainer.DropDown.DropDown, "RIGHT", 0, 3)

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

function S:Auctionator()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.auctionator then
        return
    end

    -- widgets
    hooksecurefunc(_G.AuctionatorFilterKeySelectorMixin, "OnLoad", reskin(filterKeySelector))
    hooksecurefunc(_G.AuctionatorConfigMinMaxMixin, "OnLoad", reskin(configMinMax))
    hooksecurefunc(_G.AuctionatorTabContainerMixin, "OnLoad", reskin(bottomTabButtons))
    hooksecurefunc(_G.AuctionatorScrollListShoppingListMixin, "OnLoad", reskin(scrollListShoppingList))
    hooksecurefunc(_G.AuctionatorScrollListRecentsMixin, "OnLoad", reskin(scrollListRecents))
    hooksecurefunc(_G.AuctionatorShoppingTabRecentsContainerMixin, "OnLoad", reskin(tabRecentsContainer))
    hooksecurefunc(_G.AuctionatorResultsListingMixin, "OnShow", reskin(resultsListing))

    -- tab frames
    hooksecurefunc(_G.AuctionatorShoppingTabMixin, "OnLoad", reskin(shoppingTab))
    hooksecurefunc(_G.AuctionatorConfigTabMixin, "OnLoad", reskin(configTab))

    -- frames
    hooksecurefunc(_G.AuctionatorExportTextFrameMixin, "OnLoad", reskin(exportTextFrame))
    hooksecurefunc(_G.AuctionatorListExportFrameMixin, "OnLoad", reskin(listExportFrame))
    hooksecurefunc(_G.AuctionatorListImportFrameMixin, "OnLoad", reskin(listImportFrame))
    hooksecurefunc(_G.AuctionatorShoppingItemMixin, "OnLoad", reskin(shoppingItem))
    hooksecurefunc(_G.AuctionatorSplashScreenMixin, "OnLoad", reskin(splashFrame))
end

S:AddCallbackForAddon("Auctionator")
