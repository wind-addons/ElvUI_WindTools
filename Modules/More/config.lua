local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")

local _G = _G
local GetCVarBool = GetCVarBool

P["WindTools"]["More Tools"] = {
	["Announce System"] = {
		["enabled"] = true,
		["Taunt"] = {
			["enabled"] = true,
			["missenabled"] = true,
			["PlayerSmart"] = false,
			["PetSmart"] = false,
			["OtherTankSmart"] = false,
			["IncludePet"] = true,
			["IncludeOtherTank"] = true,
		},
		["Interrupt"] = {
			["enabled"] = true,
			["SoloYell"] = false,
			["IncludePet"] = true,
		},
		["ResAndThreat"] = {
			["enabled"] = true,
		},
		["ResThanks"] = {
			["enabled"] = true,
		},
		["RaidUsefulSpells"] = {
			["enabled"] = true,
		},
	},
	["CVarsTool"] = {
		["enabled"] = true,
	},
	["Enhanced Blizzard Frame"] = {
		["enabled"] = true,
		["moveframe"] = true,
		["moveelvbag"] = false,
		["remember"] = true,
		["points"] = {},
		["errorframe"] = {
			["height"] = 60,
			["width"] = 512,
		},
		["vehicleSeatScale"] = 1,
	},
	["Enhanced Tag"] = {
		["enabled"] = true,
	},
	["Enter Combat Alert"] = {
		["enabled"] = true,
		["custom_text"] = {
			["enabled"] = false,
			["custom_enter_text"] = "",
			["custom_leave_text"] = "",
		},
		["style"] = {
			["font_name"] = E.db.general.font,
			["font_size"] = 28,
			["font_flag"] = "OUTLINE",
			["scale"] = 0.8,
		},
	},
	["Fast Loot"] = {
		["enabled"] = true,
		["speed"] = 0.3,
	},
}

WT.ToolConfigs["More Tools"] = {
	["Announce System"] = {
		tDesc   = L["A simply announce system."],
		oAuthor = "Shestak",
		cAuthor = "houshuu",
		["Interrupt"] = {
			order = 5,
			name = L["Interrupt"],
			args = {
				["Enable"] = {
					order = 1,
					name = L["Enable"],
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["Interrupt"]["enabled"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["Interrupt"]["enabled"] = value;E:StaticPopup_Show("PRIVATE_RL")end
				},
				["SoloYell"] = {
					order = 2,
					name = L["Solo Yell"],
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["Interrupt"]["SoloYell"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["Interrupt"]["SoloYell"] = value;E:StaticPopup_Show("PRIVATE_RL")end
				},
				["IncludePet"] = {
					order = 3,
					name = L["Include Pet"],
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["Interrupt"]["IncludePet"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["Interrupt"]["IncludePet"] = value;E:StaticPopup_Show("PRIVATE_RL")end
				},
			},
		},
		["Taunt"] = {
			order = 6,
			name = L["Taunt"],
			args = {
				["Enable"] = {
					order = 0,
					name = L["Enable"],
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["Taunt"]["enabled"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["Taunt"]["enabled"] = value;E:StaticPopup_Show("PRIVATE_RL")end
				},
				["Enable"] = {
					order = 1,
					name = L["Enable Miss"],
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["Taunt"]["missenabled"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["Taunt"]["missenabled"] = value;E:StaticPopup_Show("PRIVATE_RL")end
				},
				["PlayerSmart"] = {
					order = 2,
					name = L["Player Smart"],
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["Taunt"]["PlayerSmart"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["Taunt"]["PlayerSmart"] = value;E:StaticPopup_Show("PRIVATE_RL")end
				},
				["PetSmart"] = {
					order = 3,
					name = L["Pet Smart"],
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["Taunt"]["PetSmart"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["Taunt"]["PetSmart"] = value;E:StaticPopup_Show("PRIVATE_RL")end
				},
				["OtherTankSmart"] = {
					order = 4,
					name = L["Other Tank Smart"],
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["Taunt"]["OtherTankSmart"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["Taunt"]["OtherTankSmart"] = value;E:StaticPopup_Show("PRIVATE_RL")end
				},
				["IncludePet"] = {
					order = 5,
					name = L["Include Pet"],
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["Taunt"]["IncludePet"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["Taunt"]["IncludePet"] = value;E:StaticPopup_Show("PRIVATE_RL")end
				},
				["IncludeOthers"] = {
					order = 5,
					name = L["Include Other Tank"],
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["Taunt"]["IncludeOtherTank"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["Taunt"]["IncludeOtherTank"] = value;E:StaticPopup_Show("PRIVATE_RL")end
				},
			},
		},
		["ResAndThreat"] = {
			order = 7,
			name = L["Res And Threat"],
			args = {
				["Enable"] = {
					order = 1,
					name = L["Enable"],
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["ResAndThreat"]["enabled"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["ResAndThreat"]["enabled"] = value;E:StaticPopup_Show("PRIVATE_RL")end
				},
			},
		},
		["ResThanks"] = {
			order = 8,
			name = L["Res Thanks"],
			args = {
				["Enable"] = {
					order = 1,
					name = L["Enable"],
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["ResThanks"]["enabled"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["ResThanks"]["enabled"] = value;E:StaticPopup_Show("PRIVATE_RL")end
				},
			},
		},
		["RaidUsefulSpells"] = {
			order = 9,
			name = L["Raid Useful Spells"],
			args = {
				["Enable"] = {
					order = 1,
					name = L["Enable"],
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["RaidUsefulSpells"]["enabled"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["RaidUsefulSpells"]["enabled"] = value;E:StaticPopup_Show("PRIVATE_RL")end
				},
			},
		},
	},
	["CVarsTool"] = {
		tDesc   = L["Setting CVars easily."],
		oAuthor = "houshuu",
		cAuthor = "houshuu",
		["effect_control"] = {
			order = 5,
			name = L["Effect Control"],
			get = function(info) return GetCVarBool(info[#info]) end,
			set = function(info, value) E:GetModule('Wind_CVarsTool').SetCVarBool(info[#info], value) end,
			args = {
				["ffxGlow"] = {
					order = 1,
					name = L["Glow Effect"],
				},
				["ffxDeath"] = {
					order = 2,
					name = L["Death Effect"],
				},
				["ffxNether"] = {
					order = 3,
					name = L["Nether Effect"],
				},
			},
		},
		["convenience"] = {
			order = 6,
			name = L["Convenient Setting"],
			get = function(info) return GetCVarBool(info[#info]) end,
			set = function(info, value) E:GetModule('Wind_CVarsTool').SetCVarBool(info[#info], value) end,
			args = {
				["alwaysCompareItems"] = {
					order = 1,
					name = L["Auto Compare"],
				},
				["showQuestTrackingTooltips"] = {
					order = 2,
					width = "double",
					name = L["Tooltips quest info"],
				},
			},
		},
		["fix"] = {
			order = 7,
			name = L["Fix Problem"],
			get = function(info) return GetCVarBool(info[#info]) end,
			set = function(info, value) E:GetModule('Wind_CVarsTool').SetCVarBool(info[#info], value) end,
			args = {
				["rawMouseEnable"] = {
					order = 1,
					width = "double",
					name = L["Raw Mouse"],
				},
				["rawMouseAccelerationEnable"]  = {
					order = 2,
					width = "double",
					name = L["Raw Mouse Acceleration"],
				},
			},
		},
		func = function()
			-- 替換原有的開關位置
			E.Options.args.WindTools.args["More Tools"].args["CVarsTool"].args["enablebtn"] = nil
		end,
	},
	["Enter Combat Alert"] = {
		tDesc   = L["Alert you after enter or leave combat."],
		oAuthor = "loudsoul",
		cAuthor = "houshuu",
		["style"] = {
			order = 5,
			name = L["Style"],
			get = function(info) return E.db.WindTools["More Tools"]["Enter Combat Alert"]["style"][info[#info]] end,
			set = function(info, value) E.db.WindTools["More Tools"]["Enter Combat Alert"]["style"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {
				["font_name"] = {
					order = 1,
					type = 'select', dialogControl = 'LSM30_Font',
					name = L['Font'],
					values = LSM:HashTable('font'),
				},
				["font_flag"] = {
					order = 2,
					type = 'select',
					name = L["Font Outline"],
					values = {
						['NONE'] = L['None'],
						['OUTLINE'] = L['OUTLINE'],
						['MONOCHROME'] = L['MONOCHROME'],
						['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
						['THICKOUTLINE'] = L['THICKOUTLINE'],
					},
				},
				["font_size"] = {
					order = 3,
					name = L["Size"],
					type = 'range',
					min = 5, max = 60, step = 1,
				},
				["scale"] = {
					order = 4,
					type = "range",
					name = L["Scale"],
					desc = L["Default is 0.8"],
					min = 0.1, max = 2.0, step = 0.01,
				},
			},
		},
		["custom_text"] = {
			order = 6,
			name = L["Custom Text"],
			get = function(info) return E.db.WindTools["More Tools"]["Enter Combat Alert"]["custom_text"][info[#info]] end,
			set = function(info, value) E.db.WindTools["More Tools"]["Enter Combat Alert"]["custom_text"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {
				["enabled"] = {
					order = 1,
					name = L["Enable"],
				},
				["custom_enter_combat"] = {
					order = 2,
					type = "input",
					name = L["Custom Text (Enter)"],
					width = 'full',
					disabled = function(info) return not E.db.WindTools["More Tools"]["Enter Combat Alert"]["custom_text"] end,
				},
				["custom_leave_combat"] = {
					order = 3,
					type = "input",
					disabled = function(info) return not E.db.WindTools["More Tools"]["Enter Combat Alert"]["custom_text"] end,
					name = L["Custom Text (Leave)"],
					width = 'full',
				},
			},
		},
	},
	["Fast Loot"] = {
		tDesc   = L["Let auto-loot quickly."],
		oAuthor = "Leatrix",
		cAuthor = "houshuu",
		["setspeed"] = {
			order = 5,
			type = "range",
			name = L["Fast Loot Speed"],
			min = 0.1, max = 0.5, step = 0.1,
			get = function(info) return E.db.WindTools["More Tools"]["Fast Loot"]["speed"] end,
			set = function(info, value) E.db.WindTools["More Tools"]["Fast Loot"]["speed"] = value;end
		},
		["setspeeddesc"] = {
			order = 6,
			type = "description",
			name = L["Default is 0.3, DO NOT change it unless Fast Loot is not worked."],
		},
	},
	["Enhanced Blizzard Frame"] = {
		tDesc   = L["Move frames and set scale of buttons."],
		oAuthor = "ElvUI S&L",
		cAuthor = "houshuu",
		["moveframes"] = {
			order = 5,
			name = L["Move Frames"],
			get = function(info) return E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"][ info[#info] ] end,
			set = function(info, value) E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"][ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {
				["moveframe"] = {
					order = 1,
					name = L["Move Blizzard Frame"],
				},
				["moveelvbag"] = {
					order = 2,
					name = L["Move ElvUI Bag"],
					disabled = function(info) return not E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].enabled or not E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"]["moveframe"] end,
				},
				["remember"] = {
					order = 3,
					name = L["Remember Position"],
					disabled = function(info) return not E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].enabled or not E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"]["moveframe"] end,
				},
			},
		},
		["errorframe"] = {
			order = 6,
			name = L["Error Frame"],
			get = function(info) return E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].errorframe[ info[#info] ] end,
			set = function(info, value) E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"].errorframe[ info[#info] ] = value; E:GetModule("Wind_EnhancedBlizzardFrame"):ErrorFrameSize() end,
			args = {
				["width"] = {
					order = 1,
					name = L["Width"],
					type = "range",
					min = 100, max = 1000, step = 1,
				},
				["height"] = {
					order = 2,
					name = L["Height"],
					type = "range",
					min = 30, max = 300, step = 15,
				},
			},
		},
		["others"] = {
			order = 7,
			name = L["Other Setting"],
			args = {
				["vehicleSeatScale"] = {
					order = 1,
					type = 'range',
					name = L["Vehicle Seat Scale"],
					min = 0.1, max = 3, step = 0.01,
					isPercent = true,
					get = function(info) return E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"][ info[#info] ] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Enhanced Blizzard Frame"][ info[#info] ] = value; E:GetModule("Wind_EnhancedBlizzardFrame"):VehicleScale() end,
				},
			},
		},
	},
	["Enhanced Tag"] = {
		tDesc   = L["Add some tags."],
		oAuthor = "houshuu",
		cAuthor = "houshuu",
		["desc0"] = {
			order = 5,
			type = "description",
			name = "\n",
		},
		["health"] = {
			order = 6,
			name = L["Health"],
			guiInline = true,
			args = {
				["percentshort"] = {
					order = 1,
					type = "description",
					name = "[health:percent-short] "..L["Example:"].."10% / "..L["Dead"],
				},
				["percentshortnostatus"] = {
					order = 2,
					type = "description",
					name = "[health:percent-short-nostatus] "..L["Example:"].."10% / 0%",
				},
				["percentnosymbol"] = {
					order = 3,
					type = "description",
					name = "[health:percent-nosymbol] "..L["Example:"].."10 / "..L["Dead"],
				},
				["percentnosymbolnostatus"] = {
					order = 4,
					type = "description",
					name = "[health:percent-nosymbol-nostatus] "..L["Example:"].."10 / 0",
				},
				["currentpercentshort"] = {
					order = 5,
					type = "description",
					name = "[health:current-percent-short] "..L["Example:"].."1120 - 10% / "..L["Dead"],
				},
				["currentpercentshortnostatus"] = {
					order = 6,
					type = "description",
					name = "[health:current-percent-short-nostatus] "..L["Example:"].."1120 - 10% / 0 - 0%",
				},
			},
		},
		["power"] = {
			order = 7,
			name = L["Power"],
			args = {
				["desc4"] = {
					order = 1,
					type = "description",
					name = "[power:percent-short] "..L["Example:"].."10%",
				},
				["desc5"] = {
					order = 2,
					type = "description",
					name = "[power:percent-nosymbol] "..L["Example:"].."10",
				},
				["desc6"] = {
					order = 3,
					type = "description",
					name = "[power:current-percent-short] "..L["Example:"].."1120 - 10%",
				},
			},
		},
		func = function()
			E.Options.args.WindTools.args["More Tools"].args["Enhanced Tag"].args["enablebtn"].name = L["Chinese W/Y"]
		end,
	},
}