local W, F, E = unpack((select(2, ...))) ---@type WindTools, Functions, table
local LSM = E.Libs.LSM
local S = W.Modules.Skins ---@class Skins
local ES = E.Skins

local _G = _G
local assert = assert
local format = format
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local next = next
local pairs = pairs
local strmatch = strmatch
local tinsert = tinsert
local tonumber = tonumber
local tostring = tostring
local type = type
local unpack = unpack
local xpcall = xpcall

local CreateFrame = CreateFrame
local GenerateClosure = GenerateClosure
local RunNextFrame = RunNextFrame
local Settings = Settings

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

---@type table<string, any> Table to store setting frames by name
S.settingFrames = {}
---@type table<string, function> Table to store waiting setting frame callbacks
S.waitSettingFrames = {}
---@type table<string, function[]> Table to store addon loading callbacks
S.addonsToLoad = {}
---@type function[] Table to store non-addon loading callbacks
S.nonAddonsToLoad = {}
---@type table<string, function[]> Table to store library handler callbacks
S.libraryHandlers = {}
---@type table<string, number> Table to store handled library minor versions
S.libraryHandledMinors = {}
---@type function[] Table to store profile update callbacks
S.updateProfile = {}
---@type table<string, {checker: function, handler: function, constructor: function?}> Table to store AceGUI widget callbacks
S.aceWidgetConfigs = {}
---@type table<string, Frame[]> Table to store AceGUI widget that need to be waiting for db loading
S.aceWidgetWaitingList = {}
---@type function[] Table to store enter world callbacks
S.enteredLoad = {}
---@type Texture Texture object for path fetching
S.texturePathFetcher = E.UIParent:CreateTexture(nil, "ARTWORK")
S.texturePathFetcher:Hide()

-- Override Settings.RegisterCanvasLayoutCategory to track setting frames
local RegisterCanvasLayoutCategory = Settings.RegisterCanvasLayoutCategory
---@diagnostic disable-next-line: duplicate-set-field
Settings.RegisterCanvasLayoutCategory = function(frame, name)
	if frame and name then
		S.settingFrames[name] = frame
		if S.waitSettingFrames[name] then
			S.waitSettingFrames[name](frame)
			S.waitSettingFrames[name] = nil
		end
	end

	return RegisterCanvasLayoutCategory(frame, name)
end

---Check if the texture path is equal to the given path
---@param texture TextureBase The texture object to check
---@param path string The texture path to compare against
---@return boolean result True if the texture paths are equal, false otherwise
function S:IsTexturePathEqual(texture, path)
	local got = texture and texture.GetTextureFilePath and texture:GetTextureFilePath()
	if not got then
		return false
	end

	self.texturePathFetcher:SetTexture(path)
	return got == self.texturePathFetcher:GetTextureFilePath()
end

---Check the skin config of both ElvUI and WindTools DB
---@param elvuiKey string? The ElvUI database key to check (optional)
---@param windtoolsKey string? The WindTools database key to check (defaults to elvuiKey if not provided)
---@return boolean enabled True if both configs are enabled, false otherwise
function S:CheckDB(elvuiKey, windtoolsKey)
	if elvuiKey then
		windtoolsKey = windtoolsKey or elvuiKey
		if not (E.private.skins.blizzard.enable and E.private.skins.blizzard[elvuiKey]) then
			return false
		end
		if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard[windtoolsKey]) then
			return false
		end
	else
		if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard[windtoolsKey]) then
			return false
		end
	end

	return true
end

---Create a shadow for the specified frame
---@param frame any The frame to apply shadow to
---@param size number? The shadow size (default: 4)
---@param r number? Red color component (default: from config)
---@param g number? Green color component (default: from config)
---@param b number? Blue color component (default: from config)
---@param force boolean? Force creation even if shadow is disabled
function S:CreateShadow(frame, size, r, g, b, force)
	if not force then
		if not E.private.WT.skins or not E.private.WT.skins.shadow then
			return
		end
	end

	if not frame or frame.__windShadow or frame.shadow and frame.shadow.__wind then
		return
	end

	if frame:GetObjectType() == "Texture" then
		local parent = frame:GetParent()
		if not parent or parent:GetObjectType() ~= "Frame" then
			F.Developer.ThrowError("CreateShadow: Invalid parent frame of frame:", frame:GetDebugName())
			return
		end
		frame = parent
	end

	r = r or E.private.WT.skins.color.r or 0
	g = g or E.private.WT.skins.color.g or 0
	b = b or E.private.WT.skins.color.b or 0

	size = size or 4
	size = size + (E.private.WT.skins.increasedSize or 0)

	local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	shadow:SetFrameStrata(frame:GetFrameStrata())
	shadow:SetFrameLevel(frame:GetFrameLevel() or 1)
	shadow:SetOutside(frame, size, size)
	shadow:SetBackdrop({ edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = size + 1 })
	shadow:SetBackdropColor(r, g, b, 0)
	shadow:SetBackdropBorderColor(r, g, b, 0.618)
	shadow.__wind = true -- mark the shadow created by WindTools

	frame.shadow = shadow
	frame.__windShadow = 1 -- mark the current frame has shadow
end

---Create a lower shadow for the specified frame
---@param frame any The frame to apply shadow to
---@param size number? The shadow size (default: 4)
---@param r number? Red color component (default: from config)
---@param g number? Green color component (default: from config)
---@param b number? Blue color component (default: from config)
---@param force boolean? Force creation even if shadow is disabled
function S:CreateLowerShadow(frame, size, r, g, b, force)
	if not force then
		if not E.private.WT.skins or not E.private.WT.skins.shadow then
			return
		end
	end

	self:CreateShadow(frame, size, r, g, b, force)
	if frame.shadow and frame.SetFrameStrata and frame.SetFrameLevel then
		---Refresh frame level to keep shadow below the main frame
		local function refreshFrameLevel()
			local parentFrameLevel = frame:GetFrameLevel()
			frame.shadow:SetFrameLevel(parentFrameLevel > 0 and parentFrameLevel - 1 or 0)
		end

		-- avoid the shadow level is reset when the frame strata/level is changed
		hooksecurefunc(frame, "SetFrameStrata", refreshFrameLevel)
		hooksecurefunc(frame, "SetFrameLevel", refreshFrameLevel)
	end
end

---Update shadow color
---@param shadow any? The shadow frame to update
---@param r number? Red color component (default: from config)
---@param g number? Green color component (default: from config)
---@param b number? Blue color component (default: from config)
function S:UpdateShadowColor(shadow, r, g, b)
	if not shadow or not shadow.__wind then
		return
	end

	r = r or E.private.WT.skins.color.r or 0
	g = g or E.private.WT.skins.color.g or 0
	b = b or E.private.WT.skins.color.b or 0

	shadow:SetBackdropColor(r, g, b, 0)
	shadow:SetBackdropBorderColor(r, g, b, 0.618)
end

do
	---Callback function for shadow color updates
	---@param shadow any The shadow frame
	---@param r number? Red color component
	---@param g number? Green color component
	---@param b number? Blue color component
	local function colorCallback(shadow, r, g, b)
		if not r or not g or not b then
			return
		end

		if r == E.db.general.bordercolor.r and g == E.db.general.bordercolor.g and b == E.db.general.bordercolor.b then
			S:UpdateShadowColor(shadow)
		else
			S:UpdateShadowColor(shadow, r, g, b)
		end
	end

	---Bind shadow color with border color changes
	---@param frame any The frame that has shadow
	---@param borderParent any? The frame that has border (defaults to frame)
	function S:BindShadowColorWithBorder(frame, borderParent)
		local shadow = frame and frame.shadow
		borderParent = borderParent or frame

		if not shadow or not shadow.__wind or not borderParent or not borderParent.SetBackdropBorderColor then
			return
		end

		hooksecurefunc(borderParent, "SetBackdropBorderColor", function(_, ...)
			---Hook to update shadow color when border color changes
			colorCallback(shadow, ...)
		end)

		colorCallback(shadow, borderParent:GetBackdropBorderColor())
	end
end

do
	---Create backdrop shadow for frames
	---@param frame any The target frame
	---@param defaultTemplate boolean? Whether to use default template
	local function createBackdropShadow(frame, defaultTemplate)
		if not E.private.WT.skins or not E.private.WT.skins.shadow then
			return
		end

		if not defaultTemplate then
			frame.backdrop:SetTemplate("Transparent")
		end

		S:CreateShadow(frame.backdrop)

		if frame.backdrop.shadow.__wind then
			frame.__windShadow = frame.backdrop.__windShadow + 1
		end
	end

	---Creates a backdrop shadow for the specified frame
	---@param frame any The target frame
	---@param useDefaultTemplate boolean? Whether to use the default template
	function S:CreateBackdropShadow(frame, useDefaultTemplate)
		if not frame or frame.__windShadow then
			return
		end

		if frame.backdrop then
			createBackdropShadow(frame, useDefaultTemplate)
		elseif frame.CreateBackdrop and not self:IsHooked(frame, "CreateBackdrop") then
			self:SecureHook(frame, "CreateBackdrop", function(...)
				---Hook to create backdrop shadow after backdrop is created
				if self:IsHooked(frame, "CreateBackdrop") then
					self:Unhook(frame, "CreateBackdrop")
				end
				createBackdropShadow(...)
			end)
		end
	end

	---Create shadow of backdrop that created by ElvUI skin function
	---The function automatically repeats several times for waiting ElvUI done
	---the modifying/creating of backdrop
	---!!! It only checks for 2 seconds (20 times in total)
	---@param frame any The target frame
	---@param tried number? Number of attempts remaining (default: 20)
	function S:TryCreateBackdropShadow(frame, tried)
		if not frame or frame.__windShadow then
			return
		end

		tried = tried or 20

		if frame.backdrop then
			createBackdropShadow(frame)
		else
			if tried >= 0 then
				E:Delay(0.1, self.TryCreateBackdropShadow, self, frame, tried - 1)
			end
		end
	end
end

---Reskin a tab element
---@param tab any? The tab frame to reskin
function S:ReskinTab(tab)
	if not tab then
		return
	end

	self:CreateBackdropShadow(tab)
end

---Handle AceGUI widget styling
---@param lib table The AceGUI library
---@param name string The widget name
---@param constructor function The widget constructor
function S:HandleAceGUIWidget(lib, name, constructor)
	local config = self.aceWidgetConfigs[name]
	if not config then
		return
	end

	config.constructor = constructor

	if self.db then
		if self.db.enable and config.checker(self.db) then
			config.constructor = constructor
			lib.WidgetRegistry[name] = function()
				local widget = config.constructor()
				config.handler(widget)
				return widget
			end
		end
		return
	end

	if not self.aceWidgetWaitingList[name] then
		self.aceWidgetWaitingList[name] = {}
		lib.WidgetRegistry[name] = function()
			local widget = config.constructor()
			if self.db then
				if self.db.enable and config.checker(self.db) then
					config.handler(widget)
				end
			else
				tinsert(self.aceWidgetWaitingList[name], widget)
			end
			return widget
		end
	end
end

function S:ProcessWaitingAceGUIWidgets()
	local lib = _G.LibStub:GetLibrary("AceGUI-3.0", true)
	assert(lib, "ProcessWaitingAceWidgets: AceGUI-3.0 not found")

	for name, widgets in pairs(self.aceWidgetWaitingList) do
		local config = self.aceWidgetConfigs[name]
		if self.db.enable and config.checker(self.db) then
			lib.WidgetRegistry[name] = function()
				local widget = config.constructor()
				config.handler(widget)
				return widget
			end

			for _, widget in ipairs(widgets) do
				config.handler(widget)
			end
		else
			lib.WidgetRegistry[name] = config.constructor
		end
	end

	self.aceWidgetWaitingList = nil
end

---Set transparent backdrop for a frame
---@param frame any The frame to apply transparent backdrop to
function S:SetTransparentBackdrop(frame)
	if frame.backdrop then
		frame.backdrop:SetTemplate("Transparent")
	else
		frame:CreateBackdrop("Transparent")
	end
end

---Add a callback function to be executed during initialization
---@param name string? The function name (if func is nil)
---@param func function? The callback function
function S:AddCallback(name, func)
	tinsert(self.nonAddonsToLoad, func or self[name])
end

---Add a callback function for AceGUI widget styling
---@param name string The widget name
---@param handler function|string? The callback function or method name
---@param checker function The checker for enabling the skin or not
function S:AddCallbackForAceGUIWidget(name, handler, checker)
	if type(handler) == "string" then
		handler = GenerateClosure(self[handler], self)
	end

	assert(type(handler) == "function", "AddCallbackForAceGUIWidget: handler must be a function or method name")

	self.aceWidgetConfigs[name] = {
		checker = checker,
		handler = handler,
	}
end

---Add a callback function for when a specific addon is loaded
---@param addonName string The name of the addon
---@param func function|string? The callback function or method name
function S:AddCallbackForAddon(addonName, func)
	local addon = self.addonsToLoad[addonName]
	if not addon then
		self.addonsToLoad[addonName] = {}
		addon = self.addonsToLoad[addonName]
	end

	if type(func) == "string" then
		func = self[func]
	end

	tinsert(addon, func or self[addonName])
end

---Add a callback function for when a library is loaded
---@param name string The library name
---@param func function|string? The callback function or method name
function S:AddCallbackForLibrary(name, func)
	local lib = self.libraryHandlers[name]
	if not lib then
		self.libraryHandlers[name] = {}
		lib = self.libraryHandlers[name]
	end

	if type(func) == "string" then
		func = self[func]
	end

	tinsert(lib, func or self[name])
end

---Add a callback function for when the player enters the world
---@param name string? The function name (if func is nil)
---@param func function? The callback function
function S:AddCallbackForEnterWorld(name, func)
	tinsert(self.enteredLoad, func or self[name])
end

---Event handler for PLAYER_ENTERING_WORLD
function S:PLAYER_ENTERING_WORLD()
	if not E.initialized or not E.private.WT.skins.enable then
		return
	end

	for index, func in next, self.enteredLoad do
		xpcall(func, F.Developer.ThrowError, self)
		self.enteredLoad[index] = nil
	end
end

---Add a callback function for profile updates
---@param name string? The function name (if func is nil)
---@param func function? The callback function
function S:AddCallbackForUpdate(name, func)
	tinsert(self.updateProfile, func or self[name])
end

---Call all loaded addon callbacks
---@param addonName string The name of the addon
---@param object table The callback functions table
function S:CallLoadedAddon(addonName, object)
	for _, func in next, object do
		if not xpcall(func, F.Developer.ThrowError, self) then
			self:Log("debug", format("Failed to run addon %s", addonName))
		end
	end

	self.addonsToLoad[addonName] = nil
end

---Event handler for ADDON_LOADED
---@param _ any Unused parameter
---@param addonName string The name of the loaded addon
function S:ADDON_LOADED(_, addonName)
	if not E.initialized or not E.private.WT.skins.enable then
		return
	end

	local object = self.addonsToLoad[addonName]
	if object then
		self:CallLoadedAddon(addonName, object)
	end
end

---Handle new library registration via LibStub
---@param _ any Unused parameter
---@param major string The library major version
---@param minor string|number? The library minor version
function S:LibStub_NewLibrary(_, major, minor)
	if not self.libraryHandlers[major] then
		return
	end

	minor = minor and tonumber(strmatch(minor, "%d+"))
	local handledMinor = self.libraryHandledMinors[major]
	if not minor or handledMinor and handledMinor >= minor then
		return
	end

	self.libraryHandledMinors[major] = minor

	RunNextFrame(function()
		---Run library skinning on next frame to ensure library is fully loaded
		local lib, latestMinor = _G.LibStub(major, true)
		if not lib or not latestMinor or latestMinor ~= minor then
			return
		end
		for _, func in next, self.libraryHandlers[major] do
			if not xpcall(func, F.Developer.ThrowError, self, lib) then
				self:Log("debug", format("Failed to skin library %s", major, minor))
			end
		end
	end)
end

---Disable AddOnSkins for a specific key
---@param key string The addon skin key to disable
function S:DisableAddOnSkin(key)
	if _G.AddOnSkins then
		local AS = _G.AddOnSkins[1]
		if AS and AS.db[key] then
			AS:SetOption(key, false)
		end
	end
end

---Create shadow for WindTools modules
---@param frame any The frame to apply shadow to
function S:CreateShadowModule(frame)
	if E.private.WT.skins.enable and E.private.WT.skins.windtools and E.private.WT.skins.shadow then
		self:CreateShadow(frame)
	end
end

do
	local isLoaded

	---Check if MerathilisUI addon is loaded
	---@return boolean loaded True if MerathilisUI is loaded
	local function IsMerathilisUILoaded()
		if isLoaded == nil then
			isLoaded = C_AddOns_IsAddOnLoaded("ElvUI_MerathilisUI")
		end
		return isLoaded
	end

	---Apply MerathilisUI skin if the addon is loaded
	---@param frame any The frame to apply MerathilisUI skin to
	function S:MerathilisUISkin(frame)
		if E.private.WT.skins.merathilisUISkin and IsMerathilisUILoaded() then
			if frame.Styling then
				frame:Styling()
			end
		end
	end
end

do
	local regions = {
		"Center",
		"BottomEdge",
		"LeftEdge",
		"RightEdge",
		"TopEdge",
		"BottomLeftCorner",
		"BottomRightCorner",
		"TopLeftCorner",
		"TopRightCorner",
	}

	---Strip edge textures from a frame
	---@param frame any The frame to strip edge textures from
	function S:StripEdgeTextures(frame)
		for _, regionKey in pairs(regions) do
			if frame[regionKey] then
				frame[regionKey]:Kill()
			end
		end
	end
end

---Reposition frame with parameters
---@param frame any The frame to reposition
---@param target any The frame relative to
---@param border number Border size
---@param top number Top offset
---@param bottom number Bottom offset
---@param left number Left offset
---@param right number Right offset
function S:Reposition(frame, target, border, top, bottom, left, right)
	frame:ClearAllPoints()
	frame:Point("TOPLEFT", target, "TOPLEFT", -left - border, top + border)
	frame:Point("TOPRIGHT", target, "TOPRIGHT", right + border, top + border)
	frame:Point("BOTTOMLEFT", target, "BOTTOMLEFT", -left - border, -bottom - border)
	frame:Point("BOTTOMRIGHT", target, "BOTTOMRIGHT", right + border, -bottom - border)
end

---Proxy function to call ElvUI Skins functions
---@param method string The function name in ElvUI Skins
---@param frame any The frame to pass to the function
---@param ... any Additional arguments to pass
function S:Proxy(method, frame, ...)
	if not frame then
		F.Developer.ThrowError("Failed to proxy function: frame is nil.", "\n funcName:", method)
		return
	end

	if not ES[method] then
		F.Developer.ThrowError(
			format("Proxy: %s is not exist in ElvUI Skins", method),
			"\n frame:",
			frame.GetDebugName and frame:GetDebugName() or tostring(frame)
		)
		return
	end

	ES[method](ES, frame, ...)
end

---Set high alpha transparent backdrop
---@param frame any The frame to apply high alpha transparent backdrop to
function S:HighAlphaTransparent(frame)
	frame._SetBackdropColor = frame.SetBackdropColor
	frame.SetBackdropColor = function(f, r, g, b, a)
		---Override SetBackdropColor to force high alpha
		frame._SetBackdropColor(f, r, g, b, 0.8)
	end

	frame:SetTemplate("Transparent")
end

---Try to post hook a function with error handling
---@param frame string The frame name
---@param method string The method name
---@param hookFunc function The hook function
function S:TryPostHook(frame, method, hookFunc)
	if frame and method and _G[frame] and _G[frame][method] then
		hooksecurefunc(_G[frame], method, function(f, ...)
			---Hook function with skin tracking to prevent duplicate skinning
			if not f.__windSkin then
				hookFunc(f, ...)
				f.__windSkin = true
			end
		end)
	else
		self:Log("debug", "Failed to hook: " .. tostring(frame) .. " " .. tostring(method))
	end
end

---Reskin settings frame with a callback function
---@param name string The settings frame name
---@param func function|string The callback function or method name
function S:ReskinSettingFrame(name, func)
	if type(func) == "string" and S[func] then
		func = GenerateClosure(S[func], S) --[[@as function]]
	end

	if not func or type(func) ~= "function" then
		F.Developer.ThrowError("Failed to register ReskinSettingFrame: func is nil or not a function, name:", name)
		return
	end

	local frame = self.settingFrames[name]
	if frame then
		func(frame)
	else
		self.waitSettingFrames[name] = func
	end
end

---Reskin icon button with hover effects
---@param button Button The button to reskin
---@param icon string The icon texture path
---@param size number The icon size
---@param rotate number? The icon rotation (optional)
function S:ReskinIconButton(button, icon, size, rotate)
	button:StripTextures()
	button.Icon = button:CreateTexture(nil, "ARTWORK")
	button.Icon:SetTexture(icon)
	button.Icon:Size(size, size)
	button.Icon:Point("CENTER")
	if rotate then
		button.Icon:SetRotation(rotate)
	end

	button:HookScript("OnEnter", function(btn)
		---Change icon color on mouse enter
		btn.Icon:SetVertexColor(E.media.rgbvaluecolor.r, E.media.rgbvaluecolor.g, E.media.rgbvaluecolor.b)
	end)

	button:HookScript("OnLeave", function(btn)
		---Reset icon color on mouse leave
		btn.Icon:SetVertexColor(1, 1, 1)
	end)
end

--- Attempts to crop a texture by adjusting its texture coordinates if they are at default values.
--- This function checks if the texture has a valid in-game texture ID and if its texture
--- coordinates are set to the default values (0, 0, 1, 1). If both conditions are met,
--- it applies ElvUI's standard texture coordinates to crop the texture.
--- @param tex table The texture object to potentially crop
--- @return nil This function does not return a value
function S:TryCropTexture(tex)
	if not tex or not tex.GetTexture or not tex.GetTexCoord or not tex.SetTexCoord then
		return
	end

	local textureID = tex:GetTexture()

	-- Skip the check if the texture is an atlas or a custom texture
	if type(textureID) == "number" and textureID <= 0 then
		return
	end

	local left, top, _, bottom, right = tex:GetTexCoord()
	if F.IsAlmost({ left, top, right, bottom }, { 0, 0, 1, 1 }) then
		tex:SetTexCoord(unpack(E.TexCoords))
	end
end

function S:Initialize()
	self.db = E.private.WT.skins
	self:ProcessWaitingAceGUIWidgets()

	if not self.db.enable then
		return
	end

	-- Run Blizzard skins
	for index, func in next, self.nonAddonsToLoad do
		if not xpcall(func, F.Developer.ThrowError, self) then
			self:Log("debug", "Failed to run skin function")
		end
		self.nonAddonsToLoad[index] = nil
	end

	-- Run addon skins, including some lazy-loading Blizzard skins
	for addonName, object in pairs(self.addonsToLoad) do
		local isLoaded, isFinished = C_AddOns_IsAddOnLoaded(addonName)
		if isLoaded and isFinished then
			self:CallLoadedAddon(addonName, object)
		end
	end

	-- Remove parchment
	if E.private.WT.skins.removeParchment then
		E.private.skins.parchmentRemoverEnable = true
	end
end

S:RegisterEvent("ADDON_LOADED")
S:RegisterEvent("PLAYER_ENTERING_WORLD")
W:RegisterModule(S:GetName())
