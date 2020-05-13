local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.maps.args
local LSM = E.Libs.LSM
local WM = W:GetModule("WorldMap")

local _G = _G

options.worldMap = {
    order = 1,
    type = "group",
    name = L["World Map"],
    args = {
        reveal = {
            order = 1,
            type = "toggle",
            name = L["Reveal Fog"],
            desc = L["Remove Fog of War on your world map."],
            get = function(info)
                return E.private.WT.maps.worldMap[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.maps.worldMap[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end
        },
        scale = {
            order = 2,
            type = "range",
            name = L["Scale"],
            desc = L["Resize world map."],
            get = function(info)
                return E.db.WT.maps.worldMap[info[#info]]
            end,
            set = function(info, value)
                E.db.WT.maps.worldMap[info[#info]] = value
                WM:UpdateScale()
            end,
            min = 0.1,
            max = 3,
            step = 0.01
        }
    }
}
