local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@class Skins
local cache = W.Utilities.Cache

local format = format
local gsub = gsub
local strfind = strfind
local strsub = strsub
local tonumber = tonumber
local tostring = tostring

local DEFAULT_SIZE = 64
local CROP_MARGIN = 5
local MARGIN_RATIO = CROP_MARGIN / DEFAULT_SIZE
local DEFAULT_LEFT = CROP_MARGIN
local DEFAULT_RIGHT = DEFAULT_SIZE - CROP_MARGIN
local DEFAULT_TOP = CROP_MARGIN
local DEFAULT_BOTTOM = DEFAULT_SIZE - CROP_MARGIN

---@type Cache
local textureStringCache = cache.New({
	defaultTTL = 300, -- 5 minutes
	maxLength = nil,
	autoCleanup = true,
	cleanupInterval = 60,
})

local function cacheTextureString(iconData, formattedString)
	local result = format("|T%s|t", formattedString)

	-- Cache both the iconData and formattedString keys to the same result
	textureStringCache:Set(iconData, result)
	if iconData ~= formattedString then
		textureStringCache:Set(formattedString, result)
	end

	return result
end

function S:StyleTextureString(text)
	if not text or not strfind(text, "|T.+|t") then
		return text
	end

	return gsub(text, "|T([^|]+)|t", function(iconData)
		local cachedValue = textureStringCache:Get(iconData)
		if cachedValue then
			return cachedValue
		end

		-- Skip if the id is not valid or the icon may come from other addons
		local colonPos = strfind(iconData, ":")
		local path = colonPos and strsub(iconData, 1, colonPos - 1) or iconData

		if strfind(path, "Addons") or (tonumber(path) and tonumber(path) <= 0) then
			return cacheTextureString(iconData, iconData)
		end

		-- Use the simplest logics for most cases
		-- Case 1: |T<path>|t
		if not colonPos then
			return cacheTextureString(
				iconData,
				format(
					"%s:16:16:0:0:%d:%d:%d:%d:%d:%d",
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
					"%s:%s:%s:0:0:%d:%d:%d:%d:%d:%d",
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
				local heightValue = tonumber(height)
				local widthNum = tonumber(restAfterWidth)
				if
					heightValue
					and widthNum
					and height == tostring(heightValue)
					and restAfterWidth == tostring(widthNum)
				then
					return cacheTextureString(
						iconData,
						format(
							"%s:%s:%s:0:0:%d:%d:%d:%d:%d:%d",
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
		local texturePath = parts[1] or iconData
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

		-- Check if already cropped and not showing the full texture
		local alreadyCropped = left and right and top and bottom
		local showingFullTexture = alreadyCropped
			and (left == 0 and right == texWidth and top == 0 and bottom == texHeight and texWidth == texHeight)
		local shouldApplyCropping = not alreadyCropped or showingFullTexture

		local afterLeft = shouldApplyCropping and (texWidth * MARGIN_RATIO) or left
		local afterRight = shouldApplyCropping and (texWidth * (1 - MARGIN_RATIO)) or right
		local afterTop = shouldApplyCropping and (texHeight * MARGIN_RATIO) or top
		local afterBottom = shouldApplyCropping and (texHeight * (1 - MARGIN_RATIO)) or bottom

		local result = format(
			"%s:%s:%s:%s:%s:%d:%d:%.0f:%.0f:%.0f:%.0f",
			texturePath,
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

		return cacheTextureString(iconData, result)
	end)
end
