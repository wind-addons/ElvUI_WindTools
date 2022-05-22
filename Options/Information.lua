local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.information.args
local ACH = E.Libs.ACH

local _G = _G
local format = format
local gsub = gsub
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
        kofi = {
            order = 1,
            type = "execute",
            name = format("%s %s (%s)", F.GetIconString(W.Media.Icons.donateKofi, 14), L["Donate"], L["Ko-fi"]),
            func = function()
                E:StaticPopup_Show("WINDTOOLS_EDITBOX", nil, nil, "https://ko-fi.com/fang2hou")
            end,
            width = 1.2
        },
        aiFaDian = {
            order = 2,
            type = "execute",
            name = format("%s %s (%s)", F.GetIconString(W.Media.Icons.donateAiFaDian, 14), L["Donate"], L["AiFaDian"]),
            func = function()
                E:StaticPopup_Show("WINDTOOLS_EDITBOX", nil, nil, "https://afdian.net/@fang2hou")
            end,
            width = 1.2
        },
        betterAlign = {
            order = 3,
            type = "description",
            fontSize = "medium",
            name = " ",
            width = "full"
        },
        contact = {
            order = 4,
            type = "group",
            inline = true,
            name = L["Message From the Author"],
            args = {
                description = {
                    order = 1,
                    type = "description",
                    fontSize = "medium",
                    name = format(
                        "%s\n%s\n\n%s\n\n%s\n%s",
                        format(L["Thank you for using %s!"], W.Title),
                        format(
                            L[
                                "%s is a plugin for ElvUI that consists of my original plugins and several plugins developed by other players."
                            ],
                            W.Title
                        ),
                        format(
                            L["You can send your suggestions or bugs via %s, %s, %s, and the thread in %s."],
                            L["QQ Group"],
                            L["Discord"],
                            L["Github"],
                            L["NGA.cn"]
                        ),
                        format(L["The localization of %s is community-driven."], W.Title),
                        format(
                            L[
                                "If you have an interest in translating %s or improving the quality of translation, I am glad to meet you in Discord."
                            ],
                            W.Title
                        )
                    )
                },
                betterAlign = {
                    order = 2,
                    type = "description",
                    fontSize = "medium",
                    name = " ",
                    width = "full"
                },
                nga = {
                    order = 3,
                    type = "execute",
                    name = L["NGA.cn"],
                    image = W.Media.Icons.nga,
                    func = function()
                        E:StaticPopup_Show("WINDTOOLS_EDITBOX", nil, nil, "https://bbs.nga.cn/read.php?tid=12142815")
                    end,
                    width = 0.7
                },
                discord = {
                    order = 4,
                    type = "execute",
                    name = L["Discord"],
                    image = W.Media.Icons.discord,
                    func = function()
                        E:StaticPopup_Show("WINDTOOLS_EDITBOX", nil, nil, discordURL)
                    end,
                    width = 0.7
                },
                qq = {
                    order = 5,
                    type = "execute",
                    name = L["QQ Group"],
                    image = W.Media.Icons.qq,
                    func = function()
                        E:StaticPopup_Show("WINDTOOLS_EDITBOX", nil, nil, "336069019")
                    end,
                    width = 0.7
                },
                github = {
                    order = 6,
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
                },
                debugModeTip = {
                    order = 7,
                    type = "description",
                    fontSize = "medium",
                    name = E.NewSign ..
                        " |cffe74c3c" ..
                            format(
                                L["Before you submit a bug, please enable debug mode with %s and test it one more time."],
                                "|cff00ff00/wtdebug|r"
                            ) ..
                                "|r",
                    width = "full"
                }
            }
        },
        contributors = {
            order = 5,
            name = L["Contributors (Github.com)"],
            type = "group",
            inline = true,
            args = {
                ["1"] = {
                    order = 1,
                    type = "description",
                    name = format(
                        "%s: %s | %s",
                        "fang2hou",
                        E.InfoColor .. "houshuu" .. "|r",
                        F.CreateClassColorString("Tabimonk @ " .. L["Shadowmoon"] .. " (TW)", "MONK")
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
                    name = format(
                        "%s: %s",
                        "mcc1",
                        F.CreateClassColorString("青楓殘月 @ " .. L["Lights Hope"] .. " (TW)", "MAGE")
                    )
                },
                ["4"] = {
                    order = 4,
                    type = "description",
                    name = format("%s: %s", "MouJiaoZi", E.InfoColor .. "某餃子" .. "|r")
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
                    name = format(
                        "%s: %s | %s",
                        "keludechu",
                        E.InfoColor .. "水稻" .. "|r",
                        F.CreateClassColorString("Surtr @ " .. L["Blanchard"] .. " (CN)", "WARLOCK")
                    )
                },
                ["8"] = {
                    order = 8,
                    type = "description",
                    name = format(
                        "%s: %s | %s",
                        "asdf12303116",
                        E.InfoColor .. "Chen" .. "|r",
                        F.CreateClassColorString("一发径直入魂 @ " .. L["Burning Blade"] .. " (CN)", "HUNTER")
                    )
                },
                ["9"] = {
                    order = 9,
                    type = "description",
                    name = format("%s: %s", "ryanfys", "阿尔托利亜 @ " .. L["Demon Fall Canyon"] .. " (CN)")
                }
            }
        },
        version = {
            order = 6,
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
                    name = W.Title .. ": " .. AddColor(W.Version)
                },
                build = {
                    order = 3,
                    type = "description",
                    name = L["WoW Build"] .. ": " .. AddColor(format("%s (%s)", E.wowpatch, E.wowbuild))
                }
            }
        },
        loginMessage = {
            order = 997,
            type = "toggle",
            name = L["Login Message"],
            get = function(info)
                return E.private.WT.core.loginMessage
            end,
            set = function(info, value)
                E.private.WT.core.loginMessage = value
            end
        },
        compatibilityCheck = {
            order = 998,
            type = "toggle",
            name = L["Compatibility Check"],
            desc = L["Help you to enable/disable the modules for a better experience with other plugins."],
            get = function(info)
                return E.private.WT.core.compatibilityCheck
            end,
            set = function(info, value)
                E.private.WT.core.compatibilityCheck = value
                E:StaticPopup_Show("PRIVATE_RL")
            end
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
        "|cffff7d0aMerathilis|r",
        "|cfffff0cdsiweia|r",
        "Repooc",
        "|cfffff0cdloudsoul|r",
        "|cff0070deAzilroka|r",
        "|cffd12727Blazeflack|r",
        E:TextGradient("Simpy", 1.00, 1.00, 0.60, 0.53, 1.00, 0.40),
        "|cffff7d0aBenik|r",
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
        ["한국어 (koKR)"] = {
            F.CreateClassColorString("헬리오스의방패<주부월드> @ " .. L["Burning Legion"] .. "(KR)", "WARRIOR"),
            F.CreateClassColorString("불광불급옹<주부월드> @ " .. L["Burning Legion"] .. "(KR)", "HUNTER"),
            F.CreateClassColorString("다크어쌔신<주부월드> @ " .. L["Burning Legion"] .. "(KR)", "DEMONHUNTER"),
            F.CreateClassColorString("크림슨프릴<주부월드> @ " .. L["Burning Legion"] .. "(KR)", "MAGE")
        },
        ["français (frFR)"] = {
            "PodVibe @ CurseForge",
            "xan2622 @ Github"
        },
        ["Deutsche (deDE)"] = {
            "imna1975 @ CurseForge",
            "|cffff7d0aMerathilis|r",
            "|cff00c0faDlarge|r"
        },
        ["русский язык (ruRU)"] = {
            "Evgeniy-ONiX @ Github",
            "dadec666 @ Github"
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
            "oyg123 @ NGA.cn"
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
            "siweia (NDui)",
            "Witnesscm (NDui_Plus)",
            "Tevoll (ElvUI Enhanced Again)",
            "MMOSimca (Simple Objective Progress)",
            "Merathilis (ElvUI MerathilisUI)"
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
        },
        [L["Inspect"]] = {
            "loudsoul (TinyInspect)"
        },
        [L["Instance Difficulty"]] = {
            "Merathilis (ElvUI MerathilisUI)"
        },
        [L["Item Level"]] = {
            "Merathilis (ElvUI MerathilisUI)"
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
        ["迷时鸟 @ NGA.cn"] = {
            "Media/Texture/Illustration"
        },
        ["Iconfont (Alibaba)"] = {
            "Media/Icons/GameBar",
            "Media/Icons/List.tga",
            "Media/Icons/Favorite.tga",
            "Media/Textures/ArrowDown.tga"
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
        ["Sukiki情绪化 @ www.iconfont.cn"] = {
            "Media/Icons/Rest.tga"
        },
        ["王乐城愚人云端 @ www.iconfont.cn"] = {
            "Media/Texture/WindToolsSmall.tga"
        },
        ["LieutenantG @ www.iconfont.cn"] = {
            "Media/Icons/Button/Minus.tga",
            "Media/Icons/Button/Plus.tga",
            "Media/Icons/Button/Forward.tga"
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

for version, data in pairs(W.Changelog) do
    local versionString = format("%d.%02d", version / 100, mod(version, 100))
    local dateTable = {strsplit("/", data.RELEASE_DATE)}
    local dateString = data.RELEASE_DATE
    if #dateTable == 3 then
        dateString = L["%month%-%day%-%year%"]
        dateString = gsub(dateString, "%%year%%", dateTable[1])
        dateString = gsub(dateString, "%%month%%", dateTable[2])
        dateString = gsub(dateString, "%%day%%", dateTable[3])
    end

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
        name = "|cffbbbbbb" .. dateString .. " " .. L["Released"] .. "|r",
        fontSize = "small"
    }

    page.version = {
        order = 2,
        type = "description",
        name = L["Version"] .. " " .. AddColor(versionString),
        fontSize = "large"
    }

    local importantPart = data.IMPORTANT and (data.IMPORTANT[E.global.general.locale] or data.IMPORTANT["enUS"])
    if importantPart and #importantPart > 0 then
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
                for index, line in ipairs(importantPart) do
                    text =
                        text ..
                        format("%02d", index) ..
                            ". " ..
                                gsub(
                                    line,
                                    "%[.+%]",
                                    function(s)
                                        return AddColor(s)
                                    end
                                ) ..
                                    "\n"
                end
                return text .. "\n"
            end,
            fontSize = "medium"
        }
    end

    local newPart = data.NEW and (data.NEW[E.global.general.locale] or data.NEW["enUS"])
    if newPart and #newPart > 0 then
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
                for index, line in ipairs(newPart) do
                    text =
                        text ..
                        format("%02d", index) ..
                            ". " ..
                                gsub(
                                    line,
                                    "%[.+%]",
                                    function(s)
                                        return AddColor(s)
                                    end
                                ) ..
                                    "\n"
                end
                return text .. "\n"
            end,
            fontSize = "medium"
        }
    end

    local improvementPart = data.IMPROVEMENT and (data.IMPROVEMENT[E.global.general.locale] or data.IMPROVEMENT["enUS"])
    if improvementPart and #improvementPart > 0 then
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
                for index, line in ipairs(improvementPart) do
                    text =
                        text ..
                        format("%02d", index) ..
                            ". " ..
                                gsub(
                                    line,
                                    "%[.+%]",
                                    function(s)
                                        return AddColor(s)
                                    end
                                ) ..
                                    "\n"
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
    text = format(L["Reset all %s modules."], W.Title),
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

E.PopupDialogs.WINDTOOLS_IMPORT_SETTING = {
    text = format("%s\n%s", L["Are you sure you want to import the profile?"], E.InfoColor .. L["[ %s by %s ]"]),
    button1 = _G.ACCEPT,
    button2 = _G.CANCEL,
    OnAccept = function(_, UISetName)
        if UISetName then
            W[UISetName .. "Profile"]()
            W[UISetName .. "Private"]()
        end
    end,
    whileDead = 1,
    hideOnEscape = true
}

options.reset = {
    order = 4,
    type = "group",
    name = L["Reset"],
    args = {
        -- import = {
        --     order = 0,
        --     type = "group",
        --     inline = true,
        --     name = L["Import Profile"],
        --     args = {
        --         Fang2houUI = {
        --             order = 1,
        --             type = "execute",
        --             name = L["Fang2hou UI"],
        --             desc = format(
        --                 "%s\n%s",
        --                 format(
        --                     L["Override your ElvUI profile with %s profile."],
        --                     E.InfoColor .. L["Fang2hou UI"] .. "|r"
        --                 ),
        --                 E.NewSign .. L["Support 16:9, 21:9 and 32:9!"]
        --             ),
        --             func = function()
        --                 E:StaticPopup_Show("WINDTOOLS_IMPORT_SETTING", L["Fang2hou UI"], "Fang2hou", "Fang2houUI")
        --             end
        --         }
        --     }
        -- },
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
                thanks = {
                    order = 6,
                    type = "execute",
                    name = L["Thanks"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Thanks"],
                            nil,
                            function()
                                E.db.WT.announcement.thanks = P.announcement.thanks
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
                },
                quickKeystone = {
                    order = 3,
                    type = "execute",
                    name = L["Quick Keystone"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Quick Keystone"],
                            nil,
                            function()
                                E.db.WT.combat.quickKeystone = P.combat.quickKeystone
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
                extraItemsBar = {
                    order = 1,
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
                alreadyKnown = {
                    order = 3,
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
                fastLoot = {
                    order = 4,
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
                    order = 5,
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
                contacts = {
                    order = 6,
                    type = "execute",
                    name = L["Contacts"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Contacts"],
                            nil,
                            function()
                                E.db.WT.item.contacts = P.item.contacts
                                E.global.WT.item.contacts = G.item.contacts
                            end
                        )
                    end
                },
                inspect = {
                    order = 7,
                    type = "execute",
                    name = L["Inspect"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Inspect"],
                            nil,
                            function()
                                E.db.WT.item.inspect = P.item.inspect
                            end
                        )
                    end
                },
                itemLevel = {
                    order = 8,
                    type = "execute",
                    name = L["Item Level"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Item Level"],
                            nil,
                            function()
                                E.db.WT.item.itemLevel = P.item.itemLevel
                            end
                        )
                    end
                },
                extendMerchantPages = {
                    order = 9,
                    type = "execute",
                    name = L["Extend Merchant Pages"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Extend Merchant Pages"],
                            nil,
                            function()
                                E.private.WT.item.extendMerchantPages = V.item.extendMerchantPages
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
                superTracker = {
                    order = 1,
                    type = "execute",
                    name = L["Super Tracker"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Super Tracker"],
                            nil,
                            function()
                                E.private.WT.maps.superTracker = V.maps.superTracker
                            end
                        )
                    end
                },
                whoClicked = {
                    order = 2,
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
                rectangleMinimap = {
                    order = 3,
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
                minimapButtons = {
                    order = 4,
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
                worldMap = {
                    order = 5,
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
                },
                instanceDifficulty = {
                    order = 6,
                    type = "execute",
                    name = L["Instance Difficulty"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Super Tracker"],
                            nil,
                            function()
                                E.private.WT.maps.instanceDifficulty = V.maps.instanceDifficulty
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
                                E.private.WT.tooltips.factionIcon = V.tooltips.factionIcon
                                E.private.WT.tooltips.petIcon = V.tooltips.petIcon
                                E.private.WT.tooltips.petId = V.tooltips.petId
                                E.private.WT.tooltips.tierSet = V.tooltips.tierSet
                                E.private.WT.tooltips.covenant = V.tooltips.covenant
                                E.private.WT.tooltips.dominationRank = V.tooltips.dominationRank
                                E.private.WT.tooltips.objectiveProgress = V.tooltips.objectiveProgress
                                E.private.WT.tooltips.objectiveProgressAccuracy = V.tooltips.objectiveProgressAccuracy
                                E.db.WT.tooltips.yOffsetOfHealthBar = P.tooltips.yOffsetOfHealthBar
                                E.db.WT.tooltips.yOffsetOfHealthText = P.tooltips.yOffsetOfHealthText
                                E.db.WT.tooltips.groupInfo = P.tooltips.groupInfo
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
                absorb = {
                    order = 2,
                    type = "execute",
                    name = L["Absorb"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Absorb"],
                            nil,
                            function()
                                E.db.WT.unitFrames.absorb = P.unitFrames.absorb
                            end
                        )
                    end
                },
                roleIcon = {
                    order = 3,
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
                    order = 1,
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
                                E.private.WT.skins.merathilisUISkin = V.skins.merathilisUISkin
                                E.private.WT.skins.shadow = V.skins.shadow
                                E.private.WT.skins.increasedSize = V.skins.increasedSize
                                E.private.WT.skins.color = V.skins.color
                            end
                        )
                    end
                },
                font = {
                    order = 2,
                    type = "execute",
                    name = L["Font"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Font"],
                            nil,
                            function()
                                E.private.WT.skins.ime = V.skins.ime
                                E.private.WT.skins.errorMessage = V.skins.errorMessage
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
                    order = 4,
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
                },
                addons = {
                    order = 5,
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
                widgets = {
                    order = 6,
                    type = "execute",
                    name = L["Widgets"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Widgets"],
                            nil,
                            function()
                                E.private.WT.skins.widgets = V.skins.widgets
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
                                E.private.WT.misc.autoScreenshot = V.misc.autoScreenshot
                                E.private.WT.misc.moveSpeed = V.misc.moveSpeed
                                E.private.WT.misc.noKanjiMath = V.misc.noKanjiMath
                                E.private.WT.misc.pauseToSlash = V.misc.pauseToSlash
                                E.private.WT.misc.skipCutScene = V.misc.skipCutScene
                                E.private.WT.misc.hotKeyAboveCD = V.misc.hotKeyAboveCD
                                E.private.WT.misc.guildNewsItemLevel = V.misc.guildNewsItemLevel
                                E.db.WT.misc.disableTalkingHead = P.misc.disableTalkingHead
                                E.db.WT.misc.hideCrafter = P.misc.hideCrafter
                                E.db.WT.misc.noLootPanel = P.misc.noLootPanel
                            end
                        )
                    end
                },
                moveFrames = {
                    order = 2,
                    type = "execute",
                    name = L["Move Frames"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Move Frames"],
                            nil,
                            function()
                                E.private.WT.misc.moveFrames = V.misc.moveFrames
                            end
                        )
                    end
                },
                mute = {
                    order = 3,
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
                gameBar = {
                    order = 5,
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
                },
                lfgList = {
                    order = 6,
                    type = "execute",
                    name = L["LFG List"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["LFG List"],
                            nil,
                            function()
                                E.private.WT.misc.lfgList = V.misc.lfgList
                            end
                        )
                    end
                },
                automation = {
                    order = 7,
                    type = "execute",
                    name = L["Automation"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Automation"],
                            nil,
                            function()
                                E.db.WT.misc.automation = P.misc.automation
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

do
    local text = ""

    E.PopupDialogs.WINDTOOLS_IMPORT_STRING = {
        text = format(
            "%s\n|cffff0000%s|r",
            L["Are you sure you want to import this string?"],
            format(L["It will override your %s setting."], W.Title)
        ),
        button1 = _G.ACCEPT,
        button2 = _G.CANCEL,
        OnAccept = function()
            F.Profiles.ImportByString(text)
            ReloadUI()
        end,
        whileDead = 1,
        hideOnEscape = true
    }

    options.profiles = {
        order = 5,
        type = "group",
        name = L["Profiles"],
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
                        name = format(L["Import and export your %s settings."], W.Title),
                        fontSize = "medium"
                    }
                }
            },
            textArea = {
                order = 2,
                type = "group",
                inline = true,
                name = format("%s %s", W.Title, L["String"]),
                args = {
                    text = {
                        order = 1,
                        type = "input",
                        name = " ",
                        multiline = 15,
                        width = "full",
                        get = function()
                            return text
                        end,
                        set = function(_, value)
                            text = value
                        end
                    },
                    importButton = {
                        order = 2,
                        type = "execute",
                        name = L["Import"],
                        func = function()
                            if text ~= "" then
                                E:StaticPopup_Show("WINDTOOLS_IMPORT_STRING")
                            end
                        end
                    },
                    exportAllButton = {
                        order = 3,
                        type = "execute",
                        name = L["Export All"],
                        desc = format(L["Export all setting of %s."], W.Title),
                        func = function()
                            text = F.Profiles.GetOutputString(true, true)
                        end
                    },
                    exportProfileButton = {
                        order = 4,
                        type = "execute",
                        name = L["Export Profile"],
                        desc = format(L["Export the setting of %s that stored in ElvUI Profile database."], W.Title),
                        func = function()
                            text = F.Profiles.GetOutputString(true, false)
                        end
                    },
                    exportPrivateButton = {
                        order = 5,
                        type = "execute",
                        name = L["Export Private"],
                        desc = format(L["Export the setting of %s that stored in ElvUI Private database."], W.Title),
                        func = function()
                            text = F.Profiles.GetOutputString(false, true)
                        end
                    }
                }
            }
        }
    }
end
