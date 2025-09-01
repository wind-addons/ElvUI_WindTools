local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local TT = E:GetModule("Tooltip")

local _G = _G
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local pairs = pairs

-- Modified from NDui_Plus
local function HandleNavButton(btn, strip, ...)
	S:Proxy("HandleButton", btn, strip, ...)

	local str = btn:GetFontString()
	if str then
		str:SetTextColor(1, 1, 1)
	end
end

local function HandleButton(self)
	if not self then
		F.Developer.ThrowError("BtWQuests Button is nil")
		return
	end

	self:SetNormalTexture(0)
	self:CreateBackdrop("Transparent")
	self.backdrop:SetInside(nil, 4, 4)
	self.backdrop:SetFrameLevel(self:GetFrameLevel())
	self:SetHighlightTexture(E.media.blankTex)
	local highlight = self:GetHighlightTexture()
	highlight:SetVertexColor(1, 1, 1, 0.25)
	highlight:SetInside(self.backdrop)

	if self.ActiveTexture then
		self.ActiveTexture:Kill()
		S:CreateShadow(self.backdrop, 4, 1, 0.717, 0.058, true)
		self.ActiveTexture = self.backdrop.shadow
		self.ActiveTexture:Hide()
	end

	local Active = self.Acive or self.Active
	if Active then
		Active:SetTexture("")
	end

	local Background = self.Background
	if Background and self:GetWidth() / self:GetHeight() < 10 then
		self.Background:SetInside(self.backdrop)
	end

	local Cover = self.Cover
	if Cover then
		Cover:SetTexture("")
	end
end

local function ReskinItemButton(self)
	if not self.__windSkin then
		HandleButton(self)
		self.__windSkin = true
	end

	local Active = self.Acive or self.Active
	if not Active then
		return
	end

	if Active:IsShown() then
		self.backdrop:SetBackdropBorderColor(0, 0.7, 0.08)
	else
		self.backdrop:SetBackdropBorderColor(0, 0, 0)
	end
end

local function ReskinDropMenu(menu)
	local list = menu.list
	if not list.backdrop then
		list:CreateBackdrop("Transparent")
		S:CreateBackdropShadow(list)

		for _, key in pairs({ "Backdrop", "MenuBackdrop" }) do
			local backdrop = list[key]
			if backdrop then
				backdrop:Hide()
				backdrop.Show = E.noop
			end
		end
	end
end

local function HandledDropDown(button)
	if not button or not button.GetListFrame then
		F.Developer.ThrowError("BtWQuests Dropdown is nil")
		return
	end

	hooksecurefunc(button, "Toggle", ReskinDropMenu)
end

local function ReskinSearchResults(self)
	local buttons = self.scrollFrame.buttons
	for _, button in ipairs(buttons) do
		if not button.__windSkin then
			button:StripTextures()
			button:CreateBackdrop()
			button.backdrop:SetInside()
			button:SetHighlightTexture(E.media.normTex)
			local highlight = button:GetHighlightTexture()
			highlight:SetVertexColor(1, 1, 1, 0.25)
			highlight:SetInside(button.backdrop)
			button.__windSkin = true
		end
	end
end
local function StyleSearchButton(button)
	if not button then
		return
	end

	S:Proxy("HandleFrame", button, true)
	S:CreateShadow(button)
	local icon = button.icon or button.Icon
	if icon then
		S:Proxy("HandleIcon", icon)
	end

	button:SetHighlightTexture(E.media.normTex)
	local hl = button:GetHighlightTexture()
	hl:SetVertexColor(0.8, 0.8, 0.8, 0.25)
	hl:SetInside()
end
function S:BtWQuests()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.btWQuests then
		return
	end

	self:DisableAddOnSkin("BtWQuests")

	local frame = _G.BtWQuestsFrame
	if not frame then
		return
	end

	self:Proxy("HandlePortraitFrame", frame)
	self:CreateShadow(frame)
	self:Proxy("HandleEditBox", frame.SearchBox)
	self:Proxy("HandleDropDownBox", frame.ExpansionDropDown)
	TT:SetStyle(_G.BtWQuestsTooltip)
	TT:SetStyle(frame.Tooltip)
	HandledDropDown(_G.BtWQuestsOptionsMenu)
	HandledDropDown(frame.CharacterDropDown)
	HandledDropDown(frame.ExpansionDropDown)

	local navBar = frame.navBar
	if navBar then
		navBar:ClearAllPoints()
		navBar:Point("TOPLEFT", 20, -30)
		navBar:StripTextures(true)
		navBar.overlay:StripTextures(true)

		navBar:CreateBackdrop()
		navBar.backdrop:Point("TOPLEFT", -2, 0)
		navBar.backdrop:Point("BOTTOMRIGHT")
		HandleNavButton(navBar.home, true)
		navBar:HookScript("OnShow", function(nav)
			if not nav.__windSkin then
				HandledDropDown(nav.dropDown)
				nav.__windSkin = true
			end
		end)
	end

	local SearchPreview = frame.SearchPreview
	if SearchPreview then
		SearchPreview:StripTextures()

		for _, preview in ipairs(SearchPreview.Results) do
			StyleSearchButton(preview)
		end
		StyleSearchButton(SearchPreview.ShowAllResults)
	end

	local SearchResults = frame.SearchResults
	if SearchResults then
		SearchResults:SetMouseClickEnabled(true)
		SearchResults:SetMouseMotionEnabled(true)
		SearchResults:StripTextures()
		SearchResults:CreateBackdrop("Transparent")
		self:CreateBackdropShadow(SearchResults)
		SearchResults.backdrop:Point("TOPLEFT", -10, 0)
		SearchResults.backdrop:Point("BOTTOMRIGHT", 5, 0)
		S:Proxy("HandleCloseButton", SearchResults.CloseButton)
		S:Proxy("HandleScrollBar", SearchResults.scrollFrame and SearchResults.scrollFrame.scrollBar)

		if SearchResults.UpdateSearch then
			hooksecurefunc(SearchResults, "UpdateSearch", ReskinSearchResults)
		end
	end

	if frame.CloseButton and frame.OptionsButton and frame.CharacterDropDown then
		frame.OptionsButton:StripTextures()
		frame.OptionsButton:SetNormalTexture(W.Media.Icons.barGameMenu)
		frame.OptionsButton:SetHighlightTexture(W.Media.Icons.barGameMenu)
		frame.OptionsButton:SetPushedTexture(W.Media.Icons.barGameMenu)
		frame.OptionsButton:SetSize(16, 16)
		frame.OptionsButton:SetHitRectInsets(0, 0, 0, 0)
		frame.OptionsButton:ClearAllPoints()
		frame.OptionsButton:Point("RIGHT", frame.CloseButton, "LEFT", -1, 1)

		frame.CharacterDropDown:ClearAllPoints()
		frame.CharacterDropDown:Point("RIGHT", frame.OptionsButton, "LEFT", -16, -5)
		frame.CharacterDropDown:CreateBackdrop()
		frame.CharacterDropDown.backdrop:ClearAllPoints()
		frame.CharacterDropDown.backdrop:Point("TOPLEFT", 15, 0)
		frame.CharacterDropDown.backdrop:Point("BOTTOMRIGHT", 15, 10)
		self:Proxy("HandleNextPrevButton", frame.CharacterDropDown.Button, "down")
	end

	if frame.NavBack and frame.NavForward and frame.NavHere then
		self:Proxy("HandleNextPrevButton", frame.NavBack)
		frame.NavBack:SetHitRectInsets(0, 0, 0, 0)
		frame.NavBack:ClearAllPoints()
		frame.NavBack:Point("TOPLEFT", 5, -4)

		self:Proxy("HandleNextPrevButton", frame.NavForward)
		frame.NavForward:SetHitRectInsets(0, 0, 0, 0)
		frame.NavForward:ClearAllPoints()
		frame.NavForward:Point("LEFT", frame.NavBack, "RIGHT", 2, 0)

		self:Proxy("HandleNextPrevButton", frame.NavHere, "down", nil, true)
		frame.NavHere:SetHitRectInsets(0, 0, 0, 0)
		frame.NavHere:ClearAllPoints()
		frame.NavHere:Point("LEFT", frame.NavForward, "RIGHT", 2, 0)
	end

	local ExpansionList = frame.ExpansionList
	if ExpansionList then
		for _, expansion in ipairs(ExpansionList.Expansions) do
			expansion:CreateBackdrop("Transparent")
			expansion.backdrop:Point("TOPLEFT", 4, -4)
			expansion.backdrop:Point("BOTTOMRIGHT", -4, 5)
			expansion.Base:SetTexture("")
			self:Proxy("HandleCheckBox", expansion.AutoLoad)
			HandleButton(expansion.ViewAll)
			HandleButton(expansion.Load)
		end
	end

	local Category = frame.Category
	if Category then
		self:Proxy("HandleScrollBar", Category.Scroll and Category.Scroll.ScrollBar)
	end

	local Chain = frame.Chain
	if Chain then
		self:Proxy("HandleScrollBar", Chain.Scroll and Chain.Scroll.ScrollBar)
		TT:SetStyle(Chain.Tooltip)
	end

	hooksecurefunc(_G.BtWQuestsExpansionButtonMixin, "Set", ReskinItemButton)
	hooksecurefunc(_G.BtWQuestsCategoryGridItemMixin, "Set", ReskinItemButton)
	hooksecurefunc(_G.BtWQuestsCategoryListItemMixin, "Set", ReskinItemButton)
	hooksecurefunc(_G.BtWQuestsChainItemMixin, "Set", ReskinItemButton)
end

S:AddCallbackForAddon("BtWQuests")
