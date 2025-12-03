local W ---@type WindTools
local F ---@class Functions
local E ---@type ElvUI
W, F, E = unpack((select(2, ...)))
local LSM = E.Libs.LSM

local abs = abs
local assert = assert
local coroutine = coroutine
local format = format
local getmetatable = getmetatable
local min = min
local pairs = pairs
local pcall = pcall
local print = print
local rawget = rawget
local rawset = rawset
local setmetatable = setmetatable
local strfind = strfind
local strjoin = strjoin
local tonumber = tonumber
local tostring = tostring
local tremove = tremove
local type = type
local unpack = unpack

local GenerateClosure = GenerateClosure
local PlaySoundFile = PlaySoundFile

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
---@param style string? Font outline style. (optional, default is "OUTLINE")
function F.SetFont(text, font, size, style)
	if not text or not text.GetFont then
		F.Developer.LogDebug("Functions.SetFont: text not found")
		return
	end
	local fontName, fontHeight = text:GetFont()

	if type(size) == "string" then
		size = fontHeight + (tonumber(size) or 0)
	end

	if font and not strfind(font, "%.ttf") and not strfind(font, "%.otf") then
		font = LSM:Fetch("font", font)
	end

	text:FontTemplate(font or fontName, size or fontHeight, style or "OUTLINE")
	text:SetShadowColor(0, 0, 0, 0)
	text.SetShadowColor = E.noop
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
			F.SetFont(region --[[@as FontString]], font, size)
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
---@param ... string|number Message parts to print
function F.Print(...)
	print(format("%s: %s", W.Title, strjoin(" ", ...)))
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
	---@return RGB color Color table with r, g, b values
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

---@type table<any, table> Throttle first call states storage
local throttleFirstStates = {}

---Throttle function execution to prevent excessive calls
---@param duration number Duration in seconds to throttle
---@param key any? Unique key for throttling (optional, defaults to function)
---@param func function The function to throttle
---@param ... any Arguments to pass to the function
function F.Throttle(duration, key, func, ...)
	if type(duration) ~= "number" or duration < 0 then
		F.Developer.ThrowError("Invalid duration for F.Throttle: must be a positive number")
	end

	if duration == 0 then
		func(...) -- No throttling (only for testing purpose)
		return
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

---Throttle function execution, including the first call
---@param duration number Duration in seconds to throttle
---@param key any? Unique key for throttling (optional, defaults to function)
---@param func function The function to throttle
---@param ... any Arguments to pass to the function
function F.ThrottleFirst(duration, key, func, ...)
	if type(duration) ~= "number" or duration < 0 then
		F.Developer.ThrowError("Invalid duration for F.ThrottleFirst: must be a positive number")
	end

	if duration == 0 then
		func(...) -- No throttling (only for testing purpose)
		return
	end

	if type(func) ~= "function" then
		F.Developer.ThrowError("Invalid function for F.ThrottleFirst: third argument must be a function")
	end

	local finalKey = key ~= nil and key or func
	local state = throttleFirstStates[finalKey]

	if not state then
		state = {
			isThrottling = false,
			timer = nil,
			lastArgs = { ... },
		}
		throttleFirstStates[finalKey] = state
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

---Create a throttled version of a function
---@param duration number Duration in seconds to throttle
---@param func function The function to throttle
---@return function throttledFunction The throttled version of the function
function F.ThrottleFunction(duration, func)
	return function(...)
		F.Throttle(duration, func, func, ...)
	end
end

---Create a throttled version of a function (including first call)
---@param duration number Duration in seconds to throttle
---@param func function The function to throttle
---@return function throttledFunction The throttled version of the function
function F.ThrottleFirstFunction(duration, func)
	return function(...)
		F.ThrottleFirst(duration, func, func, ...)
	end
end

---Cancel throttle for a specific key
---@param key any The throttle key to cancel
function F.CancelThrottle(key)
	local state = throttleStates[key]
	if state and state.timer then
		state.timer:Cancel()
		state.timer = nil
		state.isThrottling = false
	end
end

---Cancel throttle first for a specific key
---@param key any The throttle first key to cancel
function F.CancelThrottleFirst(key)
	local state = throttleFirstStates[key]
	if state and state.timer then
		state.timer:Cancel()
		state.timer = nil
		state.isThrottling = false
	end
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
			local success, result = pcall(condition)
			if success and result then
				if type(result) == "string" and result == "end" then
					break
				end
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

	---@type table[] Store all current anchor points
	local pointsData = {}

	for i = 1, frame:GetNumPoints() do
		local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(i)
		pointsData[i] = { point, relativeTo, relativePoint, xOfs, yOfs }
	end

	frame:ClearAllPoints()

	for _, data in pairs(pointsData) do
		local point, relativeTo, relativePoint, xOfs, yOfs = unpack(data)
		F.CallMethod(frame, "SetPoint", point, relativeTo, relativePoint, xOfs + x, yOfs + y)
	end
end

---@param fontFile string Font path or name
---@param fontSize number Font size
---@param fontStyle string Font style (e.g., "OUTLINE")
---@param texts string | string[] Text or array of texts to measure
---@return number maxWidth The maximum width among the provided texts
function F.GetAdaptiveTextWidth(fontFile, fontSize, fontStyle, texts)
	if not F.__GetAdaptiveTextWidthFont then
		F.__GetAdaptiveTextWidthFont = E.UIParent:CreateFontString(nil, "OVERLAY")
		F.__GetAdaptiveTextWidthFont:Hide()
		F.InternalizeMethod(F.__GetAdaptiveTextWidthFont, "Show", true)
	end

	local font = F.__GetAdaptiveTextWidthFont
	font:FontTemplate(fontFile or E.media.normFont, fontSize or E.db.general.fontSize, fontStyle or "NONE")

	if type(texts) == "string" then
		texts = { texts }
	end

	local maxWidth = 0
	for _, text in pairs(texts) do
		if type(text) == "string" then
			font:SetText(text)
			local width = font:GetStringWidth()
			if width > maxWidth then
				maxWidth = width
			end
		end
	end

	return maxWidth
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

---Play a sound from the LibSharedMedia-3.0 library
---@param soundName string The name of the sound to play from LSM
---@param channel string? The audio channel to play the sound on (optional, default: "Master")
function F.PlayLSMSound(soundName, channel)
	local soundPath = LSM:Fetch("sound", soundName)
	if soundPath then
		PlaySoundFile(soundPath, channel or "Master")
	else
		F.Developer.LogDebug("Functions.PlayLSMSound: Sound not found -", tostring(soundName))
	end
end

---@type table<any, table> Storage for active value listeners
local valueListeners = {}

---Stop listening for value updates
---@param listenerId any The listener ID to stop
---@param table table The original table being monitored
local function StopListenValueUpdate(listenerId, table)
	if valueListeners[listenerId] then
		setmetatable(table, valueListeners[listenerId].originalMeta or {})
		valueListeners[listenerId] = nil
	end
end

---Listen for value updates on a table key and execute callback when value is set
---@param tbl table The table to monitor
---@param key any The key to monitor for changes
---@param callback function The callback function to execute when key is set (receives stopFunc and value as parameters)
---@return function? stopFunc Function to stop listening for changes
function F.ListenValueUpdate(tbl, key, callback)
	assert(type(tbl) == "table", "first argument must be a table")
	assert(type(key) ~= "nil", "second argument must be a valid key")
	assert(type(callback) == "function", "third argument must be a function")

	local listenerID = {}
	valueListeners[listenerID] = { tbl = tbl, originalMeta = getmetatable(tbl) }

	local stopFunc = GenerateClosure(StopListenValueUpdate, listenerID, tbl)

	if rawget(tbl, key) then
		callback(stopFunc, tbl[key])
		if not valueListeners[listenerID] then
			return
		end
	end

	local newMeta = {
		__newindex = function(t, k, v)
			if k == key then
				callback(stopFunc, v)
			end
			rawset(t, k, v)
		end,
		__index = valueListeners[listenerID].originalMeta and valueListeners[listenerID].originalMeta.__index
			or function(t, k)
				return rawget(t, k)
			end,
	}

	for metaKey, metaValue in pairs(valueListeners[listenerID].originalMeta or {}) do
		if metaKey ~= "__newindex" and metaKey ~= "__index" then
			newMeta[metaKey] = metaValue
		end
	end

	setmetatable(tbl, newMeta)

	return stopFunc
end
