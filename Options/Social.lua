local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.social.args
local LSM = E.Libs.LSM

local CB = W:GetModule("ChatBar")
local CL = W:GetModule("ChatLink")
local WE = W:GetModule("Emote")
local FL = W:GetModule("FriendList")
local FT = W:GetModule("Filter")
local ST = W:GetModule("SmartTab")

options.chatBar = {
    order = 1,
    type = "group",
    name = L["Chat Bar"],
    get = function(info)
        return E.db.WT.social.chatBar[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.social.chatBar[info[#info]] = value
        CB:UpdateBar()
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
                    name = L["Add a chat bar for switching channel."],
                    fontSize = "medium"
                }
            }
        },
        general = {
            order = 1,
            type = "group",
            inline = true,
            name = L["General"],
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"]
                },
                autoHide = {
                    order = 2,
                    type = "toggle",
                    name = L["Auto Hide"],
                    desc = L["Hide channels not exist."]
                },
                mouseOver = {
                    order = 3,
                    type = "toggle",
                    name = L["Mouse Over"],
                    desc = L["Only show chat bar when you mouse over it."]
                },
                orientation = {
                    order = 4,
                    type = "select",
                    name = L["Orientation"],
                    values = {
                        HORIZONTAL = L["Horizontal"],
                        VERTICAL = L["Vertical"]
                    }
                }
            }
        },
        backdrop = {
            order = 2,
            type = "group",
            inline = true,
            name = L["Backdrop"],
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
                }
            }
        },
        button = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Button"],
            args = {
                buttonWidth = {
                    order = 1,
                    type = "range",
                    name = L["Button Width"],
                    desc = L["The width of the buttons."],
                    min = 2,
                    max = 80,
                    step = 1
                },
                buttonHeight = {
                    order = 2,
                    type = "range",
                    name = L["Button Height"],
                    desc = L["The height of the buttons."],
                    min = 2,
                    max = 60,
                    step = 1
                },
                style = {
                    order = 3,
                    type = "select",
                    name = L["Style"],
                    values = {
                        BLOCK = L["Block"],
                        TEXT = L["Text"]
                    }
                }
            }
        },
        blockStyle = {
            order = 4,
            type = "group",
            inline = true,
            hidden = function()
                return not (E.db.WT.social.chatBar.style == "BLOCK")
            end,
            name = L["Style"],
            args = {
                blockShadow = {
                    order = 1,
                    type = "toggle",
                    name = L["Block Shadow"]
                },
                tex = {
                    order = 2,
                    type = "select",
                    name = L["Texture"],
                    dialogControl = "LSM30_Statusbar",
                    values = LSM:HashTable("statusbar")
                }
            }
        },
        textStyle = {
            order = 4,
            type = "group",
            inline = true,
            hidden = function()
                return not (E.db.WT.social.chatBar.style == "TEXT")
            end,
            name = L["Style"],
            args = {
                color = {
                    order = 1,
                    type = "toggle",
                    name = L["Use Color"]
                },
                font = {
                    type = "group",
                    order = 2,
                    name = L["Font Setting"],
                    get = function(info)
                        return E.db.WT.social.chatBar.font[info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.social.chatBar.font[info[#info]] = value
                        CB:UpdateBar()
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
        channels = {
            name = _G.CHANNEL,
            order = 5,
            type = "group",
            inline = true,
            args = {
                world = {
                    order = 100,
                    type = "group",
                    name = _G.WORLD,
                    get = function(info)
                        return E.db.WT.social.chatBar.channels.world[info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.social.chatBar.channels.world[info[#info]] = value
                        CB:UpdateBar()
                    end,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = L["Enable"]
                        },
                        color = {
                            order = 2,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = true,
                            get = function(info)
                                local colordb = E.db.WT.social.chatBar.channels.world.color
                                local default = P.social.chatBar.channels.world.color
                                return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
                            end,
                            set = function(info, r, g, b, a)
                                E.db.WT.social.chatBar.channels.world.color = {
                                    r = r,
                                    g = g,
                                    b = b,
                                    a = a
                                }
                                CB:UpdateBar()
                            end
                        },
                        abbr = {
                            order = 3,
                            type = "input",
                            hidden = function()
                                return not (E.db.WT.social.chatBar.style == "TEXT")
                            end,
                            name = L["Abbreviation"]
                        },
                        name = {
                            order = 4,
                            type = "input",
                            name = L["Channel Name"]
                        },
                        autoJoin = {
                            order = 5,
                            type = "toggle",
                            name = L["Auto Join"]
                        }
                    }
                },
                community = {
                    order = 101,
                    type = "group",
                    name = _G.COMMUNITIES,
                    get = function(info)
                        return E.db.WT.social.chatBar.channels.community[info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.social.chatBar.channels.community[info[#info]] = value
                        CB:UpdateBar()
                    end,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = L["Enable"]
                        },
                        color = {
                            order = 2,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = true,
                            get = function(info)
                                local colordb = E.db.WT.social.chatBar.channels.community.color
                                local default = P.social.chatBar.channels.community.color
                                return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
                            end,
                            set = function(info, r, g, b, a)
                                E.db.WT.social.chatBar.channels.community.color = {
                                    r = r,
                                    g = g,
                                    b = b,
                                    a = a
                                }
                                CB:UpdateBar()
                            end
                        },
                        abbr = {
                            order = 3,
                            type = "input",
                            hidden = function()
                                return not (E.db.WT.social.chatBar.style == "TEXT")
                            end,
                            name = L["Abbreviation"]
                        },
                        name = {
                            order = 4,
                            type = "input",
                            name = L["Channel Name"]
                        },
                        communityDesc = {
                            order = 5,
                            type = "description",
                            width = "full",
                            name = L["Please use Blizzard Communities UI add the channel to your main chat frame first."]
                        }
                    }
                },
                emote = {
                    order = 102,
                    type = "group",
                    name = "Wind" .. L["Emote"],
                    get = function(info)
                        return E.db.WT.social.chatBar.channels.emote[info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.social.chatBar.channels.emote[info[#info]] = value
                        CB:UpdateBar()
                    end,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = L["Enable"]
                        },
                        color = {
                            order = 2,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = true,
                            get = function(info)
                                local colordb = E.db.WT.social.chatBar.channels.emote.color
                                local default = P.social.chatBar.channels.emote.color
                                return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
                            end,
                            set = function(info, r, g, b, a)
                                E.db.WT.social.chatBar.channels.emote.color = {
                                    r = r,
                                    g = g,
                                    b = b,
                                    a = a
                                }
                                CB:UpdateBar()
                            end
                        },
                        icon = {
                            order = 3,
                            type = "toggle",
                            name = L["Use Icon"],
                            desc = L["Use a icon rather than text"],
                            hidden = function()
                                return not (E.db.WT.social.chatBar.style == "TEXT")
                            end
                        },
                        abbr = {
                            order = 4,
                            type = "input",
                            hidden = function()
                                return not (E.db.WT.social.chatBar.style == "TEXT")
                            end,
                            name = L["Abbreviation"]
                        }
                    }
                },
                roll = {
                    order = 103,
                    type = "group",
                    name = _G.ROLL,
                    get = function(info)
                        return E.db.WT.social.chatBar.channels.roll[info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.social.chatBar.channels.roll[info[#info]] = value
                        CB:UpdateBar()
                    end,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = L["Enable"]
                        },
                        color = {
                            order = 2,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = true,
                            get = function(info)
                                local colordb = E.db.WT.social.chatBar.channels.roll.color
                                local default = P.social.chatBar.channels.roll.color
                                return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
                            end,
                            set = function(info, r, g, b, a)
                                E.db.WT.social.chatBar.channels.roll.color = {
                                    r = r,
                                    g = g,
                                    b = b,
                                    a = a
                                }
                                CB:UpdateBar()
                            end
                        },
                        icon = {
                            order = 3,
                            type = "toggle",
                            name = L["Use Icon"],
                            desc = L["Use a icon rather than text"],
                            hidden = function()
                                return not (E.db.WT.social.chatBar.style == "TEXT")
                            end
                        },
                        abbr = {
                            order = 4,
                            type = "input",
                            hidden = function()
                                return not (E.db.WT.social.chatBar.style == "TEXT")
                            end,
                            name = L["Abbreviation"]
                        }
                    }
                }
            }
        }
    }
}

do -- 普通频道
    local channels = {"SAY", "YELL", "EMOTE", "PARTY", "INSTANCE", "RAID", "RAID_WARNING", "GUILD", "OFFICER"}
    for index, name in ipairs(channels) do
        options.chatBar.args.channels.args[name] = {
            order = index,
            type = "group",
            name = _G[name],
            get = function(info)
                return E.db.WT.social.chatBar.channels[name][info[#info]]
            end,
            set = function(info, value)
                E.db.WT.social.chatBar.channels[name][info[#info]] = value
                CB:UpdateBar()
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"]
                },
                color = {
                    order = 2,
                    type = "color",
                    name = L["Color"],
                    hasAlpha = true,
                    get = function(info)
                        local colordb = E.db.WT.social.chatBar.channels[name].color
                        local default = P.social.chatBar.channels[name].color
                        return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
                    end,
                    set = function(info, r, g, b, a)
                        E.db.WT.social.chatBar.channels[name].color = {
                            r = r,
                            g = g,
                            b = b,
                            a = a
                        }
                        CB:UpdateBar()
                    end
                },
                abbr = {
                    order = 3,
                    type = "input",
                    hidden = function()
                        return not (E.db.WT.social.chatBar.style == "TEXT")
                    end,
                    name = L["Abbreviation"]
                }
            }
        }
    end
end

options.chatLink = {
    order = 2,
    type = "group",
    name = L["Chat Link"],
    get = function(info)
        return E.db.WT.social.chatLink[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.social.chatLink[info[#info]] = value
        CL:ProfileUpdate()
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
                    name = L[
                        "Add extra information on the link, so that you can get basic information but do not need to click."
                    ],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 1,
            type = "toggle",
            name = L["Enable"]
        },
        level = {
            order = 2,
            type = "toggle",
            name = L["Level"]
        },
        icon = {
            order = 3,
            type = "toggle",
            name = L["Icon"]
        },
        armorCategory = {
            order = 4,
            type = "toggle",
            name = L["Armor Category"]
        },
        weaponCategory = {
            order = 5,
            type = "toggle",
            name = L["Weapon Category"]
        }
    }
}

options.emote = {
    order = 3,
    type = "group",
    name = L["Emote"],
    get = function(info)
        return E.db.WT.social.emote[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.social.emote[info[#info]] = value
        WE:ProfileUpdate()
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
                    name = L["Parse emote expresstion from other players."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 1,
            type = "toggle",
            name = L["Enable"]
        },
        size = {
            name = L["Emote Icon Size"],
            order = 2,
            type = "range",
            min = 5,
            max = 35,
            step = 1
        },
        panel = {
            order = 3,
            type = "toggle",
            name = L["Use Emote Panel"],
            desc = L["Press { to active the emote select window."]
        }
    }
}

options.friendList = {
    order = 4,
    type = "group",
    name = L["Friend List"],
    get = function(info)
        return E.db.WT.social.friendList[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.social.friendList[info[#info]] = value
        FriendsFrame_Update()
    end,
    args = {
        desc = {
            order = 0,
            type = "group",
            inline = true,
            name = L["Description"],
            args = {
                feature1 = {
                    order = 1,
                    type = "description",
                    name = L["Add additional information to the friend frame."],
                    fontSize = "medium"
                },
                feature2 = {
                    order = 2,
                    type = "description",
                    name = L["Modify the texture of status and make name colorful."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 1,
            type = "toggle",
            name = L["Enable"],
            set = function(info, value)
                E.db.WT.social.friendList[info[#info]] = value
                FL:ProfileUpdate()
            end
        },
        textures = {
            order = 2,
            type = "group",
            inline = true,
            name = L["Enhanced Texuture"],
            get = function(info)
                return E.db.WT.social.friendList.textures[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.social.friendList.textures[info[#info]] = value
                FriendsFrame_Update()
            end,
            args = {
                game = {
                    name = L["Game Icons"],
                    order = 1,
                    type = "select",
                    values = {
                        Default = L["Default"],
                        Modern = L["Modern"]
                    }
                },
                status = {
                    name = L["Status Icon Pack"],
                    order = 2,
                    type = "select",
                    values = {
                        Default = L["Default"],
                        D3 = L["Diablo 3"],
                        Square = L["Square"]
                    }
                }
            }
        },
        name = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Name"],
            args = {
                hideMaxLevel = {
                    order = 1,
                    type = "toggle",
                    name = L["Hide Max Level"]
                },
                useGameColor = {
                    order = 2,
                    type = "toggle",
                    name = L["Use Game Color"],
                    desc = L["Change the color of the name to the in-playing game style."]
                },
                useClassColor = {
                    order = 3,
                    type = "toggle",
                    name = L["Use Class Color"]
                },
                font = {
                    order = 4,
                    type = "group",
                    name = L["Font Setting"],
                    get = function(info)
                        return E.db.WT.social.friendList.nameFont[info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.social.friendList.nameFont[info[#info]] = value
                        FriendsFrame_Update()
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
        info = {
            order = 4,
            type = "group",
            inline = true,
            name = L["Information"],
            args = {
                areaColor = {
                    order = 1,
                    type = "color",
                    name = L["Color"],
                    hasAlpha = false,
                    get = function()
                        local colordb = E.db.WT.social.friendList.areaColor
                        local default = P.social.friendList.areaColor
                        return colordb.r, colordb.g, colordb.b, nil, default.r, default.g, default.b
                    end,
                    set = function(_, r, g, b)
                        E.db.WT.social.friendList.areaColor = {r = r, g = g, b = b}
                        FriendsFrame_Update()
                    end
                },
                font = {
                    order = 2,
                    type = "group",
                    name = L["Font Setting"],
                    get = function(info)
                        return E.db.WT.social.friendList.infoFont[info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WT.social.friendList.infoFont[info[#info]] = value
                        FriendsFrame_Update()
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

options.filter = {
    order = 5,
    type = "group",
    name = L["Filter"],
    get = function(info)
        return E.db.WT.social.filter[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.social.filter[info[#info]] = value
        FT:ProfileUpdate()
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
                    name = L["Unblock the profanity filter."],
                    fontSize = "medium"
                },
                commingSoon = {
                    order = 2,
                    type = "description",
                    name = L["More features are comming soon."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 1,
            type = "toggle",
            name = L["Enable"]
        },
        unblockProfanityFilter = {
            order = 2,
            type = "toggle",
            name = L["Profanity Filter"],
            desc = L["Unblock the setting of profanity filter. [CN Server]"]
        }
    }
}

options.smartTab = {
    order = 6,
    type = "group",
    name = L["Smart Tab"],
    get = function(info)
        return E.db.WT.social.smartTab[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.social.smartTab[info[#info]] = value
        ST:ProfileUpdate()
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
                    name = L["This module will change the channel when Tab has been pressed."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 1,
            type = "toggle",
            name = L["Enable"]
        },
        channelSetting = {
            order = 2,
            type = "group",
            inline = true,
            name = L["Channel"],
            get = function(info)
                return E.db.WT.social.smartTab[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.social.smartTab[info[#info]] = value
                ST:ProfileUpdate()
            end,
            args = {
                yell = {
                    order = 1,
                    type = "toggle",
                    name = _G.CHAT_MSG_YELL
                },
                battleground = {
                    order = 2,
                    type = "toggle",
                    name = _G.CHAT_MSG_BATTLEGROUND
                },
                raidWarning = {
                    order = 3,
                    type = "toggle",
                    name = _G.CHAT_MSG_RAID_WARNING
                },
                officer = {
                    order = 4,
                    type = "toggle",
                    name = _G.CHAT_MSG_OFFICER
                }
            }
        },
        whisperSetting = {
            order = 3,
            type = "group",
            inline = true,
            name = _G.WHISPER,
            args = {
                whisperCycle = {
                    order = 1,
                    type = "toggle",
                    name = L["Whisper Cycle"]
                },
                historyLimit = {
                    order = 2,
                    type = "range",
                    name = L["Expiration time (min)"],
                    desc = L[
                        "This module will record whispers for switching.\n You can set the expiration time here for making a shortlist of recent targets."
                    ],
                    min = 1,
                    max = 2400,
                    step = 1
                }
            }
        }
    }
}
