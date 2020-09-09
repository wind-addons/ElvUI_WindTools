local W, F, E, L = unpack(select(2, ...))
local UF = W:GetModule("UnitFrames")

local _G = _G
local next = next
local tinsert = tinsert
local xpcall = xpcall

UF.load = {} -- 毋须等待插件的函数表
UF.updateProfile = {} -- 配置更新后的函数表

--[[
    注册回调
    @param {string} name 函数名
    @param {function} [func=UF.name] 回调函数
]]
function UF:AddCallback(name, func)
    tinsert(self.load, func or self[name])
end

--[[
    注册更新回调
    @param {string} name 函数名
    @param {function} [func=UF.name] 回调函数
]]
function UF:AddCallbackForUpdate(name, func)
    tinsert(self.updateProfile, func or self[name])
end

--[[
    游戏系统输出错误
    @param {string} err 错误
]]
local function errorhandler(err)
    return _G.geterrorhandler()(err)
end

function UF:Initialize()
    self.db = E.private.WT.unitFrames

    for index, func in next, self.load do
        xpcall(func, errorhandler)
        self.load[index] = nil
    end
end

function UF:ProfileUpdate()
    for index, func in next, self.updateProfile do
        xpcall(func, errorhandler, self)
        self.updateProfile[index] = nil
    end
end

W:RegisterModule(UF:GetName())
