local W, F, E, L = unpack(select(2, ...))
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
    "Castle Nathria",
    "Sanctum of Domination",
    "Sepulcher of the First Ones"
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
    ["Sanctum of Domination"] = {
        short = L["[ABBR] Sanctum of Domination"],
        full = L["Sanctum of Domination"]
    },
    ["Sepulcher of the First Ones"] = {
        short = L["[ABBR] Sepulcher of the First Ones"],
        full = L["Sepulcher of the First Ones"]
    },
    ["Grimrail Depot"] = {
        short = L["[ABBR] Grimrail Depot"],
        full = L["Grimrail Depot"]
    },
    ["Iron Docks"] = {
        short = L["[ABBR] Iron Docks"],
        full = L["Iron Docks"]
    },
    ["Operation Mechagon: Junkyard"] = {
        short = L["[ABBR] Operation Mechagon: Junkyard"],
        full = L["Operation Mechagon: Junkyard"]
    },
    ["Operation Mechagon: Workshop"] = {
        short = L["[ABBR] Operation Mechagon: Workshop"],
        full = L["Operation Mechagon: Workshop"]
    },
    ["Return to Karazhan: Lower"] = {
        short = L["[ABBR] Return to Karazhan: Lower"],
        full = L["Return to Karazhan: Lower"]
    },
    ["Return to Karazhan: Upper"] = {
        short = L["[ABBR] Return to Karazhan: Upper"],
        full = L["Return to Karazhan: Upper"]
    },
    ["Tazavesh: Streets of Wonder"] = {
        short = L["[ABBR] Tazavesh: Streets of Wonder"],
        full = L["Tazavesh: Streets of Wonder"]
    },
    ["Tazavesh: So'leah's Gambit"] = {
        short = L["[ABBR] Tazavesh: So'leah's Gambit"],
        full = L["Tazavesh: So'leah's Gambit"]
    },
    ["Shadowlands Keystone Master: Season One"] = {
        short = L["[ABBR] Shadowlands Keystone Master: Season One"],
        full = L["Shadowlands Keystone Master: Season One"]
    },
    ["Shadowlands Keystone Master: Season Two"] = {
        short = L["[ABBR] Shadowlands Keystone Master: Season Two"],
        full = L["Shadowlands Keystone Master: Season Two"]
    },
    ["Shadowlands Keystone Master: Season Three"] = {
        short = L["[ABBR] Shadowlands Keystone Master: Season Three"],
        full = L["Shadowlands Keystone Master: Season Three"]
    },
    ["Shadowlands Keystone Master: Season Four"] = {
        short = L["[ABBR] Shadowlands Keystone Master: Season Four"],
        full = L["Shadowlands Keystone Master: Season Four"]
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
    },
    ["Sanctum of Domination"] = {
        ["Mythic"] = {
            15139,
            15143,
            15147,
            15151,
            15155,
            15159,
            15163,
            15167,
            15172,
            15176
        },
        ["Heroic"] = {
            15138,
            15142,
            15146,
            15150,
            15154,
            15158,
            15162,
            15166,
            15171,
            15175
        },
        ["Normal"] = {
            15137,
            15141,
            15145,
            15149,
            15153,
            15157,
            15161,
            15165,
            15170,
            15174
        },
        ["Raid Finder"] = {
            15136,
            15140,
            15144,
            15148,
            15152,
            15156,
            15160,
            15164,
            15169,
            15173
        }
    },
    ["Sepulcher of the First Ones"] = {
        ["Mythic"] = {
            15427,
            15431,
            15435,
            15439,
            15443,
            15447,
            15451,
            15455,
            15459,
            15463,
            15467
        },
        ["Heroic"] = {
            15426,
            15430,
            15434,
            15438,
            15442,
            15446,
            15450,
            15454,
            15458,
            15462,
            15466
        },
        ["Normal"] = {
            15425,
            15429,
            15433,
            15437,
            15441,
            15445,
            15449,
            15453,
            15457,
            15461,
            15465
        },
        ["Raid Finder"] = {
            15424,
            15428,
            15432,
            15436,
            15440,
            15444,
            15448,
            15452,
            15456,
            15460,
            15464
        }
    }
}

local mythicKeystoneDungeons = {
    [166] = "Grimrail Depot",
    [169] = "Iron Docks",
    [227] = "Return to Karazhan: Lower",
    [234] = "Return to Karazhan: Upper",
    [369] = "Operation Mechagon: Junkyard",
    [370] = "Operation Mechagon: Workshop",
    [391] = "Tazavesh: Streets of Wonder",
    [392] = "Tazavesh: So'leah's Gambit"
}

local specialAchievements = {
    {14532, "Shadowlands Keystone Master: Season One"},
    {15078, "Shadowlands Keystone Master: Season Two"},
    {15499, "Shadowlands Keystone Master: Season Three"},
    {15690, "Shadowlands Keystone Master: Season Four"}
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

T:AddInspectInfoCallback(3, "Progression", true)
