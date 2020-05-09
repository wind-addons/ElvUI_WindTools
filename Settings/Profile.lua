local W, F, E, L, V, P, G = unpack(select(2, ...))

P.combat = {
    combatAlert = {
        enable = true,
        text = true,
        speed = 1,
        animation = true,
        animationSize = 1,
        enterText = L["Enter Combat"],
        leaveText = L["Leave Combat"],
        enterColor = {r = 0.929, g = 0.11, b = 0.141, a = 1.0},
        leaveColor = {r = 1, g = 0.914, b = 0.184, a = 1.0},
        font = {name = E.db.general.font, size = 25, style = "OUTLINE"}
    }
}

P.maps = {
    worldMap = {
        scale = 1.236
    }
}
