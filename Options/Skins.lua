local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.skins.args
local LSM = E.Libs.LSM
local S = W:GetModule("Skins")

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
        windtools = {
            order = 2,
            type = "toggle",
            name = L["WindTools Modules"],
            disabled = function()
                return not E.private.WT.skins.enable
            end
        },
        removeParchment = {
            order = 3,
            type = "toggle",
            name = L["Parchment Remover"],
            disabled = function()
                return not E.private.WT.skins.enable
            end
        },
        shadowColor = {
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
        achievements = {
            type = "toggle",
            name = L["Achievements"]
        },
        addonManager = {
            type = "toggle",
            name = L["AddOn Manager"]
        },
        adventureMap = {
            type = "toggle",
            name = L["Adventure Map"]
        },
        alerts = {
            type = "toggle",
            name = L["Alert Frames"]
        },
        auctionHouse = {
            type = "toggle",
            name = L["Auction House"]
        },
        azeriteEssence = {
            type = "toggle",
            name = L["Azerite Essence"]
        },
        barberShop = {
            type = "toggle",
            name = L["Barber Shop"]
        },
        blackMarket = {
            type = "toggle",
            name = L["Black Market"]
        },
        calendar = {
            type = "toggle",
            name = L["Calendar"]
        },
        challenges = {
            type = "toggle",
            name = L["Challenges"]
        },
        channels = {
            type = "toggle",
            name = L["Channels"]
        },
        character = {
            type = "toggle",
            name = L["Character"]
        },
        collections = {
            type = "toggle",
            name = L["Collections"]
        },
        communities = {
            type = "toggle",
            name = L["Communities"]
        },
        debugTools = {
            type = "toggle",
            name = L["Debug Tools"]
        },
        dressingRoom = {
            type = "toggle",
            name = L["Dressing Room"]
        },
        encounterJournal = {
            type = "toggle",
            name = L["Encounter Journal"]
        },
        friends = {
            type = "toggle",
            name = L["Friends"]
        },
        flightMap = {
            type = "toggle",
            name = L["Flight Map"]
        },
        garrison = {
            type = "toggle",
            name = L["Garrison"]
        },
        gossip = {
            type = "toggle",
            name = L["Gossip Frame"]
        },
        guildBank = {
            type = "toggle",
            name = L["Guild Bank"]
        },
        help = {
            type = "toggle",
            name = L["Help Frame"]
        },
        inputMethodEditor = {
            type = "toggle",
            name = L["Input Method Editor"]
        },
        lookingForGroup = {
            type = "toggle",
            name = L["Looking For Group"]
        },
        loot = {
            type = "toggle",
            name = L["Loot Frames"]
        },
        lossOfControl = {
            type = "toggle",
            name = L["Loss Of Control"]
        },
        macro = {
            type = "toggle",
            name = L["Macros"]
        },
        mail = {
            type = "toggle",
            name = L["Mail Frame"]
        },
        merchant = {
            type = "toggle",
            name = L["Merchant"]
        },
        microButtons = {
            type = "toggle",
            name = L["Micro Bar"]
        },
        mirrorTimers = {
            type = "toggle",
            name = L["Mirror Timers"]
        },
        misc = {
            type = "toggle",
            name = L["Misc Frames"]
        },
        objectiveTracker = {
            type = "toggle",
            name = L["Objective Tracker"]
        },
        orderHall = {
            type = "toggle",
            name = L["Orderhall"]
        },
        quest = {
            type = "toggle",
            name = L["Quest Frames"]
        },
        raidInfo = {
            type = "toggle",
            name = L["Raid Info"]
        },
        raidUtility = {
            type = "toggle",
            name = L["Raid Utility"]
        },
        scenario = {
            type = "toggle",
            name = L["Scenario"]
        },
        scrappingMachine = {
            type = "toggle",
            name = L["Scrapping Machine"]
        },
        spellBook = {
            type = "toggle",
            name = L["Spell Book"]
        },
        staticPopup = {
            type = "toggle",
            name = L["Static Popup"]
        },
        talent = {
            type = "toggle",
            name = L["Talents"]
        },
        talkingHead = {
            type = "toggle",
            name = L["Talking Head"]
        },
        taxi = {
            type = "toggle",
            name = L["Taxi"]
        },
        timeManager = {
            type = "toggle",
            name = L["Stopwatch"]
        },
        tooltips = {
            type = "toggle",
            name = L["Tooltips"]
        },
        trainer = {
            type = "toggle",
            name = L["Trainer"]
        },
        tutorial = {
            type = "toggle",
            name = L["Tutorials"]
        },
        warboard = {
            type = "toggle",
            name = L["Warboard"]
        },
        worldMap = {
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
        actionBarsBackdrop = {
            type = "toggle",
            name = L["Actionbars Backdrop"]
        },
        actionBarsButton = {
            type = "toggle",
            name = L["Actionbars Button"]
        },
        afk = {
            type = "toggle",
            name = L["AFK Mode"]
        },
        altPowerBar = {
            type = "toggle",
            name = L["Alt Power"]
        },
        auras = {
            type = "toggle",
            name = L["Auras"]
        },
        bags = {
            type = "toggle",
            name = L["Bags"]
        },
        castBars = {
            type = "toggle",
            name = L["Cast Bar"]
        },
        chatDataPanels = {
            type = "toggle",
            name = L["Chat Data Panels"]
        },
        classBars = {
            type = "toggle",
            name = L["Class Bars"]
        },
        chatCopyFrame = {
            type = "toggle",
            name = L["Chat Copy Frame"]
        },
        dataBars = {
            type = "toggle",
            name = L["Data Bars"]
        },
        miniMap = {
            type = "toggle",
            name = L["Minimap"]
        },
        option = {
            type = "toggle",
            name = L["Options"]
        },
        panels = {
            type = "toggle",
            name = L["Panels"]
        },
        staticPopup = {
            type = "toggle",
            name = L["Static Popup"]
        },
        statusReport = {
            type = "toggle",
            name = L["Status Report"]
        },
        unitFrames = {
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
        ace3 = {
            type = "toggle",
            name = L["Ace3"]
        },
        bigwigs = {
            type = "toggle",
            name = L["BigWigs"]
        },
        weakAuras = {
            type = "toggle",
            name = L["WeakAuras"]
        },
        weakAurasOptions = {
            type = "toggle",
            name = L["WeakAuras Options"]
        }
    }
}
