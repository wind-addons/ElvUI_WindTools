local W, F, E, L, V, P, G = unpack(select(2, ...))

P.combat = {
    combatAlert = {
        enable = true,
        text = true,
        animation = true,
        animateSpeed = 1,
        animationSize = 1,
        enterText = L["Enter Combat"],
        leaveText = L["Leave Combat"],
        enterColor = {r = 0.91, g = 0.3, b = 0.24, a = 1.0},
        leaveColor = {r = 0.18, g = 0.8, b = 0.44, a = 1.0},
        font = {name = E.db.general.font, size = E.db.general.fontSize + 3, style = "OUTLINE"}
    }
}

P.maps = {
    worldMap = {
        scale = 1.236
    }
}
