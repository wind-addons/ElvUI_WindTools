local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local TT = E:GetModule("Tooltip")
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

local function styleIconsInLine(line, text)
	if not line then
		return
	end

	text = text or line:GetText()
	local styledText = S:StyleTextureString(text)
	if styledText and styledText ~= text then
		F.CallMethod(line, "SetText", styledText)
	end
end

local function StyleTooltipWidgetContainer(tt)
	if not tt or (tt == E.ScanTooltip or tt.IsEmbedded or not tt.NineSlice) or tt:IsForbidden() then
		return
	end

	if not tt.widgetContainer or not tt.widgetContainer.widgetPools then
		return
	end

	for frame in tt.widgetContainer.widgetPools:EnumerateActive() do
		if not frame.__windSkin then
			if frame.Text then
				F.InternalizeMethod(frame.Text, "SetText")
				hooksecurefunc(frame.Text, "SetText", styleIconsInLine)
				F.SetFontOutline(frame.Text)
				frame.Text:SetText(frame.Text:GetText())
			end
			frame.__windSkin = true
		end
	end
end

function S:StyleIconsInTooltip(tt)
	if tt:IsForbidden() or not tt.NumLines or not E.db.general.cropIcon then
		return
	end

	for i = 2, tt:NumLines() do
		styleIconsInLine(_G[tt:GetName() .. "TextLeft" .. i])
		styleIconsInLine(_G[tt:GetName() .. "TextRight" .. i])
	end
end

function S:ReskinTooltip(tt)
	if not tt or (tt == E.ScanTooltip or tt.IsEmbedded or not tt.NineSlice) or tt:IsForbidden() then
		return
	end

	self:CreateShadow(tt.NineSlice)

	if tt.TopOverlay then
		tt.TopOverlay:StripTextures()
	end

	if tt.BottomOverlay then
		tt.BottomOverlay:StripTextures()
	end

	if not self:IsHooked(tt, "Show") then
		StyleTooltipWidgetContainer(tt)
		self:SecureHook(tt, "Show", "StyleIconsInTooltip")
	end
end

function S:TooltipFrames()
	if not self:CheckDB("tooltip", "tooltips") then
		return
	end

	-- Tooltip list from ElvUI
	local tooltips = {
		_G.ItemRefTooltip,
		_G.ItemRefShoppingTooltip1,
		_G.ItemRefShoppingTooltip2,
		_G.FriendsTooltip,
		_G.EmbeddedItemTooltip,
		_G.ReputationParagonTooltip,
		_G.GameTooltip,
		_G.WorldMapTooltip,
		_G.ShoppingTooltip1,
		_G.ShoppingTooltip2,
		_G.QuickKeybindTooltip,
		-- ours
		E.ConfigTooltip,
		E.SpellBookTooltip,
		-- libs
		_G.LibDBIconTooltip,
		_G.SettingsTooltip,
	}

	for _, tt in pairs(tooltips) do
		if tt and tt ~= E.ScanTooltip and not tt.IsEmbedded and not tt:IsForbidden() then
			self:ReskinTooltip(tt)
		end
	end

	self:SecureHook(TT, "SetStyle", function(_, tt, _, isEmbedded)
		if not isEmbedded then
			self:ReskinTooltip(tt)
		end
	end)

	hooksecurefunc("GameTooltip_AddWidgetSet", StyleTooltipWidgetContainer)

	self:SecureHook(_G.QueueStatusFrame, "Update", "CreateShadow")
	self:CreateBackdropShadow(_G.GameTooltipStatusBar)
	self:SecureHook(TT, "GameTooltip_SetDefaultAnchor", function(_, tt)
		if tt.StatusBar and tt.StatusBar.backdrop then
			self:CreateBackdropShadow(tt.StatusBar)
		end
	end)
end

S:AddCallback("TooltipFrames")
