local E, _, V, P, G = unpack(ElvUI)
local addonName, addon = ...
local EP = E.Libs.EP
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)

local _G = _G
local tonumber = tonumber
local hooksecurefunc = hooksecurefunc
local collectgarbage = collectgarbage
local GetAddOnMetadata = GetAddOnMetadata

-- 注册 Wind 工具箱为 Ace3 插件
local W = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")

-- 初始化用于保存设置的数据库
V.WT = {}
P.WT = {}
G.WT = {}

addon[1] = W
addon[2] = {} -- 函数 F
addon[3] = E
addon[4] = L
addon[5] = V.WT
addon[6] = P.WT
addon[7] = G.WT

_G[addonName] = addon

-- 一些常量
W.Version = GetAddOnMetadata(addonName, "Version")
W.Title = L["WindTools"]

-- 预处理 WindTools 模块
W.Modules = {}
W.Modules.Skins = W:NewModule("Skins", "AceHook-3.0", "AceEvent-3.0")

-- 注册 ElvUI 模块
function W:Initialize()
    -- 确保初始化顺序为 ElvUI -> WindTools -> 各模块
    self.initialized = true
    self:InitializeModules()

    EP:RegisterPlugin(addonName, W.OptionsCallback)
    hooksecurefunc(E, "UpdateAll", W.UpdateModules)

    collectgarbage("collect")
end

EP:HookInitialize(W, W.Initialize)
