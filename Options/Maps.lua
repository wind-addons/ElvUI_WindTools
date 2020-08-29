local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.maps.args
local LSM = E.Libs.LSM
local WM = W:GetModule("WorldMap")
local MB = W:GetModule("MinimapButtons")
local RM = W:GetModule("RectangleMinimap")

local _G = _G

options.rectangleMinimap = {
    order = 1,
    type = "group",
    name = L["Rectangle Minimap"],
    get = function(info)
        return E.db.WT.maps.rectangleMinimap[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.maps.rectangleMinimap[info[#info]] = value
        RM:ChangeShape()
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
                    name = L["Change the shape of ElvUI minimap."],
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
        widthPercentage = {
            order = 3,
            type = "range",
            name = L["Width Percentage"],
            desc = L["Percentage of ElvUI minimap size."],
            min = 0.01,
            max = 1,
            step = 0.01
        },
        heightPercentage = {
            order = 4,
            type = "range",
            name = L["Height Percentage"],
            desc = L["Percentage of ElvUI minimap size."],
            min = 0.01,
            max = 1,
            step = 0.01
        }
    }
}

options.minimapButtons = {
    order = 2,
    type = "group",
    name = L["Minimap Buttons"],
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
                    name = L["Add an extra bar to collect minimap buttons."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            desc = L["Toggle minimap buttons bar."],
            get = function(info)
                return E.private.WT.maps.minimapButtons[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.maps.minimapButtons[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        mouseOver = {
            order = 3,
            type = "toggle",
            name = L["Mouse Over"],
            desc = L["Only show minimap buttons bar when you mouse over it."],
            get = function(info)
                return E.private.WT.maps.minimapButtons[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.maps.minimapButtons[info[#info]] = value
                MB:UpdateMouseOverConfig()
            end
        },
        barConfig = {
            order = 4,
            type = "group",
            inline = true,
            name = L["Minimap Buttons Bar"],
            get = function(info)
                return E.private.WT.maps.minimapButtons[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.maps.minimapButtons[info[#info]] = value
                MB:UpdateLayout()
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
                inverseDirection = {
                    order = 3,
                    type = "toggle",
                    name = L["Inverse Direction"],
                    desc = L["Reverse the direction of adding buttons."]
                },
                orientation = {
                    order = 4,
                    type = "select",
                    name = L["Orientation"],
                    desc = L["Arrangement direction of the bar."],
                    values = {
                        NOANCHOR = L["Drag"],
                        HORIZONTAL = L["Horizontal"],
                        VERTICAL = L["Vertical"]
                    },
                    set = function(info, value)
                        E.private.WT.maps.minimapButtons[info[#info]] = value
                        -- 如果开启日历美化的话，需要重载来取消掉美化
                        if value == "NOANCHOR" and E.private.WT.maps.minimapButtons.calendar then
                            E:StaticPopup_Show("PRIVATE_RL")
                        else
                            MB:UpdateLayout()
                        end
                    end
                }
            }
        },
        buttonsConfig = {
            order = 5,
            type = "group",
            inline = true,
            name = L["Buttons"],
            get = function(info)
                return E.private.WT.maps.minimapButtons[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.maps.minimapButtons[info[#info]] = value
                MB:UpdateLayout()
            end,
            args = {
                buttonsPerRow = {
                    order = 1,
                    type = "range",
                    name = L["Buttons Per Row"],
                    desc = L["The amount of buttons to display per row."],
                    min = 1,
                    max = 30,
                    step = 1
                },
                buttonSize = {
                    order = 2,
                    type = "range",
                    name = L["Button Size"],
                    desc = L["The size of the buttons."],
                    get = function(info)
                        return E.private.WT.maps.minimapButtons[info[#info]]
                    end,
                    set = function(info, value)
                        E.private.WT.maps.minimapButtons[info[#info]] = value
                        MB:SkinMinimapButtons()
                    end,
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
        },
        blizzardButtonsConfig = {
            order = 6,
            type = "group",
            inline = true,
            name = L["Blizzard Buttons"],
            get = function(info)
                return E.private.WT.maps.minimapButtons[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.maps.minimapButtons[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            args = {
                calendar = {
                    order = 1,
                    type = "toggle",
                    name = L["Calendar"],
                    desc = L["Add calendar button to the bar."]
                },
                garrison = {
                    order = 2,
                    type = "toggle",
                    name = L["Garrison"],
                    desc = L["Add garrison button to the bar."]
                }
            }
        }
    }
}

options.worldMap = {
    order = 3,
    type = "group",
    name = L["World Map"],
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
                    name = L["This module will help you to reveal and resize maps."],
                    fontSize = "medium"
                }
            }
        },
        reveal = {
            order = 2,
            type = "toggle",
            name = L["Remove Fog"],
            desc = L["Remove Fog of War from your world map."],
            get = function(info)
                return E.private.WT.maps.worldMap[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.maps.worldMap[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        scale = {
            order = 3,
            type = "range",
            name = L["Scale"],
            desc = L["Resize world map."],
            get = function(info)
                return E.db.WT.maps.worldMap[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.maps.worldMap[info[#info]] = value
                WM:UpdateScale()
            end,
            min = 0.1,
            max = 3,
            step = 0.01
        }
    }
}
