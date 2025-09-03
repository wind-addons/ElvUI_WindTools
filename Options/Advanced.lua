local W, F, E, L, V, P, G = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table, PrivateDB, ProfileDB, GlobalDB
local options = W.options.advanced.args
local C = W.Utilities.Color

local _G = _G
local format = format
local tostring = tostring
local type = type

local C_UI_Reload = C_UI.Reload

local function blue(string)
	if type(string) ~= "string" then
		string = tostring(string)
	end
	return F.CreateColorString(string, { r = 0.204, g = 0.596, b = 0.859 })
end

options.core = {
	order = 1,
	type = "group",
	name = L["Core"],
	args = {
		loginMessage = {
			order = 1,
			type = "toggle",
			name = L["Login Message"],
			desc = L["The message will be shown in chat when you first login."],
			get = function(info)
				return E.global.WT.core.loginMessage
			end,
			set = function(info, value)
				E.global.WT.core.loginMessage = value
			end,
		},
		changlogPopup = {
			order = 2,
			type = "toggle",
			name = L["Changelog Popup"],
			desc = L["Show the changelog popup rather than chat message after every update."],
			get = function(info)
				return E.global.WT.core.changlogPopup
			end,
			set = function(info, value)
				E.global.WT.core.changlogPopup = value
			end,
		},
		elvUIVersionPopup = {
			order = 3,
			type = "toggle",
			name = L["ElvUI Version Popup"],
			desc = L["Show the ElvUI version popup rather than chat message when ElvUI version is outdated."],
			get = function(info)
				return E.global.WT.core.elvUIVersionPopup
			end,
			set = function(info, value)
				E.global.WT.core.elvUIVersionPopup = value
			end,
		},
		compatibilityCheck = {
			order = 4,
			type = "toggle",
			name = L["Compatibility Check"],
			desc = L["Help you to enable/disable the modules for a better experience with other plugins."],
			get = function(info)
				return E.global.WT.core.compatibilityCheck
			end,
			set = function(info, value)
				E.global.WT.core.compatibilityCheck = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
	},
}

options.gameFix = {
	order = 2,
	type = "group",
	name = L["Game Fix"],
	args = {
		cvarAlert = {
			order = 1,
			type = "toggle",
			name = L["CVar Alert"],
			desc = format(
				L["It will alert you to reload UI when you change the CVar %s."],
				"|cff209ceeActionButtonUseKeyDown|r"
			),
			get = function(info)
				return E.global.WT.core.cvarAlert
			end,
			set = function(info, value)
				E.global.WT.core.cvarAlert = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			width = "full",
		},
		advancedCLEUEventTrace = {
			order = 2,
			type = "toggle",
			name = L["Advanced CLEU Event Trace"],
			desc = L["Enhanced Combat Log Events in /etrace frame."],
			get = function(info)
				return E.global.WT.core.advancedCLEUEventTrace
			end,
			set = function(info, value)
				E.global.WT.core.advancedCLEUEventTrace = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			width = "full",
		},
	},
}

options.developer = {
	order = 3,
	type = "group",
	name = L["Developer"],
	args = {
		logLevel = {
			order = 1,
			type = "select",
			name = L["Log Level"],
			desc = L["Only display log message that the level is higher than you choose."]
				.. "\n|cffff3860"
				.. L["Set to 2 if you do not understand the meaning of log level."]
				.. "|r",
			get = function(info)
				return E.global.WT.developer.logLevel
			end,
			set = function(info, value)
				E.global.WT.developer.logLevel = value
			end,
			values = {
				[1] = "1 - |cffff3860[ERROR]|r",
				[2] = "2 - |cffffdd57[WARNING]|r",
				[3] = "3 - |cff209cee[INFO]|r",
				[4] = "4 - |cff00d1b2[DEBUG]|r",
			},
		},
		tableAttributeDisplay = {
			order = 2,
			type = "group",
			name = L["Table Attribute Display"],
			inline = true,
			get = function(info)
				return E.global.WT.developer.tableAttributeDisplay[info[#info]]
			end,
			set = function(info, value)
				E.global.WT.developer.tableAttributeDisplay[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				desc = {
					order = 1,
					type = "description",
					name = L["Modify the debug tool that displays table attributes."],
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
					min = 0,
					max = 2000,
					step = 10,
				},
				height = {
					order = 4,
					type = "range",
					name = L["Height"],
					min = 0,
					max = 2000,
					step = 10,
				},
			},
		},
	},
}

-- Reset
E.PopupDialogs.WINDTOOLS_RESET_MODULE = {
	text = L["Are you sure you want to reset %s module?"],
	button1 = _G.ACCEPT,
	button2 = _G.CANCEL,
	OnAccept = function(_, func)
		func()
		C_UI_Reload()
	end,
	whileDead = 1,
	hideOnEscape = true,
}

E.PopupDialogs.WINDTOOLS_RESET_ALL_MODULES = {
	text = format(L["Reset all %s modules."], W.Title),
	button1 = _G.ACCEPT,
	button2 = _G.CANCEL,
	OnAccept = function()
		E.db.WT = P
		E.private.WT = V
		C_UI_Reload()
	end,
	whileDead = 1,
	hideOnEscape = true,
}

E.PopupDialogs.WINDTOOLS_IMPORT_SETTING = {
	text = format("%s\n%s", L["Are you sure you want to import the profile?"], E.InfoColor .. L["[ %s by %s ]"]),
	button1 = _G.ACCEPT,
	button2 = _G.CANCEL,
	OnAccept = function(_, UISetName)
		if UISetName then
			W[UISetName .. "Profile"]()
			W[UISetName .. "Private"]()
		end
	end,
	whileDead = 1,
	hideOnEscape = true,
}

options.reset = {
	order = 4,
	type = "group",
	name = L["Reset"],
	args = {
		announcement = {
			order = 1,
			type = "group",
			inline = true,
			name = blue(L["Announcement"]),
			args = {
				combatResurrection = {
					order = 1,
					type = "execute",
					name = L["Combat Resurrection"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Combat Resurrection"], nil, function()
							E.db.WT.announcement.combatResurrection = P.announcement.combatResurrection
						end)
					end,
				},
				goodbye = {
					order = 2,
					type = "execute",
					name = L["Goodbye"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Goodbye"], nil, function()
							E.db.WT.announcement.goodbye = P.announcement.goodbye
						end)
					end,
				},
				interrupt = {
					order = 3,
					type = "execute",
					name = L["Interrupt"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Interrupt"], nil, function()
							E.db.WT.announcement.interrupt = P.announcement.interrupt
						end)
					end,
				},
				quest = {
					order = 4,
					type = "execute",
					name = L["Quest"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Quest"], nil, function()
							E.db.WT.announcement.quest = P.announcement.quest
						end)
					end,
				},
				resetInstance = {
					order = 4,
					type = "execute",
					name = L["Reset Instance"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Reset Instance"], nil, function()
							E.db.WT.announcement.resetInstance = P.announcement.resetInstance
						end)
					end,
				},
				taunt = {
					order = 5,
					type = "execute",
					name = L["Taunt"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Taunt"], nil, function()
							E.db.WT.announcement.taunt = P.announcement.taunt
						end)
					end,
				},
				thanks = {
					order = 6,
					type = "execute",
					name = L["Thanks"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Thanks"], nil, function()
							E.db.WT.announcement.thanks = P.announcement.thanks
						end)
					end,
				},
				threatTransfer = {
					order = 7,
					type = "execute",
					name = L["Threat Transfer"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Threat Transfer"], nil, function()
							E.db.WT.announcement.threatTransfer = P.announcement.threatTransfer
						end)
					end,
				},
				utility = {
					order = 8,
					type = "execute",
					name = L["Utility"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Utility"], nil, function()
							E.db.WT.announcement.utility = P.announcement.utility
						end)
					end,
				},
			},
		},
		combat = {
			order = 2,
			type = "group",
			inline = true,
			name = blue(L["Combat"]),
			args = {
				combatAlert = {
					order = 1,
					type = "execute",
					name = L["Combat Alert"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Combat Alert"], nil, function()
							E.db.WT.combat.combatAlert = P.combat.combatAlert
						end)
					end,
				},
				raidMarkers = {
					order = 2,
					type = "execute",
					name = L["Raid Markers"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Raid Markers"], nil, function()
							E.db.WT.combat.raidMarkers = P.combat.raidMarkers
						end)
					end,
				},
				quickKeystone = {
					order = 3,
					type = "execute",
					name = L["Quick Keystone"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Quick Keystone"], nil, function()
							E.db.WT.combat.quickKeystone = P.combat.quickKeystone
						end)
					end,
				},
				classHelper = {
					order = 4,
					type = "execute",
					name = L["Class Helper"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Class Helper"], nil, function()
							E.db.WT.combat.classHelper = P.combat.classHelper
						end)
					end,
				},
			},
		},
		item = {
			order = 3,
			type = "group",
			inline = true,
			name = blue(L["Item"]),
			args = {
				extraItemsBar = {
					order = 1,
					type = "execute",
					name = L["Extra Items Bar"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Extra Items Bar"], nil, function()
							E.db.WT.item.extraItemsBar = P.item.extraItemsBar
						end)
					end,
				},
				delete = {
					order = 2,
					type = "execute",
					name = L["Delete Item"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Delete Item"], nil, function()
							E.db.WT.item.delete = P.item.delete
						end)
					end,
				},
				alreadyKnown = {
					order = 3,
					type = "execute",
					name = L["Already Known"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Already Known"], nil, function()
							E.db.WT.item.alreadyKnown = P.item.alreadyKnown
						end)
					end,
				},
				fastLoot = {
					order = 4,
					type = "execute",
					name = L["Fast Loot"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Fast Loot"], nil, function()
							E.db.WT.item.fastLoot = P.item.fastLoot
						end)
					end,
				},
				trade = {
					order = 5,
					type = "execute",
					name = L["Trade"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Trade"], nil, function()
							E.db.WT.item.trade = P.item.trade
						end)
					end,
				},
				contacts = {
					order = 6,
					type = "execute",
					name = L["Contacts"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Contacts"], nil, function()
							E.db.WT.item.contacts = P.item.contacts
							E.global.WT.item.contacts = G.item.contacts
						end)
					end,
				},
				inspect = {
					order = 7,
					type = "execute",
					name = L["Inspect"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Inspect"], nil, function()
							E.db.WT.item.inspect = P.item.inspect
						end)
					end,
				},
				itemLevel = {
					order = 8,
					type = "execute",
					name = L["Item Level"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Item Level"], nil, function()
							E.db.WT.item.itemLevel = P.item.itemLevel
						end)
					end,
				},
				extendMerchantPages = {
					order = 9,
					type = "execute",
					name = L["Extend Merchant Pages"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Extend Merchant Pages"], nil, function()
							E.private.WT.item.extendMerchantPages = V.item.extendMerchantPages
						end)
					end,
				},
			},
		},
		maps = {
			order = 4,
			type = "group",
			inline = true,
			name = blue(L["Maps"]),
			args = {
				superTracker = {
					order = 1,
					type = "execute",
					name = L["Super Tracker"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Super Tracker"], nil, function()
							E.private.WT.maps.superTracker = V.maps.superTracker
						end)
					end,
				},
				whoClicked = {
					order = 2,
					type = "execute",
					name = L["Who Clicked Minimap"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Who Clicked Minimap"], nil, function()
							E.db.WT.maps.whoClicked = P.maps.whoClicked
						end)
					end,
				},
				rectangleMinimap = {
					order = 3,
					type = "execute",
					name = L["Rectangle Minimap"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Rectangle Minimap"], nil, function()
							E.db.WT.maps.rectangleMinimap = P.maps.rectangleMinimap
						end)
					end,
				},
				minimapButtons = {
					order = 4,
					type = "execute",
					name = L["Minimap Buttons"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Minimap Buttons"], nil, function()
							E.private.WT.maps.minimapButtons = V.maps.minimapButtons
						end)
					end,
				},
				worldMap = {
					order = 5,
					type = "execute",
					name = L["World Map"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["World Map"], nil, function()
							E.private.WT.maps.worldMap = V.maps.worldMap
						end)
					end,
				},
				instanceDifficulty = {
					order = 6,
					type = "execute",
					name = L["Instance Difficulty"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Super Tracker"], nil, function()
							E.private.WT.maps.instanceDifficulty = V.maps.instanceDifficulty
						end)
					end,
				},
				eventTracker = {
					order = 7,
					type = "execute",
					name = L["Event Tracker"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Event Tracker"], nil, function()
							E.db.WT.maps.eventTracker = P.maps.eventTracker
						end)
					end,
				},
			},
		},
		quest = {
			order = 5,
			type = "group",
			inline = true,
			name = blue(L["Quest"]),
			args = {
				objectiveTracker = {
					order = 1,
					type = "execute",
					name = L["Objective Tracker"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Objective Tracker"], nil, function()
							E.private.WT.quest.objectiveTracker = V.quest.objectiveTracker
						end)
					end,
				},
				switchButtons = {
					order = 2,
					type = "execute",
					name = L["Switch Buttons"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Switch Buttons"], nil, function()
							E.db.WT.quest.switchButtons = P.quest.switchButtons
						end)
					end,
				},
				turnIn = {
					order = 3,
					type = "execute",
					name = L["Turn In"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Turn In"], nil, function()
							E.db.WT.quest.turnIn = P.quest.turnIn
						end)
					end,
				},
			},
		},
		social = {
			order = 6,
			type = "group",
			inline = true,
			name = blue(L["Social"]),
			args = {
				chatBar = {
					order = 1,
					type = "execute",
					name = L["Chat Bar"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Chat Bar"], nil, function()
							E.db.WT.social.chatBar = P.social.chatBar
						end)
					end,
				},
				chatLink = {
					order = 2,
					type = "execute",
					name = L["Chat Link"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Chat Link"], nil, function()
							E.db.WT.social.chatLink = P.social.chatLink
						end)
					end,
				},
				chatText = {
					order = 3,
					type = "execute",
					name = L["Chat Text"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Chat Text"], nil, function()
							E.db.WT.social.chatText = P.social.chatText
						end)
					end,
				},
				contextMenu = {
					order = 4,
					type = "execute",
					name = L["Context Menu"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Context Menu"], nil, function()
							E.db.WT.social.contextMenu = P.social.contextMenu
						end)
					end,
				},
				emote = {
					order = 5,
					type = "execute",
					name = L["Emote"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Emote"], nil, function()
							E.db.WT.social.emote = P.social.emote
						end)
					end,
				},
				friendList = {
					order = 6,
					type = "execute",
					name = L["Friend List"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Friend List"], nil, function()
							E.db.WT.social.friendList = P.social.friendList
						end)
					end,
				},
				smartTab = {
					order = 7,
					type = "execute",
					name = L["Smart Tab"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Smart Tab"], nil, function()
							E.db.WT.social.smartTab = P.social.smartTab
						end)
					end,
				},
			},
		},
		tooltips = {
			order = 7,
			type = "group",
			inline = true,
			name = blue(L["Tooltips"]),
			args = {
				general = {
					order = 1,
					type = "execute",
					name = L["General"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["General"], nil, function()
							E.private.WT.tooltips.modifier = V.tooltips.modifier
							E.private.WT.tooltips.titleIcon = V.tooltips.titleIcon
							E.private.WT.tooltips.factionIcon = V.tooltips.factionIcon
							E.private.WT.tooltips.petIcon = V.tooltips.petIcon
							E.private.WT.tooltips.petId = V.tooltips.petId
							E.private.WT.tooltips.tierSet = V.tooltips.tierSet
						end)
					end,
				},
				elvUITweaks = {
					order = 2,
					type = "execute",
					name = L["ElvUI Tooltip Tweaks"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["ElvUI Tooltip Tweaks"], nil, function()
							E.db.WT.tooltips.elvUITweaks = P.tooltips.elvUITweaks
						end)
					end,
				},
				progression = {
					order = 3,
					type = "execute",
					name = L["Progression"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Progression"], nil, function()
							E.private.WT.tooltips.progression = V.tooltips.progression
						end)
					end,
				},
				keystone = {
					order = 4,
					type = "execute",
					name = L["Keystone"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Keystone"], nil, function()
							E.db.WT.tooltips.keystone = P.tooltips.keystone
						end)
					end,
				},
				groupInfo = {
					order = 5,
					type = "execute",
					name = L["Group Info"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Group Info"], nil, function()
							E.db.WT.tooltips.groupInfo = P.tooltips.groupInfo
						end)
					end,
				},
				objectiveProgress = {
					order = 6,
					type = "execute",
					name = L["Objective Progress"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Objective Progress"], nil, function()
							E.private.WT.tooltips.objectiveProgress = V.tooltips.objectiveProgress
						end)
					end,
				},
			},
		},
		unitFrames = {
			order = 8,
			type = "group",
			inline = true,
			name = blue(L["UnitFrames"]),
			args = {
				quickFocus = {
					order = 1,
					type = "execute",
					name = L["Quick Focus"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Quick Focus"], nil, function()
							E.private.WT.unitFrames.quickFocus = V.unitFrames.quickFocus
						end)
					end,
				},
				absorb = {
					order = 2,
					type = "execute",
					name = L["Absorb"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Absorb"], nil, function()
							E.db.WT.unitFrames.absorb = P.unitFrames.absorb
						end)
					end,
				},
				roleIcon = {
					order = 3,
					type = "execute",
					name = L["Role Icon"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Role Icon"], nil, function()
							E.private.WT.unitFrames.roleIcon = V.unitFrames.roleIcon
						end)
					end,
				},
			},
		},
		skins = {
			order = 9,
			type = "group",
			inline = true,
			name = blue(L["Skins"]),
			args = {
				general = {
					order = 1,
					type = "execute",
					name = L["General"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["General"], nil, function()
							E.private.WT.skins.enable = V.skins.enable
							E.private.WT.skins.windtools = V.skins.windtools
							E.private.WT.skins.removeParchment = V.skins.removeParchment
							E.private.WT.skins.merathilisUISkin = V.skins.merathilisUISkin
							E.private.WT.skins.shadow = V.skins.shadow
							E.private.WT.skins.increasedSize = V.skins.increasedSize
							E.private.WT.skins.color = V.skins.color
						end)
					end,
				},
				font = {
					order = 2,
					type = "execute",
					name = L["Font"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Font"], nil, function()
							E.private.WT.skins.ime = V.skins.ime
							E.private.WT.skins.errorMessage = V.skins.errorMessage
						end)
					end,
				},
				blizzard = {
					order = 3,
					type = "execute",
					name = L["Blizzard"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Blizzard"], nil, function()
							E.private.WT.skins.blizzard = V.skins.blizzard
						end)
					end,
				},
				elvui = {
					order = 4,
					type = "execute",
					name = L["ElvUI"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["ElvUI"], nil, function()
							E.private.WT.skins.elvui = V.skins.elvui
						end)
					end,
				},
				addons = {
					order = 5,
					type = "execute",
					name = L["Addons"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Addons"], nil, function()
							E.private.WT.skins.addons = V.skins.addons
						end)
					end,
				},
				widgets = {
					order = 6,
					type = "execute",
					name = L["Widgets"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Widgets"], nil, function()
							E.private.WT.skins.widgets = V.skins.widgets
						end)
					end,
				},
				bigWigsSkin = {
					order = 7,
					type = "execute",
					name = L["BigWigs Skin"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["BigWigs Skin"], nil, function()
							E.private.WT.skins.bigWigsSkin = V.skins.bigWigsSkin
						end)
					end,
				},
			},
		},
		misc = {
			order = 10,
			type = "group",
			inline = true,
			name = blue(L["Misc"]),
			args = {
				general = {
					order = 1,
					type = "execute",
					name = L["General"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["General"], nil, function()
							E.private.WT.misc.autoScreenshot = V.misc.autoScreenshot
							E.private.WT.misc.moveSpeed = V.misc.moveSpeed
							E.private.WT.misc.noKanjiMath = V.misc.noKanjiMath
							E.private.WT.misc.pauseToSlash = V.misc.pauseToSlash
							E.private.WT.misc.skipCutScene = V.misc.skipCutScene
							E.private.WT.misc.onlyStopWatched = V.misc.onlyStopWatched
							E.private.WT.misc.keybindTextAbove = V.misc.keybindTextAbove
							E.private.WT.misc.guildNewsItemLevel = V.misc.guildNewsItemLevel
							E.private.WT.misc.addCNFilter = V.misc.addCNFilter
							E.private.WT.misc.autoToggleChatBubble = V.misc.autoToggleChatBubble
							E.db.WT.misc.disableTalkingHead = P.misc.disableTalkingHead
							E.db.WT.misc.hideCrafter = P.misc.hideCrafter
							E.db.WT.misc.noLootPanel = P.misc.noLootPanel
							E.db.WT.misc.reshiiWrapsUpgrade = P.misc.reshiiWrapsUpgrade
						end)
					end,
				},
				moveFrames = {
					order = 2,
					type = "execute",
					name = L["Move Frames"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Move Frames"], nil, function()
							E.private.WT.misc.moveFrames = V.misc.moveFrames
						end)
					end,
				},
				mute = {
					order = 3,
					type = "execute",
					name = L["Mute"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Mute"], nil, function()
							E.private.WT.misc.mute = V.misc.mute
						end)
					end,
				},
				tags = {
					order = 4,
					type = "execute",
					name = L["Tags"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Tags"], nil, function()
							E.private.WT.misc.tags = V.misc.tags
						end)
					end,
				},
				gameBar = {
					order = 5,
					type = "execute",
					name = L["Game Bar"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Game Bar"], nil, function()
							E.db.WT.misc.gameBar = P.misc.gameBar
						end)
					end,
				},
				lfgList = {
					order = 6,
					type = "execute",
					name = L["LFG List"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["LFG List"], nil, function()
							E.private.WT.misc.lfgList = V.misc.lfgList
						end)
					end,
				},
				automation = {
					order = 7,
					type = "execute",
					name = L["Automation"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Automation"], nil, function()
							E.db.WT.misc.automation = P.misc.automation
						end)
					end,
				},
				spellActivationAlert = {
					order = 8,
					type = "execute",
					name = L["Spell Activation Alert"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Spell Activation Alert"], nil, function()
							E.db.WT.misc.spellActivationAlert = P.misc.spellActivationAlert
						end)
					end,
				},
				watchedCutscene = {
					order = 9,
					type = "execute",
					name = L["Watched Cutscene"],
					desc = L["Reset the watched cutscene history (which has been used in auto skipping)."],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Watched Cutscene"], nil, function()
							E.global.WT.misc.watched.movies = {}
						end)
					end,
				},
				exitPhaseDiving = {
					order = 10,
					type = "execute",
					name = L["Exit Phase Diving"],
					func = function()
						E:StaticPopup_Show("WINDTOOLS_RESET_MODULE", L["Exit Phase Diving"], nil, function()
							E.db.WT.misc.exitPhaseDiving = P.misc.exitPhaseDiving
						end)
					end,
				},
			},
		},
		resetAllModules = {
			order = 12,
			type = "execute",
			name = L["Reset All Modules"],
			func = function()
				E:StaticPopup_Show("WINDTOOLS_RESET_ALL_MODULES")
			end,
			width = "full",
		},
	},
}

do
	local text = ""

	E.PopupDialogs.WINDTOOLS_IMPORT_STRING = {
		text = format(
			"%s\n|cffff3860%s|r",
			L["Are you sure you want to import this string?"],
			format(L["It will override your %s setting."], W.Title)
		),
		button1 = _G.ACCEPT,
		button2 = _G.CANCEL,
		OnAccept = function()
			F.Profiles.ImportByString(text)
			C_UI_Reload()
		end,
		whileDead = 1,
		hideOnEscape = true,
	}

	options.profiles = {
		order = 5,
		type = "group",
		name = L["Profiles"],
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
						name = format(L["Import and export your %s settings."], W.Title),
						fontSize = "medium",
					},
				},
			},
			textArea = {
				order = 2,
				type = "group",
				inline = true,
				name = format("%s %s", W.Title, L["String"]),
				args = {
					text = {
						order = 1,
						type = "input",
						name = " ",
						multiline = 15,
						width = "full",
						get = function()
							return text
						end,
						set = function(_, value)
							text = value
						end,
					},
					importButton = {
						order = 2,
						type = "execute",
						name = L["Import"],
						func = function()
							if text ~= "" then
								E:StaticPopup_Show("WINDTOOLS_IMPORT_STRING")
							end
						end,
					},
					exportAllButton = {
						order = 3,
						type = "execute",
						name = L["Export All"],
						desc = format(L["Export all setting of %s."], W.Title),
						func = function()
							text = F.Profiles.GetOutputString(true, true)
						end,
					},
					exportProfileButton = {
						order = 4,
						type = "execute",
						name = L["Export Profile"],
						desc = format(L["Export the setting of %s that stored in ElvUI Profile database."], W.Title),
						func = function()
							text = F.Profiles.GetOutputString(true, false)
						end,
					},
					exportPrivateButton = {
						order = 5,
						type = "execute",
						name = L["Export Private"],
						desc = format(L["Export the setting of %s that stored in ElvUI Private database."], W.Title),
						func = function()
							text = F.Profiles.GetOutputString(false, true)
						end,
					},
					betterAlign = {
						order = 6,
						type = "description",
						fontSize = "small",
						name = " ",
						width = "full",
					},
					tip = {
						order = 6,
						type = "description",
						name = format(
							"%s\n%s\n%s\n%s\n%s",
							C.StringByTemplate(L["I want to sync setting of WindTools!"], "info"),
							L["WindTools saves all data in ElvUI Profile and Private database."],
							L["So if you set ElvUI Profile and Private these |cffff0000TWO|r databases to the same across multiple character, the setting of WindTools will be synced."],
							L["Sharing ElvUI Profile is a very common thing nowadays, but actually ElvUI Private database is also exist for saving configuration of General, Skins, etc."],
							L["Check the setting of ElvUI Private database in ElvUI Options -> Profiles -> Private (tab)."]
						),
						width = "full",
					},
				},
			},
		},
	}
end
