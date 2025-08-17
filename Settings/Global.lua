local W, F, E, L, V, P, G = unpack((select(2, ...)))

G.core = {
	compatibilityCheck = true,
	changlogPopup = false,
	elvUIVersionPopup = true,
	cvarAlert = false,
	advancedCLEUEventTrace = false,
	logLevel = 2,
	loginMessage = true,
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
	gameBar = {
		covenantCache = {},
	},
	watched = {
		movies = {},
	},
	lfgList = {},
}

G.maps = {
	eventTracker = {},
}
