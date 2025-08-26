local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local format = format
local gsub = gsub
local pairs = pairs
local strfind = strfind
local strsub = strsub
local time = time
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
local CACHE_TIMEOUT = 300

C_Timer_NewTicker(60, function()
	local currentTime = time()
	for key, data in pairs(textureStringHistories) do
		if type(data) == "table" and data.timestamp and (currentTime - data.timestamp) > CACHE_TIMEOUT then
			textureStringHistories[key] = nil
		end
	end
end)

local function cacheTextureString(iconData, formattedString)
	local currentTime = time()
	local result = format("|T%s|t", formattedString)
	local cacheData = {
		value = result,
		timestamp = currentTime,
	}

	textureStringHistories[iconData] = cacheData
	if iconData ~= formattedString then
		textureStringHistories[formattedString] = cacheData
	end

	return result
end

function S:StyleTextureString(text)
	if not text or not strfind(text, "|T.+|t") then
		return text
	end

	return gsub(text, "|T([^|]+)|t", function(iconData)
		local cachedData = textureStringHistories[iconData]
		if cachedData and cachedData.value then
			return cachedData.value
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

		local alreadyCropped = left and right and top and bottom
		local afterLeft = alreadyCropped and left or texWidth * MARGIN_RATIO
		local afterRight = alreadyCropped and right or texWidth * (1 - MARGIN_RATIO)
		local afterTop = alreadyCropped and top or texHeight * MARGIN_RATIO
		local afterBottom = alreadyCropped and bottom or texHeight * (1 - MARGIN_RATIO)

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
