local W, F, E, L = unpack(select(2, ...))
local ET = E:GetModule("Tooltip")
local T = W:GetModule("Tooltips")

local select, pairs, ipairs, tonumber = select, pairs, ipairs, tonumber
local GetTime, CanInspect = GetTime, CanInspect

local UnitExists, UnitLevel, UnitGUID, UnitRace = UnitExists, UnitLevel, UnitGUID, UnitRace
local ClearAchievementComparisonUnit = ClearAchievementComparisonUnit
local SetAchievementComparisonUnit = SetAchievementComparisonUnit
local IsAddOnLoaded, HideUIPanel = IsAddOnLoaded, HideUIPanel
local C_CreatureInfo_GetFactionInfo = C_CreatureInfo.GetFactionInfo

local compareGUID
local playerGUID = UnitGUID("player")
local playerFaction = UnitFactionGroup("player")
local progressCache = {}
local IsAzeriteEmpoweredItemByID = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID

local AchievementID = {
    tiers = {Uldir, BattleOfDazaralor, CrucibleOfStorms, EternalPalace, Nyalotha},
    levels = {Mythic, Heroic, Normal, LFR},
    raids = {
        Uldir = {
            Mythic = {
                12789,
                12793,
                12797,
                12801,
                12805,
                12811,
                12816,
                12820
            },
            Heroic = {
                12788,
                12792,
                12796,
                12800,
                12804,
                12810,
                12815,
                12819
            },
            Normal = {
                12787,
                12791,
                12795,
                12799,
                12803,
                12809,
                12814,
                12818
            },
            LFR = {
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
        BattleOfDazaralor = {
            Alliance = {
                Mythic = {
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
                Heroic = {
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
                Normal = {
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
                LFR = {
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
            Horde = {
                Mythic = {
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
                Heroic = {
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
                Normal = {
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
                LFR = {
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
        CrucibleOfStorms = {
            Mythic = {
                13407,
                13413
            },
            Heroic = {
                13406,
                13412
            },
            Normal = {
                13405,
                13411
            },
            LFR = {
                13404,
                13408
            }
        },
        EternalPalace = {
            Mythic = {
                13590,
                13594,
                13598,
                13603,
                13607,
                13611,
                13615,
                13619
            },
            Heroic = {
                13589,
                13593,
                13597,
                13602,
                13606,
                13610,
                13614,
                13618
            },
            Normal = {
                13588,
                13592,
                13596,
                13601,
                13605,
                13609,
                13613,
                13617
            },
            LFR = {
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
        Nyalotha = {
            Mythic = {
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
            Heroic = {
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
            Normal = {
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
            LFR = {
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
    },
    dungeons = {
        MythicDungeon = {
            AtalDazar = 12749,
            FreeHold = 12752,
            KingsRest = 12763,
            ShrineOfTheStorm = 12768,
            SiegeOfBoralus = 12773,
            TempleOfSethrealiss = 12776,
            ["TheMOTHERLODE!!"] = 12779,
            TheUnderrot = 12745,
            TolDagor = 12782,
            WaycrestManor = 12785,
            Mechagon = 13620
        },
        ["Mythic+"] = {
            ["Mythic+(LEG&BFA)"] = 7399
        }
    }
}

local function UpdateProgression(guid, faction)
    local statFunc = guid == playerGUID and GetStatistic or GetComparisonStatistic
    local db = E.private.WT.tooltips.progression

    progressCache[guid] = progressCache[guid] or {}
    progressCache[guid].info = progressCache[guid].info or {}
    progressCache[guid].timer = GetTime()

    if db.raid.enable then
        progressCache[guid].info.raid = {}
        for _, tier in ipairs(AchievementID.tiers) do -- arranged by tier
            if db.raid[tier] then
                progressCache[guid].info.raid[tier] = {}
                local bosses =
                    tier == "BattleOfDazaralor" and AchievementID.raids[tier][faction] or AchievementID.raids[tier]

                for _, level in ipairs(self.RP.levels) do
                    local highest = 0

                    for _, statId in ipairs(bosses[level]) do
                        local kills = tonumber(statFunc(statId), 10)
                        if kills and kills > 0 then
                            highest = highest + 1
                        end
                    end

                    if (highest > 0) then
                        progressCache[guid].info.raid[tier][level] = ("%d/%d"):format(highest, #bosses[level])
                        if highest == #bosses[level] then
                            break
                        end
                    end
                end
            end
        end
    end

    -- 传奇地下城
    if db.dungeon.enable then
        progressCache[guid].info.dungeon = {}
        for k, v in pairs(AchievementID.dungeon) do
            if db.dungeon[k] then
                progressCache[guid].info.dungeon[k] = {}
                for dungeon, statId in pairs(v) do
                    progressCache[guid].info.dungeon[k][dungeon] = tonumber(statFunc(statId), 10)
                end
            end
        end
    end
end

local function SetProgressionInfo(guid, tt)
    if progressCache[guid] then
        local updated = false
        for i = 1, tt:NumLines() do
            local leftTip = _G["GameTooltipTextLeft" .. i]
            local leftTipText = leftTip:GetText()
            local found = false
            if (leftTipText) then
                if self.db["Progression"]["Raid"]["enabled"] then -- raid progress
                    for _, tier in ipairs(self.RP.tiers) do
                        if self.db["Progression"]["Raid"][tier] then
                            for _, level in ipairs(self.RP.levels) do
                                if (leftTipText:find(L[tier]) and leftTipText:find(L[level])) then
                                    -- update found tooltip text line
                                    local rightTip = _G["GameTooltipTextRight" .. i]
                                    leftTip:SetText(("%s %s:"):format(L[tier], getLevelColorString(level, false)))
                                    rightTip:SetText(progressCache[guid].info["Raid"][tier][level])
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
                if self.db["Progression"]["Dungeon"]["enabled"] then -- mythic dungeons and mythic+
                    for k, v in pairs(self.RP["Dungeon"]) do
                        if self.db["Progression"]["Dungeon"][k] then
                            for dungeon, statId in pairs(v) do
                                if (leftTipText:find(L[dungeon])) then
                                    -- update found tooltip text line
                                    local rightTip = _G["GameTooltipTextRight" .. i]
                                    leftTip:SetText(L[dungeon] .. ":")
                                    rightTip:SetText(
                                        getLevelColorString(level, true) ..
                                            progressCache[guid].info["Dungeon"][k][dungeon]
                                    )
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
            end
        end
        if updated then
            return
        end
        -- add progression tooltip line
        if self.db["Progression"]["Raid"]["enabled"] then -- raid progress
            tt:AddLine(" ")
            tt:AddLine(L["Raids"])
            for _, tier in ipairs(self.RP.tiers) do -- Raid
                if self.db["Progression"]["Raid"][tier] then
                    for _, level in ipairs(self.RP.levels) do
                        if (progressCache[guid].info["Raid"][tier][level]) then
                            tt:AddDoubleLine(
                                ("%s %s:"):format(L[tier], getLevelColorString(level, false)),
                                getLevelColorString(level, true) .. " " .. progressCache[guid].info["Raid"][tier][level],
                                nil,
                                nil,
                                nil,
                                1,
                                1,
                                1
                            )
                        end
                    end
                end
            end
        end
        if self.db["Progression"]["Dungeon"]["enabled"] then -- mythic dungeons and mythic+
            tt:AddLine(" ")
            tt:AddLine(L["Dungeon"])
            for k, v in pairs(self.RP["Dungeon"]) do
                if self.db["Progression"]["Dungeon"][k] then
                    for dungeon, statId in pairs(v) do
                        tt:AddDoubleLine(
                            L[dungeon] .. ":",
                            progressCache[guid].info["Dungeon"][k][dungeon],
                            nil,
                            nil,
                            nil,
                            1,
                            1,
                            1
                        )
                    end
                end
            end
        end
    end
end

function T:INSPECT_ACHIEVEMENT_READY(event, GUID)
    if (compareGUID ~= GUID) then
        return
    end

    local unit = "mouseover"

    if UnitExists(unit) then
        local race = select(3, UnitRace(unit))
        local faction = race and C_CreatureInfo_GetFactionInfo(race).groupTag
        if (faction) then
            UpdateProgression(GUID, faction)
            GameTooltip:SetUnit(unit)
        end
    end

    ClearAchievementComparisonUnit()
    self:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
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
            if not self.loadedComparison and select(2, IsAddOnLoaded("Blizzard_AchievementUI")) then
                AchievementFrame_DisplayComparison(unit)
                HideUIPanel(AchievementFrame)
                ClearAchievementComparisonUnit()
                self.loadedComparison = true
            end

            self.compareGUID = guid
            if SetAchievementComparisonUnit(unit) then
                T:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
            end
            return
        end
    end
    SetProgressionInfo(guid, tt)
end

function T:Progression()
    if not E.private.WT.tooltips.progression then
        return
    end

    hooksecurefunc(ET, "AddInspectInfo", AddProgression)
end

T:AddCallback("Progression")
