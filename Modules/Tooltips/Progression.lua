local W, F, E, L = unpack(select(2, ...))
local ET = E:GetModule("Tooltip")
local T = W:GetModule("Tooltips")

local _G = _G
local format = format
local ipairs = ipairs
local pairs = pairs
local select = select
local strfind = strfind
local tonumber = tonumber

local AchievementFrame_LoadUI = AchievementFrame_LoadUI
local CanInspect = CanInspect
local ClearAchievementComparisonUnit = ClearAchievementComparisonUnit
local GetComparisonStatistic = GetComparisonStatistic
local GetStatistic = GetStatistic
local GetTime = GetTime
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local SetAchievementComparisonUnit = SetAchievementComparisonUnit
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitLevel = UnitLevel
local UnitRace = UnitRace

local C_CreatureInfo_GetFactionInfo = C_CreatureInfo.GetFactionInfo
local MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL

local loadedComparison
local compareGUID
local cache = {}

local tiers = {
    "Castle Nathria"
}

local levels = {
    "Mythic",
    "Heroic",
    "Normal",
    "Raid Finder"
}

local locales = {
    ["Raid Finder"] = {
        short = L["[ABBR] Raid Finder"],
        full = L["Raid Finder"]
    },
    ["Normal"] = {
        short = L["[ABBR] Normal"],
        full = L["Normal"]
    },
    ["Heroic"] = {
        short = L["[ABBR] Heroic"],
        full = L["Heroic"]
    },
    ["Mythic"] = {
        short = L["[ABBR] Mythic"],
        full = L["Mythic"]
    },
    ["Castle Nathria"] = {
        short = L["[ABBR] Castle Nathria"],
        full = L["Castle Nathria"]
    },
    ["The Necrotic Wake"] = {
        short = L["[ABBR] The Necrotic Wake"],
        full = L["The Necrotic Wake"]
    },
    ["Plaguefall"] = {
        short = L["[ABBR] Plaguefall"],
        full = L["Plaguefall"]
    },
    ["Mists of Tirna Scithe"] = {
        short = L["[ABBR] Mists of Tirna Scithe"],
        full = L["Mists of Tirna Scithe"]
    },
    ["Halls of Atonement"] = {
        short = L["[ABBR] Halls of Atonement"],
        full = L["Halls of Atonement"]
    },
    ["Theater of Pain"] = {
        short = L["[ABBR] Theater of Pain"],
        full = L["Theater of Pain"]
    },
    ["De Other Side"] = {
        short = L["[ABBR] De Other Side"],
        full = L["De Other Side"]
    },
    ["Spires of Ascension"] = {
        short = L["[ABBR] Spires of Ascension"],
        full = L["Spires of Ascension"]
    },
    ["Sanguine Depths"] = {
        short = L["[ABBR] Sanguine Depths"],
        full = L["Sanguine Depths"]
    }
}

local raidAchievements = {
    ["Castle Nathria"] = {
        ["Mythic"] = {
            14421,
            14425,
            14429,
            14433,
            14437,
            14441,
            14445,
            14449,
            14453,
            14457
        },
        ["Heroic"] = {
            14420,
            14424,
            14428,
            14432,
            14436,
            14440,
            14444,
            14448,
            14452,
            14456
        },
        ["Normal"] = {
            14419,
            14423,
            14427,
            14431,
            14435,
            14439,
            14443,
            14447,
            14451,
            14455
        },
        ["Raid Finder"] = {
            14422,
            14426,
            14430,
            14434,
            14438,
            14442,
            14446,
            14450,
            14454,
            14458
        }
    }
}

local dungeonAchievements = {
    ["The Necrotic Wake"] = 14404,
    ["Plaguefall"] = 14398,
    ["Mists of Tirna Scithe"] = 14395,
    ["Halls of Atonement"] = 14392,
    ["Theater of Pain"] = 14407,
    ["De Other Side"] = 14389,
    ["Spires of Ascension"] = 14401,
    ["Sanguine Depths"] = 14205
}

local function GetLevelColoredString(level, short)
    local color = "ff8000"

    if level == "Mythic" then
        color = "a335ee"
    elseif level == "Heroic" then
        color = "0070dd"
    elseif level == "Normal" then
        color = "1eff00"
    end

    if short then
        return "|cff" .. color .. locales[level].short .. "|r"
    else
        return "|cff" .. color .. locales[level].full .. "|r"
    end
end

local function GetBossKillTimes(guid, achievementID)
    local func = guid == E.myguid and GetStatistic or GetComparisonStatistic
    return tonumber(func(achievementID), 10) or 0
end

local function UpdateProgression(guid, faction)
    local db = E.private.WT.tooltips.progression

    cache[guid] = cache[guid] or {}
    cache[guid].info = cache[guid].info or {}
    cache[guid].timer = GetTime()

    -- 团本
    if db.raids.enable then
        cache[guid].info.raids = {}
        for _, tier in ipairs(tiers) do
            if db.raids[tier] then
                cache[guid].info.raids[tier] = {}
                local bosses = raidAchievements[tier]
                if bosses.separated then
                    bosses = bosses[faction]
                end

                for _, level in ipairs(levels) do
                    local alreadyKilled = 0
                    for _, achievementID in pairs(bosses[level]) do
                        if GetBossKillTimes(guid, achievementID) > 0 then
                            alreadyKilled = alreadyKilled + 1
                        end
                    end

                    if alreadyKilled > 0 then
                        cache[guid].info.raids[tier][level] = format("%d/%d", alreadyKilled, #bosses[level])
                        if alreadyKilled == #bosses[level] then
                            break -- 全通本难度后毋须扫描更低难度进度
                        end
                    end
                end
            end
        end
    end

    -- 传奇地下城
    if db.mythicDungeons.enable then
        cache[guid].info.mythicDungeons = {}

        -- 挑战模式次数
        cache[guid].info.mythicDungeons.times = GetBossKillTimes(guid, 7399)

        -- 传奇副本尾王击杀次数
        for name, achievementID in pairs(dungeonAchievements) do
            if db.mythicDungeons[name] then
                cache[guid].info.mythicDungeons[name] = GetBossKillTimes(guid, achievementID)
            end
        end
    end
end

local function SetProgressionInfo(guid, tt)
    if not cache[guid] then
        return
    end

    local db = E.private.WT.tooltips.progression

    local updated = false

    for i = 1, tt:NumLines() do
        local leftTip = _G["GameTooltipTextLeft" .. i]
        local leftTipText = leftTip:GetText()
        local found = false

        if leftTipText then
            if db.raids.enable then -- 团本进度
                for _, tier in ipairs(tiers) do
                    if db.raids[tier] then
                        for _, level in ipairs(levels) do
                            if strfind(leftTipText, locales[tier].short) and strfind(leftTipText, locales[level].full) then
                                local rightTip = _G["GameTooltipTextRight" .. i]
                                leftTip:SetText(
                                    format("%s %s:", locales[tier].short, GetLevelColoredString(level, false))
                                )
                                rightTip:SetText(cache[guid].info.raids[tier][level])
                                updated = true
                                found = true
                                break
                            end
                        end

                        if found then
                            break
                        end
                    end
                end
            end

            found = false

            if db.mythicDungeons.enable then -- 地下城进度
                for name, achievementID in pairs(dungeonAchievements) do
                    if db.mythicDungeons[name] then
                        if strfind(leftTipText, locales[name].short) then
                            local rightTip = _G["GameTooltipTextRight" .. i]
                            leftTip:SetText(locales[name].short .. ":")
                            rightTip:SetText(cache[guid].info.mythicDungeons[name])
                            updated = true
                            found = true
                            break
                        end
                        if found then
                            break
                        end
                    end
                end
            end
        end
    end

    if updated then
        return
    end

    local icon = F.GetIconString(W.Media.Textures.smallLogo, 12)

    if db.raids.enable then -- 团本进度
        tt:AddLine(" ")
        tt:AddDoubleLine(L["Raids"], icon, nil, nil, nil, 1, 1, 1)

        for _, tier in ipairs(tiers) do
            if db.raids[tier] then
                for _, level in ipairs(levels) do
                    if (cache[guid].info.raids[tier][level]) then
                        local left = format("%s %s:", locales[tier].short, GetLevelColoredString(level, false))
                        local right = GetLevelColoredString(level, true) .. " " .. cache[guid].info.raids[tier][level]

                        tt:AddDoubleLine(left, right, nil, nil, nil, 1, 1, 1)
                    end
                end
            end
        end
    end

    if db.mythicDungeons.enable then -- 地下城进度
        tt:AddLine(" ")
        local titleLeft = L["Mythic Dungeons"] .. " [" .. cache[guid].info.mythicDungeons.times .. "]"
        tt:AddDoubleLine(titleLeft, icon, nil, nil, nil, 1, 1, 1)
        for name, achievementID in pairs(dungeonAchievements) do
            if db.mythicDungeons[name] then
                local left = format("%s:", locales[name].short)
                local right = cache[guid].info.mythicDungeons[name]

                tt:AddDoubleLine(left, right, nil, nil, nil, 1, 1, 1)
            end
        end
    end
end

function T:AddProgression(_, tt, unit, numTries, r, g, b)
    if not E.private.WT.tooltips.progression.enable then
        return
    end

    if InCombatLockdown() then
        return
    end

    if not (unit and CanInspect(unit)) then
        return
    end

    local level = UnitLevel(unit)
    if not (level and level == MAX_PLAYER_LEVEL) then
        return
    end

    local guid = UnitGUID(unit)

    if not IsAddOnLoaded("Blizzard_AchievementUI") then
        AchievementFrame_LoadUI()
    end

    if not cache[guid] or (GetTime() - cache[guid].timer) > 600 then
        if guid == E.myguid then
            UpdateProgression(guid, E.myfaction)
        else
            ClearAchievementComparisonUnit()

            if not loadedComparison and select(2, IsAddOnLoaded("Blizzard_AchievementUI")) then
                _G.AchievementFrame_DisplayComparison(unit)
                HideUIPanel(_G.AchievementFrame)
                ClearAchievementComparisonUnit()
                loadedComparison = true
            end

            compareGUID = guid

            if SetAchievementComparisonUnit(unit) then
                T:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
            end

            return
        end
    end

    SetProgressionInfo(guid, tt)
end

function T:INSPECT_ACHIEVEMENT_READY(event, GUID)
    if (compareGUID ~= GUID) then
        return
    end

    local unit = "mouseover"

    if UnitExists(unit) then
        local race = select(3, UnitRace(unit))
        local faction = race and C_CreatureInfo_GetFactionInfo(race).groupTag
        if faction then
            UpdateProgression(GUID, faction)
            _G.GameTooltip:SetUnit(unit)
        end
    end

    ClearAchievementComparisonUnit()

    self:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
end

function T:Progression()
    T:SecureHook(ET, "AddInspectInfo", "AddProgression")
end

T:AddCallback("Progression")
