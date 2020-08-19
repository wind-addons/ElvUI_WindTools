local W, F, E, L = unpack(select(2, ...))
local LSM = E.Libs.LSM
local S = W:GetModule("Skins")

local _G = _G
local tinsert, xpcall, next, assert, format = tinsert, xpcall, next, assert, format
local CreateFrame = CreateFrame

S.addonsToLoad = {} -- 等待插件载入后执行的美化函数表
S.nonAddonsToLoad = {} -- 毋须等待插件的美化函数表
S.updateProfile = {} -- 配置更新后的更新表

--[[
    创建阴影
    @param {object} frame 待美化的窗体
    @param {number} size 阴影尺寸
    @param {number} [r=阴影全局R值] R 通道数值（0~1）
    @param {number} [g=阴影全局G值] G 通道数值（0~1）
    @param {number} [b=阴影全局B值] B 通道数值（0~1）
]]
function S:CreateShadow(frame, size, r, g, b)
    if not frame or frame.windStyle or frame.shadow then
        return
    end

    if frame:GetObjectType() == "Texture" then
        frame = frame:GetParent()
    end

    r = r or E.private.WT.skins.color.r or 0
    g = g or E.private.WT.skins.color.g or 0
    b = b or E.private.WT.skins.color.b or 0

    local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    shadow:SetFrameLevel(1)
    shadow:SetFrameStrata(frame:GetFrameStrata())
    shadow:SetOutside(frame, size or 4, size or 4)
    shadow:SetBackdrop({edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = E:Scale(size or 5)})
    shadow:SetBackdropColor(r, g, b, 0)
    shadow:SetBackdropBorderColor(r, g, b, 0.618)

    frame.shadow = shadow
    frame.windStyle = true
end

--[[
    创建阴影于 ElvUI 美化背景
    @param {object} frame 窗体
]]
function S:CreateBackdropShadow(frame)
    if not frame or frame.windStyle then
        return
    end
    if noBackdrop then
        S:CreateShadow(frame)
    else
        if frame.backdrop then
            frame.backdrop:SetTemplate("Transparent")
            S:CreateShadow(frame.backdrop)
            frame.windStyle = true
        else
            F.DebugMessage(S, format("[1]无法找到 %s 的ElvUI美化背景！", frame:GetName() or "无名框体"))
        end
    end
end

--[[
    创建阴影于 ElvUI 美化背景（延迟等待 ElvUI 美化加载完毕）
    2 秒内未能美化会报错~
    @param {object} frame 窗体
    @param {string} [tried=20] 尝试次数
]]
function S:CreateBackdropShadowAfterElvUISkins(frame, tried)
    if not frame or frame.windStyle then
        return
    end

    tried = tried or 20

    if frame.backdrop then
        frame.backdrop:SetTemplate("Transparent")
        S:CreateShadow(frame.backdrop)
        frame.windStyle = true
    else
        if tried >= 0 then
            E:Delay(
                0.1,
                function()
                    S:CreateBackdropShadowAfterElvUISkins(frame, tried - 1)
                end
            )
        else
            F.DebugMessage(S, format("[2]无法找到 %s 的ElvUI美化背景！", frame:GetName()))
        end
    end
end

--[[
    设定窗体美化背景为透明风格
    @param {object} frame 窗体
]]
function S:SetTransparentBackdrop(frame)
    if frame.backdrop then
        backdrop:SetTemplate("Transparent")
    else
        frame:CreateBackdrop("Transparent")
    end
end

--[[
    注册回调
    @param {string} name 函数名
    @param {function} [func=S.name] 回调函数
]]
function S:AddCallback(name, func)
    tinsert(self.nonAddonsToLoad, func or self[name])
end

--[[
    注册插件回调
    @param {string} addonName 插件名
    @param {function} [func=S.addonName] 插件回调函数
]]
function S:AddCallbackForAddon(addonName, func)
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
function S:AddCallbackForUpdate(name, func)
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
function S:CallLoadedAddon(addonName, object)
    for _, func in next, object do
        xpcall(func, errorhandler)
    end

    self.addonsToLoad[addonName] = nil
end

--[[
    根据插件载入事件唤起回调
    @param {string} addonName 插件名
]]
function S:ADDON_LOADED(_, addonName)
    if not E.initialized then
        return
    end

    local object = self.addonsToLoad[addonName]
    if object then
        self:CallLoadedAddon(addonName, object)
    end
end

-- 初始化，将不需要监视插件载入情况的函数全部进行执行
function S:Initialize()
    for index, func in next, self.nonAddonsToLoad do
        xpcall(func, errorhandler)
        self.nonAddonsToLoad[index] = nil
    end

    for addonName, object in pairs(self.addonsToLoad) do
        local isLoaded, isFinished = IsAddOnLoaded(addonName)
        if isLoaded and isFinished then
            self:CallLoadedAddon(addonName, object)
        end
    end
end

function S:ProfileUpdate()
    for index, func in next, self.updateProfile do
        xpcall(func, errorhandler, self)
        self.updateProfile[index] = nil
    end
end

S:RegisterEvent("ADDON_LOADED")
W:RegisterModule(S:GetName())
