local W, F, E, L, V, P, G = unpack(select(2, ...))

-- 设定类别
W.options = {
    item = {
        order = 101,
        name = L["Item"],
        desc = L["Add a lot of QoL features to WoW."],
        icon = W.Media.Icons.item,
        args = {}
    },
    combat = {
        order = 102,
        name = L["Combat"],
        desc = L["Make combat more interesting."],
        icon = W.Media.Icons.combat,
        args = {}
    },
    maps = {
        order = 103,
        name = L["Maps"],
        desc = L["Add some useful features for maps."],
        icon = W.Media.Icons.map,
        args = {}
    },
    quest = {
        order = 104,
        name = L["Quest"],
        desc = L["Make adventure life easier."],
        icon = W.Media.Icons.map,
        args = {}
    },
    social = {
        order = 105,
        name = L["Social"],
        desc = L["Make some enhancements on chat and friend frames."],
        icon = W.Media.Icons.chat,
        args = {}
    },
    tooltips = {
        order = 106,
        name = L["Tooltips"],
        desc = L["Add some additional information to your tooltips."],
        icon = W.Media.Icons.tooltips,
        args = {}
    },
    skins = {
        order = 107,
        name = L["Skins"],
        desc = L["Apply new shadow style for ElvUI."],
        icon = W.Media.Icons.skins,
        args = {}
    },
    misc = {
        order = 107,
        name = L["Misc"],
        desc = L["Miscellaneous modules."],
        icon = W.Media.Icons.misc,
        args = {}
    }
}

-- ElvUI_OptionsUI 回调
function W:OptionsCallback()
    -- 标题
    local icon = F.GetIconString(W.Media.Icons.tools, 14)
    E.Options.name = E.Options.name .. " + " .. icon .. " " .. W.Title .. " " .. W.Version

    -- 设置主界面
    E.Options.args.WindUI = {
        type = "group",
        childGroups = "tree",
        name = W.Title .. " " .. W.Version,
        args = {
            logo = {
                order = 1,
                type = "description",
                name = "",
                image = function()
                    return W.Media.Textures.logo, 512, 128
                end
            }
        }
    }

    -- 模块设定
    for catagory, information in pairs(W.options) do
        E.Options.args.WindUI.args[catagory] = {
            order = information.order,
            type = "group",
            childGroups = "tab",
            name = information.name,
            desc = information.desc,
            icon = information.icon,
            args = information.args
        }
    end
end
