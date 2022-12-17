local W, F, E, L, V, P, G = unpack(select(2, ...))

G.core = {
    compatibilityCheck = true,
    cvarAlert = false,
    fixPlaystyle = true,
    logLevel = 2,
    loginMessage = true,
    noDuplicatedParty = true
}

G.item = {
    contacts = {
        alts = {},
        favorites = {}
    }
}

G.combat = {
    covenantHelper = {
        soulbindRules = {
            characters = {}
        }
    }
}

G.misc = {
    gameBar = {
        covenantCache = {}
    },
    watched = {
        movies = {},
    }
}
