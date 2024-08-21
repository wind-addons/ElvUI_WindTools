local W, F, E, L = unpack((select(2, ...)))
local M = W.Modules.Misc

local _G = _G
local next = next
local pairs = pairs
local tinsert = tinsert
local type = type
local xpcall = xpcall

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

M.addonsToLoad = {} -- 等待插件载入后执行的函数表
M.nonAddonsToLoad = {} -- 毋须等待插件的函数表
M.updateProfile = {} -- 配置更新后的函数表

--[[
    注册回调
    @param {string} name 函数名
    @param {function} [func=M.name] 回调函数
]]
function M:AddCallback(name, func)
	tinsert(self.nonAddonsToLoad, func or self[name])
end

--[[
    注册插件回调
    @param {string} addonName 插件名
    @param {function} [func=M.addonName] 插件回调函数
]]
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

--[[
    注册更新回调
    @param {string} name 函数名
    @param {function} [func=S.name] 回调函数
]]
function M:AddCallbackForUpdate(name, func)
	tinsert(self.updateProfile, func or self[name])
end

--[[
    游戏系统输出错误
    @param {string} err 错误
]]
local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

--[[
    回调注册的插件函数
    @param {string} addonName 插件名
    @param {object} object 回调的函数
]]
function M:CallLoadedAddon(addonName, object)
	for _, func in next, object do
		xpcall(func, errorhandler, self)
	end

	self.addonsToLoad[addonName] = nil
end

--[[
    根据插件载入事件唤起回调
    @param {string} addonName 插件名
]]
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
		xpcall(func, errorhandler, self)
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
		xpcall(func, errorhandler, self)
		self.updateProfile[index] = nil
	end
end

M:RegisterEvent("ADDON_LOADED")
W:RegisterModule(M:GetName())
