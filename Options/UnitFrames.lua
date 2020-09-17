local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.unitFrames.args
local CT = W:GetModule("ChatText")

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

local SampleStrings = {}
do
    local icons = ""
    icons = icons .. E:TextureString(W.Media.Icons.ffxivTank, ":16:16") .. " "
    icons = icons .. E:TextureString(W.Media.Icons.ffxivHealer, ":16:16") .. " "
    icons = icons .. E:TextureString(W.Media.Icons.ffxivDPS, ":16:16")
    SampleStrings.ffxiv = icons

    icons = ""
    icons = icons .. E:TextureString(W.Media.Icons.hexagonTank, ":16:16") .. " "
    icons = icons .. E:TextureString(W.Media.Icons.hexagonHealer, ":16:16") .. " "
    icons = icons .. E:TextureString(W.Media.Icons.hexagonDPS, ":16:16")
    SampleStrings.hexagon = icons

    icons = ""
    icons = icons .. E:TextureString(CT.cache.elvuiRoleIconsPath.Tank, ":16:16:0:0:64:64:2:56:2:56") .. " "
    icons = icons .. E:TextureString(CT.cache.elvuiRoleIconsPath.Healer, ":16:16:0:0:64:64:2:56:2:56") .. " "
    icons = icons .. E:TextureString(CT.cache.elvuiRoleIconsPath.DPS, ":16:16")
    SampleStrings.elvui = icons

    icons = ""
    icons = icons .. E:TextureString(W.Media.Icons.sunUITank, ":16:16") .. " "
    icons = icons .. E:TextureString(W.Media.Icons.sunUIHealer, ":16:16") .. " "
    icons = icons .. E:TextureString(W.Media.Icons.sunUIDPS, ":16:16")
    SampleStrings.sunui = icons
end

options.roleIcon = {
    order = 1,
    type = "group",
    name = L["Role Icon"],
    get = function(info)
        return E.private.WT.unitFrames.roleIcon[info[#info]]
    end,
    set = function(info, value)
        E.private.WT.unitFrames.roleIcon[info[#info]] = value
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
                    name = L["Change the role icon of unitframes."],
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
        roleIconStyle = {
            order = 3,
            type = "select",
            name = L["Style"],
            desc = L["Change the icons indicate the role."],
            values = {
                HEXAGON = SampleStrings.hexagon,
                FFXIV = SampleStrings.ffxiv,
                SUNUI = SampleStrings.sunui,
                DEFAULT = SampleStrings.elvui
            }
        }
    }
}
