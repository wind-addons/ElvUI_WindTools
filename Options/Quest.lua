local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.quest.args

options.paragonReputation = {
    order = 1,
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
                        ["PARAGON"] = L["Paragon"] .. " (100/10000)",
                        ["EXALTED"] = L["Exalted"] .. " (100/10000)",
                        ["CURRENT"] = "100 (100/10000)",
                        ["VALUE"] = "100/10000",
                        ["DEFICIT"] = "9900"
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
