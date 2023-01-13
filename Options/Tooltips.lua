local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.tooltips.args
local T = W.Modules.Tooltips
local LFGPI = W.Utilities.LFGPlayerInfo

local format = format
local ipairs = ipairs
local pairs = pairs

local cache = {
    groupInfo = {}
}

options.desc = {
    order = 1,
    type = "group",
    inline = true,
    name = L["Description"],
    args = {
        feature = {
            order = 1,
            type = "description",
            name = L["Add some additional information to your tooltips."],
            fontSize = "medium"
        }
    }
}

options.general = {
    order = 2,
    type = "group",
    name = L["General"],
    get = function(info)
        return E.private.WT.tooltips[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.tooltips[info[#info]] = value
        E:StaticPopup_Show("PRIVATE_RL")
    end,
    args = {
        modifier = {
            order = 1,
            type = "select",
            name = L["Modifier Key"],
            desc = format(L["The modifer key to show additional information from %s."], W.Title),
            set = function(info, value)
                E.private.WT.tooltips[info[#info]] = value
            end,
            values = {
                NONE = L["None"],
                SHIFT = L["Shift"],
                CTRL = L["Ctrl"],
                ALT = L["Alt"],
                ALT_SHIFT = format("%s + %s", L["Alt"], L["Shift"]),
                CTRL_SHIFT = format("%s + %s", L["Ctrl"], L["Shift"]),
                CTRL_ALT = format("%s + %s", L["Ctrl"], L["Alt"]),
                CTRL_ALT_SHIFT = format("%s + %s + %s", L["Ctrl"], L["Alt"], L["Shift"])
            }
        },
        additionalInformation = {
            order = 2,
            type = "group",
            inline = true,
            name = L["Additional Information"],
            args = {
                icon = {
                    order = 1,
                    type = "toggle",
                    name = L["Add Icon"],
                    desc = L["Show an icon for items and spells."]
                },
                factionIcon = {
                    order = 2,
                    type = "toggle",
                    name = L["Faction Icon"],
                    desc = L["Show a faction icon in the top right of tooltips."]
                },
                petIcon = {
                    order = 3,
                    type = "toggle",
                    name = L["Pet Icon"],
                    desc = L["Add an icon for indicating the type of the pet."]
                },
                petId = {
                    order = 4,
                    type = "toggle",
                    name = L["Pet ID"],
                    desc = L["Show battle pet species ID in tooltips."]
                },
                tierSet = {
                    order = 5,
                    type = "toggle",
                    name = L["Tier Set"],
                    desc = format(
                        "%s\n%s",
                        L["Show the number of tier set equipments."],
                        F.CreateColorString(L["You need hold SHIFT to inspect someone."], E.db.general.valuecolor)
                    )
                }
            }
        },
        objectiveProgressInformation = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Objective Progress"],
            args = {
                objectiveProgress = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    desc = L["Add more details of objective progress information into tooltips."]
                },
                objectiveProgressAccuracy = {
                    order = 2,
                    name = L["Accuracy"],
                    type = "range",
                    min = 0,
                    max = 5,
                    step = 1
                }
            }
        },
        healthBar = {
            order = 4,
            type = "group",
            inline = true,
            name = L["Health Bar"],
            get = function(info)
                return E.db.WT.tooltips[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.tooltips[info[#info]] = value
            end,
            args = {
                yOffsetOfHealthBar = {
                    order = 1,
                    type = "range",
                    name = L["Health Bar Y-Offset"],
                    desc = L["Change the postion of the health bar."],
                    min = -50,
                    max = 50,
                    step = 1
                },
                yOffsetOfHealthText = {
                    order = 2,
                    type = "range",
                    name = L["Health Text Y-Offset"],
                    desc = L["Change the postion of the health text."],
                    min = -50,
                    max = 50,
                    step = 1
                }
            }
        },
        groupInfo = {
            order = 5,
            type = "group",
            inline = true,
            get = function(info)
                return E.db.WT.tooltips.groupInfo[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.tooltips.groupInfo[info[#info]] = value
            end,
            name = L["Group Info"],
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    desc = L["Add LFG group info to tooltip."]
                },
                title = {
                    order = 2,
                    type = "toggle",
                    name = L["Add Title"],
                    desc = L["Display an additional title."]
                },
                mode = {
                    order = 3,
                    name = L["Mode"],
                    type = "select",
                    values = {
                        NORMAL = L["Normal"],
                        COMPACT = L["Compact"]
                    }
                },
                classIconStyle = {
                    order = 4,
                    name = L["Class Icon Style"],
                    type = "select",
                    values = function()
                        local result = {}
                        for _, style in pairs(F.GetClassIconStyleList()) do
                            local monkIcon = F.GetClassIconStringWithStyle("MONK", style)
                            local druidIcon = F.GetClassIconStringWithStyle("DRUID", style)
                            local evokerIcon = F.GetClassIconStringWithStyle("EVOKER", style)

                            if monkIcon and druidIcon and evokerIcon then
                                result[style] = format("%s %s %s", monkIcon, druidIcon, evokerIcon)
                            end
                        end
                        return result
                    end
                },
                betterAlign1 = {
                    order = 5,
                    type = "description",
                    name = "",
                    width = "full"
                },
                template = {
                    order = 6,
                    type = "input",
                    name = L["Template"],
                    desc = L["Please click the button below to read reference."],
                    width = "full",
                    get = function(info)
                        return cache.groupInfo.template or E.db.WT.tooltips[info[#info - 1]].template
                    end,
                    set = function(info, value)
                        cache.groupInfo.template = value
                    end
                },
                resourcePage = {
                    order = 7,
                    type = "execute",
                    name = F.GetWindStyleText(L["Reference"]),
                    desc = format(
                        "|cff00d1b2%s|r (%s)\n%s\n%s\n%s",
                        L["Tips"],
                        L["Editbox"],
                        L["CTRL+A: Select All"],
                        L["CTRL+C: Copy"],
                        L["CTRL+V: Paste"]
                    ),
                    func = function()
                        if E.global.general.locale == "zhCN" or E.global.general.locale == "zhTW" then
                            E:StaticPopup_Show(
                                "WINDTOOLS_EDITBOX",
                                nil,
                                nil,
                                "https://github.com/fang2hou/ElvUI_WindTools/wiki/预组建队伍玩家信息"
                            )
                        else
                            E:StaticPopup_Show(
                                "WINDTOOLS_EDITBOX",
                                nil,
                                nil,
                                "https://github.com/fang2hou/ElvUI_WindTools/wiki/LFG-Player-Info"
                            )
                        end
                    end
                },
                useDefaultTemplate = {
                    order = 8,
                    type = "execute",
                    name = L["Default"],
                    func = function(info)
                        E.db.WT.tooltips[info[#info - 1]].template = P.tooltips[info[#info - 1]].template
                        cache.groupInfo.template = nil
                    end
                },
                applyButton = {
                    order = 9,
                    type = "execute",
                    name = L["Apply"],
                    disabled = function()
                        return not cache.groupInfo.template
                    end,
                    func = function(info)
                        E.db.WT.tooltips[info[#info - 1]].template = cache.groupInfo.template
                    end
                },
                betterAlign2 = {
                    order = 10,
                    type = "description",
                    name = "",
                    width = "full"
                },
                previewText = {
                    order = 11,
                    type = "description",
                    name = function(info)
                        LFGPI:SetClassIconStyle(E.db.WT.tooltips[info[#info - 1]].classIconStyle)
                        local text =
                            LFGPI:ConductPreview(cache.groupInfo.template or E.db.WT.tooltips[info[#info - 1]].template)
                        return L["Preview"] .. ": " .. text
                    end
                }
            }
        }
    }
}

options.progression = {
    order = 3,
    type = "group",
    name = L["Progression"],
    get = function(info)
        return E.private.WT.tooltips.progression[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.tooltips.progression[info[#info]] = value
        E:StaticPopup_Show("PRIVATE_RL")
    end,
    args = {
        enable = {
            order = 1,
            type = "toggle",
            name = L["Enable"],
            desc = L["Add progression information to tooltips."]
        },
        header = {
            order = 2,
            type = "select",
            name = L["Header Style"],
            set = function(info, value)
                E.private.WT.tooltips.progression[info[#info]] = value
            end,
            values = {
                NONE = L["None"],
                TEXT = L["Text"],
                TEXTURE = L["Texture"]
            }
        },
        special = {
            order = 3,
            type = "group",
            name = L["Special Achievements"],
            inline = true,
            get = function(info)
                return E.private.WT.tooltips.progression.special[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.tooltips.progression.special[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            disabled = function()
                return not E.private.WT.tooltips.progression.enable
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"]
                }
            }
        },
        raids = {
            order = 4,
            type = "group",
            name = L["Raids"],
            inline = true,
            get = function(info)
                return E.private.WT.tooltips.progression.raids[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.tooltips.progression.raids[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            disabled = function()
                return not E.private.WT.tooltips.progression.enable
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"]
                }
            }
        },
        mythicDungeons = {
            order = 5,
            type = "group",
            name = L["Mythic Dungeons"],
            inline = true,
            get = function(info)
                return E.private.WT.tooltips.progression.mythicDungeons[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.tooltips.progression.mythicDungeons[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            disabled = function()
                return not E.private.WT.tooltips.progression.enable
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"]
                },
                markHighestScore = {
                    order = 2,
                    type = "toggle",
                    name = L["Mark Highest Score"],
                    desc = L["Add a small icon to indicate the highest score."]
                },
                showNoRecord = {
                    order = 3,
                    type = "toggle",
                    name = L["Show Dungeons with No Record"],
                    width = 1.5
                },
                instances = {
                    order = 4,
                    type = "group",
                    name = L["Instances"],
                    inline = true,
                    get = function(info)
                        return E.private.WT.tooltips.progression.mythicDungeons[info[#info]]
                    end,
                    set = function(info, value)
                        E.private.WT.tooltips.progression.mythicDungeons[info[#info]] = value
                        E:StaticPopup_Show("PRIVATE_RL")
                    end,
                    args = {}
                }
            }
        }
    }
}

do
    local raids = {
        "Vault of the Incarnates"
    }

    local dungeons = {
        "Temple of the Jade Serpent",
        "Shadowmoon Burial Grounds",
        "Halls of Valor",
        "Court of Stars",
        "Ruby Life Pools",
        "The Nokhud Offensive",
        "The Azure Vault",
        "Algeth'ar Academy"
    }

    local special = {
        "Dragonflight Keystone Master: Season One",
        "Dragonflight Keystone Hero: Season One"
    }

    for index, name in ipairs(raids) do
        options.progression.args.raids.args[name] = {
            order = index + 1,
            type = "toggle",
            name = L[name],
            width = "full",
            disabled = function()
                return not (E.private.WT.tooltips.progression.enable and E.private.WT.tooltips.progression.raids.enable)
            end
        }
    end

    for index, name in ipairs(dungeons) do
        options.progression.args.mythicDungeons.args.instances.args[name] = {
            order = index + 2,
            type = "toggle",
            name = L[name],
            width = "full",
            disabled = function()
                return not (E.private.WT.tooltips.progression.enable and
                    E.private.WT.tooltips.progression.mythicDungeons.enable)
            end
        }
    end

    for index, name in ipairs(special) do
        options.progression.args.special.args[name] = {
            order = index + 2,
            type = "toggle",
            name = L[name],
            width = "full",
            disabled = function()
                return not (E.private.WT.tooltips.progression.enable and
                    E.private.WT.tooltips.progression.special.enable)
            end
        }
    end
end
