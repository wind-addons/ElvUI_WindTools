local W, F, E, L, V, P, G = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable, PrivateDB, ProfileDB, GlobalDB
local LSM = E.Libs.LSM
local AceConfigRegistry = E.Libs.AceConfigRegistry
local C = W.Utilities.Color
local CA = W:GetModule("CombatAlert")
local DL = W:GetModule("DamageMeterLayout")
local DT = W:GetModule("DestroyTotem")
local QK = W:GetModule("QuickKeystone")
local RM = W:GetModule("RaidMarkers")

local format = format
local tonumber = tonumber
local tinsert = tinsert
local tremove = tremove
local wipe = wipe

local CopyTable = CopyTable

local Constants_PartyCountdownConstants_MaxCountdownSeconds = Constants.PartyCountdownConstants.MaxCountdownSeconds

local options = W.options.combat.args

options.raidMarkers = {
	order = 1,
	type = "group",
	name = L["Raid Markers"],
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
					name = L["Add an extra bar to let you set raid markers efficiently."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			desc = L["Toggle raid markers bar."],
			get = function(info)
				return E.db.WT.combat.raidMarkers[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.combat.raidMarkers[info[#info]] = value
				RM:ProfileUpdate()
			end,
		},
		inverse = {
			order = 3,
			type = "toggle",
			name = L["Inverse Mode"],
			desc = L["Swap the functionality of normal click and click with modifier keys."],
			get = function(info)
				return E.db.WT.combat.raidMarkers[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.combat.raidMarkers[info[#info]] = value
				RM:ToggleSettings()
			end,
			disabled = function()
				return not E.db.WT.combat.raidMarkers.enable
			end,
			width = 2,
		},
		visibilityConfig = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Visibility"],
			get = function(info)
				return E.db.WT.combat.raidMarkers[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.combat.raidMarkers[info[#info]] = value
				RM:ToggleSettings()
			end,
			disabled = function()
				return not E.db.WT.combat.raidMarkers.enable
			end,
			args = {
				visibility = {
					type = "select",
					order = 1,
					name = L["Visibility"],
					values = {
						DEFAULT = L["Default"],
						INPARTY = L["In Party"],
						ALWAYS = L["Always Display"],
					},
				},
				mouseOver = {
					order = 2,
					type = "toggle",
					name = L["Mouse Over"],
					desc = L["Only show raid markers bar when you mouse over it."],
				},
				tooltip = {
					order = 3,
					type = "toggle",
					name = L["Tooltip"],
					desc = L["Show the tooltip when you mouse over the button."],
				},
				modifier = {
					order = 4,
					type = "select",
					name = L["Modifier Key"],
					desc = L["Set the modifier key for placing world markers."],
					values = {
						shift = L["Shift Key"],
						ctrl = L["Ctrl Key"],
						alt = L["Alt Key"],
					},
				},
			},
		},
		barConfig = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Raid Markers Bar"],
			get = function(info)
				return E.db.WT.combat.raidMarkers[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.combat.raidMarkers[info[#info]] = value
				RM:ToggleSettings()
			end,
			disabled = function()
				return not E.db.WT.combat.raidMarkers.enable
			end,
			args = {
				backdrop = {
					order = 1,
					type = "toggle",
					name = L["Bar Backdrop"],
					desc = L["Show a backdrop of the bar."],
				},
				backdropSpacing = {
					order = 2,
					type = "range",
					name = L["Backdrop Spacing"],
					desc = L["The spacing between the backdrop and the buttons."],
					min = 1,
					max = 30,
					step = 1,
				},
				orientation = {
					order = 3,
					type = "select",
					name = L["Orientation"],
					desc = L["Arrangement direction of the bar."],
					values = {
						HORIZONTAL = L["Horizontal"],
						VERTICAL = L["Vertical"],
					},
				},
			},
		},
		raidButtons = {
			order = 6,
			type = "group",
			inline = true,
			name = L["Raid Buttons"],
			get = function(info)
				return E.db.WT.combat.raidMarkers[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.combat.raidMarkers[info[#info]] = value
				RM:UpdateBar()
				RM:UpdateCountDownButton()
			end,
			disabled = function()
				return not E.db.WT.combat.raidMarkers.enable
			end,
			args = {
				readyCheck = {
					order = 1,
					type = "toggle",
					name = L["Ready Check"] .. " / " .. L["Advanced Combat Logging"],
					desc = format(
						"%s\n%s",
						L["Left Click to ready check."],
						L["Right click to toggle advanced combat logging."]
					),
					width = 2,
				},
				countDown = {
					order = 2,
					type = "toggle",
					name = L["Count Down"],
				},
				countDownTime = {
					order = 3,
					type = "range",
					name = L["Count Down Time"],
					desc = L["Count down time in seconds."],
					min = 1,
					max = Constants_PartyCountdownConstants_MaxCountdownSeconds,
					step = 1,
				},
			},
		},
		buttonsConfig = {
			order = 7,
			type = "group",
			inline = true,
			name = L["Buttons"],
			get = function(info)
				return E.db.WT.combat.raidMarkers[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.combat.raidMarkers[info[#info]] = value
				RM:ToggleSettings()
			end,
			disabled = function()
				return not E.db.WT.combat.raidMarkers.enable
			end,
			args = {
				buttonSize = {
					order = 1,
					type = "range",
					name = L["Button Size"],
					desc = L["The size of the buttons."],
					min = 15,
					max = 60,
					step = 1,
				},
				spacing = {
					order = 2,
					type = "range",
					name = L["Button Spacing"],
					desc = L["The spacing between buttons."],
					min = 1,
					max = 30,
					step = 1,
				},
				buttonBackdrop = {
					order = 3,
					type = "toggle",
					name = L["Button Backdrop"],
				},
				buttonAnimation = {
					order = 4,
					type = "toggle",
					name = L["Button Animation"],
				},
				buttonAnimationDuration = {
					order = 5,
					type = "range",
					name = L["Button Animation Duration"],
					desc = L["The duration of the button animation in seconds."],
					hidden = function()
						return not E.db.WT.combat.raidMarkers.buttonAnimation
					end,
					min = 0.01,
					max = 2,
					step = 0.01,
					width = 1.2,
				},
				buttonAnimationScale = {
					order = 6,
					type = "range",
					name = L["Button Animation Scale"],
					desc = L["The scale of the button animation."],
					hidden = function()
						return not E.db.WT.combat.raidMarkers.buttonAnimation
					end,
					min = 0.01,
					max = 5,
					step = 0.01,
					width = 1.2,
				},
			},
		},
	},
}

options.combatAlert = {
	order = 2,
	type = "group",
	name = L["Combat Alert"],
	desc = L["Show a alert when you enter or leave combat."],
	get = function(info)
		return E.db.WT.combat.combatAlert[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.combat.combatAlert[info[#info]] = value
		CA:ProfileUpdate()
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
					name = L["This module will display a alert frame when entering and leaving combat.\n" .. "You can customize animations and text effects."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
		},
		speed = {
			order = 3,
			type = "range",
			name = L["Speed"],
			desc = L["The speed of the alert."],
			min = 0.1,
			max = 4,
			step = 0.01,
		},
		preview = {
			order = 4,
			type = "execute",
			name = L["Preview"],
			desc = L["Preview the alert visual effect."],
			func = function()
				CA:Preview()
			end,
		},
		animationConfig = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Animation"],
			args = {
				animation = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Display an animation when you enter or leave combat."],
				},
				animationSize = {
					order = 2,
					type = "range",
					name = L["Animation Size"],
					desc = L["The speed of the alert."],
					min = 0.1,
					max = 3,
					step = 0.01,
				},
			},
		},
		textConfig = {
			order = 6,
			type = "group",
			inline = true,
			name = L["Text"],
			args = {
				text = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Display a text when you enter or leave combat."],
				},
				enterText = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Enter Text"],
					args = {
						enterText = {
							order = 1,
							type = "input",
							name = L["Text"],
						},
						leftColor = {
							order = 2,
							type = "color",
							name = L["Gradient Color 1"],
							hasAlpha = false,
							get = function(info)
								local db = E.db.WT.combat.combatAlert.enterColor.left
								local default = P.combat.combatAlert.enterColor.left
								return db.r, db.g, db.b, nil, default.r, default.g, default.b
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.combat.combatAlert.enterColor.left
								db.r, db.g, db.b = r, g, b
								CA:ProfileUpdate()
							end,
						},
						rightColor = {
							order = 3,
							type = "color",
							name = L["Gradient Color 2"],
							hasAlpha = false,
							get = function(info)
								local db = E.db.WT.combat.combatAlert.enterColor.right
								local default = P.combat.combatAlert.enterColor.right
								return db.r, db.g, db.b, nil, default.r, default.g, default.b
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.combat.combatAlert.enterColor.right
								db.r, db.g, db.b = r, g, b
								CA:ProfileUpdate()
							end,
						},
					},
				},
				leaveText = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Leave Text"],
					args = {
						leaveText = {
							order = 1,
							type = "input",
							name = L["Text"],
						},
						leftColor = {
							order = 2,
							type = "color",
							name = L["Gradient Color 1"],
							hasAlpha = false,
							get = function(info)
								local db = E.db.WT.combat.combatAlert.leaveColor.left
								local default = P.combat.combatAlert.leaveColor.left
								return db.r, db.g, db.b, nil, default.r, default.g, default.b
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.combat.combatAlert.leaveColor.left
								db.r, db.g, db.b = r, g, b
								CA:ProfileUpdate()
							end,
						},
						rightColor = {
							order = 3,
							type = "color",
							name = L["Gradient Color 2"],
							hasAlpha = false,
							get = function(info)
								local db = E.db.WT.combat.combatAlert.leaveColor.right
								local default = P.combat.combatAlert.leaveColor.right
								return db.r, db.g, db.b, nil, default.r, default.g, default.b
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.combat.combatAlert.leaveColor.right
								db.r, db.g, db.b = r, g, b
								CA:ProfileUpdate()
							end,
						},
					},
				},
				font = {
					type = "group",
					order = 6,
					name = L["Font Setting"],
					get = function(info)
						return E.db.WT.combat.combatAlert[info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.WT.combat.combatAlert[info[#info - 1]][info[#info]] = value
						CA:ProfileUpdate()
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
					},
				},
			},
		},
		soundConfig = {
			order = 7,
			type = "group",
			inline = true,
			name = L["Sound"],
			args = {
				enterSound = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Enter Combat"],
					get = function(info)
						return E.db.WT.combat.combatAlert.enterSound[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.combat.combatAlert.enterSound[info[#info]] = value
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
						},
						sound = {
							order = 2,
							type = "select",
							dialogControl = "LSM30_Sound",
							name = L["Sound"],
							values = LSM:HashTable("sound"),
							hidden = function()
								return not E.db.WT.combat.combatAlert.enterSound.enable
							end,
						},
						channel = {
							order = 3,
							type = "select",
							name = L["Sound Channel"],
							values = {
								Master = L["Master"],
								SFX = L["SFX"],
								Music = L["Music"],
								Ambience = L["Ambience"],
								Dialog = L["Dialog"],
							},
							sorting = { "Master", "Music", "SFX", "Ambience", "Dialog" },
							hidden = function()
								return not E.db.WT.combat.combatAlert.enterSound.enable
							end,
						},
					},
				},
				leaveSound = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Leave Combat"],
					get = function(info)
						return E.db.WT.combat.combatAlert.leaveSound[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.combat.combatAlert.leaveSound[info[#info]] = value
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
						},
						sound = {
							order = 2,
							type = "select",
							dialogControl = "LSM30_Sound",
							name = L["Sound"],
							values = LSM:HashTable("sound"),
							hidden = function()
								return not E.db.WT.combat.combatAlert.leaveSound.enable
							end,
						},
						channel = {
							order = 3,
							type = "select",
							name = L["Sound Channel"],
							values = {
								Master = L["Master"],
								SFX = L["SFX"],
								Music = L["Music"],
								Ambience = L["Ambience"],
								Dialog = L["Dialog"],
							},
							sorting = { "Master", "Music", "SFX", "Ambience", "Dialog" },
							hidden = function()
								return not E.db.WT.combat.combatAlert.leaveSound.enable
							end,
						},
					},
				},
			},
		},
	},
}

options.destroyTotem = {
	order = 3,
	type = "group",
	name = L["Destroy Totem"],
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
					name = L["Use key bindings or macro to destroy your totems quickly."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			get = function(info)
				return E.private.WT.combat.destroyTotem[info[#info]]
			end,
			set = function(info, value)
				E.private.WT.combat.destroyTotem[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		keyConfig = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Key Bindings"],
			get = function(info)
				return E.private.WT.combat.destroyTotem.keys[tonumber(info[#info])]
			end,
			set = function(info, value)
				E.private.WT.combat.destroyTotem.keys[tonumber(info[#info])] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			disabled = function()
				return not E.private.WT.combat.destroyTotem.enable
			end,
			args = {
				["1"] = {
					order = 1,
					type = "keybinding",
					name = format(L["Destroy Totem %s"], 1),
				},
				["2"] = {
					order = 2,
					type = "keybinding",
					name = format(L["Destroy Totem %s"], 2),
				},
				["3"] = {
					order = 3,
					type = "keybinding",
					name = format(L["Destroy Totem %s"], 3),
				},
				["4"] = {
					order = 4,
					type = "keybinding",
					name = format(L["Destroy Totem %s"], 4),
				},
			},
		},
		macroText = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Macro Text"],
			get = function(info)
				return DT:GetMacroText(tonumber(info[#info]))
			end,
			hidden = function()
				return not E.private.WT.combat.destroyTotem.enable
			end,
			set = E.noop,
			args = {
				tip = {
					order = 1,
					type = "description",
					name = format(
						"%s: %s",
						C.StringByTemplate(L["Tip"], "emerald-500"),
						L["If you want to destroy totems by macro, or combine with other actions, you can use the following macro text."]
					),
				},
				["1"] = {
					order = 11,
					type = "input",
					name = format(L["Destroy Totem %s"], 1),
					width = "full",
				},
				["2"] = {
					order = 12,
					type = "input",
					name = format(L["Destroy Totem %s"], 2),
					width = "full",
				},
				["3"] = {
					order = 13,
					type = "input",
					name = format(L["Destroy Totem %s"], 3),
					width = "full",
				},
				["4"] = {
					order = 14,
					type = "input",
					name = format(L["Destroy Totem %s"], 4),
					width = "full",
				},
			},
		},
	},
}

options.quickKeystone = {
	order = 4,
	name = L["Quick Keystone"],
	type = "group",
	get = function(info)
		return E.db.WT.combat.quickKeystone[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.combat.quickKeystone[info[#info]] = value
		QK:ProfileUpdate()
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
					name = L["Put the keystone from bag automatically."],
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
	},
}

local damageMeterEditingLayout = 1
local damageMeterRuleKeys = { "combat", "outOfCombat", "mythicPlus", "raid", "delve" }
local damageMeterLayoutDynamicArgKeys = {}
local RebuildDamageMeterLayoutTabArgs

local function GetDamageMeterLayoutValues(includeNone)
	local values = {}
	local layouts = E.db.WT.combat.damageMeterLayout.layouts

	if includeNone then
		values[0] = L["None"]
	end

	for i = 1, #layouts do
		local layout = layouts[i]
		values[i] = layout.name or format(L["Layout %d"], i)
	end

	return values
end

local function ReindexDamageMeterLayoutRef(layoutIndex, removedIndex)
	if not layoutIndex then
		return nil
	end

	if layoutIndex == removedIndex then
		return 1
	end

	if layoutIndex > removedIndex then
		return layoutIndex - 1
	end

	return layoutIndex
end

local function NormalizeDamageMeterLayoutRefs(removedIndex)
	local db = E.db.WT.combat.damageMeterLayout
	local rules = db.autoSwitch and db.autoSwitch.rules

	db.activeLayout = ReindexDamageMeterLayoutRef(db.activeLayout, removedIndex) or 1
	damageMeterEditingLayout = ReindexDamageMeterLayoutRef(damageMeterEditingLayout, removedIndex) or 1

	if rules then
		for i = 1, #damageMeterRuleKeys do
			local key = damageMeterRuleKeys[i]
			rules[key] = ReindexDamageMeterLayoutRef(rules[key], removedIndex)
		end
	end
end

local function IsWindowIndexDuplicated(layout, slotIndex, windowIndex)
	for i = 1, 3 do
		if i ~= slotIndex then
			local meter = layout.meters[i]
			if meter and meter.windowIndex == windowIndex then
				return true
			end
		end
	end

	return false
end

local function UpdateDamageMeterLayoutOptions(rebuildTabs)
	DL:ProfileUpdate()

	if rebuildTabs then
		RebuildDamageMeterLayoutTabArgs()
	end

	if AceConfigRegistry then
		AceConfigRegistry:NotifyChange("ElvUI")
	end
end

local function BuildLayoutSlotGroup(layoutIndex, slotIndex, order)
	return {
		order = order,
		type = "group",
		inline = true,
		name = format(L["Slot %d"], slotIndex),
		args = {
			window = {
				order = 1,
				type = "select",
				name = L["Window"],
				values = {
					[0] = L["None"],
					[1] = "1",
					[2] = "2",
					[3] = "3",
				},
				get = function()
					damageMeterEditingLayout = layoutIndex
					local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
					local meter = layout.meters and layout.meters[slotIndex]
					return meter and meter.windowIndex or 0
				end,
				set = function(_, value)
					damageMeterEditingLayout = layoutIndex
					local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
					layout.meters = layout.meters or {}
					if value == 0 then
						layout.meters[slotIndex] = nil
					elseif not IsWindowIndexDuplicated(layout, slotIndex, value) then
						layout.meters[slotIndex] = layout.meters[slotIndex] or { weight = 100, hidden = false }
						layout.meters[slotIndex].windowIndex = value
					else
						E:Print(L["Damage Meter Layout: duplicated window index in current layout."])
					end
					UpdateDamageMeterLayoutOptions(false)
				end,
				disabled = function()
					return not E.db.WT.combat.damageMeterLayout.enable
				end,
			},
			weight = {
				order = 2,
				type = "range",
				name = L["Weight"],
				desc = L["The relative weight of the meter compared to other meters in the same layout."],
				min = 1,
				max = 100,
				step = 1,
				get = function()
					damageMeterEditingLayout = layoutIndex
					local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
					local meter = layout.meters and layout.meters[slotIndex]
					return meter and meter.weight or 1
				end,
				set = function(_, value)
					damageMeterEditingLayout = layoutIndex
					local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
					layout.meters = layout.meters or {}
					if layout.meters[slotIndex] then
						layout.meters[slotIndex].weight = value
						UpdateDamageMeterLayoutOptions(false)
					end
				end,
				disabled = function()
					local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
					return not E.db.WT.combat.damageMeterLayout.enable
						or not (
							layout
							and layout.meters
							and layout.meters[slotIndex]
							and layout.meters[slotIndex].windowIndex
						)
				end,
			},
			hidden = {
				order = 3,
				type = "toggle",
				name = L["Hide"],
				desc = L["Hide this meter slot in the layout."]
					.. "\n"
					.. L["If all slots in the layout are hidden, the full layout container will also be hidden."],
				get = function()
					damageMeterEditingLayout = layoutIndex
					local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
					local meter = layout.meters and layout.meters[slotIndex]
					return meter and meter.hidden == true or false
				end,
				set = function(_, value)
					damageMeterEditingLayout = layoutIndex
					local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
					layout.meters = layout.meters or {}
					if layout.meters[slotIndex] then
						layout.meters[slotIndex].hidden = value == true
						UpdateDamageMeterLayoutOptions(false)
					end
				end,
				disabled = function()
					local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
					return not E.db.WT.combat.damageMeterLayout.enable
						or not (
							layout
							and layout.meters
							and layout.meters[slotIndex]
							and layout.meters[slotIndex].windowIndex
						)
				end,
			},
		},
	}
end

local function BuildLayoutTabGroup(layoutIndex)
	return {
		type = "group",
		name = function()
			local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
			return layout.name or format(L["Layout %d"], layoutIndex)
		end,
		args = {
			layout = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Layout"],
				args = {
					name = {
						order = 1,
						type = "input",
						name = L["Layout Name"],
						get = function()
							damageMeterEditingLayout = layoutIndex
							local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
							return layout.name
						end,
						set = function(_, value)
							damageMeterEditingLayout = layoutIndex
							local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
							layout.name = value ~= "" and value or format(L["Layout %d"], layoutIndex)
							UpdateDamageMeterLayoutOptions(false)
						end,
						disabled = function()
							return not E.db.WT.combat.damageMeterLayout.enable
						end,
					},
					deleteLayout = {
						order = 2,
						type = "execute",
						name = C.StringByTemplate(L["Delete this layout"], "red-500"),
						confirm = function()
							return format(
								L["Are you sure you want to delete layout %s? This action cannot be undone."],
								E.db.WT.combat.damageMeterLayout.layouts[layoutIndex].name
							)
						end,
						func = function()
							tremove(E.db.WT.combat.damageMeterLayout.layouts, layoutIndex)
							NormalizeDamageMeterLayoutRefs(layoutIndex)
							DL:StopPreview()
							UpdateDamageMeterLayoutOptions(true)
						end,
						hidden = function()
							return not E.db.WT.combat.damageMeterLayout.enable
								or #E.db.WT.combat.damageMeterLayout.layouts <= 1
								or layoutIndex == 1
						end,
					},
					divider = {
						order = 3,
						type = "description",
						name = "",
						width = "full",
					},
					direction = {
						order = 4,
						type = "select",
						name = L["Direction"],
						values = {
							HORIZONTAL = L["Horizontal"],
							VERTICAL = L["Vertical"],
						},
						get = function()
							damageMeterEditingLayout = layoutIndex
							local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
							return layout.direction
						end,
						set = function(_, value)
							damageMeterEditingLayout = layoutIndex
							local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
							layout.direction = value
							UpdateDamageMeterLayoutOptions(false)
						end,
						disabled = function()
							return not E.db.WT.combat.damageMeterLayout.enable
						end,
					},
					outerPadding = {
						order = 5,
						type = "range",
						name = L["Outer Padding"],
						desc = L["The padding between the backdrop and the meters in the layout."],
						min = 0,
						max = 30,
						step = 1,
						get = function()
							damageMeterEditingLayout = layoutIndex
							local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
							return layout.outerPadding
						end,
						set = function(_, value)
							damageMeterEditingLayout = layoutIndex
							local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
							layout.outerPadding = value
							UpdateDamageMeterLayoutOptions(false)
						end,
						disabled = function()
							return not E.db.WT.combat.damageMeterLayout.enable
						end,
					},
					innerPadding = {
						order = 6,
						type = "range",
						name = L["Inner Padding"],
						desc = L["The padding between meters in the layout."],
						min = 0,
						max = 30,
						step = 1,
						get = function()
							damageMeterEditingLayout = layoutIndex
							local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
							return layout.innerPadding
						end,
						set = function(_, value)
							damageMeterEditingLayout = layoutIndex
							local layout = E.db.WT.combat.damageMeterLayout.layouts[layoutIndex]
							layout.innerPadding = value
							UpdateDamageMeterLayoutOptions(false)
						end,
						disabled = function()
							return not E.db.WT.combat.damageMeterLayout.enable
						end,
					},
				},
			},
			windowDistribution = {
				order = 5,
				type = "group",
				inline = true,
				name = L["Window Distribution"],
				args = {
					slot1 = BuildLayoutSlotGroup(layoutIndex, 1, 1),
					slot2 = BuildLayoutSlotGroup(layoutIndex, 2, 2),
					slot3 = BuildLayoutSlotGroup(layoutIndex, 3, 3),
				},
			},
		},
	}
end

RebuildDamageMeterLayoutTabArgs = function()
	local damageMeterLayoutArgs = options.damageMeterLayout.args.layouts.args
	for i = 1, #damageMeterLayoutDynamicArgKeys do
		damageMeterLayoutArgs[damageMeterLayoutDynamicArgKeys[i]] = nil
	end
	wipe(damageMeterLayoutDynamicArgKeys)

	local layouts = E.db.WT.combat.damageMeterLayout.layouts

	for i = 1, #layouts do
		local key = "layoutTab" .. i
		damageMeterLayoutArgs[key] = BuildLayoutTabGroup(i)
		damageMeterLayoutArgs[key].order = i
		damageMeterLayoutDynamicArgKeys[#damageMeterLayoutDynamicArgKeys + 1] = key
	end

	local newTabKey = "layoutTabNew"
	damageMeterLayoutArgs[newTabKey] = {
		order = #layouts + 1,
		type = "group",
		name = C.StringByTemplate("+ " .. L["New"], "emerald-500"),
		args = {
			newLayout = {
				order = 1,
				type = "execute",
				name = L["Create"],
				func = function()
					local newLayout = CopyTable(P.combat.damageMeterLayout.layouts[1])
					local layoutCount = #layouts + 1
					newLayout.name = format(L["Layout %d"], layoutCount)
					tinsert(layouts, newLayout)
					damageMeterEditingLayout = layoutCount
					E.db.WT.combat.damageMeterLayout.activeLayout = damageMeterEditingLayout
					UpdateDamageMeterLayoutOptions(true)
				end,
				disabled = function()
					return not E.db.WT.combat.damageMeterLayout.enable
				end,
			},
		},
	}
	damageMeterLayoutDynamicArgKeys[#damageMeterLayoutDynamicArgKeys + 1] = newTabKey
end

options.damageMeterLayout = {
	order = 5,
	type = "group",
	childGroups = "tab",
	name = L["Damage Meter Layout"],
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
					name = L["Manage Blizzard Damage Meter windows with reusable layouts."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			get = function(info)
				return E.db.WT.combat.damageMeterLayout[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.combat.damageMeterLayout[info[#info]] = value
				DL:ProfileUpdate()
			end,
		},
		activeLayout = {
			order = 3,
			type = "select",
			name = L["Active Layout"],
			values = function()
				return GetDamageMeterLayoutValues(false)
			end,
			get = function()
				return E.db.WT.combat.damageMeterLayout.activeLayout
			end,
			set = function(_, value)
				local targetLayout = value
				if DL:IsPreviewing() then
					DL:Preview(targetLayout)
				else
					DL:UpdateLayout(targetLayout)
				end
			end,
			disabled = function()
				return not E.db.WT.combat.damageMeterLayout.enable
			end,
		},
		applyRecommendedSkin = {
			order = 4,
			type = "execute",
			name = L["Recommended Skin Settings"],
			desc = L["Apply recommended Damage Meter Wind skin settings for the best experience."],
			confirm = true,
			confirmText = L["Apply skin settings and reload UI?"],
			func = function()
				E.private.WT.skins.damageMeter.windowBackdrop = "hide"
				E.private.WT.skins.damageMeter.headerPart = "always"
				E.private.WT.skins.damageMeter.headerBackdrop = "hide"
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			width = 1.5,
		},
		preview = {
			order = 5,
			type = "execute",
			name = function()
				if DL:IsPreviewing() then
					return C.StringByTemplate(L["Stop Preview Mode"], "red-500")
				end

				return L["Start Preview Mode"]
			end,
			desc = L["Lock and preview the active layout."],
			disabled = function()
				return not E.db.WT.combat.damageMeterLayout.enable
			end,
			func = function()
				local layoutIndex = damageMeterEditingLayout

				if DL:IsPreviewing() and DL.previewLayoutIndex == layoutIndex then
					DL:StopPreview()
				else
					DL:Preview(layoutIndex)
				end
			end,
			width = 1.5,
		},
		container = {
			order = 7,
			type = "group",
			name = L["Container"],
			args = {
				tip = {
					order = 1,
					type = "description",
					name = L["You can move the container in ElvUI move mode."],
					fontSize = "medium",
				},
				width = {
					order = 2,
					type = "range",
					name = L["Width"],
					min = 200,
					max = 1600,
					step = 1,
					get = function()
						return E.db.WT.combat.damageMeterLayout.width
					end,
					set = function(_, value)
						E.db.WT.combat.damageMeterLayout.width = value
						DL:ProfileUpdate()
					end,
					disabled = function()
						return not E.db.WT.combat.damageMeterLayout.enable
					end,
				},
				height = {
					order = 3,
					type = "range",
					name = L["Height"],
					min = 120,
					max = 1000,
					step = 1,
					get = function()
						return E.db.WT.combat.damageMeterLayout.height
					end,
					set = function(_, value)
						E.db.WT.combat.damageMeterLayout.height = value
						DL:ProfileUpdate()
					end,
					disabled = function()
						return not E.db.WT.combat.damageMeterLayout.enable
					end,
				},
				backdrop = {
					order = 4,
					type = "toggle",
					name = L["Backdrop"],
					get = function()
						return E.db.WT.combat.damageMeterLayout.backdrop
					end,
					set = function(_, value)
						E.db.WT.combat.damageMeterLayout.backdrop = value
						DL:ProfileUpdate()
					end,
					disabled = function()
						return not E.db.WT.combat.damageMeterLayout.enable
					end,
				},
				shadow = {
					order = 5,
					type = "toggle",
					name = L["Shadow"],
					get = function()
						return E.db.WT.combat.damageMeterLayout.shadow
					end,
					set = function(_, value)
						E.db.WT.combat.damageMeterLayout.shadow = value
						DL:ProfileUpdate()
					end,
					disabled = function()
						return not E.db.WT.combat.damageMeterLayout.enable
					end,
				},
				animation = {
					order = 6,
					type = "toggle",
					name = L["Animation"],
					desc = L["Fade in/out the damage meters when switching layouts."],
					get = function()
						return E.db.WT.combat.damageMeterLayout.animation.enable
					end,
					set = function(_, value)
						E.db.WT.combat.damageMeterLayout.animation.enable = value
					end,
					disabled = function()
						return not E.db.WT.combat.damageMeterLayout.enable
					end,
				},
				animationDuration = {
					order = 7,
					type = "range",
					name = L["Animation Duration"],
					desc = L["Values below 0.05 are treated as disabled."],
					min = 0,
					max = 2,
					step = 0.01,
					get = function()
						return E.db.WT.combat.damageMeterLayout.animation.duration
					end,
					set = function(_, value)
						E.db.WT.combat.damageMeterLayout.animation.duration = value
					end,
					hidden = function()
						return not E.db.WT.combat.damageMeterLayout.animation.enable
					end,
					disabled = function()
						return not E.db.WT.combat.damageMeterLayout.enable
					end,
				},
				autoSwitch = {
					order = 8,
					type = "group",
					inline = true,
					name = L["Auto Switch"],
					args = {
						desc = {
							order = 1,
							type = "description",
							name = format(
								"%s\n%s",
								L["Automatically switch damage meter layouts based on different combat scenarios."],
								C.StringByTemplate(L["Priority"], "yellow-500")
									.. format(
										": %s > %s > %s > %s > %s",
										L["Raid"],
										L["Mythic Plus"],
										L["Delves"],
										L["In Combat"],
										L["Out of Combat"]
									)
							),
						},
						enable = {
							order = 2,
							type = "toggle",
							name = L["Enable"],
							get = function()
								return E.db.WT.combat.damageMeterLayout.autoSwitch.enable
							end,
							set = function(_, value)
								E.db.WT.combat.damageMeterLayout.autoSwitch.enable = value
								DL:AutoSwitch(true)
							end,
							disabled = function()
								return not E.db.WT.combat.damageMeterLayout.enable
							end,
						},
						divider = {
							order = 10,
							type = "description",
							name = "",
							width = "full",
						},
						raid = {
							order = 11,
							type = "select",
							name = L["Raid"],
							values = function()
								return GetDamageMeterLayoutValues(true)
							end,
							get = function()
								return E.db.WT.combat.damageMeterLayout.autoSwitch.rules.raid or 0
							end,
							set = function(_, value)
								E.db.WT.combat.damageMeterLayout.autoSwitch.rules.raid = value == 0 and nil or value
								DL:AutoSwitch(true)
							end,
							hidden = function()
								return not E.db.WT.combat.damageMeterLayout.enable
									or not E.db.WT.combat.damageMeterLayout.autoSwitch.enable
							end,
						},
						mythicPlus = {
							order = 12,
							type = "select",
							name = L["Mythic Plus"],
							values = function()
								return GetDamageMeterLayoutValues(true)
							end,
							get = function()
								return E.db.WT.combat.damageMeterLayout.autoSwitch.rules.mythicPlus or 0
							end,
							set = function(_, value)
								E.db.WT.combat.damageMeterLayout.autoSwitch.rules.mythicPlus = value == 0 and nil
									or value
								DL:AutoSwitch(true)
							end,
							hidden = function()
								return not E.db.WT.combat.damageMeterLayout.enable
									or not E.db.WT.combat.damageMeterLayout.autoSwitch.enable
							end,
						},
						delve = {
							order = 13,
							type = "select",
							name = L["Delves"],
							values = function()
								return GetDamageMeterLayoutValues(true)
							end,
							get = function()
								return E.db.WT.combat.damageMeterLayout.autoSwitch.rules.delve or 0
							end,
							set = function(_, value)
								E.db.WT.combat.damageMeterLayout.autoSwitch.rules.delve = value == 0 and nil or value
								DL:AutoSwitch(true)
							end,
							hidden = function()
								return not E.db.WT.combat.damageMeterLayout.enable
									or not E.db.WT.combat.damageMeterLayout.autoSwitch.enable
							end,
						},
						combat = {
							order = 14,
							type = "select",
							name = L["In Combat"],
							values = function()
								return GetDamageMeterLayoutValues(true)
							end,
							get = function()
								return E.db.WT.combat.damageMeterLayout.autoSwitch.rules.combat or 0
							end,
							set = function(_, value)
								E.db.WT.combat.damageMeterLayout.autoSwitch.rules.combat = value == 0 and nil or value
								DL:AutoSwitch(true)
							end,
							hidden = function()
								return not E.db.WT.combat.damageMeterLayout.enable
									or not E.db.WT.combat.damageMeterLayout.autoSwitch.enable
							end,
						},
						outOfCombat = {
							order = 15,
							type = "select",
							name = L["Out of Combat"],
							values = function()
								return GetDamageMeterLayoutValues(true)
							end,
							get = function()
								return E.db.WT.combat.damageMeterLayout.autoSwitch.rules.outOfCombat or 0
							end,
							set = function(_, value)
								E.db.WT.combat.damageMeterLayout.autoSwitch.rules.outOfCombat = value == 0 and nil
									or value
								DL:AutoSwitch(true)
							end,
							hidden = function()
								return not E.db.WT.combat.damageMeterLayout.enable
									or not E.db.WT.combat.damageMeterLayout.autoSwitch.enable
							end,
						},
					},
				},
			},
		},
		layouts = {
			order = 8,
			type = "group",
			childGroups = "tree",
			name = L["Layouts"],
			args = {},
		},
	},
}

W:RunAfterOptionsLoaded(RebuildDamageMeterLayoutTabArgs)
