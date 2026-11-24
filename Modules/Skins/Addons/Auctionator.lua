-- luacheck: ignore 211
local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local MF = W.Modules.MoveFrames ---@type MoveFrames

local _G = _G
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local next = next
local pairs = pairs
local strfind = strfind

S:AddCallbackForAddon("Auctionator", nil, S:CreateAddonCheck("auctionator"))

local configFrameNames = {
	"AuctionatorConfigAdvancedFrame",
	"AuctionatorConfigBasicOptionsFrame",
	"AuctionatorConfigCancellingFrame",
	"AuctionatorConfigProfileFrame",
	"AuctionatorConfigQuantitiesFrame",
	"AuctionatorConfigSellingAllItemsFrame",
	"AuctionatorConfigSellingFrame",
	"AuctionatorConfigSellingShortcutsFrame",
	"AuctionatorConfigShoppingAltFrame",
	"AuctionatorConfigTooltipsFrame",
}

local dialogButtonNames = {
	"acceptButton",
	"altButton",
	"cancelButton",
	"AcceptButton",
	"CancelButton",
	"ContinueButton",
	"Buy",
	"Cancel",
}

local function skinResultRow(row)
	for _, cell in pairs(row.cells) do
		if cell.Icon and not cell.__windSkin then
			S:Proxy("HandleIcon", cell.Icon)

			if cell.IconBorder then
				cell.IconBorder:Hide()
			end

			cell.__windSkin = true
		end
	end

	if row.__windSkin then
		return
	end

	row.NormalTexture:SetAlpha(0)
	row.HighlightTexture:SetTexture(E.Media.Textures.White8x8)
	row.HighlightTexture:SetVertexColor(1, 1, 1, 0.3)
	row.SelectedHighlight:SetTexture(E.Media.Textures.White8x8)
	row.SelectedHighlight:SetVertexColor(1, 1, 1, 0.4)
	row.__windSkin = true
end

local function reskinDialog(frame)
	if not frame or frame.__windSkin then
		return
	end

	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	if frame.editBox then
		S:Proxy("HandleEditBox", frame.editBox)
		frame.editBox:SetTextInsets(0, 0, 0, 0)
	end

	if frame.QuantityInput then
		S:Proxy("HandleEditBox", frame.QuantityInput)
		frame.QuantityInput:SetTextInsets(0, 0, 0, 0)
	end

	for _, buttonName in ipairs(dialogButtonNames) do
		local button = frame[buttonName]
		if button and button:IsObjectType("Button") then
			S:Proxy("HandleButton", button)
		end
	end

	frame.__windSkin = true
end

local function skinInset(frame)
	if frame.__windSkin then
		return
	end

	frame:StripTextures()
	frame:SetTemplate("Transparent")
	frame.__windSkin = true
end

-- Modified from ElvUI Auction House Skin
local function HandleHeaders(frame)
	local headerContainer = frame.HeaderContainer
	local maxHeaders = headerContainer:GetNumChildren()
	for index, header in next, { headerContainer:GetChildren() } do
		if not header.__windSkin then
			header:DisableDrawLayer("BACKGROUND")

			if not header.backdrop then
				header:CreateBackdrop("Transparent")
			end

			header.__windSkin = true
		end

		if header.backdrop then
			header.backdrop:Point("BOTTOMRIGHT", index < maxHeaders and -5 or 0, -2)
		end
	end
end

local function HandleTab(tab)
	if tab.__windMiniTab then
		return
	end

	S:Proxy("HandleTab", tab)

	-- ElvUI clears Left/Middle/Right. These templates also keep the active and highlight pieces in TabTextures.
	if tab.TabTextures then
		for _, texture in ipairs(tab.TabTextures) do
			texture:SetAlpha(0)
		end
	end

	tab.__windMiniTab = true
end

local function skinRefreshButton(parent)
	for _, child in pairs({ parent:GetChildren() }) do
		if child:IsObjectType("Button") and child.iconAtlas == "UI-RefreshButton" then
			S:Proxy("HandleButton", child)
			break
		end
	end
end

local function buyIconName(frame)
	S:Proxy("HandleIcon", frame.Icon, true)
	S:Proxy("HandleIconBorder", frame.QualityBorder, frame.Icon.backdrop)
end

local function viewGroup(frame)
	if frame.GroupTitle then
		frame.GroupTitle:StripTextures()
		S:Proxy("HandleButton", frame.GroupTitle)
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

			pointsCache[i] = { point, relativeTo, relativePoint, xOfs, yOfs }
		end

		frame.Icon:ClearAllPoints()

		for i = 1, #pointsCache do
			local pointData = pointsCache[i]
			frame.Icon:Point(pointData[1], pointData[2], pointData[3], pointData[4], pointData[5])
		end
	end

	frame.EmptySlot:SetTexture(nil)
	frame.EmptySlot:Hide()

	frame:GetHighlightTexture():SetTexture(E.Media.Textures.White8x8)
	frame:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.3)

	frame.IconSelectedHighlight:SetTexture(E.Media.Textures.White8x8)
	frame.IconSelectedHighlight:SetVertexColor(1, 1, 1, 0.4)
	frame.IconSelectedHighlight:SetOutside(frame.Icon)

	frame:GetPushedTexture():SetTexture(E.Media.Textures.White8x8)
	frame:GetPushedTexture():SetVertexColor(1, 1, 0, 0.3)

	S:Proxy("HandleIcon", frame.Icon, true)
	S:Proxy("HandleIconBorder", frame.IconBorder, frame.Icon.backdrop)
end

local function configRadioButtonGroup(frame)
	for _, child in pairs(frame.radioButtons) do
		S:Proxy("HandleRadioButton", child.RadioButton)
	end
end

local function configCheckbox(frame)
	S:Proxy("HandleCheckBox", frame.CheckBox)
	frame.CheckBox:Size(24)
end

local function dropDown(frame)
	local dropdown = frame.DropDown
	if dropdown.__windSkin then
		return
	end

	S:Proxy("HandleDropDownBox", dropdown, dropdown:GetWidth())
	dropdown.__windSkin = true
end

local function keyBindingConfig(frame)
	S:Proxy("HandleButton", frame.Button)
end

local function bagUse(frame)
	S:Proxy("HandleTrimScrollBar", frame.View.ScrollBar)
end

local function configNumericInput(frame)
	S:Proxy("HandleEditBox", frame.InputBox)
	frame.InputBox:SetTextInsets(0, 0, 0, 0)
end

local function configMoneyInput(frame)
	S:Proxy("HandleEditBox", frame.MoneyInput.CopperBox)
	S:Proxy("HandleEditBox", frame.MoneyInput.GoldBox)
	S:Proxy("HandleEditBox", frame.MoneyInput.SilverBox)

	frame.MoneyInput.CopperBox:SetTextInsets(3, 0, 0, 0)
	frame.MoneyInput.GoldBox:SetTextInsets(3, 0, 0, 0)
	frame.MoneyInput.SilverBox:SetTextInsets(3, 0, 0, 0)

	frame.MoneyInput.CopperBox:Height(24)
	frame.MoneyInput.GoldBox:Height(24)
	frame.MoneyInput.SilverBox:Height(24)

	frame.MoneyInput.CopperBox.Icon:ClearAllPoints()
	frame.MoneyInput.CopperBox.Icon:Point("RIGHT", frame.MoneyInput.CopperBox, "RIGHT", -10, 0)
	frame.MoneyInput.GoldBox.Icon:ClearAllPoints()
	frame.MoneyInput.GoldBox.Icon:Point("RIGHT", frame.MoneyInput.GoldBox, "RIGHT", -10, 0)
	frame.MoneyInput.SilverBox.Icon:ClearAllPoints()
	frame.MoneyInput.SilverBox.Icon:Point("RIGHT", frame.MoneyInput.SilverBox, "RIGHT", -10, 0)
end

local function configMinMax(frame)
	S:Proxy("HandleEditBox", frame.MinBox)
	S:Proxy("HandleEditBox", frame.MaxBox)
end

local function filterKeySelector(frame)
	dropDown(frame)
end

local function undercutScan(frame)
	for _, child in pairs({ frame:GetChildren() }) do
		if child:IsObjectType("Button") then
			S:Proxy("HandleButton", child)
		end
	end
end

local function saleItem(frame)
	S:Proxy("HandleButton", frame.MaxButton)
	frame.MaxButton:ClearAllPoints()
	frame.MaxButton:Point("TOPLEFT", frame.Quantity, "TOPRIGHT", 0, 0)
	S:Proxy("HandleButton", frame.PostButton)
	S:Proxy("HandleButton", frame.SkipButton)
	S:Proxy("HandleButton", frame.PrevButton)

	skinRefreshButton(frame)
end

local function bottomTabButtons(frame)
	local auctionHouseFrame = _G.AuctionHouseFrame
	local previousTab = auctionHouseFrame.Tabs[#auctionHouseFrame.Tabs]

	for _, tabButton in ipairs(frame.Tabs) do
		if not tabButton.__windSkin then
			S:Proxy("HandleTab", tabButton, nil, "Transparent")
			S:ReskinTab(tabButton)
			tabButton.Text:Width(tabButton:GetWidth())

			tabButton:ClearAllPoints()
			tabButton:Point("TOPLEFT", previousTab, "TOPRIGHT", -5, 0)

			tabButton.__windSkin = true
		end

		previousTab = tabButton
	end
end

local function sellingTabPricesContainer(frame)
	HandleTab(frame.CurrentPricesTab)
	HandleTab(frame.PriceHistoryTab)
	HandleTab(frame.YourHistoryTab)
end

local function resultsListing(frame)
	local scrollArea = frame.ScrollArea
	scrollArea:SetTemplate("Transparent")
	S:Proxy("HandleTrimScrollBar", scrollArea.ScrollBar)
	HandleHeaders(frame)

	local function updateResultRows()
		HandleHeaders(frame)
		scrollArea.ScrollBox:ForEachFrame(skinResultRow)
	end

	updateResultRows()
	hooksecurefunc(scrollArea.ScrollBox, "Update", updateResultRows)
end

local function shoppingTabFrame(frame)
	S:Proxy("HandleButton", frame.NewListButton)
	S:Proxy("HandleButton", frame.ImportButton)
	S:Proxy("HandleButton", frame.ExportButton)
	S:Proxy("HandleButton", frame.ExportCSV)

	skinInset(frame.ShoppingResultsInset)
end

local function shoppingTabSearchOptions(frame)
	S:Proxy("HandleEditBox", frame.SearchString)
	S:Proxy("HandleButton", frame.ResetSearchStringButton)
	S:Proxy("HandleButton", frame.SearchButton)
	S:Proxy("HandleButton", frame.MoreButton)
	S:Proxy("HandleButton", frame.AddToListButton)
end

local function skinShoppingRow(row)
	if row.__windSkin then
		return
	end

	row.Highlight:SetTexture(E.Media.Textures.White8x8)
	row.Highlight:SetVertexColor(1, 1, 1, 0.3)
	row.Selected:SetTexture(E.Media.Textures.White8x8)
	row.Selected:SetVertexColor(1, 1, 1, 0.4)
	row.__windSkin = true
end

local function skinShoppingRows(scrollBox)
	scrollBox:ForEachFrame(skinShoppingRow)
end

local function shoppingTabContainer(frame)
	skinInset(frame.Inset)
	S:Proxy("HandleTrimScrollBar", frame.ScrollBar)

	skinShoppingRows(frame.ScrollBox)
	hooksecurefunc(frame.ScrollBox, "Update", skinShoppingRows)
end

local function shoppingTabContainerTabs(frame)
	HandleTab(frame.ListsTab)
	HandleTab(frame.RecentsTab)
end

local function sellingTab(frame)
	skinInset(frame.BagInset)
	skinInset(frame.HistoricalPriceInset)

	if frame.CurrentPricesInset then
		skinInset(frame.CurrentPricesInset)
	end
end

local function cancellingFrame(frame)
	S:Proxy("HandleEditBox", frame.SearchFilter)

	skinRefreshButton(frame)

	skinInset(frame.HistoricalPriceInset)
end

local function configTab(frame)
	frame.Bg:SetTexture(nil)
	frame.NineSlice:SetTemplate("Transparent")

	S:Proxy("HandleButton", frame.OptionsButton)
	S:Proxy("HandleButton", frame.ScanButton)

	S:Proxy("HandleEditBox", frame.ContributeLink.InputBox)
	S:Proxy("HandleEditBox", frame.DiscordLink.InputBox)
end

local function shoppingItem(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	MF:InternalHandle(frame, nil, false)

	local function reskinResetButton(button, anchor, x, y)
		S:Proxy("HandleButton", button)
		button:Size(20)
		button:ClearAllPoints()
		button:Point("LEFT", anchor, "RIGHT", x, y)
	end

	S:Proxy("HandleEditBox", frame.SearchContainer.SearchString)
	S:Proxy("HandleCheckBox", frame.SearchContainer.IsExact)

	reskinResetButton(frame.SearchContainer.ResetSearchStringButton, frame.SearchContainer.SearchString, 3, 0)
	reskinResetButton(frame.FilterKeySelector.ResetButton, frame.FilterKeySelector, 0, 3)
	reskinResetButton(frame.LevelRange.ResetButton, frame.LevelRange.MaxBox, 3, 0)
	reskinResetButton(frame.ItemLevelRange.ResetButton, frame.ItemLevelRange.MaxBox, 3, 0)
	reskinResetButton(frame.PriceRange.ResetButton, frame.PriceRange.MaxBox, 3, 0)
	reskinResetButton(frame.CraftedLevelRange.ResetButton, frame.CraftedLevelRange.MaxBox, 3, 0)
	reskinResetButton(frame.QualityContainer.ResetQualityButton, frame.QualityContainer, 200, 5)
	reskinResetButton(frame.ExpansionContainer.ResetExpansionButton, frame.ExpansionContainer, 200, 5)
	reskinResetButton(frame.TierContainer.ResetTierButton, frame.TierContainer, 200, 5)

	S:Proxy("HandleButton", frame.Finished)
	S:Proxy("HandleButton", frame.Cancel)
	S:Proxy("HandleButton", frame.ResetAllButton)
	S:Proxy("HandleCloseButton", frame.CloseButton)
end

local function exportTextFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	S:Proxy("HandleButton", frame.Close)
	S:Proxy("HandleTrimScrollBar", frame.ScrollBar)
end

local function skinExportList(frame)
	for checkBox in frame.checkBoxPool:EnumerateActive() do
		configCheckbox(checkBox)
	end
end

local function listExportFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	S:Proxy("HandleButton", frame.SelectAll)
	S:Proxy("HandleButton", frame.UnselectAll)
	S:Proxy("HandleButton", frame.Export)
	S:Proxy("HandleCloseButton", frame.CloseDialog)
	S:Proxy("HandleTrimScrollBar", frame.ScrollBar)

	hooksecurefunc(frame, "RefreshLists", skinExportList)
end

local function listImportFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	S:Proxy("HandleButton", frame.Import)
	S:Proxy("HandleCloseButton", frame.CloseDialog)
	S:Proxy("HandleTrimScrollBar", frame.ScrollBar)
end

local function itemHistoryFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	S:Proxy("HandleButton", frame.Close)
	S:Proxy("HandleButton", frame.Dock)
end

local function configSellingFrame(frame)
	S:Proxy("HandleButton", frame.UnhideAll)
end

local function craftingInfoObjectiveTrackerFrame(frame)
	S:Proxy("HandleButton", frame.SearchButton)
end

local function craftingInfoProfessionsFrame(frame)
	S:Proxy("HandleButton", frame.SearchButton)
end

local function buyItem(frame)
	skinInset(frame.Inset)
	S:Proxy("HandleButton", frame.BackButton)
	frame:StripTextures()
	skinRefreshButton(frame)

	reskinDialog(frame.BuyDialog)
	reskinDialog(frame.WidePriceRangeWarningDialog)
	reskinDialog(frame.FinalConfirmationDialog)
	reskinDialog(frame.QuantityCheckConfirmationDialog)

	local container = frame.DetailsContainer
	if not container then
		return
	end

	S:Proxy("HandleButton", container.BuyButton)
	S:Proxy("HandleEditBox", container.Quantity)
	container.Quantity:SetTextInsets(0, 0, 0, 0)
end

local function skinConfigChild(child)
	if child.__windConfigSkin or child.__windSkin then
		return
	end

	child.__windConfigSkin = true

	if child.CheckBox then
		configCheckbox(child)
	end

	if child.radioButtons then
		configRadioButtonGroup(child)
	end

	if child.MoneyInput then
		configMoneyInput(child)
	end

	if child.InputBox then
		configNumericInput(child)
	end

	if child.MinBox and child.MaxBox then
		configMinMax(child)
	end

	if child.DropDown then
		dropDown(child)
	end

	if child.Button and child.Description then
		keyBindingConfig(child)
	end

	if child.ResetButton then
		S:Proxy("HandleButton", child.ResetButton)
	end

	if child.ScrollBar then
		S:Proxy("HandleTrimScrollBar", child.ScrollBar)
		child.ScrollBar.__windSkin = true
	end

	if child:IsObjectType("Button") and not child:IsObjectType("CheckButton") and not child.__windSkin then
		S:Proxy("HandleButton", child)
	end

	for _, nestedChild in pairs({ child:GetChildren() }) do
		skinConfigChild(nestedChild)
	end
end

local function skinConfigFrames()
	for _, frameName in ipairs(configFrameNames) do
		local frame = _G[frameName]
		if frame and not frame.__windConfigSkin then
			frame.__windConfigSkin = true

			if frame.ScrollBar then
				S:Proxy("HandleTrimScrollBar", frame.ScrollBar)
				frame.ScrollBar.__windSkin = true
			end

			for _, child in pairs({ frame:GetChildren() }) do
				skinConfigChild(child)
			end
		end
	end
end

local function reskinDialogs()
	for _, dialogFunc in ipairs({
		"ShowEditBox",
		"ShowConfirm",
		"ShowConfirmAlt",
		"ShowMoney",
	}) do
		if _G.Auctionator.Dialogs and _G.Auctionator.Dialogs[dialogFunc] then
			local original = _G.Auctionator.Dialogs[dialogFunc]
			_G.Auctionator.Dialogs[dialogFunc] = function(...)
				local result = original(...)
				for _, name in pairs(_G.UISpecialFrames) do
					local frame = name and _G[name]
					if frame and not frame.__windSkin and strfind(name, "^AuctionatorDialog") then
						reskinDialog(frame)
						frame.__windSkin = true
					end
				end
				return result
			end
		end
	end
end

function S:Auctionator()
	self:DisableAddOnSkin("Auctionator")

	-- widgets
	S:TryPostHook("AuctionatorBuyIconNameTemplateMixin", "SetItem", buyIconName)
	S:TryPostHook("AuctionatorGroupsViewGroupMixin", "SetName", viewGroup)
	S:TryPostHook("AuctionatorGroupsViewItemMixin", "SetItemInfo", viewItem)
	S:TryPostHook("AuctionatorConfigCheckboxMixin", "OnLoad", configCheckbox)
	S:TryPostHook("AuctionatorConfigHorizontalRadioButtonGroupMixin", "SetupRadioButtons", configRadioButtonGroup)
	S:TryPostHook("AuctionatorConfigMinMaxMixin", "OnLoad", configMinMax)
	S:TryPostHook("AuctionatorConfigMoneyInputMixin", "OnLoad", configMoneyInput)
	S:TryPostHook("AuctionatorConfigNumericInputMixin", "OnLoad", configNumericInput)
	S:TryPostHook("AuctionatorConfigRadioButtonGroupMixin", "SetupRadioButtons", configRadioButtonGroup)
	S:TryPostHook("AuctionatorDropDownMixin", "OnLoad", dropDown)
	S:TryPostHook("AuctionatorFilterKeySelectorMixin", "OnLoad", filterKeySelector)
	S:TryPostHook("AuctionatorKeyBindingConfigMixin", "OnLoad", keyBindingConfig)
	S:TryPostHook("AuctionatorResultsListingMixin", "OnShow", resultsListing)
	S:TryPostHook("AuctionatorSaleItemMixin", "OnLoad", saleItem)
	S:TryPostHook("AuctionatorShoppingTabFrameMixin", "OnLoad", shoppingTabFrame)
	S:TryPostHook("AuctionatorShoppingTabSearchOptionsMixin", "OnLoad", shoppingTabSearchOptions)
	S:TryPostHook("AuctionatorShoppingTabListsContainerMixin", "OnLoad", shoppingTabContainer)
	S:TryPostHook("AuctionatorShoppingTabRecentsContainerMixin", "OnLoad", shoppingTabContainer)
	S:TryPostHook("AuctionatorShoppingTabContainerTabsMixin", "OnLoad", shoppingTabContainerTabs)
	S:TryPostHook("AuctionatorBagUseMixin", "OnLoad", bagUse)
	S:TryPostHook("AuctionatorSellingTabPricesContainerMixin", "OnLoad", sellingTabPricesContainer)
	S:TryPostHook("AuctionatorTabContainerMixin", "OnLoad", bottomTabButtons)
	S:TryPostHook("AuctionatorUndercutScanMixin", "OnLoad", undercutScan)

	-- tab frames
	S:TryPostHook("AuctionatorCancellingFrameMixin", "OnLoad", cancellingFrame)
	S:TryPostHook("AuctionatorConfigTabMixin", "OnLoad", configTab)
	S:TryPostHook("AuctionatorSellingTabMixin", "OnLoad", sellingTab)

	-- frames
	S:TryPostHook("AuctionatorConfigSellingFrameMixin", "OnLoad", configSellingFrame)
	S:TryPostHook("AuctionatorExportTextFrameMixin", "OnLoad", exportTextFrame)
	S:TryPostHook("AuctionatorListExportFrameMixin", "OnLoad", listExportFrame)
	S:TryPostHook("AuctionatorListImportFrameMixin", "OnLoad", listImportFrame)
	S:TryPostHook("AuctionatorItemHistoryFrameMixin", "Init", itemHistoryFrame)
	S:TryPostHook("AuctionatorCraftingInfoObjectiveTrackerFrameMixin", "OnLoad", craftingInfoObjectiveTrackerFrame)
	S:TryPostHook("AuctionatorCraftingInfoProfessionsFrameMixin", "OnLoad", craftingInfoProfessionsFrame)
	S:TryPostHook("AuctionatorShoppingItemMixin", "OnLoad", shoppingItem)
	S:TryPostHook("AuctionatorBuyCommodityFrameTemplateMixin", "OnLoad", buyItem)
	S:TryPostHook("AuctionatorBuyItemFrameTemplateMixin", "OnLoad", buyItem)
	S:TryPostHook("AuctionatorBuyCommodityFinalConfirmationDialogMixin", "SetDetails", reskinDialog)

	-- Dialog
	reskinDialogs()
	skinConfigFrames()
end
