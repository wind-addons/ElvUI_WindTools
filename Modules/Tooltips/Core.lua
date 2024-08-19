local W, F, E, L = unpack((select(2, ...)))
local ET = E:GetModule("Tooltip")
local T = W.Modules.Tooltips

local _G = _G
local format = format
local next = next
local pairs = pairs
local select = select
local strfind = strfind
local strsplit = strsplit
local tinsert = tinsert
local type = type
local xpcall = xpcall

local CanInspect = CanInspect
local GameTooltip = GameTooltip
local GetCreatureDifficultyColor = GetCreatureDifficultyColor
local GetGuildInfo = GetGuildInfo
local InCombatLockdown = InCombatLockdown
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local UnitClass = UnitClass
local UnitEffectiveLevel = UnitEffectiveLevel
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitHasVehicleUI = UnitHasVehicleUI
local UnitIsPlayer = UnitIsPlayer
local UnitLevel = UnitLevel
local UnitRace = UnitRace
local UnitReaction = UnitReaction
local UnitSex = UnitSex

local RAID_CLASS_COLORS_PRIEST = RAID_CLASS_COLORS.PRIEST

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

    triedTimes = triedTimes or 0

    local unit = select(2, tt:GetUnit())

    if not unit then
        local GMF = E:GetMouseFocus()
        local focusUnit = GMF and GMF.GetAttribute and GMF:GetAttribute("unit")
        if focusUnit then
            unit = focusUnit
        end
        if not unit or not UnitExists(unit) then
            return
        end
    end

    if not unit or not data or not data.guid then
        return
    end

    local inCombatLockdown = InCombatLockdown()
    local isShiftKeyDown = IsShiftKeyDown()
    local isPlayerUnit = UnitIsPlayer(unit)

    -- Run all registered callbacks (normal)
    for _, func in next, self.normalInspect do
        xpcall(func, F.Developer.ThrowError, self, tt, unit, data.guid)
    end

    -- Item Level
    local itemLevelAvailable = isPlayerUnit and not inCombatLockdown and ET.db.inspectDataEnable

    if self.profiledb.elvUITweaks.forceItemLevel then
        if not isShiftKeyDown and itemLevelAvailable and not tt.ItemLevelShown then
            local _, class = UnitClass(unit)
            local color = class and E:ClassColor(class) or RAID_CLASS_COLORS_PRIEST
            ET:AddInspectInfo(tt, unit, 0, color.r, color.g, color.b)
        end
    end

    -- Modifier callbacks pre-check
    if not self:CheckModifier() or not CanInspect(unit) then
        return
    end

    -- It ElvUI Item Level is enabled, we need to delay the modifier callbacks
    if self.db.forceItemLevel or isShiftKeyDown and itemLevelAvailable then
        if not tt.ItemLevelShown and triedTimes <= 4 then
            E:Delay(0.33, T.InspectInfo, T, tt, data, triedTimes + 1)
            return
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

local genderTable = {_G.UNKNOWN .. " ", _G.MALE .. " ", _G.FEMALE .. " "}

function T:SetUnitText(_, tt, unit, isPlayerUnit)
    if not tt or (tt.IsForbidden and tt:IsForbidden()) or not isPlayerUnit then
        return
    end

    if not self.profiledb.elvUITweaks.specIcon and not self.profiledb.elvUITweaks.raceIcon then -- No need to do anything
        return
    end

    local guildName = GetGuildInfo(unit)
    local levelLine, specLine = ET:GetLevelLine(tt, (guildName and 2) or 1)
    local level, realLevel = UnitEffectiveLevel(unit), UnitLevel(unit)

    if levelLine then
        local diffColor = GetCreatureDifficultyColor(level)
        local race, englishRace = UnitRace(unit)
        local gender = UnitSex(unit)
        local _, localizedFaction = E:GetUnitBattlefieldFaction(unit)
        if localizedFaction and (englishRace == "Pandaren" or englishRace == "Dracthyr") then
            race = localizedFaction .. " " .. race
        end
        local hexColor = E:RGBToHex(diffColor.r, diffColor.g, diffColor.b)
        local unitGender = ET.db.gender and genderTable[gender]
        local raceIcon = F.GetRaceAtlasString(englishRace, gender, ET.db.textFontSize, ET.db.textFontSize)
        if raceIcon and self.profiledb.elvUITweaks.raceIcon then
            race = raceIcon .. " " .. race
        end

        local levelText
        if level < realLevel then
            levelText =
                format(
                "%s%s|r |cffFFFFFF(%s)|r %s%s",
                hexColor,
                level > 0 and level or "??",
                realLevel,
                unitGender or "",
                race or ""
            )
        else
            levelText = format("%s%s|r %s%s", hexColor, level > 0 and level or "??", unitGender or "", race or "")
        end

        local specText = specLine and specLine:GetText()
        if specText then
            local localeClass, class, classID = UnitClass(unit)
            if not localeClass or not class then
                return
            end

            local nameColor = E:ClassColor(class) or RAID_CLASS_COLORS_PRIEST

            local specIcon

            -- Because inspect need some extra time, we can extract the sepcialization info just from the text
            if self.profiledb.elvUITweaks.specIcon and classID and W.SpecializationInfo[classID] then
                for _, spec in next, W.SpecializationInfo[classID] do
                    if strfind(specText, spec.name) then
                        specIcon = spec.icon
                        break
                    end
                end
            end

            if specIcon then
                local iconString = F.GetIconString(specIcon, ET.db.textFontSize, ET.db.textFontSize + 3, true)
                specText = iconString .. " " .. specText
            end

            specLine:SetFormattedText("|c%s%s|r", nameColor.colorStr, specText)
        end

        levelLine:SetFormattedText(levelText)
    end
end

function T:Initialize()
    self.db = E.private.WT.tooltips
    self.profiledb = E.db.WT.tooltips
    for index, func in next, self.load do
        xpcall(func, F.Developer.ThrowError, self)
        self.load[index] = nil
    end

    for name, _ in pairs(self.eventCallback) do
        T:RegisterEvent(name, "Event")
    end

    T:SecureHook(ET, "SetUnitText", "SetUnitText")
    T:SecureHook(ET, "RemoveTrashLines", "ElvUIRemoveTrashLines")
    T:SecureHookScript(GameTooltip, "OnTooltipCleared", "ClearInspectInfo")

    self.initialized = true
end

function T:ProfileUpdate()
    self.profiledb = E.db.WT.tooltips
    for index, func in next, self.updateProfile do
        xpcall(func, F.Developer.ThrowError, self)
        self.updateProfile[index] = nil
    end
end

W:RegisterModule(T:GetName())
