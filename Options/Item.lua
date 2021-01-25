local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.item.args
local LSM = E.Libs.LSM

local DI = W:GetModule("DeleteItem")
local AK = W:GetModule("AlreadyKnown")
local FL = W:GetModule("FastLoot")
local TD = W:GetModule("Trade")
local EB = W:GetModule("ExtraItemsBar")
local CT = W:GetModule("Contacts")
local IL = W:GetModule("Inspect")

local format = format
local pairs = pairs
local print = print
local select = select
local strlower = strlower
local tinsert = tinsert
local tonumber = tonumber
local tremove = tremove
local GetItemInfo = GetItemInfo

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
        return E.db.WT.item.extraItemsBar[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.item.extraItemsBar[info[#info]] = value
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
            order = 10,
            type = "group",
            name = L["Custom Items"],
            disabled = function()
                return not E.db.WT.item.extraItemsBar.enable
            end,
            args = {
                addToList = {
                    order = 1,
                    type = "input",
                    name = L["New Item ID"],
                    get = function()
                        return ""
                    end,
                    set = function(_, value)
                        local itemID = tonumber(value)
                        local itemName = select(1, GetItemInfo(itemID))
                        if itemName then
                            tinsert(E.db.WT.item.extraItemsBar.customList, itemID)
                            EB:UpdateBars()
                        else
                            print(L["The item ID is invalid."])
                        end
                    end
                },
                list = {
                    order = 2,
                    type = "select",
                    name = L["List"],
                    get = function()
                        return customListSelected1
                    end,
                    set = function(_, value)
                        customListSelected1 = value
                    end,
                    values = function()
                        local list = E.db.WT.item.extraItemsBar.customList
                        local result = {}
                        for key, value in pairs(list) do
                            result[key] = select(1, GetItemInfo(value))
                        end
                        return result
                    end
                },
                deleteButton = {
                    order = 3,
                    type = "execute",
                    name = L["Delete"],
                    desc = L["Delete the selected item."],
                    func = function()
                        if customListSelected1 then
                            local list = E.db.WT.item.extraItemsBar.customList
                            tremove(list, customListSelected1)
                            EB:UpdateBars()
                        end
                    end
                }
            }
        },
        blackList = {
            order = 11,
            type = "group",
            name = L["Blacklist"],
            disabled = function()
                return not E.db.WT.item.extraItemsBar.enable
            end,
            args = {
                addToList = {
                    order = 1,
                    type = "input",
                    name = L["New Item ID"],
                    get = function()
                        return ""
                    end,
                    set = function(_, value)
                        local itemID = tonumber(value)
                        local itemName = select(1, GetItemInfo(itemID))
                        if itemName then
                            E.db.WT.item.extraItemsBar.blackList[itemID] = itemName
                            EB:UpdateBars()
                        else
                            print(L["The item ID is invalid."])
                        end
                    end
                },
                list = {
                    order = 2,
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
                        for key, value in pairs(E.db.WT.item.extraItemsBar.blackList) do
                            result[key] = value
                        end
                        return result
                    end
                },
                deleteButton = {
                    order = 3,
                    type = "execute",
                    name = L["Delete"],
                    desc = L["Delete the selected item."],
                    func = function()
                        if customListSelected2 then
                            E.db.WT.item.extraItemsBar.blackList[customListSelected2] = nil
                            EB:UpdateBars()
                        end
                    end
                }
            }
        }
    }
}

do -- Add options for bars
    for i = 1, 5 do
        options.extraItemsBar.args["bar" .. i] = {
            order = i + 2,
            type = "group",
            name = L["Bar"] .. " " .. i,
            get = function(info)
                return E.db.WT.item.extraItemsBar["bar" .. i][info[#info]]
            end,
            set = function(info, value)
                E.db.WT.item.extraItemsBar["bar" .. i][info[#info]] = value
                EB:UpdateBar(i)
            end,
            disabled = function()
                return not E.db.WT.item.extraItemsBar.enable
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"]
                },
                visibility = {
                    order = 2,
                    type = "group",
                    inline = true,
                    name = L["Visibility"],
                    args = {
                        globalFade = {
                            order = 1,
                            type = "toggle",
                            name = L["Inherit Global Fade"]
                        },
                        mouseOver = {
                            order = 2,
                            type = "toggle",
                            name = L["Mouse Over"],
                            desc = L["Only show the bar when you mouse over it."],
                            disabled = function()
                                return not E.db.WT.item.extraItemsBar.enable or
                                    E.db.WT.item.extraItemsBar["bar" .. i].globalFade
                            end
                        },
                        fadeTime = {
                            order = 3,
                            type = "range",
                            name = L["Fade Time"],
                            min = 0,
                            max = 2,
                            step = 0.01,
                            disabled = function()
                                return not E.db.WT.item.extraItemsBar.enable or
                                    E.db.WT.item.extraItemsBar["bar" .. i].globalFade or
                                    not E.db.WT.item.extraItemsBar["bar" .. i].mouseOver
                            end
                        },
                        alphaMin = {
                            order = 4,
                            type = "range",
                            name = L["Alpha Min"],
                            min = 0,
                            max = 1,
                            step = 0.01,
                            disabled = function()
                                return not E.db.WT.item.extraItemsBar.enable or
                                    E.db.WT.item.extraItemsBar["bar" .. i].globalFade or
                                    not E.db.WT.item.extraItemsBar["bar" .. i].mouseOver
                            end
                        },
                        alphaMax = {
                            order = 5,
                            type = "range",
                            name = L["Alpha Max"],
                            min = 0,
                            max = 1,
                            step = 0.01,
                            disabled = function()
                                return not E.db.WT.item.extraItemsBar.enable or
                                    E.db.WT.item.extraItemsBar["bar" .. i].globalFade
                            end
                        },
                        tooltip = {
                            order = 6,
                            type = "toggle",
                            name = L["Tooltip"]
                        }
                    }
                },
                backdrop = {
                    order = 3,
                    type = "toggle",
                    name = L["Bar Backdrop"],
                    desc = L["Show a backdrop of the bar."]
                },
                anchor = {
                    order = 4,
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
                backdropSpacing = {
                    order = 5,
                    type = "range",
                    name = L["Backdrop Spacing"],
                    desc = L["The spacing between the backdrop and the buttons."],
                    min = 1,
                    max = 30,
                    step = 1
                },
                spacing = {
                    order = 6,
                    type = "range",
                    name = L["Button Spacing"],
                    desc = L["The spacing between buttons."],
                    min = 1,
                    max = 30,
                    step = 1
                },
                betterOption2 = {
                    order = 7,
                    type = "description",
                    name = " ",
                    width = "full"
                },
                numButtons = {
                    order = 8,
                    type = "range",
                    name = L["Buttons"],
                    min = 1,
                    max = 12,
                    step = 1
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
                countFont = {
                    order = 12,
                    type = "group",
                    inline = true,
                    name = L["Counter"],
                    get = function(info)
                        return E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]] = value
                        EB:UpdateBar(i)
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
                        xOffset = {
                            order = 4,
                            name = L["X-Offset"],
                            type = "range",
                            min = -50,
                            max = 50,
                            step = 1
                        },
                        yOffset = {
                            order = 5,
                            name = L["Y-Offset"],
                            type = "range",
                            min = -50,
                            max = 50,
                            step = 1
                        },
                        color = {
                            order = 6,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = false,
                            get = function(info)
                                local db = E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
                                local default = P.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
                                return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                            end,
                            set = function(info, r, g, b)
                                local db = E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
                                db.r, db.g, db.b = r, g, b
                                EB:UpdateBar(i)
                            end
                        }
                    }
                },
                bindFont = {
                    order = 13,
                    type = "group",
                    inline = true,
                    name = L["Key Binding"],
                    get = function(info)
                        return E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]] = value
                        EB:UpdateBar(i)
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
                        xOffset = {
                            order = 4,
                            name = L["X-Offset"],
                            type = "range",
                            min = -50,
                            max = 50,
                            step = 1
                        },
                        yOffset = {
                            order = 5,
                            name = L["Y-Offset"],
                            type = "range",
                            min = -50,
                            max = 50,
                            step = 1
                        },
                        color = {
                            order = 6,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = false,
                            get = function(info)
                                local db = E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
                                local default = P.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
                                return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                            end,
                            set = function(info, r, g, b)
                                local db = E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
                                db.r, db.g, db.b = r, g, b
                                EB:UpdateBar(i)
                            end
                        }
                    }
                },
                include = {
                    order = 14,
                    type = "input",
                    name = L["Button Groups"],
                    desc = format(
                        "%s %s\n\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",
                        L["Set the type and order of button groups."],
                        L["You can separate the groups with a comma."],
                        FormatDesc("QUEST", L["Quest Items"]),
                        FormatDesc("EQUIP", L["Equipments"]),
                        FormatDesc("POTION", L["Potions"]),
                        FormatDesc("POTIONSL", format("%s (%s)", L["Potions"], L["Shadowlands"])),
                        FormatDesc("FLASK", L["Flasks"]),
                        FormatDesc("FLASKSL", format("%s (%s)", L["Flasks"], L["Shadowlands"])),
                        FormatDesc("TORGHAST", L["Torghast Items"]),
                        FormatDesc("FOOD", L["Food"]),
                        FormatDesc("FOODSL", format("%s (%s)", L["Food"], L["Shadowlands"])),
                        FormatDesc("FOODVENDOR", format("%s (%s)", L["Food"], L["Sold by vendor"])),
                        FormatDesc("MAGEFOOD", format("%s (%s)", L["Food"], L["Crafted by mage"])),
                        FormatDesc("BANNER", L["Banners"]),
                        FormatDesc("UTILITY", L["Utilities"]),
                        FormatDesc("OPENABLE", L["Openable Items"]),
                        FormatDesc("CUSTOM", L["Custom Items"])
                    ),
                    width = "full"
                }
            }
        }
    end
end

options.delete = {
    order = 2,
    type = "group",
    name = L["Delete Item"],
    get = function(info)
        return E.db.WT.item.delete[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.item.delete[info[#info]] = value
        DI:ProfileUpdate()
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
                    name = L["This module provides several easy-to-use methods of deleting items."],
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
        delKey = {
            order = 3,
            type = "toggle",
            name = L["Use Delete Key"],
            desc = L["Allow you to use Delete Key for confirming deleting."]
        },
        fillIn = {
            order = 4,
            name = L["Fill In"],
            type = "select",
            values = {
                NONE = L["Disable"],
                CLICK = L["Fill by click"],
                AUTO = L["Auto Fill"]
            }
        }
    }
}

options.alreadyKnown = {
    order = 3,
    type = "group",
    name = L["Already Known"],
    get = function(info)
        return E.db.WT.item.alreadyKnown[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.item.alreadyKnown[info[#info]] = value
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
                    name = function()
                        if AK.StopRunning then
                            return format(
                                "|cffff0000" .. L["Because of %s, this module will not be loaded."] .. "|r",
                                AK.StopRunning
                            )
                        else
                            return L["Puts a overlay on already known learnable items on vendors and AH."]
                        end
                    end,
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            disabled = function()
                return AK.StopRunning
            end,
            set = function(info, value)
                E.db.WT.item.alreadyKnown[info[#info]] = value
                AK:ToggleSetting()
            end,
            width = "full"
        },
        mode = {
            order = 3,
            name = L["Mode"],
            type = "select",
            disabled = function()
                return AK.StopRunning
            end,
            values = {
                COLOR = L["Custom Color"],
                MONOCHROME = L["Monochrome"]
            }
        },
        color = {
            order = 4,
            type = "color",
            name = L["Color"],
            disabled = function()
                return AK.StopRunning
            end,
            hidden = function()
                return not (E.db.WT.item.alreadyKnown.mode == "COLOR")
            end,
            hasAlpha = false,
            get = function(info)
                local db = E.db.WT.item.alreadyKnown.color
                local default = P.item.alreadyKnown.color
                return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
            end,
            set = function(info, r, g, b)
                local db = E.db.WT.item.alreadyKnown.color
                db.r, db.g, db.b = r, g, b
            end
        }
    }
}

options.fastLoot = {
    order = 4,
    type = "group",
    name = L["Fast Loot"],
    get = function(info)
        return E.db.WT.item.fastLoot[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.item.fastLoot[info[#info]] = value
        FL:ProfileUpdate()
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
                    name = L["This module will accelerate the speed of loot."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 1,
            type = "toggle",
            name = L["Enable"],
            width = "full"
        },
        limit = {
            order = 2,
            type = "range",
            name = L["Limit"],
            desc = L["The time delay between every loot operations. (Default is 0.3)"],
            min = 0.05,
            max = 0.5,
            step = 0.01
        }
    }
}

options.trade = {
    order = 5,
    type = "group",
    name = L["Trade"],
    get = function(info)
        return E.db.WT.item.trade[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.item.trade[info[#info]] = value
        TD:ProfileUpdate()
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
                    name = L["Add some features on Trade Frame."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 1,
            type = "toggle",
            name = L["Enable"],
            width = "full"
        },
        thanksButton = {
            order = 2,
            type = "toggle",
            name = L["Thanks Button"]
        },
        thanksText = {
            order = 3,
            type = "input",
            name = L["Thanks Text"],
            width = "full"
        }
    }
}

options.contacts = {
    order = 6,
    type = "group",
    name = L["Contacts"],
    get = function(info)
        return E.db.WT.item.contacts[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.item.contacts[info[#info]] = value
        CT:ProfileUpdate()
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
                    name = L["Add a contact frame beside the mail frame."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 1,
            type = "toggle",
            name = L["Enable"]
        },
        defaultPage = {
            order = 2,
            type = "select",
            name = L["Default Page"],
            values = {
                ALTS = L["Alternate Character"],
                FRIENDS = L["Online Friends"],
                GUILD = L["Guild Members"],
                FAVORITE = L["My Favorites"]
            }
        }
    }
}

do
    local selectedKey

    options.contacts.args.alts = {
        order = 2,
        type = "group",
        inline = true,
        name = L["Alternate Character"],
        args = {
            listTable = {
                order = 1,
                type = "select",
                name = L["Alt List"],
                get = function()
                    return selectedKey
                end,
                set = function(_, value)
                    selectedKey = value
                end,
                values = function()
                    local result = {}
                    for realm, factions in pairs(E.global.WT.item.contacts.alts) do
                        for _, characters in pairs(factions) do
                            for name, class in pairs(characters) do
                                result[name .. "-" .. realm] = F.CreateClassColorString(name .. "-" .. realm, class)
                            end
                        end
                    end
                    return result
                end
            },
            deleteButton = {
                order = 2,
                type = "execute",
                name = L["Delete"],
                desc = L["Delete the selected item."],
                func = function()
                    if selectedKey then
                        for realm, factions in pairs(E.global.WT.item.contacts.alts) do
                            for faction, characters in pairs(factions) do
                                for name, class in pairs(characters) do
                                    if name .. "-" .. realm == selectedKey then
                                        E.global.WT.item.contacts.alts[realm][faction][name] = nil
                                        selectedKey = nil
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            }
        }
    }
end

do
    local selectedKey
    local tempName, tempRealm

    options.contacts.args.favorite = {
        order = 3,
        type = "group",
        inline = true,
        name = L["My Favorites"],
        args = {
            name = {
                order = 1,
                type = "input",
                name = L["Name"],
                get = function()
                    return tempName
                end,
                set = function(_, value)
                    tempName = value
                end
            },
            realm = {
                order = 2,
                type = "input",
                name = L["Realm"],
                get = function()
                    return tempRealm
                end,
                set = function(_, value)
                    tempRealm = value
                end
            },
            addButton = {
                order = 3,
                type = "execute",
                name = L["Add"],
                func = function()
                    if tempName and tempRealm then
                        E.global.WT.item.contacts.favorites[tempName .. "-" .. tempRealm] = true
                        tempName = nil
                        tempRealm = nil
                    else
                        print(L["Please set the name and realm first."])
                    end
                end
            },
            betterOption = {
                order = 4,
                type = "description",
                name = " ",
                width = "full"
            },
            listTable = {
                order = 5,
                type = "select",
                name = L["Favorite List"],
                get = function()
                    return selectedKey
                end,
                set = function(_, value)
                    selectedKey = value
                end,
                values = function()
                    local result = {}
                    for fullName in pairs(E.global.WT.item.contacts.favorites) do
                        result[fullName] = fullName
                    end
                    return result
                end
            },
            deleteButton = {
                order = 6,
                type = "execute",
                name = L["Delete"],
                func = function()
                    if selectedKey then
                        E.global.WT.item.contacts.favorites[selectedKey] = nil
                    end
                end
            }
        }
    }
end

options.inspect = {
    order = 7,
    type = "group",
    name = L["Inspect"],
    get = function(info)
        return E.db.WT.item.inspect[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.item.inspect[info[#info]] = value
        IL:ProfileUpdate()
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
                        if IL.StopRunning then
                            return format(
                                "|cffff0000" .. L["Because of %s, this module will not be loaded."] .. "|r",
                                IL.StopRunning
                            )
                        else
                            return format(
                                "%s\n%s",
                                L["This module will add an equipment list beside the character panel and inspect frame."],
                                L[
                                    "This module is a lite version of TinyInspect. Installing TinyInspect if you want to have full features."
                                ]
                            )
                        end
                    end,
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 1,
            disabled = function()
                return IL.StopRunning
            end,
            type = "toggle",
            name = L["Enable"],
            width = "full"
        },
        lists = {
            order = 2,
            type = "group",
            inline = true,
            name = L["Lists"],
            disabled = function()
                return IL.StopRunning or not E.db.WT.item.inspect.enable
            end,
            args = {
                player = {
                    order = 1,
                    type = "toggle",
                    name = L["Player"],
                    desc = L["Add a frame to your character panel."]
                },
                inspect = {
                    order = 2,
                    type = "toggle",
                    name = L["Inspect"],
                    desc = L["Add a frame to Inspect Frame."]
                }
            }
        },
        additional = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Additional Information"],
            hidden = function()
                return not E.db.WT.item.inspect.inspect
            end,
            disabled = function()
                return IL.StopRunning or not E.db.WT.item.inspect.enable
            end,
            args = {
                playerOnInspect = {
                    order = 1,
                    type = "toggle",
                    name = L["Always Show Mine"],
                    desc = L["Display character equipments list when you inspect someone."]
                },
                stats = {
                    order = 3,
                    type = "toggle",
                    name = L["Statistics"],
                    hidden = function()
                        if W.Locale == "koKR" or W.Locale == "enUS" or W.Locale == "zhCN" or W.Locale == "zhTW" then
                            return false
                        end
                        return true
                    end,
                    desc = L["Add statistics information for comparison."]
                }
            }
        },
        levelText = {
            order = 4,
            type = "group",
            inline = true,
            name = L["Item Level"],
            get = function(info)
                return E.db.WT.item.inspect.levelText[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.item.inspect.levelText[info[#info]] = value
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
        equipText = {
            order = 5,
            type = "group",
            inline = true,
            name = L["Item Name"],
            get = function(info)
                return E.db.WT.item.inspect.equipText[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.item.inspect.equipText[info[#info]] = value
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
        statsText = {
            order = 5,
            type = "group",
            inline = true,
            name = L["Statistics"],
            get = function(info)
                return E.db.WT.item.inspect.statsText[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.item.inspect.statsText[info[#info]] = value
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
