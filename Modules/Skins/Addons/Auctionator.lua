local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local MF = W.Modules.MoveFrames ---@type MoveFrames

local _G = _G
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local next = next
local pairs = pairs
local strfind = strfind
local unpack = unpack

-- Modified from ElvUI Auction House Skin
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
						S:Proxy("HandleIcon", cell.Icon)

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

local function reskinDialog(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	if frame.editBox then
		S:Proxy("HandleEditBox", frame.editBox)
		frame.editBox:SetTextInsets(0, 0, 0, 0)
	end

	for _, buttonName in pairs({ "acceptButton", "cancelButton", "AcceptButton", "CancelButton", "Buy", "Cancel" }) do
		local button = frame[buttonName]
		if button and button:IsObjectType("Button") then
			S:Proxy("HandleButton", button)
		end
	end
end

-- Modified from ElvUI Auction House Skin
local function HandleHeaders(frame)
	local maxHeaders = frame.HeaderContainer:GetNumChildren()
	for i, header in next, { frame.HeaderContainer:GetChildren() } do
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
	S:Proxy("HandleTab", tab)
	tab.Text:ClearAllPoints()
	F.InternalizeMethod(tab.Text, "SetPoint", true)
	F.CallMethod(tab.Text, "SetPoint", "CENTER", tab, "CENTER", 0, 0)
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
end

local function dropDown(frame)
	S:Proxy("HandleDropDownBox", frame.DropDown, 150)
end

local function keyBindingConfig(frame)
	S:Proxy("HandleButton", frame.Button)
end

local function bagUse(frame)
	frame.View:CreateBackdrop("Transparent")
	S:Proxy("HandleTrimScrollBar", frame.View.ScrollBar)

	for _, child in pairs({ frame:GetChildren() }) do
		if child ~= frame.View then
			S:Proxy("HandleButton", child)
		end
	end
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
	S:Proxy("HandleEditBox", frame.MinBox)
	S:Proxy("HandleEditBox", frame.MaxBox)
end

local function filterKeySelector(frame)
	S:Proxy("HandleDropDownBox", frame.DropDown, frame:GetWidth())
end

local function undercutScan(frame)
	for _, child in pairs({ frame:GetChildren() }) do
		if child:IsObjectType("Button") then
			S:Proxy("HandleButton", child)
		end
	end
end

local function saleItem(frame)
	frame.Icon:StripTextures()

	S:Proxy("HandleIcon", frame.Icon.Icon, true)
	S:Proxy("HandleIconBorder", frame.Icon.IconBorder, frame.Icon.Icon.backdrop)

	S:Proxy("HandleButton", frame.MaxButton)
	frame.MaxButton:ClearAllPoints()
	frame.MaxButton:SetPoint("TOPLEFT", frame.Quantity, "TOPRIGHT", 0, 0)
	S:Proxy("HandleButton", frame.PostButton)
	S:Proxy("HandleButton", frame.SkipButton)

	for _, child in pairs({ frame:GetChildren() }) do
		if child:IsObjectType("Button") and child.Icon then
			S:Proxy("HandleButton", child)
		end
	end
end

local function bottomTabButtons(frame)
	for _, details in ipairs(_G.Auctionator.Tabs.State.knownTabs) do
		local tabButtonFrameName = "AuctionatorTabs_" .. details.name
		local tabButton = _G[tabButtonFrameName]

		if tabButton and not tabButton.__windSkin then
			S:Proxy("HandleTab", tabButton, nil, "Transparent")
			S:ReskinTab(tabButton)
			tabButton.Text:SetWidth(tabButton:GetWidth())
			if details.tabOrder > 1 then
				local pointData = { tabButton:GetPoint(1) }
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
	S:Proxy("HandleTrimScrollBar", frame.ScrollArea.ScrollBar)

	HandleHeaders(frame)
	hooksecurefunc(frame, "UpdateTable", HandleHeaders)
end

local function shoppingTabFrame(frame)
	S:Proxy("HandleButton", frame.NewListButton)
	S:Proxy("HandleButton", frame.ImportButton)
	S:Proxy("HandleButton", frame.ExportButton)
	S:Proxy("HandleButton", frame.ExportCSV)

	frame.ShoppingResultsInset:StripTextures()
end

local function shoppingTabSearchOptions(frame)
	S:Proxy("HandleEditBox", frame.SearchString)
	S:Proxy("HandleButton", frame.ResetSearchStringButton)
	S:Proxy("HandleButton", frame.SearchButton)
	S:Proxy("HandleButton", frame.MoreButton)
	S:Proxy("HandleButton", frame.AddToListButton)
end

local function shoppingTabContainer(frame)
	frame.Inset:StripTextures()
	frame.Inset:SetTemplate("Transparent")
	S:Proxy("HandleTrimScrollBar", frame.ScrollBar)
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
	S:Proxy("HandleEditBox", frame.SearchFilter)

	for _, child in pairs({ frame:GetChildren() }) do
		if child:IsObjectType("Button") and child.Icon then
			S:Proxy("HandleButton", child)
		end
	end

	frame.HistoricalPriceInset:StripTextures()
	frame.HistoricalPriceInset:SetTemplate("Transparent")
end

local function configTab(frame)
	frame.Bg:SetTexture(nil)
	frame.NineSlice:SetTemplate("Transparent")

	S:Proxy("HandleButton", frame.OptionsButton)
	S:Proxy("HandleButton", frame.ScanButton)

	S:Proxy("HandleEditBox", frame.ContributeLink.InputBox)
	S:Proxy("HandleEditBox", frame.DiscordLink.InputBox)
	S:Proxy("HandleEditBox", frame.BugReportLink.InputBox)
end

local function shoppingItem(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	MF:InternalHandle(frame, nil, false)

	local function reskinResetButton(f, anchor, x, y)
		S:Proxy("HandleButton", f)
		f:Size(20, 20)
		f:ClearAllPoints()
		f:SetPoint("LEFT", anchor, "RIGHT", x, y)
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

local function listExportFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	S:Proxy("HandleButton", frame.SelectAll)
	S:Proxy("HandleButton", frame.UnselectAll)
	S:Proxy("HandleButton", frame.Export)
	S:Proxy("HandleCloseButton", frame.CloseDialog)
	S:Proxy("HandleTrimScrollBar", frame.ScrollBar)
end

local function listImportFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	S:Proxy("HandleButton", frame.Import)
	S:Proxy("HandleCloseButton", frame.CloseDialog)
	S:Proxy("HandleTrimScrollBar", frame.ScrollBar)
end

local function splashFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	S:Proxy("HandleCloseButton", frame.Close)
	S:Proxy("HandleCheckBox", frame.HideCheckbox.CheckBox)
	S:Proxy("HandleTrimScrollBar", frame.ScrollBar)

	if E.private.WT.misc.moveFrames.enable and not W.Modules.MoveFrames.StopRunning then
		W.Modules.MoveFrames:HandleFrame(frame)
	end
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
	S:Proxy("HandleButton", frame.BackButton)
	frame:StripTextures()

	if frame.BuyDialog then
		reskinDialog(frame.BuyDialog)
	end

	for _, child in pairs({ frame:GetChildren() }) do
		if child:IsObjectType("Button") and child.iconAtlas and child.iconAtlas == "UI-RefreshButton" then
			S:Proxy("HandleButton", child)
			break
		end
	end

	local container = frame.DetailsContainer
	if not container then
		return
	end

	S:Proxy("HandleButton", container.BuyButton)
	S:Proxy("HandleEditBox", container.Quantity)
	container.Quantity:SetTextInsets(0, 0, 0, 0)
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
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.auctionator then
		return
	end

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
	S:TryPostHook("AuctionatorSplashScreenMixin", "OnLoad", splashFrame)
	S:TryPostHook("AuctionatorBuyCommodityFrameTemplateMixin", "OnLoad", buyItem)
	S:TryPostHook("AuctionatorBuyItemFrameTemplateMixin", "OnLoad", buyItem)
	S:TryPostHook("AuctionatorBuyCommodityFinalConfirmationDialogMixin", "SetDetails", reskinDialog)

	-- Dialog
	reskinDialogs()
end

S:AddCallbackForAddon("Auctionator")
