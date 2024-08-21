local W, F, E, L, V, P, G = unpack((select(2, ...)))
local options = W.options.announcement.args
local A = W:GetModule("Announcement")
local SB = W:GetModule("SwitchButtons")

local format = format
local gsub = gsub
local pairs = pairs
local tonumber = tonumber

local C_Spell_GetSpellLink = C_Spell.GetSpellLink
local C_Spell_GetSpellName = C_Spell.GetSpellName

local function ImportantColorString(string)
	return F.CreateColorString(string, { r = 0.204, g = 0.596, b = 0.859 })
end

local function FormatDesc(code, helpText)
	return ImportantColorString(code) .. " = " .. helpText
end

options.desc = {
	order = 1,
	type = "group",
	inline = true,
	name = L["Description"],
	args = {
		feature_1 = {
			order = 1,
			type = "description",
			name = L["Announcement module is a tool to help you send messages."],
			fontSize = "medium",
		},
		feature_2 = {
			order = 2,
			type = "description",
			name = L["You can customize the sentence templates, channels, etc."],
			fontSize = "medium",
		},
		feature_3 = {
			order = 3,
			type = "description",
			name = L["Besides the raid spells, it also provides numerous features to help you be a friendly player."],
			fontSize = "medium",
		},
	},
}

options.enable = {
	order = 2,
	type = "toggle",
	get = function(info)
		return E.db.WT.announcement[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.announcement[info[#info]] = value
		A:ProfileUpdate()
	end,
	name = L["Enable"],
}

options.quest = {
	order = 3,
	type = "group",
	name = L["Quest"],
	get = function(info)
		return E.db.WT.announcement[info[#info - 1]][info[#info]]
	end,
	set = function(info, value)
		E.db.WT.announcement[info[#info - 1]][info[#info]] = value
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
					name = L["Let your teammates know the progress of quests."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.db.WT.announcement[info[#info - 1]][info[#info]] = value
				SB:ProfileUpdate()
			end,
		},
		disableBlizzard = {
			order = 3,
			type = "toggle",
			name = L["Disable Blizzard"],
			desc = L["Disable Blizzard quest progress message."],
			set = function(info, value)
				E.db.WT.announcement[info[#info - 1]][info[#info]] = value
				A:UpdateBlizzardQuestAnnouncement()
			end,
		},
		includeDetails = {
			order = 4,
			type = "toggle",
			name = L["Include Details"],
			desc = L["Announce every time the progress has been changed."],
		},
		channel = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Channel"],
			get = function(info)
				return E.db.WT.announcement[info[#info - 2]][info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement[info[#info - 2]][info[#info - 1]][info[#info]] = value
			end,
			args = {
				party = {
					order = 1,
					name = L["In Party"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				instance = {
					order = 2,
					name = L["In Instance"],
					type = "select",
					values = {
						NONE = L["None"],
						PARTY = L["Party"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						INSTANCE_CHAT = L["Instance"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				raid = {
					order = 3,
					name = L["In Raid"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						RAID = L["Raid"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
			},
		},
		tag = {
			order = 6,
			type = "group",
			inline = true,
			name = L["Tag"],
			get = function(info)
				return E.db.WT.announcement.quest[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.quest[info[#info - 1]][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["The category of the quest."],
				},
				color = {
					order = 2,
					type = "color",
					name = L["Color"],
					hasAlpha = false,
					get = function(info)
						local colordb = E.db.WT.announcement.quest[info[#info - 1]].color
						local default = P.announcement.quest[info[#info - 1]].color
						return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
					end,
					set = function(info, r, g, b, a)
						E.db.WT.announcement.quest[info[#info - 1]].color = {
							r = r,
							g = g,
							b = b,
						}
					end,
				},
			},
		},
		suggestedGroup = {
			order = 7,
			type = "group",
			inline = true,
			name = L["Suggested Group"],
			get = function(info)
				return E.db.WT.announcement.quest[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.quest[info[#info - 1]][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["If the quest is suggested with multi-players, add the number of players to the message."],
				},
				color = {
					order = 2,
					type = "color",
					name = L["Color"],
					hasAlpha = false,
					get = function(info)
						local colordb = E.db.WT.announcement.quest[info[#info - 1]].color
						local default = P.announcement.quest[info[#info - 1]].color
						return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
					end,
					set = function(info, r, g, b, a)
						E.db.WT.announcement.quest[info[#info - 1]].color = {
							r = r,
							g = g,
							b = b,
						}
					end,
				},
			},
		},
		level = {
			order = 8,
			type = "group",
			inline = true,
			name = L["Level"],
			get = function(info)
				return E.db.WT.announcement.quest[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.quest[info[#info - 1]][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["The level of the quest."],
				},
				color = {
					order = 2,
					type = "color",
					name = L["Color"],
					hasAlpha = false,
					get = function(info)
						local colordb = E.db.WT.announcement.quest[info[#info - 1]].color
						local default = P.announcement.quest[info[#info - 1]].color
						return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
					end,
					set = function(info, r, g, b, a)
						E.db.WT.announcement.quest[info[#info - 1]].color = {
							r = r,
							g = g,
							b = b,
						}
					end,
				},
				hideOnMax = {
					order = 3,
					type = "toggle",
					name = L["Hide Max Level"],
					desc = L["Hide the level part if the quest level is the max level of this expansion."],
				},
			},
		},
		daily = {
			order = 9,
			type = "group",
			inline = true,
			name = L["Daily"],
			get = function(info)
				return E.db.WT.announcement.quest[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.quest[info[#info - 1]][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add the prefix if the quest is a daily quest."],
				},
				color = {
					order = 2,
					type = "color",
					name = L["Color"],
					hasAlpha = false,
					get = function(info)
						local colordb = E.db.WT.announcement.quest[info[#info - 1]].color
						local default = P.announcement.quest[info[#info - 1]].color
						return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
					end,
					set = function(info, r, g, b, a)
						E.db.WT.announcement.quest[info[#info - 1]].color = {
							r = r,
							g = g,
							b = b,
						}
					end,
				},
			},
		},
		weekly = {
			order = 10,
			type = "group",
			inline = true,
			name = L["Weekly"],
			get = function(info)
				return E.db.WT.announcement.quest[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.quest[info[#info - 1]][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add the prefix if the quest is a weekly quest."],
				},
				color = {
					order = 2,
					type = "color",
					name = L["Color"],
					hasAlpha = false,
					get = function(info)
						local colordb = E.db.WT.announcement.quest[info[#info - 1]].color
						local default = P.announcement.quest[info[#info - 1]].color
						return colordb.r, colordb.g, colordb.b, colordb.a, default.r, default.g, default.b, default.a
					end,
					set = function(info, r, g, b, a)
						E.db.WT.announcement.quest[info[#info - 1]].color = {
							r = r,
							g = g,
							b = b,
						}
					end,
				},
			},
		},
	},
}

options.interrupt = {
	order = 4,
	type = "group",
	name = L["Interrupt"],
	get = function(info)
		return E.db.WT.announcement[info[#info - 1]][info[#info]]
	end,
	set = function(info, value)
		E.db.WT.announcement[info[#info - 1]][info[#info]] = value
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
					name = L["Send messages after the spell has been interrupted."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.db.WT.announcement[info[#info - 1]][info[#info]] = value
				A:ResetAuthority()
			end,
		},
		onlyInstance = {
			order = 3,
			type = "toggle",
			name = L["Only Instance"],
			desc = L["Disable announcement in open world."],
		},
		player = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Player(Only you)"],
			get = function(info)
				return E.db.WT.announcement.interrupt[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.interrupt[info[#info - 1]][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					width = "full",
				},
				text = {
					order = 2,
					type = "input",
					name = L["Text"],
					desc = format(
						"%s\n%s\n%s\n%s",
						FormatDesc("%player%", L["Your name"]),
						FormatDesc("%target%", L["Target name"]),
						FormatDesc("%player_spell%", L["Your spell link"]),
						FormatDesc("%target_spell%", L["Interrupted spell link"])
					),
					width = 2.5,
				},
				useDefaultText = {
					order = 3,
					type = "execute",
					name = L["Use default text"],
					func = function(info)
						E.db.WT.announcement.interrupt[info[#info - 1]].text =
							P.announcement.interrupt[info[#info - 1]].text
					end,
				},
				example = {
					order = 4,
					type = "description",
					name = function(info)
						local message = E.db.WT.announcement.interrupt[info[#info - 1]].text
						message = gsub(message, "%%player%%", E.myname)
						message = gsub(message, "%%target%%", L["Sylvanas"])
						message = gsub(message, "%%player_spell%%", C_Spell_GetSpellLink(31935))
						message = gsub(message, "%%target_spell%%", C_Spell_GetSpellLink(252150))
						return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
					end,
				},
				channel = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Channel"],
					get = function(info)
						return E.db.WT.announcement.interrupt[info[#info - 2]][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.WT.announcement.interrupt[info[#info - 2]][info[#info - 1]][info[#info]] = value
					end,
					args = {
						solo = {
							order = 1,
							name = L["Solo"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						party = {
							order = 2,
							name = L["In Party"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						instance = {
							order = 3,
							name = L["In Instance"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								INSTANCE_CHAT = L["Instance"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						raid = {
							order = 4,
							name = L["In Raid"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								RAID = L["Raid"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
					},
				},
			},
		},
		others = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Other Players"],
			get = function(info)
				return E.db.WT.announcement.interrupt[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.interrupt[info[#info - 1]][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					set = function(info, value)
						E.db.WT.announcement.interrupt[info[#info - 1]][info[#info]] = value
						A:ResetAuthority()
					end,
					width = "full",
				},
				text = {
					order = 2,
					type = "input",
					name = L["Text"],
					desc = format(
						"%s\n%s\n%s\n%s",
						FormatDesc("%player%", L["Name of the player"]),
						FormatDesc("%target%", L["Target name"]),
						FormatDesc("%player_spell%", L["The spell link"]),
						FormatDesc("%target_spell%", L["Interrupted spell link"])
					),
					width = 2.5,
				},
				useDefaultText = {
					order = 3,
					type = "execute",
					name = L["Use default text"],
					func = function(info)
						E.db.WT.announcement.interrupt[info[#info - 1]].text =
							P.announcement.interrupt[info[#info - 1]].text
					end,
				},
				example = {
					order = 4,
					type = "description",
					name = function(info)
						local message = E.db.WT.announcement.interrupt[info[#info - 1]].text
						message = gsub(message, "%%player%%", E.myname)
						message = gsub(message, "%%target%%", L["Sylvanas"])
						message = gsub(message, "%%player_spell%%", C_Spell_GetSpellLink(31935))
						message = gsub(message, "%%target_spell%%", C_Spell_GetSpellLink(252150))
						return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
					end,
				},
				channel = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Channel"],
					get = function(info)
						return E.db.WT.announcement.interrupt[info[#info - 2]][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.WT.announcement.interrupt[info[#info - 2]][info[#info - 1]][info[#info]] = value
						A:ResetAuthority()
					end,
					args = {
						party = {
							order = 1,
							name = L["In Party"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						instance = {
							order = 2,
							name = L["In Instance"],
							type = "select",
							values = {
								NONE = L["None"],
								PARTY = L["Party"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								INSTANCE_CHAT = L["Instance"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						raid = {
							order = 3,
							name = L["In Raid"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								RAID = L["Raid"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
					},
				},
			},
		},
	},
}

options.dispel = {
	order = 5,
	type = "group",
	name = L["Dispel"],
	get = function(info)
		return E.db.WT.announcement[info[#info - 1]][info[#info]]
	end,
	set = function(info, value)
		E.db.WT.announcement[info[#info - 1]][info[#info]] = value
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
					name = L["Send messages after the spell has been dispelled."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.db.WT.announcement[info[#info - 1]][info[#info]] = value
				A:ResetAuthority()
			end,
		},
		onlyInstance = {
			order = 3,
			type = "toggle",
			name = L["Only Instance"],
			desc = L["Disable announcement in open world."],
		},
		player = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Player(Only you)"],
			get = function(info)
				return E.db.WT.announcement.dispel[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.dispel[info[#info - 1]][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					width = "full",
				},
				text = {
					order = 2,
					type = "input",
					name = L["Text"],
					desc = format(
						"%s\n%s\n%s\n%s",
						FormatDesc("%player%", L["Your name"]),
						FormatDesc("%target%", L["Target name"]),
						FormatDesc("%player_spell%", L["Your spell link"]),
						FormatDesc("%target_spell%", L["Dispelled spell link"])
					),
					width = 2.5,
				},
				useDefaultText = {
					order = 3,
					type = "execute",
					name = L["Use default text"],
					func = function(info)
						E.db.WT.announcement.dispel[info[#info - 1]].text = P.announcement.dispel[info[#info - 1]].text
					end,
				},
				example = {
					order = 4,
					type = "description",
					name = function(info)
						local message = E.db.WT.announcement.dispel[info[#info - 1]].text
						message = gsub(message, "%%player%%", E.myname)
						message = gsub(message, "%%target%%", L["Sylvanas"])
						message = gsub(message, "%%player_spell%%", C_Spell_GetSpellLink(31935))
						message = gsub(message, "%%target_spell%%", C_Spell_GetSpellLink(252150))
						return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
					end,
				},
				channel = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Channel"],
					get = function(info)
						return E.db.WT.announcement.dispel[info[#info - 2]][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.WT.announcement.dispel[info[#info - 2]][info[#info - 1]][info[#info]] = value
					end,
					args = {
						solo = {
							order = 1,
							name = L["Solo"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						party = {
							order = 2,
							name = L["In Party"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						instance = {
							order = 3,
							name = L["In Instance"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								INSTANCE_CHAT = L["Instance"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						raid = {
							order = 4,
							name = L["In Raid"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								RAID = L["Raid"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
					},
				},
			},
		},
		others = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Other Players"],
			get = function(info)
				return E.db.WT.announcement.dispel[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.dispel[info[#info - 1]][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					set = function(info, value)
						E.db.WT.announcement.dispel[info[#info - 1]][info[#info]] = value
						A:ResetAuthority()
					end,
					width = "full",
				},
				text = {
					order = 2,
					type = "input",
					name = L["Text"],
					desc = format(
						"%s\n%s\n%s\n%s",
						FormatDesc("%player%", L["Name of the player"]),
						FormatDesc("%target%", L["Target name"]),
						FormatDesc("%player_spell%", L["The spell link"]),
						FormatDesc("%target_spell%", L["Dispelled spell link"])
					),
					width = 2.5,
				},
				useDefaultText = {
					order = 3,
					type = "execute",
					name = L["Use default text"],
					func = function(info)
						E.db.WT.announcement.dispel[info[#info - 1]].text = P.announcement.dispel[info[#info - 1]].text
					end,
				},
				example = {
					order = 4,
					type = "description",
					name = function(info)
						local message = E.db.WT.announcement.dispel[info[#info - 1]].text
						message = gsub(message, "%%player%%", E.myname)
						message = gsub(message, "%%target%%", L["Sylvanas"])
						message = gsub(message, "%%player_spell%%", C_Spell_GetSpellLink(31935))
						message = gsub(message, "%%target_spell%%", C_Spell_GetSpellLink(252150))
						return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
					end,
				},
				channel = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Channel"],
					get = function(info)
						return E.db.WT.announcement.dispel[info[#info - 2]][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.WT.announcement.dispel[info[#info - 2]][info[#info - 1]][info[#info]] = value
						A:ResetAuthority()
					end,
					args = {
						party = {
							order = 1,
							name = L["In Party"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						instance = {
							order = 2,
							name = L["In Instance"],
							type = "select",
							values = {
								NONE = L["None"],
								PARTY = L["Party"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								INSTANCE_CHAT = L["Instance"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						raid = {
							order = 3,
							name = L["In Raid"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								RAID = L["Raid"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
					},
				},
			},
		},
	},
}

options.taunt = {
	order = 6,
	type = "group",
	name = L["Taunt"],
	get = function(info)
		return E.db.WT.announcement[info[#info - 1]][info[#info]]
	end,
	set = function(info, value)
		E.db.WT.announcement[info[#info - 1]][info[#info]] = value
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
					name = L["Send messages after taunt succeeded or failed."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.db.WT.announcement[info[#info - 1]][info[#info]] = value
				A:ResetAuthority()
			end,
		},
		playerPlayer = {
			order = 3,
			name = L["Player"],
			type = "group",
			get = function(info)
				return E.db.WT.announcement.taunt.player.player[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.taunt.player.player[info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				success = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Success"],
					args = {
						successText = {
							order = 1,
							type = "input",
							name = L["Text"],
							desc = format(
								"%s\n%s\n%s",
								FormatDesc("%player%", L["Your name"]),
								FormatDesc("%target%", L["Target name"]),
								FormatDesc("%spell%", L["Your spell link"])
							),
							width = 2,
						},
						useDefaultText = {
							order = 2,
							type = "execute",
							func = function()
								E.db.WT.announcement.taunt.player.player.successText =
									P.announcement.taunt.player.player.successText
							end,
							name = L["Default Text"],
						},
						example = {
							order = 3,
							type = "description",
							name = function()
								local message = E.db.WT.announcement.taunt.player.player.successText
								message = gsub(message, "%%player%%", E.myname)
								message = gsub(message, "%%target%%", L["Sylvanas"])
								message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(20484))
								return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
							end,
						},
					},
				},
				tauntAll = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Taunt All"],
					args = {
						tauntAllText = {
							order = 1,
							type = "input",
							name = L["Text"],
							desc = format(
								"%s\n%s",
								FormatDesc("%player%", L["Your name"]),
								FormatDesc("%spell%", L["Your spell link"])
							),
							width = 2,
						},
						useDefaultText = {
							order = 2,
							type = "execute",
							func = function()
								E.db.WT.announcement.taunt.player.player.tauntAllText =
									P.announcement.taunt.player.player.tauntAllText
							end,
							name = L["Default Text"],
						},
						example = {
							order = 3,
							type = "description",
							name = function()
								local message = E.db.WT.announcement.taunt.player.player.tauntAllText
								message = gsub(message, "%%player%%", E.myname)
								message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(20484))
								return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
							end,
						},
					},
				},
				failed = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Failed"],
					args = {
						failedText = {
							order = 1,
							type = "input",
							name = L["Text"],
							desc = format(
								"%s\n%s\n%s",
								FormatDesc("%player%", L["Your name"]),
								FormatDesc("%target%", L["Target name"]),
								FormatDesc("%spell%", L["Your spell link"])
							),
							width = 2,
						},
						useDefaultText = {
							order = 2,
							type = "execute",
							func = function()
								E.db.WT.announcement.taunt.player.player.failedText =
									P.announcement.taunt.player.player.failedText
							end,
							name = L["Default Text"],
						},
						example = {
							order = 3,
							type = "description",
							name = function()
								local message = E.db.WT.announcement.taunt.player.player.failedText
								message = gsub(message, "%%player%%", E.myname)
								message = gsub(message, "%%target%%", L["Sylvanas"])
								message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(20484))
								return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
							end,
						},
					},
				},
				channel = {
					order = 5,
					name = L["Channel"],
					type = "group",
					inline = true,
					get = function(info)
						return E.db.WT.announcement.taunt.player.player.channel[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.announcement.taunt.player.player.channel[info[#info]] = value
					end,
					args = {
						solo = {
							order = 1,
							name = L["Solo"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						party = {
							order = 2,
							name = L["In Party"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						instance = {
							order = 3,
							name = L["In Instance"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								INSTANCE_CHAT = L["Instance"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						raid = {
							order = 4,
							name = L["In Raid"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								RAID = L["Raid"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
					},
				},
			},
		},
		playerPet = {
			order = 4,
			name = L["Your Pet"],
			type = "group",
			get = function(info)
				return E.db.WT.announcement.taunt.player.pet[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.taunt.player.pet[info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				success = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Success"],
					args = {
						successText = {
							order = 1,
							type = "input",
							name = L["Text"],
							desc = format(
								"%s\n%s\n%s\n%s\n%s",
								FormatDesc("%player%", L["Your name"]),
								FormatDesc("%pet%", L["Pet name"]),
								FormatDesc("%pet_role%", L["Pet role"]),
								FormatDesc("%target%", L["Target name"]),
								FormatDesc("%spell%", L["The spell link"])
							),
							width = 2,
						},
						useDefaultText = {
							order = 2,
							type = "execute",
							func = function()
								E.db.WT.announcement.taunt.player.pet.successText =
									P.announcement.taunt.player.pet.successText
							end,
							name = L["Default Text"],
						},
						example = {
							order = 3,
							type = "description",
							name = function()
								local message = E.db.WT.announcement.taunt.player.pet.successText
								message = gsub(message, "%%player%%", E.myname)
								message = gsub(message, "%%pet%%", L["Niuzao"])
								message = gsub(message, "%%pet_role%%", L["Totem"])
								message = gsub(message, "%%target%%", L["Sylvanas"])
								message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(20484))
								return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
							end,
						},
					},
				},
				failed = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Failed"],
					args = {
						failedText = {
							order = 1,
							type = "input",
							name = L["Text"],
							desc = format(
								"%s\n%s\n%s\n%s\n%s",
								FormatDesc("%player%", L["Your name"]),
								FormatDesc("%pet%", L["Pet name"]),
								FormatDesc("%pet_role%", L["Pet role"]),
								FormatDesc("%target%", L["Target name"]),
								FormatDesc("%spell%", L["The spell link"])
							),
							width = 2,
						},
						useDefaultText = {
							order = 2,
							type = "execute",
							func = function()
								E.db.WT.announcement.taunt.player.pet.failedText =
									P.announcement.taunt.player.pet.failedText
							end,
							name = L["Default Text"],
						},
						example = {
							order = 3,
							type = "description",
							name = function()
								local message = E.db.WT.announcement.taunt.player.pet.failedText
								message = gsub(message, "%%player%%", E.myname)
								message = gsub(message, "%%pet%%", L["Niuzao"])
								message = gsub(message, "%%pet_role%%", L["Totem"])
								message = gsub(message, "%%target%%", L["Sylvanas"])
								message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(20484))
								return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
							end,
						},
					},
				},
				channel = {
					order = 4,
					name = L["Channel"],
					type = "group",
					inline = true,
					get = function(info)
						return E.db.WT.announcement.taunt.player.pet.channel[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.announcement.taunt.player.pet.channel[info[#info]] = value
					end,
					args = {
						solo = {
							order = 1,
							name = L["Solo"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						party = {
							order = 2,
							name = L["In Party"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						instance = {
							order = 3,
							name = L["In Instance"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								INSTANCE_CHAT = L["Instance"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						raid = {
							order = 4,
							name = L["In Raid"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								RAID = L["Raid"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
					},
				},
			},
		},
		othersPlayer = {
			order = 5,
			name = L["Other Players"],
			type = "group",
			get = function(info)
				return E.db.WT.announcement.taunt.others.player[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.taunt.others.player[info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					set = function(info, value)
						E.db.WT.announcement.taunt.others.player[info[#info]] = value
						A:ResetAuthority()
					end,
				},
				success = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Success"],
					args = {
						successText = {
							order = 1,
							type = "input",
							name = L["Text"],
							desc = format(
								"%s\n%s\n%s",
								FormatDesc("%player%", L["Name of the player"]),
								FormatDesc("%target%", L["Target name"]),
								FormatDesc("%spell%", L["The spell link"])
							),
							width = 2,
						},
						useDefaultText = {
							order = 2,
							type = "execute",
							func = function()
								E.db.WT.announcement.taunt.others.player.successText =
									P.announcement.taunt.others.player.successText
							end,
							name = L["Default Text"],
						},
						example = {
							order = 3,
							type = "description",
							name = function()
								local message = E.db.WT.announcement.taunt.others.player.successText
								message = gsub(message, "%%player%%", E.myname)
								message = gsub(message, "%%target%%", L["Sylvanas"])
								message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(20484))
								return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
							end,
						},
					},
				},
				tauntAll = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Taunt All"],
					args = {
						tauntAllText = {
							order = 1,
							type = "input",
							name = L["Text"],
							desc = format(
								"%s\n%s",
								FormatDesc("%player%", L["The name of the player"]),
								FormatDesc("%spell%", L["The spell link"])
							),
							width = 2,
						},
						useDefaultText = {
							order = 2,
							type = "execute",
							func = function()
								E.db.WT.announcement.taunt.others.player.tauntAllText =
									P.announcement.taunt.others.player.tauntAllText
							end,
							name = L["Default Text"],
						},
						example = {
							order = 3,
							type = "description",
							name = function()
								local message = E.db.WT.announcement.taunt.others.player.tauntAllText
								message = gsub(message, "%%player%%", E.myname)
								message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(20484))
								return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
							end,
						},
					},
				},
				failed = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Failed"],
					args = {
						failedText = {
							order = 1,
							type = "input",
							name = L["Text"],
							desc = format(
								"%s\n%s\n%s",
								FormatDesc("%player%", L["Name of the player"]),
								FormatDesc("%target%", L["Target name"]),
								FormatDesc("%spell%", L["The spell link"])
							),
							width = 2,
						},
						useDefaultText = {
							order = 2,
							type = "execute",
							func = function()
								E.db.WT.announcement.taunt.others.player.failedText =
									P.announcement.taunt.others.player.failedText
							end,
							name = L["Default Text"],
						},
						example = {
							order = 3,
							type = "description",
							name = function()
								local message = E.db.WT.announcement.taunt.others.player.failedText
								message = gsub(message, "%%player%%", E.myname)
								message = gsub(message, "%%target%%", L["Sylvanas"])
								message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(20484))
								return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
							end,
						},
					},
				},
				channel = {
					order = 5,
					name = L["Channel"],
					type = "group",
					inline = true,
					get = function(info)
						return E.db.WT.announcement.taunt.others.player.channel[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.announcement.taunt.others.player.channel[info[#info]] = value
						A:ResetAuthority()
					end,
					args = {
						party = {
							order = 1,
							name = L["In Party"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						instance = {
							order = 2,
							name = L["In Instance"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								INSTANCE_CHAT = L["Instance"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						raid = {
							order = 3,
							name = L["In Raid"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								RAID = L["Raid"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
					},
				},
			},
		},
		othersPet = {
			order = 6,
			name = L["Other Players' Pet"],
			type = "group",
			get = function(info)
				return E.db.WT.announcement.taunt.others.pet[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.taunt.others.pet[info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					set = function(info, value)
						E.db.WT.announcement.taunt.others.pet[info[#info]] = value
						A:ResetAuthority()
					end,
				},
				success = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Success"],
					args = {
						successText = {
							order = 1,
							type = "input",
							name = L["Text"],
							desc = format(
								"%s\n%s\n%s\n%s\n%s",
								FormatDesc("%player%", L["Name of the player"]),
								FormatDesc("%pet%", L["Pet name"]),
								FormatDesc("%pet_role%", L["Pet role"]),
								FormatDesc("%target%", L["Target name"]),
								FormatDesc("%spell%", L["The spell link"])
							),
							width = 2,
						},
						useDefaultText = {
							order = 2,
							type = "execute",
							func = function()
								E.db.WT.announcement.taunt.others.pet.successText =
									P.announcement.taunt.others.pet.successText
							end,
							name = L["Default Text"],
						},
						example = {
							order = 3,
							type = "description",
							name = function()
								local message = E.db.WT.announcement.taunt.others.pet.successText
								message = gsub(message, "%%player%%", E.myname)
								message = gsub(message, "%%pet%%", L["Niuzao"])
								message = gsub(message, "%%pet_role%%", L["Totem"])
								message = gsub(message, "%%target%%", L["Sylvanas"])
								message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(20484))
								return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
							end,
						},
					},
				},
				failed = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Failed"],
					args = {
						failedText = {
							order = 1,
							type = "input",
							name = L["Text"],
							desc = format(
								"%s\n%s\n%s\n%s\n%s",
								FormatDesc("%player%", L["Name of the player"]),
								FormatDesc("%pet%", L["Pet name"]),
								FormatDesc("%pet_role%", L["Pet role"]),
								FormatDesc("%target%", L["Target name"]),
								FormatDesc("%spell%", L["The spell link"])
							),
							width = 2,
						},
						useDefaultText = {
							order = 2,
							type = "execute",
							func = function()
								E.db.WT.announcement.taunt.others.pet.failedText =
									P.announcement.taunt.others.pet.failedText
							end,
							name = L["Default Text"],
						},
						example = {
							order = 3,
							type = "description",
							name = function()
								local message = E.db.WT.announcement.taunt.others.pet.failedText
								message = gsub(message, "%%player%%", E.myname)
								message = gsub(message, "%%pet%%", L["Niuzao"])
								message = gsub(message, "%%pet_role%%", L["Totem"])
								message = gsub(message, "%%target%%", L["Sylvanas"])
								message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(20484))
								return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
							end,
						},
					},
				},
				channel = {
					order = 4,
					name = L["Channel"],
					type = "group",
					inline = true,
					get = function(info)
						return E.db.WT.announcement.taunt.others.pet.channel[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.announcement.taunt.others.pet.channel[info[#info]] = value
						A:ResetAuthority()
					end,
					args = {
						party = {
							order = 1,
							name = L["In Party"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						instance = {
							order = 2,
							name = L["In Instance"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								INSTANCE_CHAT = L["Instance"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
						raid = {
							order = 3,
							name = L["In Raid"],
							type = "select",
							values = {
								NONE = L["None"],
								SELF = L["Self (Chat Frame)"],
								EMOTE = L["Emote"],
								PARTY = L["Party"],
								RAID = L["Raid"],
								YELL = L["Yell"],
								SAY = L["Say"],
							},
						},
					},
				},
			},
		},
	},
}

options.combatResurrection = {
	order = 7,
	type = "group",
	name = L["Combat Resurrection"],
	get = function(info)
		return E.db.WT.announcement[info[#info - 1]][info[#info]]
	end,
	set = function(info, value)
		E.db.WT.announcement[info[#info - 1]][info[#info]] = value
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
					name = L["Send messages about combat resurrection use."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.db.WT.announcement[info[#info - 1]][info[#info]] = value
				A:ResetAuthority()
			end,
		},
		onlySourceIsPlayer = {
			order = 3,
			type = "toggle",
			name = L["Only You"],
			desc = L["Only send messages after you cast combat resurrection."],
		},
		raidWarning = {
			order = 4,
			type = "toggle",
			name = L["Raid Warning"],
			desc = L["If you have privilege, it would the message to raid warning(/rw) rather than raid(/r)."],
			set = function(info, value)
				E.db.WT.announcement[info[#info - 1]][info[#info]] = value
				A:ResetAuthority()
			end,
		},
		text = {
			order = 5,
			type = "input",
			name = L["Text"],
			desc = format(
				"%s\n%s\n%s",
				FormatDesc("%player%", L["Name of the player"]),
				FormatDesc("%target%", L["Target name"]),
				FormatDesc("%spell%", L["The spell link"])
			),
			width = 2.5,
		},
		useDefaultText = {
			order = 6,
			type = "execute",
			func = function(info)
				E.db.WT.announcement.combatResurrection.text = P.announcement.combatResurrection.text
			end,
			name = L["Default Text"],
		},
		example = {
			order = 7,
			type = "description",
			name = function()
				local message = E.db.WT.announcement.combatResurrection.text
				message = gsub(message, "%%player%%", E.myname)
				message = gsub(message, "%%target%%", L["Sylvanas"])
				message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(20484))
				return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
			end,
		},
		channel = {
			order = 8,
			name = L["Channel"],
			type = "group",
			inline = true,
			get = function(info)
				return E.db.WT.announcement.combatResurrection[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.combatResurrection[info[#info - 1]][info[#info]] = value
				A:ResetAuthority()
			end,
			args = {
				solo = {
					order = 1,
					name = L["Solo"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				party = {
					order = 2,
					name = L["In Party"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				instance = {
					order = 3,
					name = L["In Instance"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						INSTANCE_CHAT = L["Instance"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				raid = {
					order = 4,
					name = L["In Raid"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						RAID = L["Raid"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
			},
		},
	},
}

options.utility = {
	order = 8,
	type = "group",
	name = L["Utility"],
	get = function(info)
		return E.db.WT.announcement[info[#info - 1]][info[#info]]
	end,
	set = function(info, value)
		E.db.WT.announcement[info[#info - 1]][info[#info]] = value
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
					name = L["Send the use of portals, ritual of summoning, feasts, etc."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.db.WT.announcement[info[#info - 1]][info[#info]] = value
				A:ResetAuthority()
			end,
		},
		channel = {
			order = 3,
			name = L["Channel"],
			type = "group",
			inline = true,
			get = function(info)
				return E.db.WT.announcement.utility[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.utility[info[#info - 1]][info[#info]] = value
				A:ResetAuthority()
			end,
			args = {
				solo = {
					order = 1,
					name = L["Solo"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				party = {
					order = 2,
					name = L["In Party"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				instance = {
					order = 3,
					name = L["In Instance"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						INSTANCE_CHAT = L["Instance"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				raid = {
					order = 4,
					name = L["In Raid"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						RAID = L["Raid"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
			},
		},
	},
}

do
	local categoryLocales = {
		feasts = L["Feasts"],
		bots = L["Bots"],
		toys = L["Toys"],
		portals = L["Portals"],
	}

	local specialExampleSpell = {
		feasts = 286050,
		bots = 67826,
		toys = 61031,
		portals = 10059,
	}

	local spellOptions = options.utility.args
	local spellOrder = 10
	local categoryOrder = 50
	for categoryOrId, config in pairs(P.announcement.utility.spells) do
		local groupName, groupOrder, exampleSpellId
		local id = tonumber(categoryOrId)
		if id then
			groupName = C_Spell_GetSpellName(id)
			exampleSpellId = id
			groupOrder = spellOrder
			spellOrder = spellOrder + 1
		else
			groupName = categoryLocales[categoryOrId]
			exampleSpellId = specialExampleSpell[categoryOrId]
			groupOrder = categoryOrder
			categoryOrder = categoryOrder + 1
		end

		exampleSpellId = exampleSpellId or 20484

		spellOptions[categoryOrId] = {
			order = groupOrder,
			name = groupName,
			type = "group",
			get = function(info)
				return E.db.WT.announcement.utility.spells[categoryOrId][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.utility.spells[categoryOrId][info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				includePlayer = {
					order = 2,
					type = "toggle",
					name = L["Include Player"],
					desc = L["Uncheck this box, it will not send message if you cast the spell."],
				},
				raidWarning = {
					order = 3,
					type = "toggle",
					name = L["Raid Warning"],
					desc = L["If you have privilege, it would the message to raid warning(/rw) rather than raid(/r)."],
				},
				text = {
					order = 4,
					type = "input",
					name = L["Text"],
					desc = format(
						"%s\n%s\n%s",
						FormatDesc("%player%", L["Name of the player"]),
						FormatDesc("%target%", L["Target name"]),
						FormatDesc("%spell%", L["The spell link"])
					),
					width = 2.5,
				},
				useDefaultText = {
					order = 5,
					type = "execute",
					func = function()
						E.db.WT.announcement.utility.spells[categoryOrId].text =
							P.announcement.utility.spells[categoryOrId].text
					end,
					name = L["Default Text"],
				},
				example = {
					order = 6,
					type = "description",
					name = function()
						local message = E.db.WT.announcement.utility.spells[categoryOrId].text
						message = gsub(message, "%%player%%", E.myname)
						message = gsub(message, "%%target%%", L["Sylvanas"])
						message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(exampleSpellId))
						return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n"
					end,
				},
			},
		}
	end
end

options.threatTransfer = {
	order = 9,
	type = "group",
	name = L["Threat Transfer"],
	get = function(info)
		return E.db.WT.announcement.threatTransfer[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.announcement.threatTransfer[info[#info]] = value
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
					name = L["Alert teammates that the threat transfer spell being used."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.db.WT.announcement.threatTransfer[info[#info]] = value
				A:ResetAuthority()
			end,
		},
		raidWarning = {
			order = 3,
			type = "toggle",
			name = L["Raid Warning"],
			desc = L["If you have privilege, it would the message to raid warning(/rw) rather than raid(/r)."],
			set = function(info, value)
				E.db.WT.announcement.threatTransfer[info[#info]] = value
				A:ResetAuthority()
			end,
		},
		situation = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Situations"],
			args = {
				onlyNotTank = {
					order = 1,
					type = "toggle",
					name = L["Only Not Tank"],
					desc = L["Only announce when the target is not a tank."],
					set = function(info, value)
						E.db.WT.announcement.threatTransfer[info[#info]] = value
						A:ResetAuthority()
					end,
				},
				forceSourceIsPlayer = {
					order = 2,
					type = "toggle",
					name = L["Source"],
					desc = L["Force to announce if the spell which is cast by you."],
					hidden = function()
						return not E.db.WT.announcement.threatTransfer.onlyNotTank
					end,
				},
				forceDestIsPlayer = {
					order = 3,
					type = "toggle",
					name = L["Target"],
					desc = L["Force to announce if the target is you."],
					hidden = function()
						return not E.db.WT.announcement.threatTransfer.onlyNotTank
					end,
				},
			},
		},
		text = {
			order = 5,
			type = "input",
			name = L["Text"],
			width = 2.5,
		},
		useDefaultText = {
			order = 6,
			type = "execute",
			func = function(info)
				E.db.WT.announcement.threatTransfer.text = P.announcement.threatTransfer.text
			end,
			name = L["Default Text"],
		},
		channel = {
			order = 7,
			name = L["Channel"],
			type = "group",
			inline = true,
			get = function(info)
				return E.db.WT.announcement.threatTransfer[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.threatTransfer[info[#info - 1]][info[#info]] = value
				A:ResetAuthority()
			end,
			args = {
				solo = {
					order = 1,
					name = L["Solo"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				party = {
					order = 2,
					name = L["In Party"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				instance = {
					order = 3,
					name = L["In Instance"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						INSTANCE_CHAT = L["Instance"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				raid = {
					order = 4,
					name = L["In Raid"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						RAID = L["Raid"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
			},
		},
	},
}

options.goodbye = {
	order = 10,
	type = "group",
	name = L["Goodbye"],
	get = function(info)
		return E.db.WT.announcement[info[#info - 1]][info[#info]]
	end,
	set = function(info, value)
		E.db.WT.announcement[info[#info - 1]][info[#info]] = value
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
					name = L["Say goodbye after dungeon completed."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
		},
		delay = {
			order = 3,
			name = L["Delay (sec)"],
			desc = format(L["Default is %s."], P.announcement.goodbye.delay),
			type = "range",
			min = 0,
			max = 20,
			step = 1,
		},
		text = {
			order = 4,
			type = "input",
			name = L["Text"],
			width = 2.5,
		},
		useDefaultText = {
			order = 5,
			type = "execute",
			func = function(info)
				E.db.WT.announcement.goodbye.text = P.announcement.goodbye.text
			end,
			name = L["Default Text"],
		},
		channel = {
			order = 6,
			name = L["Channel"],
			type = "group",
			inline = true,
			get = function(info)
				return E.db.WT.announcement.goodbye[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.goodbye[info[#info - 1]][info[#info]] = value
			end,
			args = {
				party = {
					order = 1,
					name = L["In Party"],
					type = "select",
					values = {
						NONE = L["None"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				instance = {
					order = 2,
					name = L["In Instance"],
					type = "select",
					values = {
						NONE = L["None"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						INSTANCE_CHAT = L["Instance"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				raid = {
					order = 3,
					name = L["In Raid"],
					type = "select",
					values = {
						NONE = L["None"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						RAID = L["Raid"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
			},
		},
	},
}

options.thanks = {
	order = 11,
	type = "group",
	name = L["Thanks"],
	get = function(info)
		return E.db.WT.announcement.thanks[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.announcement.thanks[info[#info]] = value
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
					name = L["Say thanks to the people who helped you."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
		},
		delay = {
			order = 3,
			name = L["Delay (sec)"],
			desc = format(L["Default is %s."], P.announcement.thanks.delay),
			type = "range",
			min = 0,
			max = 20,
			step = 1,
			disabled = function()
				return not E.db.WT.announcement.thanks.enable
			end,
		},
		enhancement = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Enhancement"],
			disabled = function()
				return not E.db.WT.announcement.thanks.enable or not E.db.WT.announcement.thanks.enhancement
			end,
			args = {
				enhancement = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					disabled = function()
						return not E.db.WT.announcement.thanks.enable
					end,
					width = "full",
				},
				enhancementText = {
					order = 2,
					type = "input",
					name = L["Text"],
					desc = format(
						"%s\n%s\n%s",
						FormatDesc("%player%", L["Your name"]),
						FormatDesc("%target%", L["Target name"]),
						FormatDesc("%spell%", L["The spell link"])
					),
					width = 2.5,
				},
				useDefaultText = {
					order = 3,
					type = "execute",
					func = function()
						E.db.WT.announcement.thanks.enhancementText = P.announcement.thanks.enhancementText
					end,
					name = L["Default Text"],
				},
				example = {
					order = 4,
					type = "description",
					name = function()
						local message = E.db.WT.announcement.thanks.enhancementText
						message = gsub(message, "%%player%%", E.myname)
						message = gsub(message, "%%target%%", L["Sylvanas"])
						message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(29166))
						return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n"
					end,
				},
			},
		},
		resurrection = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Resurrection"],
			disabled = function()
				return not E.db.WT.announcement.thanks.enable or not E.db.WT.announcement.thanks.resurrection
			end,
			args = {
				resurrection = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					disabled = function()
						return not E.db.WT.announcement.thanks.enable
					end,
					width = "full",
				},
				resurrectionText = {
					order = 2,
					type = "input",
					name = L["Text"],
					desc = format(
						"%s\n%s\n%s",
						FormatDesc("%player%", L["Your name"]),
						FormatDesc("%target%", L["Target name"]),
						FormatDesc("%spell%", L["The spell link"])
					),
					width = 2.5,
				},
				useDefaultText = {
					order = 3,
					type = "execute",
					func = function()
						E.db.WT.announcement.thanks.resurrectionText = P.announcement.thanks.resurrectionText
					end,
					name = L["Default Text"],
				},
				example = {
					order = 4,
					type = "description",
					name = function()
						local message = E.db.WT.announcement.thanks.resurrectionText
						message = gsub(message, "%%player%%", E.myname)
						message = gsub(message, "%%target%%", L["Sylvanas"])
						message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(61999))
						return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n"
					end,
				},
			},
		},
		channel = {
			order = 6,
			name = L["Channel"],
			type = "group",
			inline = true,
			get = function(info)
				return E.db.WT.announcement.thanks[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.thanks[info[#info - 1]][info[#info]] = value
			end,
			disabled = function()
				return not E.db.WT.announcement.thanks.enable
			end,
			args = {
				solo = {
					order = 1,
					name = L["Solo"],
					type = "select",
					values = {
						NONE = L["None"],
						WHISPER = L["Whisper"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				party = {
					order = 2,
					name = L["In Party"],
					type = "select",
					values = {
						NONE = L["None"],
						WHISPER = L["Whisper"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				instance = {
					order = 3,
					name = L["In Instance"],
					type = "select",
					values = {
						NONE = L["None"],
						WHISPER = L["Whisper"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						INSTANCE_CHAT = L["Instance"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				raid = {
					order = 4,
					name = L["In Raid"],
					type = "select",
					values = {
						NONE = L["None"],
						WHISPER = L["Whisper"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						RAID = L["Raid"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
			},
		},
	},
}

options.resetInstance = {
	order = 12,
	type = "group",
	name = L["Reset Instance"],
	get = function(info)
		return E.db.WT.announcement[info[#info - 1]][info[#info]]
	end,
	set = function(info, value)
		E.db.WT.announcement[info[#info - 1]][info[#info]] = value
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
					name = L["Send a message after instance resetting."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
		},
		prefix = {
			order = 3,
			type = "toggle",
			name = L["Prefix"],
		},
		channel = {
			order = 4,
			name = L["Channel"],
			type = "group",
			inline = true,
			get = function(info)
				return E.db.WT.announcement.resetInstance[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.resetInstance[info[#info - 1]][info[#info]] = value
			end,
			args = {
				party = {
					order = 1,
					name = L["In Party"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				instance = {
					order = 2,
					name = L["In Instance"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						INSTANCE_CHAT = L["Instance"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
				raid = {
					order = 3,
					name = L["In Raid"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						RAID = L["Raid"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
			},
		},
	},
}

options.keystone = {
	order = 13,
	type = "group",
	name = L["Keystone"],
	get = function(info)
		return E.db.WT.announcement[info[#info - 1]][info[#info]]
	end,
	set = function(info, value)
		E.db.WT.announcement[info[#info - 1]][info[#info]] = value
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
					name = L["Announce your mythic keystone."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
		},
		command = {
			order = 3,
			type = "toggle",
			name = L["!keys Command"],
			desc = L["Send the keystone to party or guild chat when someone use !keys command."],
		},
		betterAlign = {
			order = 4,
			type = "description",
			name = " ",
			width = "full",
		},
		text = {
			order = 5,
			type = "input",
			name = L["Text"],
			desc = FormatDesc("%keystone%", L["Keystone"]),
			width = 2,
		},
		useDefaultText = {
			order = 6,
			type = "execute",
			func = function(info)
				E.db.WT.announcement.keystone.text = P.announcement.keystone.text
			end,
			name = L["Default Text"],
		},
		channel = {
			order = 7,
			name = L["Channel"],
			type = "group",
			inline = true,
			get = function(info)
				return E.db.WT.announcement.keystone[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.announcement.keystone[info[#info - 1]][info[#info]] = value
			end,
			args = {
				party = {
					order = 1,
					name = L["In Party"],
					type = "select",
					values = {
						NONE = L["None"],
						SELF = L["Self (Chat Frame)"],
						EMOTE = L["Emote"],
						PARTY = L["Party"],
						YELL = L["Yell"],
						SAY = L["Say"],
					},
				},
			},
		},
	},
}

options.general = {
	order = 14,
	type = "group",
	name = L["General"],
	get = function(info)
		return E.db.WT.announcement[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.announcement[info[#info]] = value
	end,
	args = {
		emoteFormat = {
			order = 1,
			type = "input",
			name = L["Emote Format"],
			desc = L["The text template used in emote channel."]
				.. "\n"
				.. format(L["Default is %s."], W.Utilities.Color.StringByTemplate(": %s", "info")),
			width = 2,
		},
		betterAlign = {
			order = 2,
			type = "description",
			fontSize = "small",
			name = " ",
			width = "full",
		},
		sameMessageInterval = {
			order = 3,
			type = "range",
			name = L["Same Message Interval"],
			desc = L["Time interval between sending same messages measured in seconds."]
				.. " "
				.. L["Set to 0 to disable."],
			min = 0,
			max = 3600,
			step = 1,
			width = 1.5,
		},
	},
}
