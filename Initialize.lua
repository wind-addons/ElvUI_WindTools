local E, _, V, P, G = unpack(ElvUI)
local addonName, addon = ...
local EP = E.Libs.EP
local AceAddon = E.Libs.AceAddon
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)

local _G = _G
local collectgarbage = collectgarbage
local hooksecurefunc = hooksecurefunc
local tonumber = tonumber

local GetAddOnMetadata = GetAddOnMetadata

local C_Timer_After = C_Timer.After

-- 注册 Wind 工具箱为 Ace3 插件
local W = AceAddon:NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")

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

_G["WindTools"] = addon
W.Version = GetAddOnMetadata(addonName, "Version")

-- 注册库
E:AddLib("RC", "LibRangeCheck-2.0")

-- 预处理 WindTools 模块
W.Modules = {}
W.Modules.Misc = W:NewModule("Misc", "AceHook-3.0", "AceEvent-3.0")
W.Modules.Skins = W:NewModule("Skins", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
W.Modules.Tooltip = W:NewModule("Tooltips", "AceHook-3.0", "AceEvent-3.0")

-- 注册 ElvUI 模块
function W:Initialize()
    -- 确保初始化顺序为 ElvUI -> WindTools -> 各模块
    self.initialized = true
    self:InitializeModules()

    EP:RegisterPlugin(addonName, W.OptionsCallback)
    self:SecureHook(E, "UpdateAll", "UpdateModules")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

do
    local Entered = false
    function W:PLAYER_ENTERING_WORLD()
        if Entered then
            C_Timer_After(
                10,
                function()
                    W:CheckInstalledVersion()
                end
            )
            Entered = true
        end

        C_Timer_After(
            1,
            function()
                collectgarbage("collect")
            end
        )
    end
end

EP:HookInitialize(W, W.Initialize)
