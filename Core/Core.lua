local W, F, E, L, V, P, G = unpack(select(2, ...))

local GetCVarBool = GetCVarBool
local pcall, pairs, tinsert = pcall, pairs, tinsert
local ScriptErrorsFrame_OnError = ScriptErrorsFrame_OnError

W.RegisteredModules = {}

--[[
    注册 WindTools 模块
    @param {string} name 模块名
]]
function W:RegisterModule(name)
    if not name then
        F.DebugMessage(W, "注册模块名为空")
        return
    end
    if self.initialized then
        self:GetModule(name):Initialize()
    else
        tinsert(self.RegisteredModules, name)
    end
end

-- 初始化 WindTools 模块
function W:InitializeModules()
    for _, moduleName in pairs(W.RegisteredModules) do
        local module = self:GetModule(moduleName)
        if module.Initialize then
            pcall(module.Initialize, module)
        end
    end
end

-- 配置更改后的模块更新
function W:UpdateModules()
    for _, moduleName in pairs(W.RegisteredModules) do
        local module = self:GetModule(moduleName)
        if module.ProfileUpdate then
            pcall(module.ProfileUpdate, module)
        end
    end
end

-- ElvUI 模块注册回调
function W:PluginCallback()
    -- 标题添加
    E.Options.name = E.Options.name .. " + WindUI 0.1"
end
