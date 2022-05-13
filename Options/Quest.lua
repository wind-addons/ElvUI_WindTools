local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.quest.args
local LSM = E.Libs.LSM
local TI = W:GetModule("TurnIn")
local SB = W:GetModule("SwitchButtons")
local OT = W:GetModule("ObjectiveTracker")
local PR = W:GetModule("ParagonReputation")

local pairs = pairs
local tonumber = tonumber
local tostring = tostring

local ObjectiveTracker_Update = ObjectiveTracker_Update
local ReputationFrame_Update = ReputationFrame_Update

local customListSelected

options.objectiveTracker = {
    order = 1,
    type = "group",
    name = L["Objective Tracker"],
    get = function(info)
        return E.private.WT.quest.objectiveTracker[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.quest.objectiveTracker[info[#info]] = value
        ObjectiveTracker_Update()
    end,
    args = {
        desc = {
            order = 0,
            type = "group",
            inline = true,
            name = L["Description"],
            args = {
                feature_1 = {
                    order = 1,
                    type = "description",
                    name = L["1. Customize the font of Objective Tracker."],
                    fontSize = "medium"
                },
                feature_2 = {
                    order = 2,
                    type = "description",
                    name = L["2. Add colorful progress text to the quest."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 1,
            type = "toggle",
            name = L["Enable"],
            width = "full",
            set = function(info, value)
                E.private.WT.quest.objectiveTracker[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        progress = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Progress"],
            disabled = function()
                return not E.private.WT.quest.objectiveTracker.enable
            end,
            args = {
                noDash = {
                    order = 1,
                    type = "toggle",
                    disabled = function()
                        return not E.private.WT.quest.objectiveTracker.enable
                    end,
                    name = L["No Dash"]
                },
                colorfulProgress = {
                    order = 2,
                    type = "toggle",
                    name = L["Colorful Progress"]
                },
                percentage = {
                    order = 3,
                    type = "toggle",
                    name = L["Percentage"],
                    desc = L["Add percentage text after quest text."]
                },
                colorfulPercentage = {
                    order = 4,
                    type = "toggle",
                    name = L["Colorful Percentage"],
                    desc = L["Make the additional percentage text be colored."]
                }
            }
        },
        cosmeticBar = {
            order = 4,
            type = "group",
            inline = true,
            name = L["Cosmetic Bar"],
            disabled = function()
                return not E.private.WT.quest.objectiveTracker.enable
            end,
            get = function(info)
                return E.private.WT.quest.objectiveTracker.cosmeticBar[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.quest.objectiveTracker.cosmeticBar[info[#info]] = value
                OT:ChangeQuestHeaderStyle()
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"]
                },
                style = {
                    order = 2,
                    type = "group",
                    inline = true,
                    name = L["Style"],
                    disabled = function()
                        return not E.private.WT.quest.objectiveTracker.enable or
                            not E.private.WT.quest.objectiveTracker.cosmeticBar.enable
                    end,
                    args = {
                        texture = {
                            order = 1,
                            type = "select",
                            name = L["Texture"],
                            dialogControl = "LSM30_Statusbar",
                            values = LSM:HashTable("statusbar")
                        },
                        border = {
                            order = 2,
                            type = "select",
                            name = L["Border"],
                            values = {
                                NONE = L["None"],
                                ONEPIXEL = L["One Pixel"],
                                SHADOW = L["Shadow"]
                            }
                        },
                        borderAlpha = {
                            order = 3,
                            type = "range",
                            name = L["Border Alpha"],
                            min = 0,
                            max = 1,
                            step = 0.01
                        }
                    }
                },
                position = {
                    order = 3,
                    type = "group",
                    inline = true,
                    name = L["Position"],
                    disabled = function()
                        return not E.private.WT.quest.objectiveTracker.enable or
                            not E.private.WT.quest.objectiveTracker.cosmeticBar.enable
                    end,
                    args = {
                        widthMode = {
                            order = 1,
                            type = "select",
                            name = L["Width Mode"],
                            desc = L["'Absolute' mode means the width of the bar is fixed."] ..
                                "\n" .. L["'Dynamic' mode will also add the width of header text."],
                            values = {
                                ABSOLUTE = L["Absolute"],
                                DYNAMIC = L["Dyanamic"]
                            }
                        },
                        width = {
                            order = 2,
                            type = "range",
                            name = L["Width"],
                            min = -200,
                            max = 300,
                            step = 1
                        },
                        heightMode = {
                            order = 3,
                            type = "select",
                            name = L["Height Mode"],
                            desc = L["'Absolute' mode means the height of the bar is fixed."] ..
                                "\n" .. L["'Dynamic' mode will also add the height of header text."],
                            values = {
                                ABSOLUTE = L["Absolute"],
                                DYNAMIC = L["Dyanamic"]
                            }
                        },
                        height = {
                            order = 4,
                            type = "range",
                            name = L["Height"],
                            min = -200,
                            max = 300,
                            step = 1
                        },
                        offsetX = {
                            order = 5,
                            type = "range",
                            name = L["X-Offset"],
                            min = -500,
                            max = 500,
                            step = 1
                        },
                        offsetY = {
                            order = 6,
                            type = "range",
                            name = L["Y-Offset"],
                            min = -500,
                            max = 500,
                            step = 1
                        }
                    }
                },
                color = {
                    order = 4,
                    type = "group",
                    inline = true,
                    name = L["Color"],
                    disabled = function()
                        return not E.private.WT.quest.objectiveTracker.enable or
                            not E.private.WT.quest.objectiveTracker.cosmeticBar.enable
                    end,
                    get = function(info)
                        return E.private.WT.quest.objectiveTracker.cosmeticBar.color[info[#info]]
                    end,
                    set = function(info, value)
                        E.private.WT.quest.objectiveTracker.cosmeticBar.color[info[#info]] = value
                        OT:ChangeQuestHeaderStyle()
                    end,
                    args = {
                        mode = {
                            order = 1,
                            type = "select",
                            name = L["Color Mode"],
                            values = {
                                GRADIENT = L["Gradient"],
                                NORMAL = L["Normal"],
                                CLASS = L["Class Color"]
                            }
                        },
                        normalColor = {
                            order = 2,
                            type = "color",
                            name = L["Normal Color"],
                            hasAlpha = true,
                            hidden = function()
                                if E.private.WT.quest.objectiveTracker.cosmeticBar.color.mode ~= "NORMAL" then
                                    return true
                                end
                            end,
                            get = function(info)
                                local db = E.private.WT.quest.objectiveTracker.cosmeticBar.color.normalColor
                                local default = V.quest.objectiveTracker.cosmeticBar.color.normalColor
                                return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
                            end,
                            set = function(info, r, g, b, a)
                                local db = E.private.WT.quest.objectiveTracker.cosmeticBar.color.normalColor
                                db.r, db.g, db.b, db.a = r, g, b, a
                                OT:ChangeQuestHeaderStyle()
                            end
                        },
                        gradientColor1 = {
                            order = 3,
                            type = "color",
                            name = L["Gradient Color 1"],
                            hasAlpha = true,
                            hidden = function()
                                if E.private.WT.quest.objectiveTracker.cosmeticBar.color.mode ~= "GRADIENT" then
                                    return true
                                end
                            end,
                            get = function(info)
                                local db = E.private.WT.quest.objectiveTracker.cosmeticBar.color.gradientColor1
                                local default = V.quest.objectiveTracker.cosmeticBar.color.gradientColor1
                                return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
                            end,
                            set = function(info, r, g, b, a)
                                local db = E.private.WT.quest.objectiveTracker.cosmeticBar.color.gradientColor1
                                db.r, db.g, db.b, db.a = r, g, b, a
                                OT:ChangeQuestHeaderStyle()
                            end
                        },
                        gradientColor2 = {
                            order = 4,
                            type = "color",
                            name = L["Gradient Color 2"],
                            hasAlpha = true,
                            hidden = function()
                                if E.private.WT.quest.objectiveTracker.cosmeticBar.color.mode ~= "GRADIENT" then
                                    return true
                                end
                            end,
                            get = function(info)
                                local db = E.private.WT.quest.objectiveTracker.cosmeticBar.color.gradientColor2
                                local default = V.quest.objectiveTracker.cosmeticBar.color.gradientColor2
                                return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
                            end,
                            set = function(info, r, g, b, a)
                                local db = E.private.WT.quest.objectiveTracker.cosmeticBar.color.gradientColor2
                                db.r, db.g, db.b, db.a = r, g, b, a
                                OT:ChangeQuestHeaderStyle()
                            end
                        }
                    }
                },
                preset = {
                    order = 5,
                    type = "group",
                    inline = true,
                    name = L["Presets"],
                    disabled = function()
                        return not E.private.WT.quest.objectiveTracker.enable or
                            not E.private.WT.quest.objectiveTracker.cosmeticBar.enable
                    end,
                    args = {
                        tip = {
                            order = 1,
                            type = "description",
                            name = E.NewSign .. L["Here are some example presets, just try them!"]
                        },
                        default = {
                            order = 2,
                            type = "execute",
                            name = L["Default"],
                            func = function()
                                local db = E.private.WT.quest.objectiveTracker
                                db.header.style = "OUTLINE"
                                db.header.color = {r = 1, g = 1, b = 1}
                                db.header.size = E.db.general.fontSize + 2
                                db.cosmeticBar.texture = "WindTools Glow"
                                db.cosmeticBar.widthMode = "ABSOLUTE"
                                db.cosmeticBar.heightMode = "ABSOLUTE"
                                db.cosmeticBar.width = 212
                                db.cosmeticBar.height = 2
                                db.cosmeticBar.offsetX = 0
                                db.cosmeticBar.offsetY = -13
                                db.cosmeticBar.border = "SHADOW"
                                db.cosmeticBar.borderAlpha = 1
                                db.cosmeticBar.color.mode = "GRADIENT"
                                db.cosmeticBar.color.normalColor = {r = 0.000, g = 0.659, b = 1.000, a = 1}
                                db.cosmeticBar.color.gradientColor1 = {r = 0.32941, g = 0.52157, b = 0.93333, a = 1}
                                db.cosmeticBar.color.gradientColor2 = {r = 0.25882, g = 0.84314, b = 0.86667, a = 1}
                                OT:ChangeQuestHeaderStyle()
                            end
                        },
                        preset1 = {
                            order = 3,
                            type = "execute",
                            name = format(L["Preset %d"], 1),
                            func = function()
                                local db = E.private.WT.quest.objectiveTracker
                                db.header.style = "NONE"
                                db.header.color = {r = 1, g = 1, b = 1}
                                db.header.size = E.db.general.fontSize
                                db.cosmeticBar.texture = "ElvUI Blank"
                                db.cosmeticBar.widthMode = "DYNAMIC"
                                db.cosmeticBar.heightMode = "DYNAMIC"
                                db.cosmeticBar.width = 45
                                db.cosmeticBar.height = 16
                                db.cosmeticBar.offsetX = -10
                                db.cosmeticBar.offsetY = 0
                                db.cosmeticBar.border = "NONE"
                                db.cosmeticBar.borderAlpha = 1
                                db.cosmeticBar.color.mode = "GRADIENT"
                                db.cosmeticBar.color.normalColor = {r = 0.000, g = 0.659, b = 1.000, a = 1}
                                db.cosmeticBar.color.gradientColor1 = {r = 0.32941, g = 0.52157, b = 0.93333, a = 1}
                                db.cosmeticBar.color.gradientColor2 = {r = 0.25882, g = 0.84314, b = 0.86667, a = 0}
                                OT:ChangeQuestHeaderStyle()
                            end
                        },
                        preset2 = {
                            order = 4,
                            type = "execute",
                            name = format(L["Preset %d"], 2),
                            func = function()
                                local db = E.private.WT.quest.objectiveTracker
                                db.header.style = "NONE"
                                db.header.size = E.db.general.fontSize - 2
                                db.header.color = {r = 1, g = 1, b = 1}
                                db.cosmeticBar.texture = "ElvUI Blank"
                                db.cosmeticBar.widthMode = "DYNAMIC"
                                db.cosmeticBar.heightMode = "DYNAMIC"
                                db.cosmeticBar.width = 7
                                db.cosmeticBar.height = 12
                                db.cosmeticBar.offsetX = -7
                                db.cosmeticBar.offsetY = 0
                                db.cosmeticBar.border = "ONEPIXEL"
                                db.cosmeticBar.borderAlpha = 1
                                db.cosmeticBar.color.mode = "GRADIENT"
                                db.cosmeticBar.color.normalColor = {r = 0.000, g = 0.659, b = 1.000, a = 1}
                                db.cosmeticBar.color.gradientColor1 = {r = 0.32941, g = 0.52157, b = 0.93333, a = 1}
                                db.cosmeticBar.color.gradientColor2 = {r = 0.25882, g = 0.84314, b = 0.86667, a = 1}
                                OT:ChangeQuestHeaderStyle()
                            end
                        },
                        preset3 = {
                            order = 5,
                            type = "execute",
                            name = format(L["Preset %d"], 3),
                            func = function()
                                local db = E.private.WT.quest.objectiveTracker
                                db.header.style = "OUTLINE"
                                db.header.color = {r = 1, g = 1, b = 1}
                                db.header.size = E.db.general.fontSize + 2
                                db.cosmeticBar.texture = "Solid"
                                db.cosmeticBar.widthMode = "DYNAMIC"
                                db.cosmeticBar.heightMode = "ABSOLUTE"
                                db.cosmeticBar.width = 30
                                db.cosmeticBar.height = 10
                                db.cosmeticBar.offsetX = -2
                                db.cosmeticBar.offsetY = -7
                                db.cosmeticBar.border = "NONE"
                                db.cosmeticBar.borderAlpha = 1
                                db.cosmeticBar.color.mode = "NORMAL"
                                db.cosmeticBar.color.normalColor = {r = 0.681, g = 0.681, b = 0.681, a = 0.681}
                                db.cosmeticBar.color.gradientColor1 = {r = 0.32941, g = 0.52157, b = 0.93333, a = 1}
                                db.cosmeticBar.color.gradientColor2 = {r = 0.25882, g = 0.84314, b = 0.86667, a = 1}
                                OT:ChangeQuestHeaderStyle()
                            end
                        },
                        preset4 = {
                            order = 6,
                            type = "execute",
                            name = format(L["Preset %d"], 4),
                            func = function()
                                local db = E.private.WT.quest.objectiveTracker
                                db.header.style = "OUTLINE"
                                db.header.color = {r = 1, g = 1, b = 1}
                                db.header.size = E.db.general.fontSize + 3
                                db.cosmeticBar.texture = "Solid"
                                db.cosmeticBar.widthMode = "ABSOLUTE"
                                db.cosmeticBar.heightMode = "ABSOLUTE"
                                db.cosmeticBar.width = 260
                                db.cosmeticBar.height = 24
                                db.cosmeticBar.offsetX = -7
                                db.cosmeticBar.offsetY = 0
                                db.cosmeticBar.border = "ONEPIXEL"
                                db.cosmeticBar.borderAlpha = 1
                                db.cosmeticBar.color.mode = "GRADIENT"
                                db.cosmeticBar.color.normalColor = {r = 0.681, g = 0.681, b = 0.681, a = 0.681}
                                db.cosmeticBar.color.gradientColor1 = {r = 0.32941, g = 0.52157, b = 0.93333, a = 1}
                                db.cosmeticBar.color.gradientColor2 = {r = 0.25882, g = 0.84314, b = 0.86667, a = 1}
                                OT:ChangeQuestHeaderStyle()
                            end
                        }
                    }
                }
            }
        },
        header = {
            order = 5,
            type = "group",
            inline = true,
            name = L["Header"],
            disabled = function()
                return not E.private.WT.quest.objectiveTracker.enable
            end,
            get = function(info)
                return E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]]
            end,
            set = function(info, value)
                E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
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
                },
                shortHeader = {
                    order = 4,
                    type = "toggle",
                    name = L["Short Header"],
                    desc = L["Use short name instead. e.g. Torghast, Tower of the Damned to Torghast."]
                },
                color = {
                    order = 5,
                    type = "color",
                    name = L["Color"],
                    hasAlpha = false,
                    get = function(info)
                        local db = E.private.WT.quest.objectiveTracker.header.color
                        local default = V.quest.objectiveTracker.header.color
                        return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                    end,
                    set = function(info, r, g, b)
                        local db = E.private.WT.quest.objectiveTracker.header.color
                        db.r, db.g, db.b = r, g, b
                        OT:ChangeQuestHeaderStyle()
                    end
                }
            }
        },
        titleColor = {
            order = 6,
            type = "group",
            inline = true,
            name = L["Title Color"],
            disabled = function()
                return not E.private.WT.quest.objectiveTracker.enable
            end,
            get = function(info)
                return E.private.WT.quest.objectiveTracker.titleColor[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.quest.objectiveTracker.titleColor[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    desc = L["Change the color of quest titles."]
                },
                classColor = {
                    order = 2,
                    type = "toggle",
                    name = L["Use Class Color"]
                },
                customColorNormal = {
                    order = 3,
                    type = "color",
                    name = L["Normal Color"],
                    hasAlpha = false,
                    get = function(info)
                        local db = E.private.WT.quest.objectiveTracker.titleColor.customColorNormal
                        local default = V.quest.objectiveTracker.titleColor.customColorNormal
                        return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                    end,
                    set = function(info, r, g, b)
                        local db = E.private.WT.quest.objectiveTracker.titleColor.customColorNormal
                        db.r, db.g, db.b = r, g, b
                    end
                },
                customColorHighlight = {
                    order = 4,
                    type = "color",
                    name = L["Highlight Color"],
                    hasAlpha = false,
                    get = function(info)
                        local db = E.private.WT.quest.objectiveTracker.titleColor.customColorHighlight
                        local default = V.quest.objectiveTracker.titleColor.customColorHighlight
                        return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                    end,
                    set = function(info, r, g, b)
                        local db = E.private.WT.quest.objectiveTracker.titleColor.customColorHighlight
                        db.r, db.g, db.b = r, g, b
                    end
                }
            }
        },
        title = {
            order = 6,
            type = "group",
            inline = true,
            name = L["Title"],
            disabled = function()
                return not E.private.WT.quest.objectiveTracker.enable
            end,
            get = function(info)
                return E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]]
            end,
            set = function(info, value)
                E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
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
        },
        info = {
            order = 7,
            type = "group",
            inline = true,
            name = L["Information"],
            disabled = function()
                return not E.private.WT.quest.objectiveTracker.enable
            end,
            get = function(info)
                return E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]]
            end,
            set = function(info, value)
                E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
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

options.turnIn = {
    order = 2,
    type = "group",
    name = L["Turn In"],
    get = function(info)
        return E.db.WT.quest.turnIn[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.quest.turnIn[info[#info]] = value
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
                    name = L["Make quest acceptance and completion automatically."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            set = function(info, value)
                E.db.WT.quest.turnIn[info[#info]] = value
                TI:ProfileUpdate()
                SB:ProfileUpdate()
            end,
            width = "full"
        },
        mode = {
            order = 3,
            type = "select",
            name = L["Mode"],
            disabled = function()
                return not E.db.WT.quest.turnIn.enable
            end,
            values = {
                ALL = L["All"],
                ACCEPT = L["Only Accept"],
                COMPLETE = L["Only Complete"]
            }
        },
        pauseModifier = {
            order = 4,
            type = "select",
            name = L["Pause On Press"],
            desc = L["Pause the automation by pressing a modifier key."],
            disabled = function()
                return not E.db.WT.quest.turnIn.enable
            end,
            values = {
                ANY = L["Any"],
                ALT = L["Alt Key"],
                CTRL = L["Ctrl Key"],
                SHIFT = L["Shift Key"],
                NONE = L["None"]
            }
        },
        reward = {
            order = 5,
            type = "group",
            inline = true,
            name = L["Reward"],
            disabled = function()
                return not E.db.WT.quest.turnIn.enable
            end,
            args = {
                selectReward = {
                    order = 1,
                    type = "toggle",
                    name = L["Select Reward"],
                    desc = L[
                        "If there are multiple items in the reward list, it will select the reward with the highest sell price."
                    ],
                    disabled = function()
                        return not E.db.WT.quest.turnIn.enable or E.db.WT.quest.turnIn.mode == "ACCEPT"
                    end
                },
                getBestReward = {
                    order = 2,
                    type = "toggle",
                    name = L["Get Best Reward"],
                    desc = L["Complete the quest with the most valuable reward."],
                    disabled = function()
                        return not E.db.WT.quest.turnIn.enable or E.db.WT.quest.turnIn.mode == "ACCEPT" or
                            not E.db.WT.quest.turnIn.selectReward
                    end
                }
            }
        },
        smartChat = {
            order = 6,
            type = "group",
            inline = true,
            name = L["Smart Chat"],
            disabled = function()
                return not E.db.WT.quest.turnIn.enable
            end,
            args = {
                smartChat = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    desc = L["Chat with NPCs smartly. It will automatically select the best option for you."],
                    disabled = function()
                        return not E.db.WT.quest.turnIn.enable
                    end
                },
                darkmoon = {
                    order = 2,
                    type = "toggle",
                    name = L["Dark Moon"],
                    desc = L["Accept the teleportation from Darkmoon Faire Mystic Mage automatically."],
                    disabled = function()
                        return not E.db.WT.quest.turnIn.enable or not E.db.WT.quest.turnIn.smartChat
                    end
                },
                followerAssignees = {
                    order = 3,
                    type = "toggle",
                    name = L["Follower Assignees"],
                    desc = L["Open the window of follower recruit automatically."],
                    disabled = function()
                        return not E.db.WT.quest.turnIn.enable or not E.db.WT.quest.turnIn.smartChat
                    end
                }
            }
        },
        ignore = {
            order = 7,
            type = "group",
            inline = true,
            name = L["Ignored NPCs"],
            disabled = function()
                return not E.db.WT.quest.turnIn.enable
            end,
            args = {
                description = {
                    order = 1,
                    type = "description",
                    name = "\n" .. L["If you add the NPC into the list, all automation will do not work for it."],
                    width = "full"
                },
                list = {
                    order = 2,
                    type = "select",
                    name = L["Ignore List"],
                    get = function()
                        return customListSelected
                    end,
                    set = function(_, value)
                        customListSelected = value
                    end,
                    values = function()
                        local list = E.db.WT.quest.turnIn.customIgnoreNPCs
                        local result = {}
                        for key, value in pairs(list) do
                            result[tostring(key)] = value
                        end
                        return result
                    end
                },
                addButton = {
                    order = 3,
                    type = "execute",
                    name = L["Add Target"],
                    desc = L["Make sure you select the NPC as your target."],
                    func = function()
                        TI:AddTargetToBlacklist()
                    end
                },
                deleteButton = {
                    order = 4,
                    type = "execute",
                    name = L["Delete"],
                    desc = L["Delete the selected NPC."],
                    func = function()
                        if customListSelected then
                            local list = E.db.WT.quest.turnIn.customIgnoreNPCs
                            list[tonumber(customListSelected)] = nil
                        end
                    end
                }
            }
        }
    }
}

options.switchButtons = {
    order = 3,
    type = "group",
    name = L["Switch Buttons"],
    get = function(info)
        return E.db.WT.quest.switchButtons[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.quest.switchButtons[info[#info]] = value
        SB:ProfileUpdate()
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
                    name = L["Add a bar that contains buttons to enable/disable modules quickly."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            width = "full"
        },
        hideWithObjectiveTracker = {
            order = 3,
            type = "toggle",
            name = L["Hide With Objective Tracker"],
            disabled = function()
                return not E.db.WT.quest.switchButtons.enable
            end,
            width = 1.5
        },
        tooltip = {
            order = 4,
            type = "toggle",
            disabled = function()
                return not E.db.WT.quest.switchButtons.enable
            end,
            name = L["Tooltip"]
        },
        backdrop = {
            order = 5,
            type = "toggle",
            disabled = function()
                return not E.db.WT.quest.switchButtons.enable
            end,
            name = L["Bar Backdrop"]
        },
        font = {
            order = 6,
            type = "group",
            inline = true,
            name = L["Font Setting"],
            disabled = function()
                return not E.db.WT.quest.switchButtons.enable
            end,
            get = function(info)
                return E.db.WT.quest.switchButtons.font[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.quest.switchButtons.font[info[#info]] = value
                SB:UpdateLayout()
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
                },
                color = {
                    order = 4,
                    type = "color",
                    name = L["Color"],
                    hasAlpha = false,
                    get = function(info)
                        local db = E.db.WT.quest.switchButtons.font.color
                        local default = P.quest.switchButtons.font.color
                        return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                    end,
                    set = function(info, r, g, b)
                        local db = E.db.WT.quest.switchButtons.font.color
                        db.r, db.g, db.b = r, g, b
                        SB:UpdateLayout()
                    end
                }
            }
        },
        modules = {
            order = 6,
            type = "group",
            inline = true,
            name = L["Modules"],
            disabled = function()
                return not E.db.WT.quest.switchButtons.enable
            end,
            get = function(info)
                return E.db.WT.quest.switchButtons[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.quest.switchButtons[info[#info]] = value
                SB:UpdateLayout()
            end,
            args = {
                announcement = {
                    order = 1,
                    type = "toggle",
                    name = L["Announcement"] .. " (" .. L["Quest"] .. ")",
                    width = 1.667
                },
                turnIn = {
                    order = 2,
                    type = "toggle",
                    name = L["Turn In"],
                    width = 1.667
                }
            }
        }
    }
}

options.paragonReputation = {
    order = 4,
    type = "group",
    name = L["Paragon Reputation"],
    get = function(info)
        return E.db.WT.quest.paragonReputation[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.quest.paragonReputation[info[#info]] = value
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
                    name = L["Better visualization of Paragon Factions on the Reputation Frame."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            set = function(info, value)
                E.db.WT.quest.paragonReputation[info[#info]] = value
                PR:ProfileUpdate()
            end
        },
        reputation_panel = {
            order = 3,
            name = L["Reputation panel"],
            type = "group",
            inline = true,
            disabled = function()
                return not E.db.WT.quest.paragonReputation.enable
            end,
            set = function(info, value)
                E.db.WT.quest.paragonReputation[info[#info]] = value
                ReputationFrame_Update()
            end,
            args = {
                color = {
                    order = 1,
                    name = L["Color"],
                    type = "color",
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.WT.quest.paragonReputation.color
                        return t.r, t.g, t.b, 1, 0, .5, .9, 1
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.WT.quest.paragonReputation.color
                        t.r, t.g, t.b = r, g, b
                        ReputationFrame_Update()
                    end
                },
                text = {
                    order = 2,
                    name = L["Format"],
                    type = "select",
                    values = {
                        PARAGON = L["Paragon"] .. " (100/10000)",
                        EXALTED = L["Exalted"] .. " (100/10000)",
                        PARAGONPLUS = L["Paragon"] .. " x 1" .. " (100/10000)",
                        CURRENT = "100 (100/10000)",
                        VALUE = "100/10000",
                        DEFICIT = "9900"
                    }
                }
            }
        },
        toast = {
            order = 4,
            name = L["Toast"],
            type = "group",
            inline = true,
            disabled = function()
                return not E.db.WT.quest.paragonReputation.enable
            end,
            get = function(info)
                return E.db.WT.quest.paragonReputation[info[#info - 1]][info[#info]]
            end,
            set = function(info, value)
                E.db.WT.quest.paragonReputation[info[#info - 1]][info[#info]] = value
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"]
                },
                sound = {
                    order = 2,
                    type = "toggle",
                    name = L["Sound"]
                },
                fade_time = {
                    order = 3,
                    type = "range",
                    name = L["Fade Time"],
                    min = 1,
                    max = 15.0,
                    step = 0.01
                }
            }
        }
    }
}
