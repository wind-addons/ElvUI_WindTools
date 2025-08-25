local W, F, E, L = unpack((select(2, ...)))
local TT = E:GetModule("Tooltip")
local S = W.Modules.Skins

local _G = _G
local format = format
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local strfind = strfind
local strsub = strsub
local tonumber = tonumber
local tostring = tostring
local wipe = wipe

local C_Timer_NewTicker = C_Timer.NewTicker

local DEFAULT_SIZE = 64
local CROP_MARGIN = 5
local MARGIN_RATIO = CROP_MARGIN / DEFAULT_SIZE
local DEFAULT_LEFT = CROP_MARGIN
local DEFAULT_RIGHT = DEFAULT_SIZE - CROP_MARGIN
local DEFAULT_TOP = CROP_MARGIN
local DEFAULT_BOTTOM = DEFAULT_SIZE - CROP_MARGIN

local textureStringHistories = {}

local function cacheTextureString(iconData, formattedString)
	textureStringHistories[iconData] = formattedString
	textureStringHistories[formattedString] = formattedString
	return formattedString
end

local function styleIconString(text)
	if not text or not strfind(text, "|T.+|t") then
		return text
	end

	return gsub(text, "|T([^|]+)|t", function(iconData)
		if textureStringHistories[iconData] then
			return textureStringHistories[iconData]
		end

		-- Skip if the id is not valid or the icon may come from other addons
		local colonPos = strfind(iconData, ":")
		local path = colonPos and strsub(iconData, 1, colonPos - 1) or iconData

		if strfind(path, "Addons") or (tonumber(path) and tonumber(path) <= 0) then
			return cacheTextureString(iconData, format("|T%s|t", iconData))
		end

		-- Use the simplest logics for most cases
		-- Case 1: |T<path>|t
		if not colonPos then
			return cacheTextureString(
				iconData,
				format(
					"|T%s:16:16:0:0:%d:%d:%d:%d:%d:%d|t",
					iconData,
					DEFAULT_SIZE,
					DEFAULT_SIZE,
					DEFAULT_LEFT,
					DEFAULT_RIGHT,
					DEFAULT_TOP,
					DEFAULT_BOTTOM
				)
			)
		end

		local remaining = strsub(iconData, colonPos + 1)

		-- Case 2: |T<path>:<height>|t
		local heightNum = tonumber(remaining)
		if heightNum and remaining == tostring(heightNum) then
			return cacheTextureString(
				iconData,
				format(
					"|T%s:%s:%s:0:0:%d:%d:%d:%d:%d:%d|t",
					path,
					remaining,
					remaining,
					DEFAULT_SIZE,
					DEFAULT_SIZE,
					DEFAULT_LEFT,
					DEFAULT_RIGHT,
					DEFAULT_TOP,
					DEFAULT_BOTTOM
				)
			)
		end

		-- Case 3: |T<path>:<height>:<width>|t
		local secondColon = strfind(remaining, ":")
		if secondColon then
			local height = remaining:sub(1, secondColon - 1)
			local restAfterWidth = remaining:sub(secondColon + 1)
			local thirdColon = strfind(restAfterWidth, ":")

			if not thirdColon then
				local heightNum = tonumber(height)
				local widthNum = tonumber(restAfterWidth)
				if
					heightNum
					and widthNum
					and height == tostring(heightNum)
					and restAfterWidth == tostring(widthNum)
				then
					return cacheTextureString(
						iconData,
						format(
							"|T%s:%s:%s:0:0:%d:%d:%d:%d:%d:%d|t",
							path,
							height,
							restAfterWidth,
							DEFAULT_SIZE,
							DEFAULT_SIZE,
							DEFAULT_LEFT,
							DEFAULT_RIGHT,
							DEFAULT_TOP,
							DEFAULT_BOTTOM
						)
					)
				end
			end
		end

		-- Complex cases
		-- Docs: https://warcraft.wiki.gg/wiki/UI_escape_sequences
		local parts = {}
		local pos = 1
		while pos <= #iconData do
			local nextColon = strfind(iconData, ":", pos)
			if nextColon then
				parts[#parts + 1] = strsub(iconData, pos, nextColon - 1)
				pos = nextColon + 1
			else
				parts[#parts + 1] = strsub(iconData, pos)
				break
			end
		end

		-- Extract texture parameters with defaults
		local path = parts[1] or iconData
		local height = parts[2] or "0"
		local width = parts[3] or ""
		local offsetX = parts[4] or "0"
		local offsetY = parts[5] or "0"
		local texWidth = tonumber(parts[6]) or DEFAULT_SIZE
		local texHeight = tonumber(parts[7]) or DEFAULT_SIZE
		local left = tonumber(parts[8])
		local right = tonumber(parts[9])
		local top = tonumber(parts[10])
		local bottom = tonumber(parts[11])
		local r = parts[12] or ""
		local g = parts[13] or ""
		local b = parts[14] or ""

		local alreadyCropped = left and right and top and bottom
		local afterLeft = alreadyCropped and left or texWidth * MARGIN_RATIO
		local afterRight = alreadyCropped and right or texWidth * (1 - MARGIN_RATIO)
		local afterTop = alreadyCropped and top or texHeight * MARGIN_RATIO
		local afterBottom = alreadyCropped and bottom or texHeight * (1 - MARGIN_RATIO)

		local result = format(
			"|T%s:%s:%s:%s:%s:%d:%d:%.0f:%.0f:%.0f:%.0f",
			path,
			height,
			width,
			offsetX,
			offsetY,
			texWidth,
			texHeight,
			afterLeft,
			afterRight,
			afterTop,
			afterBottom
		)

		if r ~= "" and g ~= "" and b ~= "" then
			result = result .. format(":%s:%s:%s", r, g, b)
		end

		return cacheTextureString(iconData, result .. "|t")
	end)
end

local function styleIconsInLine(line, text, skip)
	if not line or skip then
		return
	end

	text = text or line:GetText()
	local styledText = styleIconString(text)
	if styledText and styledText ~= text then
		line:SetText(styledText, true)
	end
end

local function StyleIconsInTooltip(tt)
	if tt:IsForbidden() or not tt.NumLines or not E.db.general.cropIcon then
		return
	end

	for i = 2, tt:NumLines() do
		styleIconsInLine(_G[tt:GetName() .. "TextLeft" .. i])
		styleIconsInLine(_G[tt:GetName() .. "TextRight" .. i])
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
		if frame.Text and not frame.Text.__windSkin then
			hooksecurefunc(frame.Text, "SetText", styleIconsInLine)
			F.SetFontOutline(frame.Text)
			frame.Text:SetText(frame.Text:GetText())
			frame.Text.__windSkin = true
		end
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

	StyleTooltipWidgetContainer(tt)

	if tt.Show then
		hooksecurefunc(tt, "Show", StyleIconsInTooltip)
	end
end

function S:TooltipFrames()
	if not self:CheckDB("tooltip", "tooltips") then
		return
	end

	C_Timer_NewTicker(60, function()
		wipe(textureStringHistories)
	end)

	-- Blizzard Tooltips
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
