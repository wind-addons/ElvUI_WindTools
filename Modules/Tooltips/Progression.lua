local W, F, E, L = unpack(select(2, ...))
local ET = E:GetModule("Tooltip")
local T = W:GetModule("Tooltips")

local _G = _G
local select, pairs, ipairs, tonumber = select, pairs, ipairs, tonumber
local strfind, format = strfind, format
local GetTime, CanInspect = GetTime, CanInspect

local UnitExists, UnitLevel, UnitGUID, UnitRace = UnitExists, UnitLevel, UnitGUID, UnitRace
local ClearAchievementComparisonUnit = ClearAchievementComparisonUnit
local SetAchievementComparisonUnit = SetAchievementComparisonUnit
local GetStatistic, GetComparisonStatistic = GetStatistic, GetComparisonStatistic
local IsAddOnLoaded, HideUIPanel = IsAddOnLoaded, HideUIPanel
local C_CreatureInfo_GetFactionInfo = C_CreatureInfo.GetFactionInfo
local InCombatLockdown = InCombatLockdown
local AchievementFrame_DisplayComparison = AchievementFrame_DisplayComparison
local MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL

local loadedComparison
local compareGUID
local cache = {}

local tiers = {
    "Ny'alotha, The Waking City",
    "Azshara's Eternal Palace",
    "Crucible of Storms",
    "Battle of Dazaralor",
    "Uldir"
}

local levels = {
    "Mythic",
    "Heroic",
    "Normal",
    "Looking For Raid"
}

local locales = {
    ["Looking For Raid"] = {
        short = L["[ABBR] Looking For Raid"],
        full = L["Looking For Raid"]
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
    -- 团本名
    ["Uldir"] = {
        short = L["[ABBR] Uldir"],
        full = L["Uldir"]
    },
    ["Battle of Dazaralor"] = {
        short = L["[ABBR] Battle of Dazaralor"],
        full = L["Battle of Dazaralor"]
    },
    ["Crucible of Storms"] = {
        short = L["[ABBR] Crucible of Storms"],
        full = L["Crucible of Storms"]
    },
    ["Azshara's Eternal Palace"] = {
        short = L["[ABBR] Azshara's Eternal Palace"],
        full = L["Azshara's Eternal Palace"]
    },
    ["Ny'alotha, The Waking City"] = {
        short = L["[ABBR] Ny'alotha, The Waking City"],
        full = L["Ny'alotha, The Waking City"]
    },
    -- 8.0 地下城
    ["Atal'Dazar"] = {
        short = L["[ABBR] Atal'Dazar"],
        full = L["Atal'Dazar"]
    },
    ["FreeHold"] = {
        short = L["[ABBR] FreeHold"],
        full = L["FreeHold"]
    },
    ["Kings' Rest"] = {
        short = L["[ABBR] Kings' Rest"],
        full = L["Kings' Rest"]
    },
    ["Shrine of the Storm"] = {
        short = L["[ABBR] Shrine of the Storm"],
        full = L["Shrine of the Storm"]
    },
    ["Siege of Boralus"] = {
        short = L["[ABBR] Siege of Boralus"],
        full = L["Siege of Boralus"]
    },
    ["Temple of Sethrealiss"] = {
        short = L["[ABBR] Temple of Sethrealiss"],
        full = L["Temple of Sethrealiss"]
    },
    ["The MOTHERLODE!!"] = {
        short = L["[ABBR] The MOTHERLODE!!"],
        full = L["The MOTHERLODE!!"]
    },
    ["The Underrot"] = {
        short = L["[ABBR] The Underrot"],
        full = L["The Underrot"]
    },
    ["Tol Dagor"] = {
        short = L["[ABBR] Tol Dagor"],
        full = L["Tol Dagor"]
    },
    ["Waycrest Manor"] = {
        short = L["[ABBR] Waycrest Manor"],
        full = L["Waycrest Manor"]
    },
    ["Operation: Mechagon"] = {
        short = L["[ABBR] Operation: Mechagon"],
        full = L["Operation: Mechagon"]
    },
    -- 9.0 地下城
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
    ["Uldir"] = {
        ["Mythic"] = {
            12789,
            12793,
            12797,
            12801,
            12805,
            12811,
            12816,
            12820
        },
        ["Heroic"] = {
            12788,
            12792,
            12796,
            12800,
            12804,
            12810,
            12815,
            12819
        },
        ["Normal"] = {
            12787,
            12791,
            12795,
            12799,
            12803,
            12809,
            12814,
            12818
        },
        ["Looking For Raid"] = {
            12786,
            12790,
            12794,
            12798,
            12802,
            12808,
            12813,
            12817
        }
    },
    ["Battle of Dazaralor"] = {
        separated = true,
        ["Alliance"] = {
            ["Mythic"] = {
                13331,
                13353,
                13348,
                13362,
                13366,
                13370,
                13374,
                13378,
                13382
            },
            ["Heroic"] = {
                13330,
                13351,
                13347,
                13361,
                13365,
                13369,
                13373,
                13377,
                13381
            },
            ["Normal"] = {
                13329,
                13350,
                13346,
                13359,
                13364,
                13368,
                13372,
                13376,
                13380
            },
            ["Looking For Raid"] = {
                13328,
                13349,
                13344,
                13358,
                13363,
                13367,
                13371,
                13375,
                13379
            }
        },
        ["Horde"] = {
            ["Mythic"] = {
                13331,
                13336,
                13357,
                13374,
                13378,
                13382,
                13362,
                13366,
                13370
            },
            ["Heroic"] = {
                13330,
                13334,
                13356,
                13373,
                13377,
                13381,
                13361,
                13365,
                13369
            },
            ["Normal"] = {
                13329,
                13333,
                13355,
                13372,
                13376,
                13380,
                13359,
                13364,
                13368
            },
            ["Looking For Raid"] = {
                13328,
                13332,
                13354,
                13371,
                13375,
                13379,
                13358,
                13363,
                13367
            }
        }
    },
    ["Crucible of Storms"] = {
        ["Mythic"] = {
            13407,
            13413
        },
        ["Heroic"] = {
            13406,
            13412
        },
        ["Normal"] = {
            13405,
            13411
        },
        ["Looking For Raid"] = {
            13404,
            13408
        }
    },
    ["Azshara's Eternal Palace"] = {
        ["Mythic"] = {
            13590,
            13594,
            13598,
            13603,
            13607,
            13611,
            13615,
            13619
        },
        ["Heroic"] = {
            13589,
            13593,
            13597,
            13602,
            13606,
            13610,
            13614,
            13618
        },
        ["Normal"] = {
            13588,
            13592,
            13596,
            13601,
            13605,
            13609,
            13613,
            13617
        },
        ["Looking For Raid"] = {
            13587,
            13591,
            13595,
            13600,
            13604,
            13608,
            13612,
            13616
        }
    },
    ["Ny'alotha, The Waking City"] = {
        ["Mythic"] = {
            14082,
            14094,
            14098,
            14105,
            14110,
            14115,
            14120,
            14211,
            14126,
            14130,
            14134,
            14138
        },
        ["Heroic"] = {
            14080,
            14093,
            14097,
            14104,
            14109,
            14114,
            14119,
            14210,
            14125,
            14129,
            14133,
            14137
        },
        ["Normal"] = {
            14079,
            14091,
            14096,
            14102,
            14108,
            14112,
            14118,
            14208,
            14124,
            14128,
            14132,
            14136
        },
        ["Looking For Raid"] = {
            14078,
            14089,
            14095,
            14101,
            14107,
            14111,
            14117,
            14207,
            14123,
            14127,
            14131,
            14135
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
    ["Sanguine Depths"] = 14202
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
    local times

    if guid == E.myguid then
        times = tonumber(GetStatistic(achievementID), 10)
    else
        times = tonumber(GetComparisonStatistic(achievementID), 10)
    end

    return times or 0
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
        if db.mythicDungeons.challengeModeTimes then
            cache[guid].info.mythicDungeons.times = GetBossKillTimes(guid, 7399)
        end

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
                        local right =
                            GetLevelColoredString(level, true) .. " " .. cache[guid].info.raids[tier][level]

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

    if not cache[guid] or (GetTime() - cache[guid].timer) > 600 then
        if guid == E.myguid then
            UpdateProgression(guid, E.myfaction)
        else
            ClearAchievementComparisonUnit()
            if not loadedComparison and select(2, IsAddOnLoaded("Blizzard_AchievementUI")) then
                AchievementFrame_DisplayComparison(unit)
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
