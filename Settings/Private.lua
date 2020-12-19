local W, F, E, L, V, P, G = unpack(select(2, ...))

V.combat = {
	talentManager = {
		enable = true,
		itemButtons = true,
		pvpTalent = false,
		statusIcon = true,
		sets = {}
	}
}

V.maps = {
	instanceDifficulty = {
		enable = false,
		hideBlizzard = true,
		align = "LEFT",
		font = {
			name = E.db.general.font,
			size = E.db.general.fontSize,
			style = "OUTLINE"
		}
	},
	superTracker = {
		enable = true,
		noLimit = false,
		autoTrackWaypoint = true,
		rightClickToClear = true,
		distanceText = {
			enable = true,
			name = E.db.general.font,
			size = E.db.general.fontSize + 2,
			style = "OUTLINE",
			color = {r = 1, g = 1, b = 1},
			onlyNumber = false
		}
	},
	worldMap = {
		enable = true,
		reveal = true,
		scale = {
			enable = true,
			size = 1.24
		}
	},
	minimapButtons = {
		enable = true,
		mouseOver = false,
		buttonsPerRow = 6,
		buttonSize = 30,
		backdrop = true,
		backdropSpacing = 3,
		spacing = 2,
		inverseDirection = false,
		orientation = "HORIZONTAL",
		calendar = false,
		garrison = false
	}
}

V.misc = {
	autoScreenshot = false,
	saveArtifact = true,
	pauseToSlash = true,
	noKanjiMath = false,
	skipCutScene = false,
	moveBlizzardFrames = true,
	moveElvUIBags = true,
	moveSpeed = false,
	rememberPositions = false,
	framePositions = {},
	tags = true,
	mute = {
		enable = false,
		mount = {
			[63796] = false,
			[229385] = false,
			[339588] = false,
			[312762] = false
		}
	},
	lfgList = {
		enable = true,
		icon = {
			reskin = true,
			pack = "SQUARE",
			size = 16,
			border = false,
			alpha = 1
		},
		line = {
			enable = true,
			tex = "WindTools Glow",
			width = 16,
			height = 3,
			offsetX = 0,
			offsetY = -1,
			alpha = 1
		}
	}
}

V.quest = {
	objectiveTracker = {
		enable = true,
		noDash = true,
		colorfulProgress = true,
		percentage = false,
		colorfulPercentage = false,
		showMawBuffRight = false,
		header = {
			name = E.db.general.font,
			size = E.db.general.fontSize + 2,
			style = "OUTLINE",
			shortHeader = true
		},
		title = {
			name = E.db.general.font,
			size = E.db.general.fontSize + 1,
			style = "OUTLINE"
		},
		info = {
			name = E.db.general.font,
			size = E.db.general.fontSize - 1,
			style = "OUTLINE"
		},
		titleColor = {
			enable = true,
			classColor = false,
			customColorNormal = {r = 0.000, g = 0.659, b = 1.000},
			customColorHighlight = {r = 0.282, g = 0.859, b = 0.984}
		}
	}
}

V.skins = {
	enable = true,
	windtools = true,
	removeParchment = true,
	merathilisUISkin = true,
	shadow = true,
	increasedSize = 0,
	color = {
		r = 0,
		g = 0,
		b = 0
	},
	ime = {
		label = {
			name = F.GetCompatibleFont("Montserrat"),
			size = 14,
			style = "OUTLINE"
		},
		candidate = {
			name = E.db.general.font,
			size = E.db.general.fontSize,
			style = "OUTLINE"
		}
	},
	errorMessage = {
		name = E.db.general.font,
		size = 15,
		style = "OUTLINE"
	},
	addons = {
		ace3 = true,
		azerothAutoPilot = true,
		bigWigs = true,
		bigWigsQueueTimer = true,
		bugSack = true,
		hekili = true,
		immersion = true,
		meetingStone = true,
		myslot = true,
		premadeGroupsFilter = true,
		rehack = true,
		rematch = true,
		tinyInspect = true,
		weakAuras = true,
		weakAurasOptions = true
	},
	blizzard = {
		enable = true,
		achievements = true,
		addonManager = true,
		adventureMap = true,
		alerts = true,
		animaDiversion = true,
		artifact = true,
		auctionHouse = true,
		azerite = true,
		azeriteEssence = true,
		azeriteRespec = true,
		barberShop = true,
		binding = true,
		blackMarket = true,
		calendar = true,
		challenges = true,
		channels = true,
		character = true,
		chromieTime = true,
		collections = true,
		communities = true,
		covenantRenown = true,
		covenantPreview = true,
		covenantSanctum = true,
		debugTools = true,
		dressingRoom = true,
		encounterJournal = true,
		flightMap = true,
		friends = true,
		garrison = true,
		gossip = true,
		guild = true,
		guildBank = true,
		help = true,
		inputMethodEditor = true,
		inspect = true,
		lookingForGroup = true,
		loot = true,
		lossOfControl = true,
		macro = true,
		mail = true,
		merchant = true,
		microButtons = true,
		mirrorTimers = true,
		misc = true,
		objectiveTracker = true,
		orderHall = true,
		petBattle = true,
		playerChoice = true,
		quest = true,
		raidInfo = true,
		scenario = true,
		scrappingMachine = true,
		soulbinds = true,
		spellBook = true,
		staticPopup = true,
		subscriptionInterstitial = true,
		talent = true,
		talkingHead = true,
		taxi = true,
		timeManager = true,
		tooltips = true,
		trade = true,
		tradeSkill = true,
		trainer = true,
		tutorial = true,
		warboard = true,
		weeklyRewards = true,
		worldMap = true
	},
	elvui = {
		enable = true,
		actionBarsBackdrop = true,
		actionBarsButton = true,
		afk = true,
		altPowerBar = true,
		auras = true,
		bags = true,
		castBars = true,
		chatDataPanels = true,
		chatPanels = true,
		classBars = true,
		chatCopyFrame = true,
		dataBars = true,
		dataPanels = true,
		miniMap = true,
		option = true,
		panels = true,
		raidUtility = true,
		staticPopup = true,
		statusReport = true,
		totemBar = true,
		unitFrames = true
	}
}

V.tooltips = {
	icon = true,
	objectiveProgress = true,
	objectiveProgressAccuracy = 1,
	progression = {
		enable = true,
		raids = {
			enable = true,
			["Castle Nathria"] = true,
			["Ny'alotha, The Waking City"] = true
		},
		mythicDungeons = {
			enable = true,
			["The Necrotic Wake"] = true,
			["Plaguefall"] = true,
			["Mists of Tirna Scithe"] = true,
			["Halls of Atonement"] = true,
			["Theater of Pain"] = true,
			["De Other Side"] = true,
			["Spires of Ascension"] = true,
			["Sanguine Depths"] = true
		}
	}
}

V.social = {
	smartTab = {
		whisperTargets = {}
	}
}

V.unitFrames = {
	quickFocus = {
		enable = true,
		modifier = "shift",
		button = "BUTTON1"
	},
	roleIcon = {
		enable = true,
		roleIconStyle = "SUNUI"
	}
}

V.core = {
	debugMode = false,
	compatibilityCheck = true
}
