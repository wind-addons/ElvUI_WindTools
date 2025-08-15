local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local TT = E:GetModule("Tooltip")

-- Modified from NDui_Plus
local function HandleNavButton(btn, strip, ...)
	S:ESProxy("HandleButton", btn, strip, ...)

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

	S:ESProxy("HandleFrame", button, true)
	S:CreateShadow(button)
	local icon = button.icon or button.Icon
	if icon then
		S:ESProxy("HandleIcon", icon)
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

	local frame = _G.BtWQuestsFrame
	if not frame then
		return
	end

	self:ESProxy("HandlePortraitFrame", frame)
	self:CreateShadow(frame)
	self:ESProxy("HandleEditBox", frame.SearchBox)
	self:ESProxy("HandleDropDownBox", frame.ExpansionDropDown)
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
		navBar:HookScript("OnShow", function(self)
			if not self.__windSkin then
				HandledDropDown(self.dropDown)
				self.__windSkin = true
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
		SearchResults.backdrop:SetPoint("TOPLEFT", -10, 0)
		SearchResults.backdrop:SetPoint("BOTTOMRIGHT", 5, 0)
		S:ESProxy("HandleCloseButton", SearchResults.CloseButton)
		S:ESProxy("HandleScrollBar", SearchResults.scrollFrame and SearchResults.scrollFrame.scrollBar)

		if SearchResults.UpdateSearch then
			hooksecurefunc(SearchResults, "UpdateSearch", ReskinSearchResults)
		end
	end

	if frame.CloseButton and frame.OptionsButton and frame.CharacterDropDown then
		frame.OptionsButton:StripTextures()
		frame.OptionsButton:SetSize(20, 20)
		frame.OptionsButton:SetHitRectInsets(0, 0, 0, 0)
		frame.OptionsButton:ClearAllPoints()
		frame.OptionsButton:SetPoint("RIGHT", frame.CloseButton, "LEFT", -4, 0)

		frame.CharacterDropDown:ClearAllPoints()
		frame.CharacterDropDown:SetPoint("RIGHT", frame.OptionsButton, "LEFT", -14, -4)
		frame.CharacterDropDown:CreateBackdrop()
		frame.CharacterDropDown.backdrop:ClearAllPoints()
		frame.CharacterDropDown.backdrop:Point("TOPLEFT", 15, 0)
		frame.CharacterDropDown.backdrop:Point("BOTTOMRIGHT", 15, 10)
		self:ESProxy("HandleNextPrevButton", frame.CharacterDropDown.Button, "down")
	end

	if frame.NavBack and frame.NavForward and frame.NavHere then
		self:ESProxy("HandleNextPrevButton", frame.NavBack)
		frame.NavBack:SetHitRectInsets(0, 0, 0, 0)
		frame.NavBack:ClearAllPoints()
		frame.NavBack:SetPoint("TOPLEFT", 5, -4)

		self:ESProxy("HandleNextPrevButton", frame.NavForward)
		frame.NavForward:SetHitRectInsets(0, 0, 0, 0)
		frame.NavForward:ClearAllPoints()
		frame.NavForward:SetPoint("LEFT", frame.NavBack, "RIGHT", 2, 0)

		self:ESProxy("HandleNextPrevButton", frame.NavHere, "down", nil, true)
		frame.NavHere:SetHitRectInsets(0, 0, 0, 0)
		frame.NavHere:ClearAllPoints()
		frame.NavHere:SetPoint("LEFT", frame.NavForward, "RIGHT", 2, 0)
	end

	local ExpansionList = frame.ExpansionList
	if ExpansionList then
		for _, expansion in ipairs(ExpansionList.Expansions) do
			expansion:CreateBackdrop("Transparent")
			expansion.backdrop:SetPoint("TOPLEFT", 4, -4)
			expansion.backdrop:SetPoint("BOTTOMRIGHT", -4, 5)
			expansion.Base:SetTexture("")
			self:ESProxy("HandleCheckBox", expansion.AutoLoad)
			HandleButton(expansion.ViewAll)
			HandleButton(expansion.Load)
		end
	end

	local Category = frame.Category
	if Category then
		self:ESProxy("HandleScrollBar", Category.Scroll and Category.Scroll.ScrollBar)
	end

	local Chain = frame.Chain
	if Chain then
		self:ESProxy("HandleScrollBar", Chain.Scroll and Chain.Scroll.ScrollBar)
		TT:SetStyle(Chain.Tooltip)
	end

	hooksecurefunc(_G.BtWQuestsExpansionButtonMixin, "Set", ReskinItemButton)
	hooksecurefunc(_G.BtWQuestsCategoryGridItemMixin, "Set", ReskinItemButton)
	hooksecurefunc(_G.BtWQuestsCategoryListItemMixin, "Set", ReskinItemButton)
	hooksecurefunc(_G.BtWQuestsChainItemMixin, "Set", ReskinItemButton)
end

S:AddCallbackForAddon("BtWQuests")
