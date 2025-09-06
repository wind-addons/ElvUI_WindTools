local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local MB = W:NewModule("MinimapButtons", "AceEvent-3.0", "AceHook-3.0") ---@class MinimapButtons : AceModule, AceEvent-3.0, AceHook-3.0
local S = W.Modules.Skins ---@type Skins
local EM = E:GetModule("Minimap")

local _G = _G
local ceil = ceil
local floor = floor
local min = min
local pairs = pairs
local select = select
local sort = sort
local strfind = strfind
local strlen = strlen
local strsub = strsub
local tinsert = tinsert
local tremove = tremove
local type = type
local unpack = unpack

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_Spell_GetSpellTexture = C_Spell.GetSpellTexture

local IgnoreList = {
	full = {
		"AsphyxiaUIMinimapHelpButton",
		"AsphyxiaUIMinimapVersionButton",
		"ElvConfigToggle",
		"ElvUIConfigToggle",
		"ElvUI_ConsolidatedBuffs",
		"HelpOpenTicketButton",
		"ElvUI_MinimapHolder",
		"DroodFocusMinimapButton",
		"TimeManagerClockButton",
		"MinimapZoneTextButton",
		"GameTimeFrame",
	},
	libDBIcon = {},
	startWith = {
		"Archy",
		"GatherMatePin",
		"GatherNote",
		"GuildInstance",
		"HandyNotesPin",
		"MinimMap",
		"Spy_MapNoteList_mini",
		"ZGVMarker",
		"poiMinimap",
		"GuildMap3Mini",
		"LibRockConfig-1.0_MinimapButton",
		"NauticusMiniIcon",
		"WestPointer",
		"Cork",
		"DugisArrowMinimapPoint",
		"TTMinimapButton",
		"QueueStatusButton",
	},
	partial = {
		"Node",
		"Note",
		"Pin",
		"POI",
	},
}

local TexCoordIgnoreList = {
	["Narci_MinimapButton"] = true,
	["ZygorGuidesViewerMapIcon"] = true,
}

local whiteList = {}

local acceptedFrames = {
	"BagSync_MinimapButton",
}

local handledButtons = {}

local function isValidName(name)
	for _, ignoreName in pairs(IgnoreList.full) do
		if name == ignoreName then
			return false
		end
	end

	for _, ignoreName in pairs(IgnoreList.startWith) do
		if strsub(name, 1, strlen(ignoreName)) == ignoreName then
			return false
		end
	end

	for _, ignoreName in pairs(IgnoreList.partial) do
		if strfind(name, ignoreName) ~= nil then
			return false
		end
	end

	return true
end

function MB:OnButtonSetShown(button, shown)
	local buttonName = button:GetName()

	for i, handledButtonName in pairs(handledButtons) do
		if buttonName == handledButtonName then
			if shown then
				return -- already in the list
			end
			tremove(handledButtons, i)
			break
		end
	end

	if shown then
		tinsert(handledButtons, buttonName)
	end

	self:UpdateLayout()
end

function MB:HandleLibDBIconButton(button, name)
	if not strsub(name, 1, strlen("LibDBIcon")) == "LibDBIcon" then
		return true
	end

	if not button.Show or not button.Hide or not button.IsShown then
		return true
	end

	self:SecureHook(button, "Hide", function()
		self:OnButtonSetShown(button, false)
	end)

	self:SecureHook(button, "Show", function()
		self:OnButtonSetShown(button, true)
	end)

	self:SecureHook(button, "SetShown", "OnButtonSetShown")

	if button.icon and button.icon.SetTexCoord and not self:IsHooked(button.icon, "SetTexCoord") then
		F.InternalizeMethod(button.icon, "SetTexCoord")
		self:SecureHook(button.icon, "SetTexCoord", function(icon, arg1, arg2, arg3, arg4)
			local args = { arg1, arg2, arg3, arg4 }
			if F.IsAlmost(args, { 0.05, 0.95, 0.05, 0.95 }, 0.002) or F.IsAlmost(args, { 0, 1, 0, 1 }, 0.002) then
				F.CallMethod(icon, "SetTexCoord", unpack(E.TexCoords))
			end
		end)
		button.icon:SetTexCoord(unpack(E.TexCoords))
	end

	return button:IsShown()
end

function MB:HandleExpansionButton(...)
	self.hooks[EM].HandleExpansionButton(...)
	self:Unhook(EM, "HandleExpansionButton")

	-- Run this post hook lazily and safely
	F.WaitFor(function()
		return MB ~= nil and MB.db ~= nil
	end, function()
		if not MB.db.enable or not MB.db.expansionLandingPage then
			return
		end

		local button = _G.ExpansionLandingPageMinimapButton
		if not button then
			return
		end

		self:SkinButton(button, true)

		EM:SetIconParent(button)
		EM:SetScale(button, 1)

		F.InternalizeMethod(button, "ClearAllPoints", true)
		F.InternalizeMethod(button, "SetPoint", true)
		F.InternalizeMethod(button, "SetParent", true)
		F.InternalizeMethod(button, "SetSize", true)
		F.InternalizeMethod(button, "SetScale", true)
		F.InternalizeMethod(button, "SetFrameStrata", true)
		F.InternalizeMethod(button, "SetFrameLevel", true)
		F.InternalizeMethod(button, "SetMovable", true)

		local box = _G.GarrisonLandingPageTutorialBox
		if box then
			box:SetScale(1)
			box:SetClampedToScreen(true)
		end

		button:SetHitRectInsets(0, 0, 0, 0)
		if button.AlertText then
			button.AlertText:Kill()
			button.AlertText.SetText = function(_, text)
				if text then
					local event = F.CreateColorString(button.title or L["Garrison"], E.db.general.valuecolor)
					F.Print(event .. " " .. text)
				end
			end
		end

		if button.AlertBG then
			button.AlertBG:Kill()
		end

		F.TaskManager:OutOfCombat(MB.UpdateLayout, MB)
	end, 0.1, 100)
end

function MB:SetButtonMouseOver(button, frame, rawhook)
	if not frame.HookScript then
		return
	end

	local function ButtonOnEnter()
		if button.backdrop.SetBackdropBorderColor then
			button.backdrop:SetBackdropBorderColor(
				E.db.general.valuecolor.r,
				E.db.general.valuecolor.g,
				E.db.general.valuecolor.b
			)
		end
		if not self.db.mouseOver then
			return
		end
		E:UIFrameFadeIn(self.bar, (1 - self.bar:GetAlpha()) * 0.382, self.bar:GetAlpha(), 1)
	end

	local function ButtonOnLeave()
		if button.backdrop.SetBackdropBorderColor then
			button.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
		if not self.db.mouseOver then
			return
		end
		E:UIFrameFadeOut(self.bar, self.bar:GetAlpha() * 0.382, self.bar:GetAlpha(), 0)
	end

	if not rawhook then
		frame:HookScript("OnEnter", ButtonOnEnter)
		frame:HookScript("OnLeave", ButtonOnLeave)
	else
		local OriginalOnEnter = frame:GetScript("OnEnter") or E.noop
		local OriginalOnLeave = frame:GetScript("OnLeave") or E.noop
		frame:SetScript("OnEnter", function()
			OriginalOnEnter(frame)
			ButtonOnEnter()
		end)
		frame:SetScript("OnLeave", function()
			OriginalOnLeave(frame)
			ButtonOnLeave()
		end)
	end
end

function MB:SkinButton(button, force)
	if button == nil then
		return
	end

	local name = button:GetDebugName()
	if not force and (name == nil or not button:IsVisible() or button.isSkinned) then
		return
	end

	local buttonType, frameType = nil, button:GetObjectType()
	if frameType == "Button" then
		buttonType = 1
	elseif frameType == "Frame" then
		for _, f in pairs(acceptedFrames) do
			if button:GetName() == f then
				buttonType = 2
				break
			end
		end
	end

	if not buttonType then
		return
	end

	local valid = false
	for i = 1, #whiteList do
		if strsub(name, 1, strlen(whiteList[i])) == whiteList[i] then
			valid = true
			break
		end
	end

	if strsub(name, 1, strlen("LibDBIcon")) == "LibDBIcon" then
		valid = true
		for _, ignoreName in pairs(IgnoreList.libDBIcon) do
			if strsub(name, strlen("LibDBIcon10_") + 1) == ignoreName then
				return
			end
		end
	end

	if not valid and not isValidName(name) then
		return
	end

	-- If the relative frame is Minimap, then replace it to fake Minimap
	-- It must run before FarmHud moving the Minimap
	if C_AddOns_IsAddOnLoaded("FarmHud") then
		if not self:IsHooked(button, "SetPoint") then
			self:RawHook(button, "SetPoint", function(...)
				local relativeTo = select(3, ...)
				if relativeTo and relativeTo == _G.Minimap then
					return
				end
				return self.hooks[button].SetPoint(...)
			end, true)
		end
	end

	-- Pre-skinning
	if name == "DBMMinimapButton" then
		button:SetNormalTexture("Interface\\Icons\\INV_Helmet_87")
	elseif name == "SmartBuff_MiniMapButton" then
		button:SetNormalTexture(C_Spell_GetSpellTexture(12051))
	elseif name == "GRM_MinimapButton" then
		button.GRM_MinimapButtonBorder:Hide()
		button:SetPushedTexture("")
		button:SetHighlightTexture("")
		button.SetPushedTexture = E.noop
		button.SetHighlightTexture = E.noop
		if button:HasScript("OnEnter") then
			self:SetButtonMouseOver(button, button, true)
			button.OldSetScript = button.SetScript
			button.SetScript = E.noop
		end
	elseif strsub(name, 1, strlen("TomCats-")) == "TomCats-" then
		button:SetPushedTexture("")
		button:SetDisabledTexture("")
		button:GetHighlightTexture():Kill()
	elseif name == "BtWQuestsMinimapButton" and _G.BtWQuestsMinimapButtonIcon then
		for _, region in pairs({ button:GetRegions() }) do
			if region ~= _G.BtWQuestsMinimapButtonIcon then
				region:SetTexture(nil)
				region:SetAlpha(0)
				region:Hide()
			end
		end
	elseif name == "JST_MinimapButton" then
		button.anim:Stop()
		button.anim.Play = E.noop
		button.bg:Kill()
		button.icon:SetAlpha(1)
		button.icon:Show()
		button.icon.Hide = E.noop
		button.icon2:Kill()
		button.timer:SetScript("OnUpdate", nil)
		button.timer.SetScript = E.noop
	elseif name == "MRPMinimapButton" then
		for _, region in pairs({ button:GetRegions() }) do
			if region:GetTexture() > 0 then
				region:Hide()
			end
		end
	elseif buttonType ~= 2 then
		button:SetPushedTexture("")
		button:SetDisabledTexture("")
		button:SetHighlightTexture("")
	end

	if buttonType ~= 2 then
		button:HookScript("OnClick", self.DelayedUpdateLayout)
	end

	-- Skin the textures
	for _, region in pairs({ button:GetRegions() }) do
		local original = {}
		original.Width, original.Height = button:GetSize()
		original.Point, original.relativeTo, original.relativePoint, original.xOfs, original.yOfs = button:GetPoint()
		original.Parent = button:GetParent()
		original.FrameStrata = button:GetFrameStrata()
		original.FrameLevel = button:GetFrameLevel()
		original.Scale = button:GetScale()
		if button:HasScript("OnDragStart") then
			original.DragStart = button:GetScript("OnDragStart")
		end
		if button:HasScript("OnDragStop") then
			original.DragEnd = button:GetScript("OnDragStop")
		end

		button.original = original

		if region:IsObjectType("Texture") then
			local tex = region:GetTexture()

			-- Remove rings and backdrops of LibDBIcon icons
			if tex and strsub(name, 1, strlen("LibDBIcon")) == "LibDBIcon" then
				if region ~= button.icon then
					region:SetTexture(nil)
				end
			end

			if
				tex
				and type(tex) ~= "number"
				and (strfind(tex, "Border") or strfind(tex, "Background") or strfind(tex, "AlphaMask"))
			then
				region:SetTexture(nil)
			else
				if name == "BagSync_MinimapButton" then
					region:SetTexture("Interface\\AddOns\\BagSync\\media\\icon")
				end

				if not TexCoordIgnoreList[name] then
					-- Mask cleanup
					if region.GetNumMaskTextures and region.RemoveMaskTexture and region.GetMaskTexture then
						local numMaskTextures = region:GetNumMaskTextures()
						if numMaskTextures and numMaskTextures > 0 then
							for i = 1, numMaskTextures do
								region:RemoveMaskTexture(region:GetMaskTexture(i))
							end
						else
							region:SetMask("")
						end
					elseif region.SetMask then
						region:SetMask("")
					end

					region:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				end

				region:ClearAllPoints()
				region:Point("TOPLEFT", button, "TOPLEFT", 2, -2)
				region:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
				region:SetDrawLayer("ARTWORK")

				if name == "PS_MinimapButton" then
					region.SetPoint = E.noop
				end
			end
		end
	end

	-- Create the backdrop
	if button.backdrop then
		if name == "LibDBIcon10_Musician" then
			button.backdrop:Kill()
			button.backdrop = nil
		end
	end

	button:CreateBackdrop()
	S:CreateShadowModule(button.backdrop)

	self:SetButtonMouseOver(button, button)

	-- After fix for some buttons
	if name == "Narci_MinimapButton" then
		self:SetButtonMouseOver(button, button.Panel)
		for _, child in pairs({ button.Panel:GetChildren() }) do
			if child.SetScript and not child.Highlight then
				self:SetButtonMouseOver(button, child, true)
			end
		end
	elseif name == "TomCats-MinimapButton" then
		if _G["TomCats-MinimapButtonBorder"] then
			_G["TomCats-MinimapButtonBorder"]:SetAlpha(0)
		end
		if _G["TomCats-MinimapButtonBackground"] then
			_G["TomCats-MinimapButtonBackground"]:SetAlpha(0)
		end
		if _G["TomCats-MinimapButtonIcon"] then
			_G["TomCats-MinimapButtonIcon"]:ClearAllPoints()
			_G["TomCats-MinimapButtonIcon"]:SetInside(button.backdrop)
			F.InternalizeMethod(_G["TomCats-MinimapButtonIcon"], "SetPoint", true)
			_G["TomCats-MinimapButtonIcon"]:SetTexCoord(0, 0.65, 0, 0.65)
		end
	end

	if self:HandleLibDBIconButton(button, name) then
		tinsert(handledButtons, name)
	end

	button.isSkinned = true
end

function MB.DelayedUpdateLayout()
	if MB.db.orientation ~= "NOANCHOR" then
		E:Delay(1, MB.UpdateLayout, MB)
	end
end

function MB:UpdateLayout()
	if not self.db.enable then
		return
	end

	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateLayout")
		return
	else
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end

	sort(handledButtons)

	local buttonsPerRow = self.db.buttonsPerRow
	local numOfRows = ceil(#handledButtons / buttonsPerRow)
	local spacing = self.db.spacing
	local backdropSpacing = self.db.backdropSpacing
	local buttonSize = self.db.buttonSize
	local direction = not self.db.inverseDirection

	local buttonX, buttonY, anchor, offsetX, offsetY

	for i, moveButton in pairs(handledButtons) do
		local frame = _G[moveButton]
		F.CallMethod(frame, "ClearAllPoints")

		if self.db.orientation == "NOANCHOR" then
			local original = frame.original
			F.CallMethod(frame, "SetParent", original.Parent)
			if original.DragStart then
				F.CallMethod(frame, "SetScript", "OnDragStart", original.DragStart)
			end
			if original.DragEnd then
				F.CallMethod(frame, "SetScript", "OnDragStop", original.DragEnd)
			end

			F.CallMethod(frame, "SetSize", original.Width, original.Height)

			if original.Point ~= nil then
				F.CallMethod(
					frame,
					"SetPoint",
					frame,
					original.Point,
					original.relativeTo,
					original.relativePoint,
					original.xOfs,
					original.yOfs
				)
			else
				F.CallMethod(frame, "SetPoint", "CENTER", _G.Minimap, "CENTER", -80, -34)
			end

			F.CallMethod(frame, "SetFrameStrata", original.FrameStrata)
			F.CallMethod(frame, "SetFrameLevel", original.FrameLevel)
			F.CallMethod(frame, "SetMovable", true)
			F.CallMethod(frame, "SetScale", original.Scale)
		else
			buttonX = i % buttonsPerRow
			buttonY = floor(i / buttonsPerRow) + 1

			if buttonX == 0 then
				buttonX = buttonsPerRow
				buttonY = buttonY - 1
			end

			F.CallMethod(frame, "SetParent", self.bar)
			F.CallMethod(frame, "SetFrameStrata", "LOW")
			F.CallMethod(frame, "SetFrameLevel", 20)
			F.CallMethod(frame, "SetMovable", false)
			F.CallMethod(frame, "SetScript", "OnDragStart", nil)
			F.CallMethod(frame, "SetScript", "OnDragStop", nil)

			offsetX = backdropSpacing + (buttonX - 1) * (buttonSize + spacing)
			offsetY = backdropSpacing + (buttonY - 1) * (buttonSize + spacing)

			if self.db.orientation == "HORIZONTAL" then
				if direction then
					anchor = "TOPLEFT"
					offsetY = -offsetY
				else
					anchor = "TOPRIGHT"
					offsetX, offsetY = -offsetX, -offsetY
				end
			else
				if direction then
					anchor = "TOPLEFT"
					offsetX, offsetY = offsetY, -offsetX
				else
					anchor = "BOTTOMLEFT"
					offsetX, offsetY = offsetY, offsetX
				end
			end

			F.CallMethod(frame, "SetSize", buttonSize, buttonSize)
			F.CallMethod(frame, "SetPoint", anchor, self.bar, anchor, offsetX, offsetY)
		end

		if
			E.private.WT.skins.enable
			and E.private.WT.skins.windtools
			and E.private.WT.skins.shadow
			and frame.backdrop.shadow
		then
			frame.backdrop.shadow:SetShown(not self.db.backdrop)
		end
	end

	buttonsPerRow = min(buttonsPerRow, #handledButtons)

	if self.db.orientation ~= "NOANCHOR" and #handledButtons > 0 then
		local width = buttonSize * buttonsPerRow + spacing * (buttonsPerRow - 1) + backdropSpacing * 2
		local height = buttonSize * numOfRows + spacing * (numOfRows - 1) + backdropSpacing * 2

		if self.db.orientation == "VERTICAL" then
			width, height = height, width
		end

		self.bar:Size(width, height)
		self.barAnchor:Size(width, height)
		RegisterStateDriver(self.bar, "visibility", "[petbattle]hide;show")
		self.bar:Show()
	else
		UnregisterStateDriver(self.bar, "visibility")
		self.bar:Hide()
	end

	if self.db.orientation == "HORIZONTAL" then
		anchor = direction and "LEFT" or "RIGHT"
	else
		anchor = direction and "TOP" or "BOTTOM"
	end

	self.bar:Point(anchor, self.barAnchor, anchor, 0, 0)

	if self.db.backdrop then
		self.bar.backdrop:Show()
	else
		self.bar.backdrop:Hide()
	end
end

function MB:SkinMinimapButtons()
	self:RegisterEvent("ADDON_LOADED", "StartSkinning")

	for _, child in pairs({ _G.Minimap:GetChildren() }) do
		self:SkinButton(child)
	end

	self:UpdateLayout()
end

function MB:UpdateMouseOverConfig()
	if self.db.mouseOver then
		self.bar:SetScript("OnEnter", function(bar)
			E:UIFrameFadeIn(bar, (1 - bar:GetAlpha()) * 0.382, bar:GetAlpha(), 1)
		end)

		self.bar:SetScript("OnLeave", function(bar)
			E:UIFrameFadeOut(bar, bar:GetAlpha() * 0.382, bar:GetAlpha(), 0)
		end)

		self.bar:SetAlpha(0)
	else
		self.bar:SetScript("OnEnter", nil)
		self.bar:SetScript("OnLeave", nil)
		self.bar:SetAlpha(1)
	end
end

function MB:StartSkinning()
	self:UnregisterEvent("ADDON_LOADED")
	E:Delay(5, self.SkinMinimapButtons, self)
end

function MB:CreateFrames()
	if self.bar then
		return
	end

	local frame = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
	frame:Point("TOPRIGHT", EM.MapHolder, "BOTTOMRIGHT", 0, -5)
	frame:SetFrameStrata("BACKGROUND")
	self.barAnchor = frame

	frame = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
	frame:SetFrameStrata("LOW")
	frame:CreateBackdrop("Transparent")
	frame:ClearAllPoints()
	frame:Point("CENTER", self.barAnchor, "CENTER", 0, 0)
	self.bar = frame

	self:SkinMinimapButtons()

	S:CreateShadowModule(self.bar.backdrop)
	S:MerathilisUISkin(self.bar.backdrop)

	E:CreateMover(
		self.barAnchor,
		"WTMinimapButtonBarAnchor",
		L["Minimap Buttons Bar"],
		nil,
		nil,
		nil,
		"ALL,WINDTOOLS",
		function()
			return E.private.WT.maps.minimapButtons.enable
		end,
		"WindTools,maps,minimapButtons"
	)
end

function MB:SetUpdateHook()
	if not self.initialized then
		self:SecureHook(EM, "SetGetMinimapShape", "UpdateLayout")
		self:SecureHook(EM, "UpdateSettings", "UpdateLayout")
		self:SecureHook(E, "UpdateAll", "UpdateLayout")
		self.initialized = true
	end
end

function MB:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:SetUpdateHook()
	E:Delay(1, self.SkinMinimapButtons, self)
end

function MB:Initialize()
	self.db = E.private.WT.maps.minimapButtons
	if not self.db.enable then
		return
	end

	self:CreateFrames()
	self:UpdateMouseOverConfig()

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

MB:RawHook(EM, "HandleExpansionButton")
W:RegisterModule(MB:GetName())
