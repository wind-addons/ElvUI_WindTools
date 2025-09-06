local G ---@class GlobalDB
local W, F, E, L, V, P ---@type WindTools, Functions, ElvUI, table, PrivateDB, ProfileDB
W, F, E, L, V, P, G = unpack((select(2, ...)))

G.core = {
	compatibilityCheck = true,
	changlogPopup = false,
	elvUIVersionPopup = true,
	cvarAlert = false,
	advancedCLEUEventTrace = false,
	loginMessage = true,
}

G.developer = {
	logLevel = 2,
	tableAttributeDisplay = {
		enable = false,
		width = 1000,
		height = 600,
	},
}

G.item = {
	contacts = {
		alts = {},
		favorites = {},
		updateAlts = true,
	},
}

G.combat = {
	covenantHelper = {
		soulbindRules = {
			characters = {},
		},
	},
}

G.misc = {
	watched = {
		movies = {},
	},
	lfgList = {},
}

G.maps = {
	eventTracker = {},
}
