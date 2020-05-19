local W, F, E, L, V, P, G = unpack(select(2, ...))
local options = W.options.misc.args
local LSM = E.Libs.LSM
local M = W:GetModule("Misc")

local _G = _G

local C_CVar_SetCVar, C_CVar_GetCVarBool = C_CVar.SetCVar, C_CVar.GetCVarBool

options.transmog = {
    order = 1,
    type = "group",
    name = L["Transmog"],
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
                    name = L["This module focus on enhancement of transmog."],
                    fontSize = "medium"
                }
            }
        },
        saveArtifact = {
            order = 2,
            type = "toggle",
            name = L["Save Artifact"],
            desc = L["Allow you to save outfits even if artifact in it."],
            get = function(info)
                return E.private.WT.misc[info[#info]]
            end,
            set = function(info, value)
                E.private.WT.misc[info[#info]] = value
                E:StaticPopup_Show("PRIVATE_RL")
            end
        }
    }
}

options.cvars = {
    order = 2,
    type = "group",
    name = L["CVars Editor"],
    get = function(info)
        return C_CVar_GetCVarBool(info[#info])
    end,
    set = function(info, value)
        C_CVar_SetCVar(info[#info], value and "1" or "0")
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
                    name = L["A simple editor for CVars."],
                    fontSize = "medium"
                }
            }
        },
        visualEffect = {
            order = 2,
            type = "group",
            inline = true,
            name = L["Visual Effect"],
            args = {
                ffxGlow = {
                    order = 1,
                    type = "toggle",
                    name = L["Glow Effect"]
                },
                ffxDeath = {
                    order = 2,
                    type = "toggle",
                    name = L["Death Effect"]
                },
                ffxNether = {
                    order = 3,
                    type = "toggle",
                    name = L["Nether Effect"]
                }
            }
        },
        tooltips = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Tooltips"],
            args = {
                alwaysCompareItems = {
                    order = 1,
                    type = "toggle",
                    name = L["Auto Compare"],
                },
                showQuestTrackingTooltips = {
                    order = 2,
                    type = "toggle",
                    name = L["Show Quest Info"],
                    desc = L["Add progress information (Ex. Mob 10/25)."]
                }
            }
        },
        mouse = {
            order = 4,
            type = "group",
            inline = true,
            name = L["Mouse"],
            args = {
                rawMouseEnable = {
                    order = 1,
                    type = "toggle",
                    name = L["Raw Mouse"],
                    desc = L["It will fix the problem if your cursor has abnormal movement."]
                },
                rawMouseAccelerationEnable = {
                    order = 2,
                    type = "toggle",
                    name = L["Raw Mouse Acceleration"],
                    desc = L["Changes the rate at which your mouse pointer moves based on the speed you're moving the mouse."]
                }
            }
        }
    }
}
