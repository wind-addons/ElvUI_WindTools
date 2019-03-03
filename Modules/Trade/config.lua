local E, L, V, P, G = unpack(ElvUI)
--local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")

local _G = _G

P["WindTools"]["Trade"] = {
	["Auto Delete"] = {
		["enabled"] = true,
	},
	["Already Known"] = {
		["enabled"] = true,
		["color"] = {
			r = 0,
			g = 1,
			b = 0,
			--a = 0.9,
		},
		--["monochrome"] = false,
	},
	["Azerite Tooltip"] = {
		["enabled"] = true,
		["RemoveBlizzard"]= true,
		["Compact"] = false,
		["OnlySpec"] = false,
		["Bags"] = false,
		["PaperDoll"] = true,
	},
}

WT.ToolConfigs["Trade"] = {
	["Auto Delete"] = {
		tDesc   = L["Enter DELETE automatically."],
		oAuthor = "bulleet",
		cAuthor = "houshuu",
	},
	["Already Known"] = {
		tDesc   = L["Change item color if learned before."],
		oAuthor = "ahak",
		cAuthor = "houshuu",
		["color"] = {
			order = 5,
			type = "color",
			name = L["Color"],
			hasAlpha = false,
			get = function(info)
				local t = E.db.WindTools["Trade"]["Already Known"]["color"]
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b, a)
				E.db.WindTools["Trade"]["Already Known"]["color"] = {}
				local t = E.db.WindTools["Trade"]["Already Known"]["color"]
				t.r, t.g, t.b, t.a = r, g, b
			end,
		},
	},
	["Azerite Tooltip"] = {
		tDesc   = L["Show azerite traits in the tooltip when you mouseover an azerite item."],
		oAuthor = "jokair9",
		cAuthor = "houshuu, Someblu",
		["general"] = {
			name = L['General'],
			order = 6,
			get = function(info) return E.db.WindTools["Trade"]["Azerite Tooltip"][info[#info]] end,
			set = function(info, value) E.db.WindTools["Trade"]["Azerite Tooltip"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {
				["RemoveBlizzard"] = {
					order = 1,
					name = L["Replace Blizzard Azerite Text"],
				},
				["OnlySpec"] = {
					order = 2,
					name = L["Current Spec Only"],
					desc = L["Show traits for your current specialization only"],
				},
				["Compact"] = {
					order = 3,
					name = L["Compact Mode"],
					desc = L["Only icons"],
				},
				["Bags"] = {
					order = 4,
					name = L["Bag icon"],
					desc = L["Show selected traits in bags (works only with Blizzard Bags and Bagnon)"],
				},
				["PaperDoll"] = {
					order = 5,
					name = L["Character panel icon"],
					desc = L["Show selected traits in Character Frame"],
				},
			}
		}
	},
}