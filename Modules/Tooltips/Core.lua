local W, F, E, L = unpack(select(2, ...))
local ET = E:GetModule("Tooltip")
local T = W.Modules.Tooltips

local _G = _G
local next = next
local pairs = pairs
local select = select
local strsplit = strsplit
local tinsert = tinsert
local type = type
local xpcall = xpcall

local CanInspect = CanInspect
local GameTooltip =GameTooltip
local InCombatLockdown = InCombatLockdown
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local UnitGUID = UnitGUID

T.load = {} -- 毋须等待插件的函数表
T.updateProfile = {} -- 配置更新后的函数表
T.modifierInspect = {}
T.normalInspect = {}
T.clearInspect = {}
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

function T:AddInspectInfoCallback(priority, inspectFunction, useModifier, clearFunction)
    if type(inspectFunction) == "string" then
        inspectFunction = self[inspectFunction]
    end

    if useModifier then
        self.modifierInspect[priority] = inspectFunction
    else
        self.normalInspect[priority] = inspectFunction
    end

    if clearFunction then
        if type(clearFunction) == "string" then
            clearFunction = self[clearFunction]
        end
        self.clearInspect[priority] = clearFunction
    end
end

function T:ClearInspectInfo(tt)
    if tt:IsForbidden() then
        return
    end

    -- Run all registered callbacks (clear)
    for _, func in next, self.clearInspect do
        xpcall(func, F.Developer.ThrowError, self, tt)
    end
end

function T:CheckModifier()
    if not self.db or self.db.modifier == "NONE" then
        return true
    end

    local modifierStatus = {
        SHIFT = IsShiftKeyDown(),
        ALT = IsAltKeyDown(),
        CTRL = IsControlKeyDown()
    }

    local results = {}
    for _, modifier in next, {strsplit("_", self.db.modifier)} do
        tinsert(results, modifierStatus[modifier] or false)
    end

    for _, v in next, results do
        if not v then
            return false
        end
    end

    return true
end

function T:InspectInfo(tt, data, triedTimes)
    if tt ~= GameTooltip or (tt.IsForbidden and tt:IsForbidden()) or (ET.db and not ET.db.visibility) then
        return
    end

    if tt.windInspectLoaded then
        return
    end

    local unit = select(2, tt:GetUnit())

    if not unit or not data or not data.guid then
        return
    end

    -- Run all registered callbacks (normal)
    for _, func in next, self.normalInspect do
        xpcall(func, F.Developer.ThrowError, self, tt, unit, data.guid)
    end

    if not self:CheckModifier() or not CanInspect(unit) then
        return
    end

    -- If ElvUI is inspecting, just wait for 4 seconds
    triedTimes = triedTimes or 0
    if triedTimes > 20 then
        return
    end

    if not InCombatLockdown() and IsShiftKeyDown() and ET.db.inspectDataEnable then
        local isElvUITooltipItemLevelInfoAlreadyAdded = false
        for i = #(data.lines), tt:NumLines() do
            local leftTip = _G["GameTooltipTextLeft" .. i]
            local leftTipText = leftTip:GetText()
            if leftTipText and leftTipText == L["Item Level:"] and leftTip:IsShown() then
                isElvUITooltipItemLevelInfoAlreadyAdded = true
                break
            end
        end

        if not isElvUITooltipItemLevelInfoAlreadyAdded then
            return E:Delay(0.2, T.InspectInfo, T, ET, tt, data, triedTimes + 1)
        end
    end

    -- Run all registered callbacks (modifier)
    for _, func in next, self.modifierInspect do
        xpcall(func, F.Developer.ThrowError, self, tt, unit, data.guid)
    end

    tt.windInspectLoaded = true
end

function T:ElvUIRemoveTrashLines(_, tt)
    tt.windInspectLoaded = false
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
            xpcall(func, F.Developer.ThrowError, self, event, ...)
        end
    end
end

ET._GameTooltip_OnTooltipSetUnit = ET.GameTooltip_OnTooltipSetUnit
function ET.GameTooltip_OnTooltipSetUnit(...)
    ET._GameTooltip_OnTooltipSetUnit(...)

    if not T or not T.initialized then
        return
    end

    T:InspectInfo(...)
end

function T:Initialize()
    self.db = E.private.WT.tooltips
    for index, func in next, self.load do
        xpcall(func, F.Developer.ThrowError, self)
        self.load[index] = nil
    end

    for name, _ in pairs(self.eventCallback) do
        T:RegisterEvent(name, "Event")
    end

    T:SecureHook(ET, "RemoveTrashLines", "ElvUIRemoveTrashLines")
    T:SecureHookScript(GameTooltip, "OnTooltipCleared", "ClearInspectInfo")

    self.initialized = true
end

function T:ProfileUpdate()
    for index, func in next, self.updateProfile do
        xpcall(func, F.Developer.ThrowError, self)
        self.updateProfile[index] = nil
    end
end

W:RegisterModule(T:GetName())
