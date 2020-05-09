local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.combat.args

options.combatAlert = {
    order = 1,
    type = "group",
    name = L["Combat Alert"],
    desc = L["Show a alert when you enter or leave combat."],
    hidden = false,
    args = {
        enable = {
            order = 1,
            type = 'toggle',
            name = L["Enable"],
            get = function(info) return E.db.WT.combat.combatAlert.enable end,
            set = function(info, value) E.db.WT.combat.combatAlert.enable = value end,
        },
    }
}