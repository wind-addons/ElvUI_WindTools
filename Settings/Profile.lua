local W, F, E, L, V, P, G = unpack(select(2, ...))

P.combat = {
    combatAlert = {
        enable = true,
        speed = 1,
        animation = true,
        animationSize = 1,
        text = true,
        enterText = L["Enter Combat"],
        leaveText = L["Leave Combat"],
        enterColor = {r = 0.929, g = 0.11, b = 0.141, a = 1},
        leaveColor = {r = 1, g = 0.914, b = 0.184, a = 1},
        font = {
            name = E.db.general.font,
            size = 25,
            style = "OUTLINE"
        }
    },
    raidMarkers = {
        enable = true,
        mouseOver = false,
        visibility = "DEFAULT",
        backdrop = true,
        backdropSpacing = 3,
        buttonSize = 30,
        spacing = 4,
        orientation = "HORIZONTAL",
        modifier = "shift"
    }
}

P.item = {
    delete = {
        enable = true,
        delKey = true,
        fillIn = "CLICK"
    },
    alreadyKnown = {
        enable = true,
        mode = "COLOR",
        color = {
            r = 0,
            g = 1,
            b = 0
        }
    },
    fastLoot = {
        enable = true,
        limit = 0.3
    }
}

P.maps = {
    worldMap = {
        scale = 1.236
    }
}

P.skins = {
    vignetting = {
        enable = true,
        level = 30
    }
}

P.social = {
    chatBar = {
        enable = true,
        style = "BLOCK",
        blockShadow = true,
        autoHide = false,
        mouseOver = false,
        backdrop = true,
        backdropSpacing = 3,
        buttonWidth = 40,
        buttonHeight = 8,
        spacing = 5,
        orientation = "HORIZONTAL",
        tex = "Melli",
        font = {
            name = E.db.general.font,
            size = 12,
            style = "OUTLINE"
        },
        color = true,
        channels = {
            ["SAY"] = {
                enable = true,
                cmd = "s",
                color = {r = 1, g = 1, b = 1, a = 1},
                abbr = L["[ABBR] Say"]
            },
            ["YELL"] = {
                enable = true,
                cmd = "y",
                color = {r = 1, g = 0.25, b = 0.25, a = 1},
                abbr = L["[ABBR] Yell"]
            },
            ["EMOTE"] = {
                enable = false,
                cmd = "e",
                color = {r = 1, g = 0.5, b = 0.25, a = 1},
                abbr = L["[ABBR] Emote"]
            },
            ["PARTY"] = {
                enable = true,
                cmd = "p",
                color = {r = 0.67, g = 0.67, b = 1, a = 1},
                abbr = L["[ABBR] Party"]
            },
            ["INSTANCE"] = {
                enable = true,
                cmd = "i",
                color = {r = 1, g = 0.73, b = 0.2, a = 1},
                abbr = L["[ABBR] Instance"]
            },
            ["RAID"] = {
                enable = true,
                cmd = "raid",
                color = {r = 1, g = 0.5, b = 0, a = 1},
                abbr = L["[ABBR] Raid"]
            },
            ["RAID_WARNING"] = {
                enable = false,
                cmd = "rw",
                color = {r = 1, g = 0.28, b = 0, a = 1},
                abbr = L["[ABBR] RaidWarning"]
            },
            ["GUILD"] = {
                enable = true,
                cmd = "g",
                color = {r = 0.25, g = 1, b = 0.25, a = 1},
                abbr = L["[ABBR] Guild"]
            },
            ["OFFICER"] = {
                enable = false,
                cmd = "o",
                color = {r = 0.25, g = 0.75, b = 0.25, a = 1},
                abbr = L["[ABBR] Officer"]
            },
            world = {
                enable = false,
                autoJoin = true,
                name = "",
                color = {r = 0.2, g = 0.6, b = 0.86, a = 1},
                abbr = L["[ABBR] World"]
            },
            community = {
                enable = false,
                name = "",
                color = {r = 0.72, g = 0.27, b = 0.86, a = 1},
                abbr = L["[ABBR] Community"]
            },
            emote = {
                enable = true,
                icon = true,
                color = {r = 1, g = 0.33, b = 0.52, a = 1},
                abbr = L["[ABBR] Wind Emote"]
            },
            roll = {
                enable = true,
                icon = true,
                color = {r = 0.56, g = 0.56, b = 0.56, a = 1},
                abbr = L["[ABBR] Roll"]
            }
        }
    },
    friendList = {
        enable = true,
        hideMaxLevel = true,
        useGameColor = true,
        useClassColor = true,
        textures = {
            game = "Modern",
            status = "Square"
        },
        areaColor = {
            r = 1,
            g = 1,
            b = 1
        },
        nameFont = {
            name = E.db.general.font,
            size = 13,
            style = "OUTLINE"
        },
        infoFont = {
            name = E.db.general.font,
            size = 12,
            style = "OUTLINE"
        }
    },
    filter = {
        enable = true,
        unblockProfanityFilter = true
    }
}
