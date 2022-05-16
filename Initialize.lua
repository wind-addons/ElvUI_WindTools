local E, _, V, P, G = unpack(ElvUI)
local addonName, addon = ...
local EP = E.Libs.EP
local AceAddon = E.Libs.AceAddon
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)

local _G = _G
local collectgarbage = collectgarbage
local hooksecurefunc = hooksecurefunc
local next = next
local tonumber = tonumber

local GetAddOnMetadata = GetAddOnMetadata

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
W.IsReloading = false

-- 预处理 WindTools 模块
W.Modules = {}
W.Modules.Misc = W:NewModule("Misc", "AceHook-3.0", "AceEvent-3.0")
W.Modules.Skins = W:NewModule("Skins", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
W.Modules.Tooltips = W:NewModule("Tooltips", "AceHook-3.0", "AceEvent-3.0")
W.Modules.MoveFrames = W:NewModule("MoveFrames", "AceEvent-3.0", "AceHook-3.0")

-- 注册 ElvUI 模块
function W:Initialize()
    -- 确保初始化顺序为 ElvUI -> WindTools -> 各模块
    if not self:CheckElvUIVersion() then
        return
    end

    self.initialized = true
    self:InitializeModules()

    EP:RegisterPlugin(addonName, W.OptionsCallback)
    self:SecureHook(E, "UpdateAll", "UpdateModules")
    self:SecureHook("ReloadUI", "UpdateReloadStatus")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_LOGOUT")
end

do
    local firstTime = false
    local checked = false
    function W:PLAYER_ENTERING_WORLD(_, isInitialLogin, isReloadingUi)
        if not firstTime then
            E:Delay(7, self.CheckInstalledVersion, self)
            firstTime = true
        end

        if not (checked or _G.ElvUIInstallFrame) then
            self:CheckCompatibility()
            checked = true
        end

        if _G.ElvDB then
            if isInitialLogin or not _G.ElvDB.WT then
                _G.ElvDB.WT = {
                    DisabledAddOns = {}
                }
            end

            if next(_G.ElvDB.WT.DisabledAddOns) then
                E:Delay(4, self.PrintDebugEnviromentTip)
            end
        end

        E:Delay(1, collectgarbage, "collect")
    end
end

function W:UpdateReloadStatus()
    W.IsReloading = true
end

function W:PLAYER_LOGOUT()
    if not self.IsReloading and _G.ElvDB and _G.ElvDB.WT then
        _G.ElvDB.WT = nil
    end
end

EP:HookInitialize(W, W.Initialize)
