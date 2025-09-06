local W ---@class WindTools
local F ---@type Functions
W, F = unpack((select(2, ...)))

local format = format
local math = math
local strsub = strsub
local tonumber = tonumber
local tostring = tostring
local type = type

local CreateColor = CreateColor

---@cast F Functions

---@class ColorUtility Color manipulation and conversion utilities
W.Utilities.Color = {}

---Tailwind Colors v4.1 https://tailwindcss.com/docs/colors
---Convert Script: https://github.com/wind-addons/WindToolsScripts/blob/master/CSSToRGB
---@type table<string, string> Predefined color hex values
local colors = {
	["red-50"] = "fef2f2",
	["red-100"] = "fee1e1",
	["red-200"] = "ffc8c8",
	["red-300"] = "ffa0a0",
	["red-400"] = "ff6366",
	["red-500"] = "fa2f39",
	["red-600"] = "e60012",
	["red-700"] = "bf000f",
	["red-800"] = "9d0f18",
	["red-900"] = "801d1f",
	["red-950"] = "471011",
	["orange-50"] = "fff6ec",
	["orange-100"] = "ffecd3",
	["orange-200"] = "ffd5a6",
	["orange-300"] = "ffb669",
	["orange-400"] = "ff870b",
	["orange-500"] = "ff6800",
	["orange-600"] = "f44a00",
	["orange-700"] = "c83700",
	["orange-800"] = "9d3000",
	["orange-900"] = "7d2e13",
	["orange-950"] = "45190e",
	["amber-50"] = "fffae9",
	["amber-100"] = "fef2c4",
	["amber-200"] = "fde584",
	["amber-300"] = "ffd033",
	["amber-400"] = "ffb800",
	["amber-500"] = "fd9800",
	["amber-600"] = "e07000",
	["amber-700"] = "b94d00",
	["amber-800"] = "953e00",
	["amber-900"] = "79360e",
	["amber-950"] = "471f06",
	["yellow-50"] = "fdfbe7",
	["yellow-100"] = "fef8c0",
	["yellow-200"] = "feef84",
	["yellow-300"] = "ffde25",
	["yellow-400"] = "fdc600",
	["yellow-500"] = "efaf00",
	["yellow-600"] = "cf8500",
	["yellow-700"] = "a45f00",
	["yellow-800"] = "874b00",
	["yellow-900"] = "724012",
	["yellow-950"] = "44240c",
	["lime-50"] = "f6fee6",
	["lime-100"] = "ebfcc9",
	["lime-200"] = "d7f997",
	["lime-300"] = "b9f351",
	["lime-400"] = "98e500",
	["lime-500"] = "7bcd00",
	["lime-600"] = "5ea300",
	["lime-700"] = "4a7c00",
	["lime-800"] = "3e6200",
	["lime-900"] = "375415",
	["lime-950"] = "1f310a",
	["green-50"] = "effcf3",
	["green-100"] = "dafbe5",
	["green-200"] = "b7f7cd",
	["green-300"] = "79f0a6",
	["green-400"] = "0dde71",
	["green-500"] = "00c751",
	["green-600"] = "00a43f",
	["green-700"] = "008138",
	["green-800"] = "076633",
	["green-900"] = "14542f",
	["green-950"] = "0a311b",
	["emerald-50"] = "ebfcf4",
	["emerald-100"] = "cef9e3",
	["emerald-200"] = "a2f3ce",
	["emerald-300"] = "5ee8b3",
	["emerald-400"] = "00d390",
	["emerald-500"] = "00ba7b",
	["emerald-600"] = "009765",
	["emerald-700"] = "007955",
	["emerald-800"] = "006046",
	["emerald-900"] = "004f3d",
	["emerald-950"] = "003026",
	["teal-50"] = "effdf9",
	["teal-100"] = "c9fbf0",
	["teal-200"] = "94f6e3",
	["teal-300"] = "47ebd3",
	["teal-400"] = "00d3bc",
	["teal-500"] = "00b9a5",
	["teal-600"] = "009487",
	["teal-700"] = "00766e",
	["teal-800"] = "005f5a",
	["teal-900"] = "124f4b",
	["teal-950"] = "083231",
	["cyan-50"] = "ebfdfe",
	["cyan-100"] = "cdf9fe",
	["cyan-200"] = "a0f3fc",
	["cyan-300"] = "54e9fc",
	["cyan-400"] = "00d1f2",
	["cyan-500"] = "00b6d9",
	["cyan-600"] = "0091b6",
	["cyan-700"] = "007493",
	["cyan-800"] = "005e77",
	["cyan-900"] = "174f64",
	["cyan-950"] = "0d3646",
	["sky-50"] = "eff8ff",
	["sky-100"] = "def1fe",
	["sky-200"] = "b6e5fe",
	["sky-300"] = "72d2ff",
	["sky-400"] = "00baff",
	["sky-500"] = "00a4f3",
	["sky-600"] = "0083cf",
	["sky-700"] = "0068a6",
	["sky-800"] = "005988",
	["sky-900"] = "084b6f",
	["sky-950"] = "0d324b",
	["blue-50"] = "eef5fe",
	["blue-100"] = "d9e9fe",
	["blue-200"] = "bcd9ff",
	["blue-300"] = "8cc3ff",
	["blue-400"] = "51a0ff",
	["blue-500"] = "2f7eff",
	["blue-600"] = "1b5dfb",
	["blue-700"] = "1a48e5",
	["blue-800"] = "1f3eb6",
	["blue-900"] = "213b8c",
	["blue-950"] = "1c2956",
	["indigo-50"] = "edf1ff",
	["indigo-100"] = "dfe6ff",
	["indigo-200"] = "c5d0ff",
	["indigo-300"] = "a1b1ff",
	["indigo-400"] = "7b85ff",
	["indigo-500"] = "615fff",
	["indigo-600"] = "503bf6",
	["indigo-700"] = "4530d6",
	["indigo-800"] = "392daa",
	["indigo-900"] = "342f84",
	["indigo-950"] = "23204d",
	["violet-50"] = "f4f2fe",
	["violet-100"] = "ece8fe",
	["violet-200"] = "dcd4ff",
	["violet-300"] = "c3b2ff",
	["violet-400"] = "a482ff",
	["violet-500"] = "8c52ff",
	["violet-600"] = "7e27fd",
	["violet-700"] = "6f10e6",
	["violet-800"] = "5d15be",
	["violet-900"] = "4e1d98",
	["violet-950"] = "321467",
	["purple-50"] = "f9f4fe",
	["purple-100"] = "f2e7fe",
	["purple-200"] = "e8d3ff",
	["purple-300"] = "d8b0ff",
	["purple-400"] = "c079ff",
	["purple-500"] = "ab47ff",
	["purple-600"] = "9617fa",
	["purple-700"] = "8100d9",
	["purple-800"] = "6d18ae",
	["purple-900"] = "591c89",
	["purple-950"] = "3e0a66",
	["fuchsia-50"] = "fcf3fe",
	["fuchsia-100"] = "fae7ff",
	["fuchsia-200"] = "f5ceff",
	["fuchsia-300"] = "f3a6ff",
	["fuchsia-400"] = "ec6aff",
	["fuchsia-500"] = "e02efa",
	["fuchsia-600"] = "c600dd",
	["fuchsia-700"] = "a600b5",
	["fuchsia-800"] = "880793",
	["fuchsia-900"] = "711a76",
	["fuchsia-950"] = "4c0450",
	["pink-50"] = "fcf1f7",
	["pink-100"] = "fce6f2",
	["pink-200"] = "fbcde7",
	["pink-300"] = "fda3d4",
	["pink-400"] = "fb63b4",
	["pink-500"] = "f53598",
	["pink-600"] = "e50075",
	["pink-700"] = "c5005b",
	["pink-800"] = "a1004d",
	["pink-900"] = "841744",
	["pink-950"] = "520b28",
	["rose-50"] = "fef0f1",
	["rose-100"] = "ffe3e5",
	["rose-200"] = "ffcbd1",
	["rose-300"] = "ff9fab",
	["rose-400"] = "ff637d",
	["rose-500"] = "ff2457",
	["rose-600"] = "eb0041",
	["rose-700"] = "c50038",
	["rose-800"] = "a30038",
	["rose-900"] = "891038",
	["rose-950"] = "4e091e",
	["slate-50"] = "f7f9fb",
	["slate-100"] = "f0f4f8",
	["slate-200"] = "e1e7ef",
	["slate-300"] = "c8d4e1",
	["slate-400"] = "8e9fb7",
	["slate-500"] = "61738c",
	["slate-600"] = "46556b",
	["slate-700"] = "344358",
	["slate-800"] = "222c3f",
	["slate-900"] = "161d2e",
	["slate-950"] = "080e1d",
	["gray-50"] = "f8f9fb",
	["gray-100"] = "f2f3f5",
	["gray-200"] = "e4e6ea",
	["gray-300"] = "cfd4da",
	["gray-400"] = "979fad",
	["gray-500"] = "697181",
	["gray-600"] = "4b5564",
	["gray-700"] = "384353",
	["gray-800"] = "232d3b",
	["gray-900"] = "171e2c",
	["gray-950"] = "0a0f19",
	["zinc-50"] = "f9f9f9",
	["zinc-100"] = "f3f3f4",
	["zinc-200"] = "e3e3e6",
	["zinc-300"] = "d2d2d7",
	["zinc-400"] = "9d9da7",
	["zinc-500"] = "70707a",
	["zinc-600"] = "52525c",
	["zinc-700"] = "414148",
	["zinc-800"] = "2b2b2e",
	["zinc-900"] = "1e1e20",
	["zinc-950"] = "111113",
	["neutral-50"] = "f9f9f9",
	["neutral-100"] = "f4f4f4",
	["neutral-200"] = "e4e4e4",
	["neutral-300"] = "d2d2d2",
	["neutral-400"] = "9f9f9f",
	["neutral-500"] = "727272",
	["neutral-600"] = "525252",
	["neutral-700"] = "414141",
	["neutral-800"] = "2a2a2a",
	["neutral-900"] = "1d1d1d",
	["neutral-950"] = "121212",
	["stone-50"] = "f9f9f9",
	["stone-100"] = "f4f4f3",
	["stone-200"] = "e6e4e2",
	["stone-300"] = "d5d1cf",
	["stone-400"] = "a49e99",
	["stone-500"] = "77706a",
	["stone-600"] = "57534e",
	["stone-700"] = "46413d",
	["stone-800"] = "2d2928",
	["stone-900"] = "211f1d",
	["stone-950"] = "131211",
}

--- Clamps a value between 0 and 1 (inclusive).
--- This function ensures that any input value is constrained to the valid range
--- for color components or other normalized values.
--- @param value number The input value to be clamped
--- @return number The clamped value, guaranteed to be between 0 and 1
local function clamp(value)
	return math.max(0, math.min(1, value))
end

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
function W.Utilities.Color.ExtractRGBFromTemplate(template)
	local color = colors[template]
	if not color then
		F.Developer.LogDebug("Color template not found: " .. tostring(template))
		return 1, 1, 1
	end

	return W.Utilities.Color.HexToRGB(color)
end

---Get RGBA values from predefined color template
---@param template string The color template name
---@return number r Red component (0-1)
---@return number g Green component (0-1)
---@return number b Blue component (0-1)
---@return number a Alpha component (0-1)
function W.Utilities.Color.ExtractRGBAFromTemplate(template)
	local r, g, b = W.Utilities.Color.ExtractRGBFromTemplate(template)
	return r, g, b, 1
end

---Get RGB values from predefined color template
---@param template string The color template name
---@return RGB color The RGB color object
function W.Utilities.Color.GetRGBFromTemplate(template)
	local r, g, b = W.Utilities.Color.ExtractRGBFromTemplate(template)
	return { r = r, g = g, b = b }
end

---Get RGBA values from predefined color template
---@param template string The color template name
---@return RGBA color The RGBA color object
function W.Utilities.Color.GetRGBAFromTemplate(template)
	local r, g, b = W.Utilities.Color.ExtractRGBFromTemplate(template)
	return { r = r, g = g, b = b, a = 1 }
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
	return F.IsAlmost({ c1.r, c1.g, c1.b }, { c2.r, c2.g, c2.b }, 0.005)
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
	local color = colors[template]
	if not color then
		F.Developer.LogDebug("Color template not found: " .. tostring(template))
		return text
	end

	return W.Utilities.Color.StringWithHex(text, color)
end

---Create colored string with RGB values
---@param text any The text to colorize (will be converted to string)
---@param r number|table Red component (0-1) or color table with r,g,b fields
---@param g number? Green component (0-1, required if r is number)
---@param b number? Blue component (0-1, required if r is number)
---@return string coloredText The colored string
function W.Utilities.Color.StringWithRGB(text, r, g, b)
	if text == nil then
		F.Developer.LogDebug("Text parameter cannot be nil")
		return ""
	end
	if type(text) ~= "string" then
		text = tostring(text)
	end

	if type(r) == "table" then
		if type(r.r) ~= "number" or type(r.g) ~= "number" or type(r.b) ~= "number" then
			F.Developer.LogDebug("Color table must contain r, g, b numeric values")
		end
		g = r.g
		b = r.b
		r = r.r
	else
		if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
			F.Developer.LogDebug("RGB values must be numbers when not using a color table")
		end
	end

	---@diagnostic disable-next-line: param-type-mismatch -- The above logic already ensures types are correct
	r, g, b = clamp(r), clamp(g), clamp(b)

	return W.Utilities.Color.StringWithHex(text, W.Utilities.Color.RGBToHex(r, g, b))
end

---Create colored string based on keystone level
---@param text string The text to colorize
---@param level number The keystone level
---@return string coloredText The colored string with level-appropriate color
function W.Utilities.Color.StringWithKeystoneLevel(text, level)
	return W.Utilities.Color.StringWithHex(text, keyStoneLevelHex(level))
end
