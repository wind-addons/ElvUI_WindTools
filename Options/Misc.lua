local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.misc.args
local LSM = E.Libs.LSM
local M = W:GetModule("Misc")
local MF = W:GetModule("MoveFrames")
local EB = W:GetModule("ExtraItemsBar")

local _G = _G
local format = format
local pairs = pairs
local print = print
local select = select
local strlower = strlower
local tinsert = tinsert
local tonumber = tonumber
local tremove = tremove

local GetClassInfo = GetClassInfo
local GetItemInfo = GetItemInfo
local GetNumClasses = GetNumClasses

local C_CVar_GetCVarBool = C_CVar.GetCVarBool
local C_CVar_SetCVar = C_CVar.SetCVar

local customListSelected1
local customListSelected2

local function ImportantColorString(string)
    return F.CreateColorString(string, {r = 0.204, g = 0.596, b = 0.859})
end

local function FormatDesc(code, helpText)
    return ImportantColorString(code) .. " = " .. helpText
end

options.extraItemsBar = {
    order = 1,
    type = "group",
    name = L["Extra Items Bar"],
    get = function(info)
        return E.db.WT.misc.extraItemsBar[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.misc.extraItemsBar[info[#info]] = value
        EB:ProfileUpdate()
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
                    name = L["Add a bar to contain quest items and usable equipment."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"]
        },
        custom = {
            order = 6,
            type = "group",
            inline = true,
            name = L["Custom Items"],
            disabled = function()
                return not E.db.WT.misc.extraItemsBar.enable
            end,
            args = {
                list = {
                    order = 1,
                    type = "select",
                    name = L["List"],
                    get = function()
                        return customListSelected1
                    end,
                    set = function(_, value)
                        customListSelected1 = value
                    end,
                    values = function()
                        local list = E.db.WT.misc.extraItemsBar.customList
                        local result = {}
                        for key, value in pairs(list) do
                            result[key] = select(1, GetItemInfo(value))
                        end
                        return result
                    end
                },
                addToList = {
                    order = 2,
                    type = "input",
                    name = L["New Item ID"],
                    get = function()
                        return ""
                    end,
                    set = function(_, value)
                        local itemID = tonumber(value)
                        local itemName = select(1, GetItemInfo(itemID))
                        if itemName then
                            tinsert(E.db.WT.misc.extraItemsBar.customList, itemID)
                            EB:UpdateBars()
                        else
                            print(L["The item ID is invalid."])
                        end
                    end
                },
                deleteButton = {
                    order = 3,
                    type = "execute",
                    name = L["Delete"],
                    desc = L["Delete the selected item."],
                    func = function()
                        if customListSelected1 then
                            local list = E.db.WT.misc.extraItemsBar.customList
                            tremove(list, customListSelected1)
                            EB:UpdateBars()
                        end
                    end
                }
            }
        },
        blackList = {
            order = 7,
            type = "group",
            inline = true,
            name = L["Blacklist"],
            disabled = function()
                return not E.db.WT.misc.extraItemsBar.enable
            end,
            args = {
                list = {
                    order = 1,
                    type = "select",
                    name = L["List"],
                    get = function()
                        return customListSelected2
                    end,
                    set = function(_, value)
                        customListSelected2 = value
                    end,
                    values = function()
                        local result = {}
                        for key, value in pairs(E.db.WT.misc.extraItemsBar.blackList) do
                            result[key] = value
                        end
                        return result
                    end
                },
                addToList = {
                    order = 2,
                    type = "input",
                    name = L["New Item ID"],
                    get = function()
                        return ""
                    end,
                    set = function(_, value)
                        local itemID = tonumber(value)
                        local itemName = select(1, GetItemInfo(itemID))
                        if itemName then
                            E.db.WT.misc.extraItemsBar.blackList[itemID] = itemName
                            EB:UpdateBars()
                        else
                            print(L["The item ID is invalid."])
                        end
                    end
                },
                deleteButton = {
                    order = 3,
                    type = "execute",
                    name = L["Delete"],
                    desc = L["Delete the selected item."],
                    func = function()
                        if customListSelected2 then
                            E.db.WT.misc.extraItemsBar.blackList[customListSelected2] = nil
                            EB:UpdateBars()
                        end
                    end
                }
            }
        }
    }
}

do -- 添加按钮设定组
    for i = 1, 3 do
        options.extraItemsBar.args["bar" .. i] = {
            order = i + 2,
            type = "group",
            inline = true,
            name = L["Bar"] .. " " .. i,
            get = function(info)
                return E.db.WT.misc.extraItemsBar["bar" .. i][info[#info]]
            end,
            set = function(info, value)
                E.db.WT.misc.extraItemsBar["bar" .. i][info[#info]] = value
                EB:UpdateBar(i)
            end,
            disabled = function()
                return not E.db.WT.misc.extraItemsBar.enable
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"]
                },
                mouseOver = {
                    order = 2,
                    type = "toggle",
                    name = L["Mouse Over"],
                    desc = L["Only show the bar when you mouse over it."]
                },
                anchor = {
                    order = 3,
                    type = "select",
                    name = L["Anchor Point"],
                    desc = L["The first button anchors itself to this point on the bar."],
                    values = {
                        TOPLEFT = L["TOPLEFT"],
                        TOPRIGHT = L["TOPRIGHT"],
                        BOTTOMLEFT = L["BOTTOMLEFT"],
                        BOTTOMRIGHT = L["BOTTOMRIGHT"]
                    }
                },
                betterOption1 = {
                    order = 4,
                    type = "description",
                    name = " ",
                    width = "full"
                },
                backdrop = {
                    order = 5,
                    type = "toggle",
                    name = L["Bar Backdrop"],
                    desc = L["Show a backdrop of the bar."]
                },
                backdropSpacing = {
                    order = 6,
                    type = "range",
                    name = L["Backdrop Spacing"],
                    desc = L["The spacing between the backdrop and the buttons."],
                    min = 1,
                    max = 30,
                    step = 1
                },
                spacing = {
                    order = 7,
                    type = "range",
                    name = L["Button Spacing"],
                    desc = L["The spacing between buttons."],
                    min = 1,
                    max = 30,
                    step = 1
                },
                betterOption2 = {
                    order = 8,
                    type = "description",
                    name = " ",
                    width = "full"
                },
                buttonWidth = {
                    order = 9,
                    type = "range",
                    name = L["Button Width"],
                    desc = L["The width of the buttons."],
                    min = 2,
                    max = 80,
                    step = 1
                },
                buttonHeight = {
                    order = 10,
                    type = "range",
                    name = L["Button Height"],
                    desc = L["The height of the buttons."],
                    min = 2,
                    max = 60,
                    step = 1
                },
                buttonsPerRow = {
                    order = 11,
                    type = "range",
                    name = L["Buttons Per Row"],
                    min = 1,
                    max = 12,
                    step = 1
                },
                include = {
                    order = 12,
                    type = "input",
                    name = L["Button Groups"],
                    desc = format(
                        "%s %s\n\n%s\n%s\n%s\n%s\n%s\n%s\n%s",
                        L["Set the type and order of button groups."],
                        L["You can separate the groups with a comma."],
                        FormatDesc("QUEST", L["Quest Items"]),
                        FormatDesc("EQUIP", L["Equipments"]),
                        FormatDesc("POTION", L["Potions"]),
                        FormatDesc("FLASK", L["Flasks"]),
                        FormatDesc("BANNER", L["Banners"]),
                        FormatDesc("UTILITY", L["Utilities"]),
                        FormatDesc("CUSTOM", L["Custom Items"])
                    ),
                    width = "full"
                }
            }
        }
    end
end

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
        visualEffect = {
            order = 2,
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
            order = 3,
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
            order = 4,
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
    order = 3,
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
    order = 4,
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
            tag = "[classcolor:player]",
            text = L["The color of the player's class"]
        }
    }

    for i = 1, GetNumClasses() do
        local localizedName, upperText = GetClassInfo(i)
        examples.color[upperText] = {
            tag = format("[classcolor:%s]", strlower(upperText)),
            text = format(L["The color of %s"], localizedName)
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
                    order = subIndex,
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
