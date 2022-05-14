local W, F, E, L = unpack(select(2, ...))
local LSM = E.Libs.LSM
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G
local format = format
local next = next
local pairs = pairs
local tinsert = tinsert
local type = type
local xpcall = xpcall

local AceGUI

local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

S.addonsToLoad = {} -- 等待插件载入后执行的美化函数表
S.nonAddonsToLoad = {} -- 毋须等待插件的美化函数表
S.updateProfile = {} -- 配置更新后的更新表
S.aceWidgets = {}
S.enteredLoad = {}

--[[
    查询是否符合开启条件
    @param {string} elvuiKey      ElvUI 数据库 Key
    @param {string} windtoolsKey  WindTools 数据库 Key
    @return {bool} 启用状态
]]
function S:CheckDB(elvuiKey, windtoolsKey)
    if elvuiKey then
        windtoolsKey = windtoolsKey or elvuiKey
        if not (E.private.skins.blizzard.enable and E.private.skins.blizzard[elvuiKey]) then
            return false
        end
        if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard[windtoolsKey]) then
            return false
        end
    else
        if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard[windtoolsKey]) then
            return false
        end
    end

    return true
end

--[[
    创建阴影
    @param {object} frame 待美化的窗体
    @param {number} size 阴影尺寸
    @param {number} [r=阴影全局R值] R 通道数值（0~1）
    @param {number} [g=阴影全局G值] G 通道数值（0~1）
    @param {number} [b=阴影全局B值] B 通道数值（0~1）
]]
function S:CreateShadow(frame, size, r, g, b, force)
    if not (E.private.WT.skins and E.private.WT.skins.shadow) and not force then
        return
    end

    if not frame or frame.windStyle or frame.shadow then
        return
    end

    if frame:GetObjectType() == "Texture" then
        frame = frame:GetParent()
    end

    r = r or E.private.WT.skins.color.r or 0
    g = g or E.private.WT.skins.color.g or 0
    b = b or E.private.WT.skins.color.b or 0

    size = size or 4
    size = size + (E.private.WT.skins.increasedSize or 0)

    local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    shadow:SetFrameStrata(frame:GetFrameStrata())
    shadow:SetFrameLevel(frame:GetFrameLevel() or 1)
    shadow:SetOutside(frame, size, size)
    shadow:SetBackdrop({edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = size + 1})
    shadow:SetBackdropColor(r, g, b, 0)
    shadow:SetBackdropBorderColor(r, g, b, 0.618)

    frame.shadow = shadow
    frame.windStyle = true
end

--[[
    创建阴影于 ElvUI 美化背景
    @param {object} frame 窗体
]]
function S:CreateBackdropShadow(frame, defaultTemplate)
    if not frame or frame.windStyle then
        return
    end

    if frame.backdrop then
        if not defaultTemplate then
            frame.backdrop:SetTemplate("Transparent")
        end
        self:CreateShadow(frame.backdrop)
        frame.windStyle = true
    elseif frame.CreateBackdrop and not self:IsHooked(frame, "CreateBackdrop") then
        self:SecureHook(
            frame,
            "CreateBackdrop",
            function()
                if self:IsHooked(frame, "CreateBackdrop") then
                    self:Unhook(frame, "CreateBackdrop")
                end
                if frame.backdrop then
                    if not defaultTemplate then
                        frame.backdrop:SetTemplate("Transparent")
                    end
                    self:CreateShadow(frame.backdrop)
                    frame.windStyle = true
                end
            end
        )
    end
end

--[[
    创建阴影于 ElvUI 美化背景（延迟等待 ElvUI 美化加载完毕）
    2 秒内未能美化会报错~
    @param {object} frame 窗体
    @param {string} [tried=20] 尝试次数
]]
function S:TryCreateBackdropShadow(frame, tried)
    if not frame or frame.windStyle then
        return
    end

    tried = tried or 20

    if frame.backdrop then
        frame.backdrop:SetTemplate("Transparent")
        if E.private.WT.skins.shadow then
            self:CreateShadow(frame.backdrop)
        end
        frame.windStyle = true
    else
        if tried >= 0 then
            E:Delay(
                0.1,
                function()
                    self:TryCreateBackdropShadow(frame, tried - 1)
                end
            )
        end
    end
end

function S:ReskinTab(tab)
    if not tab then
        return
    end

    if tab.GetName then
        F.SetFontOutline(_G[tab:GetName() .. "Text"])
    end

    self:CreateBackdropShadow(tab)
end

--[[
    设定窗体美化背景为透明风格
    @param {object} frame 窗体
]]
function S:SetTransparentBackdrop(frame)
    if frame.backdrop then
        frame.backdrop:SetTemplate("Transparent")
    else
        frame:CreateBackdrop("Transparent")
    end
end

--[[
    游戏系统输出错误
    @param {string} err 错误
]]
local function errorhandler(err)
    return _G.geterrorhandler()(err)
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
    注册 AceGUI Widget 回调
    @param {string} name 函数名
    @param {function} [func=S.name] 回调函数
]]
function S:AddCallbackForAceGUIWidget(name, func)
    self.aceWidgets[name] = func or self[name]
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

    if type(func) == "string" then
        func = self[func]
    end

    tinsert(addon, func or self[addonName])
end

--[[
    注册进入游戏后执行的回调
    @param {string} name 函数名
    @param {function} [func=S.name] 回调函数
]]
function S:AddCallbackForEnterWorld(name, func)
    tinsert(self.enteredLoad, func or self[name])
end

--[[
    根据进入游戏事件唤起回调
    @param {string} addonName 插件名
]]
function S:PLAYER_ENTERING_WORLD()
    if not E.initialized or not E.private.WT.skins.enable then
        return
    end

    for index, func in next, self.enteredLoad do
        xpcall(func, errorhandler, self)
        self.enteredLoad[index] = nil
    end
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
    回调注册的插件函数
    @param {string} addonName 插件名
    @param {object} object 回调的函数
]]
function S:CallLoadedAddon(addonName, object)
    for _, func in next, object do
        xpcall(func, errorhandler, self)
    end

    self.addonsToLoad[addonName] = nil
end

--[[
    根据插件载入事件唤起回调
    @param {string} addonName 插件名
]]
function S:ADDON_LOADED(_, addonName)
    if not E.initialized or not E.private.WT.skins.enable then
        return
    end

    local object = self.addonsToLoad[addonName]
    if object then
        self:CallLoadedAddon(addonName, object)
    end
end

function S:ReskinWidgets(AceGUI)
    for name, oldFunc in pairs(AceGUI.WidgetRegistry) do
        S:UpdateWidget(AceGUI, name, oldFunc)
    end
end

function S:UpdateWidget(lib, name, oldFunc)
    if self.aceWidgets[name] then
        lib.WidgetRegistry[name] = self.aceWidgets[name](self, oldFunc)
        self.aceWidgets[name] = nil
    end
end
do
    local alreadyWidgetHooked = false
    local alreadyDialogSkined = false
    function S:LibStub_NewLibrary(_, major)
        if major == "AceGUI-3.0" and not alreadyWidgetHooked then
            AceGUI = _G.LibStub("AceGUI-3.0")
            self:ReskinWidgets(AceGUI)
            self:SecureHook(AceGUI, "RegisterWidgetType", "UpdateWidget")
            alreadyWidgetHooked = true
        elseif major == "AceConfigDialog-3.0" and not alreadyDialogSkined then
            self:AceConfigDialog()
            alreadyDialogSkined = true
        end
    end

    function S:HookEarly()
        local AceGUI = _G.LibStub("AceGUI-3.0")
        if AceGUI and not alreadyWidgetHooked then
            self:ReskinWidgets(AceGUI)
            self:SecureHook(AceGUI, "RegisterWidgetType", "UpdateWidget")
            alreadyWidgetHooked = true
        end

        local AceConfigDialog = _G.LibStub("AceConfigDialog-3.0")
        if AceConfigDialog and not alreadyDialogSkined then
            self:AceConfigDialog()
            alreadyDialogSkined = true
        end
    end
end

function S:DisableAddOnSkin(key)
    if _G.AddOnSkins then
        local AS = _G.AddOnSkins[1]
        if AS and AS.db[key] then
            AS:SetOption(key, false)
        end
    end
end

function S:CreateShadowModule(frame)
    if E.private.WT.skins.enable and E.private.WT.skins.windtools and E.private.WT.skins.shadow then
        self:CreateShadow(frame)
    end
end

do
    local isLoaded
    local MER
    local MERS

    local function IsMerathilisUILoaded()
        if isLoaded == nil then
            isLoaded = IsAddOnLoaded("ElvUI_MerathilisUI")
        end

        if isLoaded then
            MER = _G.ElvUI_MerathilisUI and _G.ElvUI_MerathilisUI[1]
            MERS = MER and MER:GetModule("MER_Skins")
        end

        return isLoaded
    end

    function S:MerathilisUISkin(frame)
        if E.private.WT.skins.merathilisUISkin and IsMerathilisUILoaded() then
            if frame.Styling then
                frame:Styling()
            end
        end
    end

    function S:MerathilisUITab(tab)
        if E.private.WT.skins.merathilisUISkin and IsMerathilisUILoaded() and MERS then
            MERS:ReskinTab(tab)
        end
    end
end

do
    local DeleteRegions = {
        "Center",
        "BottomEdge",
        "LeftEdge",
        "RightEdge",
        "TopEdge",
        "BottomLeftCorner",
        "BottomRightCorner",
        "TopLeftCorner",
        "TopRightCorner"
    }
    function S:StripEdgeTextures(frame)
        for _, regionKey in pairs(DeleteRegions) do
            if frame[regionKey] then
                frame[regionKey]:Kill()
            end
        end
    end
end

function S:Reposition(frame, target, border, top, bottom, left, right)
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", target, "TOPLEFT", -left - border, top + border)
    frame:SetPoint("TOPRIGHT", target, "TOPRIGHT", right + border, top + border)
    frame:SetPoint("BOTTOMLEFT", target, "BOTTOMLEFT", -left - border, -bottom - border)
    frame:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", right + border, -bottom - border)
end

-- 初始化，将不需要监视插件载入情况的函数全部进行执行
function S:Initialize()
    if not E.private.WT.skins.enable then
        return
    end

    for index, func in next, self.nonAddonsToLoad do
        xpcall(func, errorhandler, self)
        self.nonAddonsToLoad[index] = nil
    end

    for addonName, object in pairs(self.addonsToLoad) do
        local isLoaded, isFinished = IsAddOnLoaded(addonName)
        if isLoaded and isFinished then
            self:CallLoadedAddon(addonName, object)
        end
    end

    self:HookEarly()
    self:SecureHook(_G.LibStub, "NewLibrary", "LibStub_NewLibrary")

    -- 去除羊皮纸
    if E.private.WT.skins.removeParchment then
        E.private.skins.parchmentRemoverEnable = true
    end
end

S:RegisterEvent("ADDON_LOADED")
S:RegisterEvent("PLAYER_ENTERING_WORLD")
W:RegisterModule(S:GetName())
