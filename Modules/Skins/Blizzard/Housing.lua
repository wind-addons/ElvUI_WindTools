local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

function S:Blizzard_HousingHouseFinder()
	if not self:CheckDB("housing") then
		return
	end

	local FinderFrame = _G.HouseFinderFrame
	if FinderFrame then
		self:CreateBackdropShadow(FinderFrame)
	end
end

function S:Blizzard_HousingDashboard()
	if not self:CheckDB("housing") then
		return
	end

	local DashBoardFrame = _G.HousingDashboardFrame
	if DashBoardFrame then
		self:CreateBackdropShadow(DashBoardFrame)
	end

	for _, tab in pairs({ DashBoardFrame.HouseInfoTabButton, DashBoardFrame.CatalogTabButton }) do
		self:ReskinTab(tab)
	end

	local InfoContent = DashBoardFrame.HouseInfoContent
	if InfoContent then
		local ContentFrame = InfoContent.ContentFrame
		if ContentFrame then
			for _, tab in pairs({ ContentFrame.TabSystem:GetChildren() }) do
				self:ReskinTab(tab)
			end
		end
	end
end

function S:Blizzard_HousingCornerstone()
	if not self:CheckDB("housing") then
		return
	end

	local CornerVisitorFrame = _G.HousingCornerstoneVisitorFrame
	if CornerVisitorFrame then
		self:CreateBackdropShadow(CornerVisitorFrame)
	end

	local CornerInfoFrame = _G.HousingCornerstoneHouseInfoFrame
	if CornerInfoFrame then
		self:CreateBackdropShadow(CornerInfoFrame)
	end

	local PurchaseFrame = _G.HousingCornerstonePurchaseFrame
	if PurchaseFrame then
		self:CreateBackdropShadow(PurchaseFrame)
	end

	local MoveHouseConfirmation = _G.MoveHouseConfirmationDialog
	if MoveHouseConfirmation then
		self:CreateBackdropShadow(MoveHouseConfirmation)
	end
end

function S:Blizzard_HousingBulletinBoard()
	if not self:CheckDB("housing") then
		return
	end

	local ChangeNameDialog = _G.NeighborhoodChangeNameDialog
	if ChangeNameDialog then
		self:CreateBackdropShadow(ChangeNameDialog)
	end
end

function S:Blizzard_HouseList()
	if not self:CheckDB("housing") then
		return
	end

	local ListFrame = _G.HouseListFrame
	if ListFrame then
		self:CreateBackdropShadow(ListFrame)
	end
end

function S:Blizzard_HousingCreateNeighborhood()
	if not self:CheckDB("housing") then
		return
	end

	local CreateGuildFrame = _G.HousingCreateGuildNeighborhoodFrame
	if CreateGuildFrame then
		self:CreateBackdropShadow(CreateGuildFrame)
	end
end

function S:Blizzard_HousingHouseSettings()
	if not self:CheckDB("housing") then
		return
	end

	local SettingsFrame = _G.HousingHouseSettingsFrame
	if SettingsFrame then
		self:CreateShadow(SettingsFrame)
	end

	local AbandonHouseConfirmationDialog = _G.AbandonHouseConfirmationDialog
	if AbandonHouseConfirmationDialog then
		self:CreateShadow(AbandonHouseConfirmationDialog)
	end
end

function S:Blizzard_HouseEditor()
	if not self:CheckDB("housing") then
		return
	end

	local EditorFrame = _G.HouseEditorFrame
	if not EditorFrame then
		return
	end

    local StorageButton = EditorFrame.StorageButton
	if StorageButton then
		self:CreateShadow(StorageButton)
		StorageButton:NudgePoint(2)
	end

	local StoragePanel = EditorFrame.StoragePanel
	if StoragePanel then
		self:CreateShadow(StoragePanel)
		for _, tab in pairs({ StoragePanel.TabSystem:GetChildren() }) do
			self:ReskinTab(tab)
		end

		if StoragePanel.CollapseButton then
			self:CreateShadow(StoragePanel.CollapseButton)
            StoragePanel.CollapseButton:NudgePoint(2)
		end
	end

	local CustomizationFrame = EditorFrame.ExteriorCustomizationModeFrame
	if CustomizationFrame then
		local FixtureOptionList = CustomizationFrame.FixtureOptionList
		if FixtureOptionList then
			self:CreateShadow(FixtureOptionList)
		end
	end

	local CustomizeModeFrame = EditorFrame.CustomizeModeFrame
	local CustomizationsPane = CustomizeModeFrame and CustomizeModeFrame.RoomComponentCustomizationsPane
	if CustomizationsPane then
		self:CreateShadow(CustomizationsPane)
	end
end

function S:Blizzard_HousingModelPreview()
	if not self:CheckDB("housing") then
		return
	end

	local PreviewFrame = _G.HousingModelPreviewFrame
	if PreviewFrame then
		self:CreateShadow(PreviewFrame)
	end
end

S:AddCallbackForAddon("Blizzard_HouseList")
S:AddCallbackForAddon("Blizzard_HousingBulletinBoard")
S:AddCallbackForAddon("Blizzard_HousingCornerstone")
S:AddCallbackForAddon("Blizzard_HousingCreateNeighborhood")
S:AddCallbackForAddon("Blizzard_HousingDashboard")
S:AddCallbackForAddon("Blizzard_HousingHouseFinder")
S:AddCallbackForAddon("Blizzard_HousingHouseSettings")
S:AddCallbackForAddon("Blizzard_HouseEditor")
S:AddCallbackForAddon("Blizzard_HousingModelPreview")
