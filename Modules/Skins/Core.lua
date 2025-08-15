local W, F, E, L = unpack((select(2, ...)))
local LSM = E.Libs.LSM
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G
local format = format
local hooksecurefunc = hooksecurefunc
local next = next
local pairs = pairs
local tinsert = tinsert
local tostring = tostring
local type = type
local xpcall = xpcall

local CreateFrame = CreateFrame

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

S.addonsToLoad = {}
S.nonAddonsToLoad = {}
S.updateProfile = {}
S.aceWidgets = {}
S.enteredLoad = {}

--[[
    Check the skin is enabled or not
    @param {string} ElvUI Skins key
    @param {string} WindTools Skins Key
    @return {bool} isEnabledBoth
]]
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

--[[
    Create shadow for frame
    @param {object} frame
    @param {number} size
    @param {number} [r=gloabl shadow color R] R channel value（0~1）
    @param {number} [g=gloabl shadow color G] G channel value（0~1）
    @param {number} [b=gloabl shadow color G] B channel value（0~1）
    @param {boolean} force, add shadow even if user disabled shadow in WindTools Skins
]]
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
		frame = frame:GetParent()
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

--[[
    Create a shadow that the frame level is lower than the parent frame
    @param {frame} frame
    @param {boolean} force, add shadow even if user disabled shadow in WindTools Skins
]]
function S:CreateLowerShadow(frame, force)
	if not force then
		if not E.private.WT.skins or not E.private.WT.skins.shadow then
			return
		end
	end

	self:CreateShadow(frame)
	if frame.shadow and frame.SetFrameStrata and frame.SetFrameLevel then
		local function refreshFrameLevel()
			local parentFrameLevel = frame:GetFrameLevel()
			frame.shadow:SetFrameLevel(parentFrameLevel > 0 and parentFrameLevel - 1 or 0)
		end

		-- avoid the shadow level is reset when the frame strata/level is changed
		hooksecurefunc(frame, "SetFrameStrata", refreshFrameLevel)
		hooksecurefunc(frame, "SetFrameLevel", refreshFrameLevel)
	end
end

--[[
    Update shadow that created by WindTools
    @param {frame} shadow !!!!!NOT THE PARENT FRAME
    @param {number} [r=gloabl shadow color R] R channel value（0~1）
    @param {number} [g=gloabl shadow color G] G channel value（0~1）
    @param {number} [b=gloabl shadow color G] B channel value（0~1）
]]
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

	function S:BindShadowColorWithBorder(frame, borderParent)
		local shadow = frame and frame.shadow
		borderParent = borderParent or frame

		if not shadow or not shadow.__wind or not borderParent or not borderParent.SetBackdropBorderColor then
			return
		end

		hooksecurefunc(borderParent, "SetBackdropBorderColor", function(_, ...)
			colorCallback(shadow, ...)
		end)

		colorCallback(shadow, borderParent:GetBackdropBorderColor())
	end
end

do
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

	--[[
        Create a shadow for the backdrop of the frame
        @param {frame} frame
        @param {string} template
    ]]
	function S:CreateBackdropShadow(frame, template)
		if not frame or frame.__windShadow then
			return
		end

		if frame.backdrop then
			createBackdropShadow(frame, template)
		elseif frame.CreateBackdrop and not self:IsHooked(frame, "CreateBackdrop") then
			self:SecureHook(frame, "CreateBackdrop", function(...)
				if self:IsHooked(frame, "CreateBackdrop") then
					self:Unhook(frame, "CreateBackdrop")
				end
				createBackdropShadow(...)
			end)
		end
	end

	--[[
    Create shadow of backdrop that created by ElvUI skin function
    The function is automatically repeat several times for waiting ElvUI done
        the modifying/creating of backdrop
    !!! It only check for 2 seconds (20 times in total)
    @param {object} frame
    @param {string} [tried=20] time
]]
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

--[[
    Reskin tab
    @param {frame} tab
]]
function S:ReskinTab(tab)
	if not tab then
		return
	end

	self:CreateBackdropShadow(tab)
end

--[[
    Smart set template to transparent
    @param {object} frame
]]
function S:SetTransparentBackdrop(frame)
	if frame.backdrop then
		frame.backdrop:SetTemplate("Transparent")
	else
		frame:CreateBackdrop("Transparent")
	end
end

--[[
    Register a normal callback
    @param {string} name
    @param {function} [func=S.name] function
]]
function S:AddCallback(name, func)
	tinsert(self.nonAddonsToLoad, func or self[name])
end

--[[
    Register AceGUI Widget callback
    @param {string} name
    @param {function} [func=S.name] function
]]
function S:AddCallbackForAceGUIWidget(name, func)
	self.aceWidgets[name] = func or self[name]
end

--[[
    Register addon callback
    @param {string} addonName
    @param {function} [func=S.addonName] function
]]
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

--[[
    Register a callback when game loading is finished
    @param {string} name
    @param {function} [func=S.name] function
]]
function S:AddCallbackForEnterWorld(name, func)
	tinsert(self.enteredLoad, func or self[name])
end

--[[
    Load registered callbacks when game loading is finished
    @param {string} addonName, the name of addon
]]
function S:PLAYER_ENTERING_WORLD()
	if not E.initialized or not E.private.WT.skins.enable then
		return
	end

	for index, func in next, self.enteredLoad do
		xpcall(func, F.Developer.ThrowError, self)
		self.enteredLoad[index] = nil
	end
end

--[[
    Register a callback for updateing
    @param {string} name
    @param {function} [func=S.name] function
]]
function S:AddCallbackForUpdate(name, func)
	tinsert(self.updateProfile, func or self[name])
end

--[[
    Callback loaded registered addon skins
    @param {string} addonName, the name of addon
    @param {table} object, the list of callbacks
]]
function S:CallLoadedAddon(addonName, object)
	for _, func in next, object do
		xpcall(func, F.Developer.ThrowError, self)
	end

	self.addonsToLoad[addonName] = nil
end

--[[
    Callback skins when addon loaded
    @param {string} addonName, the name of addon
]]
function S:ADDON_LOADED(_, addonName)
	if not E.initialized or not E.private.WT.skins.enable then
		return
	end

	local object = self.addonsToLoad[addonName]
	if object then
		self:CallLoadedAddon(addonName, object)
	end
end

function S:ReskinWidgets(AceGUI)
	for name, oldFunc in pairs(AceGUI.WidgetRegistry) do
		S:UpdateWidget(AceGUI, name, oldFunc)
	end
end

function S:UpdateWidget(lib, name, oldFunc)
	if self.aceWidgets[name] then
		lib.WidgetRegistry[name] = self.aceWidgets[name](self, oldFunc)
		self.aceWidgets[name] = nil
	end
end

do
	local alreadyWidgetHooked, alreadyDialogSkinned = false, false
	function S:LibStub_NewLibrary(_, major)
		if major == "AceGUI-3.0" and not alreadyWidgetHooked then
			local AceGUI = _G.LibStub("AceGUI-3.0")
			self:ReskinWidgets(AceGUI)
			self:SecureHook(AceGUI, "RegisterWidgetType", "UpdateWidget")
			alreadyWidgetHooked = true
		elseif major == "AceConfigDialog-3.0" and not alreadyDialogSkinned then
			self:AceConfigDialog()
			alreadyDialogSkinned = true
		end
	end

	function S:HookEarly()
		local AceGUI = _G.LibStub("AceGUI-3.0")
		if AceGUI and not alreadyWidgetHooked then
			self:ReskinWidgets(AceGUI)
			self:SecureHook(AceGUI, "RegisterWidgetType", "UpdateWidget")
			alreadyWidgetHooked = true
		end

		local AceConfigDialog = _G.LibStub("AceConfigDialog-3.0")
		if AceConfigDialog and not alreadyDialogSkinned then
			self:AceConfigDialog()
			alreadyDialogSkinned = true
		end
	end
end

--[[
    Disable ugly AddOnSkin option for the specific addon
    @param {frame} frame
]]
function S:DisableAddOnSkin(key)
	if _G.AddOnSkins then
		local AS = _G.AddOnSkins[1]
		if AS and AS.db[key] then
			AS:SetOption(key, false)
		end
	end
end

--[[
    Add shadow WindTools modules
    @param {frame} frame
]]
function S:CreateShadowModule(frame)
	if E.private.WT.skins.enable and E.private.WT.skins.windtools and E.private.WT.skins.shadow then
		self:CreateShadow(frame)
	end
end

do
	local isLoaded
	local MER
	local MERS

	local function IsMerathilisUILoaded()
		if isLoaded == nil then
			isLoaded = C_AddOns_IsAddOnLoaded("ElvUI_MerathilisUI")
		end

		if isLoaded then
			MER = _G.ElvUI_MerathilisUI and _G.ElvUI_MerathilisUI[1]
			MERS = MER and MER:GetModule("MER_Skins")
		end

		return isLoaded
	end

	--[[
        Trying apply MerathilisUI skin if the addon loaded
        @param {frame} frame
    ]]
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

	--[[
        Strip edge textures
        @param {frame} frame
    ]]
	function S:StripEdgeTextures(frame)
		for _, regionKey in pairs(regions) do
			if frame[regionKey] then
				frame[regionKey]:Kill()
			end
		end
	end
end

--[[
    Reposit frame with parameters
    @param {frame} frame
    @param {frame} the frame relative to
    @param {number} border size
    @param {number} top offset
    @param {number} bottom offset
    @param {number} left offset
    @param {number} right offset
]]
function S:Reposition(frame, target, border, top, bottom, left, right)
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", target, "TOPLEFT", -left - border, top + border)
	frame:SetPoint("TOPRIGHT", target, "TOPRIGHT", right + border, top + border)
	frame:SetPoint("BOTTOMLEFT", target, "BOTTOMLEFT", -left - border, -bottom - border)
	frame:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", right + border, -bottom - border)
end

function S:Initialize()
	if not E.private.WT.skins.enable then
		return
	end

	-- normal skin modules
	for index, func in next, self.nonAddonsToLoad do
		xpcall(func, F.Developer.ThrowError, self)
		self.nonAddonsToLoad[index] = nil
	end

	-- skin modules depend on addon loading
	for addonName, object in pairs(self.addonsToLoad) do
		local isLoaded, isFinished = C_AddOns_IsAddOnLoaded(addonName)
		if isLoaded and isFinished then
			self:CallLoadedAddon(addonName, object)
		end
	end

	self:HookEarly()
	self:SecureHook(_G.LibStub, "NewLibrary", "LibStub_NewLibrary")

	-- remove archment
	if E.private.WT.skins.removeParchment then
		E.private.skins.parchmentRemoverEnable = true
	end
end

function S:Proxy(funcName, frame, ...)
	if not frame then
		F.Developer.ThrowError("ESProxy: frame is nil")
		return
	end

	if not ES[funcName] then
		F.Developer.ThrowError(format("ESProxy: %s is not exist in ElvUI Skins", funcName))
		return
	end

	ES[funcName](ES, frame, ...)
end

function S:HighAlphaTransparent(frame)
	frame._SetBackdropColor = frame.SetBackdropColor
	frame.SetBackdropColor = function(f, r, g, b, a)
		frame._SetBackdropColor(f, r, g, b, 0.8)
	end

	frame:SetTemplate("Transparent")
end

function S:TryPostHook(...)
	local frame, method, hookFunc = ...
	if frame and method and _G[frame] and _G[frame][method] then
		hooksecurefunc(_G[frame], method, function(f, ...)
			if not f.__windSkin then
				hookFunc(f, ...)
				f.__windSkin = true
			end
		end)
	else
		self:Log("debug", "Failed to hook: " .. tostring(frame) .. " " .. tostring(method))
	end
end

S:RegisterEvent("ADDON_LOADED")
S:RegisterEvent("PLAYER_ENTERING_WORLD")
W:RegisterModule(S:GetName())
