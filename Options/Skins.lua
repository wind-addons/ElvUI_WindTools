local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.skins.args
local LSM = E.Libs.LSM
local S = W.Modules.Skins

local pairs = pairs
local type = type

local IsAddOnLoaded = IsAddOnLoaded

options.desc = {
    order = 1,
    type = "group",
    inline = true,
    name = L["Description"],
    args = {
        feature_1 = {
            order = 1,
            type = "description",
            name = L["WindTools provides a new shadow style for original ElvUI."],
            fontSize = "medium"
        },
        feature_2 = {
            order = 2,
            type = "description",
            name = L["You can customize the global shadow color, disable some skins, set the level of vignetting, etc."],
            fontSize = "medium"
        },
        feature_3 = {
            order = 3,
            type = "description",
            name = L["WindSkins is all in control, enjoy your own ElvUI interface!"],
            fontSize = "medium"
        }
    }
}

options.general = {
    order = 2,
    type = "group",
    name = L["General"],
    get = function(info)
        return E.private.WT.skins[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.skins[info[#info]] = value
        E:StaticPopup_Show("PRIVATE_RL")
    end,
    args = {
        enable = {
            order = 1,
            type = "toggle",
            name = L["Enable"],
            width = 0.7
        },
        resourcePage = {
            order = 2,
            type = "execute",
            name = E.NewSign .. " " .. F.GetWindStyleText(L["More Resources"]),
            desc = format(
                "%s\n%s\n\n|cff00d1b2%s|r (%s)\n%s\n%s\n%s",
                L["Open the project page and download more resources."],
                L["e.g. chat bubble texture with shadow (also in instance)"],
                L["Tips"],
                L["Editbox"],
                L["CTRL+A: Select All"],
                L["CTRL+C: Copy"],
                L["CTRL+V: Paste"]
            ),
            func = function()
                if E.global.general.locale == "zhCN" then
                    E:StaticPopup_Show("WINDTOOLS_EDITBOX", nil, nil, "https://bbs.nga.cn/read.php?tid=31851882")
                else
                    E:StaticPopup_Show("WINDTOOLS_EDITBOX", nil, nil, "https://fang2hou.github.io/ElvUI_WindTools")
                end
            end,
            width = 1.2
        },
        merathilisUISkin = {
            order = 3,
            type = "toggle",
            name = format(L["Use %s Skins"], L["MerathilisUI"]),
            width = 1.2,
            desc = format(
                "%s\n|cffff3860%s|r: %s",
                format(L["Add skins for all modules inside %s with %s functions."], W.Title, L["MerathilisUI"]),
                L["Notice"],
                format(L["It doesn't mean that the %s Skins will not be applied."], W.Title)
            ),
            hidden = function()
                return not IsAddOnLoaded("ElvUI_MerathilisUI")
            end
        },
        general = {
            order = 4,
            type = "group",
            name = L["General"],
            inline = true,
            disabled = function()
                return not E.private.WT.skins.enable
            end,
            args = {
                windtools = {
                    order = 1,
                    type = "toggle",
                    name = L["WindTools Modules"]
                },
                removeParchment = {
                    order = 2,
                    type = "toggle",
                    name = L["Parchment Remover"]
                }
            }
        },
        shadow = {
            order = 5,
            type = "group",
            name = L["Shadow"],
            inline = true,
            disabled = function()
                return not E.private.WT.skins.enable
            end,
            args = {
                shadow = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"]
                },
                weakAurasShadow = {
                    order = 2,
                    type = "toggle",
                    name = L["WeakAuras Shadow"],
                    hidden = function()
                        return not E.private.WT.skins.enable or not E.private.WT.skins.shadow or
                            not E.private.WT.skins.addons.weakAuras
                    end
                },
                increasedSize = {
                    order = 3,
                    type = "range",
                    name = L["Increase Size"],
                    desc = L["Make shadow thicker."],
                    min = 0,
                    max = 10,
                    step = 1
                },
                color = {
                    order = 4,
                    type = "color",
                    name = L["Shadow Color"],
                    hasAlpha = false,
                    get = function(info)
                        local db = E.private.WT.skins.color
                        local default = V.skins.color
                        return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                    end,
                    set = function(info, r, g, b)
                        local db = E.private.WT.skins.color
                        db.r, db.g, db.b = r, g, b
                        E:StaticPopup_Show("PRIVATE_RL")
                    end,
                    disabled = function()
                        return not E.private.WT.skins.enable
                    end
                }
            }
        },
        vignetting = {
            order = 6,
            type = "group",
            name = L["Vignetting"],
            inline = true,
            get = function(info)
                return E.db.WT.skins.vignetting[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.skins.vignetting[info[#info]] = value
                S:UpdateVignettingConfig()
            end,
            disabled = function()
                return not E.private.WT.skins.enable
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"]
                },
                level = {
                    order = 2,
                    type = "range",
                    name = L["Level"],
                    desc = L["Change the alpha of vignetting."],
                    disabled = function()
                        return not E.db.WT.skins.vignetting.enable
                    end,
                    min = 1,
                    max = 100,
                    step = 1
                }
            }
        }
    }
}

options.font = {
    order = 3,
    type = "group",
    name = L["Font"],
    args = {
        errorMessage = {
            order = 1,
            type = "group",
            inline = true,
            name = L["Error Mesage"],
            get = function(info)
                return E.private.WT.skins.errorMessage[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.skins.errorMessage[info[#info]] = value
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
        imeLabel = {
            order = 2,
            type = "group",
            inline = true,
            name = L["Input Method Editor"] .. " - " .. L["Label"],
            get = function(info)
                return E.private.WT.skins.ime.label[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.skins.ime.label[info[#info]] = value
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
        imeCandidate = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Input Method Editor"] .. " - " .. L["Candidate"],
            get = function(info)
                return E.private.WT.skins.ime.candidate[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.skins.ime.candidate[info[#info]] = value
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

options.blizzard = {
    order = 4,
    type = "group",
    name = L["Blizzard"],
    get = function(info)
        return E.private.WT.skins.blizzard[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.skins.blizzard[info[#info]] = value
        E:StaticPopup_Show("PRIVATE_RL")
    end,
    disabled = function()
        return not E.private.WT.skins.enable
    end,
    args = {
        enable = {
            order = 0,
            type = "toggle",
            name = L["Enable"]
        },
        enableAll = {
            order = 1,
            type = "execute",
            name = L["Enable All"],
            func = function()
                for key in pairs(V.skins.blizzard) do
                    E.private.WT.skins.blizzard[key] = true
                end
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        disableAll = {
            order = 2,
            type = "execute",
            name = L["Disable All"],
            func = function()
                for key in pairs(V.skins.blizzard) do
                    if key ~= "enable" then
                        E.private.WT.skins.blizzard[key] = false
                    end
                end
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        betterOption = {
            order = 3,
            type = "description",
            name = " ",
            width = "full"
        },
        achievements = {
            order = 10,
            type = "toggle",
            name = L["Achievements"]
        },
        addonManager = {
            order = 10,
            type = "toggle",
            name = L["AddOn Manager"]
        },
        adventureMap = {
            order = 10,
            type = "toggle",
            name = L["Adventure Map"]
        },
        alerts = {
            order = 10,
            type = "toggle",
            name = L["Alert Frames"]
        },
        animaDiversion = {
            order = 10,
            type = "toggle",
            name = L["Anima Diversion"]
        },
        artifact = {
            order = 10,
            type = "toggle",
            name = L["Artifact"]
        },
        auctionHouse = {
            order = 10,
            type = "toggle",
            name = L["Auction House"]
        },
        azerite = {
            order = 10,
            type = "toggle",
            name = L["Azerite"]
        },
        azeriteEssence = {
            order = 10,
            type = "toggle",
            name = L["Azerite Essence"]
        },
        azeriteRespec = {
            order = 10,
            type = "toggle",
            name = L["Azerite Respec"]
        },
        barberShop = {
            order = 10,
            type = "toggle",
            name = L["Barber Shop"]
        },
        binding = {
            order = 10,
            type = "toggle",
            name = L["Binding"]
        },
        blackMarket = {
            order = 10,
            type = "toggle",
            name = L["Black Market"]
        },
        calendar = {
            order = 10,
            type = "toggle",
            name = L["Calendar"]
        },
        challenges = {
            order = 10,
            type = "toggle",
            name = L["Challenges"]
        },
        channels = {
            order = 10,
            type = "toggle",
            name = L["Channels"]
        },
        character = {
            order = 10,
            type = "toggle",
            name = L["Character"]
        },
        chromieTime = {
            order = 10,
            type = "toggle",
            name = L["Chromie Time"]
        },
        classTalent = {
            order = 10,
            type = "toggle",
            name = L["Class Talent"]
        },
        collections = {
            order = 10,
            type = "toggle",
            name = L["Collections"]
        },
        clickBinding = {
            order = 10,
            type = "toggle",
            name = L["Click Binding"]
        },
        communities = {
            order = 10,
            type = "toggle",
            name = L["Communities"]
        },
        covenantRenown = {
            order = 10,
            type = "toggle",
            name = L["Covenant Renown"]
        },
        covenantPreview = {
            order = 10,
            type = "toggle",
            name = L["Covenant Preview"]
        },
        covenantSanctum = {
            order = 10,
            type = "toggle",
            name = L["Covenant Sanctum"]
        },
        debugTools = {
            order = 10,
            type = "toggle",
            name = L["Debug Tools"]
        },
        dressingRoom = {
            order = 10,
            type = "toggle",
            name = L["Dressing Room"]
        },
        editModeManager = {
            order = 10,
            type = "toggle",
            name = L["Edit Mode Manager"]
        },
        encounterJournal = {
            order = 10,
            type = "toggle",
            name = L["Encounter Journal"]
        },
        eventTrace = {
            order = 10,
            type = "toggle",
            name = L["Event Trace"]
        },
        friends = {
            order = 10,
            type = "toggle",
            name = L["Friend List"]
        },
        flightMap = {
            order = 10,
            type = "toggle",
            name = L["Flight Map"]
        },
        garrison = {
            order = 10,
            type = "toggle",
            name = L["Garrison"]
        },
        gossip = {
            order = 10,
            type = "toggle",
            name = L["Gossip Frame"]
        },
        guildBank = {
            order = 10,
            type = "toggle",
            name = L["Guild Bank"]
        },
        help = {
            order = 10,
            type = "toggle",
            name = L["Help Frame"]
        },
        inputMethodEditor = {
            order = 10,
            type = "toggle",
            name = L["Input Method Editor"]
        },
        inspect = {
            order = 10,
            type = "toggle",
            name = L["Inspect"]
        },
        itemInteraction = {
            order = 10,
            type = "toggle",
            name = L["Item Interaction"]
        },
        itemSocketing = {
            order = 10,
            type = "toggle",
            name = L["Item Socketing"]
        },
        itemUpgrade = {
            order = 10,
            type = "toggle",
            name = L["Item Upgrade"]
        },
        lookingForGroup = {
            order = 10,
            type = "toggle",
            name = L["Looking For Group"]
        },
        loot = {
            order = 10,
            type = "toggle",
            name = L["Loot Frames"]
        },
        lossOfControl = {
            order = 10,
            type = "toggle",
            name = L["Loss Of Control"]
        },
        macro = {
            order = 10,
            type = "toggle",
            name = L["Macros"]
        },
        mail = {
            order = 10,
            type = "toggle",
            name = L["Mail Frame"]
        },
        merchant = {
            order = 10,
            type = "toggle",
            name = L["Merchant"]
        },
        microButtons = {
            order = 10,
            type = "toggle",
            name = L["Micro Bar"]
        },
        mirrorTimers = {
            order = 10,
            type = "toggle",
            name = L["Mirror Timers"]
        },
        misc = {
            order = 10,
            type = "toggle",
            name = L["Misc Frames"]
        },
        objectiveTracker = {
            order = 10,
            type = "toggle",
            name = L["Objective Tracker"]
        },
        orderHall = {
            order = 10,
            type = "toggle",
            name = L["Orderhall"]
        },
        petBattle = {
            order = 10,
            type = "toggle",
            name = L["Pet Battle"]
        },
        playerChoice = {
            order = 10,
            type = "toggle",
            name = L["Player Choice"]
        },
        professions = {
            order = 10,
            type = "toggle",
            name = L["Professions"]
        },
        quest = {
            order = 10,
            type = "toggle",
            name = L["Quest Frames"]
        },
        raidInfo = {
            order = 10,
            type = "toggle",
            name = L["Raid Info"]
        },
        scenario = {
            order = 10,
            type = "toggle",
            name = L["Scenario"]
        },
        scrappingMachine = {
            order = 10,
            type = "toggle",
            name = L["Scrapping Machine"]
        },
        settingsPanel = {
            order = 10,
            type = "toggle",
            name = L["Setting Panel"]
        },
        soulbinds = {
            order = 10,
            type = "toggle",
            name = L["Soulbinds"]
        },
        spellBook = {
            order = 10,
            type = "toggle",
            name = L["Spell Book"]
        },
        staticPopup = {
            order = 10,
            type = "toggle",
            name = L["Static Popup"]
        },
        subscriptionInterstitial = {
            order = 10,
            type = "toggle",
            name = L["Subscription Interstitial"]
        },
        talkingHead = {
            order = 10,
            type = "toggle",
            name = L["Talking Head"]
        },
        taxi = {
            order = 10,
            type = "toggle",
            name = L["Taxi"]
        },
        ticketStatus = {
            order = 10,
            type = "toggle",
            name = L["Ticket Status"]
        },
        timeManager = {
            order = 10,
            type = "toggle",
            name = L["Stopwatch"]
        },
        tooltips = {
            order = 10,
            type = "toggle",
            name = L["Tooltips"]
        },
        trade = {
            order = 10,
            type = "toggle",
            name = L["Trade"]
        },
        trainer = {
            order = 10,
            type = "toggle",
            name = L["Trainer"]
        },
        tutorial = {
            order = 10,
            type = "toggle",
            name = L["Tutorials"]
        },
        warboard = {
            order = 10,
            type = "toggle",
            name = L["Warboard"]
        },
        weeklyRewards = {
            order = 10,
            type = "toggle",
            name = L["Weekly Rewards"]
        },
        worldMap = {
            order = 10,
            type = "toggle",
            name = L["World Map"]
        }
    }
}

for key, value in pairs(options.blizzard.args) do
    if key ~= "enable" then
        value.disabled = function()
            return not E.private.WT.skins.blizzard.enable
        end
    end
end

options.elvui = {
    order = 5,
    type = "group",
    name = L["ElvUI"],
    get = function(info)
        return E.private.WT.skins.elvui[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.skins.elvui[info[#info]] = value
        E:StaticPopup_Show("PRIVATE_RL")
    end,
    disabled = function()
        return not E.private.WT.skins.enable
    end,
    args = {
        enable = {
            order = 0,
            type = "toggle",
            name = L["Enable"]
        },
        enableAll = {
            order = 1,
            type = "execute",
            name = L["Enable All"],
            func = function()
                for key in pairs(V.skins.elvui) do
                    E.private.WT.skins.elvui[key] = true
                end
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        disableAll = {
            order = 2,
            type = "execute",
            name = L["Disable All"],
            func = function()
                for key in pairs(V.skins.elvui) do
                    if key ~= "enable" then
                        E.private.WT.skins.elvui[key] = false
                    end
                end
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        betterOption = {
            order = 3,
            type = "description",
            name = " ",
            width = "full"
        },
        actionBarsBackdrop = {
            order = 10,
            type = "toggle",
            name = L["Actionbars Backdrop"]
        },
        actionBarsButton = {
            order = 10,
            type = "toggle",
            name = L["Actionbars Button"]
        },
        afk = {
            order = 10,
            type = "toggle",
            name = L["AFK Mode"]
        },
        altPowerBar = {
            order = 10,
            type = "toggle",
            name = L["Alt Power"]
        },
        auras = {
            order = 10,
            type = "toggle",
            name = L["Auras"]
        },
        bags = {
            order = 10,
            type = "toggle",
            name = L["Bags"]
        },
        castBars = {
            order = 10,
            type = "toggle",
            name = L["Cast Bar"]
        },
        chatDataPanels = {
            order = 10,
            type = "toggle",
            name = L["Chat Data Panels"]
        },
        chatPanels = {
            order = 10,
            type = "toggle",
            name = L["Chat Panels"]
        },
        chatVoicePanel = {
            order = 10,
            type = "toggle",
            name = L["Chat Voice Panel"]
        },
        classBars = {
            order = 10,
            type = "toggle",
            name = L["Class Bars"]
        },
        chatCopyFrame = {
            order = 10,
            type = "toggle",
            name = L["Chat Copy Frame"]
        },
        dataBars = {
            order = 10,
            type = "toggle",
            name = L["Data Bars"]
        },
        dataPanels = {
            order = 10,
            type = "toggle",
            name = L["Data Panels"]
        },
        miniMap = {
            order = 10,
            type = "toggle",
            name = L["Minimap"]
        },
        option = {
            order = 10,
            type = "toggle",
            name = L["Options"]
        },
        panels = {
            order = 10,
            type = "toggle",
            name = L["Panels"]
        },
        raidUtility = {
            order = 10,
            type = "toggle",
            name = L["Raid Utility"]
        },
        staticPopup = {
            order = 10,
            type = "toggle",
            name = L["Static Popup"]
        },
        statusReport = {
            order = 10,
            type = "toggle",
            name = L["Status Report"]
        },
        totemBar = {
            order = 10,
            type = "toggle",
            name = L["Totem Bar"]
        },
        unitFrames = {
            order = 10,
            type = "toggle",
            name = L["UnitFrames"]
        }
    }
}

for key, value in pairs(options.elvui.args) do
    if key ~= "enable" then
        value.disabled = function()
            return not E.private.WT.skins.elvui.enable
        end
    end
end

-- If the skin is in development, add this: .." |cffff3860["..L["Test"].."]|r"
options.addons = {
    order = 6,
    type = "group",
    name = L["Addons"],
    get = function(info)
        return E.private.WT.skins.addons[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.skins.addons[info[#info]] = value
        E:StaticPopup_Show("PRIVATE_RL")
    end,
    disabled = function()
        return not E.private.WT.skins.enable
    end,
    args = {
        enableAll = {
            order = 1,
            type = "execute",
            name = L["Enable All"],
            func = function()
                for key in pairs(V.skins.addons) do
                    E.private.WT.skins.addons[key] = true
                end
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        disableAll = {
            order = 2,
            type = "execute",
            name = L["Disable All"],
            func = function()
                for key in pairs(V.skins.addons) do
                    E.private.WT.skins.addons[key] = false
                end
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        descGroup = {
            order = 3,
            type = "group",
            name = " ",
            inline = true,
            args = {
                desc = {
                    order = 1,
                    type = "description",
                    name = format(
                        "|cffff3860%s|r %s",
                        L["Notice"],
                        L["Skins only work if you installed and loaded the addon."]
                    ),
                    width = "full",
                    fontSize = "medium"
                }
            }
        },
        betterOption = {
            order = 9,
            type = "description",
            name = " ",
            width = "full"
        },
        ace3 = {
            order = 10,
            type = "toggle",
            name = L["Ace3"],
            width = 1.5
        },
        ace3DropdownBackdrop = {
            order = 10,
            type = "toggle",
            name = L["Ace3 Dropdown Backdrop"],
            width = 1.5
        },
        angryKeystones = {
            order = 10,
            type = "toggle",
            name = L["Angry Keystones"],
            addonName = "AngryKeystones"
        },
        bigWigs = {
            order = 10,
            type = "toggle",
            name = L["BigWigs"],
            addonName = "BigWigs"
        },
        bigWigsQueueTimer = {
            order = 10,
            type = "toggle",
            name = L["BigWigs Queue Timer"],
            addonName = "BigWigs"
        },
        bugSack = {
            order = 10,
            type = "toggle",
            name = L["BugSack"],
            addonName = "BugSack",
            addonskinsKey = "BugSack"
        },
        hekili = {
            order = 10,
            type = "toggle",
            name = L["Hekili"],
            addonName = "Hekili",
            addonskinsKey = "Hekili"
        },
        immersion = {
            order = 10,
            type = "toggle",
            name = L["Immersion"],
            addonName = "Immersion",
            addonskinsKey = "Immersion"
        },
        meetingStone = {
            order = 10,
            type = "toggle",
            name = L["NetEase Meeting Stone"],
            addonName = {"MeetingStone", "MeetingStonePlus"}
        },
        myslot = {
            order = 10,
            type = "toggle",
            name = L["Myslot"],
            addonName = "Myslot"
        },
        mythicDungeonTools = {
            order = 10,
            type = "toggle",
            name = L["Mythic Dungeon Tools"],
            addonName = "MythicDungeonTools"
        },
        premadeGroupsFilter = {
            order = 10,
            type = "toggle",
            name = L["Premade Groups Filter"],
            addonName = "PremadeGroupsFilter",
            addonskinsKey = "PremadeGroupsFilter"
        },
        -- rematch = {
        --     order = 10,
        --     type = "toggle",
        --     name = L["Rematch"],
        --     addonName = "Rematch"
        -- },
        tinyInspect = {
            order = 10,
            type = "toggle",
            name = L["TinyInspect"],
            addonName = "TinyInspect",
            addonskinsKey = "TinyInspect"
        },
        tldrMissions = {
            order = 10,
            type = "toggle",
            name = L["TLDR Missions"],
            addonName = "TLDRMissions"
        },
        tomCats = {
            order = 10,
            type = "toggle",
            name = L["TomCat's Tours"],
            addonName = "TomCats"
        },
        warpDeplete = {
            order = 10,
            type = "toggle",
            name = L["WarpDeplete"],
            addonName = "WarpDeplete"
        },
        weakAuras = {
            order = 10,
            type = "toggle",
            name = L["WeakAuras"],
            addonName = "WeakAuras"
        },
        weakAurasOptions = {
            order = 10,
            type = "toggle",
            name = L["WeakAuras Options"],
            addonName = "WeakAuras"
        }
    }
}

-- TODO: Remove after fix work done
local fixingAddonList = {
    ["TinyInspect"] = true,
    ["AngryKeystones"] = true,
    ["PremadeGroupsFilter"] = true,
    ["REHack"] = true
}

-- TODO: Remove after fix work done
local function isInFixing(name)
    if type(name) == "table" then
        name = name[1]
    end
    return fixingAddonList[name]
end

local function GenerateAddOnSkinsGetFunction(name)
    if type(name) == "string" then
        return function(info)
            return IsAddOnLoaded(name) and E.private.WT.skins.addons[info[#info]]
        end
    elseif type(name) == "table" then
        return function(info)
            local isValid = false
            for _, addon in pairs(name) do
                isValid = isValid or IsAddOnLoaded(addon)
            end
            return isValid and E.private.WT.skins.addons[info[#info]]
        end
    end
end

local function GenerateAddOnSkinsSetFunction(addonskinsKey)
    if addonskinsKey then
        return function(info, value)
            E.private.WT.skins.addons[info[#info]] = value
            if value then
                S:DisableAddOnSkin(addonskinsKey)
            end
            E:StaticPopup_Show("PRIVATE_RL")
        end
    else
        return function(info, value)
            E.private.WT.skins.addons[info[#info]] = value
            E:StaticPopup_Show("PRIVATE_RL")
        end
    end
end

local function GenerateAddOnSkinsDisabledFunction(name)
    if type(name) == "string" then
        return function(info)
            return not IsAddOnLoaded(name) or not E.private.WT.skins.enable
        end
    elseif type(name) == "table" then
        return function(info)
            local isValid = false
            for _, addon in pairs(name) do
                isValid = isValid or IsAddOnLoaded(addon)
            end
            return not isValid or not E.private.WT.skins.enable
        end
    end
end

for _, option in pairs(options.addons.args) do
    if option.addonName then
        -- TODO: Remove after fix work done
        if isInFixing(option.addonName) then
            option.name = option.name .. " |cffff0000(" .. L["Fixing"] .. ")|r"
            option.disabled = true
        else
            option.get = GenerateAddOnSkinsGetFunction(option.addonName)
            option.set = GenerateAddOnSkinsSetFunction(option.addonskinsKey)
            option.disabled = GenerateAddOnSkinsDisabledFunction(option.addonName)
        end

        option.addonName = nil
        option.addonskinsKey = nil
        option.width = 1.5
    end
end

options.widgets = {
    order = 7,
    type = "group",
    name = L["Widgets"],
    disabled = function()
        return not E.private.WT.skins.enable
    end,
    args = {
        enableAll = {
            order = 1,
            type = "execute",
            name = L["Enable All"],
            func = function()
                for key in pairs(V.skins.widgets) do
                    E.private.WT.skins.widgets[key].enable = true
                end
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        disableAll = {
            order = 2,
            type = "execute",
            name = L["Disable All"],
            func = function()
                for key in pairs(V.skins.widgets) do
                    E.private.WT.skins.widgets[key].enable = false
                end
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        descGroup = {
            order = 3,
            type = "group",
            name = " ",
            inline = true,
            args = {
                desc = {
                    order = 1,
                    type = "description",
                    name = L["These skins will affect all widgets handled by ElvUI Skins."],
                    width = "full",
                    fontSize = "medium"
                }
            }
        },
        button = {
            order = 10,
            type = "group",
            name = L["Button"],
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    width = "full",
                    get = function(info)
                        return E.private.WT.skins.widgets[info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.private.WT.skins.widgets[info[#info - 1]][info[#info]] = value
                        E:StaticPopup_Show("PRIVATE_RL")
                    end
                },
                backdrop = {
                    order = 2,
                    type = "group",
                    name = L["Additional Backdrop"],
                    inline = true,
                    get = function(info)
                        return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
                        E:StaticPopup_Show("PRIVATE_RL")
                    end,
                    disabled = function(info)
                        return not E.private.WT.skins.widgets[info[#info - 2]].enable or
                            not E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].enable
                    end,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = L["Enable"],
                            width = "full",
                            disabled = function(info)
                                return not E.private.WT.skins.widgets[info[#info - 2]].enable
                            end
                        },
                        texture = {
                            order = 2,
                            type = "select",
                            name = L["Texture"],
                            dialogControl = "LSM30_Statusbar",
                            values = LSM:HashTable("statusbar")
                        },
                        removeBorderEffect = {
                            order = 3,
                            type = "toggle",
                            name = L["Remove Border Effect"],
                            width = 1.5
                        },
                        classColor = {
                            order = 4,
                            type = "toggle",
                            name = L["Class Color"]
                        },
                        color = {
                            order = 5,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = false,
                            hidden = function(info)
                                return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].classColor
                            end,
                            get = function(info)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                            end,
                            set = function(info, r, g, b)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                db.r, db.g, db.b = r, g, b
                            end
                        },
                        alpha = {
                            order = 6,
                            type = "range",
                            name = L["Alpha"],
                            min = 0,
                            max = 1,
                            step = 0.01
                        },
                        animationType = {
                            order = 7,
                            type = "select",
                            name = L["Animation Type"],
                            desc = L["The type of animation activated when a button is hovered."],
                            hidden = true,
                            values = {
                                FADE = L["Fade"]
                            }
                        },
                        animationDuration = {
                            order = 8,
                            type = "range",
                            name = L["Animation Duration"],
                            desc = L["The duration of the animation in seconds."],
                            min = 0,
                            max = 3,
                            step = 0.01
                        }
                    }
                },
                selected = {
                    order = 3,
                    type = "group",
                    name = L["Selected Backdrop & Border"],
                    inline = true,
                    get = function(info)
                        return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
                        E:StaticPopup_Show("PRIVATE_RL")
                    end,
                    disabled = function(info)
                        return not E.private.WT.skins.widgets[info[#info - 2]].enable or
                            not E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].enable
                    end,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = L["Enable"],
                            width = "full",
                            disabled = function(info)
                                return not E.private.WT.skins.widgets[info[#info - 2]].enable
                            end
                        },
                        backdropClassColor = {
                            order = 2,
                            type = "toggle",
                            name = L["Backdrop Class Color"],
                            width = 1.5
                        },
                        backdropColor = {
                            order = 3,
                            type = "color",
                            name = L["Backdrop Color"],
                            hasAlpha = false,
                            hidden = function(info)
                                return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].backdropClassColor
                            end,
                            get = function(info)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                return db.r, db.g, db.b, nil, default.r, default.g, default.b
                            end,
                            set = function(info, r, g, b)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                db.r, db.g, db.b = r, g, b
                            end
                        },
                        backdropAlpha = {
                            order = 4,
                            type = "range",
                            name = L["Backdrop Alpha"],
                            min = 0,
                            max = 1,
                            step = 0.01
                        },
                        borderClassColor = {
                            order = 5,
                            type = "toggle",
                            name = L["Border Class Color"],
                            width = 1.5
                        },
                        borderColor = {
                            order = 6,
                            type = "color",
                            name = L["Border Color"],
                            hasAlpha = false,
                            hidden = function(info)
                                return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].borderClassColor
                            end,
                            get = function(info)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                            end,
                            set = function(info, r, g, b, a)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                db.r, db.g, db.b = r, g, b
                            end
                        },
                        borderAlpha = {
                            order = 7,
                            type = "range",
                            name = L["Border Alpha"],
                            min = 0,
                            max = 1,
                            step = 0.01
                        }
                    }
                },
                text = {
                    order = 4,
                    type = "group",
                    name = L["Text"],
                    inline = true,
                    get = function(info)
                        return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
                        E:StaticPopup_Show("PRIVATE_RL")
                    end,
                    disabled = function(info)
                        return not E.private.WT.skins.widgets[info[#info - 2]].enable or
                            not E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].enable
                    end,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = L["Enable"],
                            width = "full",
                            disabled = function(info)
                                return not E.private.WT.skins.widgets[info[#info - 2]].enable
                            end
                        },
                        font = {
                            order = 6,
                            type = "group",
                            inline = true,
                            name = L["Font Setting"],
                            disabled = function(info)
                                return not E.private.WT.skins.widgets[info[#info - 3]].enable or
                                    not E.private.WT.skins.widgets[info[#info - 3]][info[#info - 2]].enable
                            end,
                            get = function(info)
                                return E.private.WT.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]]
                            end,
                            set = function(info, value)
                                E.private.WT.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]] = value
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
                                }
                            }
                        }
                    }
                }
            }
        },
        treeGroupButton = {
            order = 11,
            type = "group",
            name = L["Tree Group Button"],
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    width = "full",
                    get = function(info)
                        return E.private.WT.skins.widgets[info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.private.WT.skins.widgets[info[#info - 1]][info[#info]] = value
                        E:StaticPopup_Show("PRIVATE_RL")
                    end
                },
                backdrop = {
                    order = 2,
                    type = "group",
                    name = L["Additional Backdrop"],
                    inline = true,
                    get = function(info)
                        return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
                        E:StaticPopup_Show("PRIVATE_RL")
                    end,
                    disabled = function(info)
                        return not E.private.WT.skins.widgets[info[#info - 2]].enable or
                            not E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].enable
                    end,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = L["Enable"],
                            width = "full",
                            disabled = function(info)
                                return not E.private.WT.skins.widgets[info[#info - 2]].enable
                            end
                        },
                        texture = {
                            order = 2,
                            type = "select",
                            name = L["Texture"],
                            dialogControl = "LSM30_Statusbar",
                            values = LSM:HashTable("statusbar")
                        },
                        classColor = {
                            order = 3,
                            type = "toggle",
                            name = L["Class Color"]
                        },
                        color = {
                            order = 4,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = false,
                            hidden = function(info)
                                return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].classColor
                            end,
                            get = function(info)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                            end,
                            set = function(info, r, g, b)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                db.r, db.g, db.b = r, g, b
                            end
                        },
                        alpha = {
                            order = 5,
                            type = "range",
                            name = L["Alpha"],
                            min = 0,
                            max = 1,
                            step = 0.01
                        },
                        animationType = {
                            order = 6,
                            type = "select",
                            name = L["Animation Type"],
                            desc = L["The type of animation activated when a button is hovered."],
                            hidden = true,
                            values = {
                                FADE = L["Fade"]
                            }
                        },
                        animationDuration = {
                            order = 7,
                            type = "range",
                            name = L["Animation Duration"],
                            desc = L["The duration of the animation in seconds."],
                            min = 0,
                            max = 3,
                            step = 0.01
                        }
                    }
                },
                selected = {
                    order = 3,
                    type = "group",
                    name = L["Selected Backdrop & Border"],
                    inline = true,
                    get = function(info)
                        return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
                        E:StaticPopup_Show("PRIVATE_RL")
                    end,
                    disabled = function(info)
                        return not E.private.WT.skins.widgets[info[#info - 2]].enable or
                            not E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].enable
                    end,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = L["Enable"],
                            width = "full",
                            disabled = function(info)
                                return not E.private.WT.skins.widgets[info[#info - 2]].enable
                            end
                        },
                        texture = {
                            order = 2,
                            type = "select",
                            name = L["Texture"],
                            dialogControl = "LSM30_Statusbar",
                            values = LSM:HashTable("statusbar")
                        },
                        backdropClassColor = {
                            order = 3,
                            type = "toggle",
                            name = L["Backdrop Class Color"],
                            width = 1.5
                        },
                        backdropColor = {
                            order = 4,
                            type = "color",
                            name = L["Backdrop Color"],
                            hasAlpha = false,
                            hidden = function(info)
                                return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].backdropClassColor
                            end,
                            get = function(info)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                            end,
                            set = function(info, r, g, b)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                db.r, db.g, db.b = r, g, b
                            end
                        },
                        backdropAlpha = {
                            order = 5,
                            type = "range",
                            name = L["Backdrop Alpha"],
                            min = 0,
                            max = 1,
                            step = 0.01
                        },
                        borderClassColor = {
                            order = 6,
                            type = "toggle",
                            name = L["Border Class Color"],
                            width = 1.5
                        },
                        borderColor = {
                            order = 7,
                            type = "color",
                            name = L["Border Color"],
                            hasAlpha = false,
                            hidden = function(info)
                                return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].borderClassColor
                            end,
                            get = function(info)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                            end,
                            set = function(info, r, g, b)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                db.r, db.g, db.b = r, g, b
                            end
                        },
                        borderAlpha = {
                            order = 8,
                            type = "range",
                            name = L["Border Alpha"],
                            min = 0,
                            max = 1,
                            step = 0.01
                        }
                    }
                },
                text = {
                    order = 4,
                    type = "group",
                    name = L["Text"],
                    inline = true,
                    get = function(info)
                        return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
                        E:StaticPopup_Show("PRIVATE_RL")
                    end,
                    disabled = function(info)
                        return not E.private.WT.skins.widgets[info[#info - 2]].enable or
                            not E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].enable
                    end,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = L["Enable"],
                            width = "full",
                            disabled = function(info)
                                return not E.private.WT.skins.widgets[info[#info - 2]].enable
                            end
                        },
                        normalClassColor = {
                            order = 2,
                            type = "toggle",
                            name = L["Normal Class Color"],
                            width = 1.5
                        },
                        normalColor = {
                            order = 3,
                            type = "color",
                            name = L["Normal Color"],
                            hasAlpha = false,
                            hidden = function(info)
                                return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].normalClassColor
                            end,
                            get = function(info)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                            end,
                            set = function(info, r, g, b)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                db.r, db.g, db.b = r, g, b
                            end
                        },
                        selectedClassColor = {
                            order = 4,
                            type = "toggle",
                            name = L["Selected Class Color"],
                            width = 1.5
                        },
                        selectedColor = {
                            order = 5,
                            type = "color",
                            name = L["Selected Color"],
                            hasAlpha = false,
                            hidden = function(info)
                                return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].selectedClassColor
                            end,
                            get = function(info)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                            end,
                            set = function(info, r, g, b)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                db.r, db.g, db.b = r, g, b
                            end
                        },
                        font = {
                            order = 6,
                            type = "group",
                            inline = true,
                            name = L["Font Setting"],
                            disabled = function(info)
                                return not E.private.WT.skins.widgets[info[#info - 3]].enable or
                                    not E.private.WT.skins.widgets[info[#info - 3]][info[#info - 2]].enable
                            end,
                            get = function(info)
                                return E.private.WT.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]]
                            end,
                            set = function(info, value)
                                E.private.WT.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]] = value
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
                                }
                            }
                        }
                    }
                }
            }
        },
        tab = {
            order = 12,
            type = "group",
            name = L["Tab"],
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    width = "full",
                    get = function(info)
                        return E.private.WT.skins.widgets[info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.private.WT.skins.widgets[info[#info - 1]][info[#info]] = value
                        E:StaticPopup_Show("PRIVATE_RL")
                    end
                },
                backdrop = {
                    order = 2,
                    type = "group",
                    name = L["Additional Backdrop"],
                    inline = true,
                    get = function(info)
                        return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
                        E:StaticPopup_Show("PRIVATE_RL")
                    end,
                    disabled = function(info)
                        return not E.private.WT.skins.widgets[info[#info - 2]].enable or
                            not E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].enable
                    end,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = L["Enable"],
                            width = "full",
                            disabled = function(info)
                                return not E.private.WT.skins.widgets[info[#info - 2]].enable
                            end
                        },
                        texture = {
                            order = 2,
                            type = "select",
                            name = L["Texture"],
                            dialogControl = "LSM30_Statusbar",
                            values = LSM:HashTable("statusbar")
                        },
                        classColor = {
                            order = 3,
                            type = "toggle",
                            name = L["Class Color"]
                        },
                        color = {
                            order = 4,
                            type = "color",
                            name = L["Color"],
                            hasAlpha = false,
                            hidden = function(info)
                                return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].classColor
                            end,
                            get = function(info)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                            end,
                            set = function(info, r, g, b)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                db.r, db.g, db.b = r, g, b
                            end
                        },
                        alpha = {
                            order = 5,
                            type = "range",
                            name = L["Alpha"],
                            min = 0,
                            max = 1,
                            step = 0.01
                        },
                        animationType = {
                            order = 6,
                            type = "select",
                            name = L["Animation Type"],
                            desc = L["The type of animation activated when a button is hovered."],
                            hidden = true,
                            values = {
                                FADE = L["Fade"]
                            }
                        },
                        animationDuration = {
                            order = 7,
                            type = "range",
                            name = L["Animation Duration"],
                            desc = L["The duration of the animation in seconds."],
                            min = 0,
                            max = 3,
                            step = 0.01
                        }
                    }
                },
                selected = {
                    order = 3,
                    type = "group",
                    name = L["Selected Backdrop & Border"],
                    inline = true,
                    get = function(info)
                        return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
                        E:StaticPopup_Show("PRIVATE_RL")
                    end,
                    disabled = function(info)
                        return not E.private.WT.skins.widgets[info[#info - 2]].enable or
                            not E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].enable
                    end,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = L["Enable"],
                            width = "full",
                            disabled = function(info)
                                return not E.private.WT.skins.widgets[info[#info - 2]].enable
                            end
                        },
                        texture = {
                            order = 2,
                            type = "select",
                            name = L["Texture"],
                            dialogControl = "LSM30_Statusbar",
                            values = LSM:HashTable("statusbar")
                        },
                        backdropClassColor = {
                            order = 3,
                            type = "toggle",
                            name = L["Backdrop Class Color"],
                            width = 1.5
                        },
                        backdropColor = {
                            order = 4,
                            type = "color",
                            name = L["Backdrop Color"],
                            hasAlpha = false,
                            hidden = function(info)
                                return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].backdropClassColor
                            end,
                            get = function(info)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                return db.r, db.g, db.b, nil, default.r, default.g, default.b
                            end,
                            set = function(info, r, g, b)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                db.r, db.g, db.b = r, g, b
                            end
                        },
                        backdropAlpha = {
                            order = 5,
                            type = "range",
                            name = L["Backdrop Alpha"],
                            min = 0,
                            max = 1,
                            step = 0.01
                        },
                        borderClassColor = {
                            order = 6,
                            type = "toggle",
                            name = L["Border Class Color"],
                            width = 1.5
                        },
                        borderColor = {
                            order = 7,
                            type = "color",
                            name = L["Border Color"],
                            hasAlpha = false,
                            hidden = function(info)
                                return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].borderClassColor
                            end,
                            get = function(info)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                            end,
                            set = function(info, r, g, b, a)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                db.r, db.g, db.b = r, g, b
                            end
                        },
                        borderAlpha = {
                            order = 8,
                            type = "range",
                            name = L["Border Alpha"],
                            min = 0,
                            max = 1,
                            step = 0.01
                        }
                    }
                },
                text = {
                    order = 4,
                    type = "group",
                    name = L["Text"],
                    inline = true,
                    get = function(info)
                        return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                    end,
                    set = function(info, value)
                        E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]] = value
                        E:StaticPopup_Show("PRIVATE_RL")
                    end,
                    disabled = function(info)
                        return not E.private.WT.skins.widgets[info[#info - 2]].enable or
                            not E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].enable
                    end,
                    args = {
                        enable = {
                            order = 1,
                            type = "toggle",
                            name = L["Enable"],
                            width = "full",
                            disabled = function(info)
                                return not E.private.WT.skins.widgets[info[#info - 2]].enable
                            end
                        },
                        normalClassColor = {
                            order = 2,
                            type = "toggle",
                            name = L["Normal Class Color"],
                            width = 1.5
                        },
                        normalColor = {
                            order = 3,
                            type = "color",
                            name = L["Normal Color"],
                            hasAlpha = false,
                            hidden = function(info)
                                return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].normalClassColor
                            end,
                            get = function(info)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                            end,
                            set = function(info, r, g, b)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                db.r, db.g, db.b = r, g, b
                            end
                        },
                        selectedClassColor = {
                            order = 4,
                            type = "toggle",
                            name = L["Selected Class Color"],
                            width = 1.5
                        },
                        selectedColor = {
                            order = 5,
                            type = "color",
                            name = L["Selected Color"],
                            hasAlpha = false,
                            hidden = function(info)
                                return E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]].selectedClassColor
                            end,
                            get = function(info)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                local default = V.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
                            end,
                            set = function(info, r, g, b)
                                local db = E.private.WT.skins.widgets[info[#info - 2]][info[#info - 1]][info[#info]]
                                db.r, db.g, db.b = r, g, b
                            end
                        },
                        font = {
                            order = 6,
                            type = "group",
                            inline = true,
                            name = L["Font Setting"],
                            disabled = function(info)
                                return not E.private.WT.skins.widgets[info[#info - 3]].enable or
                                    not E.private.WT.skins.widgets[info[#info - 3]][info[#info - 2]].enable
                            end,
                            get = function(info)
                                return E.private.WT.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]]
                            end,
                            set = function(info, value)
                                E.private.WT.skins.widgets[info[#info - 3]][info[#info - 2]].font[info[#info]] = value
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
                                }
                            }
                        }
                    }
                }
            }
        },
        checkBox = {
            order = 13,
            type = "group",
            name = L["Check Box"],
            get = function(info)
                return E.private.WT.skins.widgets[info[#info - 1]][info[#info]]
            end,
            set = function(info, value)
                E.private.WT.skins.widgets[info[#info - 1]][info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    width = "full"
                },
                desc = {
                    order = 2,
                    type = "description",
                    name = "|cffff3860" ..
                        L["To enable this feature, you need to enable the check box skin in ElvUI Skins first."] .. "|r",
                    hidden = function(info)
                        return E.private.skins.checkBoxSkin
                    end
                },
                texture = {
                    order = 3,
                    type = "select",
                    name = L["Texture"],
                    dialogControl = "LSM30_Statusbar",
                    values = LSM:HashTable("statusbar"),
                    disabled = function(info)
                        return not E.private.WT.skins.widgets[info[#info - 1]].enable
                    end
                },
                classColor = {
                    order = 4,
                    type = "toggle",
                    name = L["Class Color"],
                    disabled = function(info)
                        return not E.private.WT.skins.widgets[info[#info - 1]].enable
                    end
                },
                color = {
                    order = 5,
                    type = "color",
                    name = L["Color"],
                    hasAlpha = true,
                    disabled = function(info)
                        return not E.private.WT.skins.widgets[info[#info - 1]].enable
                    end,
                    hidden = function(info)
                        return E.private.WT.skins.widgets[info[#info - 1]].classColor
                    end,
                    get = function(info)
                        local db = E.private.WT.skins.widgets[info[#info - 1]][info[#info]]
                        local default = V.skins.widgets[info[#info - 1]][info[#info]]
                        return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
                    end,
                    set = function(info, r, g, b, a)
                        local db = E.private.WT.skins.widgets[info[#info - 1]][info[#info]]
                        db.r, db.g, db.b, db.a = r, g, b, a
                    end
                }
            }
        },
        slider = {
            order = 14,
            type = "group",
            name = L["Slider"],
            get = function(info)
                return E.private.WT.skins.widgets[info[#info - 1]][info[#info]]
            end,
            set = function(info, value)
                E.private.WT.skins.widgets[info[#info - 1]][info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    width = "full"
                },
                texture = {
                    order = 2,
                    type = "select",
                    name = L["Texture"],
                    dialogControl = "LSM30_Statusbar",
                    values = LSM:HashTable("statusbar"),
                    disabled = function(info)
                        return not E.private.WT.skins.widgets[info[#info - 1]].enable
                    end
                },
                classColor = {
                    order = 3,
                    type = "toggle",
                    name = L["Class Color"],
                    disabled = function(info)
                        return not E.private.WT.skins.widgets[info[#info - 1]].enable
                    end
                },
                color = {
                    order = 4,
                    type = "color",
                    name = L["Color"],
                    hasAlpha = true,
                    disabled = function(info)
                        return not E.private.WT.skins.widgets[info[#info - 1]].enable
                    end,
                    hidden = function(info)
                        return E.private.WT.skins.widgets[info[#info - 1]].classColor
                    end,
                    get = function(info)
                        local db = E.private.WT.skins.widgets[info[#info - 1]][info[#info]]
                        local default = V.skins.widgets[info[#info - 1]][info[#info]]
                        return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
                    end,
                    set = function(info, r, g, b, a)
                        local db = E.private.WT.skins.widgets[info[#info - 1]][info[#info]]
                        db.r, db.g, db.b, db.a = r, g, b, a
                    end
                }
            }
        }
    }
}
