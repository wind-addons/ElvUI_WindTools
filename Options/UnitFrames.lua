local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.unitFrames.args
local LSM = E.Libs.LSM

local CT = W:GetModule("ChatText")
local CB = W:GetModule("CastBar")

options.quickFocus = {
    order = 1,
    type = "group",
    name = L["Quick Focus"],
    get = function(info)
        return E.private.WT.unitFrames.quickFocus[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.unitFrames.quickFocus[info[#info]] = value
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
                    name = L["Focus the target by modifier key + click."],
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
        modifier = {
            order = 3,
            type = "select",
            name = L["Modifier Key"],
            disabled = function()
                return not E.private.WT.unitFrames.quickFocus.enable
            end,
            values = {
                shift = L["Shift Key"],
                ctrl = L["Ctrl Key"],
                alt = L["Alt Key"]
            }
        },
        button = {
            order = 4,
            type = "select",
            name = L["Button"],
            disabled = function()
                return not E.private.WT.unitFrames.quickFocus.enable
            end,
            values = {
                BUTTON1 = L["Left Button"],
                BUTTON2 = L["Right Button"],
                BUTTON3 = L["Middle Button"],
                BUTTON4 = L["Side Button 4"],
                BUTTON5 = L["Side Button 5"]
            }
        }
    }
}

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

options.roleIcon = {
    order = 2,
    type = "group",
    name = L["Role Icon"],
    get = function(info)
        return E.private.WT.unitFrames.roleIcon[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.unitFrames.roleIcon[info[#info]] = value
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
                    name = L["Change the role icon of unitframes."],
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
        roleIconStyle = {
            order = 3,
            type = "select",
            name = L["Style"],
            desc = L["Change the icons indicate the role."],
            values = {
                HEXAGON = SampleStrings.hexagon,
                FFXIV = SampleStrings.ffxiv,
                SUNUI = SampleStrings.sunui,
                LYNUI = SampleStrings.lynui,
                DEFAULT = SampleStrings.elvui
            }
        }
    }
}

options.castBar = {
    order = 3,
    type = "group",
    name = L["Cast Bar"],
    get = function(info)
        return E.db.WT.unitFrames.castBar[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.unitFrames.castBar[info[#info]] = value
        CB:ProfileUpdate()
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
                    name = L["Add more custom options to ElvUI cast bars."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            width = "full"
        }
    }
}

do
    local anchorTable = {
        TOP = L["TOP"],
        BOTTOM = L["BOTTOM"],
        LEFT = L["LEFT"],
        RIGHT = L["RIGHT"],
        TOPRIGHT = L["TOPRIGHT"],
        TOPLEFT = L["TOPLEFT"],
        BOTTOMRIGHT = L["BOTTOMRIGHT"],
        BOTTOMLEFT = L["BOTTOMLEFT"],
        CENTER = L["CENTER"]
    }

    local optionTable = {
        {
            name = L["Player"],
            key = "player"
        },
        {
            name = L["Target"],
            key = "target"
        },
        {
            name = L["Pet"],
            key = "pet"
        },
        {
            name = L["Focus"],
            key = "focus"
        },
        {
            name = L["Boss"],
            key = "boss"
        },
        {
            name = L["Arena"],
            key = "arena"
        }
    }

    for optionOrder, optionData in ipairs(optionTable) do
        options.castBar.args[optionData.key] = {
            order = optionOrder + 2,
            type = "group",
            name = optionData.name,
            get = function(info)
                return E.db.WT.unitFrames.castBar[optionData.key][info[#info]]
            end,
            set = function(info, value)
                E.db.WT.unitFrames.castBar[optionData.key][info[#info]] = value
                CB:Refresh(optionData.key)
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    width = "full"
                },
                text = {
                    order = 2,
                    type = "group",
                    inline = true,
                    name = L["Spell Name"],
                    get = function(info)
                        return E.db.WT.unitFrames.castBar[optionData.key].text[info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.unitFrames.castBar[optionData.key].text[info[#info]] = value
                        CB:Refresh(optionData.key)
                    end,
                    disabled = function()
                        return not E.db.WT.unitFrames.castBar[optionData.key].enable
                    end,
                    args = {
                        anchor = {
                            order = 1,
                            name = L["Anchor Point"],
                            type = "select",
                            values = anchorTable
                        },
                        offsetX = {
                            order = 2,
                            type = "range",
                            name = L["X-Offset"],
                            min = -200,
                            max = 200,
                            step = 1
                        },
                        offsetY = {
                            order = 3,
                            type = "range",
                            name = L["Y-Offset"],
                            min = -200,
                            max = 200,
                            step = 1
                        },
                        font = {
                            order = 4,
                            type = "group",
                            inline = true,
                            name = L["Style"],
                            get = function(info)
                                return E.db.WT.unitFrames.castBar[optionData.key].text.font[info[#info]]
                            end,
                            set = function(info, value)
                                E.db.WT.unitFrames.castBar[optionData.key].text.font[info[#info]] = value
                                CB:Refresh(optionData.key)
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
                time = {
                    order = 3,
                    type = "group",
                    inline = true,
                    name = L["Time"],
                    get = function(info)
                        return E.db.WT.unitFrames.castBar[optionData.key].time[info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.unitFrames.castBar[optionData.key].time[info[#info]] = value
                        CB:Refresh(optionData.key)
                    end,
                    disabled = function()
                        return not E.db.WT.unitFrames.castBar[optionData.key].enable
                    end,
                    args = {
                        anchor = {
                            order = 1,
                            name = L["Anchor Point"],
                            type = "select",
                            values = anchorTable
                        },
                        offsetX = {
                            order = 2,
                            type = "range",
                            name = L["X-Offset"],
                            min = -200,
                            max = 200,
                            step = 1
                        },
                        offsetY = {
                            order = 3,
                            type = "range",
                            name = L["Y-Offset"],
                            min = -200,
                            max = 200,
                            step = 1
                        },
                        font = {
                            order = 4,
                            type = "group",
                            inline = true,
                            name = L["Style"],
                            get = function(info)
                                return E.db.WT.unitFrames.castBar[optionData.key].time.font[info[#info]]
                            end,
                            set = function(info, value)
                                E.db.WT.unitFrames.castBar[optionData.key].time.font[info[#info]] = value
                                CB:Refresh(optionData.key)
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
    end
end
