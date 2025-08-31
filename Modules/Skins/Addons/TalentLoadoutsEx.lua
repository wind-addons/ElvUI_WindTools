local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local MF = W.Modules.MoveFrames ---@type MoveFrames

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local select = select
local unpack = unpack

-- Modified from NDui_Plus
local function ReskinChildButton(self)
	for _, child in pairs({ self:GetChildren() }) do
		if child:GetObjectType() == "Button" and child.Left and child.Middle and child.Right and child.Text then
			S:Proxy("HandleButton", child)
		end
	end
end

local function SkinListButton(button)
	if not button.__wind then
		button:DisableDrawLayer("BACKGROUND")
		button.Check:SetAtlas("checkmark-minimal")
		S:Proxy("HandleIcon", button.Icon)
		S:Proxy("HandleCollapseTexture", button.ToggleButton)
		button.ToggleButton:GetPushedTexture():SetAlpha(0)

		button:CreateBackdrop()
		button.backdrop:SetAllPoints()
		local r, g, b = unpack(E.media.rgbvaluecolor)
		button.SelectedBar:SetColorTexture(r, g, b, 0.25)
		button.SelectedBar:SetInside(button.backdrop)
		local highlight = button:GetHighlightTexture()
		highlight:SetColorTexture(1, 1, 1, 0.25)
		highlight:SetInside(button.backdrop)

		button.__wind = true
	end

	button.backdrop:SetShown(not not (button.data and not button.data.text))
end

local function ReskinPopupFrame(frame)
	frame.Border:StripTextures()
	frame.Header:StripTextures()
	frame.Main:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)
end

local function HandleIconSelectionFrameButton(button)
	button:DisableDrawLayer("BACKGROUND")
	button.SelectedTexture:SetColorTexture(1, 0.8, 0, 0.5)
	button.SelectedTexture:SetAllPoints(button.Icon)
	button.Icon:SetTexCoord(unpack(E.TexCoords))
	button.Icon:SetInside(button)
	button:SetTemplate()
	button:StyleButton(nil, true)
end

function S:TalentLoadoutsEx()
	local frame = _G.TalentLoadoutExMainFrame
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", _G.PlayerSpellsFrame, "TOPRIGHT", 1, 0)
	frame:SetPoint("BOTTOMLEFT", _G.PlayerSpellsFrame, "BOTTOMRIGHT", 1, 0)
	self:Proxy("HandleTrimScrollBar", frame.ScrollBar)
	ReskinChildButton(frame)
	self:CreateShadow(frame)
	F.Move(frame, 3, 0)
	MF:InternalHandle(frame, "PlayerSpellsFrame")

	for _, button in frame.ScrollBox:EnumerateFrames() do
		SkinListButton(button)
	end

	hooksecurefunc(frame.ScrollBox, "Update", function(box)
		box:ForEachFrame(SkinListButton)
	end)

	local popupFrame = frame.EditPopupFrame
	if popupFrame then
		local forEachFrame = popupFrame.IconSelector.ScrollBox.ForEachFrame
		popupFrame.IconSelector.ScrollBox.ForEachFrame = E.noop
		self:Proxy("HandleIconSelectionFrame", popupFrame)
		popupFrame.IconSelector.ScrollBox.ForEachFrame = forEachFrame
		hooksecurefunc(popupFrame.IconSelector.ScrollBox, "Update", function(sb)
			for i = 1, sb.ScrollTarget:GetNumChildren() do
				local child = select(i, sb.ScrollTarget:GetChildren())
				HandleIconSelectionFrameButton(child)
			end
		end)

		local listFrame = popupFrame.IconListFrame
		if listFrame then
			listFrame:StripTextures()
			listFrame:SetTemplate("Transparent")
			self:CreateShadow(listFrame)
			listFrame:ClearAllPoints()
			listFrame:SetPoint("TOPLEFT", popupFrame, "BOTTOMLEFT", 0, -4)
			listFrame:SetPoint("TOPRIGHT", popupFrame, "BOTTOMRIGHT", 0, -4)

			for _, child in pairs({ listFrame:GetChildren() }) do
				if child.icon and child.name then
					local hl = child:GetHighlightTexture()
					hl:SetColorTexture(1, 1, 1, 0.25)
					hl:SetAllPoints(child.texture)
					self:Proxy("HandleIcon", child.texture)
				end
			end
		end

		local textFrame = popupFrame.TalentTextFrame
		if textFrame then
			textFrame:StripTextures()
			textFrame:SetTemplate("Transparent")
			self:CreateShadow(textFrame)
			textFrame:ClearAllPoints()
			textFrame:SetPoint("BOTTOMLEFT", popupFrame, "TOPLEFT", 0, 4)
			textFrame:SetPoint("BOTTOMRIGHT", popupFrame, "TOPRIGHT", 0, 4)
			textFrame.Main:StripTextures()

			local editBox = textFrame.Main and textFrame.Main.EditBox
			if editBox then
				self:Proxy("HandleEditBox", editBox)
				editBox:ClearAllPoints()
				editBox:SetPoint("TOPLEFT", 2, -2)
				editBox:SetPoint("BOTTOMRIGHT", -2, 2)
			end
		end
	end

	local textPopup = frame.TextPopupFrame and frame.TextPopupFrame.Main
	if textPopup then
		ReskinPopupFrame(frame.TextPopupFrame)
		textPopup.ScrollFrame:StripTextures()
		textPopup.ScrollFrame:SetTemplate("Transparent")
		self:Proxy("HandleScrollBar", textPopup.ScrollFrame and textPopup.ScrollFrame.ScrollBar)
		ReskinChildButton(textPopup)
	end

	local presetPopup = frame.PresetPopupFrame and frame.PresetPopupFrame.Main
	if presetPopup then
		ReskinPopupFrame(frame.PresetPopupFrame)
		self:Proxy("HandleDropDownBox", presetPopup.AddonDropDownMenu)

		local configFrame = presetPopup.AddonConfigFrame1
		if configFrame then
			self:Proxy("HandleDropDownBox", configFrame.ModeOptionFrame and configFrame.ModeOptionFrame.DropDownMenu)
			self:Proxy("HandleCheckBox", configFrame.CombineOptionFrame and configFrame.CombineOptionFrame.CheckButton)
		end
	end

	local pvpFrame = frame.PvpFrame
	if pvpFrame then
		pvpFrame:StripTextures()
		self:Proxy("HandleCheckBox", pvpFrame.CheckButton)
		pvpFrame.CheckButton:Size(24, 24)
	end
end

function S:TalentLoadoutsExWaitFor()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.talentLoadoutsEx then
		return
	end

	F.WaitFor(function()
		return not not _G.TalentLoadoutExMainFrame
	end, function()
		self:TalentLoadoutsEx()
	end)
end

S:AddCallbackForAddon("Blizzard_PlayerSpells", "TalentLoadoutsExWaitFor")
