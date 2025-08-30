local W ---@class WindTools
local F ---@type Functions
W, F = unpack((select(2, ...)))

---@class ColorUtility Color manipulation and conversion utilities
W.Utilities.Color = {}

local format = format
local strsub = strsub
local tonumber = tonumber
local tostring = tostring
local type = type

local CreateColor = CreateColor

---@type table<string, string> Predefined color hex values
local colors = {
	greyLight = "b5b5b5",
	primary = "00d1b2",
	success = "48c774",
	link = "3273dc",
	info = "209cee",
	danger = "ff3860",
	warning = "ffdd57",
}

---Get hex color for keystone level
---@param level number The keystone level
---@return string hex The hex color code
local function keyStoneLevelHex(level)
	if level < 4 then
		return "ffffff"
	elseif level < 7 then
		return "1eff00"
	elseif level < 10 then
		return "0070dd"
	elseif level < 12 then
		return "a335ee"
	else
		return "ff8000"
	end
end

---Create a ColorMixin object from a color table
---@param colorTable table Color table with r, g, b, a values
---@return ColorMixin color The created color object
function W.Utilities.Color.CreateColorFromTable(colorTable)
	return CreateColor(colorTable.r, colorTable.g, colorTable.b, colorTable.a)
end

---Get RGB values from predefined color template
---@param template string The color template name
---@return number r Red component (0-1)
---@return number g Green component (0-1)
---@return number b Blue component (0-1)
function W.Utilities.Color.RGBFromTemplate(template)
	return W.Utilities.Color.HexToRGB(colors[template])
end

---Extract RGBA values from color table with optional overrides
---@param colorTable table Base color table
---@param override table? Optional override values
---@return number r Red component (0-1)
---@return number g Green component (0-1)
---@return number b Blue component (0-1)
---@return number a Alpha component (0-1)
function W.Utilities.Color.ExtractColorFromTable(colorTable, override)
	local r = override and override.r or colorTable.r or 1
	local g = override and override.g or colorTable.g or 1
	local b = override and override.b or colorTable.b or 1
	local a = override and override.a or colorTable.a or 1
	return r, g, b, a
end

---Check if two RGB color tables are approximately equal
---@param c1 table First color table
---@param c2 table Second color table
---@return boolean equal True if colors are approximately equal
function W.Utilities.Color.IsRGBEqual(c1, c2)
	return F.IsAlmost(c1.r, c2.r) and F.IsAlmost(c1.g, c2.g) and F.IsAlmost(c1.b, c2.b)
end

---Convert hex color to RGB values
---@param hex string Hex color string (with or without #)
---@return number r Red component (0-1)
---@return number g Green component (0-1)
---@return number b Blue component (0-1)
function W.Utilities.Color.HexToRGB(hex)
	if strsub(hex, 1, 1) == "#" then
		hex = strsub(hex, 2)
	end
	local rhex, ghex, bhex = strsub(hex, 1, 2), strsub(hex, 3, 4), strsub(hex, 5, 6)
	return tonumber(rhex, 16) / 255, tonumber(ghex, 16) / 255, tonumber(bhex, 16) / 255
end

---Convert RGB values to hex color string
---@param r number Red component (0-1)
---@param g number Green component (0-1)
---@param b number Blue component (0-1)
---@return string hex Hex color string without #
function W.Utilities.Color.RGBToHex(r, g, b)
	return format("%02x%02x%02x", r * 255, g * 255, b * 255)
end

---Create colored string with hex color
---@param text string The text to colorize
---@param color string Hex color code
---@return string coloredText The colored string
function W.Utilities.Color.StringWithHex(text, color)
	return format("|cff%s%s|r", color, text)
end

---Create colored string using predefined template
---@param text string The text to colorize
---@param template string The color template name
---@return string coloredText The colored string
function W.Utilities.Color.StringByTemplate(text, template)
	return W.Utilities.Color.StringWithHex(text, colors[template])
end

---Create colored string with RGB values
---@param text any The text to colorize (will be converted to string)
---@param r number|table Red component (0-1)
---@param g number? Green component (0-1)
---@param b number? Blue component (0-1)
---@return string coloredText The colored string
function W.Utilities.Color.StringWithRGB(text, r, g, b)
	if type(text) ~= "string" then
		text = tostring(text)
	end

	if type(r) == "table" then
		r, g, b = r.r, r.g, r.b
	end

	return W.Utilities.Color.StringWithHex(text, W.Utilities.Color.RGBToHex(r, g, b))
end

---Create colored string based on keystone level
---@param text string The text to colorize
---@param level number The keystone level
---@return string coloredText The colored string with level-appropriate color
function W.Utilities.Color.StringWithKeystoneLevel(text, level)
	return W.Utilities.Color.StringWithHex(text, keyStoneLevelHex(level))
end
