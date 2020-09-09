local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.unitFrames.args

options.quickFocus = {
    order = 1,
    type = "group",
    name = L["Quick Focus"],
    get = function(info)
        return E.private.WT.unitFrames.quickFocus[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.unitFrames.quickFocus[info[#info]] = value
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
                    name = L["Focus the target by modifier key + click."],
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
        modifier = {
            order = 3,
            type = "select",
            name = L["Modifier Key"],
            disabled = function()
                return not E.private.WT.unitFrames.quickFocus.enable
            end,
            values = {
                shift = L["Shift Key"],
                ctrl = L["Ctrl Key"],
                alt = L["Alt Key"]
            }
        },
        button = {
            order = 4,
            type = "select",
            name = L["Button"],
            disabled = function()
                return not E.private.WT.unitFrames.quickFocus.enable
            end,
            values = {
                BUTTON1 = L["Left Button"],
                BUTTON2 = L["Right Button"],
                BUTTON3 = L["Middle Button"],
                BUTTON4 = L["Side Button 4"],
                BUTTON5 = L["Side Button 5"]
            }
        }
    }
}
