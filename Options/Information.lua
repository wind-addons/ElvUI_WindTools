local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.information.args
local ACH = E.Libs.ACH

local _G = _G
local format = format
local ipairs = ipairs
local pairs = pairs
local tostring = tostring
local type = type
local unpack = unpack

local ReloadUI = ReloadUI

local discordURL = "https://discord.gg/JMz5Zsk"
if E.global.general.locale == "zhCN" or E.global.general.locale == "zhTW" then
    discordURL = "https://discord.gg/nA44TeZ"
end

local function AddColor(string)
    if type(string) ~= "string" then
        string = tostring(string)
    end
    return F.CreateColorString(string, {r = 0.204, g = 0.596, b = 0.859})
end

options.help = {
    order = 1,
    type = "group",
    name = L["Help"],
    args = {
        description = {
            order = 1,
            type = "description",
            fontSize = "medium",
            name = format(
                "%s\n\n%s\n\n%s\n\n%s\n\n\n",
                format(L["Thank you for using %s!"], L["WindTools"]),
                format(
                    L[
                        "%s is a plugin for ElvUI that consists of my original plugins and several plugins developed by other players."
                    ],
                    L["WindTools"]
                ),
                format(
                    L[
                        "In Shadowlands (9.0) pre-patch, %s has been rewritten, such that possibly there are bugs somewhere."
                    ],
                    L["WindTools"]
                ),
                format(
                    L["You can send your suggestions or bugs via %s, %s, %s, and the thread in %s."],
                    L["QQ Group"],
                    L["Discord"],
                    L["Github"],
                    L["NGA.cn"]
                )
            )
        },
        contributors = {
            order = 2,
            name = L["Contributors (Github.com)"],
            type = "group",
            inline = true,
            args = {
                ["1"] = {
                    order = 1,
                    type = "description",
                    name = format(
                        "%s: %s",
                        "fang2hou",
                        F.CreateClassColorString("Tabimonk @ " .. L["Shadowmoon"] .. "(TW)", "MONK")
                    )
                },
                ["2"] = {
                    order = 2,
                    type = "description",
                    name = "someblu"
                },
                ["3"] = {
                    order = 3,
                    type = "description",
                    name = "mcc1"
                },
                ["4"] = {
                    order = 4,
                    type = "description",
                    name = "MouJiaoZi"
                },
                ["5"] = {
                    order = 5,
                    type = "description",
                    name = "404Polaris"
                },
                ["6"] = {
                    order = 6,
                    type = "description",
                    name = "LiangYuxuan"
                },
                ["7"] = {
                    order = 7,
                    type = "description",
                    name = "keludechu"
                }
            }
        },
        version = {
            order = 3,
            name = L["Version"],
            type = "group",
            inline = true,
            args = {
                elvui = {
                    order = 1,
                    type = "description",
                    name = "ElvUI: " .. AddColor(E.version)
                },
                windtools = {
                    order = 2,
                    type = "description",
                    name = L["WindTools"] .. ": " .. AddColor(W.Version)
                },
                build = {
                    order = 3,
                    type = "description",
                    name = L["WoW Build"] .. ": " .. AddColor(format("%s (%s)", E.wowpatch, E.wowbuild))
                }
            }
        },
        contact = {
            order = 4,
            type = "group",
            inline = true,
            name = " ",
            args = {
                nga = {
                    order = 1,
                    type = "execute",
                    name = L["NGA.cn"],
                    image = W.Media.Icons.nga,
                    func = function()
                        E:StaticPopup_Show("WINDTOOLS_EDITBOX", nil, nil, "https://bbs.nga.cn/read.php?tid=12142815")
                    end,
                    width = 0.7
                },
                discord = {
                    order = 2,
                    type = "execute",
                    name = L["Discord"],
                    image = W.Media.Icons.discord,
                    func = function()
                        E:StaticPopup_Show("WINDTOOLS_EDITBOX", nil, nil, discordURL)
                    end,
                    width = 0.7
                },
                qq = {
                    order = 3,
                    type = "execute",
                    name = L["QQ Group"],
                    image = W.Media.Icons.qq,
                    func = function()
                        E:StaticPopup_Show("WINDTOOLS_EDITBOX", nil, nil, "306069019")
                    end,
                    width = 0.7
                },
                github = {
                    order = 4,
                    type = "execute",
                    name = L["Github"],
                    image = W.Media.Icons.github,
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_EDITBOX",
                            nil,
                            nil,
                            "https://github.com/fang2hou/ElvUI_WindTools/issues"
                        )
                    end,
                    width = 0.7
                }
            }
        },
        debugMode = {
            order = 999,
            type = "toggle",
            name = L["Debug Mode"],
            desc = L["If you installed other ElvUI Plugins, enabling debug mode is not a suggestion."],
            get = function(info)
                return E.private.WT.core.debugMode
            end,
            set = function(info, value)
                E.private.WT.core.debugMode = value
                E:StaticPopup_Show("PRIVATE_RL")
            end
        }
    }
}

options.credits = {
    order = 2,
    type = "group",
    name = L["Credits"],
    args = {
        specialThanks = {
            order = 1,
            name = L["Special Thanks"],
            type = "group",
            inline = true,
            args = {}
        },
        sites = {
            order = 2,
            name = L["Sites"],
            type = "group",
            inline = true,
            args = {}
        },
        localization = {
            order = 3,
            name = L["Localization"],
            type = "group",
            inline = true,
            args = {}
        },
        codes = {
            order = 4,
            name = L["Codes"],
            type = "group",
            inline = true,
            args = {}
        },
        mediaFiles = {
            order = 5,
            name = L["Media Files"],
            type = "group",
            inline = true,
            args = {}
        }
    }
}

do -- 特别感谢
    local nameList = {
        "|cffd12727Blazeflack|r",
        "|cffff7d0aMerathilis|r",
        "|cffff7d0aBenik|r",
        "|cfffff0cdsiweia|r",
        "|cfffff0cdloudsoul|r",
        E:TextGradient("Simpy", 1.00, 1.00, 0.60, 0.53, 1.00, 0.40),
        "|cff0070deAzilroka|r",
        "Haste",
        "Tukz",
        "Elv"
    }

    local nameString = strjoin(", ", unpack(nameList))

    options.credits.args.specialThanks.args["1"] = {
        order = 1,
        type = "description",
        name = format(L["Special thanks to %s."], nameString)
    }

    options.credits.args.specialThanks.args["2"] = {
        order = 2,
        type = "description",
        name = L["I have learned a lot from their codes."]
    }
end

do -- 网站
    local siteList = {
        "https://www.wowhead.com/",
        "https://www.townlong-yak.com/",
        "https://wow.tools/",
        "https://wow.gamepedia.com/"
    }

    for i, site in pairs(siteList) do
        options.credits.args.sites.args[tostring(i)] = {
            order = i,
            type = "description",
            name = site
        }
    end
end

do -- 本地化
    local localizationList = {
        ["français (frFR)"] = {
            "PodVibe @ CurseForge"
        },
        ["Deutsche (deDE)"] = {
            "imna1975 @ CurseForge"
        }
    }

    local configOrder = 1
    for langName, credits in pairs(localizationList) do
        options.credits.args.localization.args[tostring(configOrder)] = {
            order = configOrder,
            type = "description",
            name = AddColor(langName)
        }
        configOrder = configOrder + 1

        for _, credit in pairs(credits) do
            options.credits.args.localization.args[tostring(configOrder)] = {
                order = configOrder,
                type = "description",
                name = "  - " .. credit
            }
            configOrder = configOrder + 1
        end
    end
end

do -- 插件代码
    local codesCreditList = {
        [L["Announcement"]] = {
            "Venomisto (InstanceResetAnnouncer)",
            "Wetxius, Shestak (ShestakUI)",
            "cadcamzy (EUI)"
        },
        [L["Raid Markers"]] = {
            "Repooc (Shadow & Light)"
        },
        [L["Datatexts"]] = {
            "crackpotx (ElvUI Micro Menu Datatext)"
        },
        [L["Already Known"]] = {
            "ahak (Already Known?)"
        },
        [L["Fast Loot"]] = {
            "Leatrix (Leatrix Plus)"
        },
        [L["Rectangle Minimap"]] = {
            "Repooc (Shadow & Light)"
        },
        [L["World Map"]] = {
            "Leatrix (Leatrix Maps)",
            "siweia (NDui)"
        },
        [L["Minimap Buttons"]] = {
            "Azilroka, Sinaris, Feraldin (Square Minimap Buttons)"
        },
        [L["Misc"]] = {
            "Warbaby (爱不易)",
            "zaCade (FixTransmogOutfits)"
        },
        [L["Paragon Reputation"]] = {
            "Fail (Paragon Reputation)"
        },
        [L["Skins"]] = {
            "selias2k (iShadow)",
            "siweia (NDui)"
        },
        [L["Filter"]] = {
            "EKE (Fuckyou)"
        },
        [L["Friend List"]] = {
            "Azilroka (ProjectAzilroka)"
        },
        [L["Emote"]] = {
            "loudsoul (TinyChat)"
        },
        [L["Tooltips"]] = {
            "Tevoll (ElvUI Enhanced Again)",
            "MMOSimca (Simple Objective Progress)"
        },
        [L["Turn In"]] = {
            "p3lim (QuickQuest)",
            "siweia (NDui)"
        },
        [L["Context Menu"]] = {
            "Ludicrous Speed, LLC. (Raider.IO)"
        },
        [L["Quick Focus"]] = {
            "siweia (NDui)"
        },
        [L["Move Frames"]] = {
            "zaCade, Numynum (BlizzMove)"
        },
        [L["Extra Items Bar"]] = {
            "cadcamzy (EUI)"
        }
    }

    local configOrder = 1

    for moduleName, credits in pairs(codesCreditList) do
        options.credits.args.codes.args[tostring(configOrder)] = {
            order = configOrder,
            type = "description",
            name = AddColor(moduleName) .. " " .. L["Module"]
        }
        configOrder = configOrder + 1

        for _, credit in pairs(credits) do
            options.credits.args.codes.args[tostring(configOrder)] = {
                order = configOrder,
                type = "description",
                name = "  - " .. credit
            }
            configOrder = configOrder + 1
        end
    end
end

do -- 媒体文件
    local mediaFilesCreditList = {
        ["Iconfont (Alibaba)"] = {
            "Media/Icons/GameBar"
        },
        ["Ferous Media (Ferous)"] = {
            "Media/Texture/Vignetting.tga"
        },
        ["Icon made by Freepik from www.flaticon.com"] = {
            "Media/Icons/Announcement.tga",
            "Media/Texture/Combat.tga",
            "Media/Texture/Shield.tga",
            "Media/Texture/Sword.tga",
            "Media/Icons/Tooltips.tga"
        },
        ["Icon made by Pixel perfect from www.flaticon.com"] = {
            "Media/Icons/Calendar.tga"
        },
        ["Marijan Petrovski @ PSDchat.com"] = {
            "Media/Icons/Hexagon"
        },
        ["ファイナルファンタジーXIV ファンキット"] = {
            "Media/Icons/FFXIV"
        },
        ["SunUI (Coolkids)"] = {
            "Media/Icons/SunUI"
        },
        ["小华子COME @ www.iconfont.cn"] = {
            "Media/Icons/Misc.tga"
        },
        ["KERRY_ZJX @ www.iconfont.cn"] = {
            "Media/Icons/Combat.tga"
        },
        ["Jasmine_20863 @ www.iconfont.cn"] = {
            "Media/Icons/Item.tga"
        },
        ["canisminor-weibo @ www.iconfont.cn"] = {
            "Media/Icons/NGA.tga"
        },
        ["cg尐愳 @ www.iconfont.cn"] = {
            "Media/Icons/Map.tga"
        },
        ["Marina·麥 @ www.iconfont.cn"] = {
            "Media/Icons/Help.tga"
        },
        ["29ga @ www.iconfont.cn"] = {
            "Media/Icons/Chat.tga"
        },
        ["王乐城愚人云端 @ www.iconfont.cn"] = {
            "Media/Texture/WindToolsSmall.tga"
        },
        ["TinyChat (loudsoul)"] = {
            "Media/Emotes"
        },
        ["ProjectAzilroka (Azilroka)"] = {
            "Media/FriendList"
        },
        ["Tepid Monkey"] = {
            "Media/Fonts/AccidentalPresidency.ttf"
        },
        ["Julieta Ulanovsky"] = {
            "Media/Fonts/Montserrat-ExtraBold.ttf"
        },
        ["Keith Bates"] = {
            "Media/Fonts/Roadway.ttf"
        },
        ["OnePlus"] = {
            "Media/Sounds/OnePlusLight.ogg",
            "Media/Sounds/OnePlusSurprise.ogg"
        }
    }

    local configOrder = 1

    for author, sourceTable in pairs(mediaFilesCreditList) do
        options.credits.args.mediaFiles.args[tostring(configOrder)] = {
            order = configOrder,
            type = "description",
            name = AddColor(author)
        }
        configOrder = configOrder + 1

        for _, source in pairs(sourceTable) do
            options.credits.args.mediaFiles.args[tostring(configOrder)] = {
                order = configOrder,
                type = "description",
                name = "  - " .. source
            }
            configOrder = configOrder + 1
        end
    end
end

options.changelog = {
    order = 3,
    type = "group",
    childGroups = "select",
    name = L["Changelog"],
    args = {}
}

local locale = E.global.general.locale
if locale ~= "zhCN" and locale ~= "zhTW" then
    locale = "enUS"
end

for version, data in pairs(W.Changelog) do
    local versionString = format("%d.%02d", version / 100, mod(version, 100))

    options.changelog.args[tostring(version)] = {
        order = 1000 - version,
        name = versionString,
        type = "group",
        args = {}
    }

    local page = options.changelog.args[tostring(version)].args

    page.date = {
        order = 1,
        type = "description",
        name = "|cffbbbbbb" .. data.RELEASE_DATE .. " " .. L["Released"] .. "|r",
        fontSize = "small"
    }

    page.version = {
        order = 2,
        type = "description",
        name = L["Version"] .. " " .. AddColor(versionString),
        fontSize = "large"
    }

    if data.IMPORTANT and #data.IMPORTANT[locale] > 0 then
        page.importantHeader = {
            order = 3,
            type = "header",
            name = AddColor(L["Important"])
        }
        page.important = {
            order = 4,
            type = "description",
            name = function()
                local text = ""
                for index, line in ipairs(data.IMPORTANT[locale]) do
                    text = text .. format("%02d", index) .. ". " .. line .. "\n"
                end
                return text .. "\n"
            end,
            fontSize = "medium"
        }
    end

    if data.NEW and #data.NEW[locale] > 0 then
        page.newHeader = {
            order = 5,
            type = "header",
            name = AddColor(L["New"])
        }
        page.new = {
            order = 6,
            type = "description",
            name = function()
                local text = ""
                for index, line in ipairs(data.NEW[locale]) do
                    text = text .. format("%02d", index) .. ". " .. line .. "\n"
                end
                return text .. "\n"
            end,
            fontSize = "medium"
        }
    end

    if data.IMPROVEMENT and #data.IMPROVEMENT[locale] > 0 then
        page.improvementHeader = {
            order = 7,
            type = "header",
            name = AddColor(L["Improvement"])
        }
        page.improvement = {
            order = 8,
            type = "description",
            name = function()
                local text = ""
                for index, line in ipairs(data.IMPROVEMENT[locale]) do
                    text = text .. format("%02d", index) .. ". " .. line .. "\n"
                end
                return text .. "\n"
            end,
            fontSize = "medium"
        }
    end
end

-- 重置
E.PopupDialogs.WINDTOOLS_RESET_MODULE = {
    text = L["Are you sure you want to reset %s module?"],
    button1 = _G.ACCEPT,
    button2 = _G.CANCEL,
    OnAccept = function(_, func)
        func()
        ReloadUI()
    end,
    whileDead = 1,
    hideOnEscape = true
}

E.PopupDialogs.WINDTOOLS_RESET_ALL_MODULES = {
    text = format(L["Reset all %s modules."], L["WindTools"]),
    button1 = _G.ACCEPT,
    button2 = _G.CANCEL,
    OnAccept = function()
        E.db.WT = P
        E.private.WT = V
        ReloadUI()
    end,
    whileDead = 1,
    hideOnEscape = true
}

options.reset = {
    order = 4,
    type = "group",
    childGroups = "select",
    name = L["Reset"],
    args = {
        windProfile = {
            order = 0,
            type = "group",
            inline = true,
            name = L["Profiles"],
            args = {
                layout = {
                    order = 1,
                    type = "execute",
                    name = L["ElvUI Profile"],
                    desc = "|cffff0000" .. L["Set the profile to WindTools style."],
                    func = function()
                        local WindUI = {
                            ["databars"] = {
                                ["threat"] = {
                                    ["width"] = 417,
                                    ["fontOutline"] = "OUTLINE"
                                },
                                ["honor"] = {
                                    ["enable"] = false
                                },
                                ["reputation"] = {
                                    ["enable"] = true,
                                    ["height"] = 5
                                },
                                ["statusbar"] = "WindTools Glow",
                                ["experience"] = {
                                    ["width"] = 222,
                                    ["hideAtMaxLevel"] = false,
                                    ["fontOutline"] = "OUTLINE",
                                    ["height"] = 5,
                                    ["hideInCombat"] = false,
                                    ["fontSize"] = 8
                                },
                                ["azerite"] = {
                                    ["height"] = 5
                                },
                                ["customTexture"] = true,
                                ["colors"] = {
                                    ["experience"] = {
                                        ["a"] = 0.800000011920929,
                                        ["b"] = 0.9294117647058824,
                                        ["g"] = 0.4941176470588236,
                                        ["r"] = 0.07450980392156863
                                    },
                                    ["quest"] = {
                                        ["a"] = 0.5965439975261688,
                                        ["b"] = 0.5568627450980392,
                                        ["r"] = 0.192156862745098
                                    }
                                },
                                ["transparent"] = false
                            },
                            ["general"] = {
                                ["decimalLength"] = 0,
                                ["backdropfadecolor"] = {
                                    ["a"] = 0.75,
                                    ["r"] = 0.04705882352941176,
                                    ["g"] = 0.04705882352941176,
                                    ["b"] = 0.04705882352941176
                                },
                                ["valuecolor"] = {
                                    ["a"] = 1,
                                    ["r"] = 0.05882352941176471,
                                    ["g"] = 0.6784313725490196,
                                    ["b"] = 1
                                },
                                ["loginmessage"] = false,
                                ["itemLevel"] = {
                                    ["displayInspectInfo"] = false,
                                    ["itemLevelFontSize"] = 14
                                },
                                ["altPowerBar"] = {
                                    ["smoothbars"] = true,
                                    ["statusBarColorGradient"] = true
                                },
                                ["fontSize"] = 13,
                                ["autoAcceptInvite"] = true,
                                ["autoRepair"] = "PLAYER",
                                ["minimap"] = {
                                    ["icons"] = {
                                        ["lfgEye"] = {
                                            ["position"] = "BOTTOMLEFT",
                                            ["yOffset"] = -2
                                        },
                                        ["mail"] = {
                                            ["yOffset"] = -60
                                        },
                                        ["classHall"] = {
                                            ["position"] = "TOPRIGHT",
                                            ["yOffset"] = -30
                                        }
                                    },
                                    ["size"] = 220
                                },
                                ["talkingHeadFrameBackdrop"] = true,
                                ["bottomPanel"] = false,
                                ["numberPrefixStyle"] = "TCHINESE",
                                ["autoTrackReputation"] = true,
                                ["backdropcolor"] = {
                                    ["a"] = 1,
                                    ["r"] = 0.1176470588235294,
                                    ["g"] = 0.1176470588235294,
                                    ["b"] = 0.1176470588235294
                                },
                                ["totems"] = {
                                    ["growthDirection"] = "HORIZONTAL",
                                    ["size"] = 35
                                },
                                ["bonusObjectivePosition"] = "RIGHT",
                                ["resurrectSound"] = true,
                                ["stickyFrames"] = false,
                                ["objectiveFrameAutoHideInKeystone"] = true,
                                ["bordercolor"] = {
                                    ["a"] = 1
                                }
                            },
                            ["v11NamePlateReset"] = true,
                            ["chat"] = {
                                ["tabFontOutline"] = "OUTLINE",
                                ["keywordSound"] = "OnePlus Surprise",
                                ["fontOutline"] = "OUTLINE",
                                ["socialQueueMessages"] = true,
                                ["customTimeColor"] = {
                                    ["r"] = 1,
                                    ["g"] = 0.7647058823529411,
                                    ["b"] = 0.3803921568627451
                                },
                                ["channelAlerts"] = {
                                    ["WHISPER"] = "OnePlus Light"
                                },
                                ["hideChatToggles"] = true,
                                ["fontSize"] = 13,
                                ["tabFontSize"] = 13,
                                ["panelBackdrop"] = "HIDEBOTH",
                                ["maxLines"] = 2000,
                                ["keywords"] = "%MYNAME%",
                                ["timeStampFormat"] = "%H:%M ",
                                ["tabSelector"] = "NONE",
                                ["hideVoiceButtons"] = true
                            },
                            ["WT"] = {
                                ["misc"] = {
                                    ["noKanjiMath"] = true,
                                    ["gameBar"] = {
                                        ["home"] = {
                                            ["left"] = "172179"
                                        }
                                    }
                                },
                                ["maps"] = {
                                    ["rectangleMinimap"] = {
                                        ["enable"] = true
                                    }
                                },
                                ["tooltips"] = {
                                    ["yOffsetOfHealthText"] = -7,
                                    ["yOffsetOfHealthBar"] = 5
                                },
                                ["unitFrames"] = {
                                    ["castBar"] = {
                                        ["enable"] = true,
                                        ["player"] = {
                                            ["enable"] = true,
                                            ["text"] = {
                                                ["font"] = {
                                                    ["size"] = 13
                                                },
                                                ["offsetX"] = 6
                                            },
                                            ["time"] = {
                                                ["font"] = {
                                                    ["size"] = 13
                                                },
                                                ["offsetX"] = -5
                                            }
                                        }
                                    }
                                },
                                ["item"] = {
                                    ["extraItemsBar"] = {
                                        ["bar2"] = {
                                            ["buttonsPerRow"] = 10,
                                            ["numButtons"] = 10
                                        },
                                        ["bar1"] = {
                                            ["buttonsPerRow"] = 10,
                                            ["numButtons"] = 10
                                        }
                                    }
                                },
                                ["skins"] = {
                                    ["vignetting"] = {
                                        ["level"] = 38
                                    }
                                },
                                ["quest"] = {
                                    ["turnIn"] = {
                                        ["enable"] = false
                                    }
                                }
                            },
                            ["movers"] = {
                                ["WTRaidMarkersBarAnchor"] = "TOP,ElvUIParent,TOP,0,-85",
                                ["ThreatBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,9",
                                ["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,14,131",
                                ["ElvUF_RaidMover"] = "RIGHT,ElvUIParent,CENTER,-200,100",
                                ["LeftChatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,44,35",
                                ["GMMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,44,224",
                                ["BuffsMover"] = "TOPRIGHT,MinimapMover,TOPLEFT,-10,0",
                                ["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,161",
                                ["LootFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,221,97",
                                ["ZoneAbility"] = "BOTTOM,ElvUIParent,BOTTOM,-321,33",
                                ["SocialMenuMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,16,127",
                                ["WTMinimapButtonBarAnchor"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-225",
                                ["ElvUF_FocusMover"] = "TOP,ElvUIParent,TOP,341,-502",
                                ["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,317",
                                ["DurabilityFrameMover"] = "TOPLEFT,ElvUF_PlayerMover,BOTTOMLEFT,0,-200",
                                ["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,300,300",
                                ["VehicleSeatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-467,52",
                                ["WTChatBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,45,25",
                                ["ExperienceBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-211",
                                ["ElvUF_PetMover"] = "TOPRIGHT,ElvUF_PlayerMover,TOPLEFT,-5,0",
                                ["ElvUF_TargetTargetMover"] = "TOPLEFT,ElvUF_TargetMover,TOPRIGHT,5,0",
                                ["ElvUF_PartyMover"] = "RIGHT,ElvUIParent,CENTER,-300,100",
                                ["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-300,300",
                                ["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,300",
                                ["MirrorTimer1Mover"] = "TOP,ElvUIParent,TOP,0,-116",
                                ["AltPowerBarMover"] = "TOP,ElvUIParent,TOP,6,-164",
                                ["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,-72,62",
                                ["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,-72,26",
                                ["BelowMinimapContainerMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-36,-276",
                                ["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,216,26",
                                ["TalkingHeadFrameMover"] = "TOP,ElvUIParent,TOP,0,-180",
                                ["ReputationBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-204",
                                ["AzeriteBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-218",
                                ["WTExtraItemsBar3Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-63,281",
                                ["ElvAB_5"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-711,123",
                                ["VehicleLeaveButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,420",
                                ["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,14,382",
                                ["WTParagonReputationToastFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,203",
                                ["ObjectiveFrameMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,121,-25",
                                ["BNETMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,44,224",
                                ["ShiftAB"] = "BOTTOMLEFT,ElvAB_1,TOPLEFT,0,5",
                                ["VOICECHAT"] = "TOPLEFT,ElvUIParent,TOPLEFT,336,-26",
                                ["HonorBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-625,-212",
                                ["ElvAB_6"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-621,217",
                                ["ArenaHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-215,366",
                                ["WTExtraItemsBar1Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-74,210",
                                ["BossHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-240,360",
                                ["TotemBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-334,255",
                                ["ElvAB_4"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-25,337",
                                ["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-45,25",
                                ["AlertFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,180",
                                ["DebuffsMover"] = "TOP,ElvUIParent,TOP,144,-397",
                                ["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-25"
                            },
                            ["tooltip"] = {
                                ["headerFontSize"] = 15,
                                ["fontOutline"] = "OUTLINE",
                                ["cursorAnchorType"] = "ANCHOR_CURSOR_RIGHT",
                                ["healthBar"] = {
                                    ["statusPosition"] = "TOP",
                                    ["fontSize"] = 15
                                },
                                ["colorAlpha"] = 0.75,
                                ["textFontSize"] = 13,
                                ["itemCount"] = "BOTH",
                                ["fontSize"] = 13,
                                ["smallTextFontSize"] = 13
                            },
                            ["unitframe"] = {
                                ["fontSize"] = 12,
                                ["statusbar"] = "WindTools Glow",
                                ["units"] = {
                                    ["targettarget"] = {
                                        ["debuffs"] = {
                                            ["yOffset"] = 20,
                                            ["anchorPoint"] = "TOPRIGHT",
                                            ["perrow"] = 4,
                                            ["attachTo"] = "FRAME"
                                        },
                                        ["name"] = {
                                            ["text_format"] = ""
                                        },
                                        ["cutaway"] = {
                                            ["health"] = {
                                                ["enabled"] = true,
                                                ["fadeOutTime"] = 0.3,
                                                ["lengthBeforeFade"] = 0.1
                                            },
                                            ["power"] = {
                                                ["enabled"] = true,
                                                ["fadeOutTime"] = 0.3,
                                                ["lengthBeforeFade"] = 0.1
                                            }
                                        },
                                        ["power"] = {
                                            ["height"] = 4
                                        },
                                        ["customTexts"] = {
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["yOffset"] = 25,
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = 3,
                                                ["enable"] = true,
                                                ["text_format"] = "[name]",
                                                ["size"] = 12
                                            },
                                            ["Wind Power"] = {
                                                ["attachTextTo"] = "Health",
                                                ["enable"] = true,
                                                ["text_format"] = "[mouseover][power:percent-nosign]",
                                                ["yOffset"] = -14,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = -2,
                                                ["size"] = 16
                                            },
                                            ["Wind Health"] = {
                                                ["attachTextTo"] = "Health",
                                                ["enable"] = true,
                                                ["text_format"] = "[health:percent-nostatus] || [curhp]",
                                                ["yOffset"] = -27,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "LEFT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = -2,
                                                ["size"] = 16
                                            }
                                        },
                                        ["width"] = 100,
                                        ["height"] = 30
                                    },
                                    ["pet"] = {
                                        ["debuffs"] = {
                                            ["countFontSize"] = 15,
                                            ["enable"] = true,
                                            ["yOffset"] = 80,
                                            ["anchorPoint"] = "TOPLEFT",
                                            ["spacing"] = 3,
                                            ["priority"] = "Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable",
                                            ["countFont"] = "Montserrat Bold",
                                            ["perrow"] = 4,
                                            ["attachTo"] = "BUFFS"
                                        },
                                        ["raidRoleIcons"] = {
                                            ["enable"] = true,
                                            ["yOffset"] = 0,
                                            ["xOffset"] = 0,
                                            ["position"] = "TOPLEFT"
                                        },
                                        ["pvpIcon"] = {
                                            ["anchorPoint"] = "CENTER",
                                            ["xOffset"] = 0,
                                            ["enable"] = false,
                                            ["scale"] = 1,
                                            ["yOffset"] = 0
                                        },
                                        ["resurrectIcon"] = {
                                            ["attachTo"] = "CENTER",
                                            ["yOffset"] = 0,
                                            ["enable"] = true,
                                            ["xOffset"] = 0,
                                            ["attachToObject"] = "Frame",
                                            ["size"] = 30
                                        },
                                        ["phaseIndicator"] = {
                                            ["anchorPoint"] = "CENTER",
                                            ["xOffset"] = 0,
                                            ["enable"] = true,
                                            ["scale"] = 0.8,
                                            ["yOffset"] = 0
                                        },
                                        ["CombatIcon"] = {
                                            ["anchorPoint"] = "CENTER",
                                            ["yOffset"] = 0,
                                            ["size"] = 20,
                                            ["xOffset"] = 0,
                                            ["color"] = {
                                                ["a"] = 1,
                                                ["r"] = 1,
                                                ["g"] = 0.2,
                                                ["b"] = 0.2
                                            },
                                            ["enable"] = true,
                                            ["defaultColor"] = true,
                                            ["texture"] = "DEFAULT"
                                        },
                                        ["aurabar"] = {
                                            ["yOffset"] = 0,
                                            ["attachTo"] = "DEBUFFS",
                                            ["spacing"] = 0,
                                            ["detachedWidth"] = 270,
                                            ["priority"] = "Blacklist,blockNoDuration,Personal,Boss,RaidDebuffs,PlayerBuffs"
                                        },
                                        ["cutaway"] = {
                                            ["health"] = {
                                                ["enabled"] = true,
                                                ["fadeOutTime"] = 0.3,
                                                ["lengthBeforeFade"] = 0.1
                                            }
                                        },
                                        ["castbar"] = {
                                            ["iconAttachedTo"] = "Castbar",
                                            ["iconSize"] = 27,
                                            ["icon"] = false,
                                            ["iconAttached"] = false,
                                            ["width"] = 100,
                                            ["displayTarget"] = true,
                                            ["height"] = 20,
                                            ["timeToHold"] = 0.4,
                                            ["textColor"] = {
                                                ["b"] = 1,
                                                ["g"] = 1,
                                                ["r"] = 1
                                            }
                                        },
                                        ["customTexts"] = {
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["yOffset"] = 27,
                                                ["justifyH"] = "LEFT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = -2,
                                                ["enable"] = true,
                                                ["text_format"] = "[name]",
                                                ["size"] = 12
                                            },
                                            ["Wind Power"] = {
                                                ["attachTextTo"] = "Health",
                                                ["enable"] = true,
                                                ["text_format"] = "[mouseover][power:current-percent]",
                                                ["yOffset"] = -14,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "LEFT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = 2,
                                                ["size"] = 16
                                            },
                                            ["Wind Health"] = {
                                                ["attachTextTo"] = "Health",
                                                ["enable"] = true,
                                                ["text_format"] = "[curhp] || [health:percent-nostatus]",
                                                ["yOffset"] = -27,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = 3,
                                                ["size"] = 16
                                            }
                                        },
                                        ["width"] = 100,
                                        ["infoPanel"] = {
                                            ["height"] = 20
                                        },
                                        ["middleClickFocus"] = true,
                                        ["name"] = {
                                            ["text_format"] = ""
                                        },
                                        ["orientation"] = "RIGHT",
                                        ["height"] = 30,
                                        ["buffs"] = {
                                            ["yOffset"] = -80,
                                            ["anchorPoint"] = "TOPLEFT",
                                            ["spacing"] = 2,
                                            ["priority"] = "Blacklist,Personal,nonPersonal",
                                            ["perrow"] = 5,
                                            ["maxDuration"] = 0
                                        },
                                        ["power"] = {
                                            ["height"] = 4
                                        },
                                        ["raidicon"] = {
                                            ["attachTo"] = "TOP",
                                            ["size"] = 18,
                                            ["enable"] = true,
                                            ["xOffset"] = 0,
                                            ["attachToObject"] = "Frame",
                                            ["yOffset"] = 8
                                        }
                                    },
                                    ["player"] = {
                                        ["debuffs"] = {
                                            ["enable"] = false
                                        },
                                        ["disableTargetGlow"] = false,
                                        ["customTexts"] = {
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["yOffset"] = 25,
                                                ["justifyH"] = "LEFT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = -2,
                                                ["enable"] = true,
                                                ["text_format"] = "[name]",
                                                ["size"] = 12
                                            },
                                            ["Wind Power"] = {
                                                ["attachTextTo"] = "Power",
                                                ["enable"] = true,
                                                ["text_format"] = "[power:current]",
                                                ["yOffset"] = 7,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "CENTER",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = 0,
                                                ["size"] = 22
                                            },
                                            ["Wind Health"] = {
                                                ["attachTextTo"] = "Health",
                                                ["enable"] = true,
                                                ["text_format"] = "[curhp] || [health:percent-nostatus]",
                                                ["yOffset"] = -27,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = 4,
                                                ["size"] = 16
                                            }
                                        },
                                        ["disableMouseoverGlow"] = true,
                                        ["infoPanel"] = {
                                            ["height"] = 14,
                                            ["transparent"] = true
                                        },
                                        ["height"] = 30,
                                        ["raidicon"] = {
                                            ["size"] = 19
                                        },
                                        ["disableFocusGlow"] = false,
                                        ["aurabar"] = {
                                            ["enable"] = false
                                        },
                                        ["RestIcon"] = {
                                            ["anchorPoint"] = "BOTTOMLEFT",
                                            ["yOffset"] = 13,
                                            ["size"] = 21,
                                            ["color"] = {
                                                ["g"] = 0.5568627450980392,
                                                ["r"] = 0.203921568627451
                                            },
                                            ["xOffset"] = 13,
                                            ["defaultColor"] = false,
                                            ["texture"] = "RESTING1"
                                        },
                                        ["pvp"] = {
                                            ["position"] = "RIGHT"
                                        },
                                        ["classbar"] = {
                                            ["detachFromFrame"] = true,
                                            ["height"] = 13
                                        },
                                        ["power"] = {
                                            ["text_format"] = "",
                                            ["detachFromFrame"] = true,
                                            ["height"] = 15
                                        },
                                        ["portrait"] = {
                                            ["overlay"] = true,
                                            ["camDistanceScale"] = 2.88,
                                            ["overlayAlpha"] = 0.2
                                        },
                                        ["width"] = 220,
                                        ["raidRoleIcons"] = {
                                            ["xOffset"] = 3,
                                            ["position"] = "TOPRIGHT"
                                        },
                                        ["fader"] = {
                                            ["enable"] = true,
                                            ["minAlpha"] = 0,
                                            ["vehicle"] = false
                                        },
                                        ["castbar"] = {
                                            ["xOffsetTime"] = 0,
                                            ["iconXOffset"] = -4,
                                            ["xOffsetText"] = 0,
                                            ["iconSize"] = 24,
                                            ["format"] = "REMAININGMAX",
                                            ["textColor"] = {
                                                ["b"] = 1,
                                                ["g"] = 1,
                                                ["r"] = 1
                                            },
                                            ["iconAttached"] = false,
                                            ["width"] = 257,
                                            ["displayTarget"] = true,
                                            ["height"] = 24,
                                            ["iconAttachedTo"] = "Castbar",
                                            ["latency"] = false
                                        },
                                        ["cutaway"] = {
                                            ["health"] = {
                                                ["enabled"] = true,
                                                ["fadeOutTime"] = 0.3,
                                                ["lengthBeforeFade"] = 0.1
                                            },
                                            ["power"] = {
                                                ["fadeOutTime"] = 0.3,
                                                ["lengthBeforeFade"] = 0.1
                                            }
                                        },
                                        ["health"] = {
                                            ["text_format"] = ""
                                        }
                                    },
                                    ["focus"] = {
                                        ["cutaway"] = {
                                            ["health"] = {
                                                ["enabled"] = true,
                                                ["fadeOutTime"] = 0.3,
                                                ["lengthBeforeFade"] = 0.1
                                            }
                                        },
                                        ["debuffs"] = {
                                            ["countFontSize"] = 15,
                                            ["yOffset"] = 80,
                                            ["anchorPoint"] = "TOPLEFT",
                                            ["spacing"] = 3,
                                            ["priority"] = "Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable",
                                            ["countFont"] = "Montserrat Bold",
                                            ["perrow"] = 4,
                                            ["attachTo"] = "BUFFS"
                                        },
                                        ["disableTargetGlow"] = true,
                                        ["raidRoleIcons"] = {
                                            ["enable"] = true,
                                            ["position"] = "TOPLEFT",
                                            ["xOffset"] = 0,
                                            ["yOffset"] = 0
                                        },
                                        ["resurrectIcon"] = {
                                            ["attachTo"] = "CENTER",
                                            ["size"] = 30,
                                            ["enable"] = true,
                                            ["xOffset"] = 0,
                                            ["attachToObject"] = "Frame",
                                            ["yOffset"] = 0
                                        },
                                        ["phaseIndicator"] = {
                                            ["anchorPoint"] = "CENTER",
                                            ["scale"] = 0.8,
                                            ["xOffset"] = 0,
                                            ["enable"] = true,
                                            ["yOffset"] = 0
                                        },
                                        ["aurabar"] = {
                                            ["maxBars"] = 6,
                                            ["detachedWidth"] = 270
                                        },
                                        ["middleClickFocus"] = true,
                                        ["pvpIcon"] = {
                                            ["anchorPoint"] = "CENTER",
                                            ["scale"] = 1,
                                            ["xOffset"] = 0,
                                            ["enable"] = false,
                                            ["yOffset"] = 0
                                        },
                                        ["customTexts"] = {
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["yOffset"] = 27,
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["xOffset"] = 4,
                                                ["text_format"] = "[name]",
                                                ["size"] = 12
                                            },
                                            ["Wind Power"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = -1,
                                                ["text_format"] = "[mouseover][power:current-percent]",
                                                ["yOffset"] = -14,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 16
                                            },
                                            ["Wind Health"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = -2,
                                                ["text_format"] = "[health:percent-nostatus] || [curhp]",
                                                ["yOffset"] = -27,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "LEFT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 16
                                            }
                                        },
                                        ["width"] = 138,
                                        ["infoPanel"] = {
                                            ["height"] = 20
                                        },
                                        ["power"] = {
                                            ["height"] = 4
                                        },
                                        ["name"] = {
                                            ["text_format"] = ""
                                        },
                                        ["height"] = 30,
                                        ["orientation"] = "RIGHT",
                                        ["buffs"] = {
                                            ["enable"] = true,
                                            ["yOffset"] = -80,
                                            ["anchorPoint"] = "TOPLEFT",
                                            ["spacing"] = 2,
                                            ["priority"] = "Blacklist,Personal,nonPersonal",
                                            ["perrow"] = 5,
                                            ["maxDuration"] = 0
                                        },
                                        ["castbar"] = {
                                            ["iconAttachedTo"] = "Castbar",
                                            ["iconSize"] = 27,
                                            ["icon"] = false,
                                            ["iconAttached"] = false,
                                            ["width"] = 138,
                                            ["displayTarget"] = true,
                                            ["height"] = 20,
                                            ["timeToHold"] = 0.4,
                                            ["textColor"] = {
                                                ["b"] = 1,
                                                ["g"] = 1,
                                                ["r"] = 1
                                            }
                                        }
                                    },
                                    ["target"] = {
                                        ["debuffs"] = {
                                            ["countFontSize"] = 15,
                                            ["yOffset"] = 80,
                                            ["anchorPoint"] = "TOPLEFT",
                                            ["spacing"] = 3,
                                            ["countFont"] = "Montserrat Bold",
                                            ["perrow"] = 6
                                        },
                                        ["health"] = {
                                            ["text_format"] = ""
                                        },
                                        ["raidRoleIcons"] = {
                                            ["xOffset"] = 3
                                        },
                                        ["aurabar"] = {
                                            ["enable"] = false
                                        },
                                        ["cutaway"] = {
                                            ["health"] = {
                                                ["enabled"] = true,
                                                ["fadeOutTime"] = 0.3,
                                                ["lengthBeforeFade"] = 0.1
                                            }
                                        },
                                        ["castbar"] = {
                                            ["iconAttachedTo"] = "Castbar",
                                            ["iconXOffset"] = -4,
                                            ["iconSize"] = 24,
                                            ["format"] = "REMAININGMAX",
                                            ["iconAttached"] = false,
                                            ["width"] = 310,
                                            ["displayTarget"] = true,
                                            ["height"] = 24,
                                            ["timeToHold"] = 0.4,
                                            ["textColor"] = {
                                                ["b"] = 1,
                                                ["g"] = 1,
                                                ["r"] = 1
                                            }
                                        },
                                        ["customTexts"] = {
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["yOffset"] = 25,
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = 3,
                                                ["enable"] = true,
                                                ["text_format"] = "[name]",
                                                ["size"] = 12
                                            },
                                            ["Wind Power"] = {
                                                ["attachTextTo"] = "Health",
                                                ["enable"] = true,
                                                ["text_format"] = "[mouseover][power:percent-nosign]",
                                                ["yOffset"] = -14,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = -2,
                                                ["size"] = 16
                                            },
                                            ["Wind Health"] = {
                                                ["attachTextTo"] = "Health",
                                                ["enable"] = true,
                                                ["text_format"] = "[health:percent-nostatus] || [curhp]",
                                                ["yOffset"] = -27,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "LEFT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = -2,
                                                ["size"] = 16
                                            }
                                        },
                                        ["width"] = 220,
                                        ["power"] = {
                                            ["text_format"] = "",
                                            ["height"] = 4
                                        },
                                        ["name"] = {
                                            ["text_format"] = ""
                                        },
                                        ["height"] = 30,
                                        ["buffs"] = {
                                            ["yOffset"] = -80,
                                            ["anchorPoint"] = "TOPLEFT",
                                            ["spacing"] = 2
                                        }
                                    },
                                    ["raid"] = {
                                        ["portrait"] = {
                                            ["fullOverlay"] = true
                                        },
                                        ["customTexts"] = {
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["yOffset"] = -11,
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = 1,
                                                ["enable"] = true,
                                                ["text_format"] = "[namecolor][name:short]",
                                                ["size"] = 10
                                            }
                                        },
                                        ["name"] = {
                                            ["text_format"] = ""
                                        },
                                        ["height"] = 40,
                                        ["rdebuffs"] = {
                                            ["xOffset"] = 23,
                                            ["yOffset"] = 14,
                                            ["font"] = "Montserrat",
                                            ["fontOutline"] = "OUTLINE",
                                            ["size"] = 25
                                        },
                                        ["roleIcon"] = {
                                            ["yOffset"] = -2,
                                            ["position"] = "TOPLEFT",
                                            ["xOffset"] = 2
                                        },
                                        ["power"] = {
                                            ["height"] = 4
                                        },
                                        ["summonIcon"] = {
                                            ["attachTo"] = "TOPRIGHT"
                                        },
                                        ["width"] = 72
                                    },
                                    ["boss"] = {
                                        ["debuffs"] = {
                                            ["sizeOverride"] = 30,
                                            ["yOffset"] = 0,
                                            ["spacing"] = 3,
                                            ["countFont"] = "Montserrat",
                                            ["perrow"] = 4,
                                            ["xOffset"] = -5
                                        },
                                        ["spacing"] = 50,
                                        ["health"] = {
                                            ["text_format"] = ""
                                        },
                                        ["cutaway"] = {
                                            ["health"] = {
                                                ["enabled"] = true,
                                                ["fadeOutTime"] = 0.3,
                                                ["lengthBeforeFade"] = 0.2
                                            }
                                        },
                                        ["castbar"] = {
                                            ["width"] = 220,
                                            ["height"] = 24
                                        },
                                        ["customTexts"] = {
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["yOffset"] = 25,
                                                ["justifyH"] = "LEFT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = -1,
                                                ["enable"] = true,
                                                ["text_format"] = "[name]",
                                                ["size"] = 12
                                            },
                                            ["Wind Power"] = {
                                                ["attachTextTo"] = "Health",
                                                ["enable"] = true,
                                                ["text_format"] = "[mouseover][power:current-percent]",
                                                ["yOffset"] = -14,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = 0,
                                                ["size"] = 14
                                            },
                                            ["Wind Health"] = {
                                                ["attachTextTo"] = "Health",
                                                ["enable"] = true,
                                                ["text_format"] = "[health:percent-nostatus] || [health:current]",
                                                ["yOffset"] = 0,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = 0,
                                                ["size"] = 16
                                            }
                                        },
                                        ["width"] = 220,
                                        ["name"] = {
                                            ["text_format"] = ""
                                        },
                                        ["height"] = 30,
                                        ["buffs"] = {
                                            ["sizeOverride"] = 30,
                                            ["yOffset"] = 0,
                                            ["anchorPoint"] = "RIGHT",
                                            ["spacing"] = 3,
                                            ["countFont"] = "Montserrat",
                                            ["attachTo"] = "HEALTH",
                                            ["xOffset"] = 5
                                        },
                                        ["power"] = {
                                            ["text_format"] = "",
                                            ["height"] = 4
                                        }
                                    },
                                    ["party"] = {
                                        ["debuffs"] = {
                                            ["sizeOverride"] = 34,
                                            ["xOffset"] = 3,
                                            ["countFont"] = "Montserrat",
                                            ["perrow"] = 5
                                        },
                                        ["customTexts"] = {
                                            ["Wind Health Percent"] = {
                                                ["attachTextTo"] = "Health",
                                                ["enable"] = true,
                                                ["text_format"] = "[health:percent-nostatus-nosign]",
                                                ["yOffset"] = 0,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = -2,
                                                ["size"] = 22
                                            },
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["yOffset"] = 1,
                                                ["justifyH"] = "LEFT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = 22,
                                                ["enable"] = true,
                                                ["text_format"] = "[namecolor][name] [smartlevel]",
                                                ["size"] = 12
                                            },
                                            ["Wind Power"] = {
                                                ["attachTextTo"] = "Health",
                                                ["enable"] = true,
                                                ["text_format"] = "[mouseover][power:percent-nosign]",
                                                ["yOffset"] = -16,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = -2,
                                                ["size"] = 13
                                            }
                                        },
                                        ["name"] = {
                                            ["text_format"] = ""
                                        },
                                        ["height"] = 35,
                                        ["verticalSpacing"] = 5,
                                        ["rdebuffs"] = {
                                            ["xOffset"] = 28,
                                            ["yOffset"] = 6,
                                            ["font"] = "Montserrat",
                                            ["fontOutline"] = "OUTLINE"
                                        },
                                        ["raidRoleIcons"] = {
                                            ["xOffset"] = 3
                                        },
                                        ["growthDirection"] = "DOWN_RIGHT",
                                        ["disableFocusGlow"] = true,
                                        ["groupBy"] = "ROLE2",
                                        ["cutaway"] = {
                                            ["health"] = {
                                                ["enabled"] = true
                                            }
                                        },
                                        ["roleIcon"] = {
                                            ["yOffset"] = 0,
                                            ["position"] = "LEFT",
                                            ["xOffset"] = 5
                                        },
                                        ["castbar"] = {
                                            ["width"] = 154
                                        },
                                        ["summonIcon"] = {
                                            ["attachTo"] = "RIGHT",
                                            ["xOffset"] = -20
                                        },
                                        ["width"] = 154,
                                        ["health"] = {
                                            ["text_format"] = ""
                                        },
                                        ["power"] = {
                                            ["text_format"] = "",
                                            ["height"] = 4,
                                            ["hideonnpc"] = true
                                        },
                                        ["buffs"] = {
                                            ["sizeOverride"] = 34,
                                            ["enable"] = true,
                                            ["countFont"] = "Montserrat",
                                            ["perrow"] = 3,
                                            ["xOffset"] = -3
                                        }
                                    }
                                },
                                ["smoothbars"] = true,
                                ["colors"] = {
                                    ["customhealthbackdrop"] = true,
                                    ["borderColor"] = {
                                        ["a"] = 1
                                    },
                                    ["healthMultiplier"] = 0.75,
                                    ["colorhealthbyvalue"] = false,
                                    ["health_backdrop"] = {
                                        ["r"] = 0.5137254901960784,
                                        ["g"] = 0.5137254901960784,
                                        ["b"] = 0.5137254901960784
                                    },
                                    ["power"] = {
                                        ["MANA"] = {
                                            ["r"] = 0.3098039215686275,
                                            ["g"] = 0.4509803921568628,
                                            ["b"] = 0.6313725490196078
                                        },
                                        ["RUNIC_POWER"] = {
                                            ["g"] = 0.8196078431372549
                                        },
                                        ["MAELSTROM"] = {
                                            ["r"] = 0.2156862745098039,
                                            ["g"] = 0.2588235294117647,
                                            ["b"] = 0.9803921568627451
                                        },
                                        ["ENERGY"] = {
                                            ["r"] = 0.6509803921568628,
                                            ["g"] = 0.6313725490196078,
                                            ["b"] = 0.3490196078431372
                                        }
                                    },
                                    ["castColor"] = {
                                        ["a"] = 1,
                                        ["r"] = 0.2588235294117647,
                                        ["g"] = 0.7098039215686275,
                                        ["b"] = 1
                                    },
                                    ["frameGlow"] = {
                                        ["targetGlow"] = {
                                            ["enable"] = false
                                        },
                                        ["mouseoverGlow"] = {
                                            ["color"] = {
                                                ["a"] = 0.1000000238418579,
                                                ["r"] = 0.4470588235294117,
                                                ["g"] = 0.4470588235294117,
                                                ["b"] = 0.4470588235294117
                                            }
                                        }
                                    },
                                    ["castNoInterrupt"] = {
                                        ["a"] = 1,
                                        ["r"] = 1,
                                        ["g"] = 0.3882352941176471,
                                        ["b"] = 0.4941176470588236
                                    },
                                    ["health"] = {
                                        ["r"] = 0.1333333333333333,
                                        ["g"] = 0.1333333333333333,
                                        ["b"] = 0.1333333333333333
                                    },
                                    ["powerclass"] = true,
                                    ["transparentHealth"] = true
                                },
                                ["fontOutline"] = "OUTLINE",
                                ["cooldown"] = {
                                    ["fonts"] = {
                                        ["enable"] = true,
                                        ["font"] = "Oswald",
                                        ["fontSize"] = 17
                                    }
                                }
                            },
                            ["datatexts"] = {
                                ["panels"] = {
                                    ["MinimapPanel"] = {
                                        ["enable"] = false
                                    },
                                    ["RightChatDataPanel"] = {
                                        ["enable"] = false
                                    },
                                    ["LeftChatDataPanel"] = {
                                        ["enable"] = false
                                    }
                                }
                            },
                            ["actionbar"] = {
                                ["bar3"] = {
                                    ["buttonspacing"] = 4,
                                    ["buttons"] = 8,
                                    ["buttonsPerRow"] = 4
                                },
                                ["fontOutline"] = "OUTLINE",
                                ["bar1"] = {
                                    ["buttonspacing"] = 4
                                },
                                ["transparent"] = true,
                                ["font"] = "Montserrat",
                                ["hotkeyTextYOffset"] = -2,
                                ["rightClickSelfCast"] = true,
                                ["barPet"] = {
                                    ["buttonspacing"] = 4,
                                    ["backdrop"] = false,
                                    ["inheritGlobalFade"] = true,
                                    ["buttonsize"] = 37
                                },
                                ["globalFadeAlpha"] = 0.7000000000000001,
                                ["microbar"] = {
                                    ["buttonSpacing"] = 4
                                },
                                ["hideCooldownBling"] = true,
                                ["bar2"] = {
                                    ["buttonspacing"] = 4,
                                    ["enabled"] = true
                                },
                                ["bar5"] = {
                                    ["enabled"] = false
                                },
                                ["zoneActionButton"] = {
                                    ["clean"] = true
                                },
                                ["stanceBar"] = {
                                    ["buttonspacing"] = 4,
                                    ["buttonsize"] = 24
                                },
                                ["bar4"] = {
                                    ["inheritGlobalFade"] = true,
                                    ["backdrop"] = false
                                }
                            },
                            ["nameplates"] = {
                                ["statusbar"] = "WindTools Glow",
                                ["cutaway"] = {
                                    ["health"] = {
                                        ["enabled"] = true,
                                        ["fadeOutTime"] = 0.3,
                                        ["lengthBeforeFade"] = 0.2
                                    }
                                },
                                ["units"] = {
                                    ["TARGET"] = {
                                        ["glowStyle"] = "style7"
                                    },
                                    ["PLAYER"] = {
                                        ["buffs"] = {
                                            ["countFont"] = "Montserrat Bold"
                                        }
                                    }
                                },
                                ["smoothbars"] = true
                            },
                            ["bags"] = {
                                ["itemLevelFont"] = "Montserrat",
                                ["currencyFormat"] = "ICON",
                                ["itemLevelFontOutline"] = "OUTLINE",
                                ["useBlizzardCleanup"] = true,
                                ["junkDesaturate"] = true,
                                ["countFont"] = "Montserrat",
                                ["clearSearchOnClose"] = true,
                                ["countFontOutline"] = "OUTLINE",
                                ["vendorGrays"] = {
                                    ["enable"] = true
                                },
                                ["transparent"] = true,
                                ["showBindType"] = true,
                                ["moneyFormat"] = "SHORTINT"
                            },
                            ["cooldown"] = {
                                ["fonts"] = {
                                    ["enable"] = true,
                                    ["font"] = "Accidental Presidency",
                                    ["fontSize"] = 27
                                }
                            },
                            ["auras"] = {
                                ["debuffs"] = {
                                    ["countFontSize"] = 18,
                                    ["durationFontSize"] = 18,
                                    ["size"] = 42
                                },
                                ["timeYOffset"] = 6,
                                ["fontOutline"] = "OUTLINE",
                                ["countYOffset"] = 24,
                                ["font"] = "Roadway",
                                ["buffs"] = {
                                    ["countFontSize"] = 19,
                                    ["durationFontSize"] = 14,
                                    ["size"] = 36
                                }
                            }
                        }

                        local E, _, _, P = unpack(_G.ElvUI)
                        E:CopyTable(E.db, P)
                        E:CopyTable(E.db, WindUI)
                        E:StaggeredUpdateAll()
                    end
                },
                characterProfile = {
                    order = 2,
                    type = "execute",
                    name = L["Character Profile"],
                    desc = "|cffff0000" .. L["Set the profile to WindTools style."],
                    func = function()
                        E.private["general"]["chatBubbleFontOutline"] = "OUTLINE"
                        E.private["general"]["normTex"] = "WindTools Glow"
                        E.private["general"]["glossTex"] = "WindTools Flat"
                        E.private["general"]["minimap"]["hideCalendar"] = false
                        E.private["WT"]["misc"]["mute"]["enable"] = true
                        E.private["WT"]["misc"]["mute"]["mount"][63796] = true
                        E.private["WT"]["misc"]["mute"]["mount"][229385] = true
                        E.private["WT"]["skins"]["elvui"]["chatPanels"] = false
                        E.private["WT"]["maps"]["minimapButtons"]["spacing"] = 0
                        E.private["WT"]["maps"]["minimapButtons"]["buttonsPerRow"] = 7
                        E.private["WT"]["maps"]["minimapButtons"]["backdropSpacing"] = 0
                        E.private["WT"]["maps"]["minimapButtons"]["calendar"] = true
                        E.private["WT"]["maps"]["worldMap"]["scale"]["size"] = 1.55
                        E.private["skins"]["parchmentRemoverEnable"] = true
                        E.private["nameplates"]["enable"] = false
                        E.private["theme"] = "default"
                        E:StaticPopup_Show("PRIVATE_RL")
                    end
                }
            }
        },
        announcement = {
            order = 1,
            type = "group",
            inline = true,
            name = AddColor(L["Announcement"]),
            args = {
                combatResurrection = {
                    order = 1,
                    type = "execute",
                    name = L["Combat Resurrection"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Combat Resurrection"],
                            nil,
                            function()
                                E.db.WT.announcement.combatResurrection = P.announcement.combatResurrection
                            end
                        )
                    end
                },
                goodbye = {
                    order = 2,
                    type = "execute",
                    name = L["Goodbye"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Goodbye"],
                            nil,
                            function()
                                E.db.WT.announcement.goodbye = P.announcement.goodbye
                            end
                        )
                    end
                },
                interrupt = {
                    order = 3,
                    type = "execute",
                    name = L["Interrupt"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Interrupt"],
                            nil,
                            function()
                                E.db.WT.announcement.interrupt = P.announcement.interrupt
                            end
                        )
                    end
                },
                quest = {
                    order = 4,
                    type = "execute",
                    name = L["Quest"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Quest"],
                            nil,
                            function()
                                E.db.WT.announcement.quest = P.announcement.quest
                            end
                        )
                    end
                },
                resetInstance = {
                    order = 4,
                    type = "execute",
                    name = L["Reset Instance"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Reset Instance"],
                            nil,
                            function()
                                E.db.WT.announcement.resetInstance = P.announcement.resetInstance
                            end
                        )
                    end
                },
                taunt = {
                    order = 5,
                    type = "execute",
                    name = L["Taunt"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Taunt"],
                            nil,
                            function()
                                E.db.WT.announcement.taunt = P.announcement.taunt
                            end
                        )
                    end
                },
                thanksForResurrection = {
                    order = 6,
                    type = "execute",
                    name = L["Thanks For Resurrection"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Thanks For Resurrection"],
                            nil,
                            function()
                                E.db.WT.announcement.thanksForResurrection = P.announcement.thanksForResurrection
                            end
                        )
                    end
                },
                threatTransfer = {
                    order = 7,
                    type = "execute",
                    name = L["Threat Transfer"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Threat Transfer"],
                            nil,
                            function()
                                E.db.WT.announcement.threatTransfer = P.announcement.threatTransfer
                            end
                        )
                    end
                },
                utility = {
                    order = 8,
                    type = "execute",
                    name = L["Utility"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Utility"],
                            nil,
                            function()
                                E.db.WT.announcement.utility = P.announcement.utility
                            end
                        )
                    end
                }
            }
        },
        combat = {
            order = 2,
            type = "group",
            inline = true,
            name = AddColor(L["Combat"]),
            args = {
                combatAlert = {
                    order = 1,
                    type = "execute",
                    name = L["Combat Alert"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Combat Alert"],
                            nil,
                            function()
                                E.db.WT.combat.combatAlert = P.combat.combatAlert
                            end
                        )
                    end
                },
                raidMarkers = {
                    order = 2,
                    type = "execute",
                    name = L["Raid Markers"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Raid Markers"],
                            nil,
                            function()
                                E.db.WT.combat.raidMarkers = P.combat.raidMarkers
                            end
                        )
                    end
                },
                talentManager = {
                    order = 3,
                    type = "execute",
                    name = L["Talent Manager"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Talent Manager"],
                            nil,
                            function()
                                E.private.WT.combat.talentManager = V.combat.talentManager
                            end
                        )
                    end
                }
            }
        },
        item = {
            order = 3,
            type = "group",
            inline = true,
            name = AddColor(L["Item"]),
            args = {
                alreadyKnown = {
                    order = 1,
                    type = "execute",
                    name = L["Already Known"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Already Known"],
                            nil,
                            function()
                                E.db.WT.item.alreadyKnown = P.item.alreadyKnown
                            end
                        )
                    end
                },
                delete = {
                    order = 2,
                    type = "execute",
                    name = L["Delete Item"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Delete Item"],
                            nil,
                            function()
                                E.db.WT.item.delete = P.item.delete
                            end
                        )
                    end
                },
                fastLoot = {
                    order = 3,
                    type = "execute",
                    name = L["Fast Loot"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Fast Loot"],
                            nil,
                            function()
                                E.db.WT.item.fastLoot = P.item.fastLoot
                            end
                        )
                    end
                },
                trade = {
                    order = 4,
                    type = "execute",
                    name = L["Trade"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Trade"],
                            nil,
                            function()
                                E.db.WT.item.trade = P.item.trade
                            end
                        )
                    end
                },
                extraItemsBar = {
                    order = 5,
                    type = "execute",
                    name = L["Extra Items Bar"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Extra Items Bar"],
                            nil,
                            function()
                                E.db.WT.item.extraItemsBar = P.item.extraItemsBar
                            end
                        )
                    end
                }
            }
        },
        maps = {
            order = 4,
            type = "group",
            inline = true,
            name = AddColor(L["Maps"]),
            args = {
                minimapButtons = {
                    order = 1,
                    type = "execute",
                    name = L["Minimap Buttons"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Minimap Buttons"],
                            nil,
                            function()
                                E.private.WT.maps.minimapButtons = V.maps.minimapButtons
                            end
                        )
                    end
                },
                rectangleMinimap = {
                    order = 2,
                    type = "execute",
                    name = L["Rectangle Minimap"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Rectangle Minimap"],
                            nil,
                            function()
                                E.db.WT.maps.rectangleMinimap = P.maps.rectangleMinimap
                            end
                        )
                    end
                },
                whoClicked = {
                    order = 3,
                    type = "execute",
                    name = L["Who Clicked Minimap"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Who Clicked Minimap"],
                            nil,
                            function()
                                E.db.WT.maps.whoClicked = P.maps.whoClicked
                            end
                        )
                    end
                },
                worldMap = {
                    order = 4,
                    type = "execute",
                    name = L["World Map"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["World Map"],
                            nil,
                            function()
                                E.private.WT.maps.worldMap = V.maps.worldMap
                            end
                        )
                    end
                }
            }
        },
        quest = {
            order = 5,
            type = "group",
            inline = true,
            name = AddColor(L["Quest"]),
            args = {
                objectiveTracker = {
                    order = 1,
                    type = "execute",
                    name = L["Objective Tracker"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Objective Tracker"],
                            nil,
                            function()
                                E.private.WT.quest.objectiveTracker = V.quest.objectiveTracker
                            end
                        )
                    end
                },
                paragonReputation = {
                    order = 2,
                    type = "execute",
                    name = L["Paragon Reputation"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Paragon Reputation"],
                            nil,
                            function()
                                E.db.WT.quest.paragonReputation = P.quest.paragonReputation
                            end
                        )
                    end
                },
                switchButtons = {
                    order = 3,
                    type = "execute",
                    name = L["Switch Buttons"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Switch Buttons"],
                            nil,
                            function()
                                E.db.WT.quest.switchButtons = P.quest.switchButtons
                            end
                        )
                    end
                },
                turnIn = {
                    order = 4,
                    type = "execute",
                    name = L["Turn In"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Turn In"],
                            nil,
                            function()
                                E.db.WT.quest.turnIn = P.quest.turnIn
                            end
                        )
                    end
                }
            }
        },
        social = {
            order = 6,
            type = "group",
            inline = true,
            name = AddColor(L["Social"]),
            args = {
                chatBar = {
                    order = 1,
                    type = "execute",
                    name = L["Chat Bar"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Chat Bar"],
                            nil,
                            function()
                                E.db.WT.social.chatBar = P.social.chatBar
                            end
                        )
                    end
                },
                chatLink = {
                    order = 2,
                    type = "execute",
                    name = L["Chat Link"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Chat Link"],
                            nil,
                            function()
                                E.db.WT.social.chatLink = P.social.chatLink
                            end
                        )
                    end
                },
                chatText = {
                    order = 3,
                    type = "execute",
                    name = L["Chat Text"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Chat Text"],
                            nil,
                            function()
                                E.db.WT.social.chatText = P.social.chatText
                            end
                        )
                    end
                },
                contextMenu = {
                    order = 4,
                    type = "execute",
                    name = L["Context Menu"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Context Menu"],
                            nil,
                            function()
                                E.db.WT.social.contextMenu = P.social.contextMenu
                            end
                        )
                    end
                },
                emote = {
                    order = 5,
                    type = "execute",
                    name = L["Emote"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Emote"],
                            nil,
                            function()
                                E.db.WT.social.emote = P.social.emote
                            end
                        )
                    end
                },
                filter = {
                    order = 6,
                    type = "execute",
                    name = L["Filter"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Filter"],
                            nil,
                            function()
                                E.db.WT.social.filter = P.social.filter
                            end
                        )
                    end
                },
                friendList = {
                    order = 7,
                    type = "execute",
                    name = L["Friend List"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Friend List"],
                            nil,
                            function()
                                E.db.WT.social.friendList = P.social.friendList
                            end
                        )
                    end
                },
                smartTab = {
                    order = 8,
                    type = "execute",
                    name = L["Smart Tab"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Smart Tab"],
                            nil,
                            function()
                                E.db.WT.social.smartTab = P.social.smartTab
                            end
                        )
                    end
                }
            }
        },
        tooltips = {
            order = 7,
            type = "group",
            inline = true,
            name = AddColor(L["Tooltips"]),
            args = {
                general = {
                    order = 1,
                    type = "execute",
                    name = L["General"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["General"],
                            nil,
                            function()
                                E.private.WT.tooltips.icon = V.tooltips.icon
                                E.private.WT.tooltips.objectiveProgress = V.tooltips.objectiveProgress
                                E.db.WT.tooltips.yOffsetOfHealthBar = P.tooltips.yOffsetOfHealthBar
                                E.db.WT.tooltips.yOffsetOfHealthText = P.tooltips.yOffsetOfHealthText
                            end
                        )
                    end
                },
                progression = {
                    order = 2,
                    type = "execute",
                    name = L["Progression"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Progression"],
                            nil,
                            function()
                                E.private.WT.tooltips.progression = V.tooltips.progression
                            end
                        )
                    end
                },
                groupInfo = {
                    order = 3,
                    type = "execute",
                    name = L["Group Info"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Group Info"],
                            nil,
                            function()
                                E.db.WT.tooltips.groupInfo = P.tooltips.groupInfo
                            end
                        )
                    end
                }
            }
        },
        unitFrames = {
            order = 8,
            type = "group",
            inline = true,
            name = AddColor(L["UnitFrames"]),
            args = {
                quickFocus = {
                    order = 1,
                    type = "execute",
                    name = L["Quick Focus"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Quick Focus"],
                            nil,
                            function()
                                E.private.WT.unitFrames.quickFocus = V.unitFrames.quickFocus
                            end
                        )
                    end
                },
                roleIcon = {
                    order = 2,
                    type = "execute",
                    name = L["Role Icon"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Role Icon"],
                            nil,
                            function()
                                E.private.WT.unitFrames.roleIcon = V.unitFrames.roleIcon
                            end
                        )
                    end
                }
            }
        },
        skins = {
            order = 9,
            type = "group",
            inline = true,
            name = AddColor(L["Skins"]),
            args = {
                general = {
                    order = 2,
                    type = "execute",
                    name = L["General"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["General"],
                            nil,
                            function()
                                E.private.WT.skins.enable = V.skins.enable
                                E.private.WT.skins.windtools = V.skins.windtools
                                E.private.WT.skins.removeParchment = V.skins.removeParchment
                                E.private.WT.skins.color = V.skins.color
                            end
                        )
                    end
                },
                addons = {
                    order = 2,
                    type = "execute",
                    name = L["Addons"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Addons"],
                            nil,
                            function()
                                E.private.WT.skins.addons = V.skins.addons
                            end
                        )
                    end
                },
                blizzard = {
                    order = 3,
                    type = "execute",
                    name = L["Blizzard"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Blizzard"],
                            nil,
                            function()
                                E.private.WT.skins.blizzard = V.skins.blizzard
                            end
                        )
                    end
                },
                elvui = {
                    order = 3,
                    type = "execute",
                    name = L["ElvUI"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["ElvUI"],
                            nil,
                            function()
                                E.private.WT.skins.elvui = V.skins.elvui
                            end
                        )
                    end
                }
            }
        },
        misc = {
            order = 10,
            type = "group",
            inline = true,
            name = AddColor(L["Misc"]),
            args = {
                disableTalkingHead = {
                    order = 1,
                    type = "execute",
                    name = L["Disable Talking Head"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Disable Talking Head"],
                            nil,
                            function()
                                E.private.WT.misc.disableTalkingHead = V.misc.disableTalkingHead
                            end
                        )
                    end
                },
                transmog = {
                    order = 2,
                    type = "execute",
                    name = L["Transmog"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Transmog"],
                            nil,
                            function()
                                E.private.WT.misc.saveArtifact = V.misc.saveArtifact
                            end
                        )
                    end
                },
                pauseToSlash = {
                    order = 3,
                    type = "execute",
                    name = L["Pause to slash"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Pause to slash"],
                            nil,
                            function()
                                E.private.WT.misc.pauseToSlash = V.misc.pauseToSlash
                            end
                        )
                    end
                },
                tags = {
                    order = 4,
                    type = "execute",
                    name = L["Tags"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Tags"],
                            nil,
                            function()
                                E.private.WT.misc.tags = V.misc.tags
                            end
                        )
                    end
                },
                moveFrames = {
                    order = 5,
                    type = "execute",
                    name = L["Move Frames"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Move Frames"],
                            nil,
                            function()
                                E.private.WT.misc.moveBlizzardFrames = V.misc.moveBlizzardFrames
                                E.private.WT.misc.moveElvUIBags = V.misc.moveElvUIBags
                                E.private.WT.misc.rememberPositions = V.misc.rememberPositions
                                E.private.WT.misc.framePositions = V.misc.framePositions
                            end
                        )
                    end
                },
                mute = {
                    order = 6,
                    type = "execute",
                    name = L["Mute"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Mute"],
                            nil,
                            function()
                                E.private.WT.misc.mute = V.misc.mute
                            end
                        )
                    end
                },
                gameBar = {
                    order = 7,
                    type = "execute",
                    name = L["Game Bar"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Game Bar"],
                            nil,
                            function()
                                E.db.WT.misc.gameBar = P.misc.gameBar
                            end
                        )
                    end
                }
            }
        },
        resetAllModules = {
            order = 12,
            type = "execute",
            name = L["Reset All Modules"],
            func = function()
                E:StaticPopup_Show("WINDTOOLS_RESET_ALL_MODULES")
            end,
            width = "full"
        }
    }
}
