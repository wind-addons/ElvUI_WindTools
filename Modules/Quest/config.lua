local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")

local _G = _G

P["WindTools"]["Quest"] = {
	["Objective Tracker"] = {
		enabled = true,
		header = {
			font = E.db.general.font,
			size = E.db.general.fontSize,
			style = "OUTLINE",
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
		["general"] = {
			order = 5,
			name = L['General'],
			args = {
				header = {
					order = 1,
					name = L["Header"],
					get = function(info) return E.db.WindTools.Quest["Objective Tracker"]["header"][info[#info]] end,
					set = function(info, value) E.db.WindTools.Quest["Objective Tracker"]["header"][info[#info]] = value end,
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
				info = {
					order = 2,
					name = L["Info text"],
					get = function(info) return E.db.WindTools.Quest["Objective Tracker"]["info"][info[#info]] end,
					set = function(info, value) E.db.WindTools.Quest["Objective Tracker"]["info"][info[#info]] = value end,
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