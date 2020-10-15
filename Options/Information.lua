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
                    order = 4,
                    type = "description",
                    name = "404Polaris"
                },
                ["6"] = {
                    order = 4,
                    type = "description",
                    name = "LiangYuxuan"
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
            end,
        },
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
                    desc = "|cffff0000"..L["Set the profile to WindTools style."],
                    func = function()
                        local WindUI = {
                            ["databars"] = {
                                ["threat"] = {
                                    ["fontOutline"] = "OUTLINE",
                                    ["width"] = 417
                                },
                                ["experience"] = {
                                    ["fontSize"] = 8,
                                    ["hideAtMaxLevel"] = false,
                                    ["fontOutline"] = "OUTLINE",
                                    ["height"] = 5,
                                    ["hideInCombat"] = false,
                                    ["width"] = 222
                                },
                                ["honor"] = {
                                    ["enable"] = false
                                },
                                ["reputation"] = {
                                    ["enable"] = true,
                                    ["height"] = 5
                                },
                                ["azerite"] = {
                                    ["enable"] = false
                                },
                                ["customTexture"] = true,
                                ["statusbar"] = "WindTools Glow"
                            },
                            ["general"] = {
                                ["totems"] = {
                                    ["size"] = 35,
                                    ["growthDirection"] = "HORIZONTAL"
                                },
                                ["fontSize"] = 13,
                                ["autoTrackReputation"] = true,
                                ["autoAcceptInvite"] = true,
                                ["autoRepair"] = "PLAYER",
                                ["minimap"] = {
                                    ["icons"] = {
                                        ["mail"] = {
                                            ["yOffset"] = -20
                                        },
                                        ["lfgEye"] = {
                                            ["position"] = "BOTTOMLEFT",
                                            ["yOffset"] = -2
                                        },
                                        ["classHall"] = {
                                            ["position"] = "TOPRIGHT"
                                        }
                                    },
                                    ["size"] = 220
                                },
                                ["decimalLength"] = 0,
                                ["talkingHeadFrameBackdrop"] = true,
                                ["bottomPanel"] = false,
                                ["backdropfadecolor"] = {
                                    ["a"] = 0.75,
                                    ["r"] = 0.04705882352941176,
                                    ["g"] = 0.04705882352941176,
                                    ["b"] = 0.04705882352941176
                                },
                                ["valuecolor"] = {
                                    ["a"] = 1,
                                    ["b"] = 1,
                                    ["g"] = 0.6784313725490196,
                                    ["r"] = 0.05882352941176471
                                },
                                ["loginmessage"] = false,
                                ["itemLevel"] = {
                                    ["displayInspectInfo"] = false,
                                    ["itemLevelFontSize"] = 14
                                },
                                ["backdropcolor"] = {
                                    ["a"] = 1,
                                    ["r"] = 0.1176470588235294,
                                    ["g"] = 0.1176470588235294,
                                    ["b"] = 0.1176470588235294
                                },
                                ["objectiveFrameAutoHideInKeystone"] = true,
                                ["bordercolor"] = {
                                    ["a"] = 1
                                },
                                ["altPowerBar"] = {
                                    ["statusBarColorGradient"] = true,
                                    ["smoothbars"] = true
                                },
                                ["stickyFrames"] = false,
                                ["bonusObjectivePosition"] = "RIGHT",
                                ["resurrectSound"] = true
                            },
                            ["movers"] = {
                                ["WTRaidMarkersBarAnchor"] = "TOP,ElvUIParent,TOP,0,-85",
                                ["ThreatBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,9",
                                ["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,14,131",
                                ["ElvUF_RaidMover"] = "RIGHT,ElvUIParent,CENTER,-200,100",
                                ["LeftChatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,44,35",
                                ["GMMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,44,224",
                                ["BuffsMover"] = "TOPRIGHT,MinimapMover,TOPLEFT,-10,0",
                                ["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,321,33",
                                ["LootFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,221,97",
                                ["ZoneAbility"] = "BOTTOM,ElvUIParent,BOTTOM,-321,33",
                                ["SocialMenuMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,16,127",
                                ["WTMinimapButtonBarAnchor"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,0,-25",
                                ["ElvUF_FocusMover"] = "TOP,ElvUIParent,TOP,341,-502",
                                ["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,317",
                                ["DurabilityFrameMover"] = "TOPLEFT,ElvUF_PlayerMover,BOTTOMLEFT,0,-200",
                                ["VehicleSeatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-419,52",
                                ["ExperienceBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-205",
                                ["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,300,300",
                                ["ElvUF_TargetTargetMover"] = "TOPLEFT,ElvUF_TargetMover,TOPRIGHT,5,0",
                                ["Wind_ChatBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,45,25",
                                ["WTExtraItemsBar2Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-199,207",
                                ["ElvUF_PetMover"] = "TOPRIGHT,ElvUF_PlayerMover,TOPLEFT,-5,0",
                                ["MirrorTimer1Mover"] = "TOP,ElvUIParent,TOP,0,-116",
                                ["ElvUF_PartyMover"] = "RIGHT,ElvUIParent,CENTER,-300,100",
                                ["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,-72,62",
                                ["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,-72,26",
                                ["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-300,300",
                                ["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,300",
                                ["TalkingHeadFrameMover"] = "TOP,ElvUIParent,TOP,0,-180",
                                ["WTExtraItemsBar1Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-199,248",
                                ["AzeriteBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-686,-128",
                                ["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,216,26",
                                ["ReputationBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-212",
                                ["VehicleLeaveButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,420",
                                ["AltPowerBarMover"] = "TOP,ElvUIParent,TOP,6,-164",
                                ["VOICECHAT"] = "TOPLEFT,ElvUIParent,TOPLEFT,336,-26",
                                ["ObjectiveFrameMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,121,-25",
                                ["BNETMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,44,224",
                                ["ShiftAB"] = "BOTTOMLEFT,ElvAB_1,TOPLEFT,0,5",
                                ["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,14,382",
                                ["HonorBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-625,-212",
                                ["ArenaHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-215,366",
                                ["Wind_ParagonReputationToastFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,203",
                                ["WTExtraItemsBar3Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-230,207",
                                ["BossHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-240,360",
                                ["TotemBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-334,255",
                                ["ElvAB_4"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-25,337",
                                ["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-18,23",
                                ["AlertFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,180",
                                ["DebuffsMover"] = "TOP,ElvUIParent,TOP,144,-397",
                                ["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-25"
                            },
                            ["v11NamePlateReset"] = true,
                            ["chat"] = {
                                ["fontSize"] = 13,
                                ["tabFontOutline"] = "OUTLINE",
                                ["keywordSound"] = "OnePlus Surprise",
                                ["tabFontSize"] = 13,
                                ["fontOutline"] = "OUTLINE",
                                ["panelBackdrop"] = "HIDEBOTH",
                                ["socialQueueMessages"] = true,
                                ["maxLines"] = 2000,
                                ["keywords"] = "%MYNAME%",
                                ["font"] = "聊天",
                                ["channelAlerts"] = {
                                    ["WHISPER"] = "OnePlus Light"
                                },
                                ["tabSelector"] = "NONE",
                                ["hideChatToggles"] = true,
                                ["timeStampFormat"] = "%H:%M ",
                                ["hideVoiceButtons"] = true,
                                ["customTimeColor"] = {
                                    ["r"] = 1,
                                    ["g"] = 0.7647058823529411,
                                    ["b"] = 0.3803921568627451
                                }
                            },
                            ["auras"] = {
                                ["debuffs"] = {
                                    ["countFontSize"] = 18,
                                    ["size"] = 42,
                                    ["durationFontSize"] = 18
                                },
                                ["fontOutline"] = "OUTLINE",
                                ["buffs"] = {
                                    ["countFontSize"] = 19,
                                    ["size"] = 36,
                                    ["durationFontSize"] = 14
                                },
                                ["countYOffset"] = 24,
                                ["timeYOffset"] = 6,
                                ["font"] = "Roadway"
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
                            ["unitframe"] = {
                                ["fontSize"] = 12,
                                ["units"] = {
                                    ["pet"] = {
                                        ["debuffs"] = {
                                            ["countFontSize"] = 15,
                                            ["countFont"] = "Montserrat Bold",
                                            ["enable"] = true,
                                            ["yOffset"] = 80,
                                            ["anchorPoint"] = "TOPLEFT",
                                            ["spacing"] = 3,
                                            ["priority"] = "Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable",
                                            ["attachTo"] = "BUFFS",
                                            ["perrow"] = 4
                                        },
                                        ["raidRoleIcons"] = {
                                            ["enable"] = true,
                                            ["yOffset"] = 0,
                                            ["xOffset"] = 0,
                                            ["position"] = "TOPLEFT"
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
                                            ["scale"] = 0.8,
                                            ["xOffset"] = 0,
                                            ["enable"] = true,
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
                                            ["attachTo"] = "DEBUFFS",
                                            ["spacing"] = 0,
                                            ["detachedWidth"] = 270,
                                            ["priority"] = "Blacklist,blockNoDuration,Personal,Boss,RaidDebuffs,PlayerBuffs",
                                            ["yOffset"] = 0
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
                                            ["width"] = 100,
                                            ["iconAttached"] = false,
                                            ["displayTarget"] = true,
                                            ["timeToHold"] = 0.4,
                                            ["iconSize"] = 27,
                                            ["height"] = 20,
                                            ["icon"] = false,
                                            ["textColor"] = {
                                                ["b"] = 1,
                                                ["g"] = 1,
                                                ["r"] = 1
                                            }
                                        },
                                        ["customTexts"] = {
                                            ["Wind Power"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = 2,
                                                ["text_format"] = "[mouseover][power:current-percent]",
                                                ["yOffset"] = -14,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "LEFT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 16
                                            },
                                            ["Wind Health"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = 3,
                                                ["text_format"] = "[curhp] || [health:percent-nostatus]",
                                                ["yOffset"] = -27,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 16
                                            },
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = -2,
                                                ["text_format"] = "[name]",
                                                ["yOffset"] = 27,
                                                ["justifyH"] = "LEFT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 12
                                            }
                                        },
                                        ["power"] = {
                                            ["height"] = 4
                                        },
                                        ["width"] = 100,
                                        ["infoPanel"] = {
                                            ["height"] = 20
                                        },
                                        ["pvpIcon"] = {
                                            ["anchorPoint"] = "CENTER",
                                            ["scale"] = 1,
                                            ["xOffset"] = 0,
                                            ["enable"] = false,
                                            ["yOffset"] = 0
                                        },
                                        ["name"] = {
                                            ["text_format"] = ""
                                        },
                                        ["orientation"] = "RIGHT",
                                        ["height"] = 30,
                                        ["buffs"] = {
                                            ["anchorPoint"] = "TOPLEFT",
                                            ["spacing"] = 2,
                                            ["perrow"] = 5,
                                            ["priority"] = "Blacklist,Personal,nonPersonal",
                                            ["maxDuration"] = 0,
                                            ["yOffset"] = -80
                                        },
                                        ["middleClickFocus"] = true,
                                        ["raidicon"] = {
                                            ["attachTo"] = "TOP",
                                            ["size"] = 18,
                                            ["enable"] = true,
                                            ["xOffset"] = 0,
                                            ["attachToObject"] = "Frame",
                                            ["yOffset"] = 8
                                        }
                                    },
                                    ["party"] = {
                                        ["debuffs"] = {
                                            ["xOffset"] = 3,
                                            ["sizeOverride"] = 34,
                                            ["countFont"] = "Montserrat",
                                            ["perrow"] = 5
                                        },
                                        ["rdebuffs"] = {
                                            ["xOffset"] = 28,
                                            ["font"] = "Montserrat",
                                            ["fontOutline"] = "OUTLINE",
                                            ["yOffset"] = 6
                                        },
                                        ["raidRoleIcons"] = {
                                            ["xOffset"] = 3
                                        },
                                        ["growthDirection"] = "DOWN_RIGHT",
                                        ["disableFocusGlow"] = true,
                                        ["groupBy"] = "ROLE2",
                                        ["roleIcon"] = {
                                            ["xOffset"] = 5,
                                            ["position"] = "LEFT",
                                            ["yOffset"] = 0
                                        },
                                        ["castbar"] = {
                                            ["width"] = 154
                                        },
                                        ["customTexts"] = {
                                            ["Wind Power"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = -2,
                                                ["text_format"] = "[mouseover][power:percent-nosign]",
                                                ["yOffset"] = -16,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 13
                                            },
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = 22,
                                                ["text_format"] = "[namecolor][name] [smartlevel]",
                                                ["yOffset"] = 1,
                                                ["justifyH"] = "LEFT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 12
                                            },
                                            ["Wind Health Percent"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = -2,
                                                ["text_format"] = "[health:percent-nostatus-nosign]",
                                                ["yOffset"] = 0,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 22
                                            }
                                        },
                                        ["summonIcon"] = {
                                            ["attachTo"] = "RIGHT",
                                            ["xOffset"] = -20
                                        },
                                        ["width"] = 154,
                                        ["power"] = {
                                            ["height"] = 4,
                                            ["hideonnpc"] = true,
                                            ["text_format"] = ""
                                        },
                                        ["name"] = {
                                            ["text_format"] = ""
                                        },
                                        ["buffs"] = {
                                            ["sizeOverride"] = 34,
                                            ["enable"] = true,
                                            ["xOffset"] = -3,
                                            ["countFont"] = "Montserrat",
                                            ["perrow"] = 3
                                        },
                                        ["height"] = 35,
                                        ["verticalSpacing"] = 5,
                                        ["health"] = {
                                            ["text_format"] = ""
                                        },
                                        ["cutaway"] = {
                                            ["health"] = {
                                                ["enabled"] = true
                                            }
                                        }
                                    },
                                    ["player"] = {
                                        ["debuffs"] = {
                                            ["enable"] = false
                                        },
                                        ["disableTargetGlow"] = false,
                                        ["raidRoleIcons"] = {
                                            ["xOffset"] = 3,
                                            ["position"] = "TOPRIGHT"
                                        },
                                        ["disableFocusGlow"] = false,
                                        ["classbar"] = {
                                            ["detachFromFrame"] = true,
                                            ["height"] = 13
                                        },
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
                                        ["power"] = {
                                            ["detachFromFrame"] = true,
                                            ["text_format"] = "",
                                            ["height"] = 15
                                        },
                                        ["customTexts"] = {
                                            ["Wind Power"] = {
                                                ["attachTextTo"] = "Power",
                                                ["xOffset"] = 0,
                                                ["text_format"] = "[power:current]",
                                                ["yOffset"] = 7,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "CENTER",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 22
                                            },
                                            ["Wind Health"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = 4,
                                                ["text_format"] = "[curhp] || [health:percent-nostatus]",
                                                ["yOffset"] = -27,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 16
                                            },
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = -2,
                                                ["text_format"] = "[name]",
                                                ["yOffset"] = 25,
                                                ["justifyH"] = "LEFT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 12
                                            }
                                        },
                                        ["raidicon"] = {
                                            ["size"] = 19
                                        },
                                        ["disableMouseoverGlow"] = true,
                                        ["width"] = 220,
                                        ["infoPanel"] = {
                                            ["height"] = 14,
                                            ["transparent"] = true
                                        },
                                        ["health"] = {
                                            ["text_format"] = ""
                                        },
                                        ["fader"] = {
                                            ["enable"] = true,
                                            ["vehicle"] = false,
                                            ["minAlpha"] = 0
                                        },
                                        ["castbar"] = {
                                            ["xOffsetTime"] = 0,
                                            ["iconAttachedTo"] = "Castbar",
                                            ["textColor"] = {
                                                ["b"] = 1,
                                                ["g"] = 1,
                                                ["r"] = 1
                                            },
                                            ["width"] = 257,
                                            ["iconXOffset"] = -4,
                                            ["height"] = 24,
                                            ["displayTarget"] = true,
                                            ["xOffsetText"] = 0,
                                            ["iconSize"] = 24,
                                            ["format"] = "REMAININGMAX",
                                            ["iconAttached"] = false,
                                            ["latency"] = false
                                        },
                                        ["height"] = 30,
                                        ["portrait"] = {
                                            ["overlay"] = true,
                                            ["camDistanceScale"] = 2.88,
                                            ["overlayAlpha"] = 0.2
                                        },
                                        ["cutaway"] = {
                                            ["health"] = {
                                                ["enabled"] = true,
                                                ["fadeOutTime"] = 0.3,
                                                ["lengthBeforeFade"] = 0.1
                                            },
                                            ["power"] = {
                                                ["lengthBeforeFade"] = 0.1,
                                                ["fadeOutTime"] = 0.3
                                            }
                                        },
                                        ["pvp"] = {
                                            ["position"] = "RIGHT"
                                        }
                                    },
                                    ["raid40"] = {
                                        ["rdebuffs"] = {}
                                    },
                                    ["focus"] = {
                                        ["debuffs"] = {
                                            ["countFontSize"] = 15,
                                            ["countFont"] = "Montserrat Bold",
                                            ["perrow"] = 4,
                                            ["spacing"] = 3,
                                            ["attachTo"] = "BUFFS",
                                            ["priority"] = "Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable",
                                            ["anchorPoint"] = "TOPLEFT",
                                            ["yOffset"] = 80
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
                                            ["enable"] = true,
                                            ["scale"] = 0.8,
                                            ["xOffset"] = 0,
                                            ["yOffset"] = 0
                                        },
                                        ["aurabar"] = {
                                            ["maxBars"] = 6,
                                            ["detachedWidth"] = 270
                                        },
                                        ["cutaway"] = {
                                            ["health"] = {
                                                ["enabled"] = true,
                                                ["fadeOutTime"] = 0.3,
                                                ["lengthBeforeFade"] = 0.1
                                            }
                                        },
                                        ["pvpIcon"] = {
                                            ["anchorPoint"] = "CENTER",
                                            ["enable"] = false,
                                            ["scale"] = 1,
                                            ["xOffset"] = 0,
                                            ["yOffset"] = 0
                                        },
                                        ["customTexts"] = {
                                            ["Wind Power"] = {
                                                ["attachTextTo"] = "Health",
                                                ["enable"] = true,
                                                ["text_format"] = "[mouseover][power:current-percent]",
                                                ["yOffset"] = -14,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = -1,
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
                                            },
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["enable"] = true,
                                                ["text_format"] = "[name]",
                                                ["yOffset"] = 27,
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["xOffset"] = 4,
                                                ["size"] = 12
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
                                            ["anchorPoint"] = "TOPLEFT",
                                            ["perrow"] = 5,
                                            ["spacing"] = 2,
                                            ["enable"] = true,
                                            ["priority"] = "Blacklist,Personal,nonPersonal",
                                            ["maxDuration"] = 0,
                                            ["yOffset"] = -80
                                        },
                                        ["castbar"] = {
                                            ["iconAttachedTo"] = "Castbar",
                                            ["width"] = 138,
                                            ["iconAttached"] = false,
                                            ["displayTarget"] = true,
                                            ["timeToHold"] = 0.4,
                                            ["iconSize"] = 27,
                                            ["height"] = 20,
                                            ["icon"] = false,
                                            ["textColor"] = {
                                                ["b"] = 1,
                                                ["g"] = 1,
                                                ["r"] = 1
                                            }
                                        },
                                        ["middleClickFocus"] = true
                                    },
                                    ["target"] = {
                                        ["cutaway"] = {
                                            ["health"] = {
                                                ["enabled"] = true,
                                                ["fadeOutTime"] = 0.3,
                                                ["lengthBeforeFade"] = 0.1
                                            }
                                        },
                                        ["debuffs"] = {
                                            ["countFontSize"] = 15,
                                            ["countFont"] = "Montserrat Bold",
                                            ["spacing"] = 3,
                                            ["perrow"] = 6,
                                            ["anchorPoint"] = "TOPLEFT",
                                            ["yOffset"] = 80
                                        },
                                        ["castbar"] = {
                                            ["iconAttached"] = false,
                                            ["width"] = 310,
                                            ["iconXOffset"] = -4,
                                            ["iconAttachedTo"] = "Castbar",
                                            ["displayTarget"] = true,
                                            ["height"] = 24,
                                            ["iconSize"] = 24,
                                            ["format"] = "REMAININGMAX",
                                            ["timeToHold"] = 0.4,
                                            ["textColor"] = {
                                                ["r"] = 1,
                                                ["g"] = 1,
                                                ["b"] = 1
                                            }
                                        },
                                        ["customTexts"] = {
                                            ["Wind Power"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = -2,
                                                ["text_format"] = "[mouseover][power:percent-nosign]",
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
                                            },
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = 3,
                                                ["text_format"] = "[name]",
                                                ["yOffset"] = 25,
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 12
                                            }
                                        },
                                        ["raidRoleIcons"] = {
                                            ["xOffset"] = 3
                                        },
                                        ["width"] = 220,
                                        ["health"] = {
                                            ["text_format"] = ""
                                        },
                                        ["name"] = {
                                            ["text_format"] = ""
                                        },
                                        ["height"] = 30,
                                        ["buffs"] = {
                                            ["anchorPoint"] = "TOPLEFT",
                                            ["spacing"] = 2,
                                            ["yOffset"] = -80
                                        },
                                        ["power"] = {
                                            ["text_format"] = "",
                                            ["height"] = 4
                                        },
                                        ["aurabar"] = {
                                            ["enable"] = false
                                        }
                                    },
                                    ["raid"] = {
                                        ["roleIcon"] = {
                                            ["xOffset"] = 2,
                                            ["position"] = "TOPLEFT",
                                            ["yOffset"] = -2
                                        },
                                        ["portrait"] = {
                                            ["fullOverlay"] = true
                                        },
                                        ["power"] = {
                                            ["height"] = 4
                                        },
                                        ["customTexts"] = {
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = 1,
                                                ["text_format"] = "[namecolor][name:short]",
                                                ["yOffset"] = -11,
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 10
                                            }
                                        },
                                        ["rdebuffs"] = {
                                            ["font"] = "Montserrat",
                                            ["fontOutline"] = "OUTLINE",
                                            ["xOffset"] = 23,
                                            ["size"] = 25,
                                            ["yOffset"] = 14
                                        },
                                        ["width"] = 72,
                                        ["name"] = {
                                            ["text_format"] = ""
                                        },
                                        ["height"] = 40,
                                        ["summonIcon"] = {
                                            ["attachTo"] = "TOPRIGHT"
                                        }
                                    },
                                    ["boss"] = {
                                        ["cutaway"] = {
                                            ["health"] = {
                                                ["enabled"] = true,
                                                ["fadeOutTime"] = 0.3,
                                                ["lengthBeforeFade"] = 0.2
                                            }
                                        },
                                        ["debuffs"] = {
                                            ["sizeOverride"] = 30,
                                            ["spacing"] = 3,
                                            ["xOffset"] = -5,
                                            ["perrow"] = 4,
                                            ["countFont"] = "Montserrat",
                                            ["yOffset"] = 0
                                        },
                                        ["castbar"] = {
                                            ["height"] = 24,
                                            ["width"] = 220
                                        },
                                        ["customTexts"] = {
                                            ["Wind Power"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = 0,
                                                ["text_format"] = "[mouseover][power:current-percent]",
                                                ["yOffset"] = -14,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 14
                                            },
                                            ["Wind Health"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = 0,
                                                ["text_format"] = "[health:percent-nostatus] || [health:current]",
                                                ["yOffset"] = 0,
                                                ["font"] = "Accidental Presidency",
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 16
                                            },
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = -1,
                                                ["text_format"] = "[name]",
                                                ["yOffset"] = 25,
                                                ["justifyH"] = "LEFT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 12
                                            }
                                        },
                                        ["width"] = 220,
                                        ["health"] = {
                                            ["text_format"] = ""
                                        },
                                        ["spacing"] = 50,
                                        ["height"] = 30,
                                        ["buffs"] = {
                                            ["anchorPoint"] = "RIGHT",
                                            ["sizeOverride"] = 30,
                                            ["spacing"] = 3,
                                            ["xOffset"] = 5,
                                            ["attachTo"] = "HEALTH",
                                            ["countFont"] = "Montserrat",
                                            ["yOffset"] = 0
                                        },
                                        ["power"] = {
                                            ["text_format"] = "",
                                            ["height"] = 4
                                        },
                                        ["name"] = {
                                            ["text_format"] = ""
                                        }
                                    },
                                    ["targettarget"] = {
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
                                        ["debuffs"] = {
                                            ["anchorPoint"] = "TOPRIGHT",
                                            ["perrow"] = 4,
                                            ["attachTo"] = "FRAME",
                                            ["yOffset"] = 20
                                        },
                                        ["name"] = {
                                            ["text_format"] = ""
                                        },
                                        ["power"] = {
                                            ["height"] = 4
                                        },
                                        ["customTexts"] = {
                                            ["Wind Power"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = -2,
                                                ["text_format"] = "[mouseover][power:percent-nosign]",
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
                                            },
                                            ["Wind Name"] = {
                                                ["attachTextTo"] = "Health",
                                                ["xOffset"] = 3,
                                                ["text_format"] = "[name]",
                                                ["yOffset"] = 25,
                                                ["justifyH"] = "RIGHT",
                                                ["fontOutline"] = "OUTLINE",
                                                ["enable"] = true,
                                                ["size"] = 12
                                            }
                                        },
                                        ["height"] = 30,
                                        ["width"] = 100
                                    }
                                },
                                ["statusbar"] = "WindTools Glow",
                                ["colors"] = {
                                    ["power"] = {
                                        ["MANA"] = {
                                            ["b"] = 0.6313725490196078,
                                            ["g"] = 0.4509803921568628,
                                            ["r"] = 0.3098039215686275
                                        },
                                        ["RUNIC_POWER"] = {
                                            ["g"] = 0.8196078431372549
                                        },
                                        ["MAELSTROM"] = {
                                            ["b"] = 0.9803921568627451,
                                            ["g"] = 0.2588235294117647,
                                            ["r"] = 0.2156862745098039
                                        },
                                        ["ENERGY"] = {
                                            ["b"] = 0.3490196078431372,
                                            ["g"] = 0.6313725490196078,
                                            ["r"] = 0.6509803921568628
                                        }
                                    },
                                    ["castColor"] = {
                                        ["a"] = 1,
                                        ["r"] = 0.2588235294117647,
                                        ["g"] = 0.7098039215686275,
                                        ["b"] = 1
                                    },
                                    ["transparentHealth"] = true,
                                    ["colorhealthbyvalue"] = false,
                                    ["customhealthbackdrop"] = true,
                                    ["health_backdrop"] = {
                                        ["r"] = 0.5137254901960784,
                                        ["g"] = 0.5137254901960784,
                                        ["b"] = 0.5137254901960784
                                    },
                                    ["health"] = {
                                        ["r"] = 0.1333333333333333,
                                        ["g"] = 0.1333333333333333,
                                        ["b"] = 0.1333333333333333
                                    },
                                    ["borderColor"] = {
                                        ["a"] = 1
                                    },
                                    ["castNoInterrupt"] = {
                                        ["a"] = 1,
                                        ["b"] = 0.4941176470588236,
                                        ["g"] = 0.3882352941176471,
                                        ["r"] = 1
                                    },
                                    ["powerclass"] = true,
                                    ["healthMultiplier"] = 0.75,
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
                                    }
                                },
                                ["fontOutline"] = "OUTLINE",
                                ["smoothbars"] = true,
                                ["cooldown"] = {
                                    ["fonts"] = {
                                        ["enable"] = true,
                                        ["font"] = "Oswald",
                                        ["fontSize"] = 17
                                    }
                                },
                                ["filters"] = {
                                    ["aurawatch"] = {}
                                }
                            },
                            ["WT"] = {
                                ["maps"] = {
                                    ["rectangleMinimap"] = {
                                        ["enable"] = true
                                    }
                                },
                                ["social"] = {
                                    ["chatBar"] = {
                                        ["channels"] = {
                                            ["world"] = {
                                                ["name"] = "組隊頻道",
                                                ["enable"] = true
                                            }
                                        }
                                    }
                                },
                                ["item"] = {
                                    ["extraItemsBar"] = {
                                        ["bar1"] = {
                                            ["buttonsPerRow"] = 6
                                        },
                                        ["bar2"] = {
                                            ["buttonsPerRow"] = 6
                                        }
                                    }
                                },
                                ["unitFrames"] = {
                                    ["castBar"] = {
                                        ["enable"] = true,
                                        ["player"] = {
                                            ["enable"] = true,
                                            ["text"] = {
                                                ["offsetX"] = 6,
                                                ["font"] = {
                                                    ["size"] = 13
                                                }
                                            },
                                            ["time"] = {
                                                ["offsetX"] = -5,
                                                ["font"] = {
                                                    ["size"] = 13
                                                }
                                            }
                                        }
                                    }
                                }
                            },
                            ["actionbar"] = {
                                ["bar3"] = {
                                    ["buttonspacing"] = 4,
                                    ["buttonsPerRow"] = 4,
                                    ["buttons"] = 8
                                },
                                ["hideCooldownBling"] = true,
                                ["bar1"] = {
                                    ["buttonspacing"] = 4
                                },
                                ["bar2"] = {
                                    ["buttonspacing"] = 4,
                                    ["enabled"] = true
                                },
                                ["rightClickSelfCast"] = true,
                                ["microbar"] = {
                                    ["buttonSpacing"] = 4
                                },
                                ["bar5"] = {
                                    ["enabled"] = false
                                },
                                ["zoneActionButton"] = {
                                    ["clean"] = true
                                },
                                ["transparent"] = true,
                                ["font"] = "Montserrat",
                                ["globalFadeAlpha"] = 0.7000000000000001,
                                ["fontOutline"] = "OUTLINE",
                                ["hotkeyTextYOffset"] = -2,
                                ["stanceBar"] = {
                                    ["buttonspacing"] = 4,
                                    ["buttonsize"] = 24
                                },
                                ["barPet"] = {
                                    ["buttonspacing"] = 4,
                                    ["inheritGlobalFade"] = true,
                                    ["backdrop"] = false,
                                    ["buttonsize"] = 37
                                },
                                ["bar4"] = {
                                    ["backdrop"] = false,
                                    ["inheritGlobalFade"] = true
                                }
                            },
                            ["nameplates"] = {
                                ["cutaway"] = {
                                    ["health"] = {
                                        ["enabled"] = true,
                                        ["fadeOutTime"] = 0.3,
                                        ["lengthBeforeFade"] = 0.2
                                    }
                                },
                                ["smoothbars"] = true,
                                ["statusbar"] = "WindTools Glow",
                                ["units"] = {
                                    ["TARGET"] = {
                                        ["glowStyle"] = "style7"
                                    },
                                    ["PLAYER"] = {
                                        ["buffs"] = {
                                            ["countFont"] = "Montserrat Bold"
                                        }
                                    }
                                }
                            },
                            ["bags"] = {
                                ["junkDesaturate"] = true,
                                ["itemLevelFont"] = "Montserrat",
                                ["currencyFormat"] = "ICON",
                                ["countFontOutline"] = "OUTLINE",
                                ["vendorGrays"] = {
                                    ["enable"] = true
                                },
                                ["itemLevelFontOutline"] = "OUTLINE",
                                ["transparent"] = true,
                                ["moneyFormat"] = "SHORTINT",
                                ["useBlizzardCleanup"] = true,
                                ["showBindType"] = true,
                                ["clearSearchOnClose"] = true,
                                ["countFont"] = "Montserrat"
                            },
                            ["cooldown"] = {
                                ["fonts"] = {
                                    ["enable"] = true,
                                    ["font"] = "Accidental Presidency",
                                    ["fontSize"] = 27
                                }
                            },
                            ["tooltip"] = {
                                ["fontSize"] = 13,
                                ["healthBar"] = {
                                    ["statusPosition"] = "TOP",
                                    ["fontSize"] = 13
                                },
                                ["colorAlpha"] = 0.75,
                                ["headerFontSize"] = 15,
                                ["textFontSize"] = 13,
                                ["font"] = "思源黑體 粗體",
                                ["fontOutline"] = "OUTLINE",
                                ["cursorAnchorType"] = "ANCHOR_CURSOR_RIGHT",
                                ["itemCount"] = "BOTH",
                                ["smallTextFontSize"] = 13
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
                    desc = "|cffff0000"..L["Set the profile to WindTools style."],
                    func = function()
                        E.private["general"]["normTex"] = "WindTools Glow"
                        E.private["general"]["glossTex"] = "WindTools Flat"
                        E.private["general"]["chatBubbleFontOutline"] = "OUTLINE"
                        E.private["general"]["minimap"]["hideCalendar"] = false
                        E.private["WT"]["maps"]["minimapButtons"]["buttonSize"] = 25
                        E.private["WT"]["maps"]["minimapButtons"]["backdropSpacing"] = 1
                        E.private["WT"]["maps"]["minimapButtons"]["calendar"] = true
                        E.private["WT"]["maps"]["minimapButtons"]["orientation"] = "VERTICAL"
                        E.private["WT"]["maps"]["minimapButtons"]["spacing"] = 5
                        E.private["WT"]["maps"]["minimapButtons"]["backdrop"] = false
                        E.private["WT"]["maps"]["minimapButtons"]["mouseOver"] = true
                        E.private["WT"]["maps"]["worldMap"]["scale"]["size"] = 1.55
                        E.private["WT"]["misc"]["mute"]["enable"] = true
                        E.private["WT"]["misc"]["mute"]["mount"][63796] = true
                        E.private["WT"]["misc"]["mute"]["mount"][229385] = true
                        E.private["skins"]["parchmentRemoverEnable"] = true
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
