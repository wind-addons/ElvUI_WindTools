local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")

local _G = _G
local GetCVarBool = GetCVarBool

local function FormatDesc(code, helpText)
	return WT:ColorStr(code).." = "..helpText
end

local function Example_FormatInterruptMessage(custom_message)
	custom_message = gsub(custom_message, "%%player%%", UnitName("player"))
	custom_message = gsub(custom_message, "%%target%%", L["Sylvanas"])
	custom_message = gsub(custom_message, "%%player_spell%%", GetSpellLink(31935))
	custom_message = gsub(custom_message, "%%target_spell%%", GetSpellLink(252150))
	return custom_message
end

P["WindTools"]["More Tools"] = {
	["Announce System"] = {
		["enabled"] = true,
		["interrupt"] = {
			["enabled"] = true,
			["only_instance"] = true,
			["player"] = {
				["enabled"] = true,
				["text"] = L["I interrupted %target%\'s %target_spell%!"],
				["channel"] = {
					["solo"] = "SELF",
					["party"] = "PARTY",
					["instance"] = "INSTANCE_CHAT",
					["raid"] = "RAID",
				},
			},
			["others"] = {
				["enabled"] = true,
				["text"] = L["%player% interrupted %target%\'s %target_spell%!"],
				["channel"] = {
					["party"] = "EMOTE",
					["instance"] = "NONE",
					["raid"] = "NONE",
				},
			},
		},
		["raid_spells"] = {
			["enabled"] = true,
			["channel"] = {
				["solo"] = "SELF",
				["party"] = "PARTY",
				["instance"] = "INSTANCE_CHAT",
				["raid"] = "RAID",
			},
			["spells"] = {
				["ritual_of_summoning"] = {
					["enabled"] = true,
					["id"] = 698,
					["use_raid_warning"] = true,
					["text"] = L["%player% is casting %spell%, please assist!"],
				},
				["create_soulwell"] = {
					["enabled"] = true,
					["id"] = 29893,
					["use_raid_warning"] = true,
					["text"] = L["%player% is handing out cookies, go and get one!"],
				},
				["moll_e"] = {
					["enabled"] = true,
					["id"] = 54710,
					["use_raid_warning"] = true,
					["text"] = L["%player% puts %spell%"],
				},
				["katy_stampwhistle"] = {
					["enabled"] = true,
					["id"] = 261602,
					["use_raid_warning"] = true,
					["text"] = L["%player% used %spell%"],
				},
				["conjure_refreshment"] = {
					["enabled"] = true,
					["id"] = 190336,
					["use_raid_warning"] = true,
					["text"] = L["%player% casted %spell%, today's special is Anchovy Pie!"],
				},
				["feasts"] = {
					["enabled"] = true,
					["use_raid_warning"] = true,
					["text"] = L["OMG, wealthy %player% puts %spell%!"],
				},
				["bots"] = {
					["enabled"] = true,
					["use_raid_warning"] = true,
					["text"] = L["%player% puts %spell%"],
				},
				["toys"] = {
					["enabled"] = true,
					["use_raid_warning"] = true,
					["text"] = L["%player% puts %spell%"],
				},
				["portals"] = {
					["enabled"] = true,
					["use_raid_warning"] = true,
					["text"] = L["%player% opened %spell%!"],
				},
			}
		}
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
	["Enhanced Tags"] = {
		["enabled"] = true,
	},
	["Enter Combat Alert"] = {
		["enabled"] = true,
		["style"] = {
			["font_name"] = E.db.general.font,
			["font_size"] = 28,
			["font_flag"] = "THICKOUTLINE",
			["use_backdrop"] = false,
			["font_color_enter"] = {
				r = 0.91,
				g = 0.3,
				b = 0.24,
				a = 1.0,
			},
			["font_color_leave"] = {
				r = 0.18,
				g = 0.8,
				b = 0.44,
				a = 1.0,
			},
			["stay_duration"] = 1.5,
			["animation_duration"] = 0.5,
			["scale"] = 0.8,
		},
		["custom_text"] = {
			["enabled"] = false,
			["custom_enter_text"] = "",
			["custom_leave_text"] = "",
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
		oAuthor = "houshuu",
		cAuthor = "houshuu",
		["interrupt"] = {
			order = 5,
			name = L["Interrupt"],
			type = "group",
			args = {
				enable = {
					order = 1,
					name = L["Enable"],
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["enabled"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["enabled"] = value end
				},
				only_instance = {
					order = 2,
					name = L["Only instance / arena"],
					hidden = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["enabled"] end,
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["only_instance"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["only_instance"] = value end
				},
				player = {
					order = 3,
					name = L["Player(Only you)"],
					hidden = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["enabled"] end,
					args = {
						enable = {
							order = 1,
							name = L["Enable"],
							get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["player"]["enabled"] end,
							set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["player"]["enabled"] = value end
						},
						default_text = {
							order = 2,
							type = "execute",
							name = L["Use default text"],
							disabled = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["player"]["enabled"] end,
							func = function() E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["player"]["text"] = P["WindTools"]["More Tools"]["Announce System"]["interrupt"]["player"]["text"] end
						},
						text = {
							order = 3,
							type = "input",
							width = 'full',
							name = L["Text for the interrupt casted by you"],
							desc = FormatDesc("%player%", L["Your name"]).."\n"..FormatDesc("%target%", L["Target name"]).."\n"..FormatDesc("%player_spell%", L["Your spell link"]).."\n"..FormatDesc("%target_spell%", L["Interrupted spell link"]),
							disabled = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["player"]["enabled"] end,
							get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["player"]["text"] end,
							set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["player"]["text"] = value end,
						},
						text_example = {
							order = 4,
							type = "description",
							hidden = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["player"]["enabled"] end,
							name = function() return "\n"..WT:ColorStr(L["Example"])..": "..Example_FormatInterruptMessage(E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["player"]["text"]).."\n" end
						},
						channel = {
							order = 5,
							name = L["Channel"],
							disabled = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["player"]["enabled"] end,
							get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["player"]["channel"][info[#info]] end,
							set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["player"]["channel"][info[#info]] = value end,
							args = {
								["solo"] = {
									order = 1,
									name = L["Solo"],
									type = "select",
									values = {
										["NONE"] = L["None"],
										["SELF"] = L["Self(Chat Frame)"],
										["EMOTE"] = L["Emote"],
										["YELL"] = L["Yell"],
										["SAY"] = L["Say"],
									},
								},
								["party"] = {
									order = 2,
									name = L["In party"],
									type = "select",
									values = {
										["NONE"] = L["None"],
										["SELF"] = L["Self(Chat Frame)"],
										["EMOTE"] = L["Emote"],
										["PARTY"] = L["Party"],
										["YELL"] = L["Yell"],
										["SAY"] = L["Say"],
									},
								},
								["instance"] = {
									order = 3,
									name = L["In instance"],
									type = "select",
									values = {
										["NONE"] = L["None"],
										["SELF"] = L["Self(Chat Frame)"],
										["EMOTE"] = L["Emote"],
										["PARTY"] = L["Party"],
										["INSTANCE_CHAT"] = L["Instance"],
										["YELL"] = L["Yell"],
										["SAY"] = L["Say"],
									},
								},
								["raid"] = {
									order = 4,
									name = L["In raid"],
									type = "select",
									values = {
										["NONE"] = L["None"],
										["SELF"] = L["Self(Chat Frame)"],
										["EMOTE"] = L["Emote"],
										["PARTY"] = L["Party"],
										["RAID"] = L["Raid"],
										["YELL"] = L["Yell"],
										["SAY"] = L["Say"],
									},
								},
							}
						},
					},
				},
				others = {
					order = 4,
					name = L["Other Players"],
					hidden = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["enabled"] end,
					args = {
						enable = {
							order = 1,
							name = L["Enable"],
							get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["others"]["enabled"] end,
							set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["others"]["enabled"] = value end
						},
						default_text = {
							order = 2,
							type = "execute",
							name = L["Use default text"],
							disabled = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["others"]["enabled"] end,
							func = function() E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["others"]["text"] = P["WindTools"]["More Tools"]["Announce System"]["interrupt"]["others"]["text"] end
						},
						text = {
							order = 3,
							type = "input",
							width = 'full',
							name = L["Text for the interrupt casted by others"],
							desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%target%", L["Target name"]).."\n"..FormatDesc("%player_spell%", L["The spell link"]).."\n"..FormatDesc("%target_spell%", L["Interrupted spell link"]),
							disabled = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["others"]["enabled"] end,
							get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["others"]["text"] end,
							set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["others"]["text"] = value end,
						},
						text_example = {
							order = 4,
							type = "description",
							hidden = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["others"]["enabled"] end,
							name = function() return "\n"..WT:ColorStr(L["Example"])..": "..Example_FormatInterruptMessage(E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["others"]["text"]).."\n" end
						},
						
						channel = {
							order = 5,
							name = L["Channel"],
							disabled = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["others"]["enabled"] end,
							get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["others"]["channel"][info[#info]] end,
							set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["interrupt"]["others"]["channel"][info[#info]] = value end,
							args = {
								["party"] = {
									order = 1,
									name = L["In party"],
									type = "select",
									values = {
										["NONE"] = L["None"],
										["SELF"] = L["Self(Chat Frame)"],
										["EMOTE"] = L["Emote"],
										["PARTY"] = L["Party"],
										["YELL"] = L["Yell"],
										["SAY"] = L["Say"],
									},
								},
								["instance"] = {
									order = 2,
									name = L["In instance"],
									type = "select",
									values = {
										["NONE"] = L["None"],
										["SELF"] = L["Self(Chat Frame)"],
										["EMOTE"] = L["Emote"],
										["PARTY"] = L["Party"],
										["INSTANCE_CHAT"] = L["Instance"],
										["YELL"] = L["Yell"],
										["SAY"] = L["Say"],
									},
								},
								["raid"] = {
									order = 3,
									name = L["In raid"],
									type = "select",
									values = {
										["NONE"] = L["None"],
										["SELF"] = L["Self(Chat Frame)"],
										["EMOTE"] = L["Emote"],
										["PARTY"] = L["Party"],
										["RAID"] = L["Raid"],
										["YELL"] = L["Yell"],
										["SAY"] = L["Say"],
									},
								},
							}
						}

					}
				},
			},
		},
		["raid_spells"] = {
			order = 6,
			name = L["Raid Spells"],
			type = "group",
			args = {
				enable = {
					order = 1,
					name = L["Enable"],
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["enabled"] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["enabled"] = value end
				},
				channel = {
					order = 2,
					name = L["Channel"],
					disabled = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["enabled"] end,
					get = function(info) return E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["channel"][info[#info]] end,
					set = function(info, value) E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["channel"][info[#info]] = value end,
					args = {
						["solo"] = {
							order = 1,
							name = L["Solo"],
							type = "select",
							values = {
								["NONE"] = L["None"],
								["SELF"] = L["Self(Chat Frame)"],
								["EMOTE"] = L["Emote"],
								["YELL"] = L["Yell"],
								["SAY"] = L["Say"],
							},
						},
						["party"] = {
							order = 2,
							name = L["In party"],
							type = "select",
							values = {
								["NONE"] = L["None"],
								["SELF"] = L["Self(Chat Frame)"],
								["EMOTE"] = L["Emote"],
								["PARTY"] = L["Party"],
								["YELL"] = L["Yell"],
								["SAY"] = L["Say"],
							},
						},
						["instance"] = {
							order = 3,
							name = L["In instance"],
							type = "select",
							values = {
								["NONE"] = L["None"],
								["SELF"] = L["Self(Chat Frame)"],
								["EMOTE"] = L["Emote"],
								["PARTY"] = L["Party"],
								["INSTANCE_CHAT"] = L["Instance"],
								["YELL"] = L["Yell"],
								["SAY"] = L["Say"],
							},
						},
						["raid"] = {
							order = 4,
							name = L["In raid"],
							type = "select",
							values = {
								["NONE"] = L["None"],
								["SELF"] = L["Self(Chat Frame)"],
								["EMOTE"] = L["Emote"],
								["PARTY"] = L["Party"],
								["RAID"] = L["Raid"],
								["YELL"] = L["Yell"],
								["SAY"] = L["Say"],
							},
						},
					}
				},
				ritual_of_summoning = {
					order = 10,
					name = function(info)
						return select(1, GetSpellInfo(P["WindTools"]["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["id"]))
					end,
					disabled = function(info)
						return not E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["enabled"]
					end,
					get = function(info)
						return E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]][info[#info]]
					end,
					set = function(info, value)
						E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]][info[#info]] = value
					end,
					func = function(info)
						E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["text"] = P["WindTools"]["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["text"]
					end,
					args = {
						enabled = {
							order = 1,
							name = L["Enable"],
						},
						use_raid_warning = {
							order = 2,
							name = L["Use raid warning"],
							hidden = function(info) return E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["channel"]["raid"] ~= "RAID" end,
						},
						default_text = {
							order = 3,
							type = "execute",
							name = L["Use default text"],
							
						},
						text = {
							order = 4,
							type = "input",
							width = 'full',
							name = L["Text for the interrupt casted by you"],
							desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%player_spell%", L["the spell link"]),
						},
						text_example = {
							order = 5,
							type = "description",
							hidden = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"]["ritual_of_summoning"]["enabled"] end,
							name = function(info)
								local custom_message = E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["text"]
								custom_message = gsub(custom_message, "%%player%%", UnitName("player"))
								custom_message = gsub(custom_message, "%%spell%%", GetSpellLink(E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["id"]))
								return "\n"..WT:ColorStr(L["Example"])..": "..custom_message
							end
						},
					},
				},
				create_soulwell = {
					order = 11,
					name = function(info)
						return select(1, GetSpellInfo(P["WindTools"]["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["id"]))
					end,
					disabled = function(info)
						return not E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["enabled"]
					end,
					get = function(info)
						return E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]][info[#info]]
					end,
					set = function(info, value)
						E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]][info[#info]] = value
					end,
					func = function(info)
						E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["text"] = P["WindTools"]["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["text"]
					end,
					args = {
						enabled = {
							order = 1,
							name = L["Enable"],
						},
						use_raid_warning = {
							order = 2,
							name = L["Use raid warning"],
							hidden = function(info) return E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["channel"]["raid"] ~= "RAID" end,
						},
						default_text = {
							order = 3,
							type = "execute",
							name = L["Use default text"],
							
						},
						text = {
							order = 4,
							type = "input",
							width = 'full',
							name = L["Text for the interrupt casted by you"],
							desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%player_spell%", L["the spell link"]),
						},
						text_example = {
							order = 5,
							type = "description",
							hidden = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["enabled"] end,
							name = function(info)
								local custom_message = E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["text"]
								custom_message = gsub(custom_message, "%%player%%", UnitName("player"))
								custom_message = gsub(custom_message, "%%spell%%", GetSpellLink(E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["id"]))
								return "\n"..WT:ColorStr(L["Example"])..": "..custom_message
							end
						},
					},
				},
				moll_e = {
					order = 12,
					name = function(info)
						return select(1, GetSpellInfo(P["WindTools"]["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["id"]))
					end,
					disabled = function(info)
						return not E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["enabled"]
					end,
					get = function(info)
						return E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]][info[#info]]
					end,
					set = function(info, value)
						E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]][info[#info]] = value
					end,
					func = function(info)
						E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["text"] = P["WindTools"]["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["text"]
					end,
					args = {
						enabled = {
							order = 1,
							name = L["Enable"],
						},
						use_raid_warning = {
							order = 2,
							name = L["Use raid warning"],
							hidden = function(info) return E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["channel"]["raid"] ~= "RAID" end,
						},
						default_text = {
							order = 3,
							type = "execute",
							name = L["Use default text"],
							
						},
						text = {
							order = 4,
							type = "input",
							width = 'full',
							name = L["Text for the interrupt casted by you"],
							desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%player_spell%", L["the spell link"]),
						},
						text_example = {
							order = 5,
							type = "description",
							hidden = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["enabled"] end,
							name = function(info)
								local custom_message = E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["text"]
								custom_message = gsub(custom_message, "%%player%%", UnitName("player"))
								custom_message = gsub(custom_message, "%%spell%%", GetSpellLink(E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["id"]))
								return "\n"..WT:ColorStr(L["Example"])..": "..custom_message
							end
						},
					},
				},
				katy_stampwhistle = {
					order = 13,
					name = function(info)
						return select(1, GetSpellInfo(P["WindTools"]["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["id"]))
					end,
					disabled = function(info)
						return not E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["enabled"]
					end,
					get = function(info)
						return E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]][info[#info]]
					end,
					set = function(info, value)
						E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]][info[#info]] = value
					end,
					func = function(info)
						E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["text"] = P["WindTools"]["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["text"]
					end,
					args = {
						enabled = {
							order = 1,
							name = L["Enable"],
						},
						use_raid_warning = {
							order = 2,
							name = L["Use raid warning"],
							hidden = function(info) return E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["channel"]["raid"] ~= "RAID" end,
						},
						default_text = {
							order = 3,
							type = "execute",
							name = L["Use default text"],
							
						},
						text = {
							order = 4,
							type = "input",
							width = 'full',
							name = L["Text for the interrupt casted by you"],
							desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%player_spell%", L["the spell link"]),
						},
						text_example = {
							order = 5,
							type = "description",
							hidden = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["enabled"] end,
							name = function(info)
								local custom_message = E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["text"]
								custom_message = gsub(custom_message, "%%player%%", UnitName("player"))
								custom_message = gsub(custom_message, "%%spell%%", GetSpellLink(E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["id"]))
								return "\n"..WT:ColorStr(L["Example"])..": "..custom_message
							end
						},
					},
				},
				conjure_refreshment = {
					order = 14,
					name = function(info)
						return select(1, GetSpellInfo(P["WindTools"]["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["id"]))
					end,
					disabled = function(info)
						return not E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["enabled"]
					end,
					get = function(info)
						return E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]][info[#info]]
					end,
					set = function(info, value)
						E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]][info[#info]] = value
					end,
					func = function(info)
						E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["text"] = P["WindTools"]["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["text"]
					end,
					args = {
						enabled = {
							order = 1,
							name = L["Enable"],
						},
						use_raid_warning = {
							order = 2,
							name = L["Use raid warning"],
							hidden = function(info) return E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["channel"]["raid"] ~= "RAID" end,
						},
						default_text = {
							order = 3,
							type = "execute",
							name = L["Use default text"],
							
						},
						text = {
							order = 4,
							type = "input",
							width = 'full',
							name = L["Text for the interrupt casted by you"],
							desc = FormatDesc("%player%", L["Name of the player"]).."\n"..FormatDesc("%player_spell%", L["the spell link"]),
						},
						text_example = {
							order = 5,
							type = "description",
							hidden = function(info) return not E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["enabled"] end,
							name = function(info)
								local custom_message = E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["text"]
								custom_message = gsub(custom_message, "%%player%%", UnitName("player"))
								custom_message = gsub(custom_message, "%%spell%%", GetSpellLink(E.db.WindTools["More Tools"]["Announce System"]["raid_spells"]["spells"][info[5]]["id"]))
								return "\n"..WT:ColorStr(L["Example"])..": "..custom_message
							end
						},
					},
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
				["font_color_enter"] = {
					order = 4,
					type = "color",
					name = L["Enter Combat"].." - "..L["Color"],
					hasAlpha = false,
					get = function(info)
						local t = E.db.WindTools["More Tools"]["Enter Combat Alert"]["style"]["font_color_enter"]
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b, a)
						E.db.WindTools["More Tools"]["Enter Combat Alert"]["style"]["font_color_enter"] = {}
						local t = E.db.WindTools["More Tools"]["Enter Combat Alert"]["style"]["font_color_enter"]
						t.r, t.g, t.b, t.a = r, g, b
					end,
				},
				["font_color_leave"] = {
					order = 5,
					type = "color",
					name = L["Leave Combat"].." - "..L["Color"],
					hasAlpha = false,
					get = function(info)
						local t = E.db.WindTools["More Tools"]["Enter Combat Alert"]["style"]["font_color_leave"]
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b, a)
						E.db.WindTools["More Tools"]["Enter Combat Alert"]["style"]["font_color_leave"] = {}
						local t = E.db.WindTools["More Tools"]["Enter Combat Alert"]["style"]["font_color_leave"]
						t.r, t.g, t.b, t.a = r, g, b
					end,
				},
				["use_backdrop"] = {
					order = 6,
					name = L["Use Backdrop"],
				},
				["stay_duration"] = {
					order = 7,
					type = "range",
					name = L["Stay Duration"],
					min = 0.1, max = 5.0, step = 0.01,
				},
				["animation_duration"] = {
					order = 8,
					type = "range",
					name = L["Animation Duration (Fade In)"],
					min = 0.1, max = 5.0, step = 0.01,
				},
				["scale"] = {
					order = 9,
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
	["Enhanced Tags"] = {
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
			E.Options.args.WindTools.args["More Tools"].args["Enhanced Tags"].args["enablebtn"].name = L["Chinese W/Y"]
		end,
	},
}