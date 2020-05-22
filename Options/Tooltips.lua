local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.tooltips.args
local T = W:GetModule("Tooltips")

options.general = {
    order = 1,
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
        desc = {
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
        },
        icon = {
            order = 2,
            type = "toggle",
            name = L["Add Icon"],
            desc = L["Show an icon for items and spells."],
        }
    }
}