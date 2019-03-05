local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")

local _G = _G

P["WindTools"]["Quest"] = {
	["Quest List Enhanced"] = {
		["enabled"] = true,
		["titlecolor"] = true,
		["titlelevel"] = true,
		["detaillevel"] = true,
		["titlefont"] = E.db.general.font,
		["titlefontsize"] = 14,
		["titlefontflag"] = "OUTLINE",
		["infofont"] = E.db.general.font,
		["infofontsize"] = 12,
		["infofontflag"] = "OUTLINE",
		["ignorehightlevel"] = true,
		["width"] = 240,
		["frametitle"] = true,
		["leftside"] = true,
		["leftsidesize"] = 18,
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
	["Quest List Enhanced"] = {
		tDesc   = L["Add the level information in front of the quest name."],
		oAuthor = "wandercga",
		cAuthor = "houshuu",
		["general"] = {
			order = 5,
			name = L['General'],
			get = function(info) return E.db.WindTools["Quest"]["Quest List Enhanced"][info[#info]] end,
			set = function(info, value) E.db.WindTools["Quest"]["Quest List Enhanced"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL")end,
			args = {
				["titlefont"] = {
					type = 'select', dialogControl = 'LSM30_Font',
					order = 1,
					name = L['Name Font'],
					values = LSM:HashTable('font'),
				},
				["titlefontsize"] = {
					order = 2,
					name = L['Name Font Size'],
					type = 'range',
					min = 6, max = 22, step = 1,
				},
				["titlefontflag"] = {
					name = L["Name Font Flag"],
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
				["infofont"] = {
					type = 'select', dialogControl = 'LSM30_Font',
					order = 4,
					name = L['Info Font'],
					values = LSM:HashTable('font'),
				},
				["infofontsize"] = {
					order = 5,
					name = L["Info Font Size"],
					type = 'range',
					min = 6, max = 22, step = 1,
				},
				["infofontflag"] = {
					name = L["Info Font Outline"],
					order = 6,
					type = 'select',
					values = {
						['NONE'] = L['None'],
						['OUTLINE'] = L['OUTLINE'],
						['MONOCHROME'] = L['MONOCHROME'],
						['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
						['THICKOUTLINE'] = L['THICKOUTLINE'],
					},
				},
				["titlecolor"] = {
					order = 7,
					name = L["Title Class Color"],
				},
			},
		},
		["level"] = {
			order = 6,
			name = L['Quest Level'],
			get = function(info) return E.db.WindTools["Quest"]["Quest List Enhanced"][info[#info]] end,
			set = function(info, value) E.db.WindTools["Quest"]["Quest List Enhanced"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL")end,
			args = {
				["titlelevel"] = {
					order = 1,
					name = L["Tracker Level"],
					desc = L["Display level info in quest title (Tracker)"],
				},
				["detaillevel"] = {
					order = 2,
					name = L["Quest details level"],
					desc = L["Display level info in quest title (Quest details)"],
				},
				["ignorehighlevel"] = {
					order = 3,
					name = L["Ignore high level"],
				},
			},
		},
		["leftsidemode"] = {
			order = 7,
			name = L["Left Side Minimize Button"],
			disabled = function(info) return E.db.WindTools["Quest"]["Quest List Enhanced"]["frametitle"] end,
			set = function(info, value) E.db.WindTools["Quest"]["Quest List Enhanced"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL")end,
			args = {
				["leftside"] = {
					order = 1,
					name  = L["Enable"],
					get = function(info) return E.db.WindTools["Quest"]["Quest List Enhanced"]["leftside"] end,
				},
				["leftsidesize"] = {
					order = 2,
					type  = 'range',
					name  = L["Size"],
					get = function(info) return E.db.WindTools["Quest"]["Quest List Enhanced"]["leftsidesize"] end,
					min   = 10,
					max   = 30,
					step  = 1,
				},
			}
		},
		["other"] = {
			order = 8,
			name = L['Other Setting'],
			get = function(info) return E.db.WindTools["Quest"]["Quest List Enhanced"][info[#info]] end,
			set = function(info, value) E.db.WindTools["Quest"]["Quest List Enhanced"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL")end,
			args = {
				["width"] = {
					order = 1,
					type = 'range',
					name = L["Tracker width"],
					min = 200, max = 300, step = 1,
				},
				["frametitle"] = {
					order = 2,
					name = L["Frame Title"],
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