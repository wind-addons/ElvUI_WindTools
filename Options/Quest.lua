local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.quest.args
local LSM = E.Libs.LSM
local TI = W:GetModule("TurnIn")
local SB = W:GetModule("SwitchButtons")
local OT = W:GetModule("ObjectiveTracker")

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
        noDash = {
            order = 2,
            type = "toggle",
            disabled = function()
                return not E.private.WT.quest.objectiveTracker.enable
            end,
            name = L["No Dash"]
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
                colorfulProgress = {
                    order = 1,
                    type = "toggle",
                    name = L["Colorful Progress"]
                },
                percentage = {
                    order = 2,
                    type = "toggle",
                    name = L["Percentage"],
                    desc = L["Add percentage text after quest text."]
                },
                colorfulPercentage = {
                    order = 3,
                    type = "toggle",
                    name = L["Colorful Percentage"],
                    desc = L["Make the additional percentage text be colored."]
                }
            }
        },
        titleColor = {
            order = 4,
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
                OT:ChangeQuestTitleColor()
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
        selectReward = {
            order = 3,
            type = "toggle",
            name = L["Select Reward"],
            desc = L[
                "If there are multiple items in the reward list, it will select the reward with the highest sell price."
            ],
            disabled = function()
                return not E.db.WT.quest.turnIn.enable
            end,
            width = 1.667
        },
        darkmoon = {
            order = 4,
            type = "toggle",
            name = L["Dark Moon"],
            desc = L["Accept the teleportation from Darkmoon Faire Mystic Mage automatically."],
            disabled = function()
                return not E.db.WT.quest.turnIn.enable
            end,
            width = 1.667
        },
        followerAssignees = {
            order = 5,
            type = "toggle",
            name = L["Follower Assignees"],
            desc = L["Open the window of follower recruit automatically."],
            disabled = function()
                return not E.db.WT.quest.turnIn.enable
            end,
            width = 1.667
        },
        rogueClassHallInsignia = {
            order = 6,
            type = "toggle",
            name = L["Rogue Class Hall Insignia"],
            desc = L["Open the passageway to Rogue Class Hall automatically."],
            disabled = function()
                return not E.db.WT.quest.turnIn.enable
            end,
            width = 1.667
        },
        custom = {
            order = 7,
            type = "group",
            inline = true,
            name = L["Ignored NPCs"],
            disabled = function()
                return not E.db.WT.quest.turnIn.enable
            end,
            args = {
                modifierKeyPause = {
                    order = 1,
                    type = "toggle",
                    name = L["Pause On Press"],
                    desc = L["Pause the automation by pressing a modifier key."],
                    width = "full"
                },
                description = {
                    order = 2,
                    type = "description",
                    name = "\n" .. L["If you add the NPC into the list, all automation will do not work for it."],
                    width = "full"
                },
                list = {
                    order = 3,
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
                    order = 4,
                    type = "execute",
                    name = L["Add Target"],
                    desc = L["Make sure you select the NPC as your target."],
                    func = function()
                        TI:AddTargetToBlacklist()
                    end
                },
                deleteButton = {
                    order = 5,
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
                    name = L["Add a bar contains buttons to enable/disable modules quickly."],
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
        backdrop = {
            order = 4,
            type = "toggle",
            disabled = function()
                return not E.db.WT.quest.switchButtons.enable
            end,
            name = L["Bar Backdrop"]
        },
        font = {
            order = 5,
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
            name = L["Enable"]
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
