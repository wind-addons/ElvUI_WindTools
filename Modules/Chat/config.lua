local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")
local _G = _G

P["WindTools"]["Chat"] = {
	["Tab Chat Mod"] = {
		enabled = true,
		whisper_cycle = false,
		use_yell = false,
		use_battleground = false,
		use_raid_warning = false,
		use_officer = false,
	},
	["Enhanced Friend List"] = {
		["enabled"] = true,
		["color_name"] = true,
		["enhanced"] = {
			["enabled"] = true,
			["NameFont"] = E.db.general.font,
			["NameFontSize"] = 13,
			["NameFontFlag"] = "OUTLINE",
			["InfoFont"] = E.db.general.font,
			["InfoFontSize"] = 12,
			["InfoFontFlag"] = "OUTLINE",
			["StatusIconPack"] = "D3",
			["GameIcon"] = {
				["App"] = "Launcher",
				["Alliance"] = "Launcher",
				["Horde"] = "Launcher",
				["Neutral"] = "Launcher",
				["D3"] = "Launcher",
				["WTCG"] = "Launcher",
				["S1"] = "Launcher",
				["S2"] = "Launcher",
				["BSAp"] = "Launcher",
				["Hero"] = "Launcher",
				["Pro"] = "Launcher",
				["DST2"] = "Launcher",
			}
		}
	},
	["Right-click Menu"] = {
		["enabled"] = false,
		["friend"] = {
			["ARMORY"] = true,
			["MYSTATS"] = true,
			["NAME_COPY"] = true,
			["SEND_WHO"] = true,
			["FRIEND_ADD"] = true,
			["GUILD_ADD"] = true,
			-- ["Fix_Report"] = false,
		},
		-- ["chat_roster"] = {
		-- 	["NAME_COPY"]  = true,
		-- 	["SEND_WHO"] = true,
		-- 	["FRIEND_ADD"] = true,
		-- },
		-- ["guild"] = {
		-- 	["ARMORY"] = true,
		-- 	["NAME_COPY"] = true,
		-- 	["FRIEND_ADD"] = true,
		-- }
	}
}

WT.ToolConfigs["Chat"] = {
	["Tab Chat Mod"] = {
		tDesc   = L["Use tab to switch channel."],
		oAuthor = "houshuu",
		cAuthor = "houshuu",
		["general"] = {
			name = L["General"],
			order = 5,
			get = function(info) return E.db.WindTools["Chat"]["Tab Chat Mod"][ info[#info] ] end,
			set = function(info, value) E.db.WindTools["Chat"]["Tab Chat Mod"][ info[#info] ] = value end,
			args = {
				whisper_cycle = {
					name = L["Whisper Cycle"],
					order = 1,
				},
				use_yell = {
					name = CHAT_MSG_YELL,
					order = 2,
				},
				use_battleground = {
					name = CHAT_MSG_BATTLEGROUND,
					order = 3,
				},
				use_raid_warning = {
					name = CHAT_MSG_RAID_WARNING,
					order = 4,
				},
				use_officer = {
					name = CHAT_MSG_OFFICER,
					order = 5,
				},
			}
		},
	},
	["Enhanced Friend List"] = {
		tDesc   = L["Customize friend frame."],
		oAuthor = "ProjectAzilroka",
		cAuthor = "houshuu",
		["colorName"] = {
			name = L['Features'],
			order = 5,
			args = {
				["color_name"] = {
					name = L['Name color & Level'],
					order = 1,
					get = function(info) return E.db.WindTools["Chat"]["Enhanced Friend List"].color_name end,
					set = function(info, value) E.db.WindTools["Chat"]["Enhanced Friend List"].color_name = value; E:StaticPopup_Show("PRIVATE_RL") end
				},
				["enhanced_enable"] = {
					name = L['Enhanced Texuture'],
					order = 2,
					get = function(info) return E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced["enabled"] end,
					set = function(info, value) E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced["enabled"] = value; E:StaticPopup_Show("PRIVATE_RL") end
				},
			}
		},
		["general"] = {
			name = L['General'],
			order = 6,
			get = function(info) return E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced[info[#info]] end,
			set = function(info, value) E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced[info[#info]] = value FriendsFrame_Update() end,
			args = {
				["NameFont"] = {
					name = L['Name Font'],
					order = 1,
					type = 'select', dialogControl = 'LSM30_Font',
					desc = L['The font that the RealID / Character Name / Level uses.'],
					values = LSM:HashTable('font'),
				},
				["NameFontSize"] = {
					name = L['Name Font Size'],
					order = 2,
					type = 'range',
					desc = L['The font size that the RealID / Character Name / Level uses.'],
					min = 6, max = 22, step = 1,
				},
				["NameFontFlag"] = {
					name = L['Name Font Flag'],
					order = 3,
					type = 'select',
					desc = L['The font flag that the RealID / Character Name / Level uses.'],
					values = {
						['NONE'] = L['None'],
						['OUTLINE'] = L['OUTLINE'],
						['MONOCHROME'] = L['MONOCHROME'],
						['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
						['THICKOUTLINE'] = L['THICKOUTLINE'],
					},
				},
				["InfoFont"] = {
					type = 'select', dialogControl = 'LSM30_Font',
					name = L['Info Font'],
					order = 4,
					desc = L['The font that the Zone / Server uses.'],
					values = LSM:HashTable('font'),
				},
				["InfoFontSize"] = {
					name = L['Info Font Size'],
					order = 5,
					desc = L['The font size that the Zone / Server uses.'],
					type = 'range',
					min = 6, max = 22, step = 1,
				},
				["InfoFontFlag"] = {
					name = L['Info Font Outline'],
					order = 6,
					desc = L['The font flag that the Zone / Server uses.'],
					type = 'select',
					values = {
						['NONE'] = L['None'],
						['OUTLINE'] = L['OUTLINE'],
						['MONOCHROME'] = L['MONOCHROME'],
						['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
						['THICKOUTLINE'] = L['THICKOUTLINE'],
					},
				},
				["StatusIconPack"] = {
					name = L['Status Icon Pack'],
					order = 7,
					desc = L['Different Status Icons.'],
					type = 'select',
					values = {
						['Default'] = L['Default'],
						['Square'] = L['Square'],
						['D3'] = L['Diablo 3'],
					},
				},
			},
		},
		["GameIcons"] = {
			name = L['Game Icons'],
			order = 7,
			get = function(info) return E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced.GameIcon[info[#info]] end,
			set = function(info, value) E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced.GameIcon[info[#info]] = value FriendsFrame_Update() end,
			args = {},
		},
		["GameIconsPreview"] = {
			name = L['Game Icon Preview'],
			order = 8,
			args = {},
		},
		["StatusIcons"] = {
			name = L['Status Icon Preview'],
			order = 9,
			args = {},
		},
		func = function()
			local EFL = E:GetModule("Wind_EnhancedFriendsList")
			local GameIconsOptions = {
				Alliance = FACTION_ALLIANCE,
				Horde = FACTION_HORDE,
				Neutral = FACTION_STANDING_LABEL4,
				D3 = L['Diablo 3'],
				WTCG = L['Hearthstone'],
				S1 = L['Starcraft'],
				S2 = L['Starcraft 2'],
				App = L['App'],
				BSAp = L['Mobile'],
				Hero = L['Hero of the Storm'],
				Pro = L['Overwatch'],
				DST2 = L['Destiny 2'],
			}
			local GameIconOrder = {
				Alliance = 1,
				Horde = 2,
				Neutral = 3,
				D3 = 4,
				WTCG = 5,
				S1 = 6,
				S2 = 7,
				App = 8,
				BSAp = 9,
				Hero = 10,
				Pro = 11,
				DST2 = 12,
			}
			local StatusIconsOptions = {
				Online = FRIENDS_LIST_ONLINE,
				Offline = FRIENDS_LIST_OFFLINE,
				DND = DEFAULT_DND_MESSAGE,
				AFK = DEFAULT_AFK_MESSAGE,
			}
			local StatusIconsOrder = {
				Online = 1,
				Offline = 2,
				DND = 3,
				AFK = 4,
			}
	
			for Key, Value in pairs(GameIconsOptions) do
				WT.ToolConfigs["Chat"]["Enhanced Friend List"].GameIcons.args[Key] = {
					name = L[Value].." "..L['Icon'],
					order = GameIconOrder[Key],
					type = 'select',
					values = {
						['Default'] = L['Default'],
						['BlizzardChat'] = L['Blizzard Chat'],
						['Flat'] = L['Flat Style'],
						['Gloss'] = L['Glossy'],
						['Launcher'] = L['Launcher'],
					},
				}
				WT.ToolConfigs["Chat"]["Enhanced Friend List"].GameIconsPreview.args[Key] = {
					order = GameIconOrder[Key],
					type = 'execute',
					name = L[Value],
					func = function() return end,
					image = function(info) return EFL.GameIcons[info[#info]][E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced.GameIcon[Key]], 32, 32 end,
				}
			end
			
			-- 排除缺少的 SC1 图标
			WT.ToolConfigs["Chat"]["Enhanced Friend List"].GameIcons.args["S1"].values["Flat"] = nil
			WT.ToolConfigs["Chat"]["Enhanced Friend List"].GameIcons.args["S1"].values["Gloss"] = nil
	
			for Key, Value in pairs(StatusIconsOptions) do
				WT.ToolConfigs["Chat"]["Enhanced Friend List"].StatusIcons.args[Key] = {
					order = StatusIconsOrder[Key],
					type = 'execute',
					name = L[Value],
					func = function() return end,
					image = function(info) return EFL.StatusIcons[E.db.WindTools["Chat"]["Enhanced Friend List"].enhanced.StatusIconPack][info[#info]], 16, 16 end,
				}
			end
		end,
	},
	["Right-click Menu"] = {
		tDesc   = L["Enhanced right-click menu"],
		oAuthor = "loudsoul",
		cAuthor = "houshuu",
		["friend"] = {
			name = L["Friend Menu"],
			order = 5,
			args = {}
		},
		-- ["chat_roster"] = {
		-- 	name = L["Chat Roster Menu"],
		-- 	order = 6,
		-- 	args = {}
		-- },
		-- ["guild"] = {
		-- 	name = L["Guild Menu"],
		-- 	order = 7,
		-- 	args = {}
		-- },
		func = function()
			local EnhancedRCMenu = E:GetModule("Wind_EnhancedRCMenu")
			-- 循环载入设定
			for k, v in pairs(EnhancedRCMenu.friend_features) do
				WT.ToolConfigs["Chat"]["Right-click Menu"]["friend"].args[v] = {
					order = k + 1,
					name = UnitPopupButtons[v].text,
					get = function(info) return E.db.WindTools["Chat"]["Right-click Menu"]["friend"][v] end,
					set = function(info, value) E.db.WindTools["Chat"]["Right-click Menu"]["friend"][v] = value; E:StaticPopup_Show("PRIVATE_RL")  end,
				}
			end
			-- for k, v in pairs(EnhancedRCMenu.cr_features) do
			-- 	WT.ToolConfigs["Chat"]["Right-click Menu"]["chat_roster"].args[v] = {
			-- 		order = k + 1,
			-- 		name = EnhancedRCMenu.UnitPopupButtonsExtra[v],
			-- 		get = function(info) return E.db.WindTools["Chat"]["Right-click Menu"]["chat_roster"][v] end,
			-- 		set = function(info, value) E.db.WindTools["Chat"]["Right-click Menu"]["chat_roster"][v] = value; E:StaticPopup_Show("PRIVATE_RL")  end,
			-- 	}
			-- end
			-- for k, v in pairs(EnhancedRCMenu.guild_features) do
			-- 	WT.ToolConfigs["Chat"]["Right-click Menu"]["guild"].args[v] = {
			-- 		order = k + 1,
			-- 		name = EnhancedRCMenu.UnitPopupButtonsExtra[v],
			-- 		get = function(info) return E.db.WindTools["Chat"]["Right-click Menu"]["guild"][v] end,
			-- 		set = function(info, value) E.db.WindTools["Chat"]["Right-click Menu"]["guild"][v] = value; E:StaticPopup_Show("PRIVATE_RL")  end,
			-- 	}
			-- end
		
			-- WT.ToolConfigs["Chat"]["Right-click Menu"]["friend"].args.Fix_Report = {
			-- 	order = -1,
			-- 	name = L["Fix REPORT"],
			-- 	get = function(info) return E.db.WindTools["Chat"]["Right-click Menu"]["friend"]["Fix_Report"] end,
			-- 	set = function(info, value) E.db.WindTools["Chat"]["Right-click Menu"]["friend"]["Fix_Report"] = value; E:StaticPopup_Show("PRIVATE_RL")  end,
			-- }
		end,
	},
}