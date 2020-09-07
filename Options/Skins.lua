local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.skins.args
local LSM = E.Libs.LSM
local S = W:GetModule("Skins")

local _G = _G

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
    args = {
        shadowColor = {
            order = 1,
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
            end
        },
        removeParchment = {
            order = 2,
            type = "toggle",
            name = L["Parchment Remover"],
            get = function()
                return E.db.WT.skins.removeParchment
            end,
            set = function(_, value)
                E.db.WT.skins.removeParchment = value
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        vignetting = {
            order = 3,
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
    args = {
        enable = {
            order = 0,
            type = "toggle",
            name = L["Enable"],
        },
        achievements = {
            type = "toggle",
            name = _G.ACHIEVEMENTS
        },
        addonManager = {
            type = "toggle",
            name = L["AddOn Manager"]
        },
        adventureMap = {
            type = "toggle",
            name = _G.ADVENTURE_MAP_TITLE
        },
        alerts = {
            type = "toggle",
            name = L["Alert Frames"]
        },
        auctionHouse = {
            type = "toggle",
            name = _G.AUCTIONS
        },
        azeriteEssence = {
            type = "toggle",
            name = L["Azerite Essence"]
        },
        barberShop = {
            type = "toggle",
            name = _G.BARBERSHOP
        },
        blackMarket = {
            type = "toggle",
            name = _G.BLACK_MARKET_AUCTION_HOUSE
        },
        calendar = {
            type = "toggle",
            name = L["Calendar"]
        },
        challenges = {
            type = "toggle",
            name = _G.CHALLENGES
        },
        channels = {
            type = "toggle",
            name = _G.CHANNELS
        },
        character = {
            type = "toggle",
            name = _G.CHARACTER
        },
        collections = {
            type = "toggle",
            name = _G.COLLECTIONS
        },
        communities = {
            type = "toggle",
            name = _G.COMMUNITIES
        },
        debugTools = {
            type = "toggle",
            name = L["Debug Tools"]
        },
        dressingRoom = {
            type = "toggle",
            name = _G.DRESSUP_FRAME
        },
        encounterJournal = {
            type = "toggle",
            name = _G.ENCOUNTER_JOURNAL
        },
        friends = {
            type = "toggle",
            name = _G.FRIENDS
        },
        flightMap = {
            type = "toggle",
            name = _G.FLIGHT_MAP
        },
        garrison = {
            type = "toggle",
            name = _G.GARRISON_LOCATION_TOOLTIP
        },
        gossip = {
            type = "toggle",
            name = L["Gossip Frame"]
        },
        help = {
            type = "toggle",
            name = L["Help Frame"]
        },
        ime = {
            type = "toggle",
            name = L["IME"]
        },
        lookingForGroup = {
            type = "toggle",
            name = _G.LFG_TITLE
        },
        loot = {
            type = "toggle",
            name = L["Loot Frames"]
        },
        lossOfControl = {
            type = "toggle",
            name = _G.LOSS_OF_CONTROL
        },
        macro = {
            type = "toggle",
            name = _G.MACROS
        },
        mail = {
            type = "toggle",
            name = L["Mail Frame"]
        },
        merchant = {
            type = "toggle",
            name = _G.MERCHANT
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
            name = _G.OBJECTIVES_TRACKER_LABEL
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
            name = _G.RAID_INFO
        },
        raidUtility = {
            type = "toggle",
            name = L["Raid Utility"]
        },
        scenario = {
            type = "toggle",
            name = _G.SCENARIOS
        },
        scrappingMachine = {
            type = "toggle",
            name = _G.SCRAPPING_MACHINE_TITLE
        },
        spellBook = {
            type = "toggle",
            name = _G.SPELLBOOK
        },
        staticPopup = {
            type = "toggle",
            name = L["Static Popup"]
        },
        talent = {
            type = "toggle",
            name = _G.TALENTS
        },
        taxi = {
            type = "toggle",
            name = _G.FLIGHT_MAP
        },
        timeManager = {
            type = "toggle",
            name = _G.STOPWATCH_TITLE
        },
        tooltips = {
            type = "toggle",
            name = L["Tooltips"]
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
            name = _G.WORLD_MAP
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
    args = {
        ace3 = {
            type = "toggle",
            name = L["Ace3"]
        },
        bigwigs = {
            type = "toggle",
            name = L["BigWigs"]
        }
    }
}
