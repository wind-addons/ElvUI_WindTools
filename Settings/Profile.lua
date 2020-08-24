local W, F, E, L, V, P, G = unpack(select(2, ...))
local _G = _G

P.announcement = {
    enable = true,
    combatResurrection = {
        enable = true,
        onlySourceIsPlayer = false,
        raidWarning = false,
        text = L["%player% casted %spell% -> %target%"],
        channel = {
            solo = "EMOTE",
            party = "PARTY",
            instance = "INSTANCE_CHAT",
            raid = "RAID"
        }
    },
    goodbye = {
        enable = true,
        text = L["Thanks all!"],
        delay = 3,
        channel = {
            party = "PARTY",
            instance = "INSTANCE_CHAT",
            raid = "RAID"
        }
    },
    interrupt = {
        enable = true,
        onlyInstance = true,
        player = {
            enable = true,
            text = L["I interrupted %target%'s %target_spell%!"],
            channel = {
                solo = "SELF",
                party = "PARTY",
                instance = "INSTANCE_CHAT",
                raid = "RAID"
            }
        },
        others = {
            enable = false,
            text = L["%player% interrupted %target%'s %target_spell%!"],
            channel = {
                party = "EMOTE",
                instance = "NONE",
                raid = "NONE"
            }
        }
    },
    resetInstance = {
        enable = true,
        prefix = true,
        channel = {
            party = "PARTY",
            instance = "INSTANCE_CHAT",
            raid = "RAID"
        }
    },
    taunt = {
        enable = true,
        player = {
            player = {
                enable = true,
                provokeAllText = L["I taunted all enemies in 10 yards!"],
                successText = L["I taunted %target% successfully!"],
                failedText = L["I failed on taunting %target%!"],
                channel = {
                    solo = "EMOTE",
                    party = "PARTY",
                    instance = "INSTANCE_CHAT",
                    raid = "RAID"
                }
            },
            pet = {
                enable = true,
                successText = L["My %pet_role% %pet% taunted %target% successfully!"],
                failedText = L["My %pet_role% %pet% failed on taunting %target%!"],
                channel = {
                    solo = "EMOTE",
                    party = "PARTY",
                    instance = "INSTANCE_CHAT",
                    raid = "RAID"
                }
            }
        },
        others = {
            player = {
                enable = true,
                provokeAllText = L["%player% taunted all enemies in 10 yards!"],
                successText = L["%player% taunted %target% successfully!"],
                failedText = L["%player% failed on taunting %target%!"],
                channel = {
                    party = "SELF",
                    instance = "SELF",
                    raid = "SELF"
                }
            },
            pet = {
                enable = true,
                successText = L["%player%'s %pet_role% %pet% taunted %target% successfully!"],
                failedText = L["%player%'s %pet_role% %pet% failed on taunting %target%!"],
                channel = {
                    party = "SELF",
                    instance = "SELF",
                    raid = "SELF"
                }
            }
        }
    },
    thanksForResurrection = {
        enable = true,
        normalText = L["%target%, thank you for using %spell% to revive me. :)"],
        soulstoneText = L["%target%, thank you for soulstone. :)"],
        delay = 0,
        channel = {
            solo = "WHISPER",
            party = "WHISPER",
            instance = "WHISPER",
            raid = "WHISPER"
        }
    },
    threatTransfer = {
        enable = true,
        onlyNotTank = true,
        forceSourceIsPlayer = true,
        forceDestIsPlayer = false,
        raidWarning = false,
        text = L["%player% casted %spell% -> %target%"],
        channel = {
            solo = "EMOTE",
            party = "PARTY",
            instance = "INSTANCE_CHAT",
            raid = "RAID"
        }
    },
    utility = {
        enable = true,
        channel = {
            solo = "SELF",
            party = "PARTY",
            instance = "INSTANCE_CHAT",
            raid = "RAID"
        },
        spells = {
            ["698"] = {
                -- 召喚儀式
                enable = true,
                includePlayer = true,
                raidWarning = true,
                text = L["%player% is casting %spell%, please assist!"]
            },
            ["29893"] = {
                -- 靈魂之井
                enable = true,
                includePlayer = true,
                raidWarning = true,
                text = L["%player% is handing out cookies, go and get one!"]
            },
            ["54710"] = {
                -- MOLL-E 郵箱
                enable = true,
                includePlayer = true,
                raidWarning = true,
                text = L["%player% puts %spell%"]
            },
            ["261602"] = {
                -- 凱蒂的郵哨
                enable = true,
                includePlayer = true,
                raidWarning = true,
                text = L["%player% used %spell%"]
            },
            ["195782"] = {
                -- 召喚月羽雕像
                enable = true,
                includePlayer = true,
                raidWarning = true,
                text = L["%player% used %spell%"]
            },
            ["190336"] = {
                -- 召喚餐點桌
                enable = true,
                includePlayer = true,
                raidWarning = true,
                text = L["%player% casted %spell%, today's special is Anchovy Pie!"]
            },
            feasts = {
                enable = true,
                includePlayer = true,
                raidWarning = true,
                text = L["OMG, wealthy %player% puts %spell%!"]
            },
            bots = {
                enable = true,
                includePlayer = true,
                raidWarning = true,
                text = L["%player% puts %spell%"]
            },
            toys = {
                enable = true,
                includePlayer = true,
                raidWarning = true,
                text = L["%player% puts %spell%"]
            },
            portals = {
                enable = true,
                includePlayer = true,
                raidWarning = true,
                text = L["%player% opened %spell%!"]
            }
        }
    }
}

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
        leaveColor = {r = 0.227, g = 1, b = 0.6, a = 1},
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
    chatLink = {
        enable = true,
        level = true,
        icon = true,
        armorCategory = true,
        weaponCategory = true
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
    },
    smartTab = {
        enable = true,
        whisperCycle = false,
        yell = false,
        battleground = false,
        raidWarning = false,
        officer = false,
        historyLimit = 10
    },
    emote = {
        enable = true,
        size = 16,
        panel = true
    }
}

P.quest = {
    objectiveTracker = {
        enable = true,
        header = {
            name = E.db.general.font,
            size = E.db.general.fontSize,
            style = "OUTLINE"
        },
        title = {
            name = E.db.general.font,
            size = E.db.general.fontSize,
            style = "OUTLINE"
        },
        titleColor = {
            enable = true,
            useClassColor = true,
            customColorNormal = {r = 0.75, g = 0.61, b = 0},
            customColorHighlight = {r = _G.NORMAL_FONT_COLOR.r, g = _G.NORMAL_FONT_COLOR.g, b = _G.NORMAL_FONT_COLOR.b}
        },
        info = {
            name = E.db.general.font,
            size = E.db.general.fontSize,
            style = "OUTLINE"
        }
    },
    paragonReputation = {
        enable = true,
        color = {r = 0, g = .5, b = .9},
        text = "DEFICIT",
        toast = {
            enable = true,
            sound = true,
            fade_time = 5
        }
    }
}
