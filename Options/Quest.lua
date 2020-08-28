local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.quest.args
local TI = W:GetModule("TurnIn")

local pairs, print, tostring, tonumber = pairs, print, tostring, tonumber
local UnitName, UnitExists, UnitPlayerControlled = UnitName, UnitExists, UnitPlayerControlled

local customListSelected

options.turnIn = {
    order = 1,
    type = "group",
    name = L["Turn In"],
    get = function(info)
        return E.db.WT.quest.turnIn[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.quest.turnIn[info[#info]] = value
    end,
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
                    name = L["Make quest acceptance and completion automatically."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            width = "full"
        },
        selectReward = {
            order = 3,
            type = "toggle",
            name = L["Select Reward"],
            desc = L[
                "If there are multiple items in the reward list, it will select the reward with the highest sell price."
            ],
            width = 2
        },
        darkmoon = {
            order = 4,
            type = "toggle",
            name = L["Dark Moon"],
            desc = L["Accept the teleportation from Darkmoon Faire Mystic Mage automatically."],
            width = 2
        },
        followerAssignees = {
            order = 5,
            type = "toggle",
            name = L["Follower Assignees"],
            desc = L["Open the window of follower recruit automatically."],
            width = 2
        },
        rogueClassHallInsignia = {
            order = 6,
            type = "toggle",
            name = L["Rogue Class Hall Insignia"],
            desc = L["Open the passageway to rogue class hall automatically."],
            width = 2
        },
        custom = {
            order = 7,
            type = "group",
            inline = true,
            name = L["Ignored NPCs"],
            args = {
                description = {
                    order = 1,
                    type = "description",
                    name = L["If you add the NPC into the list, all automation will do not work for it."],
                    width = "full"
                },
                list = {
                    order = 2,
                    type = "select",
                    name = L["Ignore List"],
                    get = function()
                        return customListSelected
                    end,
                    set = function(_, value)
                        customListSelected = value
                    end,
                    values = function()
                        local list = E.db.WT.quest.turnIn.customIgnoreNPCs
                        local result = {}
                        for key, value in pairs(list) do
                            result[tostring(key)] = value
                        end
                        return result
                    end
                },
                addButton = {
                    order = 3,
                    type = "execute",
                    name = L["Add Target"],
                    desc = L["Make sure you select the NPC as your target."],
                    func = function()
                        if not UnitExists("target") then
                            print(L["Target is not exists."])
                            return
                        end
                        if UnitPlayerControlled("target") then
                            print(L["Target is not an NPC."])
                            return
                        end
                        local npcID = TI:GetNPCID("target")
                        if npcID then
                            local list = E.db.WT.quest.turnIn.customIgnoreNPCs
                            list[npcID] = UnitName("target")
                        end
                    end
                },
                deleteButton = {
                    order = 4,
                    type = "execute",
                    name = L["Delete"],
                    desc = L["Delete the selected NPC."],
                    func = function()
                        if customListSelected then
                            local list = E.db.WT.quest.turnIn.customIgnoreNPCs
                            list[tonumber(customListSelected)] = nil
                        end
                    end
                }
            }
        }
    }
}

options.paragonReputation = {
    order = 2,
    type = "group",
    name = L["Paragon Reputation"],
    get = function(info)
        return E.db.WT.quest.paragonReputation[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.quest.paragonReputation[info[#info]] = value
    end,
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
                    name = L["Better visualization of Paragon Factions on the Reputation Frame."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"]
        },
        reputation_panel = {
            order = 3,
            name = L["Reputation panel"],
            type = "group",
            inline = true,
            set = function(info, value)
                E.db.WT.quest.paragonReputation[info[#info]] = value
                ReputationFrame_Update()
            end,
            args = {
                color = {
                    order = 1,
                    name = L["Color"],
                    type = "color",
                    hasAlpha = false,
                    get = function(info)
                        local t = E.db.WT.quest.paragonReputation.color
                        return t.r, t.g, t.b, 1, 0, .5, .9, 1
                    end,
                    set = function(info, r, g, b)
                        local t = E.db.WT.quest.paragonReputation.color
                        t.r, t.g, t.b = r, g, b
                        ReputationFrame_Update()
                    end
                },
                text = {
                    order = 2,
                    name = L["Format"],
                    type = "select",
                    values = {
                        RAGON = L["Paragon"] .. " (100/10000)",
                        EXALTED = L["Exalted"] .. " (100/10000)",
                        CURRENT = "100 (100/10000)",
                        VALUE = "100/10000",
                        DEFICIT = "9900"
                    }
                }
            }
        },
        toast = {
            order = 4,
            name = L["Toast"],
            type = "group",
            inline = true,
            get = function(info)
                return E.db.WT.quest.paragonReputation[info[#info - 1]][info[#info]]
            end,
            set = function(info, value)
                E.db.WT.quest.paragonReputation[info[#info - 1]][info[#info]] = value
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"]
                },
                sound = {
                    order = 2,
                    type = "toggle",
                    name = L["Sound"]
                },
                fade_time = {
                    order = 3,
                    type = "range",
                    name = L["Fade time"],
                    min = 1,
                    max = 15.0,
                    step = 0.01
                }
            }
        }
    }
}
