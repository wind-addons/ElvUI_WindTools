local W ---@type WindTools
local F ---@class Functions
local E ---@type ElvUI
W, F, E = unpack((select(2, ...)))
local LSM = E.Libs.LSM

local _G = _G
local abs = abs
local coroutine = coroutine
local format = format
local min = min
local pairs = pairs
local pcall = pcall
local print = print
local strfind = strfind
local strmatch = strmatch
local tonumber = tonumber
local tostring = tostring
local tremove = tremove
local type = type
local unpack = unpack

local GetClassColor = GetClassColor

---@cast F Functions

---Set font style from database settings
---@param text FontString The FontString object to modify
---@param db table Font style database containing name, size, and style
function F.SetFontWithDB(text, db)
	if not text or not text.GetFont then
		F.Developer.LogDebug("Functions.SetFontWithDB: text not found")
		return
	end

	if not db or type(db) ~= "table" then
		F.Developer.LogDebug("Functions.SetFontWithDB: db not found")
		return
	end

	local fontName, fontHeight = text:GetFont()

	text:FontTemplate(db.name and LSM:Fetch("font", db.name) or fontName, db.size or fontHeight, db.style or "NONE")
end

---Set font color from database settings
---@param text FontString The FontString object to modify
---@param db table Font color database containing r, g, b, a values
function F.SetFontColorWithDB(text, db)
	if not text or not text.GetFont then
		F.Developer.LogDebug("Functions.SetFontColorWithDB: text not found")
		return
	end
	if not db or type(db) ~= "table" then
		F.Developer.LogDebug("Functions.SetFontColorWithDB: db not found")
		return
	end

	text:SetTextColor(db.r, db.g, db.b, db.a)
end

---Change font outline style to OUTLINE and remove shadow
---@param text FontString The FontString object to modify
---@param font string? Font path or name (optional)
---@param size number|string? Font size or size change amount as string (optional)
function F.SetFontOutline(text, font, size)
	if not text or not text.GetFont then
		F.Developer.LogDebug("Functions.SetFontOutline: text not found")
		return
	end
	local fontName, fontHeight = text:GetFont()

	if size and type(size) == "string" then
		size = fontHeight + tonumber(size)
	end

	if font and not strfind(font, "%.ttf") and not strfind(font, "%.otf") then
		font = LSM:Fetch("font", font)
	end

	text:FontTemplate(font or fontName, size or fontHeight, "OUTLINE")
	text:SetShadowColor(0, 0, 0, 0)
	text.SetShadowColor = E.noop
end

---Create colored string from database settings
---@param text string The text to colorize
---@param db table Color database containing r, g, b values
---@return string? coloredText The colored string or nil if parameters are invalid
function F.CreateColorString(text, db)
	if not text or not type(text) == "string" then
		F.Developer.LogDebug("Functions.CreateColorString: text not found")
		return
	end

	if not db or type(db) ~= "table" then
		F.Developer.LogDebug("Functions.CreateColorString: db not found")
		return
	end

	local hex = db.r and db.g and db.b and E:RGBToHex(db.r, db.g, db.b) or "|cffffffff"

	return hex .. text .. "|r"
end

---Create class colored string
---@param text string The text to colorize
---@param classFile ClassFile? The English class name (e.g., "WARRIOR", "MAGE")
---@return string? coloredText The class colored string or nil if parameters are invalid
function F.CreateClassColorString(text, classFile)
	if not text or not type(text) == "string" then
		F.Developer.LogDebug("Functions.CreateClassColorString: text not found")
		return
	end

	if not classFile or type(classFile) ~= "string" then
		F.Developer.LogDebug("Functions.CreateClassColorString: class not found")
		return
	end

	local r, g, b = GetClassColor(classFile)
	local hex = r and g and b and E:RGBToHex(r, g, b) or "|cffffffff"

	return hex .. text .. "|r"
end

---Set font outline for all FontString regions in a frame
---@param frame Frame The frame containing FontString regions
---@param font string? Font path or name (optional)
---@param size number|string? Font size or size change amount as string (optional)
function F.SetFrameFontOutline(frame, font, size)
	if not frame or not frame.GetRegions then
		F.Developer.LogDebug("Functions.SetFrameFontOutline: frame not found")
		return
	end
	for _, region in pairs({ frame:GetRegions() }) do
		if region:IsObjectType("FontString") then
			F.SetFontOutline(region --[[@as FontString]], font, size)
		end
	end
end

---Print a gradient colored line separator
function F.PrintGradientLine()
	local HexToRGB = W.Utilities.Color.HexToRGB
	local r1, g1, b1 = HexToRGB("f0772f")
	local r2, g2, b2 = HexToRGB("f34a62")
	local r3, g3, b3 = HexToRGB("bb77ed")
	local r4, g4, b4 = HexToRGB("1cdce8")

	local gradientLine =
		E:TextGradient("----------------------------------", r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4)
	print(gradientLine)
end

---Print message with WindTools title prefix
---@param text string? The text to print
function F.Print(text)
	if not text then
		return
	end

	local message = format("%s: %s", W.Title, text)
	print(message)
end

---Delay unhook all hooks from a module
---@param module table|string Ace3 module object or module name string
function F.DelayUnhookAll(module)
	if type(module) == "string" then
		module = W:GetModule(module)
	end

	if module then
		if module.UnhookAll then
			E:Delay(1, module.UnhookAll, module)
		else
			F.Developer.LogDebug("Functions.DelayUnhookAll: AceHook class not found!")
		end
	else
		F.Developer.LogDebug("Functions.DelayUnhookAll: Module not found!")
	end
end

---Round a number to specified decimal places
---@param number number The number to round
---@param decimals number Number of decimal places
---@return string roundedNumber The rounded number as string
function F.Round(number, decimals)
	return format(format("%%.%df", decimals), number)
end

---Set callback with retry mechanism
---@param callback function The callback function to execute with results
---@param target function The target function to call
---@param times number? Current retry count (internal use)
---@param ... any Arguments to pass to target function
function F.SetCallback(callback, target, times, ...)
	times = times or 0
	if times >= 10 then
		return
	end

	if times < 10 then
		local result = { pcall(target, ...) }
		if result and result[1] == true then
			tremove(result, 1)
			if callback(unpack(result)) then
				return
			end
		end
	end

	E:Delay(0.1, F.SetCallback, callback, target, times + 1, ...)
end

do
	---@type string Pattern to extract item level from tooltip text
	local pattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)")
	---Get real item level from item link by scanning tooltip
	---@param link string The item link
	---@return string? itemLevel The item level or nil if not found
	function F.GetRealItemLevelByLink(link)
		E.ScanTooltip:SetOwner(_G.UIParent, "ANCHOR_NONE")
		E.ScanTooltip:ClearLines()
		E.ScanTooltip:SetHyperlink(link)

		for i = 2, 5 do
			local leftText = _G[E.ScanTooltip:GetName() .. "TextLeft" .. i]
			if leftText then
				local text = leftText:GetText() or ""
				local level = strmatch(text, pattern)
				if level then
					return level
				end
			end
		end
	end
end

do
	---Color configuration for progress bar
	---@type table
	local color = {
		start = {
			r = 1.000,
			g = 0.647,
			b = 0.008,
		},
		complete = {
			r = 0.180,
			g = 0.835,
			b = 0.451,
		},
	}

	---Get color based on progress value (0.0 to 1.0)
	---@param progress number Progress value between 0 and 1
	---@return table color Color table with r, g, b values
	function F.GetProgressColor(progress)
		local r = (color.complete.r - color.start.r) * progress + color.start.r
		local g = (color.complete.g - color.start.g) * progress + color.start.g
		local b = (color.complete.r - color.start.b) * progress + color.start.b

		-- algorithm to let the color brighter
		local addition = 0.35
		r = min(r + abs(0.5 - progress) * addition, r)
		g = min(g + abs(0.5 - progress) * addition, g)
		b = min(b + abs(0.5 - progress) * addition, b)

		return { r = r, g = g, b = b }
	end
end

---Set vertex color for texture from database settings
---@param tex Texture The texture object to modify
---@param db table Color database containing r, g, b, a values
function F.SetVertexColorWithDB(tex, db)
	if not tex or not tex.GetVertexColor then
		F.Developer.LogDebug("Functions.SetVertexColorWithDB: No texture to handling")
		return
	end

	if not db or type(db) ~= "table" then
		F.Developer.LogDebug("Functions.SetVertexColorWithDB: No texture color database")
		return
	end

	tex:SetVertexColor(db.r, db.g, db.b, db.a)
end

---Create WindTools styled gradient text
---@param text string The text to apply gradient to
---@return string gradientText The gradient styled text
function F.GetWindStyleText(text)
	return E:TextGradient(text, 0.32941, 0.52157, 0.93333, 0.29020, 0.70980, 0.89412, 0.25882, 0.84314, 0.86667)
end

---Check if value is NaN (Not a Number)
---@param val any The value to check
---@return boolean isNaN True if value is NaN
function F.IsNaN(val)
	return tostring(val) == tostring(0 / 0)
end

---Return value or default if value is nil or NaN
---@param val any The value to check
---@param default any The default value to return if val is invalid
---@return any result The original value or default
function F.Or(val, default)
	if not val or F.IsNaN(val) then
		return default
	end
	return val
end

---@type table<any, table> Throttle states storage
local throttleStates = {}

---Throttle function execution to prevent excessive calls
---@param duration number Duration in seconds to throttle
---@param key any? Unique key for throttling (optional, defaults to function)
---@param func function The function to throttle
---@param ... any Arguments to pass to the function
function F.Throttle(duration, key, func, ...)
	if type(duration) ~= "number" or duration <= 0 then
		F.Developer.ThrowError("Invalid duration for F.Throttle: must be a positive number")
	end

	if type(func) ~= "function" then
		F.Developer.ThrowError("Invalid function for F.Throttle: third argument must be a function")
	end

	local finalKey = key ~= nil and key or func
	local state = throttleStates[finalKey]

	if not state then
		state = {
			isThrottling = false,
			timer = nil,
			lastArgs = { ... },
		}
		throttleStates[finalKey] = state
	else
		state.lastArgs = { ... }

		if state.isThrottling then
			return
		end
	end

	state.isThrottling = true

	if state.timer then
		state.timer:Cancel()
		state.timer = nil
	end

	state.timer = E:Delay(duration, function()
		func(unpack(state.lastArgs))
		state.isThrottling = false
		state.timer = nil
	end)
end

---Wait for condition to be true, then execute callback
---@param condition function Function that returns boolean when condition is met
---@param callback function Function to execute when condition is true
---@param interval number? Check interval in seconds (default: 0.1)
---@param maxTimes number? Maximum number of checks (default: 10)
function F.WaitFor(condition, callback, interval, maxTimes)
	interval = interval or 0.1
	maxTimes = maxTimes or 10

	local co = coroutine.create(function()
		local leftTimes = maxTimes

		while leftTimes > 0 do
			if condition() then
				callback()
				return
			end

			leftTimes = leftTimes - 1
			if leftTimes <= 0 then
				break
			end

			coroutine.yield(interval)
		end
	end)

	local function resumeCoroutine()
		local success, delay = coroutine.resume(co)
		if not success then
			F.Developer.ThrowError("WaitFor coroutine error:", tostring(delay))
			return
		end
		if coroutine.status(co) ~= "dead" then
			E:Delay(delay, resumeCoroutine)
		end
	end

	resumeCoroutine()
end

---Move frame by offset while preserving all anchor points
---@param frame any The frame to move
---@param x number X offset to apply
---@param y number Y offset to apply
function F.Move(frame, x, y)
	if not frame or not frame.ClearAllPoints then
		return
	end

	local setPoint = frame.__SetPoint or frame.SetPoint

	---@type table[] Store all current anchor points
	local pointsData = {}

	for i = 1, frame:GetNumPoints() do
		local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(i)
		pointsData[i] = { point, relativeTo, relativePoint, xOfs, yOfs }
	end

	frame:ClearAllPoints()

	for _, data in pairs(pointsData) do
		local point, relativeTo, relativePoint, xOfs, yOfs = unpack(data)
		setPoint(frame, point, relativeTo, relativePoint, xOfs + x, yOfs + y)
	end
end

---Check if two numbers are approximately equal
---@param a? number|number[] First number or array of numbers
---@param b? number|number[] Second number or array of numbers
---@param allowance number? Allowed difference (default: 0.025)
---@return boolean equal True if numbers are approximately equal
function F.IsAlmost(a, b, allowance)
	if a == b then
		return true
	end

	if a == nil or b == nil then
		return false
	end

	allowance = allowance or 0.025

	if type(a) == "table" and type(b) == "table" then
		local len = #a
		if len ~= #b then
			return false
		end

		for i = 1, len do
			if not F.IsAlmost(a[i], b[i], allowance) then
				return false
			end
		end

		return true
	end

	return abs(a - b) < allowance
end

---Internalizes a method by creating a backup copy with a double underscore prefix.
---This function is commonly used to preserve original method implementations before
---overriding them with custom behavior. The original method is stored as "__methodName"
---and can optionally be replaced with a no-operation function.
---@param frame any The frame object that contains the method to be internalized
---@param methodKey any The name of the method to create an internal backup for
---@param override boolean? If true, replaces the original method with E.noop function
function F.InternalizeMethod(frame, methodKey, override)
	local internalMethodKey = "__" .. methodKey
	if frame[internalMethodKey] or not frame[methodKey] then
		return
	end

	frame[internalMethodKey] = frame[methodKey]
	if override then
		frame[methodKey] = E.noop
	end
end

--- Checks if a method has been internalized on a frame object
--- @param frame table|nil The frame object to check for the internalized method
--- @param methodKey string The name of the method to check for internalization
--- @return boolean True if the frame has an internalized version of the method, false otherwise
function F.IsMethodInternalized(frame, methodKey)
	local internalMethodKey = "__" .. methodKey
	return frame and frame[internalMethodKey] ~= nil or false
end

---Safely calls a method on a frame object, with fallback support for internal method variants.
---This function first attempts to call an internal version of the method (prefixed with "__"),
---and if that doesn't exist, falls back to calling the standard method name.
---@param frame any The frame object that contains the method to be called
---@param methodKey string The name of the method to call (without any prefixes)
---@param ... any Variable arguments that will be passed to the called method
function F.CallMethod(frame, methodKey, ...)
	local internalMethodKey = "__" .. methodKey
	if frame[internalMethodKey] then
		return frame[internalMethodKey](frame, ...)
	end

	return frame[methodKey](frame, ...)
end
