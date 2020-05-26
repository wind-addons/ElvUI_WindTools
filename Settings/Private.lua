local W, F, E, L, V, P, G = unpack(select(2, ...))

V.maps = {
	worldMap = {
		reveal = true
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
	saveArtifact = true
}

V.skins = {
	color = {
		r = 0,
		g = 0,
		b = 0
	},
	windtools = true,
	addons = {
		ace3 = true,
		bigwigs = true
	},
	blizzard = {
		enable = true,
		achievements = true,
		addonManager = true,
		adventureMap = true,
		alerts = true,
		auctionHouse = true,
		barberShop = true,
		calendar = true,
		challenges = true,
		character = true,
		collections = true,
		communities = true,
		debugTools = true,
		dressingRoom = true,
		encounterJournal = true,
		friends = true,
		garrison = true,
		gossip = true,
		help = true,
		ime = true,
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
		quest = true,
		raidInfo = true,
		raidUtility = true,
		scenario = true,
		spellBook = true,
		staticPopup = true,
		talent = true,
		taxi = true,
		tooltips = true,
		warboard = true,
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
		miniMap = true,
		option = true,
		panels = true,
		staticPopup = true,
		statusReport = true,
		unitFrames = true
	}
}

V.tooltips = {
	icon = true,
	progression = {
		enable = true,
		raid = {
			enable = true,
			["Uldir"] = true,
			["Battle of Dazaralor"] = true,
			["Crucible of Storms"] = true,
			["Azshara's Eternal Palace"] = true,
			["Ny'alotha, The Waking City"] = true
		},
		dungeon = {
			enable = true,
			["Atal'Dazar"] = true,
			["FreeHold"] = true,
			["Kings' Rest"] = true,
			["Shrine of the Storm"] = true,
			["Siege of Boralus"] = true,
			["Temple of Sethrealiss"] = true,
			["The MOTHERLODE!!"] = true,
			["The Underrot"] = true,
			["Tol Dagor"] = true,
			["Waycrest Manor"] = true,
			["Operation: Mechagon"] = true
		}
	}
}
