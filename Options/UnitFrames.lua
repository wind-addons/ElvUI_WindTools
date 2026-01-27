local W, F, E, L, V, P, G = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable, PrivateDB, ProfileDB, GlobalDB
local options = W.options.unitFrames.args
local LSM = E.Libs.LSM
local C = W.Utilities.Color

local A = W:GetModule("Absorb")
local CT = W:GetModule("ChatText")

local format = format

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
	name = W.FixingLabel .. L["Absorb"],
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
			get = function()
				return false
			end,
			disabled = true, -- TODO: Wait for ElvUI UnitFrames
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
						A:ChangeDB(function(db)
							db.absorbStyle = "OVERFLOW"
						end)
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
					func = function(info)
						A:ChangeDB(function(db)
							db.height = -1
						end)
					end,
					width = 1.7,
				},
				changeColor = {
					order = 4,
					type = "execute",
					name = format(L["%s style absorb color"], W.Title),
					desc = L["Change the color of the absorb bar."],
					func = function(info)
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
					func = function(info)
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
	icons = icons .. E:TextureString(W.Media.Icons.ffxivTank, ":16:16") .. " "
	icons = icons .. E:TextureString(W.Media.Icons.ffxivHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(W.Media.Icons.ffxivDPS, ":16:16")
	SampleStrings.ffxiv = icons

	icons = ""
	icons = icons .. E:TextureString(W.Media.Icons.philModTank, ":16:16") .. " "
	icons = icons .. E:TextureString(W.Media.Icons.philModHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(W.Media.Icons.philModDPS, ":16:16")
	SampleStrings.philMod = icons

	icons = ""
	icons = icons .. E:TextureString(W.Media.Icons.hexagonTank, ":16:16") .. " "
	icons = icons .. E:TextureString(W.Media.Icons.hexagonHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(W.Media.Icons.hexagonDPS, ":16:16")
	SampleStrings.hexagon = icons

	icons = ""
	icons = icons .. E:TextureString(CT.cache.elvuiRoleIconsPath.Tank, ":16:16:0:0:64:64:2:56:2:56") .. " "
	icons = icons .. E:TextureString(CT.cache.elvuiRoleIconsPath.Healer, ":16:16:0:0:64:64:2:56:2:56") .. " "
	icons = icons .. E:TextureString(CT.cache.elvuiRoleIconsPath.DPS, ":16:16")
	SampleStrings.elvui = icons

	icons = ""
	icons = icons .. E:TextureString(W.Media.Icons.sunUITank, ":16:16") .. " "
	icons = icons .. E:TextureString(W.Media.Icons.sunUIHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(W.Media.Icons.sunUIDPS, ":16:16")
	SampleStrings.sunui = icons

	icons = ""
	icons = icons .. E:TextureString(W.Media.Icons.lynUITank, ":16:16") .. " "
	icons = icons .. E:TextureString(W.Media.Icons.lynUIHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(W.Media.Icons.lynUIDPS, ":16:16")
	SampleStrings.lynui = icons

	icons = ""
	icons = icons .. E:TextureString(W.Media.Icons.elvUIOldTank, ":16:16") .. " "
	icons = icons .. E:TextureString(W.Media.Icons.elvUIOldHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(W.Media.Icons.elvUIOldDPS, ":16:16")
	SampleStrings.elvui_old = icons

	icons = ""
	icons = icons .. E:TextureString(W.Media.Icons.blizzardTank, ":16:16") .. " "
	icons = icons .. E:TextureString(W.Media.Icons.blizzardHealer, ":16:16") .. " "
	icons = icons .. E:TextureString(W.Media.Icons.blizzardDPS, ":16:16")
	SampleStrings.blizzard = icons
end

options.roleIcon = {
	order = 3,
	type = "group",
	name = W.FixingLabel .. L["Role Icon"],
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
				HEXAGON = SampleStrings.hexagon,
				PHILMOD = SampleStrings.philMod,
				FFXIV = SampleStrings.ffxiv,
				SUNUI = SampleStrings.sunui,
				LYNUI = SampleStrings.lynui,
				ELVUI_OLD = SampleStrings.elvui_old,
				BLIZZARD = SampleStrings.blizzard,
				DEFAULT = SampleStrings.elvui,
			},
		},
	},
}
