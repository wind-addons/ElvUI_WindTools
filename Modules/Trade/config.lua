local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
--local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")

local _G = _G

P["WindTools"]["Trade"] = {
	["Enhanced Delete"] = {
		enabled = true,
		use_delete_key = true,
		click_button_delete = true,
		skip_confirm_delete = false,
	},
	["Already Known"] = {
		enabled = true,
		color = {
			r = 0,
			g = 1,
			b = 0,
			--a = 0.9,
		},
		--["monochrome"] = false,
	},
	["Azerite Tooltip"] = {
		enabled = true,
		removeblizzard = true,
		onlyspec = false,
		compact = false,
		bags = true,
		paperdoll = true, 
		icon_anchor = "BOTTOMLEFT",
	},
	["Corruption Rank"] = {
		enabled = true,
	},
}

WT.ToolConfigs["Trade"] = {
	["Enhanced Delete"] = {
		tDesc   = L["Provide a more convenient way to delete items."],
		oAuthor = "houshuu",
		cAuthor = "houshuu",
		["general"] = {
			name = L['General'],
			order = 6,
			get = function(info) return E.db.WindTools["Trade"]["Enhanced Delete"][info[#info]] end,
			set = function(info, value) E.db.WindTools["Trade"]["Enhanced Delete"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {
				use_delete_key = {
					order = 1,
					width = "full",
					name = L["Use Delete key"],
					desc = L["You may also press the |cffffd200Delete|r key as confirmation."],
				},
				click_button_delete = {
					order = 2,
					width = 1.5,
					set = function(info, value)
						E.db.WindTools["Trade"]["Enhanced Delete"][info[#info]] = value
						if value then
							E.db.WindTools["Trade"]["Enhanced Delete"].skip_confirm_delete = false
						end
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					name = L["Use delete button"],
					desc = L["Click the button to confirm the deletion of good items."],
				},
				skip_confirm_delete = {
					order = 3,
					width = 1.5,
					set = function(info, value)
						E.db.WindTools["Trade"]["Enhanced Delete"][info[#info]] = value
						if value then
							E.db.WindTools["Trade"]["Enhanced Delete"].click_button_delete = false
						end
						E:StaticPopup_Show("PRIVATE_RL")
					end,
					name = L["Skip confirm"],
					desc = L["Just delete a good item as a junk."],
				},
			}
		}
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
				removeblizzard = {
					order = 1,
					name = L["Replace Blizzard Azerite Text"],
				},
				onlyspec = {
					order = 2,
					name = L["Current Spec Only"],
					desc = L["Show traits for your current specialization only"],
				},
				compact = {
					order = 3,
					name = L["Compact Mode"],
					desc = L["Only icons"],
				},
				bags = {
					order = 4,
					name = L["Bag icon"],
					desc = L["Show selected traits in bags (works only with Blizzard Bags and Bagnon)"],
				},
				paperdoll = {
					order = 5,
					name = L["Character panel icon"],
					desc = L["Show selected traits in Character Frame"],
				},
				icon_anchor = {
					order = 6,
					name = L["Icon Anchor"],
					desc = L["Show selected traits in Character Frame"],
					type = "select",
					style = "dropdown",
					values = {
						["TOPLEFT"] = "TOP", -- 0
						["BOTTOMLEFT"] = "BOTTOM", -- 1
	
					},
				}
			}
		}
	},
	["Corruption Rank"] = {
		tDesc   = L["Show corruption rank in the tooltip when you mouseover an corruption item."],
		oAuthor = "NDui",
		cAuthor = "houshuu",
	},
}