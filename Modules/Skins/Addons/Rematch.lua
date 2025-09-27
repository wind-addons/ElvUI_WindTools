---@diagnostic disable: undefined-field
local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local MF = W.Modules.MoveFrames
local ES = E:GetModule("Skins")
local TT = E:GetModule("Tooltip")
local C = W.Utilities.Color

local _G = _G
local hooksecurefunc = hooksecurefunc
local next = next
local pairs = pairs
local select = select
local unpack = unpack

local CollectionsJournal_LoadUI = CollectionsJournal_LoadUI
local CreateFrame = CreateFrame

local function ReskinIconButton(button)
	if not button or button.__windSkin then
		return
	end
	button:StyleButton(nil, true)

	if button.Back then
		button.Back:Kill()
	end

	if button.Border then
		button.Border:SetAlpha(0)
	end

	if button.Status then
		button.Status:SetTexture(E.media.blankTex)
		button.Status:SetVertexColor(1, 0, 0, 0.3)
	end

	if button.Texture then
		button.Texture:SetTexCoord(unpack(E.TexCoords))
	end

	if button.Icon then
		button.Icon:CreateBackdrop()
	end

	if button.IconBorder then
		button.IconBorder:Hide()
	end

	if button.Selected then
		button.Selected:SetTexture(E.media.blankTex)
		button.Selected:SetVertexColor(1, 1, 1, 0.3)
	end

	if button.hover and button.Icon then
		button.hover:ClearAllPoints()
		button.hover:SetAllPoints(button.Icon)
	end

	button.__windSkin = true
end

local function ReskinCloseButton(button)
	if not button then
		return
	end
	ES:HandleCloseButton(button)
	button.Icon = E.noop
	button.SetNormalTexture = E.noop
	button.SetPushedTexture = E.noop
	button.SetHighlightTexture = E.noop
end

local function ClearTextureButton(button, icon)
	if not button then
		return
	end
	if icon then
		icon = button.Icon:GetTexture()
	else
		button.Icon = E.noop
	end

	button:StripTextures()
	button.SetNormalTexture = E.noop
	button.SetPushedTexture = E.noop
	button.SetHighlightTexture = E.noop
	button.Icon:SetTexture(icon)
end

---Reskin the Rematch button
---@param button Button
local function ReskinButton(button)
	if button.Back then
		if button.Back.IsObjectType and button.Back:IsObjectType("Texture") then
			button.Back:Kill()
		elseif type(button.Back) == "table" then
			for _, tex in pairs(button.Back) do
				tex:Kill()
			end
		end
	end

	if button.Highlight then
		if button.Highlight.IsObjectType and button.Highlight:IsObjectType("Texture") then
			button.Highlight:Kill()
		elseif type(button.Highlight) == "table" then
			for _, tex in pairs(button.Highlight) do
				tex:Kill()
			end
		end
	end

	S:Proxy("HandleButton", button)
end

local function ReskinFilterButton(button)
	if not button then
		return
	end
	ReskinButton(button)
	button.Arrow:OldSetTexture(E.Media.Textures.ArrowUp)
	button.Arrow:SetRotation(ES.ArrowRotation.right)
end

local function ReskinEditBox(editBox)
	local searchIconTex
	if editBox.SearchIcon and editBox.SearchIcon.GetTexture then
		searchIconTex = editBox.SearchIcon:GetTexture()
	end
	editBox:StripTextures()
	if searchIconTex then
		editBox.SearchIcon:SetTexture(searchIconTex)
	end

	ES:HandleEditBox(editBox)
	editBox.backdrop:SetOutside(0, 0)
end

local function ReskinDropdown(dropdown) -- modified from NDui
	dropdown:SetBackdrop(nil)
	dropdown:StripTextures()
	dropdown:CreateBackdrop()
	dropdown.backdrop:SetInside(dropdown, 2, 2)
	if dropdown.Icon then
		dropdown.Icon:SetAlpha(1)
		dropdown.Icon:CreateBackdrop()
	end
	local arrow = dropdown:GetChildren()
	ES:HandleNextPrevButton(arrow, "down")
end

local function ReskinScrollBar(scrollBar)
	ES:HandleScrollBar(scrollBar)
	scrollBar.Thumb.backdrop:ClearAllPoints()
	scrollBar.Thumb.backdrop:Point("TOPLEFT", scrollBar.Thumb, "TOPLEFT", 3, -3)
	scrollBar.Thumb.backdrop:Point("BOTTOMRIGHT", scrollBar.Thumb, "BOTTOMRIGHT", -1, 3)

	ReskinButton(scrollBar.BottomButton)
	local tex = scrollBar.BottomButton:GetNormalTexture()
	tex:SetTexture(E.media.blankTex)
	tex:SetVertexColor(1, 1, 1, 0)

	tex = scrollBar.BottomButton:GetPushedTexture()
	tex:SetTexture(E.media.blankTex)
	tex:SetVertexColor(1, 1, 1, 0.3)

	ReskinButton(scrollBar.TopButton)
	tex = scrollBar.TopButton:GetNormalTexture()
	tex:SetTexture(E.media.blankTex)
	tex:SetVertexColor(1, 1, 1, 0)

	tex = scrollBar.TopButton:GetPushedTexture()
	tex:SetTexture(E.media.blankTex)
	tex:SetVertexColor(1, 1, 1, 0.3)
end

local function ReskinXPBar(bar)
	if not bar then
		return
	end
	local iconTex = bar.Icon and bar.Icon:GetTexture()
	bar:StripTextures()
	if iconTex then
		bar.Icon:SetTexture(iconTex)
	end
	bar:SetStatusBarTexture(E.media.normTex)
	bar:CreateBackdrop("Transparent")
end

local function ReskinCard(card) -- modified from NDui
	if not card then
		return
	end

	card:SetBackdrop(nil)
	card:CreateBackdrop("Transparent")
	S:CreateBackdropShadow(card)

	if card.Source then
		card.Source:StripTextures()
	end

	card.Middle:StripTextures()

	if card.Middle.XP then
		ReskinXPBar(card.Middle.XP)
		card.Middle.XP:Height(15)
	end

	if card.Middle.Lore then
		F.SetFontOutline(card.Middle.Lore, E.db.general.font)
		card.Middle.Lore:SetTextColor(1, 1, 1, 1)
	end

	if card.Bottom.AbilitiesBG then
		card.Bottom.AbilitiesBG:Hide()
	end

	if card.Bottom.BottomBG then
		card.Bottom.BottomBG:Hide()
	end
end

local function ReskinTooltip(tooltip)
	if not tooltip then
		return
	end

	tooltip:StripTextures()
	tooltip:CreateBackdrop("Transparent")
	S:CreateBackdropShadow(tooltip)

	TT:SetStyle(tooltip)
end

local function ReskinOptions(list)
	local buttons = list.ScrollFrame.Buttons
	if not buttons then
		return
	end
	for i = 1, #buttons do
		local button = buttons[i]
		if not button.__windSkin then
			ES:HandleButton(button)
			button.backdrop:SetInside(button, 1, 1)
			button.HeaderBack:StripTextures()
			button.HeaderBack = button.backdrop
			button.__windSkin = true
		end
	end
end

local function ReskinTeamList(panel)
	if panel then
		for i = 1, 3 do
			local loadout = panel.Loadouts[i]
			if loadout and not loadout.__windSkin then
				loadout:StripTextures()
				ES:HandleButton(loadout)
				loadout.backdrop:SetInside(loadout, 2, 2)
				ReskinIconButton(loadout.Pet.Pet)
				if loadout.Pet.Pet.Level then
					loadout.Pet.Pet.Level.Text:SetTextColor(1, 1, 1)
					loadout.Pet.Pet.Level.Text:FontTemplate()
					loadout.Pet.Pet.Level.BG:SetTexture(nil)
				end
				ReskinXPBar(loadout.HP)
				ReskinXPBar(loadout.XP)
				loadout.XP:SetSize(255, 7)
				loadout.HP.MiniHP:SetText("HP")
				for j = 1, 3 do
					ReskinIconButton(loadout.Abilities[j])
				end

				loadout.__windSkin = true
			end
		end
	end
end

local function ReskinFlyout(frame)
	if not frame or frame.__windSkin then
		return
	end

	frame:SetBackdrop(nil)
	frame:CreateBackdrop()
	frame.backdrop:SetInside(frame, 2, 2)
	S:CreateBackdropShadow(frame)
	hooksecurefunc(frame, "Show", function(self)
		local abilities = self.Abilities
		if abilities then
			for i = 1, #abilities do
				local ability = abilities[i]
				ReskinIconButton(ability)
			end
		end
	end)
	frame.__windSkin = true
end

function S:Rematch_LeftBottom()
	if not _G.RematchPetPanel.List then
		return
	end

	local list = _G.RematchPetPanel.List

	list.Background:Kill()
	list:CreateBackdrop()
	list.backdrop:SetInside(list, 1, 2)
	ReskinScrollBar(list.ScrollFrame.ScrollBar)

	hooksecurefunc(_G.RematchPetPanel.List, "Update", reskinPetList)
	hooksecurefunc(_G.RematchQueuePanel.List, "Update", reskinPetList)
end

function S:Rematch_Middle() -- Modified from NDui
	local panel = _G.RematchLoadoutPanel and _G.RematchLoadoutPanel.Target
	if panel then
		panel:StripTextures()
		panel:CreateBackdrop()
		ReskinButton(panel.TargetButton)
		panel.ModelBorder:SetBackdrop(nil)
		panel.ModelBorder:DisableDrawLayer("BACKGROUND")
		panel.ModelBorder:CreateBackdrop("Transparent")
		panel.ModelBorder.backdrop:SetInside(panel.ModelBorder, 4, 3)
		ReskinButton(panel.LoadSaveButton)
		for i = 1, 3 do
			local button = panel["Pet" .. i]
			if button then
				button:StripTextures()
				ReskinIconButton(button)
			end
		end
	end

	ReskinTeamList(_G.RematchLoadoutPanel)
	ReskinFlyout(_G.RematchLoadoutPanel.Flyout)
	hooksecurefunc(_G.RematchLoadoutPanel, "UpdateLoadouts", ReskinTeamList)

	-- Target Panel
	panel = _G.RematchLoadoutPanel and _G.RematchLoadoutPanel.TargetPanel
	if panel then
		panel.Top:StripTextures()
		ReskinButton(panel.Top.BackButton)
		ReskinEditBox(panel.Top.SearchBox)
		panel.Top.SearchBox:ClearAllPoints()
		panel.Top.SearchBox:Point("TOPLEFT", panel.Top, "TOPLEFT", 3, -3)
		panel.Top.SearchBox:Point("RIGHT", panel.Top.BackButton, "LEFT", -2, 0)
		panel.List.Background:Kill()
		panel.List:CreateBackdrop()
		panel.List.backdrop:SetInside(panel.List, 2, 2)
		ReskinScrollBar(panel.List.ScrollFrame.ScrollBar)
		hooksecurefunc(panel.List, "Update", reskinPetList)
	end
end

function S:Rematch_Right() -- Modified from NDui
	-- Team Panel
	local panel = _G.RematchTeamPanel
	if panel then
		panel.Top:StripTextures()
		ReskinEditBox(panel.Top.SearchBox)
		panel.Top.SearchBox:ClearAllPoints()
		panel.Top.SearchBox:Point("TOPLEFT", panel.Top, "TOPLEFT", 3, -3)
		panel.Top.SearchBox:Point("RIGHT", panel.Top.Teams, "LEFT", -2, 0)
		ReskinFilterButton(panel.Top.Teams)
		panel.List.Background:Kill()
		panel.List:CreateBackdrop()
		panel.List.backdrop:SetInside(panel.List, 0, 2)
		ReskinScrollBar(panel.List.ScrollFrame.ScrollBar)
		hooksecurefunc(panel.List, "Update", reskinPetList)
	end

	-- Queue Panel
	panel = _G.RematchQueuePanel
	if panel then
		panel.Top:StripTextures()
		ReskinFilterButton(panel.Top.QueueButton)
		panel.List.Background:Kill()
		panel.List:CreateBackdrop()
		panel.List.backdrop:SetInside(panel.List, 2, 2)
		ReskinScrollBar(panel.List.ScrollFrame.ScrollBar)
		hooksecurefunc(panel.List, "Update", reskinPetList)
	end

	-- Option Panel
	panel = _G.RematchOptionPanel
	if panel then
		panel.Top:StripTextures()
		ReskinEditBox(panel.Top.SearchBox)
		for i = 1, 4 do
			ReskinIconButton(panel.Growth.Corners[i])
		end
		panel.List.Background:Kill()
		panel.List:CreateBackdrop()
		panel.List.backdrop:SetInside(panel.List, 2, 2)
		ReskinScrollBar(panel.List.ScrollFrame.ScrollBar)
		hooksecurefunc(panel.List, "Update", ReskinOptions)
	end
end

function S:Rematch_Footer()
	-- Tabs
	for _, tab in pairs({ _G.RematchJournal.PanelTabs:GetChildren() }) do
		tab:StripTextures()
		tab:CreateBackdrop("Transparent")
		tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -1 or -3)
		tab.backdrop:Point("BOTTOMRIGHT", -10, 3)
		F.SetFontOutline(tab.Text)
		self:CreateBackdropShadow(tab)
	end

	-- Buttons
	ReskinButton(_G.RematchBottomPanel.SummonButton)
	ReskinButton(_G.RematchBottomPanel.SaveButton)
	ReskinButton(_G.RematchBottomPanel.SaveAsButton)
	ReskinButton(_G.RematchBottomPanel.FindBattleButton)
	ES:HandleCheckBox(_G.RematchBottomPanel.UseDefault)

	hooksecurefunc(_G.RematchJournal, "SetupUseRematchButton", function()
		if _G.UseRematchButton then
			ES:HandleCheckBox(_G.UseRematchButton)
		end
	end)
end

function S:Rematch_Dialog() -- Modified from NDui
	if not _G.RematchDialog then
		return
	end

	-- Background
	local dialog = _G.RematchDialog
	dialog:StripTextures()
	dialog.Prompt:StripTextures()
	dialog:CreateBackdrop("Transparent")
	self:CreateBackdropShadow(dialog)

	-- Buttons
	ReskinCloseButton(dialog.CloseButton)
	ReskinButton(dialog.Accept)
	ReskinButton(dialog.Cancel)

	-- Icon selector
	ReskinIconButton(dialog.Slot)
	ReskinEditBox(dialog.EditBox)
	dialog.TeamTabIconPicker:StripTextures()
	dialog.TeamTabIconPicker:CreateBackdrop()
	ES:HandleScrollBar(dialog.TeamTabIconPicker.ScrollFrame.ScrollBar)
	hooksecurefunc(_G.RematchTeamTabs, "UpdateTabIconPickerList", function()
		-- modified from NDui
		local buttons = dialog.TeamTabIconPicker.ScrollFrame.buttons
		for i = 1, #buttons do
			local line = buttons[i]
			for j = 1, 10 do
				local button = line.Icons[j]
				if button and not button.__windSkin then
					button:Size(26, 26)
					button.Icon = button.Texture
					ReskinIconButton(button)
					button.__windSkin = true
				end
			end
		end
	end)

	-- Checkbox
	ES:HandleCheckBox(dialog.CheckButton)

	-- Dropdown
	ReskinDropdown(dialog.SaveAs.Target)
	ReskinDropdown(dialog.TabPicker)

	-- Save as [team]
	hooksecurefunc(_G.Rematch, "UpdateSaveAsDialog", function()
		for i = 1, 3 do
			local button = _G.RematchDialog.SaveAs.Team.Pets[i]
			ReskinIconButton(button)
			button.Icon.backdrop:SetBackdropBorderColor(button.IconBorder:GetVertexColor())
			local abilities = button.Abilities
			if abilities then
				for j = 1, #abilities do
					ReskinIconButton(abilities[j])
				end
			end
		end
	end)

	-- Collection
	local collection = dialog.CollectionReport
	hooksecurefunc(_G.Rematch, "ShowCollectionReport", function()
		for i = 1, 4 do
			local bar = collection.RarityBar[i]
			bar:SetTexture(E.media.normTex)
		end
		if not collection.RarityBarBorder.backdrop then
			collection.RarityBarBorder:StripTextures()
			collection.RarityBarBorder:CreateBackdrop("Transparent")
			collection.RarityBarBorder.backdrop:SetInside(collection.RarityBarBorder, 6, 5)
		end
	end)

	hooksecurefunc(collection, "UpdateChart", function()
		for i = 1, 10 do
			local col = collection.Chart.Columns[i]
			col.Bar:SetTexture(E.media.blankTex)
			col.IconBorder:Hide()
		end
	end)
	ReskinDropdown(collection.ChartTypeComboBox)
	collection.Chart:StripTextures()
	collection.Chart:CreateBackdrop("Transparent")
	collection.Chart.backdrop:SetInside(collection.Chart, 2, 2)
	ES:HandleRadioButton(collection.ChartTypesRadioButton)
	ES:HandleRadioButton(collection.ChartSourcesRadioButton)
end

function S:Rematch_AbilityCard()
	if not _G.RematchAbilityCard then
		return
	end

	local card = _G.RematchAbilityCard
	card:SetBackdrop(nil)
	card.TitleBG:SetAlpha(0)
	card.Hints.HintsBG:SetAlpha(0)
	card:CreateBackdrop("Transparent")
	self:CreateBackdropShadow(card)
end

function S:Rematch_PetCard()
	if not _G.RematchPetCard then
		return
	end

	local card = _G.RematchPetCard
	card:StripTextures()
	card.Title:StripTextures()
	card:CreateBackdrop("Transparent")
	self:CreateBackdropShadow(card)
	ReskinCloseButton(card.CloseButton)
	ES:HandleNextPrevButton(card.PinButton, "up")
	card.PinButton:ClearAllPoints()
	card.PinButton:Point("TOPLEFT", 3, -3)
	ReskinCard(card.Front)
	ReskinCard(card.Back)

	for i = 1, 6 do
		local button = card.Front.Bottom.Abilities[i]
		button.IconBorder:Kill()
		select(8, button:GetRegions()):SetTexture(nil)
		ReskinIconButton(button.Icon)
	end
end

function S:Rematch_RightTabs()
	hooksecurefunc(_G.RematchTeamTabs, "Update", function(tabs)
		for _, tab in next, tabs.Tabs do
			if tab and not tab.__windSkin then
				tab.Background:Kill()
				ReskinIconButton(tab)
				self:CreateBackdropShadow(tab.Icon)
				tab:Size(40, 40)
				tab.__windSkin = true
			end
		end
	end)
end

function S:Rematch_Standalone()
	if not _G.RematchFrame then
		return
	end

	local frame = _G.RematchFrame
	frame:StripTextures()
	frame:CreateBackdrop()
	self:CreateBackdropShadow(frame)

	frame.TitleBar:StripTextures()
	ReskinCloseButton(frame.TitleBar.CloseButton)
	ClearTextureButton(frame.TitleBar.MinimizeButton, true)
	ClearTextureButton(frame.TitleBar.SinglePanelButton, true)
	ClearTextureButton(frame.TitleBar.LockButton, true)

	for _, tab in pairs({ frame.PanelTabs:GetChildren() }) do
		tab:StripTextures()
		tab:CreateBackdrop("Transparent")
		tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -1 or -3)
		tab.backdrop:Point("BOTTOMRIGHT", -10, 3)
		F.SetFontOutline(tab.Text)
		self:CreateBackdropShadow(tab)
	end

	-- Mini Panel
	local mini = _G.RematchMiniPanel
	if mini then
		ReskinFlyout(mini.Flyout)
		hooksecurefunc(mini, "Update", function(panel)
			panel.Background:Kill()
			local pets = panel.Pets
			for i = 1, 3 do
				local button = panel.Pets[i]
				ReskinIconButton(button)
				button.Icon.backdrop:SetBackdropBorderColor(button.IconBorder:GetVertexColor())
				local abilities = button.Abilities
				if abilities then
					for j = 1, #abilities do
						ReskinIconButton(abilities[j])
					end
				end
				ReskinXPBar(button.HP)
				ReskinXPBar(button.XP)
			end
		end)
	end
end

function S:Rematch_SkinLoad()
	if _G.RematchJournal.skinLoaded then
		return
	end

	S:Rematch_Middle()

	-- Mini frame target
	if _G.RematchMiniPanel.Target then
		local panel = _G.RematchMiniPanel.Target
		local greenCheckTex = panel.GreenCheck and panel.GreenCheck:GetTexture()
		panel:StripTextures()
		if greenCheckTex then
			panel.GreenCheck:SetTexture(greenCheckTex)
		end
		panel:CreateBackdrop()
		panel.ModelBorder:SetBackdrop(nil)
		panel.ModelBorder:DisableDrawLayer("BACKGROUND")
		panel.ModelBorder:CreateBackdrop("Transparent")
		panel.ModelBorder.backdrop:SetInside(panel.ModelBorder, 4, 3)
		ReskinButton(panel.LoadButton)
		for i = 1, 3 do
			local button = panel.Pets[i]
			if button then
				ReskinIconButton(button)
			end
		end
	end

	-- Tooltip

	_G.RematchJournal.skinLoaded = true
end

local function ReskinCardStatusBar(parent, key)
	if not parent or not key or not parent[key] or parent[key].__windSkin then
		return
	end

	parent[key]:SetTexture(E.media.normTex)
	parent[key .. "Frame"] = CreateFrame("Frame", nil, parent)
	parent[key .. "Frame"]:SetTemplate("Transparent")
	parent[key .. "Frame"]:SetAllPoints(parent[key .. "Back"])
	parent[key .. "Back"]:SetAlpha(0)
	parent[key .. "Border"]:SetAlpha(0)
	parent[key]:SetParent(parent[key .. "Frame"])

	parent[key].__windSkin = true
end

local function ReskinPet(frame)
	if not frame or frame.__windSkin then
		return
	end

	frame.Border:SetAlpha(0)
	frame.windIconBorder = CreateFrame("Frame", nil, frame)
	frame.windIconBorder:SetOutside(frame.Icon)
	frame.windIconBorder:SetTemplate()
	hooksecurefunc(frame.Border, "SetVertexColor", function(self, r, g, b)
		frame.windIconBorder:SetBackdropBorderColor(r, g, b)
	end)
	frame.Border:SetVertexColor(frame.Border:GetVertexColor())
	frame.windIconBorder:SetFrameLevel(max(0, frame:GetFrameLevel() - 1))

	frame.LevelBubble:Kill()
	F.SetFontOutline(frame.LevelText, E.db.general.font)
	frame.LevelText:SetJustifyH("RIGHT")
	frame.LevelText:ClearAllPoints()
	frame.LevelText:Point("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 2, 0)

	frame.__windSkin = true
end

local function ReskinMainFrame(frame)
	frame:StripTextures()
	frame:SetTemplate()
	S:CreateShadow(frame)
	if not E.private.WT.skins.shadow then
		return
	end
	hooksecurefunc(frame, "Show", function()
		if _G.CollectionsJournal and _G.CollectionsJournal.shadow then
			_G.CollectionsJournal.shadow:Hide()
		end
	end)

	hooksecurefunc(frame, "Hide", function()
		if _G.CollectionsJournal and _G.CollectionsJournal.shadow then
			_G.CollectionsJournal.shadow:Show()
		end
	end)
end

local function ReskinTitleBar(frame)
	if not frame then
		return
	end

	frame.Portrait:Kill()
	F.SetFontOutline(frame.Title)
	S:Proxy("HandleCloseButton", frame.CloseButton)
end

local function ReskinToolBar(frame)
	frame:StripTextures()

	if frame.TotalsButton then
		frame.TotalsButton:StripTextures()
		frame.TotalsButton:CreateBackdrop("Transparent")
		frame.TotalsButton.backdrop:Point("TOPLEFT", 0, 0)
	end

	ReskinIconButton(frame.BandageButton)
	ReskinIconButton(frame.ExportTeamButton)
	ReskinIconButton(frame.FindBattleButton)
	ReskinIconButton(frame.HealButton)
	ReskinIconButton(frame.ImportTeamButton)
	ReskinIconButton(frame.LesserPetTreatButton)
	ReskinIconButton(frame.LevelingStoneButton)
	ReskinIconButton(frame.PetSatchelButton)
	ReskinIconButton(frame.PetTreatButton)
	ReskinIconButton(frame.RandomTeamButton)
	ReskinIconButton(frame.RarityStoneButton)
	ReskinIconButton(frame.SafariHatButton)
	ReskinIconButton(frame.SaveAsButton)
	ReskinIconButton(frame.SummonPetButton)
end

local function ReskinPetListButton(frame)
	if not frame then
		return
	end

	for _, child in pairs({ frame:GetChildren() }) do
		if not child.__windSkin and child.data and child.parentKey and child.Top then
			child:CreateBackdrop()
			child.backdrop:SetInside(child, 1, 1)
			child.backdrop.Center:Kill()
			hooksecurefunc(child.Top, "SetVertexColor", function(t, r, g, b, a)
				child.backdrop:SetBackdropBorderColor(r, g, b)
			end)
			child.Top:SetVertexColor(child.Top:GetVertexColor())

			S:Proxy("HandleBlizzardRegions", child)
			child.Top:Kill()
			child.Bottom:Kill()

			child.__windSkin = true
		end
	end

	if frame.__windSkin then
		return
	end

	ReskinPet(frame)
	frame.Back:Kill()
	frame.windHighlight = frame:CreateTexture(nil, "OVERLAY")
	frame.windHighlight:SetTexture(E.media.blankTex)
	frame.windHighlight:SetAllPoints(frame.Back)
	frame.windHighlight:SetVertexColor(1, 1, 1, 0.2)
	frame.windHighlight:Hide()
	frame:HookScript("OnEnter", function()
		frame.windHighlight:Show()
	end)
	frame:HookScript("OnLeave", function()
		frame.windHighlight:Hide()
	end)
end

local function ReskinPetsPanel(frame)
	if not frame then
		return
	end

	-- Top Filter
	frame.Top:StripTextures()
	frame.Top:CreateBackdrop("Transparent")
	S:Reposition(frame.Top.backdrop, frame.Top, 0, 0, 1, 0, 0)
	local toggleIconTex = frame.Top.ToggleButton.Icon:GetTexture()
	frame.Top.ToggleButton:StripTextures()
	frame.Top.ToggleButton.Icon:SetTexture(toggleIconTex)
	S:Proxy("HandleButton", frame.Top.ToggleButton)
	S:Proxy("HandleEditBox", frame.Top.SearchBox)
	for _, tex in pairs(frame.Top.SearchBox.Back) do
		tex:Kill()
	end
	frame.Top.SearchBox:ClearAllPoints()
	frame.Top.SearchBox:Point("TOPLEFT", frame.Top.ToggleButton, "TOPRIGHT", 5, 0)
	frame.Top.SearchBox:Point("BOTTOMRIGHT", frame.Top.FilterButton, "BOTTOMLEFT", -5, 0)
	frame.Top.FilterButton:StripTextures()
	S:Proxy("HandleButton", frame.Top.FilterButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")

	-- Top Type Bar
	F.Move(frame.Top.TypeBar, 0, -4)
	frame.Top.TypeBar:CreateBackdrop()
	S:Reposition(frame.Top.TypeBar.backdrop, frame.Top.TypeBar, 2, -25, -4, -4, -4)
	frame.Top.TypeBar.Level25Button:StripTextures()
	frame.Top.TypeBar.Level25Button:CreateBackdrop()
	frame.Top.TypeBar.Level25Button:HookScript("OnEnter", function()
		frame.Top.TypeBar.Level25Button.backdrop:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
	end)
	frame.Top.TypeBar.Level25Button:HookScript("OnLeave", function()
		frame.Top.TypeBar.Level25Button.backdrop:SetBackdropBorderColor(0, 0, 0)
	end)
	frame.Top.TypeBar.Level25Button.Text = frame.Top.TypeBar.Level25Button.backdrop:CreateFontString(nil, "OVERLAY")
	frame.Top.TypeBar.Level25Button.Text:FontTemplate(nil, 10)
	frame.Top.TypeBar.Level25Button.Text:SetText("25")
	frame.Top.TypeBar.Level25Button.Text:Point("CENTER", 1, 0)

	local newHighlight = frame.Top.TypeBar.backdrop:CreateTexture(nil, "OVERLAY")
	newHighlight:SetAllPoints(frame.Top.TypeBar.Level25Button)
	newHighlight:SetTexture(E.media.blankTex)
	newHighlight:SetVertexColor(1, 0.875, 0.125, 0.3)
	newHighlight:SetShown(frame.Top.TypeBar.Level25Highlight:IsShown())
	frame.Top.TypeBar.Level25Highlight:Kill()
	frame.Top.TypeBar.Level25Highlight = newHighlight

	frame.Top.TypeBar.TabbedBorder:SetAlpha(0)

	if frame.Top.TypeBar.Tabs then
		for i = 1, #frame.Top.TypeBar.Tabs do
			local tab = frame.Top.TypeBar.Tabs[i]
			tab:Height(25)
			S:Proxy("HandleTab", tab)
			F.InternalizeMethod(tab.Text, "SetPoint")
			hooksecurefunc(tab.Text, "SetPoint", function(t)
				F.Move(t, 0, 2)
			end)
			F.Move(tab.Text, 0, 2)
			F.Move(tab, 0, 1)
		end
	end

	if frame.Top.TypeBar.Buttons then
		for i = 1, #frame.Top.TypeBar.Buttons do
			ReskinIconButton(frame.Top.TypeBar.Buttons[i])
		end
	end

	if frame.Top.TypeBar.Selecteds then
		for i = 1, #frame.Top.TypeBar.Selecteds do
			local texture = frame.Top.TypeBar.Selecteds[i]
			texture:SetTexture(E.media.blankTex)
			F.InternalizeMethod(texture, "SetVertexColor")
			texture.SetVertexColor = function(t, r, g, b, a)
				F.CallMethod(t, "SetVertexColor", r, g, b, (a or 0.4) / 3)
			end
			texture:SetVertexColor(texture:GetVertexColor())
		end
	end

	frame.ResultsBar:StripTextures()
	frame.ResultsBar:CreateBackdrop("Transparent")
	frame.ResultsBar.backdrop:SetInside(frame.ResultsBar)

	frame.List:StripTextures()
	S:Proxy("HandleFrame", frame.List)
	S:Proxy("HandleTrimScrollBar", frame.List.ScrollBar)
	S:ReskinIconButton(frame.List.ScrollToTopButton, W.Media.Icons.buttonGoEnd, 21, 1.571)
	F.Move(frame.List.ScrollToTopButton, -1, -1)
	S:ReskinIconButton(frame.List.ScrollToBottomButton, W.Media.Icons.buttonGoEnd, 21, -1.571)

	hooksecurefunc(frame.List, "Refresh", function()
		frame.List.ScrollBox:ForEachFrame(ReskinPetListButton)
	end)

	frame.List.ScrollBox:ForEachFrame(ReskinPetListButton)
end

local function ReskinTooltipsAndMenus()
	_G.RematchTooltip:StripTextures()
	_G.RematchTooltip:CreateBackdrop("Transparent")
	S:CreateBackdropShadow(_G.RematchTooltip)

	_G.FloatingPetBattleAbilityTooltip:StripTextures()
	_G.FloatingPetBattleAbilityTooltip:CreateBackdrop("Transparent")
	S:CreateBackdropShadow(_G.FloatingPetBattleAbilityTooltip)

	S:TryPostHook("RematchMenuFrameMixin", "OnUpdate", function(self)
		if not self.__windSkin then
			self.Title:StripTextures()
			self:StripTextures()
			self:CreateBackdrop("Transparent")
			S:CreateBackdropShadow(self)
			self.__windSkin = true
		end
	end)
end

local function ReskinBottomBar(frame)
	if not frame then
		return
	end

	ReskinButton(frame.SummonButton)
	S:Proxy("HandleCheckBox", frame.UseRematchCheckButton)
	ReskinButton(frame.SaveButton)
	F.Move(frame.SaveButton, -2, 0)
	ReskinButton(frame.SaveAsButton)
	F.Move(frame.SaveAsButton, -2, 0)
	ReskinButton(frame.FindBattleButton)
end

local function ReskinPanelTabs(frame)
	if not frame or frame.__windSkin then
		return
	end

	for _, tab in pairs({ frame:GetChildren() }) do
		S:Proxy("HandleTab", tab)
		S:ReskinTab(tab)
		F.InternalizeMethod(tab.Text, "SetPoint", true)
		F.CallMethod(tab.Text, "SetPoint", "CENTER", 0, 0)
	end

	F.InternalizeMethod(frame, "SetPoint")
	hooksecurefunc(frame, "SetPoint", function()
		F.Move(frame, 7, -2)
	end)
	F.Move(frame, 7, -2)

	frame.__windSkin = true
end

local function ReskinLoadedTargetPanel(frame, petsPanel, targetsPanel)
	if not frame then
		return
	end

	frame:StripTextures()
	frame:SetTemplate("Transparent")
	frame:ClearAllPoints()
	frame:Point("TOPLEFT", petsPanel, "TOPRIGHT", 3, -1)
	frame:Point("BOTTOMRIGHT", targetsPanel, "BOTTOMLEFT", -3, -75)
	ReskinButton(frame.BigLoadSaveButton)

	frame.titleBackdrop = frame:CreateTexture(nil, "ARTWORK")
	frame.titleBackdrop:Point("TOPLEFT", frame, "TOPLEFT", 1, -1)
	frame.titleBackdrop:Point("BOTTOMRIGHT", frame, "TOPRIGHT", -1, -25)
	frame.titleBackdrop:SetTexture(E.media.blankTex)
	frame.titleBackdrop:SetVertexColor(C.ExtractRGBAFromTemplate("gray-400"))
	frame.titleBackdrop:SetAlpha(0.1)

	local EnemyTeam = frame.EnemyTeam
	if EnemyTeam then
		EnemyTeam.Border:Kill()
	end

	ReskinIconButton(frame.SmallRandomButton)
	F.InternalizeMethod(frame.SmallRandomButton, "SetPoint")
	hooksecurefunc(frame.SmallRandomButton, "SetPoint", function()
		F.Move(frame.SmallRandomButton, 1, 2)
	end)
	F.Move(frame.SmallRandomButton, 1, 2)
	ReskinIconButton(frame.SmallSaveButton)
	ReskinIconButton(frame.SmallTeamsButton)
end

local function ReskinLoadedTeamPanel(frame)
	if not frame then
		return
	end

	frame:StripTextures()
	frame.NotesFrame:StripTextures()
	ReskinIconButton(frame.NotesFrame.NotesButton)
	frame.PreferencesFrame:StripTextures()
	ReskinIconButton(frame.PreferencesFrame.PreferencesButton)
	frame.TeamButton:StripTextures()
	ReskinButton(frame.TeamButton)
end

local function ReskinLoadout(frame)
	if not frame or frame.__windSkin then
		return
	end

	S:Proxy("HandleBlizzardRegions", frame)
	frame.Top:Kill()
	frame.Bottom:Kill()
	frame.Back:Kill()
	frame.Highlight:SetTexture(E.media.blankTex)
	frame.Highlight:SetVertexColor(1, 1, 1, 0.1)
	frame:SetTemplate()

	ReskinPet(frame.Pet)

	local AbilityBar = frame.AbilityBar
	if AbilityBar then
		AbilityBar.AbilitiesBorder:Kill()
		for _, child in pairs({ AbilityBar:GetChildren() }) do
			if child ~= AbilityBar.AbilitiesBorder then
				child:CreateBackdrop()
			end
		end
	end

	ReskinCardStatusBar(frame, "HpBar")
	ReskinCardStatusBar(frame, "XpBar")

	frame.__windSkin = true
end

local function ReskinLoadoutPanel(frame)
	if not frame then
		return
	end

	hooksecurefunc(frame, "Update", function()
		for _, loadout in pairs(frame.Loadouts) do
			ReskinLoadout(loadout)
		end
	end)

	for _, loadout in pairs(frame.Loadouts) do
		ReskinLoadout(loadout)
	end

	local AbilityFlyout = frame.AbilityFlyout
	if AbilityFlyout then
		AbilityFlyout:CreateBackdrop()
		AbilityFlyout.backdrop:SetInside(AbilityFlyout, 1, 1)
		AbilityFlyout.backdrop:SetFrameLevel(AbilityFlyout:GetFrameLevel())
		S:CreateBackdropShadow(AbilityFlyout)
		AbilityFlyout.Border:Kill()

		for _, button in pairs({ AbilityFlyout:GetChildren() }) do
			if button ~= AbilityFlyout.Border and button ~= AbilityFlyout.anchoredTo then
				ReskinIconButton(button)
			end
		end

		hooksecurefunc(AbilityFlyout, "FillAbilityFlyout", function(self)
			if self.__windSkin then
				return
			end
			AbilityFlyout.AbilitySelecteds[1]:SetTexture(E.media.blankTex)
			AbilityFlyout.AbilitySelecteds[1]:SetVertexColor(C.ExtractRGBAFromTemplate("yellow-300"))
			AbilityFlyout.AbilitySelecteds[1]:SetAlpha(0.4)
			AbilityFlyout.AbilitySelecteds[2]:SetTexture(E.media.blankTex)
			AbilityFlyout.AbilitySelecteds[2]:SetVertexColor(C.ExtractRGBAFromTemplate("green-300"))
			AbilityFlyout.AbilitySelecteds[2]:SetAlpha(0.4)
			self.__windSkin = true
		end)
	end
end

function S:RematchButton()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.rematch then
		return
	end

	if not _G.Rematch or not _G.Rematch.journal then
		return
	end

	RunNextFrame(function()
		self:Proxy("HandleCheckBox", _G.Rematch.journal.UseRematchCheckButton)
	end)
end

function S:Rematch()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.rematch then
		return
	end

	local frame = _G.Rematch and _G.Rematch.frame --[[@as BackdropTemplate]]
	if not frame then
		return
	end

	self:SecureHook(frame, "Show", function()
		self:Unhook(frame, "Show")
		self:Proxy("HandleCheckBox", _G.Rematch.journal.UseRematchCheckButton)
		MF:InternalHandle(frame, "CollectionsJournal")
		MF:InternalHandle(frame.ToolBar, "CollectionsJournal")
		self:SecureHook(frame, "Show", function()
			frame:EnableMouse(true)
		end)
		ReskinPetsPanel(frame.PetsPanel)
		ReskinPanelTabs(frame.PanelTabs)
		ReskinLoadoutPanel(frame.LoadoutPanel)
	end)

	F.InternalizeMethod(frame, "SetPoint")
	hooksecurefunc(frame, "SetPoint", function()
		F.Move(frame, 1, 0)
	end)
	F.Move(frame, 1, 0)

	ReskinTooltipsAndMenus()
	ReskinMainFrame(frame)
	ReskinTitleBar(frame.TitleBar)
	ReskinToolBar(frame.ToolBar)
	ReskinBottomBar(frame.BottomBar)
	ReskinLoadedTargetPanel(frame.LoadedTargetPanel, frame.PetsPanel, frame.TargetsPanel)
	ReskinLoadedTeamPanel(frame.LoadedTeamPanel)

	-- -- Main
	-- self:Rematch_LeftTop()
	-- self:Rematch_LeftBottom()
	-- self:Rematch_Right()
	-- self:Rematch_Footer()

	-- -- Misc
	-- self:Rematch_Dialog()
	-- self:Rematch_AbilityCard()
	-- self:Rematch_PetCard()
	-- self:Rematch_RightTabs()
	-- self:Rematch_Standalone()
	-- ReskinInset(_G.RematchLoadedTeamPanel)
	-- hooksecurefunc(_G.RematchJournal, "ConfigureJournal", self.Rematch_SkinLoad)
	-- hooksecurefunc(_G.RematchFrame, "ConfigureFrame", self.Rematch_SkinLoad)
end

S:AddCallbackForAddon("Rematch")
S:AddCallbackForAddon("Blizzard_Collections", "RematchButton")
