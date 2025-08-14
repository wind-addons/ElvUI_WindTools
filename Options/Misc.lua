local W, F, E, L, V, P, G = unpack((select(2, ...)))
local C = W.Utilities.Color
local async = W.Utilities.Async
local options = W.options.misc.args
local LSM = E.Libs.LSM
local M = W.Modules.Misc
local MF = W.Modules.MoveFrames
local CT = W:GetModule("ChatText")
local GB = W:GetModule("GameBar")
local AM = W:GetModule("Automation")
local SA = W:GetModule("SpellActivationAlert")
local LL = W:GetModule("LFGList")

local format = format
local pairs = pairs
local select = select
local tonumber = tonumber
local tostring = tostring

local GetClassColor = GetClassColor
local GetClassInfo = GetClassInfo
local GetNumClasses = GetNumClasses

local C_CVar_GetCVar = C_CVar.GetCVar
local C_CVar_GetCVarBool = C_CVar.GetCVarBool
local C_CVar_SetCVar = C_CVar.SetCVar

local function GetClassColorString(class)
	local hexString = select(4, GetClassColor(class))
	return "|c" .. hexString
end

options.general = {
	order = 1,
	type = "group",
	name = L["General"],
	get = function(info)
		return E.private.WT.misc[info[#info]]
	end,
	set = function(info, value)
		E.private.WT.misc[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		pauseToSlash = {
			order = 1,
			type = "toggle",
			name = L["Pause to slash"],
			desc = L["Just for Chinese and Korean players"],
		},
		noKanjiMath = {
			order = 2,
			type = "toggle",
			name = L["Math Without Kanji"],
			desc = L["Use alphabet rather than kanji (Only for Chinese players)"],
		},
		disableTalkingHead = {
			order = 3,
			type = "toggle",
			name = L["Disable Talking Head"],
			desc = L["Disable Blizzard Talking Head."],
			get = function(info)
				return E.db.WT.misc[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.misc[info[#info]] = value
			end,
		},
		skipCutScene = {
			order = 4,
			type = "toggle",
			name = L["Skip Cut Scene"],
			set = function(info, value)
				E.private.WT.misc[info[#info]] = value
				M:SkipCutScene()
			end,
		},
		onlyStopWatched = {
			order = 5,
			type = "toggle",
			name = L["Only Watched"],
			desc = L["Only skip watched cut scene. (some cut scenes can't be skipped)"],
			hidden = function()
				return not E.private.WT.misc.skipCutScene
			end,
			set = function(info, value)
				E.private.WT.misc[info[#info]] = value
			end,
		},
		autoScreenshot = {
			order = 6,
			type = "toggle",
			name = L["Auto Screenshot"],
			desc = L["Screenshot after you earned an achievement automatically."],
		},
		moveSpeed = {
			order = 7,
			type = "toggle",
			name = L["Move Speed"],
			desc = L["Show move speed in character panel."],
		},
		hideCrafter = {
			order = 8,
			type = "toggle",
			name = L["Hide Crafter"],
			desc = L["Hide crafter name in the item tooltip."],
			get = function(info)
				return E.db.WT.misc[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.misc[info[#info]] = value
			end,
		},
		noLootPanel = {
			order = 9,
			type = "toggle",
			name = L["No Loot Panel"],
			desc = L["Disable Blizzard loot info which auto showing after combat overed."],
			get = function(info)
				return E.db.WT.misc[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.misc[info[#info]] = value
				M:LootPanel()
			end,
		},
		keybindTextAbove = {
			order = 10,
			type = "toggle",
			name = L["Keybind Text Above"],
			desc = format(
				"%s\n%s",
				L["Show keybinds above the ElvUI cooldown and glow effect on the action buttons."],
				F.CreateColorString(L["Only works with ElvUI action bar and ElvUI cooldowns."], E.db.general.valuecolor)
			),
		},
		guildNewsItemLevel = {
			order = 11,
			type = "toggle",
			name = L["Guild News IL"],
			desc = L["Show item level of each item in guild news."],
		},
		addCNFilter = {
			order = 12,
			type = "toggle",
			name = L["View SC Group"],
			desc = L["Let you can view the group created by Simplified Chinese players."],
		},
		antiOverride = {
			order = 13,
			type = "toggle",
			name = L["Anti-override"],
			desc = L["Unblock the profanity filter and disable model override."]
				.. "\n"
				.. C.StringByTemplate(L["It only applies to players who play WoW in Simplified Chinese."], "warning"),
		},
		autoToggleChatBubble = {
			order = 14,
			type = "toggle",
			name = L["Auto Toggle Chat Bubble"],
			desc = L["Only show chat bubble in instance."],
			width = 1.5,
		},
		reshiiWrapsUpgrade = {
			order = 15,
			type = "toggle",
			name = L["Reshii Wraps Upgrade"],
			desc = L["Middle click the character back slot to open the Reshii Wraps upgrade menu."],
		},
	},
}

options.automation = {
	order = 2,
	type = "group",
	name = L["Automation"],
	get = function(info)
		return E.db.WT.misc.automation[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.misc.automation[info[#info]] = value
		AM:ProfileUpdate()
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
					name = L["Automate your game life."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.db.WT.misc.automation[info[#info]] = value
			end,
			width = "full",
		},
		hideWorldMapAfterEnteringCombat = {
			order = 3,
			type = "toggle",
			name = L["Auto Hide Map"],
			desc = L["Automatically close world map if player enters combat."],
			disabled = function()
				return not E.db.WT.misc.automation.enable
			end,
			width = 1.5,
		},
		hideBagAfterEnteringCombat = {
			order = 4,
			type = "toggle",
			name = L["Auto Hide Bag"],
			desc = L["Automatically close bag if player enters combat."],
			disabled = function()
				return not E.db.WT.misc.automation.enable
			end,
			width = 1.5,
		},
		acceptResurrect = {
			order = 5,
			type = "toggle",
			name = L["Accept Resurrect"],
			desc = L["Accept resurrect from other player automatically when you not in combat."],
			disabled = function()
				return not E.db.WT.misc.automation.enable
			end,
			width = 1.5,
		},
		acceptCombatResurrect = {
			order = 6,
			type = "toggle",
			name = L["Accept Combat Resurrect"],
			desc = L["Accept resurrect from other player automatically when you in combat."],
			disabled = function()
				return not E.db.WT.misc.automation.enable
			end,
			width = 1.5,
		},
		confirmSummon = {
			order = 7,
			type = "toggle",
			name = L["Confirm Summon"],
			desc = L["Confirm summon from other player automatically."],
			disabled = function()
				return not E.db.WT.misc.automation.enable
			end,
			width = 1.5,
		},
	},
}

options.cvars = {
	order = 3,
	type = "group",
	name = L["CVars Editor"],
	get = function(info)
		return C_CVar_GetCVarBool(info[#info])
	end,
	set = function(info, value)
		C_CVar_SetCVar(info[#info], value and "1" or "0")
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
					name = format(
						"%s\n|cffff3860%s|r %s",
						L["A simple editor for CVars."],
						format(L["%s never lock the CVars."], W.Title),
						L["If you found the CVars changed automatically, please check other addons."]
					),
					fontSize = "medium",
				},
			},
		},
		combat = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Combat"],
			args = {
				floatingCombatTextCombatDamage = {
					order = 1,
					type = "toggle",
					name = L["Floating Damage Text"],
				},
				floatingCombatTextCombatHealing = {
					order = 2,
					type = "toggle",
					name = L["Floating Healing Text"],
				},
				WorldTextScale = {
					order = 3,
					type = "range",
					name = L["Floating Text Scale"],
					get = function(info)
						return tonumber(C_CVar_GetCVar(info[#info]))
					end,
					set = function(info, value)
						return C_CVar_SetCVar(info[#info], value)
					end,
					min = 0.1,
					max = 5,
					step = 0.1,
				},
				SpellQueueWindow = {
					order = 4,
					type = "range",
					name = L["Spell Queue Window"],
					get = function(info)
						return tonumber(C_CVar_GetCVar(info[#info]))
					end,
					set = function(info, value)
						return C_CVar_SetCVar(info[#info], value)
					end,
					min = 0,
					max = 400,
					step = 1,
				},
			},
		},
		visualEffect = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Visual Effect"],
			args = {
				ffxGlow = {
					order = 1,
					type = "toggle",
					name = L["Glow Effect"],
				},
				ffxDeath = {
					order = 2,
					type = "toggle",
					name = L["Death Effect"],
				},
				ffxNether = {
					order = 3,
					type = "toggle",
					name = L["Nether Effect"],
				},
			},
		},
		mouse = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Mouse"],
			args = {
				rawMouseEnable = {
					order = 1,
					type = "toggle",
					name = L["Raw Mouse"],
					desc = L["It will fix the problem if your cursor has abnormal movement."],
				},
				rawMouseAccelerationEnable = {
					order = 2,
					type = "toggle",
					name = L["Raw Mouse Acceleration"],
					desc = L["Changes the rate at which your mouse pointer moves based on the speed you are moving the mouse."],
				},
			},
		},
		nameplate = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Nameplate"],
			args = {
				tip = {
					order = 1,
					type = "description",
					name = format(
						"%s\n|cff209cee-|r %s |cff00d1b2%s|r\n|cff209cee-|r %s |cff00d1b2%s|r\n|cff209cee-|r %s |cffff3860%s|r",
						L["To enable the name of friendly player in instances, you can set as following:"],
						L["Friendly Player Name"],
						L["On"],
						L["Nameplate Only Names"],
						L["On"],
						L["Debuff on Friendly Nameplates"],
						L["Off"]
					),
				},
				UnitNameFriendlyPlayerName = {
					order = 2,
					type = "toggle",
					width = 1.5,
					name = L["Friendly Player Name"],
					desc = L["Show friendly players' names in the game world."],
				},
				nameplateShowOnlyNames = {
					order = 3,
					type = "toggle",
					width = 1.5,
					name = L["Nameplate Only Names"],
					desc = L["Disable the health bar of nameplate."],
				},
				nameplateShowDebuffsOnFriendly = {
					order = 4,
					type = "toggle",
					width = 1.5,
					name = L["Debuff on Friendly Nameplates"],
				},
				nameplateMotion = {
					order = 5,
					type = "toggle",
					width = 1.5,
					name = L["Stack Nameplates"],
				},
			},
		},
		misc = {
			order = 6,
			type = "group",
			inline = true,
			name = L["Misc"],
			args = {
				alwaysCompareItems = {
					order = 1,
					type = "toggle",
					name = L["Auto Compare"],
					width = 1.5,
				},
				autoOpenLootHistory = {
					order = 2,
					type = "toggle",
					name = L["Auto Open Loot History"],
					width = 1.5,
				},
			},
		},
	},
}

options.moveFrames = {
	order = 4,
	type = "group",
	name = L["Move Frames"],
	get = function(info)
		return E.private.WT.misc.moveFrames[info[#info]]
	end,
	set = function(info, value)
		E.private.WT.misc.moveFrames[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		desc = {
			order = 0,
			type = "group",
			inline = true,
			name = L["Description"],
			disabled = false,
			args = {
				feature = {
					order = 1,
					type = "description",
					name = function()
						if MF.StopRunning then
							return format(
								"|cffff3860" .. L["Because of %s, this module will not be loaded."] .. "|r",
								MF.StopRunning
							)
						else
							return L["This module provides the feature that repositions the frames with drag and drop."]
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
			disabled = function()
				return MF.StopRunning
			end,
		},
		elvUIBags = {
			order = 2,
			type = "toggle",
			name = L["Move ElvUI Bags"],
			disabled = function()
				return not MF:IsRunning()
			end,
		},
		tradeSkillMasterCompatible = {
			order = 3,
			type = "toggle",
			name = L["TSM Compatible"],
			desc = L["Fix the merchant frame showing when you using Trader Skill Master."],
			disabled = function()
				return not MF:IsRunning()
			end,
		},
		remember = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Remember Positions"],
			disabled = function()
				return not MF:IsRunning()
			end,
			args = {
				rememberPositions = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					set = function(info, value)
						E.private.WT.misc.moveFrames[info[#info]] = value
					end,
				},
				clearHistory = {
					order = 2,
					type = "execute",
					name = L["Clear History"],
					func = function()
						E.private.WT.misc.moveFrames.framePositions = {}
					end,
				},
				notice = {
					order = 999,
					type = "description",
					name = format(
						"\n|cffff3860%s|r %s",
						L["Notice"],
						format(
							L["%s may cause some frames to get messed, but you can use %s button to reset frames."],
							L["Remember Positions"],
							F.CreateColorString(L["Clear History"], E.db.general.valuecolor)
						)
					),
					fontSize = "medium",
				},
			},
		},
	},
}

options.mute = {
	order = 5,
	type = "group",
	name = L["Mute"],
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
					name = L["Disable some annoying sound effects."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			get = function(info)
				return E.private.WT.misc.mute.enable
			end,
			set = function(info, value)
				E.private.WT.misc.mute.enable = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		mount = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Mount"],
			get = function(info)
				return E.private.WT.misc.mute[info[#info - 1]][tonumber(info[#info])]
			end,
			set = function(info, value)
				E.private.WT.misc.mute[info[#info - 1]][tonumber(info[#info])] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {},
		},
		other = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Others"],
			get = function(info)
				return E.private.WT.misc.mute[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.private.WT.misc.mute[info[#info - 1]][info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				["Tortollan"] = {
					order = 1,
					type = "toggle",
					name = L["Tortollan"],
					width = 1.3,
				},
				["Crying"] = {
					order = 2,
					type = "toggle",
					name = L["Crying"],
					desc = L["Mute crying sounds of all races."]
						.. "\n|cffff3860"
						.. L["It will affect the cry emote sound."]
						.. "|r",
					width = 1.3,
				},
				["Dragon"] = {
					order = 3,
					type = "toggle",
					name = L["Dragon"],
					desc = L["Mute the sound of dragons."],
					width = 1.3,
				},
				["Jewelcrafting"] = {
					order = 4,
					type = "toggle",
					name = L["Jewelcrafting"],
					desc = L["Mute the sound of jewelcrafting."],
					width = 1.3,
				},
			},
		},
	},
}

do
	for id in pairs(V.misc.mute.mount) do
		async.WithSpellID(id, function(spell)
			local icon = spell:GetSpellTexture()
			local name = spell:GetSpellName()

			local iconString = F.GetIconString(icon, 12, 12)

			options.mute.args.mount.args[tostring(id)] = {
				order = id,
				type = "toggle",
				name = iconString .. " " .. name,
				width = 1.5,
			}
		end)
	end

	local itemList = {
		["Smolderheart"] = {
			id = 180873,
			desc = nil,
		},
		["Elegy of the Eternals"] = {
			id = 188270,
			desc = "|cffff3860" .. L["It will also affect the crying sound of all female Blood Elves."] .. "|r",
		},
	}

	for name, data in pairs(itemList) do
		async.WithItemID(data.id, function(item)
			local icon = item:GetItemIcon()
			local name = item:GetItemName()
			local color = item:GetItemQualityColor()

			local iconString = F.GetIconString(icon)
			local nameString = F.CreateColorString(name, color)

			options.mute.args.other.args[name] = {
				order = data.id,
				type = "toggle",
				name = iconString .. " " .. nameString,
				desc = data.desc,
				width = 1.3,
			}
		end)
	end
end

options.tags = {
	order = 6,
	type = "group",
	name = L["Tags"],
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
					name = L["Add more oUF tags. You can use them on UnitFrames configuration."],
					fontSize = "medium",
				},
			},
		},
		tags = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			get = function(info)
				return E.private.WT.misc[info[#info]]
			end,
			set = function(info, value)
				E.private.WT.misc[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
	},
}

do
	local examples = {}

	examples.health = {
		order = 1,
		name = L["Health"],
		absorbsLong = {
			order = 1,
			tag = "[absorbs-long]",
			text = L["The amount of absorbs without math unit"],
		},
		absorbsPercent0 = {
			order = 1,
			tag = "[absorbs:percent-0]",
			text = L["The percentage of absorbs"] .. format(" (%s = 0)", L["Decimal Length"]),
		},
		absorbsPercent1 = {
			order = 2,
			tag = "[absorbs:percent-1]",
			text = L["The percentage of absorbs"] .. format(" (%s = 1)", L["Decimal Length"]),
		},
		absorbsPercent2 = {
			order = 3,
			tag = "[absorbs:percent-2]",
			text = L["The percentage of absorbs"] .. format(" (%s = 2)", L["Decimal Length"]),
		},
		absorbsPercent3 = {
			order = 4,
			tag = "[absorbs:percent-3]",
			text = L["The percentage of absorbs"] .. format(" (%s = 3)", L["Decimal Length"]),
		},
		absorbsPercentNosign0 = {
			order = 5,
			tag = "[absorbs:percent-nosign-0]",
			text = L["The percentage of absorbs without percent sign"] .. format(" (%s = 0)", L["Decimal Length"]),
		},
		absorbsPercentNosign1 = {
			order = 6,
			tag = "[absorbs:percent-nosign-1]",
			text = L["The percentage of absorbs without percent sign"] .. format(" (%s = 1)", L["Decimal Length"]),
		},
		absorbsPercentNosign2 = {
			order = 7,
			tag = "[absorbs:percent-nosign-2]",
			text = L["The percentage of absorbs without percent sign"] .. format(" (%s = 2)", L["Decimal Length"]),
		},
		absorbsPercentNosign3 = {
			order = 8,
			tag = "[absorbs:percent-nosign-3]",
			text = L["The percentage of absorbs without percent sign"] .. format(" (%s = 3)", L["Decimal Length"]),
		},
		noSign = {
			order = 9,
			tag = "[health:percent-nostatus]",
			text = L["The percentage of current health without status"] .. format(" (%s)", L["Follow ElvUI Setting"]),
		},
		noSign0 = {
			order = 10,
			tag = "[health:percent-nostatus-0]",
			text = L["The percentage of current health without status"] .. format(" (%s = 0)", L["Decimal Length"]),
		},
		noSign1 = {
			order = 11,
			tag = "[health:percent-nostatus-1]",
			text = L["The percentage of current health without status"] .. format(" (%s = 1)", L["Decimal Length"]),
		},
		noSign2 = {
			order = 12,
			tag = "[health:percent-nostatus-2]",
			text = L["The percentage of current health without status"] .. format(" (%s = 2)", L["Decimal Length"]),
		},
		noSign3 = {
			order = 13,
			tag = "[health:percent-nostatus-3]",
			text = L["The percentage of current health without status"] .. format(" (%s = 3)", L["Decimal Length"]),
		},
		noStatusNoSign = {
			order = 14,
			tag = "[health:percent-nostatus-nosign]",
			text = L["The percentage of health without percent sign and status"]
				.. format(" (%s)", L["Follow ElvUI Setting"]),
		},
		noStatusNoSign0 = {
			order = 15,
			tag = "[health:percent-nostatus-nosign-0]",
			text = L["The percentage of health without percent sign and status"]
				.. format(" (%s = 0)", L["Decimal Length"]),
		},
		noStatusNoSign1 = {
			order = 16,
			tag = "[health:percent-nostatus-nosign-1]",
			text = L["The percentage of health without percent sign and status"]
				.. format(" (%s = 1)", L["Decimal Length"]),
		},
		noStatusNoSign2 = {
			order = 17,
			tag = "[health:percent-nostatus-nosign-2]",
			text = L["The percentage of health without percent sign and status"]
				.. format(" (%s = 2)", L["Decimal Length"]),
		},
		noStatusNoSign3 = {
			order = 18,
			tag = "[health:percent-nostatus-nosign-3]",
			text = L["The percentage of health without percent sign and status"]
				.. format(" (%s = 3)", L["Decimal Length"]),
		},
	}

	examples.power = {
		order = 2,
		name = L["Power"],
		noSign = {
			tag = "[power:percent-nosign]",
			text = L["The percentage of current power without percent sign"],
		},
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
		order = 3,
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
		order = 4,
		name = L["Color"],
		player = {
			order = 0,
			tag = "[classcolor:player]",
			text = L["The color of the player's class"],
		},
	}

	local className = {
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
		local upperText = select(2, GetClassInfo(i))
		local coloredClassName = GetClassColorString(upperText) .. className[upperText] .. "|r"
		examples.color[upperText] = {
			order = i,
			tag = format("[classcolor:%s]", strlower(upperText)),
			text = format(L["The color of %s"], coloredClassName),
		}
	end

	for index, style in pairs(F.GetClassIconStyleList()) do
		examples["classIcon_" .. style] = {
			order = 5 + index,
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
			local upperText = select(2, GetClassInfo(i))
			local coloredClassName = GetClassColorString(upperText) .. className[upperText] .. "|r"
			examples["classIcon_" .. style][upperText .. "_ALIGN"] = {
				order = 3 * i,
				type = "description",
			}
			examples["classIcon_" .. style][upperText .. "_ICON"] = {
				order = 3 * i + 1,
				type = "description",
				image = function()
					return F.GetClassIconWithStyle(upperText, style), 64, 64
				end,
				width = 1,
			}
			examples["classIcon_" .. style][upperText .. "_TAG"] = {
				order = 3 * i + 2,
				text = coloredClassName,
				tag = "[classicon-" .. style .. ":" .. strlower(upperText) .. "]",
				width = 1.5,
			}
		end
	end

	for cat, catTable in pairs(examples) do
		options.tags.args[cat] = {
			order = catTable.order,
			type = "group",
			name = catTable.name,
			args = {},
		}

		local subIndex = 1
		for key, data in pairs(catTable) do
			if not F.In(key, { "name", "order" }) then
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

options.gameBar = {
	order = 7,
	type = "group",
	name = L["Game Bar"],
	get = function(info)
		return E.db.WT.misc.gameBar[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.misc.gameBar[info[#info]] = value
		GB:ProfileUpdate()
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
					name = L["Add a game bar for improving QoL."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			desc = L["Toggle the game bar."],
		},
		general = {
			order = 10,
			type = "group",
			name = L["General"],
			disabled = function()
				return not E.db.WT.misc.gameBar.enable
			end,
			get = function(info)
				return E.db.WT.misc.gameBar[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.misc.gameBar[info[#info]] = value
				GB:UpdateButtons()
				GB:UpdateLayout()
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
				timeAreaWidth = {
					order = 3,
					type = "range",
					name = L["Time Area Width"],
					min = 1,
					max = 200,
					step = 1,
				},
				timeAreaHeight = {
					order = 4,
					type = "range",
					name = L["Time Area Height"],
					min = 1,
					max = 100,
					step = 1,
				},
				spacing = {
					order = 5,
					type = "range",
					name = L["Button Spacing"],
					desc = L["The spacing between buttons."],
					min = 1,
					max = 30,
					step = 1,
				},
				buttonSize = {
					order = 6,
					type = "range",
					name = L["Button Size"],
					desc = L["The size of the buttons."],
					min = 2,
					max = 80,
					step = 1,
				},
			},
		},
		display = {
			order = 11,
			type = "group",
			name = L["Display"],
			disabled = function()
				return not E.db.WT.misc.gameBar.enable
			end,
			get = function(info)
				return E.db.WT.misc.gameBar[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.misc.gameBar[info[#info]] = value
				GB:UpdateMetadata()
				GB:UpdateButtons()
				GB:UpdateTime()
			end,
			args = {
				bar = {
					order = 1,
					type = "group",
					name = L["Bar"],
					inline = true,
					args = {
						mouseOver = {
							order = 1,
							type = "toggle",
							name = L["Mouse Over"],
							desc = L["Show the bar only when the mouse is hovered over the area."],
							set = function(info, value)
								E.db.WT.misc.gameBar[info[#info]] = value
								GB:UpdateBar()
							end,
						},
						notification = {
							order = 2,
							type = "toggle",
							name = L["Notification"],
							desc = L["Add an indicator icon to buttons."],
						},
						fadeTime = {
							order = 3,
							type = "range",
							name = L["Fade Time"],
							desc = L["The animation speed."],
							min = 0,
							max = 3,
							step = 0.01,
						},
						tooltipsAnchor = {
							order = 4,
							type = "select",
							name = L["Tooltip Anchor"],
							values = {
								ANCHOR_TOP = L["TOP"],
								ANCHOR_BOTTOM = L["BOTTOM"],
							},
						},
						visibility = {
							order = 5,
							type = "input",
							name = L["Visibility"],
							set = function(info, value)
								E.db.WT.misc.gameBar[info[#info]] = value
								GB:UpdateBar()
							end,
							width = "full",
						},
					},
				},
				animation = {
					order = 2,
					type = "group",
					name = L["Animation"],
					inline = true,
					get = function(info)
						return E.db.WT.misc.gameBar[info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.WT.misc.gameBar[info[#info - 1]][info[#info]] = value
						GB:UpdateMetadata()
						GB:UpdateButtons()
						GB:UpdateTime()
					end,
					args = {
						duration = {
							order = 1,
							type = "range",
							name = L["Duration"],
							desc = L["The duration of the animation in seconds."],
							min = 0,
							max = 3,
							step = 0.01,
						},
						ease = {
							order = 2,
							type = "select",
							name = L["Ease"],
							width = 1.3,
							desc = L["The easing function used for colorize the button."]
								.. "\n"
								.. L["You can preview the ease type in https://easings.net/"],
							values = W.AnimationEaseTable,
						},
						easeInvert = {
							order = 3,
							type = "toggle",
							name = L["Invert Ease"],
							desc = L["When enabled, this option inverts the easing function."]
								.. " "
								.. L["(e.g., 'in-quadratic' becomes 'out-quadratic' and vice versa)"]
								.. "\n"
								.. L["Generally, enabling this option makes the value increase faster in the first half of the animation."],
						},
					},
				},
				normal = {
					order = 3,
					type = "group",
					name = L["Color"] .. " - " .. L["Normal"],
					inline = true,
					args = {
						normalColor = {
							order = 1,
							type = "select",
							name = L["Mode"],
							values = {
								DEFAULT = L["Default"],
								CLASS = L["Class Color"],
								VALUE = L["Value Color"],
								CUSTOM = L["Custom"],
							},
						},
						customNormalColor = {
							order = 2,
							type = "color",
							hasAlpha = true,
							name = L["Custom Color"],
							hidden = function()
								return E.db.WT.misc.gameBar.normalColor ~= "CUSTOM"
							end,
							get = function(info)
								local db = E.db.WT.misc.gameBar[info[#info]]
								local default = P.misc.gameBar[info[#info]]
								return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
							end,
							set = function(info, r, g, b, a)
								local db = E.db.WT.misc.gameBar[info[#info]]
								db.r, db.g, db.b, db.a = r, g, b, a
								GB:UpdateMetadata()
								GB:UpdateButtons()
								GB:UpdateTime()
							end,
						},
					},
				},
				hover = {
					order = 4,
					type = "group",
					name = L["Color"] .. " - " .. L["Hover"],
					inline = true,
					args = {
						hoverColor = {
							order = 1,
							type = "select",
							name = L["Mode"],
							values = {
								DEFAULT = L["Default"],
								CLASS = L["Class Color"],
								VALUE = L["Value Color"],
								CUSTOM = L["Custom"],
							},
						},
						customHoverColor = {
							order = 2,
							type = "color",
							hasAlpha = true,
							name = L["Custom Color"],
							hidden = function()
								return E.db.WT.misc.gameBar.hoverColor ~= "CUSTOM"
							end,
							get = function(info)
								local db = E.db.WT.misc.gameBar[info[#info]]
								local default = P.misc.gameBar[info[#info]]
								return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
							end,
							set = function(info, r, g, b, a)
								local db = E.db.WT.misc.gameBar[info[#info]]
								db.r, db.g, db.b, db.a = r, g, b, a
								GB:UpdateMetadata()
								GB:UpdateButtons()
								GB:UpdateTime()
							end,
						},
					},
				},
				additionalText = {
					order = 5,
					type = "group",
					name = L["Additional Text"],
					inline = true,
					get = function(info)
						return E.db.WT.misc.gameBar.additionalText[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.misc.gameBar.additionalText[info[#info]] = value
						GB:UpdateButtons()
					end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = L["Enable"],
						},
						anchor = {
							order = 2,
							type = "select",
							name = L["Anchor Point"],
							values = {
								TOP = L["TOP"],
								BOTTOM = L["BOTTOM"],
								LEFT = L["LEFT"],
								RIGHT = L["RIGHT"],
								CENTER = L["CENTER"],
								TOPLEFT = L["TOPLEFT"],
								TOPRIGHT = L["TOPRIGHT"],
								BOTTOMLEFT = L["BOTTOMLEFT"],
								BOTTOMRIGHT = L["BOTTOMRIGHT"],
							},
						},
						x = {
							order = 3,
							type = "range",
							name = L["X-Offset"],
							min = -100,
							max = 100,
							step = 1,
						},
						y = {
							order = 4,
							type = "range",
							name = L["Y-Offset"],
							min = -100,
							max = 100,
							step = 1,
						},
						slowMode = {
							order = 5,
							type = "toggle",
							name = L["Slow Mode"],
							desc = L["Update the additional text every 10 seconds rather than every 1 second such that the used memory will be lower."],
						},
						font = {
							order = 6,
							type = "group",
							name = L["Font Setting"],
							inline = true,
							get = function(info)
								return E.db.WT.misc.gameBar.additionalText[info[#info - 1]][info[#info]]
							end,
							set = function(info, value)
								E.db.WT.misc.gameBar.additionalText[info[#info - 1]][info[#info]] = value
								GB:UpdateButtons()
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
			},
		},
		time = {
			order = 12,
			type = "group",
			name = L["Time"],
			disabled = function()
				return not E.db.WT.misc.gameBar.enable
			end,
			get = function(info)
				return E.db.WT.misc.gameBar.time[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.misc.gameBar.time[info[#info]] = value
				GB:UpdateTimeArea()
				GB:UpdateLayout()
			end,
			args = {
				localTime = {
					order = 2,
					type = "toggle",
					name = L["Local Time"],
				},
				twentyFour = {
					order = 3,
					type = "toggle",
					name = L["24 Hours"],
				},
				flash = {
					order = 4,
					type = "toggle",
					name = L["Flash"],
				},
				alwaysSystemInfo = {
					order = 5,
					type = "toggle",
					name = L["Always Show Info"],
					desc = L["The system information will be always shown rather than showing only being hovered."],
				},
				interval = {
					order = 6,
					type = "range",
					name = L["Interval"],
					desc = L["The interval of updating."],
					set = function(info, value)
						E.db.WT.misc.gameBar.time[info[#info]] = value
						GB:UpdateTimeTicker()
					end,
					min = 1,
					max = 60,
					step = 1,
				},
				font = {
					order = 6,
					type = "group",
					name = L["Font Setting"],
					inline = true,
					get = function(info)
						return E.db.WT.misc.gameBar.time[info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.db.WT.misc.gameBar.time[info[#info - 1]][info[#info]] = value
						GB:UpdateTimeArea()
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
		friends = {
			order = 13,
			type = "group",
			name = L["Friends"],
			disabled = function()
				return not E.db.WT.misc.gameBar.enable
			end,
			get = function(info)
				return E.db.WT.misc.gameBar.friends[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.misc.gameBar.friends[info[#info]] = value
				GB:UpdateHomeButton()
				GB:UpdateButtons()
			end,
			args = {
				showAllFriends = {
					order = 1,
					type = "toggle",
					name = L["Show All Friends"],
					desc = L["Show all friends rather than only friends who are currently playing WoW."],
				},
				countSubAccounts = {
					order = 2,
					type = "toggle",
					name = L["Count Sub Accounts"],
					desc = L["Count active WoW sub accounts rather than Battle.net Accounts."],
				},
			},
		},
		home = {
			order = 14,
			type = "group",
			name = L["Home"],
			disabled = function()
				return not E.db.WT.misc.gameBar.enable
			end,
			get = function(info)
				return E.db.WT.misc.gameBar.home[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.misc.gameBar.home[info[#info]] = value
				GB:UpdateHomeButton()
				GB:UpdateButtons()
			end,
			args = {},
		},
		leftButtons = {
			order = 15,
			type = "group",
			name = L["Left Panel"],
			disabled = function()
				return not E.db.WT.misc.gameBar.enable
			end,
			get = function(info)
				return E.db.WT.misc.gameBar.left[tonumber(info[#info])]
			end,
			set = function(info, value)
				E.db.WT.misc.gameBar.left[tonumber(info[#info])] = value
				GB:UpdateButtons()
				GB:UpdateLayout()
			end,
			args = {},
		},
		rightButtons = {
			order = 16,
			type = "group",
			name = L["Right Panel"],
			disabled = function()
				return not E.db.WT.misc.gameBar.enable
			end,
			get = function(info)
				return E.db.WT.misc.gameBar.right[tonumber(info[#info])]
			end,
			set = function(info, value)
				E.db.WT.misc.gameBar.right[tonumber(info[#info])] = value
				GB:UpdateButtons()
			end,
			args = {},
		},
	},
}

do
	local availableButtons = GB:GetAvailableButtons()
	for i = 1, 7 do
		options.gameBar.args.leftButtons.args[tostring(i)] = {
			order = i,
			type = "select",
			name = format(L["Button #%d"], i),
			values = availableButtons,
		}

		options.gameBar.args.rightButtons.args[tostring(i)] = {
			order = i,
			type = "select",
			name = format(L["Button #%d"], i),
			values = availableButtons,
		}
	end

	options.gameBar.args.home.args.left = {
		order = 1,
		type = "select",
		name = L["Left Button"],
		width = "full",
		values = function()
			local result = {}
			for id, data in pairs(GB:GetHearthStoneTable()) do
				result[id] = F.GetIconString(data.icon, 14, 14) .. " " .. data.name
			end
			return result
		end,
	}

	options.gameBar.args.home.args.right = {
		order = 2,
		type = "select",
		name = L["Right Button"],
		width = "full",
		values = function()
			local result = {}
			for id, data in pairs(GB:GetHearthStoneTable()) do
				result[id] = F.GetIconString(data.icon, 14, 14) .. " " .. data.name
			end
			return result
		end,
	}
end

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
end

options.lfgList = {
	order = 8,
	type = "group",
	name = L["LFG List"],
	get = function(info)
		return E.private.WT.misc.lfgList[info[#info]]
	end,
	set = function(info, value)
		E.private.WT.misc.lfgList[info[#info]] = value
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
					name = function()
						if LL.StopRunning then
							return format(
								"|cffff3860" .. L["Because of %s, this module will not be loaded."] .. "|r",
								LL.StopRunning
							)
						else
							return L["QoLs for LFG list."]
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
		},
		icon = {
			order = 3,
			type = "group",
			name = L["Icon"],
			disabled = function()
				return not E.private.WT.misc.lfgList.enable
			end,
			get = function(info)
				return E.private.WT.misc.lfgList.icon[info[#info]]
			end,
			set = function(info, value)
				E.private.WT.misc.lfgList.icon[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				leader = {
					order = 2,
					type = "toggle",
					name = L["Leader"],
					desc = L["Add an indicator for the leader."],
				},
				reskin = {
					order = 3,
					type = "toggle",
					name = L["Reskin Icon"],
					desc = L["Change role icons."],
				},
				pack = {
					order = 4,
					type = "select",
					name = L["Style"],
					desc = L["Change the icons that indicate the role."],
					hidden = function()
						return not E.private.WT.misc.lfgList.icon.reskin
					end,
					values = {
						SPEC = L["Specialization"],
						SQUARE = L["Square"],
						HEXAGON = SampleStrings.hexagon,
						FFXIV = SampleStrings.ffxiv,
						SUNUI = SampleStrings.sunui,
						LYNUI = SampleStrings.lynui,
						ELVUI_OLD = SampleStrings.elvui_old,
						DEFAULT = SampleStrings.elvui,
					},
				},
				border = {
					order = 5,
					type = "toggle",
					name = L["Border"],
				},
				size = {
					order = 6,
					type = "range",
					name = L["Size"],
					min = 1,
					max = 20,
					step = 1,
				},
				alpha = {
					order = 7,
					type = "range",
					name = L["Alpha"],
					min = 0,
					max = 1,
					step = 0.01,
				},
				hideDefaultClassCircle = {
					order = 8,
					type = "toggle",
					name = L["Hide default class circles"],
					desc = L["Disable the default class-colored background circle in LFG Lists, leaving only the skinned icons from preferences"],
				},
			},
		},
		line = {
			order = 4,
			type = "group",
			name = L["Class Line"],
			disabled = function()
				return not E.private.WT.misc.lfgList.enable
			end,
			get = function(info)
				return E.private.WT.misc.lfgList.line[info[#info]]
			end,
			set = function(info, value)
				E.private.WT.misc.lfgList.line[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add a line in class color."],
				},
				tex = {
					order = 2,
					type = "select",
					name = L["Texture"],
					dialogControl = "LSM30_Statusbar",
					values = LSM:HashTable("statusbar"),
				},
				width = {
					order = 4,
					type = "range",
					name = L["Width"],
					min = 1,
					max = 20,
					step = 1,
				},
				height = {
					order = 4,
					type = "range",
					name = L["Height"],
					min = 1,
					max = 20,
					step = 1,
				},
				offsetX = {
					order = 5,
					type = "range",
					name = L["X-Offset"],
					min = -20,
					max = 20,
					step = 1,
				},
				offsetY = {
					order = 6,
					type = "range",
					name = L["Y-Offset"],
					min = -20,
					max = 20,
					step = 1,
				},
				alpha = {
					order = 7,
					type = "range",
					name = L["Alpha"],
					min = 0,
					max = 1,
					step = 0.01,
				},
			},
		},
		additionalText = {
			order = 5,
			type = "group",
			name = L["Additional Text"],
			disabled = function()
				return not E.private.WT.misc.lfgList.enable
			end,
			get = function(info)
				return E.private.WT.misc.lfgList.additionalText[info[#info]]
			end,
			set = function(info, value)
				E.private.WT.misc.lfgList.additionalText[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add some additional information into title or description."],
					width = "full",
				},
				target = {
					order = 2,
					type = "select",
					name = L["Target"],
					values = {
						TITLE = L["Title"],
						DESC = L["Description"],
					},
					width = 0.8,
				},
				shortenDescription = {
					order = 3,
					type = "toggle",
					name = L["Shorten Description"],
					desc = L["Remove useless part from description."],
					width = 1.5,
				},
				template = {
					order = 4,
					type = "input",
					name = L["Template"],
					desc = function()
						return format(
							"%s = %s\n%s = %s\n%s = %s",
							C.StringByTemplate("{{score}}", "primary"),
							L["Leader Score"],
							C.StringByTemplate("{{best}}", "primary"),
							L["Leader Best Run"],
							C.StringByTemplate("{{text}}", "primary"),
							L["Original Text"]
						)
					end,
					width = "full",
				},
			},
		},
		partyKeystone = {
			order = 6,
			type = "group",
			name = L["Party Keystone"],
			disabled = function()
				return not E.private.WT.misc.lfgList.enable
			end,
			get = function(info)
				return E.private.WT.misc.lfgList.partyKeystone[info[#info]]
			end,
			set = function(info, value)
				E.private.WT.misc.lfgList.partyKeystone[info[#info]] = value
				LL:UpdatePartyKeystoneFrame()
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add an additional frame to show party members' keystone."],
				},
				font = {
					order = 6,
					type = "group",
					name = L["Font Setting"],
					inline = true,
					get = function(info)
						return E.private.WT.misc.lfgList.partyKeystone[info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.WT.misc.lfgList.partyKeystone[info[#info - 1]][info[#info]] = value
						LL:UpdatePartyKeystoneFrame()
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
		rightPanel = {
			order = 7,
			type = "group",
			name = L["Right Panel"],
			disabled = function()
				return not E.private.WT.misc.lfgList.enable
			end,
			get = function(info)
				return E.private.WT.misc.lfgList.rightPanel[info[#info]]
			end,
			set = function(info, value)
				E.private.WT.misc.lfgList.rightPanel[info[#info]] = value
				LL:UpdateRightPanel()
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Add an additional frame to filter the groups."],
				},
				autoRefresh = {
					order = 2,
					type = "toggle",
					name = L["Auto Refresh"],
					desc = L["Automatically refresh the list after you changing the filter."],
				},
				automations = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Automation"],
					args = {
						autoJoin = {
							order = 3,
							type = "toggle",
							name = L["Auto Join"],
							desc = L["Automatically join the dungeon when clicking on the LFG row, without asking for role confirmation."],
						},
						skipConfirmation = {
							order = 4,
							type = "toggle",
							name = L["Skip Confirmation"],
							desc = L["Skip signup confirmation during automatic join on listing click"],
						},
					},
				},
				filtersBehaviour = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Filters"],
					args = {
						feature = {
							order = 1,
							type = "description",
							name = format(
								"%s\n|cffff0000%s|r\n\n%s\n%s",
								L["Automatic filters behaviour"],
								format(
									"!! - %s: %s - !!",
									L["WARNING"],
									L["Change this only if you know what you are doing"]
								),
								format(
									"- |cff00aaff%s|r: %s",
									L["Unchecked"],
									L["When selecting 'Has Tank' / 'Has Healer', the 'Role Available' filter is disabled automatically and vice-versa."]
								),
								format(
									"- |cff00aaff%s|r: %s",
									L["Checked"],
									L["No automatic removal of filters, might cause empty results if you already have the roles in your party."]
								)
							),
							fontSize = "medium",
						},
						disableSafeFilters = {
							order = 2,
							type = "toggle",
							name = L["Disable safe filters"],
							desc = L["Disable the default behaviour that prevents inconsistent filters with flags 'Has Tank', 'Has Healer' and 'Role Available'"],
						},
					},
				},
			},
		},
	},
}

options.spellActivationAlert = {
	order = 9,
	type = "group",
	name = L["Spell Activation Alert"],
	get = function(info)
		return E.db.WT.misc.spellActivationAlert[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.misc.spellActivationAlert[info[#info]] = value
		SA:Update()
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
					name = L["Spell activation alert frame customizations."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
		},
		visibility = {
			order = 3,
			type = "toggle",
			name = L["Visibility"],
			desc = L["Enable/Disable the spell activation alert frame."],
			get = function(info)
				return C_CVar_GetCVarBool("displaySpellActivationOverlays")
			end,
			set = function(info, value)
				C_CVar_SetCVar("displaySpellActivationOverlays", value and "1" or "0")
			end,
			disabled = function()
				return not E.db.WT.misc.spellActivationAlert.enable
			end,
		},
		opacity = {
			order = 4,
			type = "range",
			name = L["Opacity"],
			desc = L["Set the opacity of the spell activation alert frame. (Blizzard CVar)"],
			get = function(info)
				return tonumber(C_CVar_GetCVar("spellActivationOverlayOpacity"))
			end,
			set = function(info, value)
				C_CVar_SetCVar("spellActivationOverlayOpacity", value)
				SA:Update()
				SA:Preview()
			end,
			min = 0,
			max = 1,
			step = 0.01,
			disabled = function()
				return not E.db.WT.misc.spellActivationAlert.enable
			end,
		},
		scale = {
			order = 5,
			type = "range",
			name = L["Scale"],
			desc = L["Set the scale of the spell activation alert frame."],
			min = 0.1,
			max = 5,
			step = 0.01,
			disabled = function()
				return not E.db.WT.misc.spellActivationAlert.enable
			end,
			set = function(info, value)
				E.db.WT.misc.spellActivationAlert[info[#info]] = value
				SA:Update()
				SA:Preview()
			end,
		},
	},
}

options.cooldownTextOffset = {
	order = 10,
	type = "group",
	name = L["Cooldown Text Offset"],
	get = function(info)
		return E.db.WT.misc.cooldownTextOffset[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.misc.cooldownTextOffset[info[#info]] = value
		M:UpdateCooldownTextOffset()
	end,
	disabled = function()
		return not E.db.cooldown.enable
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
					name = L["Customize the ElvUI cooldown text offset."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
		},
		offsetX = {
			order = 3,
			type = "range",
			name = L["X-Offset"],
			min = -100,
			max = 100,
			step = 1,
			disabled = function()
				return not E.db.WT.misc.cooldownTextOffset.enable
			end,
		},
		offsetY = {
			order = 4,
			type = "range",
			name = L["Y-Offset"],
			min = -100,
			max = 100,
			step = 1,
			disabled = function()
				return not E.db.WT.misc.cooldownTextOffset.enable
			end,
		},
	},
}

local selected, fromHotKey, toHotKey = nil, nil, nil

options.keybindAlias = {
	order = 11,
	type = "group",
	name = L["Keybind Alias"],
	get = function(info)
		return E.db.WT.misc.keybindAlias[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.misc.keybindAlias[info[#info]] = value
		M:UpdateAllKeybindText()
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
					name = L["Custom hotkey alias for keybinding."],
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
		dropdown = {
			order = 3,
			type = "select",
			name = L["Active Aliases"],
			width = 1.5,
			values = function()
				local list = {}
				for k, v in pairs(E.db.WT.misc.keybindAlias.list) do
					list[k] = C.StringByTemplate(v, "primary") .. ": " .. k
				end
				return list
			end,
			get = function()
				return selected
			end,
			set = function(_, value)
				selected = value
			end,
			disabled = function()
				return not E.db.WT.misc.keybindAlias.enable
			end,
		},
		remove = {
			order = 4,
			type = "execute",
			name = L["Remove"],
			desc = L["Remove the selected alias."],
			func = function()
				if selected then
					E.db.WT.misc.keybindAlias.list[selected] = nil
					selected = nil
					M:UpdateAllKeybindText()
				end
			end,
			disabled = function()
				return not E.db.WT.misc.keybindAlias.enable
			end,
		},
		devide = {
			order = 5,
			type = "description",
			name = " ",
			width = "full",
		},
		hotKey = {
			order = 6,
			type = "keybinding",
			name = L["Hot Key"],
			desc = L["The hotkey you want to set alias for."],
			get = function()
				return fromHotKey
			end,
			set = function(_, value)
				fromHotKey = value
			end,
			disabled = function()
				return not E.db.WT.misc.keybindAlias.enable
			end,
		},
		alias = {
			order = 7,
			type = "input",
			name = L["Alias"],
			desc = L["The alias you want to set for the hotkey."],
			get = function()
				return toHotKey
			end,
			set = function(_, value)
				toHotKey = value
			end,
			disabled = function()
				return not E.db.WT.misc.keybindAlias.enable
			end,
		},
		addOrUpdate = {
			order = 8,
			type = "execute",
			name = L["Add / Update"],
			func = function()
				if fromHotKey and toHotKey then
					E.db.WT.misc.keybindAlias.list[fromHotKey] = toHotKey
					fromHotKey, toHotKey = nil, nil
					M:UpdateAllKeybindText()
				end
			end,
			disabled = function()
				return not E.db.WT.misc.keybindAlias.enable
			end,
		},
	},
}

options.exitPhaseDiving = {
	order = 12,
	type = "group",
	name = L["Exit Phase Diving"],
	get = function(info)
		return E.db.WT.misc.exitPhaseDiving[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.misc.exitPhaseDiving[info[#info]] = value
		M:UpdateExitPhaseDivingButton()
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
					name = L["Add a button to exit phase diving."]
						.. "\n"
						.. L["You can use ElvUI Mover to reposition it."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
		},
		width = {
			order = 3,
			type = "range",
			name = L["Width"],
			min = 5,
			max = 1000,
			step = 1,
			disabled = function()
				return not E.db.WT.misc.exitPhaseDiving.enable
			end,
		},
		height = {
			order = 4,
			type = "range",
			name = L["Height"],
			min = 5,
			max = 1000,
			step = 1,
			disabled = function()
				return not E.db.WT.misc.exitPhaseDiving.enable
			end,
		},
	},
}
