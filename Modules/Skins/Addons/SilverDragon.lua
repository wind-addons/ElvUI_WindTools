local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local TT = E:GetModule("Tooltip")

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local select = select
local type = type
local unpack = unpack

local RAID_CLASS_COLORS = RAID_CLASS_COLORS

-- Common styling utilities
local function StyleSilverDragonText(fontString, size, color)
	if not fontString then
		return
	end

	F.SetFontOutline(fontString, E.db.general.font, size)
	fontString:SetTextColor(color and unpack(color) or 1, 1, 1, 1)
	fontString:SetShadowOffset(1, -1)
	fontString:SetShadowColor(0, 0, 0, 0.8)
end

local function StyleSilverDragonLootWindow(frame)
	if not frame then
		return
	end

	if frame.buttons then
		for _, button in pairs(frame.buttons) do
			if not button.IsStyled then
				S:Proxy("HandleIcon", button.icon, true)
				S:Proxy("HandleIconBorder", button.IconBorder, button.icon.backdrop)
				button.icon.backdrop:OffsetFrameLevel(nil, button)
				button:GetNormalTexture():SetAlpha(0)
				button:GetPushedTexture():SetAlpha(0)
				button:GetHighlightTexture():SetTexture(E.media.blankTex)
				button:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.25)
				button.IsStyled = true
			end
		end
	end

	if frame.__windSkin then
		return
	end

	S:Proxy("HandleFrame", frame)
	S:CreateShadow(frame)

	if frame.title then
		StyleSilverDragonText(frame.title, E.db.general.fontSize)
	end

	if frame.close then
		S:Proxy("HandleCloseButton", frame.close)
		frame.close:SetHitRectInsets(0, 0, 0, 0)
		frame.close:Size(18, 18)
		frame.close:ClearAllPoints()
		frame.close:Point("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
	end

	F.InternalizeMethod(frame, "SetPoint")
	F.Move(frame, 0, -3)
	hooksecurefunc(frame, "SetPoint", function()
		F.Move(frame, 0, -3)
	end)

	frame.__windSkin = true
end

local function StyleSilverDragonPopup(popup, module)
	-- Style the main frame
	S:Proxy("HandleFrame", popup)
	S:CreateShadow(popup)

	-- Style elements
	if popup.background then
		popup.background:SetAllPoints()
	end

	if popup.close then
		S:Proxy("HandleCloseButton", popup.close)
		popup.close:ClearAllPoints()
		popup.close:SetHitRectInsets(0, 0, 0, 0)
		popup.close:SetFrameLevel(popup:GetFrameLevel() + 2)
		popup.close:Point("TOPRIGHT", popup, "TOPRIGHT", -3, -3)
		popup.close:Size(18, 18)
		if popup.close.backdrop then
			S:CreateShadow(popup.close.backdrop)
		end
	end

	if popup.lootIcon then
		S:Proxy("HandleButton", popup.lootIcon)
		popup.lootIcon.texture:SetAtlas("VignetteLoot")
		popup.lootIcon:HookScript("OnClick", function()
			F.WaitFor(function()
				return popup.lootIcon and popup.lootIcon.window and true or false
			end, function()
				StyleSilverDragonLootWindow(popup.lootIcon.window)
			end)
		end)
	end

	StyleSilverDragonText(popup.title, E.db.general.fontSize + 2)
	StyleSilverDragonText(popup.source, E.db.general.fontSize - 1, { 0.8, 0.8, 0.8, 1 })
	StyleSilverDragonText(popup.status, E.db.general.fontSize, { 1, 0.8, 0, 1 })
	if popup.lootIcon and popup.lootIcon.count then
		StyleSilverDragonText(popup.lootIcon.count, E.db.general.fontSize - 2)
	end

	if popup.glow then
		popup.glow:SetTexture([[Interface\FullScreenTextures\OutOfControl]])
		popup.glow:SetAllPoints()
	end
	if popup.shine then
		popup.shine:Point("TOPLEFT", 0, 0)
		popup.shine:Point("BOTTOMLEFT", 0, 0)
		popup.shine:SetWidth(32)
	end
	if popup.dead then
		popup.dead:SetAtlas("XMarksTheSpot")
		popup.dead:SetAlpha(0)
	end
	if popup.raidIcon then
		popup.raidIcon:Size(20, 20)
		popup.raidIcon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	end

	-- Override source text behavior
	popup.SetSource = function(_, source)
		if module.db.profile.model then
			popup.source:SetText(source or "")
		else
			popup.source:SetText(source and source:sub(0, 1) or "")
		end
	end
end

local function StyleSilverDragonHistoryLine(line)
	if not line or line.__windSkin then
		return
	end

	S:Proxy("HandleButton", line)

	line.icon:SetTexCoord(unpack(E.TexCoords))
	line.title:SetJustifyH("LEFT")
	StyleSilverDragonText(line.title, E.db.general.fontSize - 1)
	StyleSilverDragonText(line.time, E.db.general.fontSize - 2, { 0.8, 0.8, 0.8, 1 })
	StyleSilverDragonText(line.source, E.db.general.fontSize - 3, { 0.6, 0.6, 0.6, 1 })

	line.__windSkin = true
end

local function StyleSilverDragonHistoryWindow(frame, collapseButtonStatus)
	if not frame or frame.__windSkin then
		return
	end

	if frame.collapseButton then
		frame.collapseButton:Size(20, 20)
		frame.collapseButton:StripTextures()

		frame.collapseButton.SetNormalAtlas = E.noop
		frame.collapseButton.SetPushedAtlas = E.noop
		frame.collapseButton.SetDisabledAtlas = E.noop
		frame.collapseButton.SetHighlightAtlas = E.noop

		S:Proxy("HandleButton", frame.collapseButton)
		local normalTex = frame.collapseButton:GetNormalTexture()
		local pushedTex = frame.collapseButton:GetPushedTexture()
		local disabledTex = frame.collapseButton:GetDisabledTexture()
		disabledTex:SetVertexColor(0.5, 0.5, 0.5)

		local texes = { normalTex, pushedTex, disabledTex }

		for _, tex in pairs(texes) do
			tex:ClearAllPoints()
			tex:Point("CENTER")
			tex:Size(12, 12)
		end

		hooksecurefunc(frame.collapseButton, "SetButtonMode", function(button, mode)
			for _, tex in pairs(texes) do
				tex:SetTexture(mode == "Plus" and W.Media.Icons.buttonPlus or W.Media.Icons.buttonMinus)
			end
		end)

		frame.collapseButton:SetButtonMode(collapseButtonStatus and "Plus" or "Minus")
	end

	if frame.clearButton then
		frame.clearButton:Size(20, 20)
		frame.clearButton:StripTextures()

		S:Proxy("HandleButton", frame.clearButton)
		local normalTex = frame.clearButton:GetNormalTexture()
		local highlightTex = frame.clearButton:GetHighlightTexture()
		local pushedTex = frame.clearButton:GetPushedTexture()
		local disabledTex = frame.clearButton:GetDisabledTexture()
		disabledTex:SetVertexColor(0.5, 0.5, 0.5)

		for _, tex in pairs({ normalTex, highlightTex, pushedTex, disabledTex }) do
			tex:SetTexture(W.Media.Icons.buttonDelete)
			tex:ClearAllPoints()
			tex:Point("CENTER")
			tex:Size(14, 14)
		end
	end

	-- Style main frame
	S:Proxy("HandleFrame", frame)
	S:CreateShadow(frame)

	-- Style title
	StyleSilverDragonText(frame.title, E.db.general.fontSize)

	-- Fix dragon textures
	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region and region:GetObjectType() == "Texture" then
			local texture = region:GetTexture()
			if texture and type(texture) == "string" and texture:find("Dragon") then
				region:SetTexCoord(unpack(E.TexCoords))
			end
		end
	end

	-- Style resize button
	if frame.resize then
		local normalTex = frame.resize:GetNormalTexture()
		local highlightTex = frame.resize:GetHighlightTexture()
		local pushedTex = frame.resize:GetPushedTexture()

		for _, tex in pairs({ normalTex, highlightTex, pushedTex }) do
			tex:SetTexture(E.Media.Textures.ArrowUp)
			tex:SetTexCoord(0, 1, 0, 1)
			tex:SetRotation(-2.35)
		end

		normalTex:SetVertexColor(0.5, 0.5, 0.5)
		pushedTex:SetVertexColor(E.media.rgbvaluecolor.r, E.media.rgbvaluecolor.g, E.media.rgbvaluecolor.b)
		frame.resize:SetFrameLevel(200)
	end

	-- Style container and setup line hooks
	if frame.container then
		local container = frame.container
		S:Proxy("HandleTrimScrollBar", container.scrollBar)
		container.scrollBox:ForEachFrame(StyleSilverDragonHistoryLine)
		hooksecurefunc(container.scrollBox, "Update", function(box)
			box:ForEachFrame(StyleSilverDragonHistoryLine)
		end)
	end
end

local function ConfigureSilverDragonPopup(popup, config, module)
	-- Set background color
	local r, g, b, a = unpack(config.background)
	popup:SetBackdropColor(r, g, b, a)

	-- Set border color
	if config.classcolor then
		local classColor = RAID_CLASS_COLORS[E.myclass]
		if classColor then
			popup:SetBackdropBorderColor(classColor:GetRGB())
		end
	else
		popup:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end

	-- Layout elements based on model setting
	popup.title:ClearAllPoints()
	popup.status:ClearAllPoints()
	popup.source:ClearAllPoints()

	if module.db.profile.model then
		popup:Size(276, 80)
		popup.model:Show()

		popup.modelbg:SetTexture([[Interface\FrameGeneral\UI-Background-Marble]])
		popup.modelbg:SetVertexColor(0.2, 0.2, 0.2, 0.8)
		popup.modelbg:Point("TOPLEFT", 2, -2)
		popup.modelbg:Point("BOTTOMLEFT", 2, 2)
		popup.modelbg:SetWidth(popup:GetHeight() - 4)
		module:SizeModel(popup, 0, 0)

		popup.title:Point("TOPLEFT", popup.modelbg, "TOPRIGHT", 8, -8)
		popup.title:Point("TOPRIGHT", popup, "TOPRIGHT", -25, -8)
		popup.status:Point("TOPLEFT", popup.title, "BOTTOMLEFT", 0, -4)
		popup.status:Point("TOPRIGHT", popup.title, "BOTTOMRIGHT", 0, -4)
		popup.source:Point("BOTTOMRIGHT", -8, 4)

		popup.raidIcon:Point("BOTTOM", popup.modelbg, "TOP", 0, 2)
		popup.lootIcon:Point("BOTTOMLEFT", popup.modelbg, "BOTTOMLEFT", -2, -2)
		popup.lootIcon:Size(24, 24)

		popup.dead:SetAllPoints(popup.modelbg)
		popup.shine.animIn.translate:SetOffset(240, 0)
	else
		popup:Size(240, 50)
		popup.model:Hide()

		popup.title:Point("TOPLEFT", popup, "TOPLEFT", 8, -8)
		popup.title:Point("TOPRIGHT", popup, "TOPRIGHT", -25, -8)
		popup.status:Point("BOTTOM", 0, 8)
		popup.status:SetJustifyH("CENTER")
		popup.source:Point("BOTTOMRIGHT", -8, 4)

		popup.raidIcon:Point("BOTTOM", popup.title, "TOP", 0, 2)
		popup.lootIcon:Point("BOTTOMLEFT", 4, 4)
		popup.lootIcon:Size(20, 20)

		popup.dead:SetAllPoints(popup)
		popup.shine.animIn.translate:SetOffset(180, 0)
	end

	-- Style loot icon backdrop
	if popup.lootIcon and popup.lootIcon.backdrop then
		popup.lootIcon.backdrop:SetBackdropColor(0, 0, 0, 0.6)
		popup.lootIcon.backdrop:SetBackdropBorderColor(0.8, 0.6, 0, 1)
	end
end

local function SetupSilverDragonOverlay(silverDragon)
	local module = silverDragon:GetModule("Overlay", true)
	if not module or not module.ShowTooltip then
		return
	end

	hooksecurefunc(module, "ShowTooltip", function(overlayModule)
		F.WaitFor(function()
			return overlayModule.lootwindow and true or false
		end, function()
			StyleSilverDragonLootWindow(overlayModule.lootwindow)
		end)
	end)

	if module.tooltip then
		TT:SetStyle(module.tooltip)
		if module.tooltip.shoppingTooltips then
			for _, tooltip in pairs(module.tooltip.shoppingTooltips) do
				TT:SetStyle(tooltip)
			end
		end
	end
end

local function SetupSilverDragonPopups(silverDragon)
	local module = silverDragon:GetModule("ClickTarget", true)
	if not module then
		return
	end

	-- Register the WindTools look
	function module.Looks:WindTools(popup, config)
		StyleSilverDragonPopup(popup, module)
	end

	-- Register look configuration
	module:RegisterLookConfig("WindTools", {
		classcolor = {
			type = "toggle",
			name = "Class colored border",
			desc = "Color the border of the popup by your class color",
		},
		background = { type = "color", name = "Background color", hasAlpha = true },
	}, {
		classcolor = false,
		background = { 0, 0, 0, 0.8 },
	}, function(_, popup, config)
		ConfigureSilverDragonPopup(popup, config, module)
	end)

	-- Set default style if needed
	if module.db.profile.style == "SilverDragon" then
		module.db.profile.style = "WindTools"
	end
end

local function SetupSilverDragonHistory(silverDragon)
	local module = silverDragon:GetModule("History", true)
	if not module then
		return
	end

	if module.window then
		StyleSilverDragonHistoryWindow(module.window, module.db.collapsed)
	end

	if module.ShowWindow then
		hooksecurefunc(module, "ShowWindow", function(historyModule)
			if historyModule.window then
				StyleSilverDragonHistoryWindow(historyModule.window, historyModule.db.collapsed)
			end
		end)
	end
end

function S:SilverDragon()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.silverDragon then
		return
	end

	self:DisableAddOnSkin("SilverDragon")

	local SilverDragon = _G.LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
	if not SilverDragon then
		return
	end

	SetupSilverDragonPopups(SilverDragon)
	SetupSilverDragonHistory(SilverDragon)
	SetupSilverDragonOverlay(SilverDragon)
end

S:AddCallbackForAddon("SilverDragon")
