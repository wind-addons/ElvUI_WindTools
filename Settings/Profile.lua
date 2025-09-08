local P ---@class ProfileDB
local W, F, E, L, V, G ---@type WindTools, Functions, ElvUI, table, PrivateDB, GlobalDB
W, F, E, L, V, P, G = unpack((select(2, ...)))

---@cast W WindTools
local C = W.Utilities.Color

local tinsert = tinsert

P.announcement = {
	enable = true,
	emoteFormat = ": %s",
	sameMessageInterval = 10,
	combatResurrection = {
		enable = true,
		onlySourceIsPlayer = false,
		raidWarning = false,
		text = L["%player% cast %spell% -> %target%"],
		channel = {
			solo = "NONE",
			party = "PARTY",
			instance = "INSTANCE_CHAT",
			raid = "RAID",
		},
	},
	goodbye = {
		enable = false,
		text = L["Thanks all!"],
		delay = 3,
		channel = {
			party = "PARTY",
			instance = "INSTANCE_CHAT",
			raid = "RAID",
		},
	},
	dispel = {
		enable = false,
		onlyInstance = true,
		player = {
			enable = true,
			text = L["I dispelled %target%'s %target_spell%!"],
			channel = {
				solo = "NONE",
				party = "PARTY",
				instance = "INSTANCE_CHAT",
				raid = "RAID",
			},
		},
		others = {
			enable = false,
			text = L["%player% dispelled %target%'s %target_spell%!"],
			channel = {
				party = "EMOTE",
				instance = "NONE",
				raid = "NONE",
			},
		},
	},
	interrupt = {
		enable = true,
		onlyInstance = true,
		player = {
			enable = true,
			text = L["I interrupted %target%'s %target_spell%!"],
			channel = {
				solo = "NONE",
				party = "PARTY",
				instance = "INSTANCE_CHAT",
				raid = "RAID",
			},
		},
		others = {
			enable = false,
			text = L["%player% interrupted %target%'s %target_spell%!"],
			channel = {
				party = "EMOTE",
				instance = "NONE",
				raid = "NONE",
			},
		},
	},
	quest = {
		enable = false,
		paused = true,
		disableBlizzard = true,
		includeDetails = true,
		channel = {
			party = "PARTY",
			instance = "INSTANCE_CHAT",
			raid = "RAID",
		},
		tag = {
			enable = true,
			color = C.GetRGBFromTemplate("yellow-300"),
		},
		suggestedGroup = {
			enable = true,
			color = C.GetRGBFromTemplate("rose-500"),
		},
		level = {
			enable = true,
			color = C.GetRGBFromTemplate("emerald-400"),
			hideOnMax = true,
		},
		daily = {
			enable = true,
			color = C.GetRGBFromTemplate("cyan-500"),
		},
		weekly = {
			enable = true,
			color = C.GetRGBFromTemplate("blue-500"),
		},
	},
	resetInstance = {
		enable = true,
		prefix = true,
		channel = {
			party = "PARTY",
			instance = "INSTANCE_CHAT",
			raid = "RAID",
		},
	},
	taunt = {
		enable = false,
		player = {
			player = {
				enable = true,
				tauntAllText = L["I taunted all enemies!"],
				successText = L["I taunted %target% successfully!"],
				failedText = L["I failed on taunting %target%!"],
				channel = {
					solo = "NONE",
					party = "PARTY",
					instance = "INSTANCE_CHAT",
					raid = "RAID",
				},
			},
			pet = {
				enable = true,
				successText = L["My %pet_role% %pet% taunted %target% successfully!"],
				failedText = L["My %pet_role% %pet% failed on taunting %target%!"],
				channel = {
					solo = "NONE",
					party = "PARTY",
					instance = "INSTANCE_CHAT",
					raid = "RAID",
				},
			},
		},
		others = {
			player = {
				enable = true,
				tauntAllText = L["%player% taunted all enemies!"],
				successText = L["%player% taunted %target% successfully!"],
				failedText = L["%player% failed on taunting %target%!"],
				channel = {
					party = "SELF",
					instance = "SELF",
					raid = "SELF",
				},
			},
			pet = {
				enable = true,
				successText = L["%player%'s %pet_role% %pet% taunted %target% successfully!"],
				failedText = L["%player%'s %pet_role% %pet% failed on taunting %target%!"],
				channel = {
					party = "SELF",
					instance = "SELF",
					raid = "SELF",
				},
			},
		},
	},
	thanks = {
		enable = false,
		resurrection = true,
		enhancement = true,
		resurrectionText = L["%target%, thank you for using %spell% to revive me. :)"],
		enhancementText = L["%target%, thank you for %spell%. :)"],
		delay = 0,
		channel = {
			solo = "WHISPER",
			party = "WHISPER",
			instance = "WHISPER",
			raid = "WHISPER",
		},
	},
	threatTransfer = {
		enable = true,
		onlyNotTank = true,
		forceSourceIsPlayer = true,
		forceDestIsPlayer = false,
		raidWarning = false,
		text = L["%player% cast %spell% -> %target%"],
		channel = {
			solo = "NONE",
			party = "PARTY",
			instance = "INSTANCE_CHAT",
			raid = "RAID",
		},
	},
	utility = {
		enable = true,
		channel = {
			solo = "NONE",
			party = "PARTY",
			instance = "INSTANCE_CHAT",
			raid = "RAID",
		},
		spells = {
			["698"] = {
				-- 召喚儀式
				enable = true,
				includePlayer = true,
				raidWarning = true,
				text = L["%player% is casting %spell%, please assist!"],
			},
			["29893"] = {
				-- 靈魂之井
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["%player% is handing out cookies, go and get one!"],
			},
			["54710"] = {
				-- MOLL-E 郵箱
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["%player% puts %spell%"],
			},
			["261602"] = {
				-- 凱蒂的郵哨
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["%player% used %spell%"],
			},
			["384911"] = {
				-- 原子校準器
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["%player% used %spell%"],
			},
			["290154"] = {
				-- 塑形師道標
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["%player% used %spell%"],
			},
			["376664"] = {
				-- 歐胡納鷹棲所
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["%player% used %spell%"],
			},
			["195782"] = {
				-- 召喚月羽雕像
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["%player% used %spell%"],
			},
			["190336"] = {
				-- 召喚餐點桌
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["%player% cast %spell%, today's special is Anchovy Pie!"],
			},
			feasts = {
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["OMG, wealthy %player% puts %spell%!"],
			},
			bots = {
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["%player% puts %spell%"],
			},
			toys = {
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["%player% puts %spell%"],
			},
			portals = {
				enable = true,
				includePlayer = true,
				raidWarning = false,
				text = L["%player% opened %spell%!"],
			},
		},
	},
	keystone = {
		enable = true,
		text = L["My new keystone is %keystone%."],
		channel = {
			party = "PARTY",
		},
		command = true,
	},
}

P.combat = {
	classHelper = {
		enable = false,
		deathStrikeEstimator = {
			enable = false,
			width = 4,
			height = 30,
			yOffset = 0,
			sparkTexture = false,
			texture = "ElvUI Blank",
			color = { r = 1, g = 0.2, b = 0.2, a = 1 },
			onlyInCombat = false,
			hideIfTheBarOutside = false,
		},
	},
	combatAlert = {
		enable = true,
		speed = 1,
		animation = true,
		animationSize = 1,
		text = true,
		enterText = L["Enter Combat"],
		leaveText = L["Leave Combat"],
		enterColor = { r = 0.929, g = 0.11, b = 0.141, a = 1 },
		leaveColor = { r = 0.227, g = 1, b = 0.6, a = 1 },
		font = {
			name = E.db.general.font,
			size = 25,
			style = "OUTLINE",
		},
	},
	raidMarkers = {
		enable = true,
		mouseOver = false,
		tooltip = true,
		visibility = "DEFAULT",
		backdrop = true,
		backdropSpacing = 3,
		buttonSize = 30,
		buttonBackdrop = true,
		buttonAnimation = true,
		buttonAnimationDuration = 0.2,
		buttonAnimationScale = 1.33,
		spacing = 4,
		orientation = "HORIZONTAL",
		modifier = "shift",
		readyCheck = true,
		countDown = true,
		countDownTime = 5,
		inverse = false,
	},
	quickKeystone = {
		enable = true,
	},
}

P.item = {
	contacts = {
		enable = true,
		defaultPage = "ALTS",
	},
	delete = {
		enable = true,
		delKey = true,
		fillIn = "CLICK",
	},
	alreadyKnown = {
		enable = true,
		mode = "COLOR",
		color = {
			r = 0,
			g = 1,
			b = 0,
		},
	},
	fastLoot = {
		enable = true,
		limit = 0.3,
	},
	trade = {
		enable = true,
		thanksButton = true,
		thanksText = L["Thank you!"],
	},
	extraItemsBar = {
		enable = true,
		customList = {},
		blackList = {
			[183040] = true, -- 恆冬符咒
			[193757] = true, -- 晶紅幼龍之殼
			[200563] = true, -- 洪荒儀式龜殼
			[219381] = true, -- 命運編織者
			[237494] = true, -- 神聖典籍
			[237495] = true, -- 怨毒摘錄
			[242664] = true, -- 耐用的情報收集器
			[245964] = true, -- 耐用的情報收集器
			[245965] = true, -- 耐用的情報收集器
			[245966] = true, -- 耐用的情報收集器
		},
		bar1 = {
			enable = true,
			mouseOver = false,
			globalFade = false,
			visibility = "[petbattle]hide;show",
			fadeTime = 0.3,
			alphaMin = 0,
			alphaMax = 1,
			numButtons = 12,
			backdrop = true,
			backdropSpacing = 3,
			buttonWidth = 35,
			buttonHeight = 30,
			buttonsPerRow = 12,
			anchor = "TOPLEFT",
			spacing = 3,
			tooltip = true,
			qualityTier = {
				size = 16,
				xOffset = 0,
				yOffset = 0,
			},
			countFont = {
				name = F.GetCompatibleFont("Montserrat"),
				size = 12,
				style = "OUTLINE",
				xOffset = 0,
				yOffset = 0,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
			bindFont = {
				name = F.GetCompatibleFont("Montserrat"),
				size = 12,
				style = "OUTLINE",
				xOffset = 0,
				yOffset = 0,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
			include = "QUEST,BANNER,EQUIP,PROF,HOLIDAY,OPENABLE,DELVE",
		},
		bar2 = {
			enable = true,
			mouseOver = false,
			globalFade = false,
			visibility = "[petbattle]hide;show",
			fadeTime = 0.3,
			alphaMin = 0,
			alphaMax = 1,
			numButtons = 12,
			backdrop = true,
			backdropSpacing = 3,
			buttonWidth = 35,
			buttonHeight = 30,
			buttonsPerRow = 12,
			anchor = "TOPLEFT",
			spacing = 3,
			tooltip = true,
			qualityTier = {
				size = 16,
				xOffset = 0,
				yOffset = 0,
			},
			countFont = {
				name = F.GetCompatibleFont("Montserrat"),
				size = 12,
				style = "OUTLINE",
				xOffset = 0,
				yOffset = 0,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
			bindFont = {
				name = F.GetCompatibleFont("Montserrat"),
				size = 12,
				style = "OUTLINE",
				xOffset = 0,
				yOffset = 0,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
			include = "POTIONTWW,FLASKTWW,VANTUSTWW,UTILITY",
		},
		bar3 = {
			enable = true,
			mouseOver = false,
			globalFade = false,
			visibility = "[petbattle]hide;show",
			fadeTime = 0.3,
			alphaMin = 0,
			alphaMax = 1,
			numButtons = 12,
			backdrop = true,
			backdropSpacing = 3,
			buttonWidth = 35,
			buttonHeight = 30,
			buttonsPerRow = 12,
			anchor = "TOPLEFT",
			spacing = 3,
			tooltip = true,
			qualityTier = {
				size = 16,
				xOffset = 0,
				yOffset = 0,
			},
			countFont = {
				name = F.GetCompatibleFont("Montserrat"),
				size = 12,
				style = "OUTLINE",
				xOffset = 0,
				yOffset = 0,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
			bindFont = {
				name = F.GetCompatibleFont("Montserrat"),
				size = 12,
				style = "OUTLINE",
				xOffset = 0,
				yOffset = 0,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
			include = "MAGEFOOD,FOODVENDOR,FOODTWW,RUNETWW,CUSTOM",
		},
		bar4 = {
			enable = false,
			mouseOver = false,
			globalFade = false,
			visibility = "[petbattle]hide;show",
			fadeTime = 0.3,
			alphaMin = 0,
			alphaMax = 1,
			numButtons = 12,
			backdrop = true,
			backdropSpacing = 3,
			buttonWidth = 35,
			buttonHeight = 30,
			buttonsPerRow = 12,
			anchor = "TOPLEFT",
			spacing = 3,
			tooltip = true,
			qualityTier = {
				size = 16,
				xOffset = 0,
				yOffset = 0,
			},
			countFont = {
				name = F.GetCompatibleFont("Montserrat"),
				size = 12,
				style = "OUTLINE",
				xOffset = 0,
				yOffset = 0,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
			bindFont = {
				name = F.GetCompatibleFont("Montserrat"),
				size = 12,
				style = "OUTLINE",
				xOffset = 0,
				yOffset = 0,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
			include = "CUSTOM",
		},
		bar5 = {
			enable = false,
			mouseOver = false,
			globalFade = false,
			visibility = "[petbattle]hide;show",
			fadeTime = 0.3,
			alphaMin = 0,
			alphaMax = 1,
			numButtons = 12,
			backdrop = true,
			backdropSpacing = 3,
			buttonWidth = 35,
			buttonHeight = 30,
			buttonsPerRow = 12,
			anchor = "TOPLEFT",
			spacing = 3,
			tooltip = true,
			qualityTier = {
				size = 16,
				xOffset = 0,
				yOffset = 0,
			},
			countFont = {
				name = F.GetCompatibleFont("Montserrat"),
				size = 12,
				style = "OUTLINE",
				xOffset = 0,
				yOffset = 0,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
			bindFont = {
				name = F.GetCompatibleFont("Montserrat"),
				size = 12,
				style = "OUTLINE",
				xOffset = 0,
				yOffset = 0,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
			include = "CUSTOM",
		},
	},
	inspect = {
		enable = true,
		player = true,
		inspect = true,
		stats = true,
		playerOnInspect = true,
		slotText = {
			name = E.db.general.font,
			size = W.CompatibleFont and 12 or 9,
			style = "OUTLINE",
		},
		levelText = {
			name = F.GetCompatibleFont("Montserrat"),
			size = 13,
			style = "OUTLINE",
		},
		equipText = {
			name = E.db.general.font,
			size = 13,
			style = "OUTLINE",
		},
		statsText = {
			name = E.db.general.font,
			size = 13,
			style = "OUTLINE",
		},
	},
	itemLevel = {
		enable = true,
		flyout = {
			enable = true,
			useBagsFontSetting = false,
			qualityColor = true,
			font = {
				name = F.GetCompatibleFont("Montserrat"),
				size = 11,
				style = "OUTLINE",
				xOffset = 0,
				yOffset = 0,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
		},
		scrappingMachine = {
			enable = true,
			useBagsFontSetting = false,
			qualityColor = true,
			font = {
				name = F.GetCompatibleFont("Montserrat"),
				size = 13,
				style = "OUTLINE",
				xOffset = 0,
				yOffset = 0,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
		},
	},
}

P.maps = {
	eventTracker = {
		enable = true,
		style = {
			backdrop = true,
			backdropYOffset = 3,
			backdropSpacing = 6,
			trackerWidth = 240,
			trackerHeight = 30,
			trackerHorizontalSpacing = 10,
			trackerVerticalSpacing = 2,
		},
		font = {
			name = E.db.general.font,
			scale = 1,
			outline = "OUTLINE",
		},
		professionsWeeklyTWW = {
			enable = true,
			desaturate = true,
		},
		weeklyTWW = {
			enable = true,
			desaturate = true,
		},
		ecologicalSuccession = {
			enable = true,
			desaturate = true,
		},
		nightFall = {
			enable = true,
			desaturate = true,
			alert = true,
			sound = true,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = true,
		},
		theaterTroupe = {
			enable = true,
			desaturate = true,
			alert = true,
			sound = true,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = true,
		},
		ringingDeeps = {
			enable = true,
			desaturate = true,
		},
		spreadingTheLight = {
			enable = true,
			desaturate = true,
		},
		underworldOperative = {
			enable = true,
			desaturate = true,
		},
		radiantEchoes = {
			enable = false,
			desaturate = false,
			alert = false,
			sound = true,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = true,
			stopAlertIfPlayerNotEnteredDragonlands = true,
		},
		communityFeast = {
			enable = false,
			desaturate = false,
			alert = false,
			sound = false,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = true,
			stopAlertIfPlayerNotEnteredDragonlands = true,
		},
		siegeOnDragonbaneKeep = {
			enable = false,
			desaturate = false,
			alert = false,
			sound = false,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = true,
			stopAlertIfPlayerNotEnteredDragonlands = true,
		},
		researchersUnderFire = {
			enable = false,
			desaturate = false,
			alert = false,
			sound = false,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = true,
			stopAlertIfPlayerNotEnteredDragonlands = true,
		},
		timeRiftThaldraszus = {
			enable = false,
			desaturate = false,
			alert = false,
			sound = false,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = false,
			stopAlertIfPlayerNotEnteredDragonlands = true,
		},
		superBloom = {
			enable = false,
			desaturate = false,
			alert = false,
			sound = false,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = true,
			stopAlertIfPlayerNotEnteredDragonlands = true,
		},
		bigDig = {
			enable = false,
			desaturate = false,
			alert = false,
			sound = true,
			soundFile = "OnePlus Surprise",
			second = 600,
			stopAlertIfCompleted = false,
			stopAlertIfPlayerNotEnteredDragonlands = true,
		},
		iskaaranFishingNet = {
			enable = false,
			alert = false,
			sound = true,
			soundFile = "OnePlus Surprise",
			disableAlertAfterHours = 48,
		},
	},
	rectangleMinimap = {
		enable = false,
		heightPercentage = 0.8,
	},
	whoClicked = {
		enable = true,
		xOffset = 0,
		yOffset = 2,
		fadeInTime = 0.5,
		stayTime = 3,
		fadeOutTime = 0.5,
		addRealm = false,
		onlyOnCombat = true,
		classColor = true,
		customColor = { r = 1, g = 1, b = 1 },
		font = {
			name = E.db.general.font,
			size = 14,
			style = "OUTLINE",
		},
	},
}

P.skins = {
	vignetting = {
		enable = true,
		level = 30,
	},
}

P.social = {
	chatBar = {
		enable = true,
		style = "BLOCK",
		blockShadow = true,
		autoHide = false,
		mouseOver = false,
		backdrop = false,
		backdropSpacing = 3,
		buttonWidth = 40,
		buttonHeight = 5,
		spacing = 5,
		orientation = "HORIZONTAL",
		tex = "WindTools Glow",
		font = {
			name = E.db.general.font,
			size = 12,
			style = "OUTLINE",
		},
		color = true,
		channels = {
			["SAY"] = {
				enable = true,
				cmd = "s",
				color = { r = 1, g = 1, b = 1, a = 1 },
				abbr = L["[ABBR] Say"],
			},
			["YELL"] = {
				enable = true,
				cmd = "y",
				color = { r = 1, g = 0.25, b = 0.25, a = 1 },
				abbr = L["[ABBR] Yell"],
			},
			["EMOTE"] = {
				enable = false,
				cmd = "e",
				color = { r = 1, g = 0.5, b = 0.25, a = 1 },
				abbr = L["[ABBR] Emote"],
			},
			["PARTY"] = {
				enable = true,
				cmd = "p",
				color = { r = 0.67, g = 0.67, b = 1, a = 1 },
				abbr = L["[ABBR] Party"],
			},
			["INSTANCE"] = {
				enable = true,
				cmd = "i",
				color = { r = 1, g = 0.73, b = 0.2, a = 1 },
				abbr = L["[ABBR] Instance"],
			},
			["RAID"] = {
				enable = true,
				cmd = "raid",
				color = { r = 1, g = 0.5, b = 0, a = 1 },
				abbr = L["[ABBR] Raid"],
			},
			["RAID_WARNING"] = {
				enable = false,
				cmd = "rw",
				color = { r = 1, g = 0.28, b = 0, a = 1 },
				abbr = L["[ABBR] Raid Warning"],
			},
			["GUILD"] = {
				enable = true,
				cmd = "g",
				color = { r = 0.25, g = 1, b = 0.25, a = 1 },
				abbr = L["[ABBR] Guild"],
			},
			["OFFICER"] = {
				enable = false,
				cmd = "o",
				color = { r = 0.25, g = 0.75, b = 0.25, a = 1 },
				abbr = L["[ABBR] Officer"],
			},
			world = {
				enable = false,
				config = {},
				color = { r = 0.2, g = 0.6, b = 0.86, a = 1 },
				abbr = L["[ABBR] World"],
			},
			community = {
				enable = false,
				name = "",
				color = { r = 0.72, g = 0.27, b = 0.86, a = 1 },
				abbr = L["[ABBR] Community"],
			},
			emote = {
				enable = true,
				icon = true,
				color = { r = 1, g = 0.33, b = 0.52, a = 1 },
				abbr = L["[ABBR] Wind Emote"],
			},
			roll = {
				enable = true,
				icon = true,
				color = { r = 0.56, g = 0.56, b = 0.56, a = 1 },
				abbr = L["[ABBR] Roll"],
			},
		},
	},
	chatLink = {
		enable = true,
		numericalQualityTier = false,
		translateItem = true,
		level = true,
		icon = true,
		iconWidth = 18,
		iconHeight = 16,
		armorCategory = true,
		weaponCategory = true,
		keepRatio = true,
	},
	chatText = {
		enable = true,
		abbreviation = "SHORT",
		removeBrackets = true,
		roleIconSize = 16,
		roleIconStyle = "SUNUI",
		removeRealm = true,
		customAbbreviation = {},
		classIcon = true,
		classIconStyle = "flatborder2",
		guildMemberStatus = true,
		guildMemberStatusInviteLink = true,
		mergeAchievement = true,
		bnetFriendOnline = true,
		bnetFriendOffline = false,
		factionIcon = true,
	},
	emote = {
		enable = true,
		size = 16,
		panel = true,
		chatBubbles = true,
	},
	friendList = {
		enable = true,
		level = true,
		hideMaxLevel = true,
		useClientColor = true,
		useClassColor = true,
		useNoteAsName = false,
		hideRealm = false,
		textures = {
			status = "square",
			gameIcon = "PATCH",
		},
		areaColor = {
			r = 1,
			g = 1,
			b = 1,
		},
		nameFont = {
			name = E.db.general.font,
			size = 13,
			style = "OUTLINE",
		},
		infoFont = {
			name = E.db.general.font,
			size = 12,
			style = "OUTLINE",
		},
	},
	contextMenu = {
		enable = true,
		sectionTitle = true,
		armory = W.Locale ~= "zhCN",
		armoryOverride = {},
		guildInvite = true,
		who = true,
		reportStats = false,
	},
	smartTab = {
		enable = true,
		whisperCycle = false,
		yell = false,
		battleground = false,
		raidWarning = false,
		officer = false,
		historyLimit = 10,
	},
}

if W.ChineseLocale then
	P.social.chatText.customAbbreviation[L["BigfootWorldChannel"]] = "世"
	P.social.chatText.customAbbreviation["尋求組隊"] = "世"
	P.social.chatText.customAbbreviation["組隊頻道"] = "世"

	tinsert(P.social.chatBar.channels.world.config, {
		region = "TW",
		faction = "Alliance",
		realmID = "ALL",
		name = "組隊頻道",
		autoJoin = true,
	})

	tinsert(P.social.chatBar.channels.world.config, {
		region = "TW",
		faction = "Horde",
		realmID = "ALL",
		name = "尋求組隊",
		autoJoin = true,
	})

	tinsert(P.social.chatBar.channels.world.config, {
		region = "TW",
		faction = "ALL",
		realmID = "ALL",
		name = L["BigfootWorldChannel"],
		autoJoin = true,
	})

	tinsert(P.social.chatBar.channels.world.config, {
		region = "CN",
		faction = "ALL",
		realmID = "ALL",
		name = L["BigfootWorldChannel"],
		autoJoin = true,
	})
end

P.quest = {
	switchButtons = {
		enable = true,
		tooltip = true,
		backdrop = false,
		font = {
			name = E.db.general.font,
			size = 12,
			style = "OUTLINE",
			color = { r = 1, g = 0.82, b = 0 },
		},
		announcement = true,
		turnIn = true,
	},
	turnIn = {
		enable = true,
		mode = "ALL",
		onlyRepeatable = false,
		smartChat = true,
		selectReward = true,
		getBestReward = false,
		darkmoon = true,
		followerAssignees = true,
		pauseModifier = "SHIFT",
		customIgnoreNPCs = {},
	},
}

P.tooltips = {
	elvUITweaks = {
		forceItemLevel = false,
		healthBar = {
			barYOffset = 0,
			textYOffset = 0,
		},
		raceIcon = {
			enable = true,
			width = 16,
			height = 16,
		},
		specIcon = {
			enable = true,
			width = 16,
			height = 14,
		},
		betterMythicPlusInfo = {
			enable = true,
			icon = {
				enable = true,
				width = 16,
				height = 14,
			},
		},
	},
	keystone = {
		enable = true,
		useAbbreviation = true,
		icon = {
			enable = true,
			width = 16,
			height = 14,
		},
	},
	groupInfo = {
		enable = true,
		excludeDungeon = false,
		hideBlizzard = true,
		title = false,
		mode = "NORMAL",
		classIconStyle = "flat",
		template = "{{classIcon:18}} {{specIcon:14,18}} {{classColorStart}}{{className}} ({{specName}}){{classColorEnd}}{{amountStart}} x {{amount}}{{amountEnd}}",
	},
}

P.unitFrames = {
	absorb = {
		enable = false,
		texture = {
			enable = true,
			custom = E.db.unitframe.statusbar,
			blizzardStyle = true,
		},
		blizzardOverAbsorbGlow = true,
		blizzardAbsorbOverlay = true,
	},
}

P.misc = {
	disableTalkingHead = false,
	hideCrafter = false,
	noLootPanel = false,
	spellActivationAlert = {
		enable = false,
		scale = 1,
	},
	gameBar = {
		enable = true,
		mouseOver = false,
		backdrop = true,
		backdropSpacing = 5,
		timeAreaWidth = 110,
		timeAreaHeight = 50,
		buttonSize = 24,
		spacing = 4,
		fadeTime = 0.618,
		normalColor = "DEFAULT",
		hoverColor = "CLASS",
		animation = {
			duration = 0.2,
			ease = "quadratic",
			easeInvert = false,
		},
		customNormalColor = { r = 1, g = 1, b = 1 },
		customHoverColor = { r = 0, g = 0.659, b = 1 },
		notification = true,
		visibility = "[petbattle] hide; show",
		tooltipsAnchor = "ANCHOR_BOTTOM",
		friends = {
			showAllFriends = false,
			countSubAccounts = true,
		},
		time = {
			localTime = true,
			twentyFour = true,
			flash = true,
			interval = 10,
			alwaysSystemInfo = false,
			avoidReloadInCombat = true,
			font = {
				name = F.GetCompatibleFont("Montserrat"),
				size = 25,
				style = "OUTLINE",
			},
		},
		home = {
			left = "6948",
			right = "140192",
		},
		additionalText = {
			enable = true,
			slowMode = true,
			anchor = "BOTTOMRIGHT",
			x = 3,
			y = -3,
			font = {
				name = F.GetCompatibleFont("Montserrat"),
				size = 12,
				style = "OUTLINE",
			},
		},
		left = {
			[1] = "CHARACTER",
			[2] = "SPELLBOOK",
			[3] = "TALENTS",
			[4] = "FRIENDS",
			[5] = "GUILD",
			[6] = "GROUP_FINDER",
			[7] = "SCREENSHOT",
		},
		right = {
			[1] = "HOME",
			[2] = "ACHIEVEMENTS",
			[3] = "MISSION_REPORTS",
			[4] = "ENCOUNTER_JOURNAL",
			[5] = "TOY_BOX",
			[6] = "PET_JOURNAL",
			[7] = "BAGS",
		},
	},
	automation = {
		enable = false,
		hideBagAfterEnteringCombat = false,
		hideWorldMapAfterEnteringCombat = false,
		acceptResurrect = false,
		acceptCombatResurrect = false,
		confirmSummon = false,
	},
	cooldownTextOffset = {
		enable = false,
		offsetX = 0,
		offsetY = 0,
	},
	keybindAlias = {
		enable = false,
		list = {},
	},
	exitPhaseDiving = {
		enable = true,
		width = 81,
		height = 50,
	},
}
