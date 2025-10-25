local W, F, E, L, V, P, G = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable, PrivateDB, ProfileDB, GlobalDB
local C = W.Utilities.Color
local options = W.options.quest.args
local LSM = E.Libs.LSM
local TI = W:GetModule("TurnIn")
local SB = W:GetModule("SwitchButtons")
local OT = W:GetModule("ObjectiveTracker")
local QP = W:GetModule("QuestProgress")

local format = format
local pairs = pairs
local tonumber = tonumber
local tostring = tostring

local C_QuestLog_SortQuestWatches = C_QuestLog.SortQuestWatches

local customListSelected

local function ImportantColorString(s)
	return C.StringByTemplate(s, "blue-400")
end

local function FormatDesc(code, helpText)
	return ImportantColorString(code) .. " = " .. helpText
end

options.objectiveTracker = {
	order = 1,
	type = "group",
	name = L["Objective Tracker"],
	get = function(info)
		return E.private.WT.quest.objectiveTracker[info[#info]]
	end,
	set = function(info, value)
		E.private.WT.quest.objectiveTracker[info[#info]] = value
		C_QuestLog_SortQuestWatches()
	end,
	args = {
		desc = {
			order = 0,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				feature_1 = {
					order = 1,
					type = "description",
					name = L["1. Customize the font of Objective Tracker."],
					fontSize = "medium",
				},
				feature_2 = {
					order = 2,
					type = "description",
					name = L["2. Add colorful progress text to the quest."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.private.WT.quest.objectiveTracker[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		warning = {
			order = 2,
			type = "description",
			name = C.StringByTemplate(
				L["This module may prevent clicking quest items in the objective tracker due to taint."],
				"rose-500"
			),
		},
		progress = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Progress"],
			disabled = function()
				return not E.private.WT.quest.objectiveTracker.enable
			end,
			args = {
				noDash = {
					order = 1,
					type = "toggle",
					disabled = function()
						return not E.private.WT.quest.objectiveTracker.enable
					end,
					name = L["No Dash"],
				},
				colorfulProgress = {
					order = 2,
					type = "toggle",
					name = L["Colorful Progress"],
				},
				percentage = {
					order = 3,
					type = "toggle",
					name = L["Percentage"],
					desc = L["Add percentage text after quest text."],
				},
				colorfulPercentage = {
					order = 4,
					type = "toggle",
					name = L["Colorful Percentage"],
					desc = L["Make the additional percentage text be colored."],
				},
			},
		},
		cosmeticBar = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Cosmetic Bar"],
			disabled = function()
				return not E.private.WT.quest.objectiveTracker.enable
			end,
			get = function(info)
				return E.private.WT.quest.objectiveTracker.cosmeticBar[info[#info]]
			end,
			set = function(info, value)
				E.private.WT.quest.objectiveTracker.cosmeticBar[info[#info]] = value
				OT:RefreshAllCosmeticBars()
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				style = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Style"],
					disabled = function()
						return not E.private.WT.quest.objectiveTracker.enable
							or not E.private.WT.quest.objectiveTracker.cosmeticBar.enable
					end,
					args = {
						texture = {
							order = 1,
							type = "select",
							name = L["Texture"],
							dialogControl = "LSM30_Statusbar",
							values = LSM:HashTable("statusbar"),
						},
						border = {
							order = 2,
							type = "select",
							name = L["Border"],
							values = {
								NONE = L["None"],
								ONEPIXEL = L["One Pixel"],
								SHADOW = L["Shadow"],
							},
						},
						borderAlpha = {
							order = 3,
							type = "range",
							name = L["Border Alpha"],
							min = 0,
							max = 1,
							step = 0.01,
						},
					},
				},
				position = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Position"],
					disabled = function()
						return not E.private.WT.quest.objectiveTracker.enable
							or not E.private.WT.quest.objectiveTracker.cosmeticBar.enable
					end,
					args = {
						widthMode = {
							order = 1,
							type = "select",
							name = L["Width Mode"],
							desc = L["'Absolute' mode means the width of the bar is fixed."]
								.. "\n"
								.. L["'Dynamic' mode will also add the width of header text."],
							values = {
								ABSOLUTE = L["Absolute"],
								DYNAMIC = L["Dyanamic"],
							},
						},
						width = {
							order = 2,
							type = "range",
							name = L["Width"],
							min = -200,
							max = 300,
							step = 1,
						},
						heightMode = {
							order = 3,
							type = "select",
							name = L["Height Mode"],
							desc = L["'Absolute' mode means the height of the bar is fixed."]
								.. "\n"
								.. L["'Dynamic' mode will also add the height of header text."],
							values = {
								ABSOLUTE = L["Absolute"],
								DYNAMIC = L["Dyanamic"],
							},
						},
						height = {
							order = 4,
							type = "range",
							name = L["Height"],
							min = -200,
							max = 300,
							step = 1,
						},
						offsetX = {
							order = 5,
							type = "range",
							name = L["X-Offset"],
							min = -500,
							max = 500,
							step = 1,
						},
						offsetY = {
							order = 6,
							type = "range",
							name = L["Y-Offset"],
							min = -500,
							max = 500,
							step = 1,
						},
					},
				},
				color = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Color"],
					disabled = function()
						return not E.private.WT.quest.objectiveTracker.enable
							or not E.private.WT.quest.objectiveTracker.cosmeticBar.enable
					end,
					get = function(info)
						return E.private.WT.quest.objectiveTracker.cosmeticBar.color[info[#info]]
					end,
					set = function(info, value)
						E.private.WT.quest.objectiveTracker.cosmeticBar.color[info[#info]] = value
						OT:RefreshAllCosmeticBars()
					end,
					args = {
						mode = {
							order = 1,
							type = "select",
							name = L["Color Mode"],
							values = {
								GRADIENT = L["Gradient"],
								NORMAL = L["Normal"],
								CLASS = L["Class Color"],
							},
						},
						normalColor = {
							order = 2,
							type = "color",
							name = L["Normal Color"],
							hasAlpha = true,
							hidden = function()
								if E.private.WT.quest.objectiveTracker.cosmeticBar.color.mode ~= "NORMAL" then
									return true
								end
							end,
							get = function(info)
								local db = E.private.WT.quest.objectiveTracker.cosmeticBar.color.normalColor
								local default = V.quest.objectiveTracker.cosmeticBar.color.normalColor
								return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
							end,
							set = function(info, r, g, b, a)
								local db = E.private.WT.quest.objectiveTracker.cosmeticBar.color.normalColor
								db.r, db.g, db.b, db.a = r, g, b, a
								OT:RefreshAllCosmeticBars()
							end,
						},
						gradientColor1 = {
							order = 3,
							type = "color",
							name = L["Gradient Color 1"],
							hasAlpha = true,
							hidden = function()
								if E.private.WT.quest.objectiveTracker.cosmeticBar.color.mode ~= "GRADIENT" then
									return true
								end
							end,
							get = function(info)
								local db = E.private.WT.quest.objectiveTracker.cosmeticBar.color.gradientColor1
								local default = V.quest.objectiveTracker.cosmeticBar.color.gradientColor1
								return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
							end,
							set = function(info, r, g, b, a)
								local db = E.private.WT.quest.objectiveTracker.cosmeticBar.color.gradientColor1
								db.r, db.g, db.b, db.a = r, g, b, a
								OT:RefreshAllCosmeticBars()
							end,
						},
						gradientColor2 = {
							order = 4,
							type = "color",
							name = L["Gradient Color 2"],
							hasAlpha = true,
							hidden = function()
								if E.private.WT.quest.objectiveTracker.cosmeticBar.color.mode ~= "GRADIENT" then
									return true
								end
							end,
							get = function(info)
								local db = E.private.WT.quest.objectiveTracker.cosmeticBar.color.gradientColor2
								local default = V.quest.objectiveTracker.cosmeticBar.color.gradientColor2
								return db.r, db.g, db.b, db.a, default.r, default.g, default.b, default.a
							end,
							set = function(info, r, g, b, a)
								local db = E.private.WT.quest.objectiveTracker.cosmeticBar.color.gradientColor2
								db.r, db.g, db.b, db.a = r, g, b, a
								OT:RefreshAllCosmeticBars()
							end,
						},
					},
				},
				preset = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Presets"],
					disabled = function()
						return not E.private.WT.quest.objectiveTracker.enable
							or not E.private.WT.quest.objectiveTracker.cosmeticBar.enable
					end,
					args = {
						tip = {
							order = 1,
							type = "description",
							name = L["Here are some example presets, just try them!"],
						},
						default = {
							order = 2,
							type = "execute",
							name = L["Default"],
							func = function()
								local db = E.private.WT.quest.objectiveTracker
								db.header.style = "OUTLINE"
								db.header.color = { r = 1, g = 1, b = 1 }
								db.header.size = E.db.general.fontSize + 2
								db.cosmeticBar.texture = "WindTools Glow"
								db.cosmeticBar.widthMode = "ABSOLUTE"
								db.cosmeticBar.heightMode = "ABSOLUTE"
								db.cosmeticBar.width = 212
								db.cosmeticBar.height = 2
								db.cosmeticBar.offsetX = 0
								db.cosmeticBar.offsetY = -13
								db.cosmeticBar.border = "SHADOW"
								db.cosmeticBar.borderAlpha = 1
								db.cosmeticBar.color.mode = "GRADIENT"
								db.cosmeticBar.color.normalColor = { r = 0.000, g = 0.659, b = 1.000, a = 1 }
								db.cosmeticBar.color.gradientColor1 = { r = 0.32941, g = 0.52157, b = 0.93333, a = 1 }
								db.cosmeticBar.color.gradientColor2 = { r = 0.25882, g = 0.84314, b = 0.86667, a = 1 }
								OT:RefreshAllCosmeticBars()
							end,
						},
						preset1 = {
							order = 3,
							type = "execute",
							name = format(L["Preset %d"], 1),
							func = function()
								local db = E.private.WT.quest.objectiveTracker
								db.header.style = "NONE"
								db.header.color = { r = 1, g = 1, b = 1 }
								db.header.size = E.db.general.fontSize
								db.cosmeticBar.texture = "ElvUI Blank"
								db.cosmeticBar.widthMode = "DYNAMIC"
								db.cosmeticBar.heightMode = "DYNAMIC"
								db.cosmeticBar.width = 45
								db.cosmeticBar.height = 16
								db.cosmeticBar.offsetX = -10
								db.cosmeticBar.offsetY = 0
								db.cosmeticBar.border = "NONE"
								db.cosmeticBar.borderAlpha = 1
								db.cosmeticBar.color.mode = "GRADIENT"
								db.cosmeticBar.color.normalColor = { r = 0.000, g = 0.659, b = 1.000, a = 1 }
								db.cosmeticBar.color.gradientColor1 = { r = 0.32941, g = 0.52157, b = 0.93333, a = 1 }
								db.cosmeticBar.color.gradientColor2 = { r = 0.25882, g = 0.84314, b = 0.86667, a = 0 }
								OT:RefreshAllCosmeticBars()
							end,
						},
						preset2 = {
							order = 4,
							type = "execute",
							name = format(L["Preset %d"], 2),
							func = function()
								local db = E.private.WT.quest.objectiveTracker
								db.header.style = "NONE"
								db.header.size = E.db.general.fontSize - 2
								db.header.color = { r = 1, g = 1, b = 1 }
								db.cosmeticBar.texture = "ElvUI Blank"
								db.cosmeticBar.widthMode = "DYNAMIC"
								db.cosmeticBar.heightMode = "DYNAMIC"
								db.cosmeticBar.width = 7
								db.cosmeticBar.height = 12
								db.cosmeticBar.offsetX = -7
								db.cosmeticBar.offsetY = 0
								db.cosmeticBar.border = "ONEPIXEL"
								db.cosmeticBar.borderAlpha = 1
								db.cosmeticBar.color.mode = "GRADIENT"
								db.cosmeticBar.color.normalColor = { r = 0.000, g = 0.659, b = 1.000, a = 1 }
								db.cosmeticBar.color.gradientColor1 = { r = 0.32941, g = 0.52157, b = 0.93333, a = 1 }
								db.cosmeticBar.color.gradientColor2 = { r = 0.25882, g = 0.84314, b = 0.86667, a = 1 }
								OT:RefreshAllCosmeticBars()
							end,
						},
						preset3 = {
							order = 5,
							type = "execute",
							name = format(L["Preset %d"], 3),
							func = function()
								local db = E.private.WT.quest.objectiveTracker
								db.header.style = "OUTLINE"
								db.header.color = { r = 1, g = 1, b = 1 }
								db.header.size = E.db.general.fontSize + 2
								db.cosmeticBar.texture = "Solid"
								db.cosmeticBar.widthMode = "DYNAMIC"
								db.cosmeticBar.heightMode = "ABSOLUTE"
								db.cosmeticBar.width = 30
								db.cosmeticBar.height = 10
								db.cosmeticBar.offsetX = -2
								db.cosmeticBar.offsetY = -7
								db.cosmeticBar.border = "NONE"
								db.cosmeticBar.borderAlpha = 1
								db.cosmeticBar.color.mode = "NORMAL"
								db.cosmeticBar.color.normalColor = { r = 0.681, g = 0.681, b = 0.681, a = 0.681 }
								db.cosmeticBar.color.gradientColor1 = { r = 0.32941, g = 0.52157, b = 0.93333, a = 1 }
								db.cosmeticBar.color.gradientColor2 = { r = 0.25882, g = 0.84314, b = 0.86667, a = 1 }
								OT:RefreshAllCosmeticBars()
							end,
						},
						preset4 = {
							order = 6,
							type = "execute",
							name = format(L["Preset %d"], 4),
							func = function()
								local db = E.private.WT.quest.objectiveTracker
								db.header.style = "OUTLINE"
								db.header.color = { r = 1, g = 1, b = 1 }
								db.header.size = E.db.general.fontSize + 3
								db.cosmeticBar.texture = "Solid"
								db.cosmeticBar.widthMode = "ABSOLUTE"
								db.cosmeticBar.heightMode = "ABSOLUTE"
								db.cosmeticBar.width = 260
								db.cosmeticBar.height = 24
								db.cosmeticBar.offsetX = -7
								db.cosmeticBar.offsetY = 0
								db.cosmeticBar.border = "ONEPIXEL"
								db.cosmeticBar.borderAlpha = 1
								db.cosmeticBar.color.mode = "GRADIENT"
								db.cosmeticBar.color.normalColor = { r = 0.681, g = 0.681, b = 0.681, a = 0.681 }
								db.cosmeticBar.color.gradientColor1 = { r = 0.32941, g = 0.52157, b = 0.93333, a = 1 }
								db.cosmeticBar.color.gradientColor2 = { r = 0.25882, g = 0.84314, b = 0.86667, a = 1 }
								OT:RefreshAllCosmeticBars()
							end,
						},
					},
				},
			},
		},
		header = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Header"],
			disabled = function()
				return not E.private.WT.quest.objectiveTracker.enable
			end,
			get = function(info)
				return E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
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
				shortHeader = {
					order = 4,
					type = "toggle",
					name = L["Short Header"],
					desc = L["Use short name instead. e.g. Torghast, Tower of the Damned to Torghast."],
				},
				classColor = {
					order = 5,
					type = "toggle",
					name = L["Use Class Color"],
				},
				color = {
					order = 6,
					type = "color",
					name = L["Color"],
					hasAlpha = false,
					disabled = function()
						return not E.private.WT.quest.objectiveTracker.enable
							or E.private.WT.quest.objectiveTracker.header.classColor
					end,
					get = function(info)
						local db = E.private.WT.quest.objectiveTracker.header.color
						local default = V.quest.objectiveTracker.header.color
						return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
					end,
					set = function(info, r, g, b)
						local db = E.private.WT.quest.objectiveTracker.header.color
						db.r, db.g, db.b = r, g, b
						OT:RefreshAllCosmeticBars()
					end,
				},
			},
		},
		titleColor = {
			order = 6,
			type = "group",
			inline = true,
			name = L["Title Color"],
			disabled = function()
				return not E.private.WT.quest.objectiveTracker.enable
			end,
			get = function(info)
				return E.private.WT.quest.objectiveTracker.titleColor[info[#info]]
			end,
			set = function(info, value)
				E.private.WT.quest.objectiveTracker.titleColor[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Change the color of quest titles."],
				},
				classColor = {
					order = 2,
					type = "toggle",
					name = L["Use Class Color"],
				},
				customColorNormal = {
					order = 3,
					type = "color",
					name = L["Normal Color"],
					hasAlpha = false,
					get = function(info)
						local db = E.private.WT.quest.objectiveTracker.titleColor.customColorNormal
						local default = V.quest.objectiveTracker.titleColor.customColorNormal
						return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
					end,
					set = function(info, r, g, b)
						local db = E.private.WT.quest.objectiveTracker.titleColor.customColorNormal
						db.r, db.g, db.b = r, g, b
					end,
				},
				customColorHighlight = {
					order = 4,
					type = "color",
					name = L["Highlight Color"],
					hasAlpha = false,
					get = function(info)
						local db = E.private.WT.quest.objectiveTracker.titleColor.customColorHighlight
						local default = V.quest.objectiveTracker.titleColor.customColorHighlight
						return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
					end,
					set = function(info, r, g, b)
						local db = E.private.WT.quest.objectiveTracker.titleColor.customColorHighlight
						db.r, db.g, db.b = r, g, b
					end,
				},
			},
		},
		title = {
			order = 7,
			type = "group",
			inline = true,
			name = L["Title"],
			disabled = function()
				return not E.private.WT.quest.objectiveTracker.enable
			end,
			get = function(info)
				return E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
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
				wordWrap = {
					order = 4,
					type = "toggle",
					name = L["Word Wrap"],
					desc = L["Enable word wrap for long text."],
				},
			},
		},
		infoColor = {
			order = 8,
			type = "group",
			inline = true,
			name = L["Information Color"],
			disabled = function()
				return not E.private.WT.quest.objectiveTracker.enable
			end,
			get = function(info)
				return E.private.WT.quest.objectiveTracker.infoColor[info[#info]]
			end,
			set = function(info, value)
				E.private.WT.quest.objectiveTracker.infoColor[info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Change the color of quest titles."],
				},
				classColor = {
					order = 2,
					type = "toggle",
					name = L["Use Class Color"],
				},
				customColorNormal = {
					order = 3,
					type = "color",
					name = L["Normal Color"],
					hasAlpha = false,
					get = function(info)
						local db = E.private.WT.quest.objectiveTracker.infoColor.customColorNormal
						local default = V.quest.objectiveTracker.infoColor.customColorNormal
						return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
					end,
					set = function(info, r, g, b)
						local db = E.private.WT.quest.objectiveTracker.infoColor.customColorNormal
						db.r, db.g, db.b = r, g, b
					end,
				},
				customColorHighlight = {
					order = 4,
					type = "color",
					name = L["Highlight Color"],
					hasAlpha = false,
					get = function(info)
						local db = E.private.WT.quest.objectiveTracker.infoColor.customColorHighlight
						local default = V.quest.objectiveTracker.infoColor.customColorHighlight
						return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
					end,
					set = function(info, r, g, b)
						local db = E.private.WT.quest.objectiveTracker.infoColor.customColorHighlight
						db.r, db.g, db.b = r, g, b
					end,
				},
			},
		},
		info = {
			order = 9,
			type = "group",
			inline = true,
			name = L["Information"],
			disabled = function()
				return not E.private.WT.quest.objectiveTracker.enable
			end,
			get = function(info)
				return E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
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
				wordWrap = {
					order = 4,
					type = "toggle",
					name = L["Word Wrap"],
					desc = L["Enable word wrap for long text."],
				},
			},
		},
		backdrop = {
			order = 10,
			type = "group",
			inline = true,
			name = L["Backdrop"],
			disabled = function()
				return not E.private.WT.quest.objectiveTracker.enable
			end,
			get = function(info)
				return E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]] = value
				OT:UpdateBackdrop()
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				transparent = {
					order = 2,
					type = "toggle",
					name = L["Transparent"],
					disabled = function()
						return not E.private.WT.quest.objectiveTracker.enable
							or not E.private.WT.quest.objectiveTracker.backdrop.enable
					end,
				},
				betterAlign1 = {
					order = 3,
					type = "description",
					name = "",
					width = "full",
				},
				topLeftOffsetX = {
					order = 4,
					disabled = function()
						return not E.private.WT.quest.objectiveTracker.enable
							or not E.private.WT.quest.objectiveTracker.backdrop.enable
					end,
					name = L["Top Left Offset X"],
					type = "range",
					min = -100,
					max = 100,
					step = 1,
					width = 1.2,
				},
				topLeftOffsetY = {
					order = 5,
					disabled = function()
						return not E.private.WT.quest.objectiveTracker.enable
							or not E.private.WT.quest.objectiveTracker.backdrop.enable
					end,
					name = L["Top Left Offset Y"],
					type = "range",
					min = -100,
					max = 100,
					step = 1,
					width = 1.2,
				},
				betterAlign2 = {
					order = 6,
					type = "description",
					name = "",
					width = "full",
				},
				bottomRightOffsetX = {
					order = 7,
					disabled = function()
						return not E.private.WT.quest.objectiveTracker.enable
							or not E.private.WT.quest.objectiveTracker.backdrop.enable
					end,
					name = L["Bottom Right Offset X"],
					type = "range",
					min = -100,
					max = 100,
					step = 1,
					width = 1.2,
				},
				bottomRightOffsetY = {
					order = 8,
					disabled = function()
						return not E.private.WT.quest.objectiveTracker.enable
							or not E.private.WT.quest.objectiveTracker.backdrop.enable
					end,
					name = L["Bottom Right Offset Y"],
					type = "range",
					min = -100,
					max = 100,
					step = 1,
					width = 1.2,
				},
			},
		},
		menuTitle = {
			order = 11,
			type = "group",
			inline = true,
			name = L["Menu Title"] .. " (" .. L["it shows when objective tracker be collapsed."] .. ")",
			disabled = function()
				return not E.private.WT.quest.objectiveTracker.enable
			end,
			get = function(info)
				return E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]]
			end,
			set = function(info, value)
				E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Change the color of quest titles."],
				},
				classColor = {
					order = 2,
					type = "toggle",
					name = L["Use Class Color"],
					disabled = function()
						return not E.private.WT.quest.objectiveTracker.enable
							or not E.private.WT.quest.objectiveTracker.menuTitle.enable
					end,
				},
				color = {
					order = 3,
					type = "color",
					name = L["Color"],
					hasAlpha = false,
					disabled = function()
						return not E.private.WT.quest.objectiveTracker.enable
							or not E.private.WT.quest.objectiveTracker.menuTitle.enable
							or E.private.WT.quest.objectiveTracker.menuTitle.classColor
					end,
					get = function(info)
						local db = E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]]
						local default = V.quest.objectiveTracker[info[#info - 1]][info[#info]]
						return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
					end,
					set = function(info, r, g, b)
						local db = E.private.WT.quest.objectiveTracker[info[#info - 1]][info[#info]]
						db.r, db.g, db.b = r, g, b
					end,
				},
				font = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Font"],
					disabled = function()
						return not E.private.WT.quest.objectiveTracker.enable
							or not E.private.WT.quest.objectiveTracker.menuTitle.enable
					end,
					get = function(info)
						return E.private.WT.quest.objectiveTracker[info[#info - 2]][info[#info - 1]][info[#info]]
					end,
					set = function(info, value)
						E.private.WT.quest.objectiveTracker[info[#info - 2]][info[#info - 1]][info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
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
}

options.turnIn = {
	order = 2,
	type = "group",
	name = L["Turn In"],
	get = function(info)
		return E.db.WT.quest.turnIn[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.quest.turnIn[info[#info]] = value
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
					name = L["Make quest acceptance and completion automatically."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			set = function(info, value)
				E.db.WT.quest.turnIn[info[#info]] = value
				TI:ProfileUpdate()
				SB:ProfileUpdate()
			end,
			width = "full",
		},
		mode = {
			order = 3,
			type = "select",
			name = L["Mode"],
			disabled = function()
				return not E.db.WT.quest.turnIn.enable
			end,
			values = {
				ALL = L["All"],
				ACCEPT = L["Only Accept"],
				COMPLETE = L["Only Complete"],
			},
		},
		pauseModifier = {
			order = 4,
			type = "select",
			name = L["Pause On Press"],
			desc = L["Pause the automation by pressing a modifier key."],
			disabled = function()
				return not E.db.WT.quest.turnIn.enable
			end,
			values = {
				ANY = L["Any"],
				ALT = L["Alt Key"],
				CTRL = L["Ctrl Key"],
				SHIFT = L["Shift Key"],
				NONE = L["None"],
			},
		},
		onlyRepeatable = {
			order = 4,
			type = "toggle",
			name = L["Only Repeatable"],
			desc = L["Only accept and complete repeatable quests."],
			disabled = function()
				return not E.db.WT.quest.turnIn.enable
			end,
		},
		reward = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Reward"],
			disabled = function()
				return not E.db.WT.quest.turnIn.enable
			end,
			args = {
				selectReward = {
					order = 1,
					type = "toggle",
					name = L["Select Reward"],
					desc = L["If there are multiple items in the reward list, it will select the reward with the highest sell price."],
					disabled = function()
						return not E.db.WT.quest.turnIn.enable or E.db.WT.quest.turnIn.mode == "ACCEPT"
					end,
				},
				getBestReward = {
					order = 2,
					type = "toggle",
					name = L["Get Best Reward"],
					desc = L["Complete the quest with the most valuable reward."],
					disabled = function()
						return not E.db.WT.quest.turnIn.enable
							or E.db.WT.quest.turnIn.mode == "ACCEPT"
							or not E.db.WT.quest.turnIn.selectReward
					end,
				},
			},
		},
		smartChat = {
			order = 6,
			type = "group",
			inline = true,
			name = L["Smart Chat"],
			disabled = function()
				return not E.db.WT.quest.turnIn.enable
			end,
			args = {
				smartChat = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Chat with NPCs smartly. It will automatically select the best option for you."],
					disabled = function()
						return not E.db.WT.quest.turnIn.enable
					end,
				},
				darkmoon = {
					order = 2,
					type = "toggle",
					name = L["Dark Moon"],
					desc = L["Accept the teleportation from Darkmoon Faire Mystic Mage automatically."],
					disabled = function()
						return not E.db.WT.quest.turnIn.enable or not E.db.WT.quest.turnIn.smartChat
					end,
				},
				followerAssignees = {
					order = 3,
					type = "toggle",
					name = L["Follower Assignees"],
					desc = L["Open the window of follower recruit automatically."],
					disabled = function()
						return not E.db.WT.quest.turnIn.enable or not E.db.WT.quest.turnIn.smartChat
					end,
				},
			},
		},
		ignore = {
			order = 7,
			type = "group",
			inline = true,
			name = L["Ignored NPCs"],
			disabled = function()
				return not E.db.WT.quest.turnIn.enable
			end,
			args = {
				description = {
					order = 1,
					type = "description",
					name = "\n" .. L["If you add the NPC into the list, all automation will do not work for it."],
					width = "full",
				},
				list = {
					order = 2,
					type = "select",
					name = L["Ignore List"],
					get = function()
						return customListSelected
					end,
					set = function(_, value)
						customListSelected = value
					end,
					values = function()
						local list = E.db.WT.quest.turnIn.customIgnoreNPCs
						local result = {}
						for key, value in pairs(list) do
							result[tostring(key)] = value
						end
						return result
					end,
				},
				addButton = {
					order = 3,
					type = "execute",
					name = L["Add Target"],
					desc = L["Make sure you select the NPC as your target."],
					func = function()
						TI:AddTargetToBlacklist()
					end,
				},
				deleteButton = {
					order = 4,
					type = "execute",
					name = L["Delete"],
					desc = L["Delete the selected NPC."],
					func = function()
						if customListSelected then
							local list = E.db.WT.quest.turnIn.customIgnoreNPCs
							list[tonumber(customListSelected)] = nil
						end
					end,
				},
			},
		},
	},
}

options.progress = {
	order = 3,
	type = "group",
	name = L["Progress"],
	get = function(info)
		return E.db.WT.quest.progress[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.quest.progress[info[#info]] = value
		QP:ProfileUpdate()
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
					name = L["Display colorful quest progress information to replace Blizzard's default."] .. "\n\n",
					fontSize = "medium",
					width = "full",
				},
				notice = {
					order = 2,
					type = "description",
					name = ImportantColorString(L["Notice"])
						.. " "
						.. L["To ensure the colorful progress information remains clearly visible across different environments, the 'OUTLINE' font style is recommended."]
						.. " "
						.. format(
							L["You can find the setting in 'ElvUI > %s > %s > %s'."],
							L["General"],
							L["Fonts"],
							L["Quest Progress and Error Text"]
						),
					fontSize = "medium",
					width = "full",
				},
			},
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			width = "full",
		},
		disableIfRequiredOver = {
			order = 2,
			type = "range",
			name = L["Disable If Required Over"],
			desc = L["Disable the progress message if the required number of objectives is over this value to avoid spamming."],
			step = 1,
			min = 1,
			max = 2000,
		},
		displayTemplate = {
			order = 3,
			type = "input",
			name = L["Display Template"],
			desc = strjoin(
				"\n",
				L["The template for rendering progress message in UIErrorsFrame."],
				"",
				F.GetWindStyleText(L["Template Elements"]),
				FormatDesc("{{level}}", L["Quest level"]),
				FormatDesc("{{suggestedGroup}}", L["Suggested group size"]),
				FormatDesc("{{daily}}", L["Daily quest label"]),
				FormatDesc("{{weekly}}", L["Weekly quest label"]),
				FormatDesc("{{tag}}", L["Quest tags (Quest series)"]),
				FormatDesc("{{title}}", L["Quest title"]),
				FormatDesc("{{link}}", L["Quest link"]),
				FormatDesc("{{progress}}", L["Quest progress (including objectives)"]),
				FormatDesc("{{icon}}", L["Status icon (accept/complete)"])
			),
			width = "full",
			disabled = function()
				return not E.db.WT.quest.progress.enable
			end,
		},
		example = {
			order = 4,
			type = "description",
			name = function()
				local _, coloredContext = QP:GetTestContext()
				local color = E.db.WT.quest.progress.progress.objective.color
				coloredContext.progress = C.GradientStringByRGB(L["Test Target"], color.left, color.right)
				coloredContext.icon = format("|T%s:0|t", W.Media.Icons.complete)
				local message = QP:RenderTemplate(E.db.WT.quest.progress.displayTemplate, coloredContext)
				return "\n" .. ImportantColorString(L["Example"]) .. ": " .. message .. "\n\n"
			end,
		},
		useDefault = {
			order = 5,
			type = "execute",
			name = L["Default"],
			desc = L["Reset the template to default value."],
			func = function()
				E.db.WT.quest.progress.displayTemplate = P.quest.progress.displayTemplate
			end,
		},
		tag = {
			order = 6,
			type = "group",
			name = L["Tag"],
			disabled = function()
				return not E.db.WT.quest.progress.enable
			end,
			get = function(info)
				return E.db.WT.quest.progress.tag[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.quest.progress.tag[info[#info]] = value
			end,
			args = {
				descGroup = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						tag = {
							order = 1,
							type = "description",
							name = format(
								L["%s contains the quest tag, which is typically the quest series name."],
								ImportantColorString("{{tag}}")
							),
							fontSize = "medium",
						},
					},
				},
				template = {
					order = 2,
					type = "input",
					name = L["Template"],
					width = 1.5,
				},
				default = {
					order = 3,
					type = "execute",
					name = L["Default"],
					desc = L["Reset the template to default value."],
					func = function()
						E.db.WT.quest.progress.tag.template = P.quest.progress.tag.template
					end,
				},
				color = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Color"],
					get = function(info)
						return E.db.WT.quest.progress.tag.color[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.quest.progress.tag.color[info[#info]] = value
					end,
					args = {
						left = {
							order = 1,
							type = "color",
							name = L["Gradient Color 1"],
							hasAlpha = false,
							get = function(info)
								local colordb = E.db.WT.quest.progress.tag.color.left
								local default = P.quest.progress.tag.color.left
								return colordb.r, colordb.g, colordb.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.quest.progress.tag.color.left
								db.r, db.g, db.b = r, g, b
							end,
						},
						right = {
							order = 2,
							type = "color",
							name = L["Gradient Color 2"],
							hasAlpha = false,
							get = function(info)
								local colordb = E.db.WT.quest.progress.tag.color.right
								local default = P.quest.progress.tag.color.right
								return colordb.r, colordb.g, colordb.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.quest.progress.tag.color.right
								db.r, db.g, db.b = r, g, b
							end,
						},
					},
				},
			},
		},
		suggestedGroup = {
			order = 7,
			type = "group",
			name = L["Suggested Group"],
			disabled = function()
				return not E.db.WT.quest.progress.enable
			end,
			get = function(info)
				return E.db.WT.quest.progress.suggestedGroup[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.quest.progress.suggestedGroup[info[#info]] = value
			end,
			args = {
				descGroup = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						suggestedGroup = {
							order = 1,
							type = "description",
							name = format(
								L["%s contains the suggested group size for the quest."],
								ImportantColorString("{{suggestedGroup}}")
							),
							fontSize = "medium",
						},
					},
				},
				template = {
					order = 2,
					type = "input",
					name = L["Template"],
					width = 1.5,
				},
				default = {
					order = 3,
					type = "execute",
					name = L["Default"],
					desc = L["Reset the template to default value."],
					func = function()
						E.db.WT.quest.progress.suggestedGroup.template = P.quest.progress.suggestedGroup.template
					end,
				},
				color = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Color"],
					get = function(info)
						return E.db.WT.quest.progress.suggestedGroup.color[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.quest.progress.suggestedGroup.color[info[#info]] = value
					end,
					args = {
						left = {
							order = 1,
							type = "color",
							name = L["Gradient Color 1"],
							hasAlpha = false,
							get = function(info)
								local colordb = E.db.WT.quest.progress.suggestedGroup.color.left
								local default = P.quest.progress.suggestedGroup.color.left
								return colordb.r, colordb.g, colordb.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.quest.progress.suggestedGroup.color.left
								db.r, db.g, db.b = r, g, b
							end,
						},
						right = {
							order = 2,
							type = "color",
							name = L["Gradient Color 2"],
							hasAlpha = false,
							get = function(info)
								local colordb = E.db.WT.quest.progress.suggestedGroup.color.right
								local default = P.quest.progress.suggestedGroup.color.right
								return colordb.r, colordb.g, colordb.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.quest.progress.suggestedGroup.color.right
								db.r, db.g, db.b = r, g, b
							end,
						},
					},
				},
			},
		},
		level = {
			order = 8,
			type = "group",
			name = L["Level"],
			disabled = function()
				return not E.db.WT.quest.progress.enable
			end,
			get = function(info)
				return E.db.WT.quest.progress.level[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.quest.progress.level[info[#info]] = value
			end,
			args = {
				descGroup = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						level = {
							order = 1,
							type = "description",
							name = format(L["%s contains the quest level."], ImportantColorString("{{level}}")),
							fontSize = "medium",
						},
					},
				},
				template = {
					order = 2,
					type = "input",
					name = L["Template"],
					width = 1.5,
				},
				default = {
					order = 3,
					type = "execute",
					name = L["Default"],
					desc = L["Reset the template to default value."],
					func = function()
						E.db.WT.quest.progress.level.template = P.quest.progress.level.template
					end,
				},
				hideOnCharacterLevel = {
					order = 4,
					type = "toggle",
					width = 1.5,
					name = L["Hide On Character Level"],
					desc = L["Hide the level part if the quest level is the same as your character level."],
				},
				color = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Color"],
					get = function(info)
						return E.db.WT.quest.progress.level.color[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.quest.progress.level.color[info[#info]] = value
					end,
					args = {
						left = {
							order = 1,
							type = "color",
							name = L["Gradient Color 1"],
							hasAlpha = false,
							get = function(info)
								local colordb = E.db.WT.quest.progress.level.color.left
								local default = P.quest.progress.level.color.left
								return colordb.r, colordb.g, colordb.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.quest.progress.level.color.left
								db.r, db.g, db.b = r, g, b
							end,
						},
						right = {
							order = 2,
							type = "color",
							name = L["Gradient Color 2"],
							hasAlpha = false,
							get = function(info)
								local colordb = E.db.WT.quest.progress.level.color.right
								local default = P.quest.progress.level.color.right
								return colordb.r, colordb.g, colordb.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.quest.progress.level.color.right
								db.r, db.g, db.b = r, g, b
							end,
						},
					},
				},
			},
		},
		daily = {
			order = 9,
			type = "group",
			name = L["Daily"],
			disabled = function()
				return not E.db.WT.quest.progress.enable
			end,
			get = function(info)
				return E.db.WT.quest.progress.daily[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.quest.progress.daily[info[#info]] = value
			end,
			args = {
				descGroup = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						daily = {
							order = 1,
							type = "description",
							name = format(L["%s contains the daily quest label."], ImportantColorString("{{daily}}")),
							fontSize = "medium",
						},
					},
				},
				template = {
					order = 2,
					type = "input",
					name = L["Template"],
					width = 1.5,
				},
				default = {
					order = 3,
					type = "execute",
					name = L["Default"],
					desc = L["Reset the template to default value."],
					func = function()
						E.db.WT.quest.progress.daily.template = P.quest.progress.daily.template
					end,
				},
				color = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Color"],
					get = function(info)
						return E.db.WT.quest.progress.daily.color[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.quest.progress.daily.color[info[#info]] = value
					end,
					args = {
						left = {
							order = 1,
							type = "color",
							name = L["Gradient Color 1"],
							hasAlpha = false,
							get = function(info)
								local colordb = E.db.WT.quest.progress.daily.color.left
								local default = P.quest.progress.daily.color.left
								return colordb.r, colordb.g, colordb.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.quest.progress.daily.color.left
								db.r, db.g, db.b = r, g, b
							end,
						},
						right = {
							order = 2,
							type = "color",
							name = L["Gradient Color 2"],
							hasAlpha = false,
							get = function(info)
								local colordb = E.db.WT.quest.progress.daily.color.right
								local default = P.quest.progress.daily.color.right
								return colordb.r, colordb.g, colordb.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.quest.progress.daily.color.right
								db.r, db.g, db.b = r, g, b
							end,
						},
					},
				},
			},
		},
		weekly = {
			order = 10,
			type = "group",
			name = L["Weekly"],
			disabled = function()
				return not E.db.WT.quest.progress.enable
			end,
			get = function(info)
				return E.db.WT.quest.progress.weekly[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.quest.progress.weekly[info[#info]] = value
			end,
			args = {
				descGroup = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						weekly = {
							order = 1,
							type = "description",
							name = format(L["%s contains the weekly quest label."], ImportantColorString("{{weekly}}")),
							fontSize = "medium",
						},
					},
				},
				template = {
					order = 2,
					type = "input",
					name = L["Template"],
					width = 1.5,
				},
				default = {
					order = 3,
					type = "execute",
					name = L["Default"],
					desc = L["Reset the template to default value."],
					func = function()
						E.db.WT.quest.progress.weekly.template = P.quest.progress.weekly.template
					end,
				},
				color = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Color"],
					get = function(info)
						return E.db.WT.quest.progress.weekly.color[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.quest.progress.weekly.color[info[#info]] = value
					end,
					args = {
						left = {
							order = 1,
							type = "color",
							name = L["Gradient Color 1"],
							hasAlpha = false,
							get = function(info)
								local colordb = E.db.WT.quest.progress.weekly.color.left
								local default = P.quest.progress.weekly.color.left
								return colordb.r, colordb.g, colordb.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.quest.progress.weekly.color.left
								db.r, db.g, db.b = r, g, b
							end,
						},
						right = {
							order = 2,
							type = "color",
							name = L["Gradient Color 2"],
							hasAlpha = false,
							get = function(info)
								local colordb = E.db.WT.quest.progress.weekly.color.right
								local default = P.quest.progress.weekly.color.right
								return colordb.r, colordb.g, colordb.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.quest.progress.weekly.color.right
								db.r, db.g, db.b = r, g, b
							end,
						},
					},
				},
			},
		},
		title = {
			order = 11,
			type = "group",
			name = L["Title"],
			disabled = function()
				return not E.db.WT.quest.progress.enable
			end,
			get = function(info)
				return E.db.WT.quest.progress.title[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.quest.progress.title[info[#info]] = value
			end,
			args = {
				descGroup = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						title = {
							order = 1,
							type = "description",
							name = format(L["%s contains the quest title."], ImportantColorString("{{title}}")),
							fontSize = "medium",
						},
					},
				},
				template = {
					order = 2,
					type = "input",
					name = L["Template"],
					width = 1.5,
				},
				default = {
					order = 3,
					type = "execute",
					name = L["Default"],
					desc = L["Reset the template to default value."],
					func = function()
						E.db.WT.quest.progress.title.template = P.quest.progress.title.template
					end,
				},
				color = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Color"],
					get = function(info)
						return E.db.WT.quest.progress.title.color[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.quest.progress.title.color[info[#info]] = value
					end,
					args = {
						left = {
							order = 1,
							type = "color",
							name = L["Gradient Color 1"],
							hasAlpha = false,
							get = function(info)
								local colordb = E.db.WT.quest.progress.title.color.left
								local default = P.quest.progress.title.color.left
								return colordb.r, colordb.g, colordb.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.quest.progress.title.color.left
								db.r, db.g, db.b = r, g, b
							end,
						},
						right = {
							order = 2,
							type = "color",
							name = L["Gradient Color 2"],
							hasAlpha = false,
							get = function(info)
								local colordb = E.db.WT.quest.progress.title.color.right
								local default = P.quest.progress.title.color.right
								return colordb.r, colordb.g, colordb.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = E.db.WT.quest.progress.title.color.right
								db.r, db.g, db.b = r, g, b
							end,
						},
					},
				},
			},
		},
		progress = {
			order = 12,
			type = "group",
			name = L["Progress"],
			disabled = function()
				return not E.db.WT.quest.progress.enable
			end,
			args = {
				objective = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Objective"],
					get = function(info)
						return E.db.WT.quest.progress.progress.objective[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.quest.progress.progress.objective[info[#info]] = value
					end,
					args = {
						descGroup = {
							order = 1,
							type = "group",
							inline = true,
							name = L["Description"],
							args = {
								objective = {
									order = 1,
									type = "description",
									name = format(
										L["%s contains the quest objective progress."],
										ImportantColorString("{{progress}}")
									),
									fontSize = "medium",
								},
							},
						},
						detailTemplate = {
							order = 2,
							type = "input",
							name = L["Detail Template"],
							desc = L["The progress details like 10/20."],
							width = 1.5,
						},
						default = {
							order = 3,
							type = "execute",
							name = L["Default"],
							desc = L["Reset the template to default value."],
							func = function()
								E.db.WT.quest.progress.progress.objective.detailTemplate =
									P.quest.progress.progress.objective.detailTemplate
							end,
						},
						color = {
							order = 4,
							type = "group",
							inline = true,
							name = L["Objective Color"],
							get = function(info)
								return E.db.WT.quest.progress.progress.objective.color[info[#info]]
							end,
							set = function(info, value)
								E.db.WT.quest.progress.progress.objective.color[info[#info]] = value
							end,
							args = {
								left = {
									order = 1,
									type = "color",
									name = L["Gradient Color 1"],
									hasAlpha = false,
									get = function(info)
										local colordb = E.db.WT.quest.progress.progress.objective.color.left
										local default = P.quest.progress.progress.objective.color.left
										return colordb.r,
											colordb.g,
											colordb.b,
											nil,
											default.r,
											default.g,
											default.b,
											nil
									end,
									set = function(info, r, g, b)
										local db = E.db.WT.quest.progress.progress.objective.color.left
										db.r, db.g, db.b = r, g, b
									end,
								},
								right = {
									order = 2,
									type = "color",
									name = L["Gradient Color 2"],
									hasAlpha = false,
									get = function(info)
										local colordb = E.db.WT.quest.progress.progress.objective.color.right
										local default = P.quest.progress.progress.objective.color.right
										return colordb.r,
											colordb.g,
											colordb.b,
											nil,
											default.r,
											default.g,
											default.b,
											nil
									end,
									set = function(info, r, g, b)
										local db = E.db.WT.quest.progress.progress.objective.color.right
										db.r, db.g, db.b = r, g, b
									end,
								},
							},
						},
					},
				},
				complete = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Complete"],
					get = function(info)
						return E.db.WT.quest.progress.progress.complete[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.quest.progress.progress.complete[info[#info]] = value
					end,
					args = {
						template = {
							order = 1,
							type = "input",
							name = L["Template"],
							width = 1.5,
						},
						default = {
							order = 2,
							type = "execute",
							name = L["Default"],
							desc = L["Reset the template to default value."],
							func = function()
								E.db.WT.quest.progress.progress.complete.template =
									P.quest.progress.progress.complete.template
							end,
						},
						color = {
							order = 3,
							type = "group",
							inline = true,
							name = L["Color"],
							get = function(info)
								return E.db.WT.quest.progress.progress.complete.color[info[#info]]
							end,
							set = function(info, value)
								E.db.WT.quest.progress.progress.complete.color[info[#info]] = value
							end,
							args = {
								left = {
									order = 1,
									type = "color",
									name = L["Gradient Color 1"],
									hasAlpha = false,
									get = function(info)
										local colordb = E.db.WT.quest.progress.progress.complete.color.left
										local default = P.quest.progress.progress.complete.color.left
										return colordb.r,
											colordb.g,
											colordb.b,
											nil,
											default.r,
											default.g,
											default.b,
											nil
									end,
									set = function(info, r, g, b)
										local db = E.db.WT.quest.progress.progress.complete.color.left
										db.r, db.g, db.b = r, g, b
									end,
								},
								right = {
									order = 2,
									type = "color",
									name = L["Gradient Color 2"],
									hasAlpha = false,
									get = function(info)
										local colordb = E.db.WT.quest.progress.progress.complete.color.right
										local default = P.quest.progress.progress.complete.color.right
										return colordb.r,
											colordb.g,
											colordb.b,
											nil,
											default.r,
											default.g,
											default.b,
											nil
									end,
									set = function(info, r, g, b)
										local db = E.db.WT.quest.progress.progress.complete.color.right
										db.r, db.g, db.b = r, g, b
									end,
								},
							},
						},
					},
				},
				accepted = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Accepted"],
					get = function(info)
						return E.db.WT.quest.progress.progress.accepted[info[#info]]
					end,
					set = function(info, value)
						E.db.WT.quest.progress.progress.accepted[info[#info]] = value
					end,
					args = {
						template = {
							order = 1,
							type = "input",
							name = L["Template"],
							width = 1.5,
						},
						default = {
							order = 2,
							type = "execute",
							name = L["Default"],
							desc = L["Reset the template to default value."],
							func = function()
								E.db.WT.quest.progress.progress.accepted.template =
									P.quest.progress.progress.accepted.template
							end,
						},
						color = {
							order = 3,
							type = "group",
							inline = true,
							name = L["Color"],
							get = function(info)
								return E.db.WT.quest.progress.progress.accepted.color[info[#info]]
							end,
							set = function(info, value)
								E.db.WT.quest.progress.progress.accepted.color[info[#info]] = value
							end,
							args = {
								left = {
									order = 1,
									type = "color",
									name = L["Gradient Color 1"],
									hasAlpha = false,
									get = function(info)
										local colordb = E.db.WT.quest.progress.progress.accepted.color.left
										local default = P.quest.progress.progress.accepted.color.left
										return colordb.r,
											colordb.g,
											colordb.b,
											nil,
											default.r,
											default.g,
											default.b,
											nil
									end,
									set = function(info, r, g, b)
										local db = E.db.WT.quest.progress.progress.accepted.color.left
										db.r, db.g, db.b = r, g, b
									end,
								},
								right = {
									order = 2,
									type = "color",
									name = L["Gradient Color 2"],
									hasAlpha = false,
									get = function(info)
										local colordb = E.db.WT.quest.progress.progress.accepted.color.right
										local default = P.quest.progress.progress.accepted.color.right
										return colordb.r,
											colordb.g,
											colordb.b,
											nil,
											default.r,
											default.g,
											default.b,
											nil
									end,
									set = function(info, r, g, b)
										local db = E.db.WT.quest.progress.progress.accepted.color.right
										db.r, db.g, db.b = r, g, b
									end,
								},
							},
						},
					},
				},
			},
		},
	},
}

options.switchButtons = {
	order = 4,
	type = "group",
	name = L["Switch Buttons"],
	get = function(info)
		return E.db.WT.quest.switchButtons[info[#info]]
	end,
	set = function(info, value)
		E.db.WT.quest.switchButtons[info[#info]] = value
		SB:ProfileUpdate()
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
					name = L["Add a bar that contains buttons to enable/disable modules quickly."],
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
		hideWithObjectiveTracker = {
			order = 3,
			type = "toggle",
			name = L["Hide With Objective Tracker"],
			disabled = function()
				return not E.db.WT.quest.switchButtons.enable
			end,
			width = 1.5,
		},
		tooltip = {
			order = 4,
			type = "toggle",
			disabled = function()
				return not E.db.WT.quest.switchButtons.enable
			end,
			name = L["Tooltip"],
		},
		backdrop = {
			order = 5,
			type = "toggle",
			disabled = function()
				return not E.db.WT.quest.switchButtons.enable
			end,
			name = L["Bar Backdrop"],
		},
		font = {
			order = 6,
			type = "group",
			inline = true,
			name = L["Font Setting"],
			disabled = function()
				return not E.db.WT.quest.switchButtons.enable
			end,
			get = function(info)
				return E.db.WT.quest.switchButtons.font[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.quest.switchButtons.font[info[#info]] = value
				SB:UpdateLayout()
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
				color = {
					order = 4,
					type = "color",
					name = L["Color"],
					hasAlpha = false,
					get = function(info)
						local db = E.db.WT.quest.switchButtons.font.color
						local default = P.quest.switchButtons.font.color
						return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
					end,
					set = function(info, r, g, b)
						local db = E.db.WT.quest.switchButtons.font.color
						db.r, db.g, db.b = r, g, b
						SB:UpdateLayout()
					end,
				},
			},
		},
		modules = {
			order = 6,
			type = "group",
			inline = true,
			name = L["Modules"],
			disabled = function()
				return not E.db.WT.quest.switchButtons.enable
			end,
			get = function(info)
				return E.db.WT.quest.switchButtons[info[#info]]
			end,
			set = function(info, value)
				E.db.WT.quest.switchButtons[info[#info]] = value
				SB:UpdateLayout()
			end,
			args = {
				announcement = {
					order = 1,
					type = "toggle",
					name = L["Announcement"] .. " (" .. L["Quest"] .. ")",
					width = 1.667,
				},
				turnIn = {
					order = 2,
					type = "toggle",
					name = L["Turn In"],
					width = 1.667,
				},
			},
		},
	},
}
