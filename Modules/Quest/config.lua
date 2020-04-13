local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
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
		auto_turn_in = {
			auto = false,
			switch_button = {
				enabled = true,
				fade_with_objective_tracker = true,
				font = E.db.general.font,
				size = E.db.general.fontSize,
				style = "OUTLINE",
				enabled_text = L["Auto Turn In"],
				disabled_text = L["Auto Turn In"],
				enabled_color = {r = .298, g = .82, b = .216},
				disabled_color = {r = .467, g = .467, b = .467},
			},
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
	["Disable Talking Head"] = {
		["enabled"] = false,
	},
	["Objective Progress"] = {
		["enabled"] = true,
	},
	["Track Reputation"] = {
		enabled = false,
	},
	["Paragon Reputation"] = {
		enabled = true,
		color = { r = 0, g = .5, b = .9 },
		text = "DEFICIT",
		toast = {
			enabled = true,
			sound = true,
			fade_time = 5,
		}
	},
}

WT.ToolConfigs["Quest"] = {
	["Objective Tracker"] = {
		tDesc   = L["The new-look interface for objective tracker."],
		oAuthor = "houshuu",
		cAuthor = "houshuu",
		auto_turn_in = {
			order = 5,
			name = L["Auto Turn In"],
			get = function(info) return E.db.WindTools.Quest["Objective Tracker"]["auto_turn_in"][info[#info]] end,
			set = function(info, value)
				E.db.WindTools.Quest["Objective Tracker"]["auto_turn_in"][info[#info]] = value
				WT.UpdateSwitchButton()
			end,
			args = {
				auto = {
					order = 1,
					name = L["Auto"],
				},
				use_switch_button = {
					order = 1,
					name = L["Switch button"],
					get = function(info) return E.db.WindTools.Quest["Objective Tracker"]["auto_turn_in"]["switch_button"]["enabled"] end,
					set = function(info, value)
						E.db.WindTools.Quest["Objective Tracker"]["auto_turn_in"]["switch_button"]["enabled"] = value
						WT.UpdateSwitchButton()
					end,
				},
				switch_button = {
					order = 2,
					name = L["Switch button"],
					get = function(info) return E.db.WindTools.Quest["Objective Tracker"]["auto_turn_in"]["switch_button"][info[#info]] end,
					set = function(info, value)
						E.db.WindTools.Quest["Objective Tracker"]["auto_turn_in"]["switch_button"][info[#info]] = value
						WT.UpdateSwitchButton()
					end,
					args = {
						fade_with_objective_tracker = {
							order = 1,
							name = L["Fade with Objective Tracker"],
							width = "full",
						},
						font_setting = {
							order = 2,
							name = L["Custom font"],
							get = function(info) return E.db.WindTools.Quest["Objective Tracker"]["auto_turn_in"]["switch_button"][info[#info]] end,
							set = function(info, value)
								E.db.WindTools.Quest["Objective Tracker"]["auto_turn_in"]["switch_button"][info[#info]] = value
								WT.UpdateSwitchButton()
							end,
							args = {
								font = {
									type = 'select', dialogControl = 'LSM30_Font',
									order = 2,
									name = L['Font'],
									values = LSM:HashTable('font'),
								},
								size = {
									order = 3,
									name = L['Size'],
									type = 'range',
									min = 6, max = 22, step = 1,
								},
								style = {
									order = 4,
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
						text_setting = {
							order = 3,
							name = L["Custom text"],
							get = function(info) return E.db.WindTools.Quest["Objective Tracker"]["auto_turn_in"]["switch_button"][info[#info]] end,
							set = function(info, value)
								E.db.WindTools.Quest["Objective Tracker"]["auto_turn_in"]["switch_button"][info[#info]] = value
								WT.UpdateSwitchButton()
							end,
							args = {
								enabled_text = {
									order = 1,
									type = "input",
									width = 1.2,
									name = L["Text when enabled"],
								},
								enabled_color = {
									order = 2,
									type = "color",
									name = L["Enable"],
									width = 0.8,
									hasAlpha = false,
									get = function(info)
										local t = E.db.WindTools.Quest["Objective Tracker"]["auto_turn_in"]["switch_button"]["enabled_color"]
										return t.r, t.g, t.b, nil, .298, .82, .216, nil
									end,
									set = function(info, r, g, b)
										local t = E.db.WindTools.Quest["Objective Tracker"]["auto_turn_in"]["switch_button"]["enabled_color"]
										t.r, t.g, t.b = r, g, b
										WT.UpdateSwitchButton()
									end,
								},
								disabled_text = {
									order = 3,
									type = "input",
									width = 1.2,
									name = L["Text when disabled"],
								},
								disabled_color = {
									order = 4,
									type = "color",
									width = 0.8,
									name = L["Disable"],
									hasAlpha = false,
									get = function(info)
										local t = E.db.WindTools.Quest["Objective Tracker"]["auto_turn_in"]["switch_button"]["disabled_color"]
										return t.r, t.g, t.b, nil, .467, .467, .467, nil
									end,
									set = function(info, r, g, b)
										local t = E.db.WindTools.Quest["Objective Tracker"]["auto_turn_in"]["switch_button"]["disabled_color"]
										t.r, t.g, t.b = r, g, b
										WT.UpdateSwitchButton()
									end,
								},
							},
						},
					},
				},
			},
		},
		general = {
			order = 6,
			name = L['General'],
			args = {
				header = {
					order = 2,
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
					order = 3,
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
					order = 4,
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
			name = L["Raids"],
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
	["Disable Talking Head"] = {
		tDesc   = L["Disable TalkingHeadFrame."],
		oAuthor = "houshuu",
		cAuthor = "houshuu",
	},
	["Objective Progress"] = {
		tDesc   = L["Add quest/mythic+ dungeon progress to tooltip."],
		oAuthor = "Simca",
		cAuthor = "houshuu",
	},
	["Track Reputation"] = {
		tDesc   = L['Automatically change your watched faction on the reputation bar to the faction you got reputation points for.'],
		oAuthor = "ElvUI_Enhanced, Marcel Menzel",
		cAuthor = "houshuu",
	},
	["Paragon Reputation"] = {
		tDesc   = L['Better visualization of Paragon Factions on the Reputation Frame.'],
		oAuthor = "|cffabd473Fail|r |cffff4000US-Ragnaros|r",
		cAuthor = "houshuu",
		reputation_panel = {
			order = 5,
			name = L["Reputation panel"],
			get = function(info) return E.db.WindTools["Quest"]["Paragon Reputation"][ info[#info] ] end,
			set = function(info, value) E.db.WindTools["Quest"]["Paragon Reputation"][ info[#info] ] = value; ReputationFrame_Update() end,
			args = {
				color = {
					order = 1, 
					name = L["Color"],
					type = "color",
					hasAlpha = false,
					get = function(info)
						local t = E.db.WindTools["Quest"]["Paragon Reputation"].color
						return t.r, t.g, t.b, 1, 0, .5, .9, 1
					end,
					set = function(info, r, g, b)
						local t = E.db.WindTools["Quest"]["Paragon Reputation"].color
						t.r, t.g, t.b = r, g, b
						ReputationFrame_Update()
					end,
				},
				text = {
					order = 2, 
					name = L["Format"],
					type = 'select',
					values = {
						['PARAGON'] = L["Paragon"]..' (100/10000)',
						['EXALTED'] = L["Exalted"]..' (100/10000)',
						['CURRENT'] = '100 (100/10000)',
						['VALUE'] = '100/10000',
						['DEFICIT'] = '9900',
					},
				},
			},
		},
		toast = {
			order = 6,
			name = L["Toast"],
			get = function(info) return E.db.WindTools["Quest"]["Paragon Reputation"]["toast"][ info[#info] ] end,
			set = function(info, value) E.db.WindTools["Quest"]["Paragon Reputation"]["toast"][ info[#info] ] = value end,
			args = {
				enabled = {
					order = 1, 
					name = L["Enable"],
				},
				sound = {
					order = 1, 
					name = L["Sound"],
				},
				fade_time = {
					order = 3,
					type = "range",
					name = L["Fade time"],
					min = 1, max = 15.0, step = 0.01,
				},
			},
		},
	},
}