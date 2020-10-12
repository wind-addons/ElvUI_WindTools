local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.misc.args
local LSM = E.Libs.LSM
local M = W:GetModule("Misc")
local MF = W:GetModule("MoveFrames")
local GB = W:GetModule("GameBar")

local format = format
local tonumber = tonumber
local tostring = tostring

local GetClassInfo = GetClassInfo
local GetNumClasses = GetNumClasses
local GetSpellInfo = GetSpellInfo

local C_CVar_GetCVar = C_CVar.GetCVar
local C_CVar_GetCVarBool = C_CVar.GetCVarBool
local C_CVar_SetCVar = C_CVar.SetCVar

options.cvars = {
    order = 1,
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
                },
                showQuestTrackingTooltips = {
                    order = 2,
                    type = "toggle",
                    name = L["Show Quest Info"],
                    desc = L["Add progress information (Ex. Mob 10/25)."]
                }
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
    order = 2,
    type = "group",
    name = L["Move Frames"],
    get = function(info)
        return E.private.WT.misc[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.misc[info[#info]] = value
        E:StaticPopup_Show("PRIVATE_RL")
    end,
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
        moveBlizzardFrames = {
            order = 1,
            type = "toggle",
            name = L["Enable"]
        },
        moveElvUIBags = {
            order = 2,
            type = "toggle",
            name = L["Move ElvUI Bags"]
        },
        remember = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Remember Positions"],
            args = {
                rememberPositions = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    set = function(info, value)
                        E.private.WT.misc[info[#info]] = value
                    end
                },
                clearHistory = {
                    order = 2,
                    type = "execute",
                    name = L["Clear History"],
                    func = function()
                        E.private.WT.misc.framePositions = {}
                    end
                }
            }
        }
    }
}

options.transmog = {
    order = 3,
    type = "group",
    name = L["Transmog"],
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
                    name = L["This module focus on enhancement of transmog."],
                    fontSize = "medium"
                }
            }
        },
        saveArtifact = {
            order = 2,
            type = "toggle",
            name = L["Save Artifact"],
            desc = L["Allow you to save outfits even if the artifact in it."],
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

options.mute = {
    order = 3,
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
        }
    }
}

do
    for id in pairs(V.misc.mute.mount) do
        options.mute.args.mount.args[tostring(id)] = {
            order = id,
            type = "toggle",
            name = GetSpellInfo(id)
        }
    end
end

options.pauseToSlash = {
    order = 5,
    type = "group",
    name = L["Pause to slash"],
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
                    name = L[
                        "This module works with Chinese and Korean, it will correct the text to slash when you input Pause."
                    ],
                    fontSize = "medium"
                }
            }
        },
        pauseToSlash = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            desc = L["Pause to slash (Just for Chinese and Korean players)"],
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

options.disableTalkingHead = {
    order = 6,
    type = "group",
    name = L["Disable Talking Head"],
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
                    name = L["Enable this module will disable Blizzard Talking Head."],
                    fontSize = "medium"
                }
            }
        },
        disableTalkingHead = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            desc = L["Stop talking."],
            get = function(info)
                return E.private.WT.misc[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.misc[info[#info]] = value
            end
        }
    }
}

options.tags = {
    order = 7,
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
    order = 8,
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
                fadeTime = {
                    order = 1,
                    type = "range",
                    name = L["Fade Time"],
                    desc = L["The animation speed."],
                    min = 0,
                    max = 3,
                    step = 0.01
                },
                normal = {
                    order = 2,
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
                    order = 3,
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
                    order = 4,
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
                            desc = L["Update the additional text every 10 seconds rather than every 1 second such that the used memory will be lower."]
                        },
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
                interval = {
                    order = 5,
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
    local heartstones = {
        ["6948"] = GetItemInfo(6948), -- 爐石
        ["110560"] = GetItemInfo(110560), -- 要塞爐石
        ["140192"] = GetItemInfo(140192), -- 達拉然爐石
        ["141605"] = GetItemInfo(141605), -- 飛行管理員的哨子
        ["162973"] = GetItemInfo(162973), -- 冬天爺爺的爐石
        ["163045"] = GetItemInfo(163045), -- 無頭騎士的爐石
        ["165669"] = GetItemInfo(165669), -- 新年長者的爐石
        ["165670"] = GetItemInfo(165670), -- 傳播者充滿愛的爐石
        ["165802"] = GetItemInfo(165802), -- 貴族園丁的爐石
        ["166746"] = GetItemInfo(166746), -- 吞火者的爐石
        ["166747"] = GetItemInfo(166747), -- 啤酒節狂歡者的爐石
        ["168907"] = GetItemInfo(168907), -- 全像數位化爐石
        ["172179"] = GetItemInfo(172179), -- 永恆旅人的爐石
        ["180290"] = GetItemInfo(180290), -- 暗夜妖精的爐石
        ["182773"] = GetItemInfo(182773), -- 死靈領主爐石
        ["184353"] = GetItemInfo(184353) -- 琪瑞安族爐石
    }

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
        values = heartstones
    }

    options.gameBar.args.home.args.right = {
        order = 2,
        type = "select",
        name = L["Right Button"],
        values = heartstones
    }
end
