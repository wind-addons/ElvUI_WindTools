local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")

local _G = _G
local friend_features = {
	"ARMORY",
	"MYSTATS",
	"NAME_COPY",
	"SEND_WHO",
	"FRIEND_ADD",
	"GUILD_ADD",
}
local cr_features = {
	"NAME_COPY",
	"SEND_WHO",
	"FRIEND_ADD",
	"INVITE",
}
local guild_features = {
	"ARMORY",
	"NAME_COPY",
	"FRIEND_ADD",
}

local UnitPopupButtonsExtra = {
	["ARMORY"] = L["Armory"],
	["SEND_WHO"] = L["Query Detail"],
	["NAME_COPY"] = L["Get Name"],
	["GUILD_ADD"] = L["Guild Invite"],
	["FRIEND_ADD"] = L["Add Friend"],
	["MYSTATS"] = L["Report MyStats"],
	["INVITE"] = L["Invite"],
}

P["WindTools"] = {
	["Tab Chat Mod"] = {
		["enabled"] = true,
		["whispercycle"] = false,
		["useofficer"] = false,
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
		["enabled"] = true,
		["friend"] = {
			["ARMORY"] = true,
			["SEND_WHO"] = true,
			["NAME_COPY"] = true,
			["GUILD_ADD"] = true,
			["FRIEND_ADD"] = true,
			["MYSTATS"] = true,
			["Fix_Report"] = false,
		},
		["chat_roster"] = {
			["NAME_COPY"]  = true,
			["SEND_WHO"] = true,
			["FRIEND_ADD"] = true,
			["INVITE"] = true,
		},
		["guild"] = {
			["ARMORY"] = true,
			["NAME_COPY"] = true,
			["FRIEND_ADD"] = true,
		}
	}
}

WT.ToolConfigs["Tab Chat Mod"] = function()
	E.Options.args.WindTools.args["Chat"].args["Tab Chat Mod"].args["addwhisper"] = {
		order = 10,
		type = "group",
		name = L["Whisper Cycle"],
		guiInline = true,
		args = {
			seteffect = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function(info) return E.db.WindTools["Tab Chat Mod"]["whispercycle"] end,
				set = function(info, value) E.db.WindTools["Tab Chat Mod"]["whispercycle"] = value;end
			},
		}
	}
	E.Options.args.WindTools.args["Chat"].args["Tab Chat Mod"].args["addofficer"] = {
		order = 11,
		type = "group",
		name = L["Include Officer Channel"],
		guiInline = true,
		args = {
			seteffect = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function(info) return E.db.WindTools["Tab Chat Mod"]["useofficer"] end,
				set = function(info, value) E.db.WindTools["Tab Chat Mod"]["useofficer"] = value;end
			},
		}
	}
end


WT.ToolConfigs["Enhanced Friend List"] = function()
	if not E.db.WindTools["Enhanced Friend List"]["enabled"] then return end
	local profile = E.db.WindTools["Enhanced Friend List"]
	local Options = {
		colorName = {
			order = 9,
			type = 'group',
			name = L['Features'],
			guiInline = true,
			args = {
				color_name = {
					order = 1,
					type = "toggle",
					name = L['Name color & Level'],
					get = function(info) return profile.color_name end,
					set = function(info, value) profile.color_name = value; E:StaticPopup_Show("PRIVATE_RL") end
				},
				enhanced_enable = {
					order = 2,
					type = "toggle",
					name = L['Enhanced Texuture'],
					get = function(info) return profile.enhanced["enabled"] end,
					set = function(info, value) profile.enhanced["enabled"] = value; E:StaticPopup_Show("PRIVATE_RL") end
				},
			}
		},
		general = {
			order = 10,
			type = 'group',
			name = L['General'],
			guiInline = true,
			get = function(info) return profile.enhanced[info[#info]] end,
			set = function(info, value) profile.enhanced[info[#info]] = value FriendsFrame_Update() end,
			args = {
				NameFont = {
					type = 'select', dialogControl = 'LSM30_Font',
					order = 1,
					name = L['Name Font'],
					desc = L['The font that the RealID / Character Name / Level uses.'],
					values = LSM:HashTable('font'),
				},
				NameFontSize = {
					order = 2,
					name = L['Name Font Size'],
					desc = L['The font size that the RealID / Character Name / Level uses.'],
					type = 'range',
					min = 6, max = 22, step = 1,
				},
				NameFontFlag = {
					name = L['Name Font Flag'],
					desc = L['The font flag that the RealID / Character Name / Level uses.'],
					order = 3,
					type = 'select',
					values = {
						['NONE'] = L['None'],
						['OUTLINE'] = L['OUTLINE'],
						['MONOCHROME'] = L['MONOCHROME'],
						['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
						['THICKOUTLINE'] = L['THICKOUTLINE'],
					},
				},
				InfoFont = {
					type = 'select', dialogControl = 'LSM30_Font',
					order = 4,
					name = L['Info Font'],
					desc = L['The font that the Zone / Server uses.'],
					values = LSM:HashTable('font'),
				},
				InfoFontSize = {
					order = 5,
					name = L['Info Font Size'],
					desc = L['The font size that the Zone / Server uses.'],
					type = 'range',
					min = 6, max = 22, step = 1,
				},
				InfoFontFlag = {
					order = 6,
					name = L['Info Font Outline'],
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
				StatusIconPack = {
					name = L['Status Icon Pack'],
					desc = L['Different Status Icons.'],
					order = 7,
					type = 'select',
					values = {
						['Default'] = L['Default'],
						['Square'] = L['Square'],
						['D3'] = L['Diablo 3'],
					},
				},
			},
		},
		GameIcons = {
			order = 11,
			type = 'group',
			name = L['Game Icons'],
			guiInline = true,
			get = function(info) return profile.enhanced.GameIcon[info[#info]] end,
			set = function(info, value) profile.enhanced.GameIcon[info[#info]] = value FriendsFrame_Update() end,
			args = {},
		},
		GameIconsPreview = {
			order = 12,
			type = 'group',
			name = L['Game Icon Preview'],
			guiInline = true,
			args = {},
		},
		StatusIcons = {
			order = 13,
			type = 'group',
			name = L['Status Icon Preview'],
			guiInline = true,
			args = {},
		},
	}
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
		Options.GameIcons.args[Key] = {
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
		Options.GameIconsPreview.args[Key] = {
			order = GameIconOrder[Key],
			type = 'execute',
			name = L[Value],
			func = function() return end,
			image = function(info) return E:GetModule("EnhancedFriendsList").GameIcons[info[#info]][profile.enhanced.GameIcon[Key]], 32, 32 end,
		}
	end
	
	-- 排除缺少的 SC1 图标
	Options.GameIcons.args["S1"].values["Flat"] = nil
	Options.GameIcons.args["S1"].values["Gloss"] = nil

	for Key, Value in pairs(StatusIconsOptions) do
		Options.StatusIcons.args[Key] = {
			order = StatusIconsOrder[Key],
			type = 'execute',
			name = L[Value],
			func = function() return end,
			image = function(info) return E:GetModule("EnhancedFriendsList").StatusIcons[profile.enhanced.StatusIconPack][info[#info]], 16, 16 end,
		}
	end

	for k, v in pairs(Options) do
		E.Options.args.WindTools.args["Chat"].args["Enhanced Friend List"].args[k] = v
	end
end

WT.ToolConfigs["Right-click Menu"] = function()
	-- 初始化空设定
	local Options = {
		friend = {
			order = 11,
			type = "group",
			name = L["Friend Menu"],
			guiInline = true,
			args = {}
		},
		chat_roster = {
			order = 12,
			type = "group",
			name = L["Chat Roster Menu"],
			guiInline = true,
			args = {}
		},
		guild = {
			order = 13,
			type = "group",
			name = L["Guild Menu"],
			guiInline = true,
			args = {}
		},
	}
	-- 循环载入设定
	for k, v in pairs(E:GetModule("EnhancedRCMenu").friend_features) do
		Options["friend"].args[v] = {
			order = k + 1,
			type = "toggle",
			name = E:GetModule("EnhancedRCMenu").UnitPopupButtonsExtra[v],
			get = function(info) return E.db.WindTools["Right-click Menu"]["friend"][v] end,
			set = function(info, value) E.db.WindTools["Right-click Menu"]["friend"][v] = value; E:StaticPopup_Show("PRIVATE_RL")  end,
		}
	end
	for k, v in pairs(E:GetModule("EnhancedRCMenu").cr_features) do
		Options["chat_roster"].args[v] = {
			order = k + 1,
			type = "toggle",
			name = E:GetModule("EnhancedRCMenu").UnitPopupButtonsExtra[v],
			get = function(info) return E.db.WindTools["Right-click Menu"]["chat_roster"][v] end,
			set = function(info, value) E.db.WindTools["Right-click Menu"]["chat_roster"][v] = value; E:StaticPopup_Show("PRIVATE_RL")  end,
		}
	end
	for k, v in pairs(E:GetModule("EnhancedRCMenu").guild_features) do
		Options["guild"].args[v] = {
			order = k + 1,
			type = "toggle",
			name = E:GetModule("EnhancedRCMenu").UnitPopupButtonsExtra[v],
			get = function(info) return E.db.WindTools["Right-click Menu"]["guild"][v] end,
			set = function(info, value) E.db.WindTools["Right-click Menu"]["guild"][v] = value; E:StaticPopup_Show("PRIVATE_RL")  end,
		}
	end

	Options["friend"].args.Fix_Report = {
		order = -1,
		type = "toggle",
		name = L["Fix REPORT"],
		get = function(info) return E.db.WindTools["Right-click Menu"]["friend"]["Fix_Report"] end,
		set = function(info, value) E.db.WindTools["Right-click Menu"]["friend"]["Fix_Report"] = value; E:StaticPopup_Show("PRIVATE_RL")  end,
	}

	for k, v in pairs(Options) do
		E.Options.args.WindTools.args["Chat"].args["Right-click Menu"].args[k] = v
	end
end
