local W, F, E, L, V, P, G = unpack(select(2, ...))
local HexToRGB = W.Utilities.Color.HexToRGB

local gsub = gsub
local pairs = pairs
local strrep = strrep
local tostring = tostring
local type = type

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
        icon = W.Media.Icons.quest,
        args = {}
    },
    social = {
        order = 105,
        name = L["Social"],
        desc = L["Make some enhancements on chat and friend frames."],
        icon = W.Media.Icons.chat,
        args = {}
    },
    announcement = {
        order = 106,
        name = L["Announcement"],
        desc = L["Send something to game automatically."],
        icon = W.Media.Icons.announcement,
        args = {}
    },
    tooltips = {
        order = 107,
        name = L["Tooltips"],
        desc = L["Add some additional information to your tooltips."],
        icon = W.Media.Icons.tooltips,
        args = {}
    },
    unitFrames = {
        order = 108,
        name = L["UnitFrames"],
        desc = L["Add more features to ElvUI UnitFrames."],
        icon = W.Media.Icons.unitFrames,
        args = {}
    },
    skins = {
        order = 109,
        name = L["Skins"],
        desc = L["Apply new shadow style for ElvUI."],
        icon = W.Media.Icons.skins,
        args = {}
    },
    misc = {
        order = 110,
        name = L["Misc"],
        desc = L["Miscellaneous modules."],
        icon = W.Media.Icons.misc,
        args = {}
    },
    advanced = {
        order = 111,
        name = L["Advanced"],
        desc = L["Advanced settings."],
        icon = W.Media.Icons.information,
        args = {}
    },
    information = {
        order = 112,
        name = L["Information"],
        desc = L["Credits & help."],
        icon = W.Media.Icons.information,
        args = {}
    }
}

local tempString = strrep("Z", 12)
local tempString =
    E:TextGradient(tempString, 0.910, 0.314, 0.357, 0.976, 0.835, 0.431, 0.953, 0.925, 0.761, 0.078, 0.694, 0.671)

local color = {}

gsub(
    tempString,
    "cff(......)Z",
    function(self)
        color[#color + 1] = self
    end
)

-- ElvUI_OptionsUI 回调
function W:OptionsCallback()
    -- 标题
    local icon = F.GetIconString(W.Media.Textures.smallLogo, 14)
    E.Options.name = E.Options.name .. " + " .. icon .. " " .. W.Title .. " |cff00d1b2" .. W.Version .. "|r"

    -- 设置主界面
    E.Options.args.WindTools = {
        type = "group",
        childGroups = "tree",
        name = icon .. " " .. W.Title,
        args = {
            beforeLogo = {
                order = 1,
                type = "description",
                fontSize = "medium",
                name = " ",
                width = "full"
            },
            logo = {
                order = 2,
                type = "description",
                name = "",
                image = function()
                    return W.Media.Textures.title, 364, 106.667
                end,
                imageCoords = F.GetTitleTexCoord
            },
            afterLogo = {
                order = 3,
                type = "description",
                fontSize = "medium",
                name = " \n ",
                width = "full"
            }
        }
    }

    -- 模块设定
    for catagory, info in pairs(W.options) do
        E.Options.args.WindTools.args[catagory] = {
            order = info.order,
            type = "group",
            childGroups = "tab",
            name = "|cff" .. color[info.order - 100] .. info.name,
            desc = info.desc,
            icon = info.icon,
            args = info.args
        }
    end
end
