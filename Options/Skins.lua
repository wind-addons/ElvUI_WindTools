local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.skins.args
local LSM = E.Libs.LSM
local S = W:GetModule("Skins")

local pairs = pairs

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
            name = L["Enable"]
        },
        general = {
            order = 2,
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
            order = 3,
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
                color = {
                    order = 2,
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
            order = 5,
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

options.blizzard = {
    order = 3,
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
        auctionHouse = {
            order = 10,
            type = "toggle",
            name = L["Auction House"]
        },
        azeriteEssence = {
            order = 10,
            type = "toggle",
            name = L["Azerite Essence"]
        },
        barberShop = {
            order = 10,
            type = "toggle",
            name = L["Barber Shop"]
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
        collections = {
            order = 10,
            type = "toggle",
            name = L["Collections"]
        },
        communities = {
            order = 10,
            type = "toggle",
            name = L["Communities"]
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
        encounterJournal = {
            order = 10,
            type = "toggle",
            name = L["Encounter Journal"]
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
        talent = {
            order = 10,
            type = "toggle",
            name = L["Talents"]
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
        tradeSkill = {
            order = 10,
            type = "toggle",
            name = L["Trade Skill"]
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
    order = 4,
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

options.addons = {
    order = 5,
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
            order = 0,
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
            order = 1,
            type = "execute",
            name = L["Disable All"],
            func = function()
                for key in pairs(V.skins.addons) do
                    E.private.WT.skins.addons[key] = false
                end
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        betterOption = {
            order = 2,
            type = "description",
            name = " ",
            width = "full"
        },
        ace3 = {
            order = 10,
            type = "toggle",
            name = L["Ace3"]
        },
        bigWigs = {
            order = 10,
            type = "toggle",
            name = L["BigWigs"]
        },
        bugSack = {
            order = 10,
            type = "toggle",
            name = L["BugSack"]
        },
        hekili = {
            order = 10,
            type = "toggle",
            name = L["Hekili"]
        },
        immersion = {
            order = 10,
            type = "toggle",
            name = L["Immersion"]
        },
        tinyInspect = {
            order = 10,
            type = "toggle",
            name = L["TinyInspect"]
        },
        weakAuras = {
            order = 10,
            type = "toggle",
            name = L["WeakAuras"]
        },
        weakAurasOptions = {
            order = 10,
            type = "toggle",
            name = L["WeakAuras Options"]
        }
    }
}
