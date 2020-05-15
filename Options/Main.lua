local W, F, E, L, V, P, G = unpack(select(2, ...))

-- 设定类别
W.options = {
    combat = {
        order = 101,
        name = L["Combat"],
        desc = L["Make combat more interesting."],
        icon = W.Media.Icons.combat,
        args = {}
    },
    item = {
        order = 102,
        name = L["Item"],
        desc = L["Make adventure life easier."],
        icon = W.Media.Icons.item,
        args = {}
    },
    maps = {
        order = 103,
        name = L["Maps"],
        desc = L["Add some useful features for maps."],
        icon = W.Media.Icons.map,
        args = {}
    },
    skins = {
        order = 104,
        name = L["Skins"],
        desc = L["Apply new shadow style for ElvUI."],
        icon = W.Media.Icons.skins,
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
