local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local MF = W.Modules.MoveFrames
local ES = E:GetModule("Skins")
local LSM = E.Libs.LSM
local C = W.Utilities.Color

local _G = _G
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local max = math.max
local pairs = pairs
local select = select
local strfind = strfind
local type = type
local unpack = unpack

local CreateFrame = CreateFrame
local RunNextFrame = RunNextFrame

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

	if button.Cooldown then
		E:RegisterCooldown(button.Cooldown)
	end

	button.__windSkin = true
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

local function ReskinToggleButton(button)
	if not button or button.__windSkin then
		return
	end

	ReskinButton(button)
	F.InternalizeMethod(button.Text, "SetPoint", true)
	button.windExpandIcon = button:CreateTexture(nil, "OVERLAY")
	button.windExpandIcon:Point("LEFT", button, "LEFT", 7, 0)
	button.windExpandIcon:Size(12, 12)
	hooksecurefunc(button.Back, "SetTexCoord", function(_, ...)
		if F.IsAlmost({ 0, 1, 0, 0.1875 }, { ... }) then
			button.windExpandIcon:SetTexture(W.Media.Icons.buttonPlus)
		elseif F.IsAlmost({ 0, 1, 0.375, 0.5625 }, { ... }) then
			button.windExpandIcon:SetTexture(W.Media.Icons.buttonMinus)
		end
	end)

	button.__windSkin = true
end

local texList = {
	close = { E.Media.Textures.Close, 0 },
	minimize = { E.Media.Textures.ArrowUp, ES.ArrowRotation.up },
	maximize = { E.Media.Textures.ArrowUp, ES.ArrowRotation.down },
	left = { E.Media.Textures.ArrowUp, ES.ArrowRotation.left },
	right = { E.Media.Textures.ArrowUp, ES.ArrowRotation.right },
	pin = { W.Media.Icons.buttonPin, 0 },
	lock = { W.Media.Icons.buttonLock, 0 },
	unlock = { W.Media.Icons.buttonUnlock, 0 },
	flip = { W.Media.Icons.buttonUndo, 0 },
}

---@param frame Button?
---@param size number?
local function ReskinTitlebarButton(frame, size)
	if not frame or frame.__windSkin then
		return
	end

	---@param tex Texture
	---@param r number?
	---@param g number?
	---@param b number?
	local function UpdateTexture(tex, r, g, b)
		if not frame.icon or not texList[frame.icon] then
			return
		end
		local texData = texList[frame.icon]

		F.InternalizeMethod(tex, "SetTexture", true)
		F.InternalizeMethod(tex, "SetTexCoord", true)
		F.CallMethod(tex, "SetTexture", texData[1])
		F.CallMethod(tex, "SetTexCoord", 0, 1, 0, 1)
		tex:Size(size or 12)
		tex:SetRotation(texData[2] or 0)
		tex:SetVertexColor(r or 1, g or 1, b or 1)
		tex:SetAlpha(1)
		tex:SetBlendMode("BLEND")
	end

	local hoverColor = E.media.rgbvaluecolor

	frame.Update = function(self)
		UpdateTexture(self:GetNormalTexture(), 1, 1, 1)
		UpdateTexture(self:GetDisabledTexture(), 0.5, 0.5, 0.5)
		UpdateTexture(self:GetPushedTexture(), hoverColor.r, hoverColor.g, hoverColor.b)
		UpdateTexture(self:GetHighlightTexture(), hoverColor.r, hoverColor.g, hoverColor.b)
	end

	frame:Update()

	frame:Size(size or 12, size or 12)

	frame.__windSkin = true
end

local function ReskinCardStatusBar(parent, key)
	if not parent or not key or not parent[key] or parent[key].__windSkin then
		return
	end

	local back = parent[key .. "Back"] or parent["Back"]
	local border = parent[key .. "Border"] or parent["Border"]
	local text = parent[key .. "Text"] or parent["Text"]

	parent[key]:SetTexture(E.media.normTex)
	parent[key .. "Frame"] = CreateFrame("Frame", nil, parent)
	parent[key .. "Frame"]:SetTemplate("Transparent")
	parent[key .. "Frame"]:SetAllPoints(back)
	back:SetAlpha(0)
	border:SetAlpha(0)
	parent[key]:SetParent(parent[key .. "Frame"])
	if text then
		text:SetParent(parent[key .. "Frame"])
		F.Move(text, 0, 1)
	end

	hooksecurefunc(parent[key], "Hide", function()
		parent[key .. "Frame"]:Hide()
	end)

	hooksecurefunc(parent[key], "Show", function()
		parent[key .. "Frame"]:Show()
	end)

	hooksecurefunc(parent[key], "SetShown", function(_, shown)
		parent[key .. "Frame"]:SetShown(shown)
	end)

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
	hooksecurefunc(frame.Border, "SetVertexColor", function(_, r, g, b)
		frame.windIconBorder:SetBackdropBorderColor(r, g, b)
	end)
	frame.Border:SetVertexColor(frame.Border:GetVertexColor())
	frame.windIconBorder:SetFrameLevel(max(0, frame:GetFrameLevel() - 1))

	frame.LevelBubble:Kill()
	F.SetFont(frame.LevelText, E.db.general.font)
	frame.LevelText:SetJustifyH("RIGHT")
	frame.LevelText:ClearAllPoints()
	frame.LevelText:Point("BOTTOMRIGHT", frame.Icon, "BOTTOMRIGHT", 2, 0)

	if frame.Status then
		frame.Status:SetAllPoints(frame.Icon)
		hooksecurefunc(frame.Status, "SetTexCoord", function(self, ...)
			if F.IsAlmost({ 0.3125, 0.625, 0, 0.625 }, { ... }) then
				self:SetTexCoord(0.325, 0.6125, 0.025, 0.6)
			elseif F.IsAlmost({ 0, 0.3125, 0, 0.625 }, { ... }) then
				self:SetTexCoord(0.0125, 0.3, 0.025, 0.6)
			end
		end)
		local ULx, ULy, _, _, _, _, LRx, LRy = frame.Status:GetTexCoord()
		frame.Status:SetTexCoord(ULx, LRx, ULy, LRy)
	end

	if frame.Icon then
		frame.Icon:SetTexCoord(unpack(E.TexCoords))
	end

	frame.__windSkin = true
end

local function ReskinSelectionIndicator(frame)
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
end

local function ReskinCheck(frame)
	if not frame.Check or frame.Check.__windSkin then
		return
	end

	frame.CheckFrame = CreateFrame("Frame", nil, frame)
	frame.CheckFrame:SetTemplate()
	frame.CheckFrame:Size(14, 14)
	frame.CheckFrame:Point("LEFT", frame.Check, "LEFT", 6, 0)
	frame.CheckFrame:SetShown(frame.Check:IsShown())
	frame.CheckFrame.Checked = frame.CheckFrame:CreateTexture(nil, "OVERLAY")
	frame.CheckFrame.Checked:SetInside(frame.CheckFrame)
	if E.private.WT.skins.widgets.checkBox.enable then
		local db = E.private.WT.skins.widgets.checkBox
		frame.CheckFrame.Checked:SetTexture(LSM:Fetch("statusbar", db.texture) or E.media.normTex)
		F.SetVertexColorWithDB(frame.CheckFrame.Checked, db.classColor and E.myClassColor or db.color)
	else
		frame.CheckFrame.Checked:SetTexture(E.Media.Textures.Melli)
		frame.CheckFrame.Checked:SetVertexColor(1, 0.82, 0, 0.8)
	end

	hooksecurefunc(frame.Check, "SetTexCoord", function(_, ...)
		local hidden = F.IsAlmost({ 0, 0.25, 0.5, 0.75 }, { ... })
		frame.CheckFrame.Checked:SetShown(not hidden)
	end)
	local ULx, ULy, _, _, _, _, LRx, LRy = frame.Check:GetTexCoord()
	frame.Check:SetTexCoord(ULx, LRx, ULy, LRy)

	frame.Check:Kill()
	hooksecurefunc(frame.Check, "Show", function()
		frame.CheckFrame:SetShown(true)
	end)
	hooksecurefunc(frame.Check, "Hide", function()
		frame.CheckFrame:SetShown(false)
	end)
	hooksecurefunc(frame.Check, "SetShown", function(_, shown)
		frame.CheckFrame:SetShown(shown)
	end)

	frame.Check.__windSkin = true
end

local function ReskinList(frame)
	if not frame then
		return
	end

	frame:StripTextures()
	S:Proxy("HandleFrame", frame)
	S:Proxy("HandleTrimScrollBar", frame.ScrollBar)
	frame.ScrollBar:ClearAllPoints()
	frame.ScrollBar:Point("TOPRIGHT", frame, "TOPRIGHT", -7, -18)
	frame.ScrollBar:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -7, 18)
	S:ReskinIconButton(frame.ScrollToTopButton, W.Media.Icons.buttonGoEnd, 20, 1.571)
	F.Move(frame.ScrollToTopButton, -3, -1)
	S:ReskinIconButton(frame.ScrollToBottomButton, W.Media.Icons.buttonGoEnd, 20, -1.571)
	F.Move(frame.ScrollToBottomButton, -2, 4)
end

local function ReskinMainFrame(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)
end

local function ReskinTitleBar(frame)
	if not frame then
		return
	end

	frame.Portrait:Kill()
	F.SetFont(frame.Title)

	ReskinTitlebarButton(frame.CloseButton)
	F.Move(frame.CloseButton, -4, -4)
	ReskinTitlebarButton(frame.MinimizeButton, 16)
	F.Move(frame.MinimizeButton, -4, 2)

	ReskinTitlebarButton(frame.LockButton, 14)
	F.Move(frame.LockButton, 4, -4)
	ReskinTitlebarButton(frame.NextModeButton, 14)
	F.Move(frame.NextModeButton, 4, 0)
	ReskinTitlebarButton(frame.PrevModeButton, 14)
	F.Move(frame.PrevModeButton, 4, 0)
end

local function ReskinToolBar(frame)
	frame:StripTextures()

	if frame.TotalsButton then
		frame.TotalsButton:StripTextures()
		frame.TotalsButton:CreateBackdrop("Transparent")
		frame.TotalsButton.backdrop:Point("TOPLEFT", 0, 0)
	end

	for _, button in pairs({
		frame.BandageButton,
		frame.ExportTeamButton,
		frame.FindBattleButton,
		frame.HealButton,
		frame.ImportTeamButton,
		frame.LesserPetTreatButton,
		frame.LevelingStoneButton,
		frame.PetSatchelButton,
		frame.PetTreatButton,
		frame.RandomTeamButton,
		frame.RarityStoneButton,
		frame.SafariHatButton,
		frame.SaveAsButton,
		frame.SummonPetButton,
	}) do
		ReskinIconButton(button)
		F.InternalizeMethod(button, "SetPoint")
		hooksecurefunc(button, "SetPoint", function()
			F.Move(button, 2, 0)
		end)
		F.Move(button, 2, 0)
	end
end

local function ReskinPetListButton(frame)
	if not frame then
		return
	end

	ReskinSelectionIndicator(frame)

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

	ReskinList(frame.List)
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
	local NotesButton = frame.NotesFrame.NotesButton
	ReskinIconButton(NotesButton)
	NotesButton.Icon.backdrop:SetOutside(NotesButton, 1, 1)
	NotesButton.hover:SetOutside(NotesButton)

	frame.PreferencesFrame:StripTextures()
	local PreferencesButton = frame.PreferencesFrame.PreferencesButton
	ReskinIconButton(PreferencesButton)
	PreferencesButton.Icon.backdrop:SetOutside(PreferencesButton, 1, 1)
	PreferencesButton.hover:SetOutside(PreferencesButton)

	frame.TeamButton:StripTextures()
	ReskinButton(frame.TeamButton)
end

local function ReskinLoadout(frame)
	if not frame or frame.__windSkin then
		return
	end

	S:Proxy("HandleBlizzardRegions", frame)
	frame:SetTemplate()
	frame.Top:Kill()
	frame.Bottom:Kill()
	frame.Back:Kill()
	if frame.Highlight then
		frame.Highlight:SetTexture(E.media.blankTex)
		frame.Highlight:SetVertexColor(1, 1, 1, 0.1)
	end

	-- Mini Loadout has no own Pet frame
	ReskinPet(frame.Pet or frame)

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
	ReskinCardStatusBar(frame, "TopStatusBar")
	ReskinCardStatusBar(frame, "BottomStatusBar")

	frame.__windSkin = true
end

local function ReskinAbilityFlyout(frame)
	frame:CreateBackdrop()
	frame.backdrop:SetInside(frame, 1, 1)
	frame.backdrop:SetFrameLevel(frame:GetFrameLevel())
	S:CreateBackdropShadow(frame)
	frame.Border:Kill()

	for _, button in pairs({ frame:GetChildren() }) do
		if button ~= frame.Border and button ~= frame.anchoredTo then
			ReskinIconButton(button)
		end
	end

	hooksecurefunc(frame, "FillAbilityFlyout", function(self)
		if self.__windSkin then
			return
		end
		frame.AbilitySelecteds[1]:SetTexture(E.media.blankTex)
		frame.AbilitySelecteds[1]:SetVertexColor(C.ExtractRGBAFromTemplate("yellow-300"))
		frame.AbilitySelecteds[1]:SetAlpha(0.4)
		frame.AbilitySelecteds[2]:SetTexture(E.media.blankTex)
		frame.AbilitySelecteds[2]:SetVertexColor(C.ExtractRGBAFromTemplate("green-300"))
		frame.AbilitySelecteds[2]:SetAlpha(0.4)
		self.__windSkin = true
	end)
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
		ReskinAbilityFlyout(AbilityFlyout)
	end
end

local function ReskinListElement(frame)
	if not frame then
		return
	end

	if frame.ExpandIcon and not frame.ExpandIcon.__windSkin then
		ReskinButton(frame)
		if frame.Border then
			frame.Border:Kill()
		end

		frame.ExpandIcon:Size(12, 12)
		F.Move(frame.ExpandIcon, 6, 0)
		F.InternalizeMethod(frame.ExpandIcon, "SetTexCoord")
		local ULx, ULy, _, _, _, _, LRx, LRy = frame.ExpandIcon:GetTexCoord()
		F.CallMethod(frame.ExpandIcon, "SetTexCoord", 0, 1, 0, 1)
		frame.ExpandIcon.SetTexCoord = function(_, ...)
			if F.IsAlmost({ 0.75, 0.80078125, 0, 0.40625 }, { ... }) then
				frame.ExpandIcon:SetTexture(W.Media.Icons.buttonPlus)
			elseif F.IsAlmost({ 0.80078125, 0.8515625, 0, 0.40625 }, { ... }) then
				frame.ExpandIcon:SetTexture(W.Media.Icons.buttonMinus)
			end
		end
		frame.ExpandIcon:SetTexCoord(ULx, LRx, ULy, LRy)
		frame.ExpandIcon.__windSkin = true
	end

	ReskinCheck(frame)

	if frame.widget then
		for _, child in pairs({ frame.widget:GetChildren() }) do
			if child:IsObjectType("Button") and not child.__windSkin then
				ReskinButton(child)
				if child.DropDownButton then
					child.DropDownTex = child:CreateTexture(nil, "OVERLAY")
					child.DropDownTex:SetInside(child.DropDownButton, 1, 1)
					child.DropDownTex:SetTexture(E.Media.Textures.ArrowUp)
					child.DropDownTex:SetRotation(ES.ArrowRotation.down)
					child.DropDownButton:Kill()
				end
				child.__windSkin = true
			end
		end

		ReskinCheck(frame.widget)
	end
end

local function ReskinTeamButton(frame)
	if frame.ExpandIcon then
		ReskinListElement(frame)
		return
	end

	if frame.__windSkin then
		return
	end

	if frame.Border then
		frame.Border:Kill()
	end

	if frame.Back then
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

	frame.__windSkin = true
end

local function ReskinTeamsPanel(frame)
	if not frame then
		return
	end

	-- Top
	frame.Top:StripTextures()
	frame.Top:CreateBackdrop("Transparent")
	S:Reposition(frame.Top.backdrop, frame.Top, 0, 0, 1, 0, 0)

	ReskinToggleButton(frame.Top.AllButton)
	S:Proxy("HandleEditBox", frame.Top.SearchBox)
	for _, tex in pairs(frame.Top.SearchBox.Back) do
		tex:Kill()
	end
	frame.Top.SearchBox:ClearAllPoints()
	frame.Top.SearchBox:Point("TOPLEFT", frame.Top.AllButton, "TOPRIGHT", 5, 0)
	frame.Top.SearchBox:Point("BOTTOMRIGHT", frame.Top.TeamsButton, "BOTTOMLEFT", -5, 0)
	frame.Top.TeamsButton:StripTextures()
	S:Proxy("HandleButton", frame.Top.TeamsButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")

	-- List
	ReskinList(frame.List)
	hooksecurefunc(frame.List.ScrollBox, "Update", function()
		frame.List.ScrollBox:ForEachFrame(ReskinTeamButton)
		frame.List.ScrollBox:ForEachFrame(ReskinSelectionIndicator)
	end)
	hooksecurefunc(frame.List, "Refresh", function()
		frame.List.ScrollBox:ForEachFrame(ReskinSelectionIndicator)
	end)
	frame.List.ScrollBox:ForEachFrame(ReskinTeamButton)
	frame.List.ScrollBox:ForEachFrame(ReskinSelectionIndicator)
end

local function ReskinTargetsButton(frame)
	if frame.ExpandIcon then
		ReskinListElement(frame)
		return
	end

	if frame.__windSkin then
		return
	end

	if frame.Border then
		frame.Border:Kill()
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

		frame.__windSkin = true
	end
end

local function ReskinTargetsPanel(frame)
	if not frame then
		return
	end

	-- Top
	frame.Top:StripTextures()
	frame.Top:CreateBackdrop("Transparent")
	S:Reposition(frame.Top.backdrop, frame.Top, 0, 0, 1, 0, 0)
	ReskinToggleButton(frame.Top.AllButton)
	S:Proxy("HandleEditBox", frame.Top.SearchBox)
	for _, tex in pairs(frame.Top.SearchBox.Back) do
		tex:Kill()
	end
	frame.Top.SearchBox:ClearAllPoints()
	frame.Top.SearchBox:Point("TOPLEFT", frame.Top.AllButton, "TOPRIGHT", 5, 0)
	frame.Top.SearchBox:Point("BOTTOMRIGHT", frame.Top, "BOTTOMRIGHT", -7, 2)

	-- List
	ReskinList(frame.List)
	hooksecurefunc(frame.List.ScrollBox, "Update", function()
		frame.List.ScrollBox:ForEachFrame(ReskinTargetsButton)
	end)
	frame.List.ScrollBox:ForEachFrame(ReskinTargetsButton)
end

local function ReskinQueuePanel(frame)
	if not frame then
		return
	end

	-- Top
	frame.PreferencesFrame:StripTextures()
	local PreferencesButton = frame.PreferencesFrame.PreferencesButton
	ReskinIconButton(PreferencesButton)
	PreferencesButton.Icon.backdrop:SetTemplate("Transparent")
	PreferencesButton.Icon.backdrop:SetOutside(PreferencesButton, 3, 3)
	F.Move(PreferencesButton, 0, -1)
	PreferencesButton.hover:ClearAllPoints()
	PreferencesButton.hover:SetOutside(PreferencesButton, 2, 2)

	frame.Top:StripTextures()
	frame.Top:CreateBackdrop("Transparent")
	S:Reposition(frame.Top.backdrop, frame.Top, 0, 0, 1, 0, 0)
	frame.Top.QueueButton:StripTextures()
	S:Proxy("HandleButton", frame.Top.QueueButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")

	-- List
	ReskinList(frame.List)
	hooksecurefunc(frame.List, "Refresh", function()
		frame.List.ScrollBox:ForEachFrame(ReskinPetListButton)
	end)
	hooksecurefunc(frame.List.ScrollBox, "Update", function()
		frame.List.ScrollBox:ForEachFrame(ReskinPetListButton)
	end)
	frame.List.ScrollBox:ForEachFrame(ReskinPetListButton)
end

local function ReskinOptionsPanel(frame)
	if not frame then
		return
	end

	-- Top
	frame.Top:StripTextures()
	frame.Top:CreateBackdrop("Transparent")
	S:Reposition(frame.Top.backdrop, frame.Top, 0, 0, 1, 0, 0)
	ReskinToggleButton(frame.Top.AllButton)
	S:Proxy("HandleEditBox", frame.Top.SearchBox)
	for _, tex in pairs(frame.Top.SearchBox.Back) do
		tex:Kill()
	end
	frame.Top.SearchBox:ClearAllPoints()
	frame.Top.SearchBox:Point("TOPLEFT", frame.Top.AllButton, "TOPRIGHT", 5, 0)
	frame.Top.SearchBox:Point("BOTTOMRIGHT", frame.Top, "BOTTOMRIGHT", -7, 2)

	-- List
	ReskinList(frame.List)
	hooksecurefunc(frame.List.ScrollBox, "Update", function()
		frame.List.ScrollBox:ForEachFrame(ReskinListElement)
	end)
	frame.List.ScrollBox:ForEachFrame(ReskinListElement)
end

local function ReskinRoundButton(frame)
	for _, tex in pairs({ frame:GetRegions() }) do
		if tex:IsObjectType("Texture") and tex:GetDrawLayer() == "ARTWORK" then
			tex:Kill()
		end
	end
end

local function ReskinPetCard(frame)
	if not frame or frame.__windSkin then
		return
	end

	frame:StripTextures()
	frame:CreateBackdrop("Transparent")
	S:CreateBackdropShadow(frame)

	ReskinTitlebarButton(frame.CloseButton)
	F.Move(frame.CloseButton, -4, -4)
	ReskinTitlebarButton(frame.MinimizeButton, 16)
	F.Move(frame.MinimizeButton, -4, 2)
	ReskinTitlebarButton(frame.FlipButton, 14)
	F.InternalizeMethod(frame.FlipButton, "SetPoint")
	hooksecurefunc(frame.FlipButton, "SetPoint", function()
		F.Move(frame.FlipButton, 4, -4)
	end)
	ReskinTitlebarButton(frame.PinButton, 14)
	F.InternalizeMethod(frame.PinButton, "SetPoint")
	hooksecurefunc(frame.PinButton, "SetPoint", function()
		F.Move(frame.PinButton, 4, -4)
	end)

	frame.Content.NineSlice:SetAlpha(0)
	frame.Content:SetTemplate("Transparent")
	S:CreateShadow(frame.Content)
	frame.Content.Back.Source:StripTextures()

	ReskinRoundButton(frame.Content.Top.PetIcon)
	ReskinRoundButton(frame.Content.Top.TypeIcon)
	ReskinCardStatusBar(frame.Content.Front.Stats.XpBar, "Bar")
	ReskinCardStatusBar(frame.Content.Front.Stats.HpBar, "Bar")

	for _, button in pairs(frame.Content.Front.Abilities.Buttons) do
		if button.Border then
			button.Border:Kill()
		end
		button.IconFrame = CreateFrame("Frame", nil, button)
		button.IconFrame:SetTemplate()
		button.IconFrame:SetOutside(button.Icon)
		button.Icon:SetParent(button.IconFrame)
	end

	hooksecurefunc(frame, "SetAlpha", function(_, alpha)
		if frame.Content.shadow then
			frame.Content.shadow:SetShown(alpha == 0)
		end
	end)
	frame:SetAlpha(frame:GetAlpha())

	frame.__windSkin = true
end

local function ReskinCanvas(frame)
	if not frame or frame.__windSkin then
		return
	end

	local function ReskinTopFrame(topFrame)
		if not topFrame then
			return
		end
		topFrame:CreateBackdrop()
		S:Reposition(topFrame.backdrop, topFrame, 0, 0, 1, 0, 0)
		topFrame.Back:Kill()
		S:Proxy("HandleBlizzardRegions", topFrame)
		topFrame.Top:Kill()
		topFrame.Bottom:Kill()
	end

	local function ReskinDropDown(dropDownFrame)
		dropDownFrame.Left:Kill()
		dropDownFrame.Middle:Kill()
		dropDownFrame.Right:Kill()
		dropDownFrame:SetTemplate()
		dropDownFrame.DropDownButton:Kill()
		dropDownFrame.DropDownTex = dropDownFrame:CreateTexture(nil, "OVERLAY")
		dropDownFrame.DropDownTex:SetInside(dropDownFrame.DropDownButton, 1, 1)
		dropDownFrame.DropDownTex:SetTexture(E.Media.Textures.ArrowUp)
		dropDownFrame.DropDownTex:SetRotation(ES.ArrowRotation.down)
		dropDownFrame.DropDownTex:SetScript("OnEnter", function(t)
			t:SetVertexColor(unpack(E.media.rgbvaluecolor))
		end)
		dropDownFrame.DropDownTex:SetScript("OnLeave", function(t)
			t:SetVertexColor(1, 1, 1)
		end)
		dropDownFrame.DropDownTex:SetScript("OnMouseDown", function()
			dropDownFrame:OnClick(dropDownFrame.DropDownButton)
		end)
	end

	local LayoutTabs = frame.LayoutTabs
	if LayoutTabs then
		LayoutTabs:StripTextures()
		for i = 1, 4 do
			local tab = LayoutTabs["Tab" .. i]
			tab:Height(25)
			S:Proxy("HandleTab", tab)
		end
	end

	local ComboBox = frame.ComboBox
	if ComboBox then
		ReskinDropDown(ComboBox.ComboBox)
	end

	local GroupSelect = frame.GroupSelect
	if GroupSelect then
		for _, tex in pairs({ GroupSelect.Button:GetRegions() }) do
			if
				tex:IsObjectType("Texture")
				and tex ~= GroupSelect.Button.Icon
				and tex ~= GroupSelect.Button.IconMask
			then
				tex:Kill()
			end
		end
		ReskinButton(GroupSelect.Button)
	end

	local GroupPicker = frame.GroupPicker
	if GroupPicker then
		ReskinTopFrame(GroupPicker.Top)
		ReskinButton(GroupPicker.Top.CancelButton)
		F.Move(GroupPicker.Top.Label, 0, -1)

		ReskinList(GroupPicker.List)
		hooksecurefunc(GroupPicker.List.ScrollBox, "Update", function()
			GroupPicker.List.ScrollBox:ForEachFrame(ReskinButton)
		end)
		GroupPicker.List.ScrollBox:ForEachFrame(ReskinButton)
	end

	local Team = frame.Team
	if Team and Team.ListButtonTeam then
		Team.ListButtonTeam.Back:Kill()
		Team.ListButtonTeam.Border:Kill()
		Team.ListButtonTeam:CreateBackdrop("Transparent")
	end

	local TeamWithAbilities = frame.TeamWithAbilities
	if TeamWithAbilities then
		for _, subGroup in pairs({ TeamWithAbilities:GetChildren() }) do
			if subGroup and subGroup:IsObjectType("Frame") and subGroup.Pet then
				ReskinPet(subGroup.Pet)
				subGroup.AbilityBar.AbilitiesBorder:Kill()
				for _, child in pairs({ subGroup.AbilityBar:GetChildren() }) do
					if child ~= subGroup.AbilityBar.AbilitiesBorder then
						child:CreateBackdrop()
					end
				end
			end
		end
	end

	local TeamPicker = frame.TeamPicker
	if TeamPicker then
		local Lister, Picker = TeamPicker.Lister, TeamPicker.Picker

		-- Lister
		ReskinTopFrame(Lister.Top)
		ReskinButton(Lister.Top.AddButton)

		for _, button in pairs({
			Lister.Top.AddButton,
			Lister.Top.DeleteButton,
			Lister.Top.UpButton,
			Lister.Top.DownButton,
		}) do
			button:Width(button:GetWidth() - 3)
			ReskinButton(button)
		end

		F.Move(Lister.Top.DeleteButton, 4, 0)
		F.Move(Lister.Top.UpButton, -4, 0)

		ReskinList(Lister.List)
		hooksecurefunc(Lister.List.ScrollBox, "Update", function()
			Lister.List.ScrollBox:ForEachFrame(ReskinTargetsButton)
			Lister.List.ScrollBox:ForEachFrame(ReskinSelectionIndicator)
		end)
		hooksecurefunc(Lister.List, "Refresh", function()
			Lister.List.ScrollBox:ForEachFrame(ReskinSelectionIndicator)
		end)
		Lister.List.ScrollBox:ForEachFrame(ReskinTargetsButton)
		Lister.List.ScrollBox:ForEachFrame(ReskinSelectionIndicator)

		-- Picker
		ReskinTopFrame(Picker.Top)
		ReskinToggleButton(Picker.Top.AllButton)
		ReskinButton(Picker.Top.CancelButton)
		S:Proxy("HandleEditBox", Picker.Top.SearchBox)
		for _, tex in pairs(Picker.Top.SearchBox.Back) do
			tex:Kill()
		end
		Picker.Top.SearchBox:ClearAllPoints()
		Picker.Top.SearchBox:Point("TOPLEFT", Picker.Top.AllButton, "TOPRIGHT", 5, 0)
		Picker.Top.SearchBox:Point("BOTTOMRIGHT", Picker.Top.CancelButton, "BOTTOMLEFT", -5, 0)

		-- List
		ReskinList(Picker.List)
		hooksecurefunc(Picker.List.ScrollBox, "Update", function()
			Picker.List.ScrollBox:ForEachFrame(ReskinTargetsButton)
		end)
		Picker.List.ScrollBox:ForEachFrame(ReskinTargetsButton)
	end

	local Preferences = frame.Preferences
	if Preferences then
		for _, input in pairs({
			Preferences.MinLevel,
			Preferences.MaxLevel,
			Preferences.MinHealth,
			Preferences.MaxHealth,
		}) do
			S:Proxy("HandleEditBox", input)
			for _, tex in pairs(input.Back) do
				tex:Kill()
			end

			input.backdrop:Point("TOPLEFT", input, "TOPLEFT", 2, 0)
		end
		S:Proxy("HandleCheckBox", Preferences.AllowMM)
		Preferences.AllowMM:Size(22, 22)
		F.Move(Preferences.AllowMM.Text, 0, -2)

		Preferences.ExpectedDamage.Borders:Kill()

		local texture = Preferences.ExpectedDamage.Selected
		texture:SetTexture(E.media.blankTex)
		F.InternalizeMethod(texture, "SetVertexColor")
		texture.SetVertexColor = function(t, r, g, b, a)
			F.CallMethod(t, "SetVertexColor", r, g, b, (a or 0.4) / 3)
		end
		texture:SetVertexColor(texture:GetVertexColor())
	end

	local WinRecord = frame.WinRecord
	if WinRecord then
		for _, input in pairs({ WinRecord.Wins, WinRecord.Losses, WinRecord.Draws }) do
			S:Proxy("HandleEditBox", input)
			for _, tex in pairs(input.Back) do
				tex:Kill()
			end

			input.backdrop:Point("TOPLEFT", input, "TOPLEFT", 2, 0)
		end

		for _, button in pairs({
			WinRecord.DrawsMinus,
			WinRecord.DrawsPlus,
			WinRecord.LossesMinus,
			WinRecord.LossesPlus,
			WinRecord.WinsMinus,
			WinRecord.WinsPlus,
		}) do
			ReskinButton(button)
			local isPlus = strfind(button:GetDebugName(), "Plus", 1, true) ~= nil
			F.Move(button, isPlus and 2 or 4, 0)
		end
	end

	local Line = frame.Line
	if Line then
		local region = select(1, Line:GetRegions())
		if region and region:IsObjectType("Texture") then
			region:SetTexture(E.media.blankTex)
			region:SetVertexColor(C.ExtractRGBAFromTemplate("gray-700"))
			region:SetInside(Line, 0, 1)
		end
	end

	local MultiLineEditBox = frame.MultiLineEditBox
	if MultiLineEditBox then
		MultiLineEditBox:StripTextures()
		MultiLineEditBox:SetTemplate("Transparent")

		local scrollFrame = MultiLineEditBox.ScrollFrame
		S:Proxy("HandleEditBox", scrollFrame.EditBox)
		scrollFrame.EditBox.backdrop:Point("TOPLEFT", scrollFrame.EditBox, "TOPLEFT", 2, 0)
		local PleaseWait = scrollFrame.PleaseWait
		PleaseWait.Bar:SetTexture(E.media.normTex)
		PleaseWait.Border:Kill()
		S:Proxy("HandleScrollBar", scrollFrame.ScrollBar, 0, 2)
	end

	local IncludeCheckButtons = frame.IncludeCheckButtons
	if IncludeCheckButtons then
		for _, checkButton in pairs({
			IncludeCheckButtons.IncludeNotes,
			IncludeCheckButtons.IncludePreferences,
		}) do
			S:Proxy("HandleCheckBox", checkButton)
			checkButton:Size(22, 22)
			F.Move(checkButton.Text, 0, -1)
		end
	end

	local EditBox = frame.EditBox
	if EditBox then
		EditBox.EditBox:StripTextures()
		S:Proxy("HandleEditBox", EditBox.EditBox)
		S:Reposition(EditBox.EditBox.backdrop, EditBox.EditBox, -2, -2, -1, -2, 1)
	end

	local Pet = frame.Pet
	if Pet then
		ReskinPetListButton(Pet.ListButtonPet)
	end

	local ColorPicker = frame.ColorPicker
	if ColorPicker then
		for _, swatch in pairs(ColorPicker.Swatches) do
			swatch.Border:Kill()
			swatch:CreateBackdrop()
			swatch.backdrop:SetOutside(swatch, 1, 1)
			swatch.backdrop:SetBackdropBorderColor(swatch.Selected:GetVertexColor())
			swatch.Selected:Kill()
			F.InternalizeMethod(swatch.Selected, "SetShown", true)
			hooksecurefunc(swatch.Selected, "SetShown", function(_, shown)
				swatch.backdrop:SetShown(shown)
			end)
			swatch.backdrop:SetShown(swatch.Selected:IsShown())
		end
	end

	local IconPicker = frame.IconPicker
	if IconPicker then
		for _, region in pairs({ IconPicker:GetRegions() }) do
			if region:IsObjectType("Texture") and region ~= IconPicker.Icon then
				region:Kill()
			end
		end
		IconPicker.Icon:SetTexCoord(unpack(E.TexCoords))

		for i, region in ipairs({ IconPicker.SearchBox:GetRegions() }) do
			if i > 5 then
				break
			end
			if region:IsObjectType("Texture") then
				region:Kill()
			end
		end
		S:Proxy("HandleEditBox", IconPicker.SearchBox)
		S:Reposition(IconPicker.SearchBox.backdrop, IconPicker.SearchBox, -1, 0, 0, 0, 2)
		ReskinList(IconPicker.List)
	end

	local CheckButton = frame.CheckButton
	if CheckButton then
		S:Proxy("HandleCheckBox", CheckButton.Check)
		CheckButton.Check:Size(22, 22)
		F.Move(CheckButton.CheckText, 0, -1)
	end

	local BarChartDropDown = frame.BarChartDropDown
	if BarChartDropDown then
		ReskinDropDown(BarChartDropDown.DropDown)
	end

	local DropDown = frame.DropDown
	if DropDown then
		ReskinDropDown(DropDown.DropDown)
	end

	local PetSummary = frame.PetSummary
	if PetSummary then
		PetSummary.LeftCap:Kill()
		PetSummary.RightCap:Kill()
		PetSummary.MidBorder:Kill()
		PetSummary.ProgressBarBackdrop = CreateFrame("Frame", nil, PetSummary)
		PetSummary.ProgressBarBackdrop:SetTemplate()
		PetSummary.ProgressBarBackdrop:Point("TOPLEFT", PetSummary.LeftCap, "TOPLEFT", 0, 0)
		PetSummary.ProgressBarBackdrop:Point("BOTTOMRIGHT", PetSummary.RightCap, "BOTTOMRIGHT", 0, 0)
		PetSummary.ProgressBarBackdrop:SetFrameLevel(PetSummary:GetFrameLevel())

		PetSummary.PoorBar:SetTexture(E.media.normTex)
		PetSummary.CommonBar:SetTexture(E.media.normTex)
		PetSummary.UncommonBar:SetTexture(E.media.normTex)
		PetSummary.RareBar:SetTexture(E.media.normTex)
	end

	frame.__windSkin = true
end

local function ReskinDialog(frame)
	if not frame or frame.__windSkin then
		return
	end

	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	ReskinTitlebarButton(frame.CloseButton)
	F.Move(frame.CloseButton, -4, -4)
	ReskinTitlebarButton(frame.MinimizeButton, 16)
	F.Move(frame.MinimizeButton, -4, 2)

	if frame.CloseButton then
		ReskinTitlebarButton(frame.CloseButton)
		F.Move(frame.CloseButton, -4, -4)
	end
	ReskinButton(frame.AcceptButton)
	ReskinButton(frame.CancelButton)
	ReskinButton(frame.OtherButton)

	frame.OtherButton:Width(frame.OtherButton:GetWidth() - 5)
	frame.CancelButton:Width(frame.CancelButton:GetWidth() - 5)
	frame.AcceptButton:ClearAllPoints()
	frame.AcceptButton:Point("LEFT", frame.OtherButton, "RIGHT", 3, 0)
	frame.AcceptButton:Point("RIGHT", frame.CancelButton, "LEFT", -3, 0)

	local Prompt = frame.Prompt
	if Prompt then
		Prompt:StripTextures()
		Prompt.TopBar = Prompt:CreateTexture(nil, "ARTWORK")
		Prompt.TopBar:SetTexture(E.media.blankTex)
		Prompt.TopBar:SetVertexColor(C.ExtractRGBAFromTemplate("gray-400"))
		Prompt.TopBar:Height(3)
		Prompt.TopBar:SetPoint("TOPLEFT", Prompt, "TOPLEFT", 1, -1)
		Prompt.TopBar:SetPoint("TOPRIGHT", Prompt, "TOPRIGHT", -1, -1)
	end

	ReskinCanvas(frame.Canvas)

	frame.__windSkin = true
end

local function ReskinNotesCard(frame)
	if not frame or frame.__windSkin then
		return
	end

	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	ReskinTitlebarButton(frame.CloseButton)
	F.Move(frame.CloseButton, -4, -4)
	ReskinTitlebarButton(frame.LockButton, 14)
	F.Move(frame.LockButton, 4, -4)

	frame.Content.NineSlice:SetAlpha(0)
	frame.Content:SetTemplate("Transparent")
	S:CreateShadow(frame.Content)

	hooksecurefunc(frame, "SetAlpha", function(_, alpha)
		if frame.Content.shadow then
			frame.Content.shadow:SetShown(alpha == 0)
		end
	end)
	frame:SetAlpha(frame:GetAlpha())

	local ScrollFrame = frame.Content.ScrollFrame
	S:Proxy("HandleEditBox", ScrollFrame.EditBox)
	ScrollFrame.EditBox.backdrop:Point("TOPLEFT", ScrollFrame.EditBox, "TOPLEFT", 2, 0)
	S:Proxy("HandleScrollBar", ScrollFrame.ScrollBar, 0, 2)

	local Bottom = frame.Content.Bottom
	if Bottom then
		Bottom.Back:Kill()
		for _, button in pairs({ Bottom.DeleteButton, Bottom.SaveButton, Bottom.UndoButton }) do
			ReskinButton(button)
			button:Width(button:GetWidth() - 5)
		end
	end

	frame.__windSkin = true
end

local function ReskinMiniLoadoutPanel(frame)
	if not frame or frame.__windSkin then
		return
	end

	local AbilityFlyout = frame.AbilityFlyout
	if AbilityFlyout then
		ReskinAbilityFlyout(AbilityFlyout)
	end

	local Loadouts = frame.Loadouts
	if Loadouts then
		for _, loadout in pairs(Loadouts) do
			ReskinLoadout(loadout)
			if loadout.Icon then
				loadout.Icon:CreateBackdrop()
				loadout.Icon.backdrop:SetFrameLevel(3)
			end
		end
	end

	frame.__windSkin = true
end

function S:BlizzardCollections_Rematch()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.rematch then
		return
	end

	local Rematch = _G.Rematch
	if not Rematch then
		return
	end

	local Journal = Rematch.journal
	if not Journal then
		return
	end

	local function HidePetJournalElements()
		if not Journal:IsActive() then
			return
		end

		_G.CollectionsJournalCloseButton:Hide()
		_G.CollectionsJournalTitleText:Hide()
		_G.CollectionsJournal.backdrop:SetTemplate("NoBackdrop")
		if _G.CollectionsJournal.shadow then
			_G.CollectionsJournal.shadow:Hide()
		end
	end

	local function RestoreJournalElements()
		if not Journal:IsActive() then
			return
		end

		_G.CollectionsJournal.backdrop:SetTemplate("Transparent")
		_G.CollectionsJournalCloseButton:Show()
		_G.CollectionsJournalTitleText:Show()
		if _G.CollectionsJournal.shadow then
			_G.CollectionsJournal.shadow:Show()
		end
	end

	self:SecureHook(Journal, "PLAYER_REGEN_ENABLED", HidePetJournalElements)
	self:SecureHook(Journal, "PetJournalOnShow", HidePetJournalElements)
	self:SecureHook(Journal, "PetJournalOnSetShown", function(_, shown)
		(shown and HidePetJournalElements or RestoreJournalElements)()
	end)
	self:Hook(Journal, "PLAYER_REGEN_DISABLED", RestoreJournalElements)
	self:Hook(Journal, "PetJournalOnHide", RestoreJournalElements)

	self:HookScript(Rematch.bottombar.UseRematchCheckButton, "OnClick", RestoreJournalElements)

	RunNextFrame(function()
		self:Proxy("HandleCheckBox", Journal.UseRematchCheckButton)
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

	ReskinTooltipsAndMenus()
	ReskinMainFrame(frame)
	ReskinTitleBar(frame.TitleBar)
	ReskinToolBar(frame.ToolBar)
	ReskinBottomBar(frame.BottomBar)
	ReskinLoadedTargetPanel(frame.LoadedTargetPanel, frame.PetsPanel, frame.TargetsPanel)
	ReskinLoadedTeamPanel(frame.LoadedTeamPanel)

	local skinned = false
	local checkButtonSkinned = false
	local moveHandled = false

	self:SecureHook(frame, "Show", function()
		if not skinned then
			skinned = true
			ReskinPetsPanel(frame.PetsPanel)
			ReskinPanelTabs(frame.PanelTabs)
			ReskinLoadoutPanel(frame.LoadoutPanel)
			ReskinMiniLoadoutPanel(frame.MiniLoadoutPanel)
			ReskinTeamsPanel(frame.TeamsPanel)
			ReskinTargetsPanel(frame.TargetsPanel)
			ReskinQueuePanel(frame.QueuePanel)
			ReskinOptionsPanel(frame.OptionsPanel)
			ReskinPetCard(_G.Rematch.petCard)
			ReskinNotesCard(_G.Rematch.notes)
			ReskinDialog(_G.Rematch.dialog)
		end

		if not checkButtonSkinned and _G.Rematch.journal and _G.Rematch.journal.UseRematchCheckButton then
			checkButtonSkinned = true
			self:Proxy("HandleCheckBox", _G.Rematch.journal.UseRematchCheckButton)
		end

		if not moveHandled and _G.CollectionsJournal then
			moveHandled = true
			MF:InternalHandle(frame, "CollectionsJournal")
			MF:InternalHandle(frame.ToolBar, "CollectionsJournal")
		end

		local _, relativeTo = frame:GetPoint(1)
		MF:SetMovable(frame, relativeTo and relativeTo == _G.CollectionsJournal)
	end)

	F.InternalizeMethod(frame, "SetPoint")
	hooksecurefunc(frame, "SetPoint", function(_, _, relativeTo)
		if relativeTo and relativeTo == _G.CollectionsJournal then
			F.Move(frame, 1, 0)
		end
	end)
	local _, relativeTo = frame:GetPoint(1)
	if relativeTo and relativeTo == _G.CollectionsJournal then
		F.Move(frame, 1, 0)
	end
end

S:AddCallbackForAddon("Rematch")
S:AddCallbackForAddon("Blizzard_Collections", "BlizzardCollections_Rematch")
