local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.advanced.args

local _G = _G
local format = format
local tostring = tostring
local type = type

local ReloadUI = ReloadUI

local function blue(string)
    if type(string) ~= "string" then
        string = tostring(string)
    end
    return F.CreateColorString(string, {r = 0.204, g = 0.596, b = 0.859})
end

options.core = {
    order = 1,
    type = "group",
    name = L["Core"],
    args = {
        loginMessage = {
            order = 1,
            type = "toggle",
            name = L["Login Message"],
            desc = L["The message will be shown in chat when you first login."],
            get = function(info)
                return E.global.WT.core.loginMessage
            end,
            set = function(info, value)
                E.global.WT.core.loginMessage = value
            end
        },
        compatibilityCheck = {
            order = 2,
            type = "toggle",
            name = L["Compatibility Check"],
            desc = L["Help you to enable/disable the modules for a better experience with other plugins."],
            get = function(info)
                return E.global.WT.core.compatibilityCheck
            end,
            set = function(info, value)
                E.global.WT.core.compatibilityCheck = value
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        logLevel = {
            order = 3,
            type = "select",
            name = L["Log Level"],
            desc = L["Only display log message that the level is higher than you choose."] ..
                "\n|cffff3860" .. L["Set to 2 if you do not understand the meaning of log level."] .. "|r",
            get = function(info)
                return E.global.WT.core.logLevel
            end,
            set = function(info, value)
                E.global.WT.core.logLevel = value
            end,
            hidden = function()
            end,
            values = {
                [1] = "1 - |cffff3860[ERROR]|r",
                [2] = "2 - |cffffdd57[WARNING]|r",
                [3] = "3 - |cff209cee[INFO]|r",
                [4] = "4 - |cff00d1b2[DEBUG]|r"
            }
        }
    }
}

options.gameFix = {
    order = 2,
    type = "group",
    name = L["Game Fix"],
    args = {
        cvarAlert = {
            order = 1,
            type = "toggle",
            name = L["CVar Alert"],
            desc = format(
                L["It will alert you to reload UI when you change the CVar %s."],
                "|cff209ceeActionButtonUseKeyDown|r"
            ),
            get = function(info)
                return E.global.WT.core.cvarAlert
            end,
            set = function(info, value)
                E.global.WT.core.cvarAlert = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            width = "full"
        },
        noDuplicatedParty = {
            order = 2,
            type = "toggle",
            name = L["Fix duplicated party in lfg frame"],
            desc = L["Fix the bug that you will see duplicated party in lfg frame."],
            get = function(info)
                return E.global.WT.core.noDuplicatedParty
            end,
            set = function(info, value)
                E.global.WT.core.noDuplicatedParty = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            width = "full"
        },
        fixPlaystyle = {
            order = 3,
            type = "toggle",
            name = L["Fix PlaystyleString Lua Error"],
            desc = L["Fix the bug that you will see Lua error when you using LFG frame."],
            get = function(info)
                return E.global.WT.core.fixPlaystyle
            end,
            set = function(info, value)
                E.global.WT.core.fixPlaystyle = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            width = "full"
        }
    }
}

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
    order = 3,
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
            name = blue(L["Announcement"]),
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
            name = blue(L["Combat"]),
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
                },
                covenantHelper = {
                    order = 4,
                    type = "execute",
                    name = L["Covenant Helper"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Covenant Helper"],
                            nil,
                            function()
                                E.db.WT.combat.covenantHelper = P.combat.covenantHelper
                                E.global.WT.combat.covenantHelper = G.combat.covenantHelper
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
            name = blue(L["Item"]),
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
            name = blue(L["Maps"]),
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
            name = blue(L["Quest"]),
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
            name = blue(L["Social"]),
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
            name = blue(L["Tooltips"]),
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
            name = blue(L["UnitFrames"]),
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
            name = blue(L["Skins"]),
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
            name = blue(L["Misc"]),
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
                },
                spellActivationAlert = {
                    order = 8,
                    type = "execute",
                    name = L["Spell Activation Alert"],
                    func = function()
                        E:StaticPopup_Show(
                            "WINDTOOLS_RESET_MODULE",
                            L["Spell Activation Alert"],
                            nil,
                            function()
                                E.db.WT.misc.spellActivationAlert = P.misc.spellActivationAlert
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
            "%s\n|cffff3860%s|r",
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
        order = 4,
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
