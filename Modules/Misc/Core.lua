local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local M = W.Modules.Misc ---@class Misc

local _G = _G
local next = next
local pairs = pairs
local tinsert = tinsert
local type = type
local xpcall = xpcall

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

---@type table<string, function[]> Table of functions to execute after addon loading
M.addonsToLoad = {}
---@type function[] Table of functions that don't need to wait for addons
M.nonAddonsToLoad = {}
---@type function[] Table of functions to execute after profile update
M.updateProfile = {}

--- Register a callback function
---@param name string Function name
---@param func function|string? Callback function (defaults to M[name] if not provided)
function M:AddCallback(name, func)
	tinsert(self.nonAddonsToLoad, func or self[name])
end

--- Register an addon callback function
---@param addonName string Addon name
---@param func? function|string Addon callback function (defaults to M[addonName] if not provided)
function M:AddCallbackForAddon(addonName, func)
	if func and type(func) == "string" then
		func = self[func]
	end

	local addon = self.addonsToLoad[addonName]
	if not addon then
		self.addonsToLoad[addonName] = {}
		addon = self.addonsToLoad[addonName]
	end

	tinsert(addon, func or self[addonName])
end

--- Register an update callback function
---@param name string Function name
---@param func function|string? Callback function (defaults to self[name] if not provided)
function M:AddCallbackForUpdate(name, func)
	tinsert(self.updateProfile, func or self[name])
end

--- Call registered addon functions
---@param addonName string Addon name
---@param object function[] Array of callback functions
function M:CallLoadedAddon(addonName, object)
	for _, func in next, object do
		xpcall(func, F.Developer.LogDebug, self)
	end

	self.addonsToLoad[addonName] = nil
end

--- Trigger callbacks based on addon loading events
---@param _ any Unused parameter
---@param addonName string Addon name
function M:ADDON_LOADED(_, addonName)
	if not E.initialized then
		return
	end

	local object = self.addonsToLoad[addonName]
	if object then
		self:CallLoadedAddon(addonName, object)
	end
end

function M:Initialize()
	for index, func in next, self.nonAddonsToLoad do
		xpcall(func, F.Developer.LogDebug, self)
		self.nonAddonsToLoad[index] = nil
	end

	for addonName, object in pairs(self.addonsToLoad) do
		local isLoaded, isFinished = C_AddOns_IsAddOnLoaded(addonName)
		if isLoaded and isFinished then
			self:CallLoadedAddon(addonName, object)
		end
	end
end

function M:ProfileUpdate()
	for index, func in next, self.updateProfile do
		xpcall(func, F.Developer.LogDebug, self)
		self.updateProfile[index] = nil
	end
end

M:RegisterEvent("ADDON_LOADED")
W:RegisterModule(M:GetName())
