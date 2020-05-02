local W, F, E, L, V, P, G = unpack(select(2, ...))

local GetCVarBool = GetCVarBool
local pcall, pairs, tinsert = pcall, pairs, tinsert
local ScriptErrorsFrame_OnError = ScriptErrorsFrame_OnError

W.RegisteredModules = {}

---------------------------------------------------
-- 注册 WindTools 模块
---------------------------------------------------
function W:RegisterModule(name)
    if self.initialized then
        self:GetModule(name):Initialize()
    else
        tinsert(self.RegisteredModules, name)
    end
end

---------------------------------------------------
-- 初始化 WindTools 模块
---------------------------------------------------
function W:InitializeModules()
    for _, moduleName in pairs(W.RegisteredModules) do
        local module = self:GetModule(moduleName)
        if module.Initialize then pcall(module.Initialize, module) end
    end
end
