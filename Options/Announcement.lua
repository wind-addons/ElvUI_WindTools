local W, F, E, L, V, P, G = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable, PrivateDB, ProfileDB, GlobalDB
local options = W.options.announcement.args
local A = W:GetModule("Announcement")
local SB = W:GetModule("SwitchButtons")
local QP = W:GetModule("QuestProgress")
local C = W.Utilities.Color

---@cast QP QuestProgress

local format = format
local strjoin = strjoin

local function FormatDesc(code, helpText)
	return C.StringByTemplate(code, "blue-400") .. " = " .. helpText
end

options.desc = {
	order = 1,
	type = "group",
	inline = true,
	name = L["Description"],
	args = {
		feature = {
			order = 1,
			type = "description",
			name = L["Announcement module is a tool to help you send messages."]
				.. " "
				.. L["You can customize the sentence templates, channels, etc."],
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

options.general = {
	order = 3,
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
				.. format(L["Default is %s."], W.Utilities.Color.StringByTemplate(": %s", "blue-500")),
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

options.quest = {
	order = 4,
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
		includeDetails = {
			order = 3,
			type = "toggle",
			name = L["Include Details"],
			desc = L["Announce every time the progress has been changed."],
		},
		hideLevelOnMaxLevel = {
			order = 4,
			type = "toggle",
			name = L["Hide Level on Max Level"],
			desc = L["Do not show quest level if the quest level is the same as the maximum level of your current expansion."],
			width = 2,
		},
		hideLevelIfSameAsPlayer = {
			order = 5,
			type = "toggle",
			name = L["Hide Level if Same as Player"],
			desc = L["Do not show quest level if the quest level is the same as your current level."],
			width = 2,
		},
		template = {
			order = 6,
			type = "input",
			name = L["Message Template"],
			desc = strjoin(
				"\n",
				L["The template for rendering announcement message."],
				format(L["The template of each element can be customized in %s module."], L["Quest Progress"]),
				"",
				F.GetWindStyleText(L["Template Elements"]),
				FormatDesc("{{level}}", L["Quest level"]),
				FormatDesc("{{daily}}", L["Daily quest label"]),
				FormatDesc("{{weekly}}", L["Weekly quest label"]),
				FormatDesc("{{link}}", L["Quest link"]),
				FormatDesc("{{tag}}", L["Quest tags (Quest series)"]),
				FormatDesc("{{progress}}", L["Quest progress (including objectives)"]),
				FormatDesc("{{title}}", L["Quest title"]),
				FormatDesc("{{suggestedGroup}}", L["Suggested group size"])
			),
			width = "full",
		},
		example = {
			order = 7,
			type = "description",
			name = function()
				local context = QP:GetTestContext()
				context.progress = L["Test Target"] .. ": 3/10"
				local message = QP:RenderTemplate(E.db.WT.announcement.quest.template, context)
				return "\n" .. C.StringByTemplate(L["Example"], "blue-400") .. ": " .. message .. "\n\n"
			end,
		},
		useDefault = {
			order = 8,
			type = "execute",
			name = L["Default"],
			desc = L["Reset the template to default value."],
			func = function(info)
				E.db.WT.announcement.quest.template = P.announcement.quest.template
			end,
		},
		tip = {
			order = 9,
			type = "group",
			inline = true,
			name = L["Tips"],
			args = {
				note = {
					order = 1,
					type = "description",
					name = format(
						"%s\n%s",
						format(
							L["Because the quest announcement is actually an extension of the %s module."],
							L["Quest Progress"]
						),
						format(
							L["You can custom the text for Quest Accepted, Quest Complete and Objective Progress in %s module's progress customization."],
							L["Quest Progress"]
						)
					),
				},
			},
		},
		channel = {
			order = 10,
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
	},
}

options.goodbye = {
	order = 5,
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

options.resetInstance = {
	order = 6,
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
		difficultyChange = {
			order = 3,
			type = "toggle",
			name = L["Difficulty Change"],
			desc = L["Also announce when you change the instance difficulty."],
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
	order = 7,
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
