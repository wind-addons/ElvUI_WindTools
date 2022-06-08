local W, F, E, L, V, P, G = unpack(select(2, ...))

G.core = {
    logLevel = 2,
    compatibilityCheck = true,
    loginMessage = true
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
