local E, _, V, P, G = unpack(ElvUI)
local AddOnName, NameSpace = ...
local EP = E.Libs.EP

local _G = _G
local tonumber = tonumber
local hooksecurefunc = hooksecurefunc
local collectgarbage = collectgarbage

-- 注册 Wind 工具箱为 Ace3 插件
local W = LibStub("AceAddon-3.0"):NewAddon(AddOnName, "AceConsole-3.0", "AceEvent-3.0", 'AceTimer-3.0', 'AceHook-3.0');

-- 初始化用于保存设置的数据库
V.WT = {}
P.WT = {}
G.WT = {}

NameSpace[1] = W
NameSpace[2] = {} -- 函数 F
NameSpace[3] = E
NameSpace[4] = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale)
NameSpace[5] = V.WT
NameSpace[6] = P.WT
NameSpace[7] = G.WT

_G[AddOnName] = NameSpace

---------------------------------------------------
-- ElvUI 模块注册回调
---------------------------------------------------
function W:PluginCallback()
    -- 标题添加
    E.Options.name = E.Options.name .. " + WindUI 0.1"
end

---------------------------------------------------
-- 配置更改后的模块更新
---------------------------------------------------
function W:UpdateAll() end

---------------------------------------------------
-- 注册 ElvUI 模块
---------------------------------------------------
function W:Initialize()
    -- 确保初始化顺序为 ElvUI -> WindTools -> 各模块
    self.initialized = true
    self:InitializeModules()

    EP:RegisterPlugin(AddOnName, W.PluginCallback)
    hooksecurefunc(E, "UpdateAll", W.UpdateAll)

    collectgarbage("collect")
end

EP:HookInitialize(W, W.Initialize)
