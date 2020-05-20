local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.item.args
local LSM = E.Libs.LSM

local DI = W:GetModule("DeleteItem")
local AK = W:GetModule("AlreadyKnown")

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

options.alreadyKnown = {
    order = 2,
    type = "group",
    name = L["Already Known"],
    get = function(info)
        return E.db.WT.item.alreadyKnown[info[#info]]
    end,
    set = function(info, value)
        E.db.WT.item.alreadyKnown[info[#info]] = value
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
                    name = L["Puts a overlay on already known learnable items on vendors and AH."],
                    fontSize = "medium"
                }
            }
        },
        enable = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            set = function(info, value)
                E.db.WT.item.alreadyKnown[info[#info]] = value
                AK:ToggleSetting()
            end,
        },
        mode = {
            order = 3,
            name = L["Mode"],
            type = "select",
            values = {
                COLOR = L["Custom Color"],
                MONOCHROME = L["Monochrome"]
            }
        },
        color = {
            order = 4,
            type = "color",
            name = L["Color"],
            hidden = function()
                return not (E.db.WT.item.alreadyKnown.mode == "COLOR")
            end,
            hasAlpha = false,
            get = function(info)
                local db = E.db.WT.item.alreadyKnown.color
                local default = P.item.alreadyKnown.color
                return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
            end,
            set = function(info, r, g, b)
                local db = E.db.WT.item.alreadyKnown.color
                db.r, db.g, db.b = r, g, b
            end
        }
    }
}
