local W, F, E, L = unpack(select(2, ...))
local ET = E:GetModule("Tooltip")
local T = W:GetModule("Tooltips")

local select, ipairs, tonumber = select, ipairs, tonumber
local strfind, format = strfind, format
local GetTime, CanInspect = GetTime, CanInspect

local UnitExists, UnitLevel, UnitGUID, UnitRace = UnitExists, UnitLevel, UnitGUID, UnitRace
local ClearAchievementComparisonUnit = ClearAchievementComparisonUnit
local SetAchievementComparisonUnit = SetAchievementComparisonUnit
local GetStatistic, GetComparisonStatistic = GetStatistic, GetComparisonStatistic
local IsAddOnLoaded, HideUIPanel = IsAddOnLoaded, HideUIPanel
local C_CreatureInfo_GetFactionInfo = C_CreatureInfo.GetFactionInfo

local loadedComparison
local compareGUID
local playerGUID = UnitGUID("player")
local playerFaction = UnitFactionGroup("player")
local progressCache = {}
local IsAzeriteEmpoweredItemByID = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID

-- 8.0 决战艾泽拉斯
local tiers = {
    "Uldir",
    "Battle of Dazaralor",
    "Crucible of Storms",
    "Azshara's Eternal Palace",
    "Ny'alotha, The Waking City"
}

local levels = {"Mythic", "Heroic", "Normal", "Looking For Raid"}

local Locales = {
    ["Looking For Raid"] = {
        short = "LFR",
        full = L["Looking For Raid"]
    },
    ["Normal"] = {
        short = "N",
        full = L["Normal"]
    },
    ["Heroic"] = {
        short = "H",
        full = L["Heroic"]
    },
    ["Mythic"] = {
        short = "M",
        full = L["Mythic"]
    },
    -- 团本名
    ["Uldir"] = {
        short = L["Uldir"],
        full = L["Uldir"]
    },
    ["Battle of Dazaralor"] = {
        short = L["BoD"],
        full = L["Battle of Dazaralor"]
    },
    ["Crucible of Storms"] = {
        short = L["BoD"],
        full = L["Battle of Dazaralor"]
    },
    ["Azshara's Eternal Palace"] = {
        short = L["AEP"],
        full = L["Azshara's Eternal Palace"]
    },
    ["Ny'alotha, The Waking City"] = {
        short = L["Nyalotha"],
        full = L["Ny'alotha, The Waking City"]
    },
    -- 地下城名
    ["Atal'Dazar"] = {
        full = L["Atal'Dazar"]
    },
    ["FreeHold"] = {
        full = L["FreeHold"]
    },
    ["Kings' Rest"] = {
        full = L["Kings' Rest"]
    },
    ["Shrine of the Storm"] = {
        full = L["Shrine of the Storm"]
    },
    ["Siege of Boralus"] = {
        full = L["Siege of Boralus"]
    },
    ["Temple of Sethrealiss"] = {
        full = L["Temple of Sethrealiss"]
    },
    ["The MOTHERLODE!!"] = {
        full = L["The MOTHERLODE!!"]
    },
    ["The Underrot"] = {
        full = L["The Underrot"]
    },
    ["Tol Dagor"] = {
        full = L["Tol Dagor"]
    },
    ["Waycrest Manor"] = {
        full = L["Waycrest Manor"]
    },
    ["Operation: Mechagon"] = {
        full = L["Operation: Mechagon"]
    },
    -- 其他
    ["Mythic+ Times"] = {
        full = L["Mythic+ Times"]
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
    ["Atal'Dazar"] = 12749,
    ["FreeHold"] = 12752,
    ["Kings' Rest"] = 12763,
    ["Shrine of the Storm"] = 12768,
    ["Siege of Boralus"] = 12773,
    ["Temple of Sethrealiss"] = 12776,
    ["The MOTHERLODE!!"] = 12779,
    ["The Underrot"] = 12745,
    ["Tol Dagor"] = 12782,
    ["Waycrest Manor"] = 12785,
    ["Operation: Mechagon"] = 13620,
    ["Mythic+ Times"] = 7399
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
        return "|cff" .. color .. Locales[level].short .. "|r"
    else
        return "|cff" .. color .. Locales[level].full .. "|r"
    end
end

local function GetBossKillTimes(guid, achievementID)
    local times

    if guid == playerGUID then
        times = tonumber(GetStatistic(achievementID), 10)
    else
        times = tonumber(GetComparisonStatistic(achievementID), 10)
    end

    return times or 0
end

local function UpdateProgression(guid, faction)
    local db = E.private.WT.tooltips.progression

    progressCache[guid] = progressCache[guid] or {}
    progressCache[guid].info = progressCache[guid].info or {}
    progressCache[guid].timer = GetTime()

    -- 团本成就查询
    if db.raid.enable then
        progressCache[guid].info.raid = {}
        for _, tier in ipairs(tiers) do
            -- 单个团本
            if db.raid[tier] then
                progressCache[guid].info.raid[tier] = {}
                local bosses

                if tier == "Battle of Dazaralor" then
                    bosses = raidAchievements[tier][faction]
                else
                    bosses = raidAchievements[tier]
                end

                for _, level in ipairs(levels) do
                    local alreadyKilled = 0

                    -- 统计 Boss 击杀个数
                    for _, achievementID in ipairs(bosses[level]) do
                        if GetBossKillTimes(guid, achievementID) > 0 then
                            alreadyKilled = alreadyKilled + 1
                        end
                    end

                    if (alreadyKilled > 0) then
                        progressCache[guid].info.raid[tier][level] = format("%d/%d", highest, #bosses[level])
                        if alreadyKilled == #bosses[level] then
                            break -- 全通本难度后毋须扫描更低难度进度
                        end
                    end
                end
            end
        end
    end

    -- 传奇地下城
    if db.dungeon.enable then
        progressCache[guid].info.dungeon = {}
        for name, achievementID in ipairs(dungeonAchievements) do
            if db.dungeon[name] then
                progressCache[guid].info.dungeon[name] = GetBossKillTimes(guid, achievementID)
            end
        end
    end
end

local function SetProgressionInfo(guid, tt)
    if not progressCache[guid] then
        return
    end

    local db = E.private.WT.tooltips.progression

    local updated = false

    for i = 1, tt:NumLines() do
        local leftTip = _G["GameTooltipTextLeft" .. i]
        local leftTipText = leftTip:GetText()
        local found = false

        if leftTipText then
            if db.raid.enable then -- 团本进度
                for _, tier in ipairs(tiers) do
                    if db.raid[tier] then
                        for _, level in ipairs(levels) do
                            if strfind(leftTipText, Locales[tier].full) and strfind(leftTipText, Locales[level].full) then
                                local rightTip = _G["GameTooltipTextRight" .. i]
                                leftTip:SetText(
                                    format("%s %s:", Locales[tier].full, GetLevelColoredString(level, false))
                                )
                                rightTip:SetText(progressCache[guid].info.raid[tier][level])
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

            if db.dungeon.enable then -- 地下城进度
                for name, achievementID in ipairs(dungeonAchievements) do
                    if db.dungeon[name] then
                        if strfind(leftTipText, Locales[name].full) then
                            -- update found tooltip text line
                            local rightTip = _G["GameTooltipTextRight" .. i]
                            leftTip:SetText(Locales[name].full .. ":")
                            rightTip:SetText(
                                GetLevelColoredString("Mythic", true) .. progressCache[guid].info.dungeon[name]
                            )
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

    if db.raid.enable then -- 团本进度
        tt:AddLine(" ")
        tt:AddLine(L["Raids"])

        for _, tier in ipairs(tiers) do
            if db.raid[tier] then
                for _, level in ipairs(levels) do
                    if (progressCache[guid].info.raid[tier][level]) then
                        local left = format("%s %s:", Locales[tier].short, GetLevelColoredString(level, false))
                        local right =
                            GetLevelColoredString(level, true) .. " " .. progressCache[guid].info.raid[tier][level]

                        tt:AddDoubleLine(left, right, nil, nil, nil, 1, 1, 1)
                    end
                end
            end
        end
    end
    if db.dungeon.enable then -- 地下城进度
        tt:AddLine(" ")
        tt:AddLine(L["Dungeon"])
        for name, achievementID in ipairs(dungeonAchievements) do
            if db.dungeon[name] then
                local left = format("%s:", Locales[name].full)
                local right = progressCache[guid].info.dungeon[name]

                tt:AddDoubleLine(left, right, nil, nil, nil, 1, 1, 1)
            end
        end
    end
end

local function AddProgression(self, tt, unit, numTries, r, g, b)
    if not E.private.WT.tooltips.progression then
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

    if not progressCache[guid] or (GetTime() - progressCache[guid].timer) > 600 then
        if guid == playerGUID then
            UpdateProgression(guid, playerFaction)
        else
            ClearAchievementComparisonUnit()
            if not loadedComparison and select(2, IsAddOnLoaded("Blizzard_AchievementUI")) then
                AchievementFrame_DisplayComparison(unit)
                HideUIPanel(AchievementFrame)
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
            GameTooltip:SetUnit(unit)
        end
    end

    ClearAchievementComparisonUnit()

    self:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
end

function T:Progression()
    if not E.private.WT.tooltips.progression then
        return
    end

    hooksecurefunc(ET, "AddInspectInfo", AddProgression)
end

T:AddCallback("Progression")
