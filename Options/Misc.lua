local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.misc.args
local LSM = E.Libs.LSM
local M = W.Modules.Misc
local MF = W.Modules.MoveFrames
local CT = W:GetModule("ChatText")
local GB = W:GetModule("GameBar")

local format = format
local tonumber = tonumber
local tostring = tostring

local GetClassInfo = GetClassInfo
local GetNumClasses = GetNumClasses
local Item = Item
local Spell = Spell

local C_CVar_GetCVar = C_CVar.GetCVar
local C_CVar_GetCVarBool = C_CVar.GetCVarBool
local C_CVar_SetCVar = C_CVar.SetCVar

options.general = {
    order = 1,
    type = "group",
    name = L["General"],
    get = function(info)
        return E.private.WT.misc[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.misc[info[#info]] = value
        E:StaticPopup_Show("PRIVATE_RL")
    end,
    args = {
        pauseToSlash = {
            order = 1,
            type = "toggle",
            name = L["Pause to slash"],
            desc = L["Just for Chinese and Korean players"]
        },
        noKanjiMath = {
            order = 2,
            type = "toggle",
            name = L["Math Without Kanji"],
            desc = L["Use alphabet rather than kanji (Only for Chinese players)"]
        },
        disableTalkingHead = {
            order = 3,
            type = "toggle",
            name = L["Disable Talking Head"],
            desc = L["Disable Blizzard Talking Head."],
            get = function(info)
                return E.db.WT.misc[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.misc[info[#info]] = value
            end
        },
        skipCutScene = {
            order = 4,
            type = "toggle",
            name = L["Skip Cut Scene"],
            set = function(info, value)
                E.private.WT.misc[info[#info]] = value
                M:SkipCutScene()
            end
        },
        autoScreenshot = {
            order = 5,
            type = "toggle",
            name = L["Auto Screenshot"],
            desc = L["Screenshot after you earned an achievement automatically."]
        },
        moveSpeed = {
            order = 6,
            type = "toggle",
            name = L["Move Speed"],
            desc = L["Show move speed in character panel."]
        },
        hideCrafter = {
            order = 7,
            type = "toggle",
            name = L["Hide Crafter"],
            desc = L["Hide crafter name in the item tooltip."],
            get = function(info)
                return E.db.WT.misc[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.misc[info[#info]] = value
            end
        },
        autoHideWorldMap = {
            order = 8,
            type = "toggle",
            name = L["Auto Hide Map"],
            desc = L["Automatically close world map if player enters combat."],
            get = function(info)
                return E.db.WT.misc[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.misc[info[#info]] = value
            end
        },
        autoHideBag = {
            order = 9,
            type = "toggle",
            name = L["Auto Hide Bag"],
            desc = L["Automatically close bag if player enters combat."],
            get = function(info)
                return E.db.WT.misc[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.misc[info[#info]] = value
            end
        },
        noLootPanel = {
            order = 10,
            type = "toggle",
            name = L["No Loot Panel"],
            desc = L["Disable Blizzard loot info which auto showing after combat overed."],
            get = function(info)
                return E.db.WT.misc[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.misc[info[#info]] = value
                M:LootPanel()
            end
        },
        hotKeyAboveCD = {
            order = 11,
            type = "toggle",
            name = L["HotKey Above CD"],
            desc = format(
                "%s\n%s %s",
                L["Show hotkeys above the ElvUI cooldown animation."],
                E.NewSign,
                F.CreateColorString(L["Only works with ElvUI action bar and ElvUI cooldowns."], E.db.general.valuecolor)
            )
        },
        guildNewsItemLevel = {
            order = 12,
            type = "toggle",
            name = L["Guild News IL"],
            desc = L["Show item level of each item in guild news."]
        }
    }
}

options.cvars = {
    order = 2,
    type = "group",
    name = L["CVars Editor"],
    get = function(info)
        return C_CVar_GetCVarBool(info[#info])
    end,
    set = function(info, value)
        C_CVar_SetCVar(info[#info], value and "1" or "0")
    end,
    args = {
        desc = {
            order = 1,
            type = "group",
            inline = true,
            name = L["Description"],
            args = {
                feature = {
                    order = 1,
                    type = "description",
                    name = L["A simple editor for CVars."],
                    fontSize = "medium"
                }
            }
        },
        combat = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Combat"],
            args = {
                floatingCombatTextCombatDamage = {
                    order = 1,
                    type = "toggle",
                    name = L["Floating Damage Text"]
                },
                floatingCombatTextCombatHealing = {
                    order = 2,
                    type = "toggle",
                    name = L["Floating Healing Text"]
                },
                WorldTextScale = {
                    order = 3,
                    type = "range",
                    name = L["Floating Text Scale"],
                    get = function(info)
                        return tonumber(C_CVar_GetCVar(info[#info]))
                    end,
                    set = function(info, value)
                        return C_CVar_SetCVar(info[#info], value)
                    end,
                    min = 0.1,
                    max = 5,
                    step = 0.1
                },
                SpellQueueWindow = {
                    order = 4,
                    type = "range",
                    name = L["Spell Queue Window"],
                    get = function(info)
                        return tonumber(C_CVar_GetCVar(info[#info]))
                    end,
                    set = function(info, value)
                        return C_CVar_SetCVar(info[#info], value)
                    end,
                    min = 0,
                    max = 400,
                    step = 1
                }
            }
        },
        visualEffect = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Visual Effect"],
            args = {
                ffxGlow = {
                    order = 1,
                    type = "toggle",
                    name = L["Glow Effect"]
                },
                ffxDeath = {
                    order = 2,
                    type = "toggle",
                    name = L["Death Effect"]
                },
                ffxNether = {
                    order = 3,
                    type = "toggle",
                    name = L["Nether Effect"]
                }
            }
        },
        tooltips = {
            order = 4,
            type = "group",
            inline = true,
            name = L["Tooltips"],
            args = {
                alwaysCompareItems = {
                    order = 1,
                    type = "toggle",
                    name = L["Auto Compare"]
                }
                -- showQuestTrackingTooltips = {
                --     order = 2,
                --     type = "toggle",
                --     name = L["Show Quest Info"],
                --     desc = L["Add progress information (Ex. Mob 10/25)."]
                -- }
            }
        },
        mouse = {
            order = 5,
            type = "group",
            inline = true,
            name = L["Mouse"],
            args = {
                rawMouseEnable = {
                    order = 1,
                    type = "toggle",
                    name = L["Raw Mouse"],
                    desc = L["It will fix the problem if your cursor has abnormal movement."]
                },
                rawMouseAccelerationEnable = {
                    order = 2,
                    type = "toggle",
                    name = L["Raw Mouse Acceleration"],
                    desc = L[
                        "Changes the rate at which your mouse pointer moves based on the speed you are moving the mouse."
                    ]
                }
            }
        }
    }
}

options.moveFrames = {
    order = 4,
    type = "group",
    name = L["Move Frames"],
    get = function(info)
        return E.private.WT.misc.moveFrames[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.misc.moveFrames[info[#info]] = value
        E:StaticPopup_Show("PRIVATE_RL")
    end,
    args = {
        desc = {
            order = 0,
            type = "group",
            inline = true,
            name = L["Description"],
            disabled = false,
            args = {
                feature = {
                    order = 1,
                    type = "description",
                    name = function()
                        if MF.StopRunning then
                            return format(
                                "|cffff0000" .. L["Because of %s, this module will not be loaded."] .. "|r",
                                MF.StopRunning
                            )
                        else
                            return L["This module provides the feature that repositions the frames with drag and drop."]
                        end
                    end,
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 1,
            type = "toggle",
            name = L["Enable"],
            disabled = function()
                return MF.StopRunning
            end
        },
        elvUIBags = {
            order = 2,
            type = "toggle",
            name = L["Move ElvUI Bags"],
            disabled = function()
                return MF.StopRunning or not E.private.WT.misc.moveFrames.enable
            end
        },
        remember = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Remember Positions"],
            disabled = function()
                return MF.StopRunning or not E.private.WT.misc.moveFrames.enable
            end,
            args = {
                rememberPositions = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    set = function(info, value)
                        E.private.WT.misc.moveFrames[info[#info]] = value
                    end
                },
                clearHistory = {
                    order = 2,
                    type = "execute",
                    name = L["Clear History"],
                    func = function()
                        E.private.WT.misc.moveFrames.framePositions = {}
                    end
                },
                notice = {
                    order = 999,
                    type = "description",
                    name = format(
                        "\n|cffff0000%s|r %s",
                        L["Notice"],
                        format(
                            L["%s may cause some frames to get messed, but you can use %s button to reset frames."],
                            L["Remember Positions"],
                            F.CreateColorString(L["Clear History"], E.db.general.valuecolor)
                        )
                    ),
                    fontSize = "medium"
                }
            }
        }
    }
}

options.mute = {
    order = 5,
    type = "group",
    name = L["Mute"],
    args = {
        desc = {
            order = 1,
            type = "group",
            inline = true,
            name = L["Description"],
            args = {
                feature = {
                    order = 1,
                    type = "description",
                    name = L["Disable some annoying sound effects."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            get = function(info)
                return E.private.WT.misc.mute.enable
            end,
            set = function(info, value)
                E.private.WT.misc.mute.enable = value
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        mount = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Mount"],
            get = function(info)
                return E.private.WT.misc.mute[info[#info - 1]][tonumber(info[#info])]
            end,
            set = function(info, value)
                E.private.WT.misc.mute[info[#info - 1]][tonumber(info[#info])] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            args = {}
        },
        other = {
            order = 4,
            type = "group",
            inline = true,
            name = L["Others"],
            get = function(info)
                return E.private.WT.misc.mute[info[#info - 1]][info[#info]]
            end,
            set = function(info, value)
                E.private.WT.misc.mute[info[#info - 1]][info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            args = {
                ["Tortollan"] = {
                    order = 1,
                    type = "toggle",
                    name = L["Tortollan"],
                    width = 1.3
                },
                ["Crying"] = {
                    order = 2,
                    type = "toggle",
                    name = L["Crying"],
                    desc = L["Mute crying sounds of all races."] ..
                        "\n|cffff0000" .. L["It will affect the cry emote sound."] .. "|r",
                    width = 1.3
                }
            }
        }
    }
}

do
    for id in pairs(V.misc.mute.mount) do
        local spell = Spell:CreateFromSpellID(id)
        spell:ContinueOnSpellLoad(
            function()
                local icon = spell:GetSpellTexture()
                local name = spell:GetSpellName()

                local iconString = F.GetIconString(icon)

                options.mute.args.mount.args[tostring(id)] = {
                    order = id,
                    type = "toggle",
                    name = iconString .. " " .. name,
                    width = 1.5
                }
            end
        )
    end

    local itemList = {
        ["Smolderheart"] = {
            id = 180873,
            desc = nil
        },
        ["Elegy of the Eternals"] = {
            id = 188270,
            desc = "|cffff0000" .. L["It will also affect the crying sound of all female Blood Elves."] .. "|r"
        }
    }

    for name, data in pairs(itemList) do
        local item = Item:CreateFromItemID(data.id)
        item:ContinueOnItemLoad(
            function()
                local icon = item:GetItemIcon()
                local name = item:GetItemName()
                local color = item:GetItemQualityColor()

                local iconString = F.GetIconString(icon)
                local nameString = F.CreateColorString(name, color)

                options.mute.args.other.args[name] = {
                    order = id,
                    type = "toggle",
                    name = iconString .. " " .. nameString,
                    desc = data.desc,
                    width = 1.3
                }
            end
        )
    end
end

options.tags = {
    order = 6,
    type = "group",
    name = L["Tags"],
    args = {
        desc = {
            order = 0,
            type = "group",
            inline = true,
            name = L["Description"],
            args = {
                feature = {
                    order = 1,
                    type = "description",
                    name = L["Add more oUF tags. You can use them on UnitFrames configuration."],
                    fontSize = "medium"
                }
            }
        },
        tags = {
            order = 1,
            type = "toggle",
            name = L["Enable"],
            get = function(info)
                return E.private.WT.misc[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.misc[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end
        }
    }
}

do
    local examples = {}

    examples.health = {
        name = L["Health"],
        noSign = {
            tag = "[health:percent-nosign]",
            text = L["The percentage of current health without percent sign"]
        },
        noStatusNoSign = {
            tag = "[health:percent-nostatus-nosign]",
            text = L["The percentage of health without percent sign and status"]
        }
    }

    examples.power = {
        name = L["Power"],
        noSign = {
            tag = "[power:percent-nosign]",
            text = L["The percentage of current power without percent sign"]
        },
        smart = {
            tag = "[smart-power]",
            text = L["Automatically select the best format of power (e.g. Rogue is 120, Mage is 100%)"]
        },
        smartNoSign = {
            tag = "[smart-power-nosign]",
            text = L["Automatically select the best format of power (e.g. Rogue is 120, Mage is 100)"]
        }
    }

    examples.range = {
        name = L["Range"],
        normal = {
            tag = "[range]",
            text = L["Range"]
        },
        expectation = {
            tag = "[range:expectation]",
            text = L["Range Expectation"]
        }
    }

    examples.color = {
        name = L["Color"],
        player = {
            order = 0,
            tag = "[classcolor:player]",
            text = L["The color of the player's class"]
        }
    }

    local className = {
        WARRIOR = L["Warrior"],
        PALADIN = L["Paladin"],
        HUNTER = L["Hunter"],
        ROGUE = L["Rogue"],
        PRIEST = L["Priest"],
        DEATHKNIGHT = L["Deathknight"],
        SHAMAN = L["Shaman"],
        MAGE = L["Mage"],
        WARLOCK = L["Warlock"],
        MONK = L["Monk"],
        DRUID = L["Druid"],
        DEMONHUNTER = L["Demonhunter"]
    }

    for i = 1, GetNumClasses() do
        local upperText = select(2, GetClassInfo(i))
        examples.color[upperText] = {
            order = i,
            tag = format("[classcolor:%s]", strlower(upperText)),
            text = format(L["The color of %s"], className[upperText])
        }
    end

    local index = 11
    for cat, catTable in pairs(examples) do
        options.tags.args[cat] = {
            order = index,
            type = "group",
            name = catTable.name,
            args = {}
        }
        index = index + 1

        local subIndex = 1
        for key, data in pairs(catTable) do
            if key ~= "name" then
                options.tags.args[cat].args[key] = {
                    order = data.order or subIndex,
                    type = "input",
                    width = "full",
                    name = data.text,
                    get = function()
                        return data.tag
                    end
                }
                subIndex = subIndex + 1
            end
        end
    end
end

options.gameBar = {
    order = 7,
    type = "group",
    name = L["Game Bar"],
    get = function(info)
        return E.db.WT.misc.gameBar[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.misc.gameBar[info[#info]] = value
        GB:ProfileUpdate()
    end,
    args = {
        desc = {
            order = 1,
            type = "group",
            inline = true,
            name = L["Description"],
            args = {
                feature = {
                    order = 1,
                    type = "description",
                    name = L["Add a game bar for improving QoL."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            desc = L["Toggle the game bar."]
        },
        general = {
            order = 10,
            type = "group",
            name = L["General"],
            disabled = function()
                return not E.db.WT.misc.gameBar.enable
            end,
            get = function(info)
                return E.db.WT.misc.gameBar[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.misc.gameBar[info[#info]] = value
                GB:UpdateButtons()
                GB:UpdateLayout()
            end,
            args = {
                backdrop = {
                    order = 1,
                    type = "toggle",
                    name = L["Bar Backdrop"],
                    desc = L["Show a backdrop of the bar."]
                },
                backdropSpacing = {
                    order = 2,
                    type = "range",
                    name = L["Backdrop Spacing"],
                    desc = L["The spacing between the backdrop and the buttons."],
                    min = 1,
                    max = 30,
                    step = 1
                },
                timeAreaWidth = {
                    order = 3,
                    type = "range",
                    name = L["Time Area Width"],
                    min = 1,
                    max = 200,
                    step = 1
                },
                timeAreaHeight = {
                    order = 4,
                    type = "range",
                    name = L["Time Area Height"],
                    min = 1,
                    max = 100,
                    step = 1
                },
                spacing = {
                    order = 5,
                    type = "range",
                    name = L["Button Spacing"],
                    desc = L["The spacing between buttons."],
                    min = 1,
                    max = 30,
                    step = 1
                },
                buttonSize = {
                    order = 6,
                    type = "range",
                    name = L["Button Size"],
                    desc = L["The size of the buttons."],
                    min = 2,
                    max = 80,
                    step = 1
                }
            }
        },
        display = {
            order = 11,
            type = "group",
            name = L["Display"],
            disabled = function()
                return not E.db.WT.misc.gameBar.enable
            end,
            get = function(info)
                return E.db.WT.misc.gameBar[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.misc.gameBar[info[#info]] = value
                GB:UpdateButtons()
                GB:UpdateTimeFormat()
                GB:UpdateTime()
            end,
            args = {
                bar = {
                    order = 1,
                    type = "group",
                    name = L["Bar"],
                    inline = true,
                    args = {
                        mouseOver = {
                            order = 1,
                            type = "toggle",
                            name = L["Mouse Over"],
                            desc = L["Show the bar only mouse hovered the area."],
                            set = function(info, value)
                                E.db.WT.misc.gameBar[info[#info]] = value
                                GB:UpdateBar()
                            end
                        },
                        notification = {
                            order = 2,
                            type = "toggle",
                            name = L["Notification"],
                            desc = L["Add an indicator icon to buttons."]
                        },
                        fadeTime = {
                            order = 3,
                            type = "range",
                            name = L["Fade Time"],
                            desc = L["The animation speed."],
                            min = 0,
                            max = 3,
                            step = 0.01
                        },
                        tooltipsAnchor = {
                            order = 4,
                            type = "select",
                            name = L["Tooltip Anchor"],
                            values = {
                                ANCHOR_TOP = L["TOP"],
                                ANCHOR_BOTTOM = L["BOTTOM"]
                            }
                        },
                        visibility = {
                            order = 5,
                            type = "input",
                            name = L["Visibility"],
                            set = function(info, value)
                                E.db.WT.misc.gameBar[info[#info]] = value
                                GB:UpdateBar()
                            end,
                            width = "full"
                        }
                    }
                },
                normal = {
                    order = 3,
                    type = "group",
                    name = L["Color"] .. " - " .. L["Normal"],
                    inline = true,
                    args = {
                        normalColor = {
                            order = 1,
                            type = "select",
                            name = L["Mode"],
                            values = {
                                NONE = L["None"],
                                CLASS = L["Class Color"],
                                VALUE = L["Value Color"],
                                CUSTOM = L["Custom"]
                            }
                        },
                        customNormalColor = {
                            order = 2,
                            type = "color",
                            hasAlpha = true,
                            name = L["Custom Color"],
                            hidden = function()
                                return E.db.WT.misc.gameBar.normalColor ~= "CUSTOM"
                            end,
                            get = function(info)
                                local db = E.db.WT.misc.gameBar[info[#info]]
                                local default = P.misc.gameBar[info[#info]]
                                return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
                            end,
                            set = function(info, r, g, b, a)
                                local db = E.db.WT.misc.gameBar[info[#info]]
                                db.r, db.g, db.b, db.a = r, g, b, a
                            end
                        }
                    }
                },
                hover = {
                    order = 4,
                    type = "group",
                    name = L["Color"] .. " - " .. L["Hover"],
                    inline = true,
                    args = {
                        hoverColor = {
                            order = 1,
                            type = "select",
                            name = L["Mode"],
                            values = {
                                NONE = L["None"],
                                CLASS = L["Class Color"],
                                VALUE = L["Value Color"],
                                CUSTOM = L["Custom"]
                            }
                        },
                        customHoverColor = {
                            order = 2,
                            type = "color",
                            hasAlpha = true,
                            name = L["Custom Color"],
                            hidden = function()
                                return E.db.WT.misc.gameBar.hoverColor ~= "CUSTOM"
                            end,
                            get = function(info)
                                local db = E.db.WT.misc.gameBar[info[#info]]
                                local default = P.misc.gameBar[info[#info]]
                                return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
                            end,
                            set = function(info, r, g, b, a)
                                local db = E.db.WT.misc.gameBar[info[#info]]
                                db.r, db.g, db.b, db.a = r, g, b, a
                            end
                        }
                    }
                },
                additionalText = {
                    order = 5,
                    type = "group",
                    name = L["Additional Text"],
                    inline = true,
                    get = function(info)
                        return E.db.WT.misc.gameBar.additionalText[info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.misc.gameBar.additionalText[info[#info]] = value
                        GB:UpdateButtons()
                    end,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = L["Enable"]
                        },
                        anchor = {
                            order = 2,
                            type = "select",
                            name = L["Anchor Point"],
                            values = {
                                TOP = L["TOP"],
                                BOTTOM = L["BOTTOM"],
                                LEFT = L["LEFT"],
                                RIGHT = L["RIGHT"],
                                CENTER = L["CENTER"],
                                TOPLEFT = L["TOPLEFT"],
                                TOPRIGHT = L["TOPRIGHT"],
                                BOTTOMLEFT = L["BOTTOMLEFT"],
                                BOTTOMRIGHT = L["BOTTOMRIGHT"]
                            }
                        },
                        x = {
                            order = 3,
                            type = "range",
                            name = L["X-Offset"],
                            min = -100,
                            max = 100,
                            step = 1
                        },
                        y = {
                            order = 4,
                            type = "range",
                            name = L["Y-Offset"],
                            min = -100,
                            max = 100,
                            step = 1
                        },
                        slowMode = {
                            order = 5,
                            type = "toggle",
                            name = L["Slow Mode"],
                            desc = L[
                                "Update the additional text every 10 seconds rather than every 1 second such that the used memory will be lower."
                            ]
                        },
                        font = {
                            order = 6,
                            type = "group",
                            name = L["Font Setting"],
                            inline = true,
                            get = function(info)
                                return E.db.WT.misc.gameBar.additionalText[info[#info - 1]][info[#info]]
                            end,
                            set = function(info, value)
                                E.db.WT.misc.gameBar.additionalText[info[#info - 1]][info[#info]] = value
                                GB:UpdateButtons()
                            end,
                            args = {
                                name = {
                                    order = 1,
                                    type = "select",
                                    dialogControl = "LSM30_Font",
                                    name = L["Font"],
                                    values = LSM:HashTable("font")
                                },
                                style = {
                                    order = 2,
                                    type = "select",
                                    name = L["Outline"],
                                    values = {
                                        NONE = L["None"],
                                        OUTLINE = L["OUTLINE"],
                                        MONOCHROME = L["MONOCHROME"],
                                        MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"],
                                        THICKOUTLINE = L["THICKOUTLINE"]
                                    }
                                },
                                size = {
                                    order = 3,
                                    name = L["Size"],
                                    type = "range",
                                    min = 5,
                                    max = 60,
                                    step = 1
                                }
                            }
                        }
                    }
                }
            }
        },
        time = {
            order = 12,
            type = "group",
            name = L["Time"],
            disabled = function()
                return not E.db.WT.misc.gameBar.enable
            end,
            get = function(info)
                return E.db.WT.misc.gameBar.time[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.misc.gameBar.time[info[#info]] = value
                GB:UpdateTimeArea()
                GB:UpdateLayout()
            end,
            args = {
                localTime = {
                    order = 2,
                    type = "toggle",
                    name = L["Local Time"]
                },
                twentyFour = {
                    order = 3,
                    type = "toggle",
                    name = L["24 Hours"]
                },
                flash = {
                    order = 4,
                    type = "toggle",
                    name = L["Flash"]
                },
                alwaysSystemInfo = {
                    order = 5,
                    type = "toggle",
                    name = L["Always Show Info"],
                    desc = L["The system information will be always shown rather than showing only being hovered."]
                },
                interval = {
                    order = 6,
                    type = "range",
                    name = L["Interval"],
                    desc = L["The interval of updating."],
                    set = function(info, value)
                        E.db.WT.misc.gameBar.time[info[#info]] = value
                        GB:UpdateTimeTicker()
                    end,
                    min = 1,
                    max = 60,
                    step = 1
                },
                font = {
                    order = 6,
                    type = "group",
                    name = L["Font Setting"],
                    inline = true,
                    get = function(info)
                        return E.db.WT.misc.gameBar.time[info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.misc.gameBar.time[info[#info - 1]][info[#info]] = value
                        GB:UpdateTimeFormat()
                        GB:UpdateTimeArea()
                    end,
                    args = {
                        name = {
                            order = 1,
                            type = "select",
                            dialogControl = "LSM30_Font",
                            name = L["Font"],
                            values = LSM:HashTable("font")
                        },
                        style = {
                            order = 2,
                            type = "select",
                            name = L["Outline"],
                            values = {
                                NONE = L["None"],
                                OUTLINE = L["OUTLINE"],
                                MONOCHROME = L["MONOCHROME"],
                                MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"],
                                THICKOUTLINE = L["THICKOUTLINE"]
                            }
                        },
                        size = {
                            order = 3,
                            name = L["Size"],
                            type = "range",
                            min = 5,
                            max = 60,
                            step = 1
                        }
                    }
                }
            }
        },
        home = {
            order = 13,
            type = "group",
            name = L["Home"],
            disabled = function()
                return not E.db.WT.misc.gameBar.enable
            end,
            get = function(info)
                return E.db.WT.misc.gameBar.home[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.misc.gameBar.home[info[#info]] = value
                GB:UpdateHomeButton()
                GB:UpdateButtons()
            end,
            args = {}
        },
        leftButtons = {
            order = 14,
            type = "group",
            name = L["Left Panel"],
            disabled = function()
                return not E.db.WT.misc.gameBar.enable
            end,
            get = function(info)
                return E.db.WT.misc.gameBar.left[tonumber(info[#info])]
            end,
            set = function(info, value)
                E.db.WT.misc.gameBar.left[tonumber(info[#info])] = value
                GB:UpdateButtons()
                GB:UpdateLayout()
            end,
            args = {}
        },
        rightButtons = {
            order = 16,
            type = "group",
            name = L["Right Panel"],
            disabled = function()
                return not E.db.WT.misc.gameBar.enable
            end,
            get = function(info)
                return E.db.WT.misc.gameBar.right[tonumber(info[#info])]
            end,
            set = function(info, value)
                E.db.WT.misc.gameBar.right[tonumber(info[#info])] = value
                GB:UpdateButtons()
            end,
            args = {}
        }
    }
}

do
    local availableButtons = GB:GetAvailableButtons()
    for i = 1, 7 do
        options.gameBar.args.leftButtons.args[tostring(i)] = {
            order = i,
            type = "select",
            name = format(L["Button #%d"], i),
            values = availableButtons
        }

        options.gameBar.args.rightButtons.args[tostring(i)] = {
            order = i,
            type = "select",
            name = format(L["Button #%d"], i),
            values = availableButtons
        }
    end

    options.gameBar.args.home.args.left = {
        order = 1,
        type = "select",
        name = L["Left Button"],
        values = function()
            return GB:GetHearthStoneTable()
        end
    }

    options.gameBar.args.home.args.right = {
        order = 2,
        type = "select",
        name = L["Right Button"],
        values = function()
            return GB:GetHearthStoneTable()
        end
    }
end

local SampleStrings = {}
do
    local icons = ""
    icons = icons .. E:TextureString(W.Media.Icons.ffxivTank, ":16:16") .. " "
    icons = icons .. E:TextureString(W.Media.Icons.ffxivHealer, ":16:16") .. " "
    icons = icons .. E:TextureString(W.Media.Icons.ffxivDPS, ":16:16")
    SampleStrings.ffxiv = icons

    icons = ""
    icons = icons .. E:TextureString(W.Media.Icons.hexagonTank, ":16:16") .. " "
    icons = icons .. E:TextureString(W.Media.Icons.hexagonHealer, ":16:16") .. " "
    icons = icons .. E:TextureString(W.Media.Icons.hexagonDPS, ":16:16")
    SampleStrings.hexagon = icons

    icons = ""
    icons = icons .. E:TextureString(CT.cache.elvuiRoleIconsPath.Tank, ":16:16:0:0:64:64:2:56:2:56") .. " "
    icons = icons .. E:TextureString(CT.cache.elvuiRoleIconsPath.Healer, ":16:16:0:0:64:64:2:56:2:56") .. " "
    icons = icons .. E:TextureString(CT.cache.elvuiRoleIconsPath.DPS, ":16:16")
    SampleStrings.elvui = icons

    icons = ""
    icons = icons .. E:TextureString(W.Media.Icons.sunUITank, ":16:16") .. " "
    icons = icons .. E:TextureString(W.Media.Icons.sunUIHealer, ":16:16") .. " "
    icons = icons .. E:TextureString(W.Media.Icons.sunUIDPS, ":16:16")
    SampleStrings.sunui = icons

    icons = ""
    icons = icons .. E:TextureString(W.Media.Icons.lynUITank, ":16:16") .. " "
    icons = icons .. E:TextureString(W.Media.Icons.lynUIHealer, ":16:16") .. " "
    icons = icons .. E:TextureString(W.Media.Icons.lynUIDPS, ":16:16")
    SampleStrings.lynui = icons
end

options.lfgList = {
    order = 8,
    type = "group",
    name = L["LFG List"],
    get = function(info)
        return E.private.WT.misc.lfgList[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.misc.lfgList[info[#info]] = value
        E:StaticPopup_Show("PRIVATE_RL")
    end,
    args = {
        desc = {
            order = 1,
            type = "group",
            inline = true,
            name = L["Description"],
            args = {
                feature = {
                    order = 1,
                    type = "description",
                    name = L["Reskinning the role icons."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"]
        },
        icon = {
            order = 3,
            type = "group",
            name = L["Icon"],
            disabled = function()
                return not E.private.WT.misc.lfgList.enable
            end,
            get = function(info)
                return E.private.WT.misc.lfgList.icon[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.misc.lfgList.icon[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            args = {
                reskin = {
                    order = 1,
                    type = "toggle",
                    name = L["Reskin Icon"],
                    desc = L["Change role icons."]
                },
                pack = {
                    order = 2,
                    type = "select",
                    name = L["Style"],
                    desc = L["Change the icons that indicate the role."],
                    hidden = function()
                        return not E.private.WT.misc.lfgList.icon.reskin
                    end,
                    values = {
                        SQUARE = L["Square"],
                        HEXAGON = SampleStrings.hexagon,
                        FFXIV = SampleStrings.ffxiv,
                        SUNUI = SampleStrings.sunui,
                        LYNUI = SampleStrings.lynui,
                        DEFAULT = SampleStrings.elvui
                    }
                },
                border = {
                    order = 3,
                    type = "toggle",
                    name = L["Border"]
                },
                size = {
                    order = 4,
                    type = "range",
                    name = L["Size"],
                    min = 1,
                    max = 20,
                    step = 1
                },
                alpha = {
                    order = 5,
                    type = "range",
                    name = L["Alpha"],
                    min = 0,
                    max = 1,
                    step = 0.01
                }
            }
        },
        line = {
            order = 4,
            type = "group",
            name = L["Line"],
            disabled = function()
                return not E.private.WT.misc.lfgList.enable
            end,
            get = function(info)
                return E.private.WT.misc.lfgList.line[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.misc.lfgList.line[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    desc = L["Add a line in class color."]
                },
                tex = {
                    order = 2,
                    type = "select",
                    name = L["Texture"],
                    dialogControl = "LSM30_Statusbar",
                    values = LSM:HashTable("statusbar")
                },
                width = {
                    order = 4,
                    type = "range",
                    name = L["Width"],
                    min = 1,
                    max = 20,
                    step = 1
                },
                height = {
                    order = 4,
                    type = "range",
                    name = L["Height"],
                    min = 1,
                    max = 20,
                    step = 1
                },
                offsetX = {
                    order = 5,
                    type = "range",
                    name = L["X-Offset"],
                    min = -20,
                    max = 20,
                    step = 1
                },
                offsetY = {
                    order = 6,
                    type = "range",
                    name = L["Y-Offset"],
                    min = -20,
                    max = 20,
                    step = 1
                },
                alpha = {
                    order = 7,
                    type = "range",
                    name = L["Alpha"],
                    min = 0,
                    max = 1,
                    step = 0.01
                }
            }
        }
    }
}
