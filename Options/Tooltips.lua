local W, F, E, L, V, P, G = unpack((select(2, ...)))
local options = W.options.tooltips.args
local C = W.Utilities.Color
local T = W.Modules.Tooltips
local LFGPI = W.Utilities.LFGPlayerInfo

local format = format
local ipairs = ipairs
local pairs = pairs
local strsplit = strsplit
local tonumber = tonumber

local cache = {
	groupInfo = {},
}

options.desc = {
	order = 1,
	type = "group",
	inline = true,
	name = L["Description"],
	args = {
		feature = {
			order = 1,
			type = "description",
			name = L["Add some additional information to your tooltips."],
			fontSize = "medium",
		},
	},
}

options.general = {
	order = 2,
	type = "group",
	name = L["General"],
	get = function(info)
		return E.private.WT.tooltips[info[#info]]
	end,
	set = function(info, value)
		E.private.WT.tooltips[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		elvUITweaks = {
			order = 1,
			type = "group",
			inline = true,
			name = L["ElvUI Tooltip Tweaks"],
			get = function(info)
				return E.db.WT.tooltips[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.tooltips[info[#info - 1]][info[#info]] = value
			end,
			args = {
				forceItemLevel = {
					order = 1,
					type = "toggle",
					name = L["Force Item Level"],
					desc = L["Even you are not pressing the modifier key, the item level will still be shown."]
						.. "\n"
						.. C.StringByTemplate(L["It may broken inspect feature sometimes."], "warning"),
				},
				specIcon = {
					order = 2,
					type = "group",
					name = L["Spec Icon"],
					inline = true,
					get = function(info)
						return E.db.WT.tooltips.elvUITweaks[info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.WT.tooltips.elvUITweaks[info[#info - 1]][info[#info]] = value
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Show the icon of the specialization."],
						},
						iconWidth = {
							order = 2,
							type = "range",
							name = L["Icon Width"],
							min = 1,
							max = 50,
							step = 1,
						},
						iconHeight = {
							order = 3,
							type = "range",
							name = L["Icon Height"],
							min = 1,
							max = 50,
							step = 1,
						},
					},
				},
				raceIcon = {
					order = 3,
					type = "group",
					name = L["Race Icon"],
					inline = true,
					get = function(info)
						return E.db.WT.tooltips.elvUITweaks[info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.WT.tooltips.elvUITweaks[info[#info - 1]][info[#info]] = value
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Show the icon of the player race."],
						},
						iconWidth = {
							order = 2,
							type = "range",
							name = L["Icon Width"],
							min = 1,
							max = 50,
							step = 1,
						},
						iconHeight = {
							order = 3,
							type = "range",
							name = L["Icon Height"],
							min = 1,
							max = 50,
							step = 1,
						},
					},
				},
				betterMythicPlusInfo = {
					order = 4,
					type = "group",
					name = L["Better Mythic+ Info"],
					inline = true,
					get = function(info)
						return E.db.WT.tooltips.elvUITweaks[info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.WT.tooltips.elvUITweaks[info[#info - 1]][info[#info]] = value
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
							desc = L["Enhance ElvUI Mythic Plus info with more details."],
						},
						icon = {
							order = 2,
							type = "toggle",
							name = L["Add Icon"],
							desc = L["Show an icon for the best dungeon."],
						},
						iconWidth = {
							order = 3,
							type = "range",
							name = L["Icon Width"],
							min = 1,
							max = 50,
							step = 1,
						},
						iconHeight = {
							order = 4,
							type = "range",
							name = L["Icon Height"],
							min = 1,
							max = 50,
							step = 1,
						},
					},
				},
			},
		},
		additionalInformation = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Additional Information"],
			args = {
				modifier = {
					order = 1,
					type = "select",
					name = L["Modifier Key"],
					desc = format(L["The modifier key to show additional information from %s."], W.Title),
					set = function(info, value)
						E.private.WT.tooltips[info[#info]] = value
					end,
					values = {
						NONE = L["None"],
						SHIFT = L["Shift"],
						CTRL = L["Ctrl"],
						ALT = L["Alt"],
						ALT_SHIFT = format("%s + %s", L["Alt"], L["Shift"]),
						CTRL_SHIFT = format("%s + %s", L["Ctrl"], L["Shift"]),
						CTRL_ALT = format("%s + %s", L["Ctrl"], L["Alt"]),
						CTRL_ALT_SHIFT = format("%s + %s + %s", L["Ctrl"], L["Alt"], L["Shift"]),
					},
				},
				icon = {
					order = 2,
					type = "toggle",
					name = L["Add Icon"],
					desc = L["Show an icon for items and spells."],
				},
				factionIcon = {
					order = 3,
					type = "toggle",
					name = L["Faction Icon"],
					desc = L["Show a faction icon in the top right of tooltips."],
				},
				petIcon = {
					order = 4,
					type = "toggle",
					name = L["Pet Icon"],
					desc = L["Add an icon for indicating the type of the pet."],
				},
				petId = {
					order = 5,
					type = "toggle",
					name = L["Pet ID"],
					desc = L["Show battle pet species ID in tooltips."],
				},
				tierSet = {
					order = 6,
					type = "toggle",
					name = L["Tier Set"],
					desc = format(
						"%s\n%s",
						L["Show the number of tier set equipments."],
						F.CreateColorString(L["You need hold SHIFT to inspect someone."], E.db.general.valuecolor)
					),
				},
			},
		},
		keystone = {
			order = 3,
			type = "group",
			name = L["Keystone"],
			inline = true,
			get = function(info)
				return E.db.WT.tooltips[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.tooltips[info[#info - 1]][info[#info]] = value
			end,
			args = {
				description = {
					order = 1,
					type = "description",
					width = "full",
					name = C.StringByTemplate(
						format(
							L["The keystone information only available for players who installed Details! or %s."],
							W.Title
						),
						"warning"
					),
				},
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					desc = L["Show the keystone information in the tooltip."],
				},
				useAbbreviation = {
					order = 3,
					type = "toggle",
					name = L["Use Abbreviation"],
					desc = L["Use abbreviation for the keystone name."],
				},
				icon = {
					order = 4,
					type = "toggle",
					name = L["Add Icon"],
					desc = L["Show an icon for the keystone."],
					disabled = function()
						return not E.db.WT.tooltips.keystone.enable
					end,
				},
				iconWidth = {
					order = 5,
					type = "range",
					name = L["Icon Width"],
					min = 1,
					max = 50,
					step = 1,
					hidden = function()
						return not E.db.WT.tooltips.keystone.icon
					end,
				},
				iconHeight = {
					order = 6,
					type = "range",
					name = L["Icon Height"],
					min = 1,
					max = 50,
					step = 1,
					hidden = function()
						return not E.db.WT.tooltips.keystone.icon
					end,
				},
			},
		},
		objectiveProgressInformation = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Objective Progress"],
			args = {
				objectiveProgress = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add more details of objective progress information into tooltips."],
				},
				objectiveProgressAccuracy = {
					order = 2,
					name = L["Accuracy"],
					type = "range",
					min = 0,
					max = 5,
					step = 1,
				},
			},
		},
		healthBar = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Health Bar"],
			get = function(info)
				return E.db.WT.tooltips[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.tooltips[info[#info]] = value
			end,
			args = {
				yOffsetOfHealthBar = {
					order = 1,
					type = "range",
					name = L["Health Bar Y-Offset"],
					desc = L["Change the postion of the health bar."],
					min = -50,
					max = 50,
					step = 1,
				},
				yOffsetOfHealthText = {
					order = 2,
					type = "range",
					name = L["Health Text Y-Offset"],
					desc = L["Change the postion of the health text."],
					min = -50,
					max = 50,
					step = 1,
				},
			},
		},
		groupInfo = {
			order = 6,
			type = "group",
			inline = true,
			get = function(info)
				return E.db.WT.tooltips.groupInfo[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.tooltips.groupInfo[info[#info]] = value
			end,
			name = L["Group Info"],
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add LFG group info to tooltip."],
				},
				excludeDungeon = {
					order = 2,
					type = "toggle",
					name = L["Exclude Dungeons"],
					desc = L["It will not show the group info for dungeons."],
				},
				title = {
					order = 3,
					type = "toggle",
					name = L["Add Title"],
					desc = L["Display an additional title."],
				},
				mode = {
					order = 4,
					name = L["Mode"],
					type = "select",
					values = {
						NORMAL = L["Normal"],
						COMPACT = L["Compact"],
					},
				},
				classIconStyle = {
					order = 5,
					name = L["Class Icon Style"],
					type = "select",
					values = function()
						local result = {}
						for _, style in pairs(F.GetClassIconStyleList()) do
							local monkIcon = F.GetClassIconStringWithStyle("MONK", style)
							local druidIcon = F.GetClassIconStringWithStyle("DRUID", style)
							local evokerIcon = F.GetClassIconStringWithStyle("EVOKER", style)

							if monkIcon and druidIcon and evokerIcon then
								result[style] = format("%s %s %s", monkIcon, druidIcon, evokerIcon)
							end
						end
						return result
					end,
				},
				betterAlign1 = {
					order = 6,
					type = "description",
					name = "",
					width = "full",
				},
				template = {
					order = 7,
					type = "input",
					name = L["Template"],
					desc = L["Please click the button below to read reference."],
					width = "full",
					get = function(info)
						return cache.groupInfo.template or E.db.WT.tooltips[info[#info - 1]].template
					end,
					set = function(info, value)
						cache.groupInfo.template = value
					end,
				},
				resourcePage = {
					order = 8,
					type = "execute",
					name = F.GetWindStyleText(L["Reference"]),
					desc = format(
						"|cff00d1b2%s|r (%s)\n%s\n%s\n%s",
						L["Tips"],
						L["Editbox"],
						L["CTRL+A: Select All"],
						L["CTRL+C: Copy"],
						L["CTRL+V: Paste"]
					),
					func = function()
						if E.global.general.locale == "zhCN" or E.global.general.locale == "zhTW" then
							E:StaticPopup_Show(
								"WINDTOOLS_EDITBOX",
								nil,
								nil,
								"https://github.com/wind-addons/ElvUI_WindTools/wiki/预组建队伍玩家信息"
							)
						else
							E:StaticPopup_Show(
								"WINDTOOLS_EDITBOX",
								nil,
								nil,
								"https://github.com/wind-addons/ElvUI_WindTools/wiki/LFG-Player-Info"
							)
						end
					end,
				},
				useDefaultTemplate = {
					order = 9,
					type = "execute",
					name = L["Default"],
					func = function(info)
						E.db.WT.tooltips[info[#info - 1]].template = P.tooltips[info[#info - 1]].template
						cache.groupInfo.template = nil
					end,
				},
				applyButton = {
					order = 10,
					type = "execute",
					name = L["Apply"],
					disabled = function()
						return not cache.groupInfo.template
					end,
					func = function(info)
						E.db.WT.tooltips[info[#info - 1]].template = cache.groupInfo.template
					end,
				},
				betterAlign2 = {
					order = 11,
					type = "description",
					name = "",
					width = "full",
				},
				previewText = {
					order = 12,
					type = "description",
					name = function(info)
						LFGPI:SetClassIconStyle(E.db.WT.tooltips[info[#info - 1]].classIconStyle)
						local text =
							LFGPI:ConductPreview(cache.groupInfo.template or E.db.WT.tooltips[info[#info - 1]].template)
						return L["Preview"] .. ": " .. text
					end,
				},
			},
		},
	},
}

options.progression = {
	order = 3,
	type = "group",
	name = L["Progression"],
	get = function(info)
		return E.private.WT.tooltips.progression[info[#info]]
	end,
	set = function(info, value)
		E.private.WT.tooltips.progression[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		notice = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Notice"],
			args = {
				notice = {
					order = 1,
					type = "description",
					name = L["This feature also follows the modifier keys setting for additional information."]
						.. "\n"
						.. format(L["You can find the setting in [%s] - [Tooltips] - [General]."], W.Title),
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			desc = L["Add progression information to tooltips."],
		},
		header = {
			order = 3,
			type = "select",
			name = L["Header Style"],
			set = function(info, value)
				E.private.WT.tooltips.progression[info[#info]] = value
			end,
			values = {
				NONE = L["None"],
				TEXT = L["Text"],
				TEXTURE = L["Texture"],
			},
		},
		specialAchievement = {
			order = 4,
			type = "group",
			name = L["Special Achievements"],
			inline = true,
			get = function(info)
				return E.private.WT.tooltips.progression.specialAchievement[tonumber(info[#info])]
			end,
			set = function(info, value)
				E.private.WT.tooltips.progression.specialAchievement[tonumber(info[#info])] = value
			end,
			disabled = function()
				return not (
					E.private.WT.tooltips.progression.enable
					and E.private.WT.tooltips.progression.specialAchievement.enable
				)
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function(info)
						return E.private.WT.tooltips.progression.specialAchievement.enable
					end,
					set = function(info, value)
						E.private.WT.tooltips.progression.specialAchievement.enable = value
					end,
					disabled = function()
						return not E.private.WT.tooltips.progression.enable
					end,
				},
			},
		},
		raid = {
			order = 5,
			type = "group",
			name = L["Raid"],
			inline = true,
			get = function(info)
				return E.private.WT.tooltips.progression.raid[tonumber(info[#info])]
			end,
			set = function(info, value)
				E.private.WT.tooltips.progression.raid[tonumber(info[#info])] = value
			end,
			disabled = function()
				return not (E.private.WT.tooltips.progression.enable and E.private.WT.tooltips.progression.raid.enable)
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function(info)
						return E.private.WT.tooltips.progression.raid.enable
					end,
					set = function(info, value)
						E.private.WT.tooltips.progression.raid.enable = value
					end,
					disabled = function()
						return not E.private.WT.tooltips.progression.enable
					end,
				},
			},
		},
		mythicPlus = {
			order = 6,
			type = "group",
			name = L["Mythic Plus"],
			inline = true,
			get = function(info)
				return E.private.WT.tooltips.progression.mythicPlus[info[#info]]
			end,
			set = function(info, value)
				E.private.WT.tooltips.progression.mythicPlus[info[#info]] = value
			end,
			disabled = function()
				return not (
					E.private.WT.tooltips.progression.enable
					and E.private.WT.tooltips.progression.mythicPlus.enable
				)
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					disabled = function()
						return not E.private.WT.tooltips.progression.enable
					end,
				},
				markHighestScore = {
					order = 2,
					type = "toggle",
					name = L["Mark Highest Score"],
					desc = L["Add a small icon to indicate the highest score."],
				},
				showNoRecord = {
					order = 3,
					type = "toggle",
					name = L["Show Dungeons with No Record"],
					width = 1.5,
				},
				instances = {
					order = 4,
					type = "group",
					name = L["Instances"],
					inline = true,
					get = function(info)
						return E.private.WT.tooltips.progression.mythicPlus[tonumber(info[#info])]
					end,
					set = function(info, value)
						E.private.WT.tooltips.progression.mythicPlus[tonumber(info[#info])] = value
					end,
					args = {},
				},
			},
		},
	},
}

do
	for _, config in ipairs({
		{ target = "specialAchievement", data = W.MythicPlusSeasonAchievementData },
		{ target = "raid", data = W.RaidData },
		{ target = "mythicPlus.args.instances", data = W.MythicPlusMapData },
	}) do
		local target = options.progression.args
		for _, key in ipairs({ strsplit(".", config.target) }) do
			target = target[key]
		end

		for id, data in pairs(config.data) do
			target.args[data.idString] = {
				order = id,
				type = "toggle",
				name = format("|T%s:16:18:0:0:64:64:4:60:7:57:255:255:255|t %s", data.tex, data.name),
				width = "full",
			}
		end
	end
end
