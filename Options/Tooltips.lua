local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.tooltips.args
local T = W:GetModule("Tooltips")

local ipairs = ipairs

options.desc = {
    order = 1,
    type = "group",
    inline = true,
    name = L["Description"],
    args = {
        feature = {
            order = 1,
            type = "description",
            name = L["Add some additional information to your tooltips."],
            fontSize = "medium"
        }
    }
}

options.general = {
    order = 2,
    type = "group",
    name = L["General"],
    get = function(info)
        return E.private.WT.tooltips[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.tooltips[info[#info]] = value
        E:StaticPopup_Show("PRIVATE_RL")
    end,
    args = {
        icon = {
            order = 1,
            type = "toggle",
            name = L["Add Icon"],
            desc = L["Show an icon for items and spells."]
        },
        objectiveProgress = {
            order = 2,
            type = "toggle",
            name = L["Objective Progress"],
            desc = L["Add more details of objective progress information into tooltips."]
        }
    }
}

options.progression = {
    order = 3,
    type = "group",
    name = L["Progression"],
    get = function(info)
        return E.private.WT.tooltips.progression[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.tooltips.progression[info[#info]] = value
        E:StaticPopup_Show("PRIVATE_RL")
    end,
    args = {
        enable = {
            order = 1,
            type = "toggle",
            name = L["Enable"],
            desc = L["Add progression information to tooltips."]
        },
        raid = {
            order = 2,
            type = "group",
            name = L["Raids"],
            inline = true,
            get = function(info)
                return E.private.WT.tooltips.progression.raid[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.tooltips.progression.raid[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"]
                }
            }
        },
        dungeon = {
            order = 2,
            type = "group",
            name = L["Dungeons"],
            inline = true,
            get = function(info)
                return E.private.WT.tooltips.progression.dungeon[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.tooltips.progression.dungeon[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end,
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"]
                }
            }
        }
    }
}

local raids = {
    "Ny'alotha, The Waking City",
    "Azshara's Eternal Palace",
    "Crucible of Storms",
    "Battle of Dazaralor",
    "Uldir"
}

local dungeons = {
    "Atal'Dazar",
    "FreeHold",
    "Kings' Rest",
    "Shrine of the Storm",
    "Siege of Boralus",
    "Temple of Sethrealiss",
    "The MOTHERLODE!!",
    "The Underrot",
    "Tol Dagor",
    "Waycrest Manor",
    "Operation: Mechagon"
}

for index, raid in ipairs(raids) do
    options.progression.args.raid.args[raid] = {
        order = index + 1,
        type = "toggle",
        name = L[raid]
    }
end

for index, dungeon in ipairs(dungeons) do
    options.progression.args.dungeon.args[dungeon] = {
        order = index + 2,
        type = "toggle",
        name = L[dungeon]
    }
end
