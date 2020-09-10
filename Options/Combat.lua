local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.combat.args
local C = W:GetModule("CombatAlert")
local RM = W:GetModule("RaidMarkers")
local LSM = E.Libs.LSM

local _G = _G

options.combatAlert = {
    order = 1,
    type = "group",
    name = L["Combat Alert"],
    desc = L["Show a alert when you enter or leave combat."],
    get = function(info)
        return E.db.WT.combat.combatAlert[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.combat.combatAlert[info[#info]] = value
        C:ProfileUpdate()
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
                    name = L[
                        "This module will display a alert frame when entering and leaving combat.\n" ..
                            "You can customize animations and text effects."
                    ],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"]
        },
        speed = {
            order = 3,
            type = "range",
            name = L["Speed"],
            desc = L["The speed of the alert."],
            min = 0.1,
            max = 4,
            step = 0.01
        },
        preview = {
            order = 4,
            type = "execute",
            name = L["Preview"],
            desc = L["Preview the alert visual effect."],
            func = function()
                C:Preview()
            end
        },
        animationConfig = {
            order = 5,
            type = "group",
            inline = true,
            name = L["Animation"],
            args = {
                animation = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    desc = L["Display an animation when you enter or leave combat."]
                },
                animationSize = {
                    order = 2,
                    type = "range",
                    name = L["Animation Size"],
                    desc = L["The speed of the alert."],
                    min = 0.1,
                    max = 3,
                    step = 0.01
                }
            }
        },
        textConfig = {
            order = 6,
            type = "group",
            inline = true,
            name = L["Text"],
            args = {
                text = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    desc = L["Display a text when you enter or leave combat."]
                },
                enterText = {
                    order = 2,
                    type = "input",
                    name = L["Text (Enter)"]
                },
                enterColor = {
                    order = 3,
                    type = "color",
                    name = L["Color (Enter)"],
                    get = function(info)
                        local db = E.db.WT.combat.combatAlert[info[#info]]
                        local default = P.combat.combatAlert[info[#info]]
                        return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
                    end,
                    set = function(info, r, g, b, a)
                        local db = E.db.WT.combat.combatAlert[info[#info]]
                        db.r, db.g, db.b, db.a = r, g, b, a
                    end
                },
                leaveText = {
                    order = 4,
                    type = "input",
                    name = L["Text (Leave)"]
                },
                leaveColor = {
                    order = 5,
                    type = "color",
                    name = L["Color (Leave)"],
                    get = function(info)
                        local db = E.db.WT.combat.combatAlert[info[#info]]
                        local default = P.combat.combatAlert[info[#info]]
                        return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
                    end,
                    set = function(info, r, g, b, a)
                        local db = E.db.WT.combat.combatAlert[info[#info]]
                        db.r, db.g, db.b, db.a = r, g, b, a
                    end
                },
                font = {
                    type = "group",
                    order = 6,
                    name = L["Font Setting"],
                    get = function(info)
                        return E.db.WT.combat.combatAlert[info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.combat.combatAlert[info[#info - 1]][info[#info]] = value
                        C:ProfileUpdate()
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
}

options.raidMarkers = {
    order = 1,
    type = "group",
    name = L["Raid Markers"],
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
                    name = L["Add an extra bar to let you set raid markers efficiently."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            desc = L["Toggle raid markers bar."],
            get = function(info)
                return E.db.WT.combat.raidMarkers[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.combat.raidMarkers[info[#info]] = value
                RM:ProfileUpdate()
            end
        },
        visibilityConfig = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Visibility"],
            get = function(info)
                return E.db.WT.combat.raidMarkers[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.combat.raidMarkers[info[#info]] = value
                RM:ToggleSettings()
            end,
            disabled = function()
                return not E.db.WT.combat.raidMarkers.enable
            end,
            args = {
                visibility = {
                    type = "select",
                    order = 1,
                    name = L["Visibility"],
                    values = {
                        DEFAULT = L["Default"],
                        INPARTY = _G.AGGRO_WARNING_IN_PARTY,
                        ALWAYS = L["Always Display"]
                    }
                },
                mouseOver = {
                    order = 2,
                    type = "toggle",
                    name = L["Mouse Over"],
                    desc = L["Only show raid markers bar when you mouse over it."]
                },
                modifier = {
                    order = 3,
                    type = "select",
                    name = L["Modifier Key"],
                    desc = L["Set the modifier key for placing world markers."],
                    values = {
                        shift = L["Shift Key"],
                        ctrl = L["Ctrl Key"],
                        alt = L["Alt Key"]
                    }
                }
            }
        },
        barConfig = {
            order = 4,
            type = "group",
            inline = true,
            name = L["Raid Markers Bar"],
            get = function(info)
                return E.db.WT.combat.raidMarkers[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.combat.raidMarkers[info[#info]] = value
                RM:ToggleSettings()
            end,
            disabled = function()
                return not E.db.WT.combat.raidMarkers.enable
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
                orientation = {
                    order = 3,
                    type = "select",
                    name = L["Orientation"],
                    desc = L["Arrangement direction of the bar."],
                    values = {
                        HORIZONTAL = L["Horizontal"],
                        VERTICAL = L["Vertical"]
                    }
                }
            }
        },
        raidButtons = {
            order = 5,
            type = "group",
            inline = true,
            name = L["Raid Buttons"],
            get = function(info)
                return E.db.WT.combat.raidMarkers[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.combat.raidMarkers[info[#info]] = value
                RM:UpdateBar()
            end,
            disabled = function()
                return not E.db.WT.combat.raidMarkers.enable
            end,
            args = {
                readyCheck = {
                    order = 1,
                    type = "toggle",
                    name = _G.READY_CHECK,
                },
                countDown = {
                    order = 2,
                    type = "toggle",
                    name = L["Count Down"],
                },
                countDownTime = {
                    order = 3,
                    type = "range",
                    name = L["Count Down Time"],
                    desc = L["Count down time in seconds."],
                    min = 1,
                    max = 30,
                    step = 1
                },
            }
        },
        buttonsConfig = {
            order = 6,
            type = "group",
            inline = true,
            name = L["Buttons"],
            get = function(info)
                return E.db.WT.combat.raidMarkers[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.combat.raidMarkers[info[#info]] = value
                RM:ToggleSettings()
            end,
            disabled = function()
                return not E.db.WT.combat.raidMarkers.enable
            end,
            args = {
                buttonSize = {
                    order = 1,
                    type = "range",
                    name = L["Button Size"],
                    desc = L["The size of the buttons."],
                    min = 15,
                    max = 60,
                    step = 1
                },
                spacing = {
                    order = 3,
                    type = "range",
                    name = L["Button Spacing"],
                    desc = L["The spacing between buttons."],
                    min = 1,
                    max = 30,
                    step = 1
                }
            }
        }
        
    }
}
