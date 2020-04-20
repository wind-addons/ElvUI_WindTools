local E, L, V, P, G = unpack(ElvUI); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")
local _G = _G

P["WindTools"]["Chat"] = {
    ["Chat Frame"] = {
        enabled = true,
        link = {
            enabled = true,
            add_level = true,
            add_icon = true,
            add_armor_category = true,
            add_weapon_category = true,
            add_corruption_rank = true
        },
        smart_tab = {
            enabled = true,
            whisper_cycle = false,
            use_yell = false,
            use_battleground = false,
            use_raid_warning = false,
            use_officer = false,
            whisper_targets = {},
            whisper_history_time = 10
        },
        emote = {enabled = true, size = 16, use_panel = true},
        correction = {enabled = true, dun_to_slash = true}
    },
    ["Chat Bar"] = {
        enabled = true,
        style = {
            smart_hide = false,
            bar_backdrop = false,
            mouseover = false,
            orientation = "HORIZONTAL",
            padding = 5,
            width = 40,
            height = 8,
            block_type = {enabled = true, tex = V.general.normTex, shadow = true},
            text_type = {
                enabled = false,
                color = true,
                font_name = E.db.general.font,
                font_size = 14,
                font_style = "OUTLINE"
            }
        },
        normal_channels = {
            ["SAY"] = {enabled = true, cmd = "s", color = {1, 1, 1, 1}, abbr = L["Say_Abbr"]},
            ["YELL"] = {enabled = true, cmd = "y", color = {1, .25, .25, 1}, abbr = L["Yell_Abbr"]},
            ["EMOTE"] = {enabled = false, cmd = "e", color = {1, .5, .25, 1}, abbr = L["Emote_Abbr"]},
            ["PARTY"] = {enabled = true, cmd = "p", color = {.67, .67, 1, 1}, abbr = L["Party_Abbr"]},
            ["INSTANCE"] = {enabled = true, cmd = "i", color = {1, .73, .2, 1}, abbr = L["Instance_Abbr"]},
            ["RAID"] = {enabled = true, cmd = "raid", color = {1, .5, 0, 1}, abbr = L["Raid_Abbr"]},
            ["RAID_WARNING"] = {enabled = false, cmd = "rw", color = {1, .28, 0, 1}, abbr = L["RaidWarning_Abbr"]},
            ["GUILD"] = {enabled = true, cmd = "g", color = {.25, 1, .25, 1}, abbr = L["Guild_Abbr"]},
            ["OFFICER"] = {enabled = false, cmd = "o", color = {.25, .75, .25, 1}, abbr = L["Officer_Abbr"]}
        },
        world_channel = {
            enabled = true,
            auto_join = true,
            channel_name = "",
            color = {.2, .6, .86, 1},
            abbr = L["World_Abbr"]
        },
        emote_button = {enabled = true, use_icon = true, color = {1, .33, .52, 1}, abbr = L["Emote_Abbr"]},
        roll_button = {enabled = true, use_icon = true, color = {.56, .56, .56, 1}, abbr = L["Roll_Abbr"]}
    },
    ["Enhanced Friend List"] = {
        ["enabled"] = true,
        ["color_name"] = true,
        ["enhanced"] = {
            ["enabled"] = true,
            ["NameFont"] = E.db.general.font,
            ["NameFontSize"] = 13,
            ["NameFontFlag"] = "OUTLINE",
            ["InfoFont"] = E.db.general.font,
            ["InfoFontSize"] = 12,
            ["InfoFontFlag"] = "OUTLINE",
            ["StatusIconPack"] = "D3",
            ["GameIcon"] = {
                ["App"] = "Launcher",
                ["Alliance"] = "Launcher",
                ["Horde"] = "Launcher",
                ["Neutral"] = "Launcher",
                ["D3"] = "Launcher",
                ["WTCG"] = "Launcher",
                ["S1"] = "Launcher",
                ["S2"] = "Launcher",
                ["BSAp"] = "Launcher",
                ["Hero"] = "Launcher",
                ["Pro"] = "Launcher",
                ["DST2"] = "Launcher"
            }
        }
    },
    ["Right-click Menu"] = {
        ["enabled"] = false,
        ["friend"] = {
            ["ARMORY"] = true,
            ["MYSTATS"] = true,
            ["NAME_COPY"] = true,
            ["SEND_WHO"] = true,
            ["FRIEND_ADD"] = true,
            ["GUILD_ADD"] = true
            -- ["Fix_Report"] = false,
        }
        -- ["chat_roster"] = {
        -- 	["NAME_COPY"]  = true,
        -- 	["SEND_WHO"] = true,
        -- 	["FRIEND_ADD"] = true,
        -- },
        -- ["guild"] = {
        -- 	["ARMORY"] = true,
        -- 	["NAME_COPY"] = true,
        -- 	["FRIEND_ADD"] = true,
        -- }
    },
    ["Unblock Filter"] = {["enabled"] = true}
}

WT.ToolConfigs["Chat"] = {
    ["Chat Frame"] = {
        tDesc = L["Provide more features for chat frame."],
        oAuthor = "houshuu",
        cAuthor = "houshuu",
        smart_tab = {
            name = L["Use Tab to switch channel"],
            order = 5,
            get = function(info) return E.db.WindTools["Chat"]["Chat Frame"][info[4]][info[#info]] end,
            set = function(info, value) E.db.WindTools["Chat"]["Chat Frame"][info[4]][info[#info]] = value end,
            args = {
                enabled = {
                    order = 1,
                    name = L["Enable"],
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Frame"][info[4]][info[#info]] = value;
                        E:StaticPopup_Show("PRIVATE_RL")
                    end
                },
                whisper_cycle = {name = L["Whisper Cycle"], order = 2},
                use_yell = {name = CHAT_MSG_YELL, order = 3},
                use_battleground = {name = CHAT_MSG_BATTLEGROUND, order = 4},
                use_raid_warning = {name = CHAT_MSG_RAID_WARNING, order = 5},
                use_officer = {name = CHAT_MSG_OFFICER, order = 6},
                whisper_history_time = {
                    name = L['Whisper history expiration time (min)'],
                    order = 7,
                    type = 'range',
                    width = 1.3,
                    desc = L['This module will record whispers for switching.\n You can set the expiration time here for making a shortlist of recent targets.'],
                    min = 1,
                    max = 2400,
                    step = 1
                }
            }
        },
        link = {
            name = L["Add information on link"],
            order = 6,
            get = function(info) return E.db.WindTools["Chat"]["Chat Frame"][info[4]][info[#info]] end,
            set = function(info, value) E.db.WindTools["Chat"]["Chat Frame"][info[4]][info[#info]] = value end,
            args = {
                enabled = {
                    name = L["Enable"],
                    order = 1,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Frame"][info[4]][info[#info]] = value;
                        E:StaticPopup_Show("PRIVATE_RL")
                    end
                },
                add_icon = {name = L["Add Icon"], order = 2},
                add_level = {name = L["Add Level"], order = 3},
                add_armor_category = {name = L["Add Armor Category"], order = 4},
                add_weapon_category = {name = L["Add Weapon Category"], order = 5},
                add_corruption_rank = {name = L["Add Corruption Rank"], order = 5}
            }
        },
        emote = {
            name = L["Emote"],
            order = 7,
            get = function(info) return E.db.WindTools["Chat"]["Chat Frame"][info[4]][info[#info]] end,
            set = function(info, value) E.db.WindTools["Chat"]["Chat Frame"][info[4]][info[#info]] = value end,
            args = {
                enabled = {
                    name = L["Enable"],
                    desc = L["Parse emote expresstion from other players."],
                    order = 1,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Frame"][info[4]][info[#info]] = value;
                        E:StaticPopup_Show("PRIVATE_RL")
                    end
                },
                size = {name = L['Emote Icon Size'], order = 2, type = 'range', min = 5, max = 35, step = 1},
                use_panel = {
                    name = L["Use Emote Panel"],
                    desc = L["Press { to active the emote select window."],
                    order = 3
                }
            }
        },
        correction = {
            name = L["Input Correction"],
            order = 8,
            get = function(info) return E.db.WindTools["Chat"]["Chat Frame"][info[4]][info[#info]] end,
            set = function(info, value) E.db.WindTools["Chat"]["Chat Frame"][info[4]][info[#info]] = value end,
            args = {
                enabled = {
                    name = L["Enable"],
                    order = 1,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Frame"][info[4]][info[#info]] = value;
                        E:StaticPopup_Show("PRIVATE_RL")
                    end
                },
                dun_to_slash = {
                    name = "「、」=>「/」",
                    desc = L["Designed for Asian player, it will help you to enter command without switching IME."],
                    order = 2
                }
            }
        }
    },
    ["Chat Bar"] = {
        tDesc = L["Add a chat bar for switching channel."],
        oAuthor = "houshuu",
        cAuthor = "houshuu",
        style = {
            name = L["Style"],
            order = 5,
            args = {
                bar_backdrop = {
                    order = 1,
                    name = L["Bar Backdrop"],
                    get = function(info) return E.db.WindTools["Chat"]["Chat Bar"].style.bar_backdrop end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Bar"].style.bar_backdrop = value;
                        E:GetModule('Wind_ChatBar'):UpdateBar()
                    end
                },
                smart_hide = {
                    order = 2,
                    name = L["Smart Hide"],
                    get = function(info) return E.db.WindTools["Chat"]["Chat Bar"].style.smart_hide end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Bar"].style.smart_hide = value;
                        E:StaticPopup_Show("PRIVATE_RL")
                    end
                },
                mouseover = {
                    order = 3,
                    name = L["Mouse Over"],
                    get = function(info) return E.db.WindTools["Chat"]["Chat Bar"].style.mouseover end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Bar"].style.mouseover = value;
                        E:GetModule('Wind_ChatBar'):UpdateBar()
                    end
                },
                block_type = {
                    order = 4,
                    name = L["Block Type"],
                    get = function(info)
                        return E.db.WindTools["Chat"]["Chat Bar"].style.block_type.enabled
                    end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Bar"].style.block_type.enabled = value
                        E.db.WindTools["Chat"]["Chat Bar"].style.text_type.enabled = not value
                        E:StaticPopup_Show("PRIVATE_RL")
                    end
                },
                text_type = {
                    order = 5,
                    name = L["Text Type"],
                    get = function(info)
                        return E.db.WindTools["Chat"]["Chat Bar"].style.text_type.enabled
                    end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Bar"].style.text_type.enabled = value
                        E.db.WindTools["Chat"]["Chat Bar"].style.block_type.enabled = not value
                        E:StaticPopup_Show("PRIVATE_RL")
                    end
                },
                orientation = {
                    order = 7,
                    type = 'select',
                    name = L['Orientation'],
                    get = function(info) return E.db.WindTools["Chat"]["Chat Bar"].style.orientation end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Bar"].style.orientation = value;
                        E:GetModule('Wind_ChatBar'):UpdateBar()
                    end,
                    values = {['HORIZONTAL'] = L['Horizontal'], ['VERTICAL'] = L['Vertical']}
                },
                padding = {
                    order = 10,
                    type = 'range',
                    name = L['Padding'],
                    min = 0,
                    max = 20,
                    step = 1,
                    get = function(info) return E.db.WindTools["Chat"]["Chat Bar"].style.padding end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Bar"].style.padding = value;
                        E:GetModule('Wind_ChatBar'):UpdateBar()
                    end
                },
                width = {
                    order = 11,
                    type = 'range',
                    name = L['Width'],
                    min = 2,
                    max = 100,
                    step = 1,
                    get = function(info) return E.db.WindTools["Chat"]["Chat Bar"].style.width end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Bar"].style.width = value;
                        E:GetModule('Wind_ChatBar'):UpdateBar()
                    end
                },
                height = {
                    order = 12,
                    type = 'range',
                    name = L['Height'],
                    min = 2,
                    max = 100,
                    step = 1,
                    get = function(info) return E.db.WindTools["Chat"]["Chat Bar"].style.height end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Bar"].style.height = value;
                        E:GetModule('Wind_ChatBar'):UpdateBar()
                    end
                },
                block_type_setting = {
                    order = 13,
                    name = L["Block Type Setting"],
                    hidden = function()
                        return E.db.WindTools["Chat"]["Chat Bar"].style.text_type.enabled
                    end,
                    args = {
                        block_type_shadow = {
                            order = 1,
                            name = L["Add Button Shadow"],
                            get = function(info)
                                return E.db.WindTools["Chat"]["Chat Bar"].style.block_type.shadow
                            end,
                            set = function(info, value)
                                E.db.WindTools["Chat"]["Chat Bar"].style.block_type.shadow = value;
                                E:GetModule('Wind_ChatBar'):UpdateBar()
                            end
                        },
                        block_type_tex = {
                            order = 2,
                            name = L["Button Texture"],
                            hidden = function()
                                return E.db.WindTools["Chat"]["Chat Bar"].style.text_type.enabled
                            end,
                            get = function(info)
                                return E.db.WindTools["Chat"]["Chat Bar"].style.block_type.tex
                            end,
                            set = function(info, value)
                                E.db.WindTools["Chat"]["Chat Bar"].style.block_type.tex = value;
                                E:GetModule('Wind_ChatBar'):UpdateBar()
                            end,
                            type = "select",
                            dialogControl = "LSM30_Statusbar",
                            values = LSM:HashTable('statusbar')
                        }
                    }
                },
                text_type_setting = {
                    order = 14,
                    name = L["Text Type Setting"],
                    hidden = function()
                        return E.db.WindTools["Chat"]["Chat Bar"].style.block_type.enabled
                    end,
                    get = function(info)
                        return E.db.WindTools["Chat"]["Chat Bar"].style.text_type[info[#info]]
                    end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Bar"].style.text_type[info[#info]] = value;
                        E:GetModule('Wind_ChatBar'):UpdateBar()
                    end,
                    args = {
                        font_name = {
                            name = L['Font'],
                            order = 1,
                            type = 'select',
                            dialogControl = 'LSM30_Font',
                            values = LSM:HashTable('font')
                        },
                        font_size = {name = L['Size'], order = 2, type = 'range', min = 6, max = 22, step = 1},
                        font_style = {
                            name = L['Style'],
                            order = 3,
                            type = 'select',
                            values = {
                                ['NONE'] = L['None'],
                                ['OUTLINE'] = L['OUTLINE'],
                                ['MONOCHROME'] = L['MONOCHROME'],
                                ['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
                                ['THICKOUTLINE'] = L['THICKOUTLINE']
                            }
                        },
                        color = {order = 1, name = L["Use Color"]}
                    }
                }
            }
        },
        normal_channels = {
            name = _G.CHANNEL,
            order = 7,
            args = {
                world_channel = {
                    order = 100,
                    name = _G.WORLD,
                    get = function(info) return E.db.WindTools["Chat"]["Chat Bar"][info[5]][info[6]] end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Bar"][info[5]][info[6]] = value;
                        E:GetModule('Wind_ChatBar'):UpdateBar()
                    end,
                    args = {
                        enabled = {order = 1, name = L["Enable"]},
                        auto_join = {order = 2, name = L["Auto Join"]},
                        channel_name = {order = 3, type = "input", name = L["Channel Name"]},
                        color = {
                            order = 4,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = true,
                            get = function(info)
                                local colordb = E.db.WindTools["Chat"]["Chat Bar"][info[5]][info[6]]
                                local default = P.WindTools["Chat"]["Chat Bar"].roll_button.color
                                return colordb[1], colordb[2], colordb[3], colordb[4], default[1], default[2],
                                       default[3], default[4]
                            end,
                            set = function(info, r, g, b, a)
                                E.db.WindTools["Chat"]["Chat Bar"][info[5]][info[6]] = {r, g, b, a}
                                E:GetModule('Wind_ChatBar'):UpdateBar()
                            end
                        },
                        abbr = {
                            order = 5,
                            type = "input",
                            hidden = function()
                                return E.db.WindTools["Chat"]["Chat Bar"].style.block_type.enabled
                            end,
                            name = L["Abbreviation"]
                        }
                    }
                },
                emote_button = {
                    order = 101,
                    name = "Wind" .. L["Emote"],
                    get = function(info) return E.db.WindTools["Chat"]["Chat Bar"][info[5]][info[6]] end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Bar"][info[5]][info[6]] = value;
                        E:GetModule('Wind_ChatBar'):UpdateBar()
                    end,
                    args = {
                        enabled = {order = 1, name = L["Enable"]},
                        use_icon = {
                            order = 2,
                            name = L["Use Icon"],
                            hidden = function()
                                return not E.db.WindTools["Chat"]["Chat Bar"].style.text_type.enabled
                            end,
                            desc = L["Use a icon rather than text"]
                        },
                        color = {
                            order = 3,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = true,
                            get = function(info)
                                local colordb = E.db.WindTools["Chat"]["Chat Bar"][info[5]][info[6]]
                                local default = P.WindTools["Chat"]["Chat Bar"][info[5]][info[6]]
                                return colordb[1], colordb[2], colordb[3], colordb[4], default[1], default[2],
                                       default[3], default[4]
                            end,
                            set = function(info, r, g, b, a)
                                E.db.WindTools["Chat"]["Chat Bar"][info[5]][info[6]] = {r, g, b, a}
                                E:GetModule('Wind_ChatBar'):UpdateBar()
                            end
                        },
                        abbr = {
                            order = 4,
                            type = "input",
                            hidden = function()
                                return E.db.WindTools["Chat"]["Chat Bar"].style.block_type.enabled
                            end,
                            name = L["Abbreviation"]
                        }
                    }
                },
                roll_button = {
                    order = 102,
                    name = _G.ROLL,
                    get = function(info) return E.db.WindTools["Chat"]["Chat Bar"][info[5]][info[6]] end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Bar"][info[5]][info[6]] = value;
                        E:GetModule('Wind_ChatBar'):UpdateBar()
                    end,
                    args = {
                        enabled = {order = 1, name = L["Enable"]},
                        use_icon = {
                            order = 2,
                            name = L["Use Icon"],
                            hidden = function()
                                return not E.db.WindTools["Chat"]["Chat Bar"].style.text_type.enabled
                            end,
                            desc = L["Use a icon rather than text"]
                        },
                        color = {
                            order = 3,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = true,
                            get = function(info)
                                local colordb = E.db.WindTools["Chat"]["Chat Bar"][info[5]][info[6]]
                                local default = P.WindTools["Chat"]["Chat Bar"][info[5]][info[6]]
                                return colordb[1], colordb[2], colordb[3], colordb[4], default[1], default[2],
                                       default[3], default[4]
                            end,
                            set = function(info, r, g, b, a)
                                E.db.WindTools["Chat"]["Chat Bar"][info[5]][info[6]] = {r, g, b, a}
                                E:GetModule('Wind_ChatBar'):UpdateBar()
                            end
                        },
                        abbr = {
                            order = 4,
                            type = "input",
                            hidden = function()
                                return E.db.WindTools["Chat"]["Chat Bar"].style.block_type.enabled
                            end,
                            name = L["Abbreviation"]
                        }
                    }
                }
            }
        },
        func = function()
            local option = WT.ToolConfigs["Chat"]["Chat Bar"].normal_channels.args
            local db = P["WindTools"]["Chat"]["Chat Bar"].normal_channels
            local normal_channels_index = {"SAY", "YELL", "PARTY", "INSTANCE", "RAID", "RAID_WARNING", "GUILD", "EMOTE"}
            for index, name in ipairs(normal_channels_index) do
                option[name] = {
                    order = index,
                    name = _G[name],
                    get = function(info)
                        return E.db.WindTools["Chat"]["Chat Bar"][info[4]][info[5]][info[6]]
                    end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Chat Bar"][info[4]][info[5]][info[6]] = value;
                        E:GetModule('Wind_ChatBar'):UpdateBar()
                    end,
                    args = {
                        enabled = {order = 1, name = L["Enable"]},
                        color = {
                            order = 2,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = true,
                            get = function(info)
                                local colordb = E.db.WindTools["Chat"]["Chat Bar"][info[4]][info[5]][info[6]]
                                local default = db[name].color
                                return colordb[1], colordb[2], colordb[3], colordb[4], default[1], default[2],
                                       default[3], default[4]
                            end,
                            set = function(info, r, g, b, a)
                                E.db.WindTools["Chat"]["Chat Bar"][info[4]][info[5]][info[6]] = {r, g, b, a}
                                E:GetModule('Wind_ChatBar'):UpdateBar()
                            end
                        },
                        abbr = {
                            order = 3,
                            type = "input",
                            hidden = function()
                                return E.db.WindTools["Chat"]["Chat Bar"].style.block_type.enabled
                            end,
                            name = L["Abbreviation"]
                        }
                    }
                }
            end
        end
    },
    ["Enhanced Friend List"] = {
        tDesc = L["Customize friend frame."],
        oAuthor = "ProjectAzilroka",
        cAuthor = "houshuu",
        ["colorName"] = {
            name = L['Features'],
            order = 5,
            args = {
                ["color_name"] = {
                    name = L['Name color & Level'],
                    order = 1,
                    get = function(info)
                        return E.db.WindTools["Chat"]["Enhanced Friend List"].color_name
                    end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Enhanced Friend List"].color_name = value;
                        E:StaticPopup_Show("PRIVATE_RL")
                    end
                },
                ["enhanced_enable"] = {
                    name = L['Enhanced Texuture'],
                    order = 2,
                    get = function(info)
                        return E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced["enabled"]
                    end,
                    set = function(info, value)
                        E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced["enabled"] = value;
                        E:StaticPopup_Show("PRIVATE_RL")
                    end
                }
            }
        },
        ["general"] = {
            name = L['General'],
            order = 6,
            get = function(info) return E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced[info[#info]] end,
            set = function(info, value)
                E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced[info[#info]] = value
                FriendsFrame_Update()
            end,
            args = {
                ["NameFont"] = {
                    name = L['Name Font'],
                    order = 1,
                    type = 'select',
                    dialogControl = 'LSM30_Font',
                    desc = L['The font that the RealID / Character Name / Level uses.'],
                    values = LSM:HashTable('font')
                },
                ["NameFontSize"] = {
                    name = L['Name Font Size'],
                    order = 2,
                    type = 'range',
                    desc = L['The font size that the RealID / Character Name / Level uses.'],
                    min = 6,
                    max = 22,
                    step = 1
                },
                ["NameFontFlag"] = {
                    name = L['Name Font Flag'],
                    order = 3,
                    type = 'select',
                    desc = L['The font flag that the RealID / Character Name / Level uses.'],
                    values = {
                        ['NONE'] = L['None'],
                        ['OUTLINE'] = L['OUTLINE'],
                        ['MONOCHROME'] = L['MONOCHROME'],
                        ['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
                        ['THICKOUTLINE'] = L['THICKOUTLINE']
                    }
                },
                ["InfoFont"] = {
                    type = 'select',
                    dialogControl = 'LSM30_Font',
                    name = L['Info Font'],
                    order = 4,
                    desc = L['The font that the Zone / Server uses.'],
                    values = LSM:HashTable('font')
                },
                ["InfoFontSize"] = {
                    name = L['Info Font Size'],
                    order = 5,
                    desc = L['The font size that the Zone / Server uses.'],
                    type = 'range',
                    min = 6,
                    max = 22,
                    step = 1
                },
                ["InfoFontFlag"] = {
                    name = L['Info Font Outline'],
                    order = 6,
                    desc = L['The font flag that the Zone / Server uses.'],
                    type = 'select',
                    values = {
                        ['NONE'] = L['None'],
                        ['OUTLINE'] = L['OUTLINE'],
                        ['MONOCHROME'] = L['MONOCHROME'],
                        ['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
                        ['THICKOUTLINE'] = L['THICKOUTLINE']
                    }
                },
                ["StatusIconPack"] = {
                    name = L['Status Icon Pack'],
                    order = 7,
                    desc = L['Different Status Icons.'],
                    type = 'select',
                    values = {['Default'] = L['Default'], ['Square'] = L['Square'], ['D3'] = L['Diablo 3']}
                }
            }
        },
        ["GameIcons"] = {
            name = L['Game Icons'],
            order = 7,
            get = function(info)
                return E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced.GameIcon[info[#info]]
            end,
            set = function(info, value)
                E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced.GameIcon[info[#info]] = value
                FriendsFrame_Update()
            end,
            args = {}
        },
        ["GameIconsPreview"] = {name = L['Game Icon Preview'], order = 8, args = {}},
        ["StatusIcons"] = {name = L['Status Icon Preview'], order = 9, args = {}},
        func = function()
            local EFL = E:GetModule("Wind_EnhancedFriendsList")
            local GameIconsOptions = {
                Alliance = FACTION_ALLIANCE,
                Horde = FACTION_HORDE,
                Neutral = FACTION_STANDING_LABEL4,
                D3 = L['Diablo 3'],
                WTCG = L['Hearthstone'],
                S1 = L['Starcraft'],
                S2 = L['Starcraft 2'],
                App = L['App'],
                BSAp = L['Mobile'],
                Hero = L['Hero of the Storm'],
                Pro = L['Overwatch'],
                DST2 = L['Destiny 2']
            }
            local GameIconOrder = {
                Alliance = 1,
                Horde = 2,
                Neutral = 3,
                D3 = 4,
                WTCG = 5,
                S1 = 6,
                S2 = 7,
                App = 8,
                BSAp = 9,
                Hero = 10,
                Pro = 11,
                DST2 = 12
            }
            local StatusIconsOptions = {
                Online = FRIENDS_LIST_ONLINE,
                Offline = FRIENDS_LIST_OFFLINE,
                DND = DEFAULT_DND_MESSAGE,
                AFK = DEFAULT_AFK_MESSAGE
            }
            local StatusIconsOrder = {Online = 1, Offline = 2, DND = 3, AFK = 4}

            for Key, Value in pairs(GameIconsOptions) do
                WT.ToolConfigs["Chat"]["Enhanced Friend List"].GameIcons.args[Key] =
                    {
                        name = L[Value] .. " " .. L['Icon'],
                        order = GameIconOrder[Key],
                        type = 'select',
                        values = {
                            ['Default'] = L['Default'],
                            ['BlizzardChat'] = L['Blizzard Chat'],
                            ['Flat'] = L['Flat Style'],
                            ['Gloss'] = L['Glossy'],
                            ['Launcher'] = L['Launcher']
                        }
                    }
                WT.ToolConfigs["Chat"]["Enhanced Friend List"].GameIconsPreview.args[Key] =
                    {
                        order = GameIconOrder[Key],
                        type = 'execute',
                        name = L[Value],
                        func = function() return end,
                        image = function(info)
                            return EFL.GameIcons[info[#info]][E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced
                                       .GameIcon[Key]], 32, 32
                        end
                    }
            end

            -- 排除缺少的 SC1 图标
            WT.ToolConfigs["Chat"]["Enhanced Friend List"].GameIcons.args["S1"].values["Flat"] = nil
            WT.ToolConfigs["Chat"]["Enhanced Friend List"].GameIcons.args["S1"].values["Gloss"] = nil

            for Key, Value in pairs(StatusIconsOptions) do
                WT.ToolConfigs["Chat"]["Enhanced Friend List"].StatusIcons.args[Key] =
                    {
                        order = StatusIconsOrder[Key],
                        type = 'execute',
                        name = L[Value],
                        func = function() return end,
                        image = function(info)
                            return EFL.StatusIcons[E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced
                                       .StatusIconPack][info[#info]], 16, 16
                        end
                    }
            end
        end
    },
    ["Right-click Menu"] = {
        tDesc = L["Enhanced right-click menu"],
        oAuthor = "loudsoul",
        cAuthor = "houshuu",
        ["friend"] = {name = L["Friend Menu"], order = 5, args = {}},
        -- ["chat_roster"] = {
        -- 	name = L["Chat Roster Menu"],
        -- 	order = 6,
        -- 	args = {}
        -- },
        -- ["guild"] = {
        -- 	name = L["Guild Menu"],
        -- 	order = 7,
        -- 	args = {}
        -- },
        func = function()
            local EnhancedRCMenu = E:GetModule("Wind_EnhancedRCMenu")
            -- 循环载入设定
            for k, v in pairs(EnhancedRCMenu.friend_features) do
                WT.ToolConfigs["Chat"]["Right-click Menu"]["friend"].args[v] =
                    {
                        order = k + 1,
                        name = UnitPopupButtons[v].text,
                        get = function(info)
                            return E.db.WindTools["Chat"]["Right-click Menu"]["friend"][v]
                        end,
                        set = function(info, value)
                            E.db.WindTools["Chat"]["Right-click Menu"]["friend"][v] = value;
                            E:StaticPopup_Show("PRIVATE_RL")
                        end
                    }
            end
            -- for k, v in pairs(EnhancedRCMenu.cr_features) do
            -- 	WT.ToolConfigs["Chat"]["Right-click Menu"]["chat_roster"].args[v] = {
            -- 		order = k + 1,
            -- 		name = EnhancedRCMenu.UnitPopupButtonsExtra[v],
            -- 		get = function(info) return E.db.WindTools["Chat"]["Right-click Menu"]["chat_roster"][v] end,
            -- 		set = function(info, value) E.db.WindTools["Chat"]["Right-click Menu"]["chat_roster"][v] = value; E:StaticPopup_Show("PRIVATE_RL")  end,
            -- 	}
            -- end
            -- for k, v in pairs(EnhancedRCMenu.guild_features) do
            -- 	WT.ToolConfigs["Chat"]["Right-click Menu"]["guild"].args[v] = {
            -- 		order = k + 1,
            -- 		name = EnhancedRCMenu.UnitPopupButtonsExtra[v],
            -- 		get = function(info) return E.db.WindTools["Chat"]["Right-click Menu"]["guild"][v] end,
            -- 		set = function(info, value) E.db.WindTools["Chat"]["Right-click Menu"]["guild"][v] = value; E:StaticPopup_Show("PRIVATE_RL")  end,
            -- 	}
            -- end

            -- WT.ToolConfigs["Chat"]["Right-click Menu"]["friend"].args.Fix_Report = {
            -- 	order = -1,
            -- 	name = L["Fix REPORT"],
            -- 	get = function(info) return E.db.WindTools["Chat"]["Right-click Menu"]["friend"]["Fix_Report"] end,
            -- 	set = function(info, value) E.db.WindTools["Chat"]["Right-click Menu"]["friend"]["Fix_Report"] = value; E:StaticPopup_Show("PRIVATE_RL")  end,
            -- }
        end
    },
    ["Unblock Filter"] = {
        tDesc = L["Unblock profanity filter setting for China server."],
        oAuthor = "EKE",
        cAuthor = "houshuu"
    }
}
