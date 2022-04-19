local W, F, E, L = unpack(select(2, ...))
local ET = E:GetModule("Tooltip")
local T = W:GetModule("Tooltips")

local _G = _G

local next = next
local pairs = pairs
local select = select
local tinsert = tinsert
local type = type
local xpcall = xpcall

local CanInspect = CanInspect
local IsShiftKeyDown = IsShiftKeyDown
local UnitGUID = UnitGUID

T.load = {} -- 毋须等待插件的函数表
T.updateProfile = {} -- 配置更新后的函数表
T.inspect = {}
T.eventCallback = {}

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
    @param {function} [func=T.name] 回调函数
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

function T:AddInspectInfoCallback(priority, func)
    if type(func) == "string" then
        func = self[func]
    end
    T.inspect[priority] = func
end

function T:InspectInfo(_, tt, triedTimes)
    if not IsShiftKeyDown() or tt:IsForbidden() then
        return
    end

    local unit = select(2, tt:GetUnit())
    if not unit or not CanInspect(unit) then
        return
    end

    local guid = UnitGUID(unit)

    -- If ElvUI is inspecting, just wait for 2 seconds
    triedTimes = triedTimes or 0
    if triedTimes > 20 then
        return
    end

    if ET.db.inspectDataEnable then
        local isElvUITooltipItemLevelInfoAlreadyAdded = false

        for i = 1, tt:NumLines() do
            local leftTip = _G["GameTooltipTextLeft" .. i]
            local leftTipText = leftTip:GetText()
            if leftTipText and leftTipText == L["Item Level:"] then
                isElvUITooltipItemLevelInfoAlreadyAdded = true
                break
            end
        end

        if not isElvUITooltipItemLevelInfoAlreadyAdded then
            E:Delay(0.2, T.InspectInfo, T, ET, tt, triedTimes + 1)
            return
        end
    end

    -- Run all registered callbacks
    for _, func in next, self.inspect do
        xpcall(func, errorhandler, self, tt, unit, guid)
    end
end

function T:AddEventCallback(eventName, func)
    if type(func) == "string" then
        func = self[func]
    end
    if self.eventCallback[eventName] then
        tinsert(self.eventCallback[eventName], func)
    else
        self.eventCallback[eventName] = {func}
    end
end

function T:Event(event, ...)
    if self.eventCallback[event] then
        for _, func in next, self.eventCallback[event] do
            xpcall(func, errorhandler, self, event, ...)
        end
    end
end

function T:Initialize()
    self.db = E.private.WT.tooltips

    for index, func in next, self.load do
        xpcall(func, errorhandler, T)
        self.load[index] = nil
    end

    for name, _ in pairs(self.eventCallback) do
        T:RegisterEvent(name, "Event")
    end

    T:SecureHook(ET, "GameTooltip_OnTooltipSetUnit", "InspectInfo")
end

function T:ProfileUpdate()
    for index, func in next, self.updateProfile do
        xpcall(func, errorhandler, self)
        self.updateProfile[index] = nil
    end
end

W:RegisterModule(T:GetName())
