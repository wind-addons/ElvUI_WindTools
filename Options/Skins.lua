local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.skins.args
local LSM = E.Libs.LSM

local _G = _G

options.general = {
    order = 1,
    type = "group",
    name = L["General"],
    args = {
        shadowColor = {
            order = 3,
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
        vignetting = {
            order = 2,
            type = "group",
            name = L["Vignetting"],
            get = function(info)
                return E.private.WT.skins.vignetting[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.skins.vignetting[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
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
                    min = 0.1,
                    max = 3,
                    step = 0.01
                }
            }
        }
    }
}

options.blizzard = {
    order = 2,
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
            type = "toggle",
            name = L["Enable"]
        },
        achievements = {
            type = "toggle",
            name = L["ACHIEVEMENTS"],
            desc = L["TOGGLESKIN_DESC"]
        },
        addonManager = {
            type = "toggle",
            name = L["AddOn Manager"],
            desc = L["TOGGLESKIN_DESC"]
        },
        adventureMap = {
            type = "toggle",
            name = L["ADVENTURE_MAP_TITLE"],
            desc = L["TOGGLESKIN_DESC"]
        },
        alerts = {
            type = "toggle",
            name = L["Alert Frames"],
            desc = L["TOGGLESKIN_DESC"]
        },
        auctionHouse = {
            type = "toggle",
            name = L["AUCTIONS"],
            desc = L["TOGGLESKIN_DESC"]
        },
        barberShop = {
            type = "toggle",
            name = L["BARBERSHOP"],
            desc = L["TOGGLESKIN_DESC"]
        },
        calendar = {
            type = "toggle",
            name = L["Calendar Frame"],
            desc = L["TOGGLESKIN_DESC"]
        },
        challenges = {
            type = "toggle",
            name = L["Challenges"],
            desc = L["TOGGLESKIN_DESC"]
        },
        character = {
            type = "toggle",
            name = L["Character Frame"],
            desc = L["TOGGLESKIN_DESC"]
        },
        collections = {
            type = "toggle",
            name = L["COLLECTIONS"],
            desc = L["TOGGLESKIN_DESC"]
        },
        communities = {
            type = "toggle",
            name = L["COMMUNITIES"],
            desc = L["TOGGLESKIN_DESC"]
        },
        debugTools = {
            type = "toggle",
            name = L["Debug Tools"],
            desc = L["TOGGLESKIN_DESC"]
        },
        dressingRoom = {
            type = "toggle",
            name = L["DRESSUP_FRAME"],
            desc = L["TOGGLESKIN_DESC"]
        },
        encounterJournal = {
            type = "toggle",
            name = L["ENCOUNTER_JOURNAL"],
            desc = L["TOGGLESKIN_DESC"]
        },
        friends = {
            type = "toggle",
            name = L["FRIENDS"],
            desc = L["TOGGLESKIN_DESC"]
        },
        garrison = {
            type = "toggle",
            name = L["GARRISON_LOCATION_TOOLTIP"],
            desc = L["TOGGLESKIN_DESC"]
        },
        gossip = {
            type = "toggle",
            name = L["Gossip Frame"],
            desc = L["TOGGLESKIN_DESC"]
        },
        help = {
            type = "toggle",
            name = L["Help Frame"],
            desc = L["TOGGLESKIN_DESC"]
        },
        ime = {
            type = "toggle",
            name = L["IME"],
            desc = L["TOGGLESKIN_DESC"]
        },
        lookingForGroup = {
            type = "toggle",
            name = L["LFG_TITLE"],
            desc = L["TOGGLESKIN_DESC"]
        },
        loot = {
            type = "toggle",
            name = L["Loot Frames"],
            desc = L["TOGGLESKIN_DESC"]
        },
        lossOfControl = {
            type = "toggle",
            name = L["LOSS_OF_CONTROL"],
            desc = L["TOGGLESKIN_DESC"]
        },
        macro = {
            type = "toggle",
            name = L["MACROS"],
            desc = L["TOGGLESKIN_DESC"]
        },
        mail = {
            type = "toggle",
            name = L["Mail Frame"],
            desc = L["TOGGLESKIN_DESC"]
        },
        merchant = {
            type = "toggle",
            name = L["Merchant Frame"],
            desc = L["TOGGLESKIN_DESC"]
        },
        microButtons = {
            type = "toggle",
            name = L["Micro Bar"],
            desc = L["TOGGLESKIN_DESC"]
        },
        mirrorTimers = {
            type = "toggle",
            name = L["Mirror Timers"],
            desc = L["TOGGLESKIN_DESC"]
        },
        misc = {
            type = "toggle",
            name = L["Misc Frames"],
            desc = L["TOGGLESKIN_DESC"]
        },
        objectiveTracker = {
            type = "toggle",
            name = L["OBJECTIVES_TRACKER_LABEL"],
            desc = L["TOGGLESKIN_DESC"]
        },
        orderHall = {
            type = "toggle",
            name = L["Orderhall"],
            desc = L["TOGGLESKIN_DESC"]
        },
        quest = {
            type = "toggle",
            name = L["Quest Frames"],
            desc = L["TOGGLESKIN_DESC"]
        },
        raidInfo = {
            type = "toggle",
            name = L["Raid Info"],
            desc = L["TOGGLESKIN_DESC"]
        },
        raidUtility = {
            type = "toggle",
            name = L["Enable"],
            desc = L["TOGGLESKIN_DESC"]
        },
        scenario = {
            type = "toggle",
            name = L["Scenario"],
            desc = L["TOGGLESKIN_DESC"]
        },
        spellBook = {
            type = "toggle",
            name = L["SPELLBOOK"],
            desc = L["TOGGLESKIN_DESC"]
        },
        staticPopup = {
            type = "toggle",
            name = L["Static Popup"],
            desc = L["TOGGLESKIN_DESC"]
        },
        talent = {
            type = "toggle",
            name = L["TALENTS"],
            desc = L["TOGGLESKIN_DESC"]
        },
        taxi = {
            type = "toggle",
            name = L["FLIGHT_MAP"],
            desc = L["TOGGLESKIN_DESC"]
        },
        tooltip = {
            type = "toggle",
            name = L["Tooltip"],
            desc = L["TOGGLESKIN_DESC"]
        },
        warboard = {
            type = "toggle",
            name = L["Warboard"],
            desc = L["TOGGLESKIN_DESC"]
        },
        worldMap = {
            type = "toggle",
            name = L["WORLD_MAP"],
            desc = L["TOGGLESKIN_DESC"]
        }
    }
}
