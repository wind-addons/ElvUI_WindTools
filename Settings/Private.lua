local W, F, E, L, V, P, G = unpack(select(2, ...))

V.combat = {}

V.item = {
    extendMerchantPages = {
        enable = false,
        numberOfPages = 2
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
            color = {r = 1, g = 1, b = 1}
        },
        waypointParse = {
            enable = true,
            worldMapInput = true,
            command = true,
            commandKeys = {
                ["wtgo"] = true,
                ["goto"] = true
            }
        }
    },
    worldMap = {
        enable = true,
        reveal = {
            enable = true,
            useColor = false,
            color = {r = 1, g = 1, b = 1, a = 1}
        },
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
    moveSpeed = false,
    noKanjiMath = false,
    pauseToSlash = true,
    skipCutScene = false,
    tags = true,
    hotKeyAboveCD = false,
    guildNewsItemLevel = true,
    moveFrames = {
        enable = true,
        elvUIBags = true,
        tradeSkillMasterCompatible = true,
        rememberPositions = false,
        framePositions = {}
    },
    mute = {
        enable = false,
        mount = {
            [63796] = false,
            [229385] = false,
            [339588] = false,
            [312762] = false
        },
        other = {
            ["Crying"] = false,
            ["Tortollan"] = false,
            ["Smolderheart"] = false,
            ["Elegy of the Eternals"] = false
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
        backdrop = {
            enable = false,
            transparent = true,
            topLeftOffsetX = 0,
            topLeftOffsetY = 0,
            bottomRightOffsetX = 0,
            bottomRightOffsetY = 0
        },
        header = {
            name = E.db.general.font,
            size = E.db.general.fontSize + 2,
            style = "OUTLINE",
            classColor = false,
            color = {r = 1, g = 1, b = 1},
            shortHeader = true
        },
        cosmeticBar = {
            enable = true,
            texture = "WindTools Glow",
            widthMode = "ABSOLUTE",
            heightMode = "ABSOLUTE",
            width = 212,
            height = 2,
            offsetX = 0,
            offsetY = -12,
            border = "SHADOW",
            borderAlpha = 1,
            color = {
                mode = "GRADIENT",
                normalColor = {r = 0.000, g = 0.659, b = 1.000, a = 1},
                gradientColor1 = {r = 0.32941, g = 0.52157, b = 0.93333, a = 1},
                gradientColor2 = {r = 0.25882, g = 0.84314, b = 0.86667, a = 1}
            }
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
    weakAurasShadow = true,
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
    widgets = {
        button = {
            enable = true,
            backdrop = {
                enable = true,
                texture = "WindTools Glow",
                classColor = false,
                color = {r = 0.145, g = 0.353, b = 0.698},
                alpha = 1,
                animationType = "FADE",
                animationDuration = 0.2,
                removeBorderEffect = true
            },
            selected = {
                enable = true,
                backdropClassColor = false,
                backdropColor = {r = 0.322, g = 0.608, b = 0.961},
                backdropAlpha = 0.4,
                borderClassColor = false,
                borderColor = {r = 0.145, g = 0.353, b = 0.698},
                borderAlpha = 1
            },
            text = {
                enable = true,
                font = {
                    name = E.db.general.font,
                    style = "OUTLINE"
                }
            }
        },
        tab = {
            enable = true,
            backdrop = {
                enable = true,
                texture = "WindTools Glow",
                classColor = false,
                color = {r = 0.145, g = 0.353, b = 0.698},
                alpha = 1,
                animationType = "FADE",
                animationDuration = 0.2
            },
            selected = {
                enable = true,
                texture = "WindTools Glow",
                backdropClassColor = false,
                backdropColor = {r = 0.322, g = 0.608, b = 0.961},
                backdropAlpha = 0.4,
                borderClassColor = false,
                borderColor = {r = 0.145, g = 0.353, b = 0.698},
                borderAlpha = 1
            },
            text = {
                enable = true,
                normalClassColor = false,
                normalColor = {r = 1, g = 0.82, b = 0},
                selectedClassColor = false,
                selectedColor = {r = 1, g = 1, b = 1},
                font = {
                    name = E.db.general.font,
                    style = "OUTLINE"
                }
            }
        },
        checkBox = {
            enable = true,
            texture = "WindTools Glow",
            classColor = false,
            color = {r = 0.322, g = 0.608, b = 0.961, a = 0.8}
        },
        slider = {
            enable = true,
            texture = "WindTools Glow",
            classColor = false,
            color = {r = 0.322, g = 0.608, b = 0.961, a = 0.8}
        },
        treeGroupButton = {
            enable = true,
            backdrop = {
                enable = true,
                texture = "WindTools Glow",
                classColor = false,
                color = {r = 0.145, g = 0.353, b = 0.698},
                alpha = 1,
                animationType = "FADE",
                animationDuration = 0.2,
                removeBorderEffect = true
            },
            selected = {
                enable = true,
                texture = "WindTools Glow",
                backdropClassColor = false,
                backdropColor = {r = 0.322, g = 0.608, b = 0.961},
                backdropAlpha = 0.4,
                borderClassColor = false,
                borderColor = {r = 0.145, g = 0.353, b = 0.698},
                borderAlpha = 0
            },
            text = {
                enable = true,
                normalClassColor = false,
                normalColor = {r = 1, g = 0.82, b = 0},
                selectedClassColor = false,
                selectedColor = {r = 1, g = 1, b = 1},
                font = {
                    name = E.db.general.font,
                    style = "OUTLINE"
                }
            }
        }
    },
    addons = {
        ace3 = true,
        ace3DropdownBackdrop = true,
        angryKeystones = true,
        azerothAutoPilot = true,
        bigWigs = true,
        bigWigsQueueTimer = true,
        bugSack = true,
        hekili = true,
        immersion = true,
        meetingStone = true,
        myslot = true,
        mythicDungeonTools = true,
        premadeGroupsFilter = true,
        rehack = true,
        rematch = true,
        tinyInspect = true,
        tldrMissions = true,
        tomCats = true,
        warpDeplete = true,
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
        blizzardOptions = true,
        calendar = true,
        challenges = true,
        channels = true,
        character = true,
        chromieTime = true,
        clickBinding = true,
        collections = true,
        communities = true,
        covenantRenown = true,
        covenantPreview = true,
        covenantSanctum = true,
        debugTools = true,
        dressingRoom = true,
        encounterJournal = true,
        eventTrace = true,
        flightMap = true,
        friends = true,
        garrison = true,
        gossip = true,
        guild = true,
        guildBank = true,
        help = true,
        inputMethodEditor = true,
        inspect = true,
        itemInteraction = true,
        itemSocketing = true,
        itemUpgrade = true,
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
        ticketStatus = true,
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
        chatCopyFrame = true,
        chatVoicePanel = true,
        classBars = true,
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
    factionIcon = true,
    petIcon = true,
    petId = true,
    tierSet = true,
    covenant = true,
    dominationRank = true,
    objectiveProgress = true,
    objectiveProgressAccuracy = 1,
    progression = {
        enable = true,
        header = "TEXTURE",
        raids = {
            enable = true,
            ["Castle Nathria"] = true,
            ["Sanctum of Domination"] = true,
            ["Sepulcher of the First Ones"] = true
        },
        special = {
            enable = true,
            ["Shadowlands Keystone Master: Season One"] = false,
            ["Shadowlands Keystone Master: Season Two"] = false,
            ["Shadowlands Keystone Master: Season Three"] = true,
            ["Shadowlands Keystone Master: Season Four"] = true
        },
        mythicDungeons = {
            enable = true,
            markHighestScore = true,
            showNoRecord = true,
            ["Grimrail Depot"] = true,
            ["Iron Docks"] = true,
            ["Operation: Mechagon - Junkyard"] = true,
            ["Operation: Mechagon - Workshop"] = true,
            ["Return to Karazhan: Lower"] = true,
            ["Return to Karazhan: Upper"] = true,
            ["Tazavesh: So'leah's Gambit"] = true,
            ["Tazavesh: Streets of Wonder"] = true
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
        enable = false,
        modifier = "shift",
        button = "BUTTON1"
    },
    roleIcon = {
        enable = true,
        roleIconStyle = "SUNUI"
    }
}
