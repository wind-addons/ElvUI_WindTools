local W, F, E, L, V, P, G = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable, PrivateDB, ProfileDB, GlobalDB
local options = W.options.unitFrames.args
local LSM = E.Libs.LSM
local C = W.Utilities.Color

local A = W:GetModule("Absorb") ---@class Absorb
local CT = W:GetModule("ChatText")

local format = format
local pairs = pairs

options.quickFocus = {
	order = 1,
	type = "group",
	name = L["Quick Focus"],
	get = function(info)
		return E.private.WT.unitFrames.quickFocus[info[#info]]
	end,
	set = function(info, value)
		E.private.WT.unitFrames.quickFocus[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
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
					name = L["Focus the target by modifier key + click."],
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
		modifier = {
			order = 3,
			type = "select",
			name = L["Modifier Key"],
			disabled = function()
				return not E.private.WT.unitFrames.quickFocus.enable
			end,
			values = {
				shift = L["Shift Key"],
				ctrl = L["Ctrl Key"],
				alt = L["Alt Key"],
			},
		},
		button = {
			order = 4,
			type = "select",
			name = L["Button"],
			disabled = function()
				return not E.private.WT.unitFrames.quickFocus.enable
			end,
			values = {
				BUTTON1 = L["Left Button"],
				BUTTON2 = L["Right Button"],
				BUTTON3 = L["Middle Button"],
				BUTTON4 = L["Side Button 4"],
				BUTTON5 = L["Side Button 5"],
			},
		},
		setMark = {
			order = 5,
			type = "toggle",
			name = L["Set Mark"],
			desc = L["Set the raid marker on the quick focused target if possible."],
			disabled = function()
				return not E.private.WT.unitFrames.quickFocus.enable
			end,
		},
		markNumber = {
			order = 6,
			type = "select",
			name = L["Mark"],
			disabled = function()
				return not E.private.WT.unitFrames.quickFocus.enable or not E.private.WT.unitFrames.quickFocus.setMark
			end,
			values = {
				[1] = F.GetIconString("Interface\\TargetingFrame\\UI-RaidTargetingIcon_1"),
				[2] = F.GetIconString("Interface\\TargetingFrame\\UI-RaidTargetingIcon_2"),
				[3] = F.GetIconString("Interface\\TargetingFrame\\UI-RaidTargetingIcon_3"),
				[4] = F.GetIconString("Interface\\TargetingFrame\\UI-RaidTargetingIcon_4"),
				[5] = F.GetIconString("Interface\\TargetingFrame\\UI-RaidTargetingIcon_5"),
				[6] = F.GetIconString("Interface\\TargetingFrame\\UI-RaidTargetingIcon_6"),
				[7] = F.GetIconString("Interface\\TargetingFrame\\UI-RaidTargetingIcon_7"),
				[8] = F.GetIconString("Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"),
			},
		},
		safeMark = {
			order = 7,
			type = "toggle",
			name = L["Safe Mark"],
			desc = format(
				"%s\n\n%s",
				L["Only set raid markers on castable targets to prevent 'invalid target' errors by avoiding enemy players."],
				L["Note: This may prevent auto-marking certain NPCs or objects."]
			),
			disabled = function()
				return not E.private.WT.unitFrames.quickFocus.enable or not E.private.WT.unitFrames.quickFocus.setMark
			end,
		},
		notice = {
			order = 8,
			type = "description",
			name = format(
				"%s %s",
				C.StringByTemplate(L["Notice"], "rose-500"),
				L["Blizzard not allow setting raid markers on enemy faction players."]
			),
			fontSize = "medium",
		},
	},
}

options.absorb = {
	order = 2,
	type = "group",
	name = L["Absorb"],
	get = function(info)
		return E.db.WT.unitFrames.absorb[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.unitFrames.absorb[info[#info]] = value
		A:ProfileUpdate()
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
					name = L["Modify the texture of the absorb bar."]
						.. "\n"
						.. L["Add the Blizzard over absorb glow and overlay to ElvUI unit frames."],
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
		texture = {
			order = 3,
			type = "group",
			name = L["Texture"],
			disabled = function()
				return not E.db.WT.unitFrames.absorb.enable
			end,
			inline = true,
			get = function(info)
				return E.db.WT.unitFrames.absorb.texture[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.unitFrames.absorb.texture[info[#info]] = value
				A:ProfileUpdate()
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable the replacing of ElvUI absorb bar textures."],
				},
				blizzardStyle = {
					order = 2,
					type = "toggle",
					name = L["Blizzard Style"],
					desc = L["Use the texture from Blizzard Raid Frames."],
					disabled = function()
						return not E.db.WT.unitFrames.absorb.enable or not E.db.WT.unitFrames.absorb.texture.enable
					end,
				},
				custom = {
					order = 3,
					type = "select",
					name = L["Custom Texture"],
					desc = L["The selected texture will override the ElvUI default absorb bar texture."],
					disabled = function()
						return not E.db.WT.unitFrames.absorb.enable
							or not E.db.WT.unitFrames.absorb.texture.enable
							or E.db.WT.unitFrames.absorb.texture.blizzardStyle
					end,
					dialogControl = "LSM30_Statusbar",
					values = LSM:HashTable("statusbar"),
				},
			},
		},
		misc = {
			order = 4,
			type = "group",
			name = L["Misc"],
			inline = true,
			disabled = function()
				return not E.db.WT.unitFrames.absorb.enable
			end,
			args = {
				blizzardOverAbsorbGlow = {
					order = 1,
					type = "toggle",
					name = L["Blizzard Over Absorb Glow"],
					desc = L["Add a glow in the end of health bars to indicate the over absorb."],
					width = 1.5,
				},
				blizzardAbsorbOverlay = {
					order = 2,
					type = "toggle",
					name = L["Blizzard Absorb Overlay"],
					desc = L["Add an additional overlay to the absorb bar."],
					width = 1.3,
				},
				setColor = {
					order = 4,
					type = "execute",
					name = L["Color"],
					func = function()
						E:ToggleOptions("unitframe,allColorsGroup,healPrediction")
					end,
					width = 0.6,
				},
			},
		},
		elvui = {
			order = 5,
			type = "group",
			name = L["ElvUI"],
			inline = true,
			disabled = function()
				return not E.db.WT.unitFrames.absorb.enable
			end,
			args = {
				feature = {
					order = 1,
					type = "description",
					width = "full",
					name = format(
						"%s\n%s",
						format(
							L["The absorb style %s and %s is highly recommended with %s tweaks."],
							C.StringWithRGB(L["Overflow"], E.db.general.valuecolor),
							C.StringWithRGB(L["Auto Height"], E.db.general.valuecolor),
							W.Title
						),
						L["Here are some buttons for helping you change the setting of all absorb bars by one-click."]
					),
				},
				setAllAbsorbStyleToOverflow = {
					order = 2,
					type = "execute",
					name = format(
						L["Set All Absorb Style to %s"],
						C.StringWithRGB(L["Overflow"], E.db.general.valuecolor)
					),
					func = function(info)
						for key in pairs(E.db.unitframe.units) do
							local db = E.db.unitframe.units[key].healPrediction
							if db and db.absorbStyle then
								db.absorbStyle = "OVERFLOW"
							end
						end
						E.UnitFrames:Update_AllFrames()
					end,
					width = 1.7,
				},
				setAllAbsorbStyleToAutoHeight = {
					order = 3,
					type = "execute",
					name = format(
						L["Set All Absorb Style to %s"],
						C.StringWithRGB(L["Auto Height"], E.db.general.valuecolor)
					),
					func = function()
						for key in pairs(E.db.unitframe.units) do
							local db = E.db.unitframe.units[key].healPrediction
							if db and db.height then
								db.height = -1
							end
						end
						E.UnitFrames:Update_AllFrames()
					end,
					width = 1.7,
				},
				changeColor = {
					order = 4,
					type = "execute",
					name = format(L["%s style absorb color"], W.Title),
					desc = L["Change the color of the absorb bar."],
					func = function()
						E.db.unitframe.colors.healPrediction.absorbs = { r = 0.06, g = 0.83, b = 1, a = 1 }
						E.db.unitframe.colors.healPrediction.overabsorbs = { r = 0.06, g = 0.83, b = 1, a = 1 }
					end,
					width = 1.7,
				},
				changeMaxOverflow = {
					order = 5,
					type = "execute",
					name = format(
						L["Set %s to %s"],
						C.StringWithRGB(L["Max Overflow"], E.db.general.valuecolor),
						C.StringWithRGB("0", E.db.general.valuecolor)
					),
					func = function()
						E.db.unitframe.colors.healPrediction.maxOverflow = 0
					end,
					width = 1.7,
				},
			},
		},
	},
}

local SampleStrings = {}
do
	local icons = ""
	icons = icons .. E:TextureString(CT.cache.elvuiRoleIconsPath.Tank, ":16:16:0:0:64:64:2:56:2:56") .. " "
	icons = icons .. E:TextureString(CT.cache.elvuiRoleIconsPath.Healer, ":16:16:0:0:64:64:2:56:2:56") .. " "
	icons = icons .. E:TextureString(CT.cache.elvuiRoleIconsPath.DPS, ":16:16")
	SampleStrings.ELVUI = icons

	for _, pack in ipairs({ "FFXIV", "PHILMOD", "HEXAGON", "SUNUI", "LYNUI", "ELVUI_OLD", "DEFAULT", "BLIZZARD" }) do
		icons = ""

		icons = icons .. E:TextureString(W.Media.RoleIcons[pack].TANK, ":16:16") .. " "
		icons = icons .. E:TextureString(W.Media.RoleIcons[pack].HEALER, ":16:16") .. " "
		icons = icons .. E:TextureString(W.Media.RoleIcons[pack].DAMAGER, ":16:16")
		SampleStrings[pack] = icons
	end
end

options.roleIcon = {
	order = 3,
	type = "group",
	name = L["Role Icon"],
	get = function(info)
		return E.private.WT.unitFrames.roleIcon[info[#info]]
	end,
	set = function(info, value)
		E.private.WT.unitFrames.roleIcon[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
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
					name = L["Change the role icon of unitframes."],
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
		roleIconStyle = {
			order = 3,
			type = "select",
			name = L["Style"],
			desc = L["Change the icons that indicate the role."],
			values = {
				HEXAGON = SampleStrings.HEXAGON,
				PHILMOD = SampleStrings.PHNILMOD,
				FFXIV = SampleStrings.FFXIV,
				SUNUI = SampleStrings.SUNUI,
				LYNUI = SampleStrings.LYNUI,
				ELVUI_OLD = SampleStrings.ELVUI_OLD,
				BLIZZARD = SampleStrings.BLIZZARD,
				DEFAULT = SampleStrings.DEFAULT,
			},
		},
	},
}

options.tags = {
	order = 99,
	type = "group",
	name = L["Tags"],
	get = function(info)
		return E.private.WT.unitFrames.tags[info[#info]]
	end,
	set = function(info, value)
		E.private.WT.unitFrames.tags[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
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
					name = L["Add more oUF tags. You can use them on UnitFrames configuration."],
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
		availableTags = {
			order = 3,
			type = "header",
			name = L["Available Tags"],
		},
	},
}

do
	local examples = {}

	examples.health = {
		order = 10,
		name = L["Health"],
		float1 = {
			order = 1,
			tag = "[perhp1f]",
			text = L["The percentage of health without percent sign and status"]
				.. format(" (%s = 1)", L["Decimal Length"]),
		},
		float2 = {
			order = 2,
			tag = "[perhp2f]",
			text = L["The percentage of health without percent sign and status"]
				.. format(" (%s = 2)", L["Decimal Length"]),
		},
		float3 = {
			order = 3,
			tag = "[perhp3f]",
			text = L["The percentage of health without percent sign and status"]
				.. format(" (%s = 3)", L["Decimal Length"]),
		},
		absorbsAutohide = {
			order = 4,
			tag = "[absorbs-autohide]",
			text = format(
				L["Just like %s, but it will be hidden when the amount is zero."],
				C.StringByTemplate("[absorbs]", "sky-500")
			),
		},
		healabsorbsAutohide = {
			order = 5,
			tag = "[healabsorbs-autohide]",
			text = format(
				L["Just like %s, but it will be hidden when the amount is zero."],
				C.StringByTemplate("[healabsorbs]", "sky-500")
			),
		},
	}

	examples.power = {
		order = 11,
		name = L["Power"],
		smart = {
			tag = "[smart-power]",
			text = L["Automatically select the best format of power (e.g. Rogue is 120, Mage is 100%)"],
		},
		smartNoSign = {
			tag = "[smart-power-nosign]",
			text = L["Automatically select the best format of power (e.g. Rogue is 120, Mage is 100)"],
		},
	}

	examples.range = {
		order = 12,
		name = L["Range"],
		normal = {
			tag = "[range]",
			text = L["Range"],
		},
		expectation = {
			tag = "[range:expectation]",
			text = L["Range Expectation"],
		},
	}

	examples.color = {
		order = 13,
		name = L["Color"],
		player = {
			order = 0,
			tag = "[classcolor:player]",
			text = L["The color of the player's class"],
		},
	}

	---@type table<ClassFile, string>
	local classNames = {
		WARRIOR = L["Warrior"],
		PALADIN = L["Paladin"],
		HUNTER = L["Hunter"],
		ROGUE = L["Rogue"],
		PRIEST = L["Priest"],
		DEATHKNIGHT = L["Deathknight"],
		SHAMAN = L["Shaman"],
		MAGE = L["Mage"],
		WARLOCK = L["Warlock"],
		MONK = L["Monk"],
		DRUID = L["Druid"],
		DEMONHUNTER = L["Demonhunter"],
		EVOKER = L["Evoker"],
	}

	for i = 1, GetNumClasses() do
		local classFile = select(2, GetClassInfo(i))
		examples.color[classFile] = {
			order = i,
			tag = format("[classcolor:%s]", strlower(classFile)),
			text = format(L["The color of %s"], C.StringWithClassColor(classNames[classFile], classFile)),
		}
	end

	for index, style in pairs(F.GetClassIconStyleList()) do
		examples["classIcon_" .. style] = {
			order = 20 + index,
			name = L["Class Icon"] .. " - " .. style,
			["PLAYER_ICON"] = {
				order = 1,
				type = "description",
				image = function()
					return F.GetClassIconWithStyle(E.myclass, style), 64, 64
				end,
				width = 1,
			},
			["PLAYER_TAG"] = {
				order = 2,
				text = L["The class icon of the player's class"],
				tag = "[classicon-" .. style .. "]",
				width = 1.5,
			},
		}

		for i = 1, GetNumClasses() do
			local classFile = select(2, GetClassInfo(i))
			examples["classIcon_" .. style][classFile .. "_ALIGN"] = {
				order = 3 * i,
				type = "description",
			}
			examples["classIcon_" .. style][classFile .. "_ICON"] = {
				order = 3 * i + 1,
				type = "description",
				image = function()
					return F.GetClassIconWithStyle(classFile, style), 64, 64
				end,
				width = 1,
			}
			examples["classIcon_" .. style][classFile .. "_TAG"] = {
				order = 3 * i + 2,
				text = C.StringWithClassColor(classNames[classFile], classFile),
				tag = "[classicon-" .. style .. ":" .. strlower(classFile) .. "]",
				width = 1.5,
			}
		end
	end

	for cat, catTable in pairs(examples) do
		options.tags.args[cat] = {
			order = catTable.order,
			type = "group",
			name = catTable.name,
			inline = false,
			args = {},
		}

		local subIndex = 1
		for key, data in pairs(catTable) do
			if key ~= "name" and key ~= "order" then
				options.tags.args[cat].args[key] = {
					order = data.order or subIndex,
					type = data.type or "input",
					width = data.width or "full",
					name = data.text or "",
					get = function()
						return data.tag
					end,
				}

				if data.image then
					options.tags.args[cat].args[key].image = data.image
				end
				subIndex = subIndex + 1
			end
		end
	end
end
