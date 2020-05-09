local W, F, E, L, V, P, G = unpack(select(2, ...))

-- 设定类别
W.options = {
    combat = {
        order = 101,
        name = L["Combat"],
        desc = L["Make the combat more interesting."],
        icon = F.GetTexture("combat.tga", "Icons"),
        args = {}
    }
}

-- ElvUI_OptionsUI 回调
function W:OptionsCallback()
    -- 标题
    local icon = F.GetIconString(F.GetTexture("hammer.tga", "Icons"), 14)
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
                    return F.GetTexture("WindTools.blp", "Textures"), 512, 128
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
