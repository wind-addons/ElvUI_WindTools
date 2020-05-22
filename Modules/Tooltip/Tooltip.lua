local W, F, E, L = unpack(select(2, ...))
local T = W:GetModule("Tooltip")

local _G = _G

T.load = {} -- 毋须等待插件的函数表
T.updateProfile = {} -- 配置更新后的函数表

--[[
    注册回调
    @param {string} name 函数名
    @param {function} [func=T.name] 回调函数
]]
function T:AddCallback(name, func)
    tinsert(self.load, func or self[name])
end

--[[
    注册更新回调
    @param {string} name 函数名
    @param {function} [func=S.name] 回调函数
]]
function T:AddCallbackForUpdate(name, func)
    tinsert(self.updateProfile, func or self[name])
end

--[[
    游戏系统输出错误
    @param {string} err 错误
]]
local function errorhandler(err)
    return _G.geterrorhandler()(err)
end

function T:Initialize()
    for index, func in next, self.load do
        xpcall(func, errorhandler)
        self.load[index] = nil
    end
end

function T:ProfileUpdate()
    for index, func in next, self.updateProfile do
        xpcall(func, errorhandler, self)
        self.updateProfile[index] = nil
    end
end

W:RegisterModule(T:GetName())
