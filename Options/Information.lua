local W, F, E, L, V, P, G = unpack((select(2, ...)))
local C = W.Utilities.Color

local options = W.options.information.args

local format = format
local gsub = gsub
local ipairs = ipairs
local pairs = pairs
local tonumber = tonumber
local tostring = tostring
local type = type
local unpack = unpack

local tconcat = table.concat

local function blue(string)
	if type(string) ~= "string" then
		string = tostring(string)
	end
	return F.CreateColorString(string, { r = 0.204, g = 0.596, b = 0.859 })
end

local donators = {
	cdkeys = blue(L["CDKey"] .. ": ") .. tconcat({
		"DakJaniels",
	}, ", "),
	patreon = blue("Ko-fi / Patreon" .. ": ") .. tconcat({
		"Dlarge",
		"KK",
		"paroxp",
		"Constrained",
	}, ", "),
	aifadian = blue(L["AiFaDian"] .. ": ") .. tconcat({
		"LuckyAres",
		"喵仙人Meowcactus",
		"Fakewings",
		"向宁",
		"Leon",
		"不想当人",
		L["Anonymous"] .. "_TxbM",
		L["Anonymous"] .. "_Df5K",
		L["Anonymous"] .. "_tJWM",
		L["Anonymous"] .. "_sCEm",
		L["Anonymous"] .. "_m37v",
		L["Anonymous"] .. "_thgF",
		L["Anonymous"] .. "_aqjx",
	}, ", "),
}

options.help = {
	order = 1,
	type = "group",
	name = L["Help"],
	args = {
		donators = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Golden Donators"],
			args = {
				list = {
					order = 1,
					type = "description",
					fontSize = "small",
					name = tconcat({
						donators.patreon .. "       " .. donators.cdkeys,
						donators.aifadian,
					}, "\n"),
				},
			},
		},
		patreon = {
			order = 2,
			type = "execute",
			name = format("%s %s (%s)", F.GetIconString(W.Media.Icons.donateKofi, 14), L["Donate"], L["Patreon"]),
			func = function()
				E:StaticPopup_Show("WINDTOOLS_EDITBOX", nil, nil, "https://www.patreon.com/fang2hou")
			end,
			width = 1.2,
		},
		aiFaDian = {
			order = 3,
			type = "execute",
			name = format(
				"%s %s (%s/RMB)",
				F.GetIconString(W.Media.Icons.donateAiFaDian, 14),
				L["Donate"],
				L["AiFaDian"]
			),
			func = function()
				E:StaticPopup_Show("WINDTOOLS_EDITBOX", nil, nil, "https://afdian.com/a/fang2hou")
			end,
			width = 1.2,
		},
		betterAlign = {
			order = 4,
			type = "description",
			fontSize = "small",
			name = " ",
			width = "full",
		},
		contact = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Message From the Author"],
			args = {
				description = {
					order = 1,
					type = "description",
					fontSize = "medium",
					name = format(
						"%s\n%s\n%s",
						format(L["Thank you for using %s!"], W.Title),
						format(
							L["You can send your suggestions or bugs via %s, %s, %s and the thread in %s."],
							L["QQ Group"],
							L["Discord"],
							L["GitHub"],
							L["NGA.cn"]
						),
						format(
							"|cffe74c3c%s|r",
							format(
								L["Before you submit a bug, please enable debug mode with %s and test it one more time."],
								"|cff00d1b2/wtdebug on|r"
							)
						)
					),
				},
				betterAlign = {
					order = 2,
					type = "description",
					fontSize = "small",
					name = " ",
					width = "full",
				},
				nga = {
					order = 3,
					type = "execute",
					name = L["NGA.cn"],
					image = W.Media.Icons.nga,
					func = function()
						E:StaticPopup_Show("WINDTOOLS_EDITBOX", nil, nil, "https://bbs.nga.cn/read.php?tid=12142815")
					end,
					width = 0.7,
				},
				discord = {
					order = 4,
					type = "execute",
					name = L["Discord"],
					image = W.Media.Icons.discord,
					func = function()
						E:StaticPopup_Show("WINDTOOLS_EDITBOX", nil, nil, "https://discord.gg/CMDsBmhvyW")
					end,
					width = 0.7,
				},
				qq = {
					order = 5,
					type = "execute",
					name = L["QQ Group"],
					image = W.Media.Icons.qq,
					func = function()
						E:StaticPopup_Show("WINDTOOLS_QQ_GROUP_DIALOG")
					end,
					width = 0.7,
				},
				github = {
					order = 6,
					type = "execute",
					name = L["GitHub"],
					image = W.Media.Icons.github,
					func = function()
						E:StaticPopup_Show(
							"WINDTOOLS_EDITBOX",
							nil,
							nil,
							"https://github.com/wind-addons/ElvUI_WindTools/issues"
						)
					end,
					width = 0.7,
				},
			},
		},
		contributors = {
			order = 6,
			name = L["Contributors (GitHub.com)"],
			type = "group",
			inline = true,
			args = {
				["fang2hou"] = {
					order = 1,
					type = "description",
					name = format(
						"%s: %s | %s",
						"fang2hou",
						E.InfoColor .. "houshuu" .. "|r",
						F.CreateClassColorString("Tabimonk @ " .. L["Shadowmoon"] .. "(TW)", "MONK")
					),
				},
				["mcc1"] = {
					order = 2,
					type = "description",
					name = format(
						"%s: %s",
						"mcc1",
						F.CreateClassColorString("青楓殘月 @ " .. L["Lights Hope"] .. " (TW)", "MAGE")
					),
				},
				["someblu"] = {
					order = 3,
					type = "description",
					name = "someblu",
				},
				["keludechu"] = {
					order = 4,
					type = "description",
					name = format(
						"%s: %s | %s",
						"keludechu",
						E.InfoColor .. "水稻" .. "|r",
						F.CreateClassColorString("Surtr @ " .. L["Blanchard"] .. " (CN)", "WARLOCK")
					),
				},
				["LiangYuxuan"] = {
					order = 5,
					type = "description",
					name = "LiangYuxuan",
				},
				["asdf12303116"] = {
					order = 6,
					type = "description",
					name = format(
						"%s: %s | %s",
						"asdf12303116",
						E.InfoColor .. "Chen" .. "|r",
						F.CreateClassColorString("一发径直入魂 @ " .. L["Burning Blade"] .. " (CN)", "HUNTER")
					),
				},
				["KurtzPT"] = {
					order = 7,
					type = "description",
					name = "KurtzPT",
				},
				["404Polaris"] = {
					order = 8,
					type = "description",
					name = "404Polaris",
				},
				["fubaWoW"] = {
					order = 9,
					type = "description",
					name = "fubaWoW",
				},
				["ryanfys"] = {
					order = 10,
					type = "description",
					name = format("%s: %s", "ryanfys", "阿尔托利亜 @ " .. L["Demon Fall Canyon"] .. " (CN)"),
				},
				["MouJiaoZi"] = {
					order = 11,
					type = "description",
					name = format("%s: %s", "MouJiaoZi", E.InfoColor .. "某餃子" .. "|r"),
				},
				["Jaenichen"] = {
					order = 12,
					type = "description",
					name = format("%s: %s", "Jaenichen", E.InfoColor .. "beejayjayn" .. "|r"),
				},
				["mattiagraziani-it"] = {
					order = 13,
					type = "description",
					name = "mattiagraziani-it",
				},
				["ylt"] = {
					order = 14,
					type = "description",
					name = format(
						"%s: %s | %s",
						"ylt",
						E.InfoColor .. "Joe" .. "|r",
						F.CreateClassColorString("Shaype @ " .. "Draenor" .. " (EU)", "DRUID")
					),
				},
				["AngelosNaoumis"] = {
					order = 15,
					type = "description",
					name = "AngelosNaoumis",
				},
				["DakJaniels"] = {
					order = 16,
					type = "description",
					name = "DakJaniels",
				},
				["LvWind"] = {
					order = 17,
					type = "description",
					name = format(
						"%s: %s",
						"LvWind",
						F.CreateClassColorString("Stellagosa @ " .. L["Bleeding Hollow"] .. " (CN)", "HUNTER")
					),
				},
			},
		},
		version = {
			order = 7,
			name = L["Version"],
			type = "group",
			inline = true,
			args = {
				elvui = {
					order = 1,
					type = "description",
					name = "ElvUI: " .. blue(E.versionString),
				},
				windtools = {
					order = 2,
					type = "description",
					name = W.Title .. ": " .. blue(W.DisplayVersion),
				},
				build = {
					order = 3,
					type = "description",
					name = L["WoW Build"] .. ": " .. blue(format("%s (%s)", E.wowpatch, E.wowbuild)),
				},
			},
		},
	},
}

options.credits = {
	order = 2,
	type = "group",
	name = L["Credits"],
	args = {
		specialThanks = {
			order = 1,
			name = L["Special Thanks"],
			type = "group",
			inline = true,
			args = {},
		},
		sites = {
			order = 2,
			name = L["Sites"],
			type = "group",
			inline = true,
			args = {},
		},
		localization = {
			order = 3,
			name = L["Localization"],
			type = "group",
			inline = true,
			args = {},
		},
		codes = {
			order = 4,
			name = L["Codes"],
			type = "group",
			inline = true,
			args = {},
		},
		mediaFiles = {
			order = 5,
			name = L["Media Files"],
			type = "group",
			inline = true,
			args = {},
		},
	},
}

do -- 特别感谢
	local nameList = {
		"|cffa2c446Siweia|r (|cff68a2daN|r|cffd25348D|rui)",
		"Witness (NDui_Plus)",
		"Loudsoul (|cffea5d5bTiny|rInspect, |cffea5d5bTiny|rTooltip)",
		"|cffff7d0aMerathilis|r (ElvUI_Merathilis|cffff7d0aUI|r)",
		"|cff00e4f5Toxi|r & |cffb5ffebNawuko|r (ElvUI_|cffffffffToxi|r|cff00e4f5UI|r)",
	}

	local nameString = strjoin("\n", unpack(nameList))

	options.credits.args.specialThanks.args["1"] = {
		order = 1,
		type = "description",
		name = nameString .. "\n" .. L["and whole ElvUI team."],
	}
end

do -- 网站
	local siteList = {
		"https://www.wowhead.com/",
		"https://www.townlong-yak.com/",
		"https://wow.tools/",
		"https://wago.tools/",
		"https://wow.gamepedia.com/",
		"https://warcraft.wiki.gg/",
	}

	for i, site in pairs(siteList) do
		options.credits.args.sites.args[tostring(i)] = {
			order = i,
			type = "description",
			name = site,
		}
	end
end

do -- 本地化
	local localizationList = {
		["한국어 (koKR)"] = {
			F.CreateClassColorString(
				"헬리오스의방패<주부월드> @ " .. L["Burning Legion"] .. "(KR)",
				"WARRIOR"
			),
			F.CreateClassColorString("불광불급옹<주부월드> @ " .. L["Burning Legion"] .. "(KR)", "HUNTER"),
			F.CreateClassColorString(
				"다크어쌔신<주부월드> @ " .. L["Burning Legion"] .. "(KR)",
				"DEMONHUNTER"
			),
			F.CreateClassColorString("크림슨프릴<주부월드> @ " .. L["Burning Legion"] .. "(KR)", "MAGE"),
			"Sang Jeon @ GitHub",
			"Reim @ Discord",
			"와우하는아저씨 @ Discord",
			"BlueSea-jun @ GitHub",
		},
		["français (frFR)"] = {
			"PodVibe @ CurseForge",
			"xan2622 @ GitHub",
			"Pristi#2836 @ Discord",
			"Isilorn @ GitHub",
			"ckeurk @ GitHub",
		},
		["Español (esES/esMX)"] = {
			"Keralin @ GitHub",
		},
		["Deutsche (deDE)"] = {
			"imna1975 @ CurseForge",
			"|cffff7d0aMerathilis|r",
			"|cff00c0faDlarge|r",
		},
		["русский язык (ruRU)"] = {
			"Evgeniy-ONiX @ GitHub",
			"dadec666 @ GitHub",
			"Hollicsh @ GitHub",
			"Denzeriko @ GitHub",
		},
	}

	local configOrder = 1
	for langName, credits in pairs(localizationList) do
		options.credits.args.localization.args[tostring(configOrder)] = {
			order = configOrder,
			type = "description",
			name = blue(langName),
		}
		configOrder = configOrder + 1

		for _, credit in pairs(credits) do
			options.credits.args.localization.args[tostring(configOrder)] = {
				order = configOrder,
				type = "description",
				name = "  - " .. credit,
			}
			configOrder = configOrder + 1
		end
	end
end

do -- 插件代码
	local codesCreditList = {
		[L["Announcement"]] = {
			"Venomisto (InstanceResetAnnouncer)",
			"Wetxius, Shestak (ShestakUI)",
			"cadcamzy (EUI)",
		},
		[L["Raid Markers"]] = {
			"Repooc (Shadow & Light)",
		},
		[L["Datatexts"]] = {
			"crackpotx (ElvUI Micro Menu Datatext)",
		},
		[L["Already Known"]] = {
			"ahak (Already Known?)",
			"siweia (NDui)",
		},
		[L["Fast Loot"]] = {
			"Leatrix (Leatrix Plus)",
		},
		[L["Rectangle Minimap"]] = {
			"Repooc (Shadow & Light)",
		},
		[L["World Map"]] = {
			"Leatrix (Leatrix Maps)",
			"siweia (NDui)",
		},
		[L["Minimap Buttons"]] = {
			"Azilroka, Sinaris, Feraldin (Square Minimap Buttons)",
		},
		[L["Misc"]] = {
			"Warbaby (爱不易)",
			"oyg123 @ NGA.cn",
		},
		[L["Skins"]] = {
			"selias2k (iShadow)",
			"siweia (NDui)",
		},
		[L["Filter"]] = {
			"EKE (Fuckyou)",
		},
		[L["Friend List"]] = {
			"Azilroka (ProjectAzilroka)",
		},
		[L["Emote"]] = {
			"loudsoul (TinyChat)",
		},
		[L["Tooltips"]] = {
			"siweia (NDui)",
			"Witnesscm (NDui_Plus)",
			"Tevoll (ElvUI Enhanced Again)",
			"MMOSimca (Simple Objective Progress)",
			"Merathilis (ElvUI MerathilisUI)",
		},
		[L["Turn In"]] = {
			"p3lim (QuickQuest)",
			"siweia (NDui)",
		},
		[L["Context Menu"]] = {
			"Ludicrous Speed, LLC. (Raider.IO)",
		},
		[L["Quick Focus"]] = {
			"siweia (NDui)",
		},
		[L["Move Frames"]] = {
			"zaCade, Numynum (BlizzMove)",
		},
		[L["Extra Items Bar"]] = {
			"cadcamzy (EUI)",
		},
		[L["Inspect"]] = {
			"loudsoul (TinyInspect)",
		},
		[L["Instance Difficulty"]] = {
			"Merathilis (ElvUI MerathilisUI)",
		},
		[L["Item Level"]] = {
			"Merathilis (ElvUI MerathilisUI)",
		},
	}

	local configOrder = 1

	for moduleName, credits in pairs(codesCreditList) do
		options.credits.args.codes.args[tostring(configOrder)] = {
			order = configOrder,
			type = "description",
			name = blue(moduleName) .. " " .. L["Module"],
		}
		configOrder = configOrder + 1

		for _, credit in pairs(credits) do
			options.credits.args.codes.args[tostring(configOrder)] = {
				order = configOrder,
				type = "description",
				name = "  - " .. credit,
			}
			configOrder = configOrder + 1
		end
	end
end

do -- 媒体文件
	local mediaFilesCreditList = {
		["ToxiUI Team"] = {
			"Media/Texture/ToxiUI",
		},
		["迷时鸟 @ NGA.cn"] = {
			"Media/Texture/Illustration",
		},
		["Simaia"] = {
			"Media/Icons/ClassIcon",
		},
		["FlickMasher @ Reddit"] = {
			"Media/Icons/PhilMod",
		},
		["Iconfont (Alibaba)"] = {
			"Media/Icons/GameBar",
			"Media/Icons/List.tga",
			"Media/Icons/Favorite.tga",
			"Media/Textures/ArrowDown.tga",
		},
		["Ferous Media (Ferous)"] = {
			"Media/Texture/Vignetting.tga",
		},
		["Icon made by Freepik from www.flaticon.com"] = {
			"Media/Texture/Shield.tga",
			"Media/Texture/Sword.tga",
			"Media/Icons/Tooltips.tga",
		},
		["Marijan Petrovski @ PSDchat.com"] = {
			"Media/Icons/Hexagon",
		},
		["ファイナルファンタジーXIV ファンキット"] = {
			"Media/Icons/FFXIV",
		},
		["SunUI (Coolkids)"] = {
			"Media/Icons/SunUI",
		},
		["Sukiki情绪化 @ www.iconfont.cn"] = {
			"Media/Icons/Rest.tga",
		},
		["LieutenantG @ www.iconfont.cn"] = {
			"Media/Icons/Button/Minus.tga",
			"Media/Icons/Button/Plus.tga",
			"Media/Icons/Button/Forward.tga",
		},
		["Jodalo"] = {
			"Media/Textures/StatusbarClean.tga",
		},
		["IconPark"] = {
			"Media/Icons/Categories",
		},
		["TinyChat (loudsoul)"] = {
			"Media/Emotes",
		},
		["ProjectAzilroka (Azilroka)"] = {
			"Media/FriendList",
		},
		["Tepid Monkey"] = {
			"Media/Fonts/AccidentalPresidency.ttf",
		},
		["Julieta Ulanovsky"] = {
			"Media/Fonts/Montserrat-ExtraBold.ttf",
		},
		["Keith Bates"] = {
			"Media/Fonts/Roadway.ttf",
		},
		["OnePlus"] = {
			"Media/Sounds/OnePlusLight.ogg",
			"Media/Sounds/OnePlusSurprise.ogg",
		},
	}

	local configOrder = 1

	for author, sourceTable in pairs(mediaFilesCreditList) do
		options.credits.args.mediaFiles.args[tostring(configOrder)] = {
			order = configOrder,
			type = "description",
			name = blue(author),
		}
		configOrder = configOrder + 1

		for _, source in pairs(sourceTable) do
			options.credits.args.mediaFiles.args[tostring(configOrder)] = {
				order = configOrder,
				type = "description",
				name = "  - " .. source,
			}
			configOrder = configOrder + 1
		end
	end
end

options.changelog = {
	order = 3,
	type = "group",
	childGroups = "select",
	name = L["Changelog"],
	args = {},
}

local function renderChangeLogLine(line)
	line = gsub(line, "%[[^%[]+%]", blue)
	return line
end

for version, data in pairs(W.Changelog) do
	local versionString = format("%d.%02d", version / 100, mod(version, 100))
	local changelogVer = tonumber(versionString)
	local addonVer = tonumber(W.Version)
	local dateTable = { strsplit("/", data.RELEASE_DATE) }
	local dateString = data.RELEASE_DATE
	if #dateTable == 3 then
		dateString = L["%month%-%day%-%year%"]
		dateString = gsub(dateString, "%%year%%", dateTable[1])
		dateString = gsub(dateString, "%%month%%", dateTable[2])
		dateString = gsub(dateString, "%%day%%", dateTable[3])
	end

	options.changelog.args[tostring(version)] = {
		order = 1000 - version,
		name = versionString,
		type = "group",
		args = {},
	}

	local page = options.changelog.args[tostring(version)].args

	page.date = {
		order = 1,
		type = "description",
		name = "|cffbbbbbb" .. dateString .. " " .. L["Released"] .. "|r",
		fontSize = "small",
	}

	page.version = {
		order = 2,
		type = "description",
		name = L["Version"] .. " " .. blue(versionString),
		fontSize = "large",
	}

	local importantPart = data.IMPORTANT and (data.IMPORTANT[E.global.general.locale] or data.IMPORTANT["enUS"])
	if importantPart and #importantPart > 0 then
		page.importantHeader = {
			order = 3,
			type = "header",
			name = blue(L["Important"]),
		}
		page.important = {
			order = 4,
			type = "description",
			name = function()
				local text = ""
				for index, line in ipairs(importantPart) do
					text = text .. format("%02d", index) .. ". " .. renderChangeLogLine(line) .. "\n"
				end
				return text .. "\n"
			end,
			fontSize = "medium",
		}
	end

	local newPart = data.NEW and (data.NEW[E.global.general.locale] or data.NEW["enUS"])
	if newPart and #newPart > 0 then
		page.newHeader = {
			order = 5,
			type = "header",
			name = blue(L["New"]),
		}
		page.new = {
			order = 6,
			type = "description",
			name = function()
				local text = ""
				for index, line in ipairs(newPart) do
					text = text .. format("%02d", index) .. ". " .. renderChangeLogLine(line) .. "\n"
				end
				return text .. "\n"
			end,
			fontSize = "medium",
		}
	end

	local improvementPart = data.IMPROVEMENT and (data.IMPROVEMENT[E.global.general.locale] or data.IMPROVEMENT["enUS"])
	if improvementPart and #improvementPart > 0 then
		page.improvementHeader = {
			order = 7,
			type = "header",
			name = blue(L["Improvement"]),
		}
		page.improvement = {
			order = 8,
			type = "description",
			name = function()
				local text = ""
				for index, line in ipairs(improvementPart) do
					text = text .. format("%02d", index) .. ". " .. renderChangeLogLine(line) .. "\n"
				end
				return text .. "\n"
			end,
			fontSize = "medium",
		}
	end

	page.beforeConfirm1 = {
		order = 9,
		type = "description",
		name = " ",
		width = "full",
		hidden = function()
			local dbVer = E.global.WT and E.global.WT.changelogRead and tonumber(E.global.WT.changelogRead)
			return dbVer and dbVer >= changelogVer or addonVer < changelogVer
		end,
	}

	page.beforeConfirm2 = {
		order = 10,
		type = "description",
		name = " ",
		width = "full",
		hidden = function()
			local dbVer = E.global.WT and E.global.WT.changelogRead and tonumber(E.global.WT.changelogRead)
			return dbVer and dbVer >= changelogVer or addonVer < changelogVer
		end,
	}

	page.confirm = {
		order = 11,
		type = "execute",
		name = C.StringByTemplate(L["I got it!"], "primary"),
		desc = L["Mark as read, the changelog message will be hidden when you login next time."],
		width = "full",
		hidden = function()
			local dbVer = E.global.WT and E.global.WT.changelogRead and tonumber(E.global.WT.changelogRead)
			return dbVer and dbVer >= changelogVer or addonVer < changelogVer
		end,
		func = function()
			E.global.WT.changelogRead = versionString
		end,
	}
end
