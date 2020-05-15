local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.item.args
local LSM = E.Libs.LSM

local DI = W:GetModule("DeleteItem")

local _G = _G

options.delete = {
    order = 1,
    type = "group",
    name = L["Delete Item"],
    get = function(info)
        return E.db.WT.item.delete[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.item.delete[info[#info]] = value
        DI:ProfileUpdate()
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
                    name = L["This module provides several easy-to-use methods of deleting items."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"]
        },
        delKey = {
            order = 3,
            type = "toggle",
            name = L["Use Delete Key"],
            desc = L["Allow you to use Delete Key for confirming deleting."]
        },
        fillIn = {
            order = 4,
            name = L["Fill In"],
            type = "select",
            values = {
                NONE = L["Disable"],
                CLICK = L["Fill by click"],
                AUTO = L["Auto Fill"]
            }
        }
    }
}
