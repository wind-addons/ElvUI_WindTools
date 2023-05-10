local W, F, E, L = unpack((select(2, ...)))
local ET = E:GetModule("Tooltip")
local T = W.Modules.Tooltips

local _G = _G
local format = format
local gsub = gsub
local ipairs = ipairs
local next = next
local pairs = pairs
local select = select
local strfind = strfind
local tonumber = tonumber
local unpack = unpack

local AchievementFrame_LoadUI = AchievementFrame_LoadUI
local ClearAchievementComparisonUnit = ClearAchievementComparisonUnit
local GetAchievementComparisonInfo = GetAchievementComparisonInfo
local GetAchievementInfo = GetAchievementInfo
local GetComparisonStatistic = GetComparisonStatistic
local GetStatistic = GetStatistic
local GetTime = GetTime
local HideUIPanel = HideUIPanel
local IsAddOnLoaded = IsAddOnLoaded
local SetAchievementComparisonUnit = SetAchievementComparisonUnit
local UnitExists = UnitExists
local UnitLevel = UnitLevel
local UnitRace = UnitRace

local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_ChallengeMode_GetSpecificDungeonOverallScoreRarityColor =
    C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor
local C_CreatureInfo_GetFactionInfo = C_CreatureInfo.GetFactionInfo
local C_PlayerInfo_GetPlayerMythicPlusRatingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary

local HIGHLIGHT_FONT_COLOR = HIGHLIGHT_FONT_COLOR
local MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL

local starIconString = format("|T%s:0|t ", W.Media.Icons.star)

local loadedComparison
local compareGUID
local cache = {}

local tiers = {
    "Vault of the Incarnates",
    "Aberrus, the Shadowed Crucible"
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
    ["Dragonflight Keystone Master: Season One"] = {
        short = L["[ABBR] Dragonflight Keystone Master: Season One"],
        full = L["Dragonflight Keystone Master: Season One"]
    },
    ["Dragonflight Keystone Hero: Season One"] = {
        short = L["[ABBR] Dragonflight Keystone Hero: Season One"],
        full = L["Dragonflight Keystone Hero: Season One"]
    },
    ["Dragonflight Keystone Master: Season Two"] = {
        short = L["[ABBR] Dragonflight Keystone Master: Season Two"],
        full = L["Dragonflight Keystone Master: Season Two"]
    },
    ["Dragonflight Keystone Hero: Season Two"] = {
        short = L["[ABBR] Dragonflight Keystone Hero: Season Two"],
        full = L["Dragonflight Keystone Hero: Season Two"]
    },
    ["Vault of the Incarnates"] = {
        short = L["[ABBR] Vault of the Incarnates"],
        full = L["Vault of the Incarnates"]
    },
    ["Aberrus, the Shadowed Crucible"] = {
        short = L["[ABBR] Aberrus, the Shadowed Crucible"],
        full = L["Aberrus, the Shadowed Crucible"]
    },
    ["Neltharion's Lair"] = {
        short = L["[ABBR] Neltharion's Lair"],
        full = L["Neltharion's Lair"]
    },
    ["Freehold"] = {
        short = L["[ABBR] Freehold"],
        full = L["Freehold"]
    },
    ["The Underrot"] = {
        short = L["[ABBR] The Underrot"],
        full = L["The Underrot"]
    },
    ["Uldaman: Legacy of Tyr"] = {
        short = L["[ABBR] Uldaman: Legacy of Tyr"],
        full = L["Uldaman: Legacy of Tyr"]
    },
    ["Neltharus"] = {
        short = L["[ABBR] Neltharus"],
        full = L["Neltharus"]
    },
    ["Brackenhide Hollow"] = {
        short = L["[ABBR] Brackenhide Hollow"],
        full = L["Brackenhide Hollow"]
    },
    ["Halls of Infusion"] = {
        short = L["[ABBR] Halls of Infusion"],
        full = L["Halls of Infusion"]
    },
    ["The Vortex Pinnacle"] = {
        short = L["[ABBR] The Vortex Pinnacle"],
        full = L["The Vortex Pinnacle"]
    }
}

local raidAchievements = {
    ["Vault of the Incarnates"] = {
        ["Mythic"] = {
            16387,
            16388,
            16389,
            16390,
            16391,
            16392,
            16393,
            16394
        },
        ["Heroic"] = {
            16379,
            16380,
            16381,
            16382,
            16383,
            16384,
            16385,
            16386
        },
        ["Normal"] = {
            16371,
            16372,
            16373,
            16374,
            16375,
            16376,
            16377,
            16378
        },
        ["Raid Finder"] = {
            16359,
            16361,
            16362,
            16366,
            16367,
            16368,
            16369,
            16370
        }
    },
    ["Aberrus, the Shadowed Crucible"] = {
        ["Mythic"] = {
            18219,
            18220,
            18221,
            18222,
            18223,
            18224,
            18225,
            18226,
            18227
        },
        ["Heroic"] = {
            18210,
            18211,
            18212,
            18213,
            18214,
            18215,
            18216,
            18217,
            18218
        },
        ["Normal"] = {
            18189,
            18190,
            18191,
            18192,
            18194,
            18195,
            18196,
            18197,
            18198
        },
        ["Raid Finder"] = {
            18180,
            18181,
            18182,
            18183,
            18184,
            18185,
            18186,
            18188,
            18187
        }
    }
}

local mythicKeystoneDungeons = {
    [206] = "Neltharion's Lair",
    [245] = "Freehold",
    [251] = "The Underrot",
    [403] = "Uldaman: Legacy of Tyr",
    [404] = "Neltharus",
    [405] = "Brackenhide Hollow",
    [406] = "Halls of Infusion",
    [438] = "The Vortex Pinnacle"
}

local specialAchievements = {
    {16649, "Dragonflight Keystone Master: Season One"},
    {16650, "Dragonflight Keystone Hero: Season One"},
    {17844, "Dragonflight Keystone Master: Season Two"},
    {17845, "Dragonflight Keystone Hero: Season Two"}
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

local function GetAchievementInfoByID(guid, achievementID)
    local completed, month, day, year
    if guid == E.myguid then
        completed, month, day, year = select(4, GetAchievementInfo(achievementID))
    else
        completed, month, day, year = GetAchievementComparisonInfo(achievementID)
    end
    return completed, month, day, year
end

local function UpdateProgression(guid, unit, faction)
    local db = E.private.WT.tooltips.progression

    cache[guid] = cache[guid] or {}
    cache[guid].info = cache[guid].info or {}
    cache[guid].timer = GetTime()

    -- 成就
    if db.special.enable then
        cache[guid].info.special = {}
        for _, specialAchievement in pairs(specialAchievements) do
            local achievementID, name = unpack(specialAchievement)
            if db.special[name] then
                local completed, month, day, year = GetAchievementInfoByID(guid, achievementID)
                local completedString = "|cff888888" .. L["Not Completed"] .. "|r"
                if completed then
                    completedString = gsub(L["%month%-%day%-%year%"], "%%year%%", 2000 + year)
                    completedString = gsub(completedString, "%%month%%", month)
                    completedString = gsub(completedString, "%%day%%", day)
                end
                cache[guid].info.special[name] = completedString
            end
        end
    end

    -- 团本
    if db.raids.enable then
        cache[guid].info.raids = {}
        for _, tier in ipairs(tiers) do
            if db.raids[tier] then
                local tempInfo = {}
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
                        tempInfo[level] = format("%d/%d", alreadyKilled, #bosses[level])
                        if alreadyKilled == #bosses[level] then
                            break -- 全通本难度后毋须扫描更低难度进度
                        end
                    end
                end
                if next(tempInfo) then
                    cache[guid].info.raids[tier] = tempInfo
                end
            end
        end
    end

    -- 传奇地下城
    if db.mythicDungeons.enable then
        cache[guid].info.mythicDungeons = {}
        local summary = C_PlayerInfo_GetPlayerMythicPlusRatingSummary(unit)
        local runs = summary and summary.runs
        local tempHighestScore, tempHighestScoreDungeon

        if runs then
            for _, info in ipairs(runs) do
                local name =
                    mythicKeystoneDungeons[info.challengeModeID] or C_ChallengeMode_GetMapUIInfo(info.challengeModeID)
                local scoreColor =
                    C_ChallengeMode_GetSpecificDungeonOverallScoreRarityColor(info.mapScore) or HIGHLIGHT_FONT_COLOR
                local levelColor = info.finishedSuccess and "|cffffffff" or "|cffaaaaaa"
                cache[guid].info.mythicDungeons[name] =
                    format(
                    "%s (%s)",
                    scoreColor:WrapTextInColorCode(info.mapScore),
                    levelColor .. info.bestRunLevel .. "|r"
                )

                if db.mythicDungeons.markHighestScore then
                    if not tempHighestScore or info.mapScore > tempHighestScore then
                        tempHighestScore = info.mapScore
                        tempHighestScoreDungeon = name
                    end
                end
            end
        end

        cache[guid].info.mythicDungeons.highestScoreDungeon = tempHighestScoreDungeon
    end
end

local function SetProgressionInfo(tt, guid)
    if not cache[guid] then
        return
    end

    local db = E.private.WT.tooltips.progression

    -- Special Achievements
    if db.special.enable and cache[guid].info.special and next(cache[guid].info.special) then
        tt:AddLine(" ")
        if db.header == "TEXTURE" then
            tt:AddLine(F.GetCustomHeader("SpecialAchievements", 0.618), 0, 0, true)
        elseif db.header == "TEXT" then
            tt:AddLine(L["Special Achievements"])
        end

        for _, specialAchievement in pairs(specialAchievements) do
            local achievementID, name = unpack(specialAchievement)
            if db.special[name] then
                local left = format("%s:", locales[name].short)
                local right = cache[guid].info.special[name]

                tt:AddDoubleLine(left, right, nil, nil, nil, 1, 1, 1)
            end
        end
    end

    -- Raids
    if db.raids.enable and cache[guid].info.raids and next(cache[guid].info.raids) then
        tt:AddLine(" ")
        if db.header == "TEXTURE" then
            tt:AddLine(F.GetCustomHeader("Raids", 0.618), 0, 0, true)
        elseif db.header == "TEXT" then
            tt:AddLine(L["Raids"])
        end
        for _, tier in ipairs(tiers) do
            if db.raids[tier] then
                for _, level in ipairs(levels) do
                    if cache[guid].info.raids[tier] and cache[guid].info.raids[tier][level] then
                        local left = format("%s %s:", locales[tier].short, GetLevelColoredString(level, false))
                        local right = GetLevelColoredString(level, true) .. " " .. cache[guid].info.raids[tier][level]

                        tt:AddDoubleLine(left, right, nil, nil, nil, 1, 1, 1)
                    end
                end
            end
        end
    end

    -- Mythic+ scores
    local displayMythicDungeons = false
    if db.mythicDungeons.showNoRecord then
        displayMythicDungeons = true
    else
        for name, _ in pairs(cache[guid].info.mythicDungeons) do
            if db.mythicDungeons[name] then
                displayMythicDungeons = true
                break
            end
        end
    end

    if db.mythicDungeons.enable and cache[guid].info.mythicDungeons and displayMythicDungeons then
        local highestScoreDungeon = cache[guid].info.mythicDungeons.highestScoreDungeon

        tt:AddLine(" ")
        if db.header == "TEXTURE" then
            tt:AddLine(F.GetCustomHeader("MythicDungeons", 0.618), 0, 0, true)
        elseif db.header == "TEXT" then
            tt:AddLine(L["Mythic Dungeons"])
        end
        for id, name in pairs(mythicKeystoneDungeons) do
            if db.mythicDungeons[name] then
                local left = format("%s:", locales[name].short)
                local right = cache[guid].info.mythicDungeons[name]
                if not right and db.mythicDungeons.showNoRecord then
                    right = "|cff888888" .. L["No Record"] .. "|r"
                end
                if right then
                    if highestScoreDungeon and highestScoreDungeon == name then
                        right = starIconString .. right
                    end
                    tt:AddDoubleLine(left, right, nil, nil, nil, 1, 1, 1)
                end
            end
        end
    end
end

function T:Progression(tt, unit, guid)
    if not E.private.WT.tooltips.progression.enable then
        return
    end

    local level = UnitLevel(unit)
    if not level or not level == MAX_PLAYER_LEVEL then
        return
    end

    if not IsAddOnLoaded("Blizzard_AchievementUI") then
        AchievementFrame_LoadUI()
    end

    if not cache[guid] or (GetTime() - cache[guid].timer) > 120 then
        if guid == E.myguid then
            UpdateProgression(guid, unit, E.myfaction)
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

    SetProgressionInfo(tt, guid)
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
            UpdateProgression(GUID, unit, faction)
            _G.GameTooltip:SetUnit(unit)
        end
    end

    ClearAchievementComparisonUnit()

    self:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
end

T:AddInspectInfoCallback(2, "Progression", true)

-- https://wago.tools/db2/MapChallengeMode?page=1&sort[Name_lang]=asc
-- PYTHON SCRIPT TO GENERATE THE TABLE
-- USE FIRST 2 COLS OF MapChallengeMode.dbc
-- _text = text.split("\n")
-- for _t in _text:
--     if "\t" in _t:
--         s = _t.split("\t")
--         print(f"[{s[1]}] = \"{s[0]},")
