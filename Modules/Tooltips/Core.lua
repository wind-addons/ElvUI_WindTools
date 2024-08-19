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

local HIGHLIGHT_FONT_COLOR = HIGHLIGHT_FONT_COLOR
local RAID_CLASS_COLORS_PRIEST = RAID_CLASS_COLORS.PRIEST

local C_PlayerInfo_GetPlayerMythicPlusRatingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary
local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local C_ChallengeMode_GetSpecificDungeonOverallScoreRarityColor =
    C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor

T.load = {} -- functions that need to be called when module is loaded
T.updateProfile = {} -- functions that need to be called when profile is updated
T.modifierInspect = {}
T.normalInspect = {}
T.clearInspect = {}
T.eventCallback = {}

local mythicPlusDataCache = {}

function T:AddCallback(name, func)
    tinsert(self.load, func or self[name])
end

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

function T:GetMythicPlusData(unit)
    local guid = UnitGUID(unit)
    if not guid then
        return
    end
    local now = time()
    if mythicPlusDataCache[guid] and now - mythicPlusDataCache[guid].updated < 60 then
        return mythicPlusDataCache[guid]
    end

    local data = C_PlayerInfo_GetPlayerMythicPlusRatingSummary(unit)
    if not data then
        return
    end
    data.updated = now

    local runs = data and data.runs

    if data and data.runs then
        local highestScore, highestScoreDungeonID, highestScoreDungeonIndex
        for i, run in pairs(data.runs) do
            local metadata = W.MythicPlusMapData[run.challengeModeID]

            if not highestScore or run.mapScore > highestScore then
                highestScore = run.mapScore
                highestScoreDungeon = run.challengeModeID
                highestScoreDungeonIndex = i
            end

            if metadata and metadata.timers then
                local sec = run.bestRunDurationMS / 1000
                local timers = metadata.timers
                run.upgrades = (sec <= timers[1] and 3) or (sec <= timers[2] and 2) or (run.finishedSuccess and 1) or 0
            end

            run.mapScoreColor =
                C_ChallengeMode_GetSpecificDungeonOverallScoreRarityColor(run.mapScore) or HIGHLIGHT_FONT_COLOR
            run.bestRunLevelColor = run.finishedSuccess and "ffffff" or "aaaaaa"
        end

        if highestScore then
            data.highestScoreDungeonID = highestScoreDungeon
            data.highestScoreDungeonIndex = highestScoreDungeonIndex
        end
    end

    data.currentSeasonScoreColor =
        (ET.db.dungeonScoreColor and C_ChallengeMode_GetDungeonScoreRarityColor(data.currentSeasonScore)) or
        HIGHLIGHT_FONT_COLOR

    mythicPlusDataCache[guid] = data
    return data
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

function T:AddMythicInfo(mod, tt, unit)
    if not self.profiledb or not self.profiledb.elvUITweaks.betterMythicPlusInfo then
        return self.hooks[mod].AddMythicInfo(mod, tt, unit)
    end

    local data = self:GetMythicPlusData(unit)
    if not data or not data.currentSeasonScore or data.currentSeasonScore <= 0 then
        return self.hooks[mod].AddMythicInfo(mod, tt, unit)
    end

    if ET.db.dungeonScore then
        tt:AddDoubleLine(
            L["M+ Score"],
            data.currentSeasonScore,
            nil,
            nil,
            nil,
            data.currentSeasonScoreColor.r,
            data.currentSeasonScoreColor.g,
            data.currentSeasonScoreColor.b
        )
    end

    if ET.db.mythicBestRun then
        local mapData = data.highestScoreDungeonID and W.MythicPlusMapData[data.highestScoreDungeonID]
        local run = data.highestScoreDungeonIndex and data.runs and data.runs[data.highestScoreDungeonIndex]
        if mapData and run then
            local bestRunLevelText
            if run.finishedSuccess and run.mapScoreColor then
                bestRunLevelText = run.mapScoreColor:WrapTextInColorCode(run.bestRunLevel)
            else
                bestRunLevelText = format("|cff%s%s|r", run.bestRunLevelColor, run.bestRunLevel)
            end
            if bestRunLevelText then
                for i = 1, run.upgrades do
                    bestRunLevelText = "+" .. bestRunLevelText
                end

                local right =
                    format(
                    "%s %s | %s",
                    F.GetIconString(mapData.tex, ET.db.textFontSize, ET.db.textFontSize + 3, true),
                    F.CreateColorString(mapData.abbr, E.db.general.valuecolor),
                    bestRunLevelText
                )
                tt:AddDoubleLine(
                    L["M+ Best Run"],
                    right,
                    nil,
                    nil,
                    nil,
                    HIGHLIGHT_FONT_COLOR.r,
                    HIGHLIGHT_FONT_COLOR.g,
                    HIGHLIGHT_FONT_COLOR.b
                )
            end
        end
    end
end

local genderTable = {_G.UNKNOWN .. " ", _G.MALE .. " ", _G.FEMALE .. " "}

function T:SetUnitText(_, tt, unit, isPlayerUnit)
    if not tt or (tt.IsForbidden and tt:IsForbidden()) or not isPlayerUnit then
        return
    end

    local etdb = self.profiledb and self.profiledb.elvUITweaks
    if not etdb or etdb.specIcon and not etdb.raceIcon then -- No need to do anything
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

        if etdb.raceIcon then
            local raceIcon = F.GetRaceAtlasString(englishRace, gender, ET.db.textFontSize, ET.db.textFontSize)
            if raceIcon then
                race = raceIcon .. " " .. race
            end
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
            if etdb.specIcon and classID and W.SpecializationInfo[classID] then
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

    T:RawHook(ET, "AddMythicInfo")
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
