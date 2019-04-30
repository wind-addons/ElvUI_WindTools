local E, _, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local L = unpack(select(2, ...))
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")

local _G = _G

local function refresh_objective_tracker()
	ObjectiveTracker_Update()
end

P["WindTools"]["Quest"] = {
	["Objective Tracker"] = {
		enabled = true,
		header = {
			font = E.db.general.font,
			size = E.db.general.fontSize,
			style = "OUTLINE",
		},
		title = {
			font = E.db.general.font,
			size = E.db.general.fontSize,
			style = "OUTLINE",
			color = {
				enabled = true,
				class_color = true,
				custom_color = { r = 0.75, g = 0.61, b = 0 },
				custom_color_highlight = { r = NORMAL_FONT_COLOR.r, g = NORMAL_FONT_COLOR.g, b = NORMAL_FONT_COLOR.b },
			},
		},
		info = {
			font = E.db.general.font,
			size = E.db.general.fontSize,
			style = "OUTLINE",
		},
	},
	["Quest Announcment"] = {
		["enabled"] = true,
		["NoDetail"] = false,
		["Instance"] = false,
		["Raid"] = false,
		["Party"] = false,
		["Solo"] = true,
		["ignore_supplies"] = true,
	},
	["Close Quest Voice"] = {
		["enabled"] = false,
	},
	["Objective Progress"] = {
		["enabled"] = true,
	},
}

WT.ToolConfigs["Quest"] = {
	["Objective Tracker"] = {
		tDesc   = L["The new-look interface for objective tracker."],
		oAuthor = "houshuu",
		cAuthor = "houshuu",
		general = {
			order = 5,
			name = L['General'],
			args = {
				header = {
					order = 1,
					name = L["Header"],
					get = function(info) return E.db.WindTools.Quest["Objective Tracker"]["header"][info[#info]] end,
					set = function(info, value)
						E.db.WindTools.Quest["Objective Tracker"]["header"][info[#info]] = value
						refresh_objective_tracker()
					end,
					args = {
						font = {
							type = 'select', dialogControl = 'LSM30_Font',
							order = 1,
							name = L['Font'],
							values = LSM:HashTable('font'),
						},
						size = {
							order = 2,
							name = L['Size'],
							type = 'range',
							min = 6, max = 22, step = 1,
						},
						style = {
							order = 3,
							name = L["Style"],
							type = 'select',
							values = {
								['NONE'] = L['None'],
								['OUTLINE'] = L['OUTLINE'],
								['MONOCHROME'] = L['MONOCHROME'],
								['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
								['THICKOUTLINE'] = L['THICKOUTLINE'],
							},
						},
					},	
				},
				title = {
					order = 2,
					name = L["Title"],
					get = function(info) return E.db.WindTools.Quest["Objective Tracker"]["title"][info[#info]] end,
					set = function(info, value)
						E.db.WindTools.Quest["Objective Tracker"]["title"][info[#info]] = value
						refresh_objective_tracker()
					end,
					args = {
						font = {
							type = 'select', dialogControl = 'LSM30_Font',
							order = 1,
							name = L['Font'],
							values = LSM:HashTable('font'),
						},
						size = {
							order = 2,
							name = L['Size'],
							type = 'range',
							min = 6, max = 22, step = 1,
						},
						style = {
							order = 3,
							name = L["Style"],
							type = 'select',
							values = {
								['NONE'] = L['None'],
								['OUTLINE'] = L['OUTLINE'],
								['MONOCHROME'] = L['MONOCHROME'],
								['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
								['THICKOUTLINE'] = L['THICKOUTLINE'],
							},
						},
						color = {
							order = 4,
							name = L["Color"],
							get = function(info) return E.db.WindTools.Quest["Objective Tracker"]["title"]["color"][info[#info]] end,
							set = function(info, value)
								E.db.WindTools.Quest["Objective Tracker"]["title"]["color"][info[#info]] = value
								refresh_objective_tracker()
							end,
							args = {
								enabled = {
									order = 1,
									name = L["Enable"],
								},
								class_color = {
									order = 2,
									name = L["Use class color"],
									set = function(info, value)
										E.db.WindTools.Quest["Objective Tracker"]["title"]["color"]["class_color"] = value
										E:StaticPopup_Show("WIND_RL")
									end,
								},
								custom_color = {
									order = 3,
									type = "color",
									name = L["Custom title color"],
									hasAlpha = false,
									hidden = function() return E.db.WindTools.Quest["Objective Tracker"]["title"]["color"]["class_color"] end,
									get = function(info)
										local t = E.db.WindTools.Quest["Objective Tracker"]["title"]["color"]["custom_color"]
										return t.r, t.g, t.b
									end,
									set = function(info, r, g, b)
										local t = E.db.WindTools.Quest["Objective Tracker"]["title"]["color"]["custom_color"]
										t.r, t.g, t.b = r, g, b
										E:StaticPopup_Show("WIND_RL")
									end,
								},
								custom_color_highlight = {
									order = 4,
									type = "color",
									name = L["Custom highlight color"],
									hasAlpha = false,
									hidden = function() return E.db.WindTools.Quest["Objective Tracker"]["title"]["color"]["class_color"] end,
									get = function(info)
										local t = E.db.WindTools.Quest["Objective Tracker"]["title"]["color"]["custom_color_highlight"]
										return t.r, t.g, t.b
									end,
									set = function(info, r, g, b)
										local t = E.db.WindTools.Quest["Objective Tracker"]["title"]["color"]["custom_color_highlight"]
										t.r, t.g, t.b = r, g, b
										E:StaticPopup_Show("WIND_RL")
									end,
								},
							},
						},
					},
				},
				info = {
					order = 3,
					name = L["Info text"],
					get = function(info) return E.db.WindTools.Quest["Objective Tracker"]["info"][info[#info]] end,
					set = function(info, value)
						E.db.WindTools.Quest["Objective Tracker"]["info"][info[#info]] = value
						refresh_objective_tracker()
					end,
					args = {
						font = {
							type = 'select', dialogControl = 'LSM30_Font',
							order = 1,
							name = L['Font'],
							values = LSM:HashTable('font'),
						},
						size = {
							order = 2,
							name = L['Size'],
							type = 'range',
							min = 6, max = 22, step = 1,
						},
						style = {
							order = 3,
							name = L["Style"],
							type = 'select',
							values = {
								['NONE'] = L['None'],
								['OUTLINE'] = L['OUTLINE'],
								['MONOCHROME'] = L['MONOCHROME'],
								['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
								['THICKOUTLINE'] = L['THICKOUTLINE'],
							},
						},
					},
				},
			},
		},
	},
	["Quest Announcment"] = {
		tDesc   = L["Let you know quest is completed."],
		oAuthor = "EUI",
		cAuthor = "houshuu",
		["NoDetail"] = {
			order = 5,
			name = L["No Detail"],
			get = function(info) return E.db.WindTools["Quest"]["Quest Announcment"]["NoDetail"] end,
			set = function(info, value) E.db.WindTools["Quest"]["Quest Announcment"]["NoDetail"] = value;end
		},
		["Instance"] = {
			order = 6,
			name = L["Instance"],
			get = function(info) return E.db.WindTools["Quest"]["Quest Announcment"]["Instance"] end,
			set = function(info, value) E.db.WindTools["Quest"]["Quest Announcment"]["Instance"] = value;end
		},
		["Raid"] = {
			order = 7,
			name = L["Raid"],
			get = function(info) return E.db.WindTools["Quest"]["Quest Announcment"]["Raid"] end,
			set = function(info, value) E.db.WindTools["Quest"]["Quest Announcment"]["Raid"] = value; E:StaticPopup_Show("PRIVATE_RL")end
		},
		["Party"] = {
			order = 8,
			name = L["Party"],
			get = function(info) return E.db.WindTools["Quest"]["Quest Announcment"]["Party"] end,
			set = function(info, value) E.db.WindTools["Quest"]["Quest Announcment"]["Party"] = value;end
		},
		["Solo"] = {
			order = 9,
			name = L["Solo"],
			get = function(info) return E.db.WindTools["Quest"]["Quest Announcment"]["Solo"] end,
			set = function(info, value) E.db.WindTools["Quest"]["Quest Announcment"]["Solo"] = value;end
		},
		["ignore_supplies"] = {
			order = 10,
			name = L["Ignore supplies quest"],
			get = function(info) return E.db.WindTools["Quest"]["Quest Announcment"]["ignore_supplies"] end,
			set = function(info, value) E.db.WindTools["Quest"]["Quest Announcment"]["ignore_supplies"] = value;end
		},
		
	},
	["Close Quest Voice"] = {
		tDesc   = L["Disable TalkingHeadFrame."],
		oAuthor = "houshuu",
		cAuthor = "houshuu",
	},
	["Objective Progress"] = {
		tDesc   = L["Add quest/mythic+ dungeon progress to tooltip."],
		oAuthor = "Simca",
		cAuthor = "houshuu",
	},
}