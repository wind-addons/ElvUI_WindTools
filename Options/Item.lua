local W, F, E, L, V, P, G = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table, PrivateDB, ProfileDB, GlobalDB
local C = W.Utilities.Color
local options = W.options.item.args
local async = W.Utilities.Async
local LSM = E.Libs.LSM

local DI = W:GetModule("DeleteItem")
local AK = W:GetModule("AlreadyKnown")
local FL = W:GetModule("FastLoot")
local TD = W:GetModule("Trade")
local EB = W:GetModule("ExtraItemsBar")
local CT = W:GetModule("Contacts")
local IS = W:GetModule("Inspect")
local IL = W:GetModule("ItemLevel")
local EMP = W:GetModule("ExtendMerchantPages")

local format = format
local ipairs = ipairs
local pairs = pairs
local print = print
local strrep = strrep
local tconcat = table.concat
local tinsert = tinsert
local tonumber = tonumber
local tremove = tremove
local unpack = unpack

local customListSelected1, customListSelected2

local function desc(code, helpText)
	return C.StringByTemplate(code, "teal-400") .. " = " .. helpText
end

local slotNames = {
	[1] = HEADSLOT,
	[2] = NECKSLOT,
	[3] = SHOULDERSLOT,
	[4] = SHIRTSLOT,
	[5] = CHESTSLOT,
	[6] = WAISTSLOT,
	[7] = LEGSSLOT,
	[8] = FEETSLOT,
	[9] = WRISTSLOT,
	[10] = HANDSSLOT,
	[11] = FINGER0SLOT_UNIQUE,
	[12] = FINGER1SLOT_UNIQUE,
	[13] = TRINKET0SLOT_UNIQUE,
	[14] = TRINKET1SLOT_UNIQUE,
	[15] = BACKSLOT,
	[16] = MAINHANDSLOT,
	[17] = SECONDARYHANDSLOT,
	[18] = RANGEDSLOT,
	[19] = TABARDSLOT,
}

-- Generate slot ID descriptions
local function generateSlotDesc()
	local slots = {}
	for id, name in ipairs(slotNames) do
		tinsert(slots, format("|cff71d5ff%d|r=%s", id, name))
	end

	return tconcat(slots, " ")
end

local extraItemGroupTooltip = (function()
	local lines = {
		L["Set the type and order of button groups."],
		L["You can separate the groups with a comma."],
		desc("QUEST", L["Quest Items"]),
		desc("EQUIP", L["Equipments"]),
		desc("CUSTOM", L["Custom Items"]),
		desc("SLOT:1-19", L["Equipment Slots (Range)"]),
		desc("SLOT:|cffadd8e6" .. L["number"] .. "|r", L["Equipment Slots (Single)"]),
		format("|cffadd8e6%s|r", L["Slot ID List"] .. ":"),
		generateSlotDesc(),
		desc("POTION", format("%s (%s)", L["Potions"], L["All"])),
		desc("POTIONSL", format("%s |cff999999%s|r", L["Potions"], L["[ABBR] Shadowlands"])),
		desc("POTIONDF", format("%s |cff999999%s|r", L["Potions"], L["[ABBR] Dragonflight"])),
		desc("POTIONTWW", format("%s |cffffdd57%s|r", L["Potions"], L["[ABBR] The War Within"])),
		desc("FLASK", format("%s (%s)", L["Flasks"], L["All"])),
		desc("FLASKSL", format("%s |cff999999%s|r", L["Flasks"], L["[ABBR] Shadowlands"])),
		desc("FLASKDF", format("%s |cff999999%s|r", L["Flasks"], L["[ABBR] Dragonflight"])),
		desc("FLASKTWW", format("%s |cffffdd57%s|r", L["Flasks"], L["[ABBR] The War Within"])),
		desc("RUNE", format("%s (%s)", L["Runes"], L["All"])),
		desc("RUNEDF", format("%s |cff999999%s|r", L["Runes"], L["[ABBR] Dragonflight"])),
		desc("RUNETWW", format("%s |cffffdd57%s|r", L["Runes"], L["[ABBR] The War Within"])),
		desc("VANTUS", format("%s (%s)", L["Vantus Runes"], L["All"])),
		desc("VANTUSTWW", format("%s |cffffdd57%s|r", L["Vantus Runes"], L["[ABBR] The War Within"])),
		desc("FOOD", format("%s (%s)", L["Crafted Food"], L["All"])),
		desc("FOODSL", format("%s |cff999999%s|r", L["Crafted Food"], L["[ABBR] Shadowlands"])),
		desc("FOODDF", format("%s |cff999999%s|r", L["Crafted Food"], L["[ABBR] Dragonflight"])),
		desc("FOODTWW", format("%s |cffffdd57%s|r", L["Crafted Food"], L["[ABBR] The War Within"])),
		desc(
			"FOODVENDOR",
			format("%s (%s) |cffffdd57%s|r", L["Food"], L["Sold by vendor"], L["[ABBR] The War Within"])
		),
		desc("MAGEFOOD", format("%s (%s)|r", L["Food"], L["Crafted by mage"])),
		desc("FISHING", format("%s (%s)", L["Fishing"], L["All"])),
		desc("FISHINGTWW", format("%s |cffffdd57%s|r", L["Fishing"], L["[ABBR] The War Within"])),
		desc("BANNER", L["Banners"]),
		desc("UTILITY", L["Utilities"]),
		desc("OPENABLE", L["Openable Items"]),
		desc("PROF", format("%s |cffffdd57%s|r", L["Profession Items"], L["[ABBR] The War Within"])),
		desc("SEEDS", L["Seeds"]),
		desc("BIGDIG", L["Big Dig"]),
		desc("DELVE", L["Delves"]),
		desc("HOLIDAY", L["Holiday Reward Boxes"]),
	}

	return format("%s %s\n" .. strrep("\n%s", #lines - 2), unpack(lines))
end)()

options.extraItemsBar = {
	order = 1,
	type = "group",
	name = L["Extra Items Bar"],
	get = function(info)
		return E.db.WT.item.extraItemsBar[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.item.extraItemsBar[info[#info]] = value
		EB:ProfileUpdate()
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
					name = L["Add a bar to contain quest items and usable equipment."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
		},
		custom = {
			order = 10,
			type = "group",
			name = L["Custom Items"],
			disabled = function()
				return not E.db.WT.item.extraItemsBar.enable
			end,
			args = {
				addToList = {
					order = 1,
					type = "input",
					name = L["New Item ID"],
					get = function()
						return ""
					end,
					set = function(_, value)
						local itemID = tonumber(value)
						if async.WithItemID(itemID) then
							tinsert(E.db.WT.item.extraItemsBar.customList, itemID)
							EB:UpdateBars()
						else
							F.Print(L["The item ID is invalid."])
						end
					end,
				},
				list = {
					order = 2,
					type = "select",
					name = L["List"],
					get = function()
						return customListSelected1
					end,
					set = function(_, value)
						customListSelected1 = value
					end,
					values = function()
						local list = E.db.WT.item.extraItemsBar.customList
						local result = {}
						for key, value in pairs(list) do
							async.WithItemID(value, function(item)
								local name = item:GetItemName() or L["Unknown"]
								local tex = item:GetItemIcon()
								result[key] = F.GetIconString(tex, 14, 18, true) .. " " .. name
							end)
						end
						return result
					end,
				},
				deleteButton = {
					order = 3,
					type = "execute",
					name = L["Delete"],
					desc = L["Delete the selected item."],
					func = function()
						if customListSelected1 then
							local list = E.db.WT.item.extraItemsBar.customList
							tremove(list, customListSelected1)
							EB:UpdateBars()
						end
					end,
				},
			},
		},
		blackList = {
			order = 11,
			type = "group",
			name = L["Blacklist"],
			disabled = function()
				return not E.db.WT.item.extraItemsBar.enable
			end,
			args = {
				addToList = {
					order = 1,
					type = "input",
					name = L["New Item ID"],
					get = function()
						return ""
					end,
					set = function(_, value)
						local itemID = tonumber(value)
						if async.WithItemID(itemID) then
							E.db.WT.item.extraItemsBar.blackList[itemID] = true
							EB:UpdateBars()
						else
							F.Print(L["The item ID is invalid."])
						end
					end,
				},
				list = {
					order = 2,
					type = "select",
					name = L["List"],
					get = function()
						return customListSelected2
					end,
					set = function(_, value)
						customListSelected2 = value
					end,
					values = function()
						local result = {}
						for key in pairs(E.db.WT.item.extraItemsBar.blackList) do
							async.WithItemID(key, function(item)
								local name = item:GetItemName() or L["Unknown"]
								local tex = item:GetItemIcon()
								result[key] = F.GetIconString(tex, 14, 18, true) .. " " .. name
							end)
						end
						return result
					end,
				},
				deleteButton = {
					order = 3,
					type = "execute",
					name = L["Delete"],
					desc = L["Delete the selected item."],
					func = function()
						if customListSelected2 then
							E.db.WT.item.extraItemsBar.blackList[customListSelected2] = nil
							EB:UpdateBars()
						end
					end,
				},
			},
		},
	},
}

do -- Add options for bars
	for i = 1, 5 do
		options.extraItemsBar.args["bar" .. i] = {
			order = i + 2,
			type = "group",
			name = L["Bar"] .. " " .. i,
			get = function(info)
				return E.db.WT.item.extraItemsBar["bar" .. i][info[#info]]
			end,
			set = function(info, value)
				E.db.WT.item.extraItemsBar["bar" .. i][info[#info]] = value
				EB:UpdateBar(i)
			end,
			disabled = function()
				return not E.db.WT.item.extraItemsBar.enable
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				groupSetting = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Button Groups"],
					args = {
						include = {
							order = 16,
							type = "input",
							name = L["Button Groups"],
							desc = extraItemGroupTooltip,
							width = "full",
						},
						reset = {
							order = 16,
							type = "execute",
							name = L["Reset"],
							desc = L["Reset the button groups of this bar."],
							func = function()
								E.db.WT.item.extraItemsBar["bar" .. i].include =
									P.item.extraItemsBar["bar" .. i].include
								EB:UpdateBar(i)
							end,
						},
					},
				},
				visibility = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Visibility"],
					args = {
						globalFade = {
							order = 1,
							type = "toggle",
							name = L["Inherit Global Fade"],
						},
						mouseOver = {
							order = 2,
							type = "toggle",
							name = L["Mouse Over"],
							desc = L["Only show the bar when you mouse over it."],
							disabled = function()
								return not E.db.WT.item.extraItemsBar.enable
									or E.db.WT.item.extraItemsBar["bar" .. i].globalFade
							end,
						},
						fadeTime = {
							order = 3,
							type = "range",
							name = L["Fade Time"],
							min = 0,
							max = 2,
							step = 0.01,
							disabled = function()
								return not E.db.WT.item.extraItemsBar.enable
									or E.db.WT.item.extraItemsBar["bar" .. i].globalFade
									or not E.db.WT.item.extraItemsBar["bar" .. i].mouseOver
							end,
						},
						alphaMin = {
							order = 4,
							type = "range",
							name = L["Alpha Min"],
							min = 0,
							max = 1,
							step = 0.01,
							disabled = function()
								return not E.db.WT.item.extraItemsBar.enable
									or E.db.WT.item.extraItemsBar["bar" .. i].globalFade
									or not E.db.WT.item.extraItemsBar["bar" .. i].mouseOver
							end,
						},
						alphaMax = {
							order = 5,
							type = "range",
							name = L["Alpha Max"],
							min = 0,
							max = 1,
							step = 0.01,
							disabled = function()
								return not E.db.WT.item.extraItemsBar.enable
									or E.db.WT.item.extraItemsBar["bar" .. i].globalFade
							end,
						},
						tooltip = {
							order = 6,
							type = "toggle",
							name = L["Tooltip"],
						},
						visibility = {
							order = 7,
							type = "input",
							name = L["Visibility"],
							desc = L["The macro condition for the bar to be shown."],
							width = "full",
						},
					},
				},
				backdrop = {
					order = 4,
					type = "toggle",
					name = L["Bar Backdrop"],
					desc = L["Show a backdrop of the bar."],
				},
				anchor = {
					order = 5,
					type = "select",
					name = L["Anchor Point"],
					desc = L["The first button anchors itself to this point on the bar."],
					values = {
						TOPLEFT = L["TOPLEFT"],
						TOPRIGHT = L["TOPRIGHT"],
						BOTTOMLEFT = L["BOTTOMLEFT"],
						BOTTOMRIGHT = L["BOTTOMRIGHT"],
					},
				},
				backdropSpacing = {
					order = 6,
					type = "range",
					name = L["Backdrop Spacing"],
					desc = L["The spacing between the backdrop and the buttons."],
					min = 1,
					max = 30,
					step = 1,
				},
				spacing = {
					order = 7,
					type = "range",
					name = L["Button Spacing"],
					desc = L["The spacing between buttons."],
					min = 1,
					max = 30,
					step = 1,
				},
				betterOption2 = {
					order = 8,
					type = "description",
					name = " ",
					width = "full",
				},
				numButtons = {
					order = 9,
					type = "range",
					name = L["Buttons"],
					min = 1,
					max = 12,
					step = 1,
				},
				buttonWidth = {
					order = 10,
					type = "range",
					name = L["Button Width"],
					desc = L["The width of the buttons."],
					min = 2,
					max = 80,
					step = 1,
				},
				buttonHeight = {
					order = 11,
					type = "range",
					name = L["Button Height"],
					desc = L["The height of the buttons."],
					min = 2,
					max = 60,
					step = 1,
				},
				buttonsPerRow = {
					order = 12,
					type = "range",
					name = L["Buttons Per Row"],
					min = 1,
					max = 12,
					step = 1,
				},
				qualityTier = {
					order = 13,
					type = "group",
					inline = true,
					name = L["Crafting Quality Tier"],
					get = function(info)
						return E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]] = value
						EB:UpdateBar(i)
					end,
					args = {
						size = {
							order = 3,
							name = L["Size"],
							type = "range",
							min = 5,
							max = 60,
							step = 1,
						},
						xOffset = {
							order = 4,
							name = L["X-Offset"],
							type = "range",
							min = -100,
							max = 100,
							step = 1,
						},
						yOffset = {
							order = 5,
							name = L["Y-Offset"],
							type = "range",
							min = -100,
							max = 100,
							step = 1,
						},
					},
				},
				countFont = {
					order = 14,
					type = "group",
					inline = true,
					name = L["Counter"],
					get = function(info)
						return E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]] = value
						EB:UpdateBar(i)
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
						},
						style = {
							order = 2,
							type = "select",
							name = L["Outline"],
							values = {
								NONE = L["None"],
								OUTLINE = L["Outline"],
								THICKOUTLINE = L["Thick"],
								SHADOW = L["|cff888888Shadow|r"],
								SHADOWOUTLINE = L["|cff888888Shadow|r Outline"],
								SHADOWTHICKOUTLINE = L["|cff888888Shadow|r Thick"],
								MONOCHROME = L["|cFFAAAAAAMono|r"],
								MONOCHROMEOUTLINE = L["|cFFAAAAAAMono|r Outline"],
								MONOCHROMETHICKOUTLINE = L["|cFFAAAAAAMono|r Thick"],
							},
						},
						size = {
							order = 3,
							name = L["Size"],
							type = "range",
							min = 5,
							max = 60,
							step = 1,
						},
						xOffset = {
							order = 4,
							name = L["X-Offset"],
							type = "range",
							min = -100,
							max = 100,
							step = 1,
						},
						yOffset = {
							order = 5,
							name = L["Y-Offset"],
							type = "range",
							min = -100,
							max = 100,
							step = 1,
						},
						color = {
							order = 6,
							type = "color",
							name = L["Color"],
							hasAlpha = false,
							get = function(info)
								local db = E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
								local default = P.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
								EB:UpdateBar(i)
							end,
						},
					},
				},
				bindFont = {
					order = 15,
					type = "group",
					inline = true,
					name = L["Key Binding"],
					get = function(info)
						return E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]] = value
						EB:UpdateBar(i)
					end,
					args = {
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
						},
						style = {
							order = 2,
							type = "select",
							name = L["Outline"],
							values = {
								NONE = L["None"],
								OUTLINE = L["OUTLINE"],
								THICKOUTLINE = L["THICKOUTLINE"],
								SHADOW = L["SHADOW"],
								SHADOWOUTLINE = L["SHADOWOUTLINE"],
								SHADOWTHICKOUTLINE = L["SHADOWTHICKOUTLINE"],
								MONOCHROME = L["MONOCHROME"],
								MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"],
								MONOCHROMETHICKOUTLINE = L["MONOCHROMETHICKOUTLINE"],
							},
						},
						size = {
							order = 3,
							name = L["Size"],
							type = "range",
							min = 5,
							max = 60,
							step = 1,
						},
						xOffset = {
							order = 4,
							name = L["X-Offset"],
							type = "range",
							min = -100,
							max = 100,
							step = 1,
						},
						yOffset = {
							order = 5,
							name = L["Y-Offset"],
							type = "range",
							min = -100,
							max = 100,
							step = 1,
						},
						color = {
							order = 6,
							type = "color",
							name = L["Color"],
							hasAlpha = false,
							get = function(info)
								local db = E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
								local default = P.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.item.extraItemsBar["bar" .. i][info[#info - 1]][info[#info]]
								db.r, db.g, db.b = r, g, b
								EB:UpdateBar(i)
							end,
						},
					},
				},
			},
		}
	end
end

options.delete = {
	order = 2,
	type = "group",
	name = L["Delete Item"],
	get = function(info)
		return E.db.WT.item.delete[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.item.delete[info[#info]] = value
		DI:ProfileUpdate()
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
					name = L["This module provides several easy-to-use methods of deleting items."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			width = "full",
		},
		delKey = {
			order = 3,
			type = "toggle",
			name = L["Use Delete Key"],
			desc = L["Allow you to use Delete Key for confirming deleting."],
		},
		fillIn = {
			order = 4,
			name = L["Fill In"],
			type = "select",
			values = {
				NONE = L["Disable"],
				CLICK = L["Fill by click"],
				AUTO = L["Auto Fill"],
			},
		},
	},
}

options.alreadyKnown = {
	order = 3,
	type = "group",
	name = L["Already Known"],
	get = function(info)
		return E.db.WT.item.alreadyKnown[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.item.alreadyKnown[info[#info]] = value
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
					name = function()
						if AK.StopRunning then
							return format(
								"|cffff3860" .. L["Because of %s, this module will not be loaded."] .. "|r",
								AK.StopRunning
							)
						else
							return L["Puts a overlay on already known learnable items on vendors and AH."]
						end
					end,
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			disabled = function()
				return AK.StopRunning
			end,
			set = function(info, value)
				E.db.WT.item.alreadyKnown[info[#info]] = value
				AK:ToggleSetting()
			end,
			width = "full",
		},
		mode = {
			order = 3,
			name = L["Mode"],
			type = "select",
			disabled = function()
				return AK.StopRunning
			end,
			values = {
				COLOR = L["Custom Color"],
				MONOCHROME = L["Monochrome"],
			},
		},
		color = {
			order = 4,
			type = "color",
			name = L["Color"],
			disabled = function()
				return AK.StopRunning
			end,
			hidden = function()
				return not (E.db.WT.item.alreadyKnown.mode == "COLOR")
			end,
			hasAlpha = false,
			get = function(info)
				local db = E.db.WT.item.alreadyKnown.color
				local default = P.item.alreadyKnown.color
				return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
			end,
			set = function(info, r, g, b)
				local db = E.db.WT.item.alreadyKnown.color
				db.r, db.g, db.b = r, g, b
			end,
		},
	},
}

options.fastLoot = {
	order = 4,
	type = "group",
	name = L["Fast Loot"],
	get = function(info)
		return E.db.WT.item.fastLoot[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.item.fastLoot[info[#info]] = value
		FL:ProfileUpdate()
	end,
	args = {
		desc = {
			order = 0,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				feature = {
					order = 1,
					type = "description",
					name = L["This module will accelerate the speed of loot."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			width = "full",
		},
		limit = {
			order = 2,
			type = "range",
			name = L["Limit"],
			desc = L["The time delay between every loot operations. (Default is 0.3)"],
			min = 0.05,
			max = 0.5,
			step = 0.01,
		},
	},
}

options.trade = {
	order = 5,
	type = "group",
	name = L["Trade"],
	get = function(info)
		return E.db.WT.item.trade[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.item.trade[info[#info]] = value
		TD:ProfileUpdate()
	end,
	args = {
		desc = {
			order = 0,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				feature = {
					order = 1,
					type = "description",
					name = L["Add some features on Trade Frame."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			width = "full",
		},
		thanksButton = {
			order = 2,
			type = "toggle",
			name = L["Thanks Button"],
		},
		thanksText = {
			order = 3,
			type = "input",
			name = L["Thanks Text"],
			width = "full",
		},
	},
}

options.contacts = {
	order = 6,
	type = "group",
	name = L["Contacts"],
	get = function(info)
		return E.db.WT.item.contacts[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.item.contacts[info[#info]] = value
		CT:ProfileUpdate()
	end,
	args = {
		desc = {
			order = 0,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				feature = {
					order = 1,
					type = "description",
					name = L["Add a contact frame beside the mail frame."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
		},
		updateAlts = {
			order = 2,
			type = "toggle",
			name = L["Update Alts"],
			desc = L["Update the alt list when you log in."],
			get = function()
				return E.global.WT.item.contacts.updateAlts
			end,
			set = function(_, value)
				E.global.WT.item.contacts.updateAlts = value
			end,
		},
		defaultPage = {
			order = 3,
			type = "select",
			name = L["Default Page"],
			values = {
				ALTS = L["Alternate Character"],
				FRIENDS = L["Online Friends"],
				GUILD = L["Guild Members"],
				FAVORITE = L["My Favorites"],
			},
		},
	},
}

do
	local selectedKey

	options.contacts.args.alts = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Alternate Character"],
		args = {
			listTable = {
				order = 1,
				type = "select",
				name = L["Alt List"],
				width = 1.5,
				get = function()
					return selectedKey
				end,
				set = function(_, value)
					selectedKey = value
				end,
				values = function()
					local result = {}
					for realm, factions in pairs(E.global.WT.item.contacts.alts) do
						for _, characters in pairs(factions) do
							for name, class in pairs(characters) do
								result[name .. "-" .. realm] = F.CreateClassColorString(name .. "-" .. realm, class)
							end
						end
					end
					return result
				end,
			},
			deleteButton = {
				order = 2,
				type = "execute",
				name = L["Delete"],
				desc = L["Delete the selected item."],
				func = function()
					if selectedKey then
						for realm, factions in pairs(E.global.WT.item.contacts.alts) do
							for faction, characters in pairs(factions) do
								for name, class in pairs(characters) do
									if name .. "-" .. realm == selectedKey then
										E.global.WT.item.contacts.alts[realm][faction][name] = nil
										selectedKey = nil
										return
									end
								end
							end
						end
					end
				end,
			},
			clearAlts = {
				order = 3,
				type = "execute",
				name = L["Clear All"],
				desc = L["Clear the alt list."],
				confirm = true,
				confirmText = L["Are you sure to clear the alt list?"],
				func = function()
					E.global.WT.item.contacts.alts = {}
				end,
			},
		},
	}
end

do
	local selectedKey
	local tempName, tempRealm

	options.contacts.args.favorite = {
		order = 5,
		type = "group",
		inline = true,
		name = L["My Favorites"],
		args = {
			name = {
				order = 1,
				type = "input",
				name = L["Name"],
				get = function()
					return tempName
				end,
				set = function(_, value)
					tempName = value
				end,
			},
			realm = {
				order = 2,
				type = "input",
				name = L["Realm"],
				get = function()
					return tempRealm
				end,
				set = function(_, value)
					tempRealm = value
				end,
			},
			addButton = {
				order = 3,
				type = "execute",
				name = L["Add"],
				func = function()
					if tempName and tempRealm then
						E.global.WT.item.contacts.favorites[tempName .. "-" .. tempRealm] = true
						tempName = nil
						tempRealm = nil
					else
						print(L["Please set the name and realm first."])
					end
				end,
			},
			betterOption = {
				order = 4,
				type = "description",
				name = " ",
				width = "full",
			},
			listTable = {
				order = 5,
				type = "select",
				name = L["Favorite List"],
				get = function()
					return selectedKey
				end,
				set = function(_, value)
					selectedKey = value
				end,
				values = function()
					local result = {}
					for fullName in pairs(E.global.WT.item.contacts.favorites) do
						result[fullName] = fullName
					end
					return result
				end,
			},
			deleteButton = {
				order = 6,
				type = "execute",
				name = L["Delete"],
				func = function()
					if selectedKey then
						E.global.WT.item.contacts.favorites[selectedKey] = nil
					end
				end,
			},
		},
	}
end

options.inspect = {
	order = 7,
	type = "group",
	name = L["Inspect"],
	get = function(info)
		return E.db.WT.item.inspect[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.item.inspect[info[#info]] = value
		IS:ProfileUpdate()
	end,
	args = {
		desc = {
			order = 0,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				feature = {
					order = 1,
					type = "description",
					name = function()
						if IS.StopRunning then
							return format(
								"|cffff3860" .. L["Because of %s, this module will not be loaded."] .. "|r",
								IS.StopRunning
							)
						else
							return format(
								"%s\n%s",
								L["This module will add an equipment list beside the character panel and inspect frame."],
								L["This module is a lite version of TinyInspect. Installing TinyInspect if you want to have full features."]
							)
						end
					end,
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 1,
			disabled = function()
				return IS.StopRunning
			end,
			type = "toggle",
			name = L["Enable"],
			width = "full",
		},
		lists = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Lists"],
			disabled = function()
				return IS.StopRunning or not E.db.WT.item.inspect.enable
			end,
			args = {
				player = {
					order = 1,
					type = "toggle",
					name = L["Player"],
					desc = L["Add a frame to your character panel."],
				},
				inspect = {
					order = 2,
					type = "toggle",
					name = L["Inspect"],
					desc = L["Add a frame to Inspect Frame."],
				},
			},
		},
		additional = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Additional Information"],
			hidden = function()
				return not E.db.WT.item.inspect.inspect
			end,
			disabled = function()
				return IS.StopRunning or not E.db.WT.item.inspect.enable
			end,
			args = {
				playerOnInspect = {
					order = 1,
					type = "toggle",
					name = L["Always Show Mine"],
					desc = L["Display character equipments list when you inspect someone."],
				},
				stats = {
					order = 3,
					type = "toggle",
					name = L["Statistics"],
					hidden = function()
						if W.Locale == "koKR" or W.Locale == "enUS" or W.Locale == "zhCN" or W.Locale == "zhTW" then
							return false
						end
						return true
					end,
					desc = L["Add statistics information for comparison."],
				},
			},
		},
		slotText = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Slot"],
			get = function(info)
				return E.db.WT.item.inspect.slotText[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.item.inspect.slotText[info[#info]] = value
			end,
			args = {
				name = {
					order = 1,
					type = "select",
					dialogControl = "LSM30_Font",
					name = L["Font"],
					values = LSM:HashTable("font"),
				},
				style = {
					order = 2,
					type = "select",
					name = L["Outline"],
					values = {
						NONE = L["None"],
						OUTLINE = L["Outline"],
						THICKOUTLINE = L["Thick"],
						SHADOW = L["|cff888888Shadow|r"],
						SHADOWOUTLINE = L["|cff888888Shadow|r Outline"],
						SHADOWTHICKOUTLINE = L["|cff888888Shadow|r Thick"],
						MONOCHROME = L["|cFFAAAAAAMono|r"],
						MONOCHROMEOUTLINE = L["|cFFAAAAAAMono|r Outline"],
						MONOCHROMETHICKOUTLINE = L["|cFFAAAAAAMono|r Thick"],
					},
				},
				size = {
					order = 3,
					name = L["Size"],
					type = "range",
					min = 5,
					max = 60,
					step = 1,
				},
			},
		},
		levelText = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Item Level"],
			get = function(info)
				return E.db.WT.item.inspect.levelText[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.item.inspect.levelText[info[#info]] = value
			end,
			args = {
				name = {
					order = 1,
					type = "select",
					dialogControl = "LSM30_Font",
					name = L["Font"],
					values = LSM:HashTable("font"),
				},
				style = {
					order = 2,
					type = "select",
					name = L["Outline"],
					values = {
						NONE = L["None"],
						OUTLINE = L["Outline"],
						THICKOUTLINE = L["Thick"],
						SHADOW = L["|cff888888Shadow|r"],
						SHADOWOUTLINE = L["|cff888888Shadow|r Outline"],
						SHADOWTHICKOUTLINE = L["|cff888888Shadow|r Thick"],
						MONOCHROME = L["|cFFAAAAAAMono|r"],
						MONOCHROMEOUTLINE = L["|cFFAAAAAAMono|r Outline"],
						MONOCHROMETHICKOUTLINE = L["|cFFAAAAAAMono|r Thick"],
					},
				},
				size = {
					order = 3,
					name = L["Size"],
					type = "range",
					min = 5,
					max = 60,
					step = 1,
				},
			},
		},
		equipText = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Item Name"],
			get = function(info)
				return E.db.WT.item.inspect.equipText[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.item.inspect.equipText[info[#info]] = value
			end,
			args = {
				name = {
					order = 1,
					type = "select",
					dialogControl = "LSM30_Font",
					name = L["Font"],
					values = LSM:HashTable("font"),
				},
				style = {
					order = 2,
					type = "select",
					name = L["Outline"],
					values = {
						NONE = L["None"],
						OUTLINE = L["Outline"],
						THICKOUTLINE = L["Thick"],
						SHADOW = L["|cff888888Shadow|r"],
						SHADOWOUTLINE = L["|cff888888Shadow|r Outline"],
						SHADOWTHICKOUTLINE = L["|cff888888Shadow|r Thick"],
						MONOCHROME = L["|cFFAAAAAAMono|r"],
						MONOCHROMEOUTLINE = L["|cFFAAAAAAMono|r Outline"],
						MONOCHROMETHICKOUTLINE = L["|cFFAAAAAAMono|r Thick"],
					},
				},
				size = {
					order = 3,
					name = L["Size"],
					type = "range",
					min = 5,
					max = 60,
					step = 1,
				},
			},
		},
		statsText = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Statistics"],
			get = function(info)
				return E.db.WT.item.inspect.statsText[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.item.inspect.statsText[info[#info]] = value
			end,
			args = {
				name = {
					order = 1,
					type = "select",
					dialogControl = "LSM30_Font",
					name = L["Font"],
					values = LSM:HashTable("font"),
				},
				style = {
					order = 2,
					type = "select",
					name = L["Outline"],
					values = {
						NONE = L["None"],
						OUTLINE = L["Outline"],
						THICKOUTLINE = L["Thick"],
						SHADOW = L["|cff888888Shadow|r"],
						SHADOWOUTLINE = L["|cff888888Shadow|r Outline"],
						SHADOWTHICKOUTLINE = L["|cff888888Shadow|r Thick"],
						MONOCHROME = L["|cFFAAAAAAMono|r"],
						MONOCHROMEOUTLINE = L["|cFFAAAAAAMono|r Outline"],
						MONOCHROMETHICKOUTLINE = L["|cFFAAAAAAMono|r Thick"],
					},
				},
				size = {
					order = 3,
					name = L["Size"],
					type = "range",
					min = 5,
					max = 60,
					step = 1,
				},
			},
		},
	},
}

options.itemLevel = {
	order = 8,
	type = "group",
	name = L["Item Level"],
	get = function(info)
		return E.db.WT.item.itemLevel[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.item.itemLevel[info[#info]] = value
		IL:ProfileUpdate()
	end,
	args = {
		desc = {
			order = 0,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				feature = {
					order = 1,
					type = "description",
					name = L["Add an extra item level text to some equipment buttons."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			width = "full",
		},
		flyout = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Flyout Button"],
			disabled = function()
				return not E.db.WT.item.itemLevel.enable
			end,
			get = function(info)
				return E.db.WT.item.itemLevel.flyout[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.item.itemLevel.flyout[info[#info]] = value
			end,
			args = {
				enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
					width = "full",
				},
				font = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Font"],
					get = function(info)
						return E.db.WT.item.itemLevel.flyout.font[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.item.itemLevel.flyout.font[info[#info]] = value
					end,
					disabled = function()
						return E.db.WT.item.itemLevel.flyout.useBagsFontSetting or not E.db.WT.item.itemLevel.enable
					end,
					args = {
						useBagsFontSetting = {
							order = 0,
							get = function(info)
								return E.db.WT.item.itemLevel.flyout[info[#info]]
							end,
							set = function(info, value)
								E.db.WT.item.itemLevel.flyout[info[#info]] = value
							end,
							disabled = function()
								return not E.db.WT.item.itemLevel.enable
							end,
							type = "toggle",
							name = L["Use Bags Setting"],
							desc = L["Render the item level text with the setting in ElvUI bags."],
						},
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
						},
						style = {
							order = 2,
							type = "select",
							name = L["Outline"],
							values = {
								NONE = L["None"],
								OUTLINE = L["OUTLINE"],
								THICKOUTLINE = L["THICKOUTLINE"],
								SHADOW = L["SHADOW"],
								SHADOWOUTLINE = L["SHADOWOUTLINE"],
								SHADOWTHICKOUTLINE = L["SHADOWTHICKOUTLINE"],
								MONOCHROME = L["MONOCHROME"],
								MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"],
								MONOCHROMETHICKOUTLINE = L["MONOCHROMETHICKOUTLINE"],
							},
						},
						size = {
							order = 3,
							name = L["Size"],
							type = "range",
							min = 5,
							max = 60,
							step = 1,
						},
						xOffset = {
							order = 4,
							name = L["X-Offset"],
							type = "range",
							min = -100,
							max = 100,
							step = 1,
						},
						yOffset = {
							order = 5,
							name = L["Y-Offset"],
							type = "range",
							min = -100,
							max = 100,
							step = 1,
						},
					},
				},
				color = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Color"],
					disabled = function()
						return E.db.WT.item.itemLevel.flyout.qualityColor or not E.db.WT.item.itemLevel.enable
					end,
					args = {
						qualityColor = {
							order = 0,
							get = function(info)
								return E.db.WT.item.itemLevel.flyout[info[#info]]
							end,
							set = function(info, value)
								E.db.WT.item.itemLevel.flyout[info[#info]] = value
							end,
							disabled = function()
								return not E.db.WT.item.itemLevel.enable
							end,
							type = "toggle",
							name = L["Quality Color"],
						},
						color = {
							order = 6,
							type = "color",
							name = L["Color"],
							hasAlpha = false,
							get = function(info)
								local db = E.db.WT.item.itemLevel.flyout.font.color
								local default = P.item.itemLevel.flyout.font.color
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.item.itemLevel.flyout.font.color
								db.r, db.g, db.b = r, g, b
							end,
						},
					},
				},
			},
		},
		scrappingMachine = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Scrapping Machine"],
			disabled = function()
				return not E.db.WT.item.itemLevel.enable
			end,
			get = function(info)
				return E.db.WT.item.itemLevel.scrappingMachine[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.item.itemLevel.scrappingMachine[info[#info]] = value
			end,
			args = {
				enable = {
					order = 0,
					type = "toggle",
					name = L["Enable"],
					width = "full",
				},
				font = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Font"],
					get = function(info)
						return E.db.WT.item.itemLevel.scrappingMachine.font[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.item.itemLevel.scrappingMachine.font[info[#info]] = value
					end,
					disabled = function()
						return E.db.WT.item.itemLevel.scrappingMachine.useBagsFontSetting
							or not E.db.WT.item.itemLevel.enable
					end,
					args = {
						useBagsFontSetting = {
							order = 0,
							get = function(info)
								return E.db.WT.item.itemLevel.scrappingMachine[info[#info]]
							end,
							set = function(info, value)
								E.db.WT.item.itemLevel.scrappingMachine[info[#info]] = value
							end,
							disabled = function()
								return not E.db.WT.item.itemLevel.enable
							end,
							type = "toggle",
							name = L["Use Bags Setting"],
							desc = L["Render the item level text with the setting in ElvUI bags."],
						},
						name = {
							order = 1,
							type = "select",
							dialogControl = "LSM30_Font",
							name = L["Font"],
							values = LSM:HashTable("font"),
						},
						style = {
							order = 2,
							type = "select",
							name = L["Outline"],
							values = {
								NONE = L["None"],
								OUTLINE = L["OUTLINE"],
								THICKOUTLINE = L["THICKOUTLINE"],
								SHADOW = L["SHADOW"],
								SHADOWOUTLINE = L["SHADOWOUTLINE"],
								SHADOWTHICKOUTLINE = L["SHADOWTHICKOUTLINE"],
								MONOCHROME = L["MONOCHROME"],
								MONOCHROMEOUTLINE = L["MONOCROMEOUTLINE"],
								MONOCHROMETHICKOUTLINE = L["MONOCHROMETHICKOUTLINE"],
							},
						},
						size = {
							order = 3,
							name = L["Size"],
							type = "range",
							min = 5,
							max = 60,
							step = 1,
						},
						xOffset = {
							order = 4,
							name = L["X-Offset"],
							type = "range",
							min = -100,
							max = 100,
							step = 1,
						},
						yOffset = {
							order = 5,
							name = L["Y-Offset"],
							type = "range",
							min = -100,
							max = 100,
							step = 1,
						},
					},
				},
				color = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Color"],
					disabled = function()
						return E.db.WT.item.itemLevel.scrappingMachine.qualityColor or not E.db.WT.item.itemLevel.enable
					end,
					args = {
						qualityColor = {
							order = 0,
							get = function(info)
								return E.db.WT.item.itemLevel.scrappingMachine[info[#info]]
							end,
							set = function(info, value)
								E.db.WT.item.itemLevel.scrappingMachine[info[#info]] = value
							end,
							disabled = function()
								return not E.db.WT.item.itemLevel.enable
							end,
							type = "toggle",
							name = L["Quality Color"],
						},
						color = {
							order = 6,
							type = "color",
							name = L["Color"],
							hasAlpha = false,
							get = function(info)
								local db = E.db.WT.item.itemLevel.scrappingMachine.font.color
								local default = P.item.itemLevel.scrappingMachine.font.color
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.item.itemLevel.scrappingMachine.font.color
								db.r, db.g, db.b = r, g, b
							end,
						},
					},
				},
			},
		},
	},
}

options.extendMerchantPages = {
	order = 8,
	type = "group",
	name = L["Extend Merchant Pages"],
	get = function(info)
		return E.private.WT.item.extendMerchantPages[info[#info]]
	end,
	set = function(info, value)
		E.private.WT.item.extendMerchantPages[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		desc = {
			order = 0,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				feature = {
					order = 1,
					type = "description",
					name = function()
						if EMP.StopRunning then
							return format(
								"|cffff3860" .. L["Because of %s, this module will not be loaded."] .. "|r",
								EMP.StopRunning
							)
						else
							return L["Extends the merchant page to show more items."]
						end
					end,
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			width = "full",
			disabled = function()
				return EMP.StopRunning
			end,
		},
		numberOfPages = {
			order = 2,
			type = "range",
			name = L["Number of Pages"],
			desc = L["The number of pages shown in the merchant frame."],
			min = 2,
			max = 6,
			step = 1,
			disabled = function()
				return EMP.StopRunning or not E.private.WT.item.extendMerchantPages.enable
			end,
		},
	},
}
