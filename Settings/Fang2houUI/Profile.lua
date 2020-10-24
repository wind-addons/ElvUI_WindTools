local W, F, E, L, V, P, G = unpack(select(2, ...))

local profile = {
    ["databars"] = {
        ["threat"] = {
            ["width"] = 417,
            ["fontOutline"] = "OUTLINE"
        },
        ["honor"] = {
            ["enable"] = false
        },
        ["reputation"] = {
            ["enable"] = true,
            ["height"] = 5
        },
        ["statusbar"] = "WindTools Glow",
        ["experience"] = {
            ["width"] = 222,
            ["hideAtMaxLevel"] = false,
            ["fontOutline"] = "OUTLINE",
            ["height"] = 5,
            ["hideInCombat"] = false,
            ["fontSize"] = 8
        },
        ["azerite"] = {
            ["height"] = 5
        },
        ["customTexture"] = true,
        ["colors"] = {
            ["experience"] = {
                ["a"] = 0.800000011920929,
                ["b"] = 0.9294117647058824,
                ["g"] = 0.4941176470588236,
                ["r"] = 0.07450980392156863
            },
            ["quest"] = {
                ["a"] = 0.5965439975261688,
                ["b"] = 0.5568627450980392,
                ["r"] = 0.192156862745098
            }
        },
        ["transparent"] = false
    },
    ["general"] = {
        ["decimalLength"] = 0,
        ["backdropfadecolor"] = {
            ["a"] = 0.75,
            ["r"] = 0.04705882352941176,
            ["g"] = 0.04705882352941176,
            ["b"] = 0.04705882352941176
        },
        ["valuecolor"] = {
            ["a"] = 1,
            ["r"] = 0.05882352941176471,
            ["g"] = 0.6784313725490196,
            ["b"] = 1
        },
        ["loginmessage"] = false,
        ["itemLevel"] = {
            ["displayInspectInfo"] = false,
            ["itemLevelFontSize"] = 14
        },
        ["altPowerBar"] = {
            ["smoothbars"] = true,
            ["statusBarColorGradient"] = true
        },
        ["fontSize"] = 13,
        ["autoAcceptInvite"] = true,
        ["autoRepair"] = "PLAYER",
        ["minimap"] = {
            ["icons"] = {
                ["lfgEye"] = {
                    ["position"] = "BOTTOMLEFT",
                    ["yOffset"] = -2
                },
                ["mail"] = {
                    ["yOffset"] = -60
                },
                ["classHall"] = {
                    ["position"] = "TOPRIGHT",
                    ["yOffset"] = -30
                }
            },
            ["size"] = 220
        },
        ["talkingHeadFrameBackdrop"] = true,
        ["bottomPanel"] = false,
        ["numberPrefixStyle"] = "TCHINESE",
        ["autoTrackReputation"] = true,
        ["backdropcolor"] = {
            ["a"] = 1,
            ["r"] = 0.1176470588235294,
            ["g"] = 0.1176470588235294,
            ["b"] = 0.1176470588235294
        },
        ["totems"] = {
            ["growthDirection"] = "HORIZONTAL",
            ["size"] = 35
        },
        ["bonusObjectivePosition"] = "RIGHT",
        ["resurrectSound"] = true,
        ["stickyFrames"] = false,
        ["objectiveFrameAutoHideInKeystone"] = true,
        ["bordercolor"] = {
            ["a"] = 1
        }
    },
    ["v11NamePlateReset"] = true,
    ["chat"] = {
        ["tabFontOutline"] = "OUTLINE",
        ["keywordSound"] = "OnePlus Surprise",
        ["fontOutline"] = "OUTLINE",
        ["socialQueueMessages"] = true,
        ["customTimeColor"] = {
            ["r"] = 1,
            ["g"] = 0.7647058823529411,
            ["b"] = 0.3803921568627451
        },
        ["channelAlerts"] = {
            ["WHISPER"] = "OnePlus Light"
        },
        ["hideChatToggles"] = true,
        ["fontSize"] = 13,
        ["tabFontSize"] = 13,
        ["panelBackdrop"] = "HIDEBOTH",
        ["maxLines"] = 2000,
        ["keywords"] = "%MYNAME%",
        ["timeStampFormat"] = "%H:%M ",
        ["tabSelector"] = "NONE",
        ["hideVoiceButtons"] = true
    },
    ["WT"] = {
        ["misc"] = {
            ["noKanjiMath"] = false,
            ["gameBar"] = {
                ["home"] = {
                    ["left"] = "172179"
                }
            }
        },
        ["maps"] = {
            ["rectangleMinimap"] = {
                ["enable"] = true
            }
        },
        ["tooltips"] = {
            ["yOffsetOfHealthText"] = -7,
            ["yOffsetOfHealthBar"] = 5
        },
        ["unitFrames"] = {
            ["castBar"] = {
                ["enable"] = true,
                ["player"] = {
                    ["enable"] = true,
                    ["text"] = {
                        ["font"] = {
                            ["size"] = 13
                        },
                        ["offsetX"] = 6
                    },
                    ["time"] = {
                        ["font"] = {
                            ["size"] = 13
                        },
                        ["offsetX"] = -5
                    }
                }
            }
        },
        ["item"] = {
            ["extraItemsBar"] = {
                ["bar2"] = {
                    ["buttonsPerRow"] = 10,
                    ["numButtons"] = 10
                },
                ["bar1"] = {
                    ["buttonsPerRow"] = 10,
                    ["numButtons"] = 10
                }
            }
        },
        ["skins"] = {
            ["vignetting"] = {
                ["level"] = 38
            }
        },
        ["quest"] = {
            ["turnIn"] = {
                ["enable"] = false
            }
        }
    },
    ["movers"] = {
        ["WTRaidMarkersBarAnchor"] = "TOP,ElvUIParent,TOP,0,-85",
        ["ThreatBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,9",
        ["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,14,131",
        ["ElvUF_RaidMover"] = "RIGHT,ElvUIParent,CENTER,-200,100",
        ["LeftChatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,44,35",
        ["GMMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,44,224",
        ["BuffsMover"] = "TOPRIGHT,MinimapMover,TOPLEFT,-10,0",
        ["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,161",
        ["LootFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,221,97",
        ["ZoneAbility"] = "BOTTOM,ElvUIParent,BOTTOM,-321,33",
        ["SocialMenuMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,16,127",
        ["WTMinimapButtonBarAnchor"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-225",
        ["ElvUF_FocusMover"] = "TOP,ElvUIParent,TOP,341,-502",
        ["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,317",
        ["DurabilityFrameMover"] = "TOPLEFT,ElvUF_PlayerMover,BOTTOMLEFT,0,-200",
        ["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,300,300",
        ["VehicleSeatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-467,52",
        ["WTChatBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,45,25",
        ["ExperienceBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-211",
        ["ElvUF_PetMover"] = "TOPRIGHT,ElvUF_PlayerMover,TOPLEFT,-5,0",
        ["ElvUF_TargetTargetMover"] = "TOPLEFT,ElvUF_TargetMover,TOPRIGHT,5,0",
        ["ElvUF_PartyMover"] = "RIGHT,ElvUIParent,CENTER,-300,100",
        ["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-300,300",
        ["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,300",
        ["MirrorTimer1Mover"] = "TOP,ElvUIParent,TOP,0,-116",
        ["AltPowerBarMover"] = "TOP,ElvUIParent,TOP,6,-164",
        ["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,-72,62",
        ["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,-72,26",
        ["BelowMinimapContainerMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-36,-276",
        ["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,216,26",
        ["TalkingHeadFrameMover"] = "TOP,ElvUIParent,TOP,0,-180",
        ["ReputationBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-204",
        ["AzeriteBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-218",
        ["WTExtraItemsBar3Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-63,281",
        ["ElvAB_5"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-711,123",
        ["VehicleLeaveButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,420",
        ["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,14,382",
        ["WTParagonReputationToastFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,203",
        ["ObjectiveFrameMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,121,-25",
        ["BNETMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,44,224",
        ["ShiftAB"] = "BOTTOMLEFT,ElvAB_1,TOPLEFT,0,5",
        ["VOICECHAT"] = "TOPLEFT,ElvUIParent,TOPLEFT,336,-26",
        ["HonorBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-625,-212",
        ["ElvAB_6"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-621,217",
        ["ArenaHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-215,366",
        ["WTExtraItemsBar1Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-74,210",
        ["BossHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-240,360",
        ["TotemBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-334,255",
        ["ElvAB_4"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-25,337",
        ["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-45,25",
        ["AlertFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,180",
        ["DebuffsMover"] = "TOP,ElvUIParent,TOP,144,-397",
        ["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-25"
    },
    ["tooltip"] = {
        ["headerFontSize"] = 15,
        ["fontOutline"] = "OUTLINE",
        ["cursorAnchorType"] = "ANCHOR_CURSOR_RIGHT",
        ["healthBar"] = {
            ["statusPosition"] = "TOP",
            ["fontSize"] = 15
        },
        ["colorAlpha"] = 0.75,
        ["textFontSize"] = 13,
        ["itemCount"] = "BOTH",
        ["fontSize"] = 13,
        ["smallTextFontSize"] = 13
    },
    ["unitframe"] = {
        ["fontSize"] = 12,
        ["statusbar"] = "WindTools Glow",
        ["units"] = {
            ["targettarget"] = {
                ["debuffs"] = {
                    ["yOffset"] = 20,
                    ["anchorPoint"] = "TOPRIGHT",
                    ["perrow"] = 4,
                    ["attachTo"] = "FRAME"
                },
                ["name"] = {
                    ["text_format"] = ""
                },
                ["cutaway"] = {
                    ["health"] = {
                        ["enabled"] = true,
                        ["fadeOutTime"] = 0.3,
                        ["lengthBeforeFade"] = 0.1
                    },
                    ["power"] = {
                        ["enabled"] = true,
                        ["fadeOutTime"] = 0.3,
                        ["lengthBeforeFade"] = 0.1
                    }
                },
                ["power"] = {
                    ["height"] = 4
                },
                ["customTexts"] = {
                    ["Wind Name"] = {
                        ["attachTextTo"] = "Health",
                        ["yOffset"] = 25,
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = 3,
                        ["enable"] = true,
                        ["text_format"] = "[name]",
                        ["size"] = 12
                    },
                    ["Wind Power"] = {
                        ["attachTextTo"] = "Health",
                        ["enable"] = true,
                        ["text_format"] = "[mouseover][power:percent-nosign]",
                        ["yOffset"] = -14,
                        ["font"] = "Accidental Presidency" ..
                            (W.CompatibleFont and " (en)" or ""),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = -2,
                        ["size"] = 16
                    },
                    ["Wind Health"] = {
                        ["attachTextTo"] = "Health",
                        ["enable"] = true,
                        ["text_format"] = "[health:percent-nostatus] || [curhp]",
                        ["yOffset"] = -27,
                        ["font"] = "Accidental Presidency" ..
                            (W.CompatibleFont and " (en)" or ""),
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = -2,
                        ["size"] = 16
                    }
                },
                ["width"] = 100,
                ["height"] = 30
            },
            ["pet"] = {
                ["debuffs"] = {
                    ["countFontSize"] = 15,
                    ["enable"] = true,
                    ["yOffset"] = 80,
                    ["anchorPoint"] = "TOPLEFT",
                    ["spacing"] = 3,
                    ["priority"] = "Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable",
                    ["countFont"] = "Montserrat Bold",
                    ["perrow"] = 4,
                    ["attachTo"] = "BUFFS"
                },
                ["raidRoleIcons"] = {
                    ["enable"] = true,
                    ["yOffset"] = 0,
                    ["xOffset"] = 0,
                    ["position"] = "TOPLEFT"
                },
                ["pvpIcon"] = {
                    ["anchorPoint"] = "CENTER",
                    ["xOffset"] = 0,
                    ["enable"] = false,
                    ["scale"] = 1,
                    ["yOffset"] = 0
                },
                ["resurrectIcon"] = {
                    ["attachTo"] = "CENTER",
                    ["yOffset"] = 0,
                    ["enable"] = true,
                    ["xOffset"] = 0,
                    ["attachToObject"] = "Frame",
                    ["size"] = 30
                },
                ["phaseIndicator"] = {
                    ["anchorPoint"] = "CENTER",
                    ["xOffset"] = 0,
                    ["enable"] = true,
                    ["scale"] = 0.8,
                    ["yOffset"] = 0
                },
                ["CombatIcon"] = {
                    ["anchorPoint"] = "CENTER",
                    ["yOffset"] = 0,
                    ["size"] = 20,
                    ["xOffset"] = 0,
                    ["color"] = {
                        ["a"] = 1,
                        ["r"] = 1,
                        ["g"] = 0.2,
                        ["b"] = 0.2
                    },
                    ["enable"] = true,
                    ["defaultColor"] = true,
                    ["texture"] = "DEFAULT"
                },
                ["aurabar"] = {
                    ["yOffset"] = 0,
                    ["attachTo"] = "DEBUFFS",
                    ["spacing"] = 0,
                    ["detachedWidth"] = 270,
                    ["priority"] = "Blacklist,blockNoDuration,Personal,Boss,RaidDebuffs,PlayerBuffs"
                },
                ["cutaway"] = {
                    ["health"] = {
                        ["enabled"] = true,
                        ["fadeOutTime"] = 0.3,
                        ["lengthBeforeFade"] = 0.1
                    }
                },
                ["castbar"] = {
                    ["iconAttachedTo"] = "Castbar",
                    ["iconSize"] = 27,
                    ["icon"] = false,
                    ["iconAttached"] = false,
                    ["width"] = 100,
                    ["displayTarget"] = true,
                    ["height"] = 20,
                    ["timeToHold"] = 0.4,
                    ["textColor"] = {
                        ["b"] = 1,
                        ["g"] = 1,
                        ["r"] = 1
                    }
                },
                ["customTexts"] = {
                    ["Wind Name"] = {
                        ["attachTextTo"] = "Health",
                        ["yOffset"] = 27,
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = -2,
                        ["enable"] = true,
                        ["text_format"] = "[name]",
                        ["size"] = 12
                    },
                    ["Wind Power"] = {
                        ["attachTextTo"] = "Health",
                        ["enable"] = true,
                        ["text_format"] = "[mouseover][power:current-percent]",
                        ["yOffset"] = -14,
                        ["font"] = "Accidental Presidency" ..
                            (W.CompatibleFont and " (en)" or ""),
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = 2,
                        ["size"] = 16
                    },
                    ["Wind Health"] = {
                        ["attachTextTo"] = "Health",
                        ["enable"] = true,
                        ["text_format"] = "[curhp] || [health:percent-nostatus]",
                        ["yOffset"] = -27,
                        ["font"] = "Accidental Presidency" ..
                            (W.CompatibleFont and " (en)" or ""),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = 3,
                        ["size"] = 16
                    }
                },
                ["width"] = 100,
                ["infoPanel"] = {
                    ["height"] = 20
                },
                ["middleClickFocus"] = true,
                ["name"] = {
                    ["text_format"] = ""
                },
                ["orientation"] = "RIGHT",
                ["height"] = 30,
                ["buffs"] = {
                    ["yOffset"] = -80,
                    ["anchorPoint"] = "TOPLEFT",
                    ["spacing"] = 2,
                    ["priority"] = "Blacklist,Personal,nonPersonal",
                    ["perrow"] = 5,
                    ["maxDuration"] = 0
                },
                ["power"] = {
                    ["height"] = 4
                },
                ["raidicon"] = {
                    ["attachTo"] = "TOP",
                    ["size"] = 18,
                    ["enable"] = true,
                    ["xOffset"] = 0,
                    ["attachToObject"] = "Frame",
                    ["yOffset"] = 8
                }
            },
            ["player"] = {
                ["debuffs"] = {
                    ["enable"] = false
                },
                ["disableTargetGlow"] = false,
                ["customTexts"] = {
                    ["Wind Name"] = {
                        ["attachTextTo"] = "Health",
                        ["yOffset"] = 25,
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = -2,
                        ["enable"] = true,
                        ["text_format"] = "[name]",
                        ["size"] = 12
                    },
                    ["Wind Power"] = {
                        ["attachTextTo"] = "Power",
                        ["enable"] = true,
                        ["text_format"] = "[power:current]",
                        ["yOffset"] = 7,
                        ["font"] = "Accidental Presidency" ..
                            (W.CompatibleFont and " (en)" or ""),
                        ["justifyH"] = "CENTER",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = 0,
                        ["size"] = 22
                    },
                    ["Wind Health"] = {
                        ["attachTextTo"] = "Health",
                        ["enable"] = true,
                        ["text_format"] = "[curhp] || [health:percent-nostatus]",
                        ["yOffset"] = -27,
                        ["font"] = "Accidental Presidency" ..
                            (W.CompatibleFont and " (en)" or ""),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = 4,
                        ["size"] = 16
                    }
                },
                ["disableMouseoverGlow"] = true,
                ["infoPanel"] = {
                    ["height"] = 14,
                    ["transparent"] = true
                },
                ["height"] = 30,
                ["raidicon"] = {
                    ["size"] = 19
                },
                ["disableFocusGlow"] = false,
                ["aurabar"] = {
                    ["enable"] = false
                },
                ["RestIcon"] = {
                    ["anchorPoint"] = "BOTTOMLEFT",
                    ["yOffset"] = 13,
                    ["size"] = 21,
                    ["color"] = {
                        ["g"] = 0.5568627450980392,
                        ["r"] = 0.203921568627451
                    },
                    ["xOffset"] = 13,
                    ["defaultColor"] = false,
                    ["texture"] = "RESTING1"
                },
                ["pvp"] = {
                    ["position"] = "RIGHT"
                },
                ["classbar"] = {
                    ["detachFromFrame"] = true,
                    ["height"] = 13
                },
                ["power"] = {
                    ["text_format"] = "",
                    ["detachFromFrame"] = true,
                    ["height"] = 15
                },
                ["portrait"] = {
                    ["overlay"] = true,
                    ["camDistanceScale"] = 2.88,
                    ["overlayAlpha"] = 0.2
                },
                ["width"] = 220,
                ["raidRoleIcons"] = {
                    ["xOffset"] = 3,
                    ["position"] = "TOPRIGHT"
                },
                ["fader"] = {
                    ["enable"] = true,
                    ["minAlpha"] = 0,
                    ["vehicle"] = false
                },
                ["castbar"] = {
                    ["xOffsetTime"] = 0,
                    ["iconXOffset"] = -4,
                    ["xOffsetText"] = 0,
                    ["iconSize"] = 24,
                    ["format"] = "REMAININGMAX",
                    ["textColor"] = {
                        ["b"] = 1,
                        ["g"] = 1,
                        ["r"] = 1
                    },
                    ["iconAttached"] = false,
                    ["width"] = 257,
                    ["displayTarget"] = true,
                    ["height"] = 24,
                    ["iconAttachedTo"] = "Castbar",
                    ["latency"] = false
                },
                ["cutaway"] = {
                    ["health"] = {
                        ["enabled"] = true,
                        ["fadeOutTime"] = 0.3,
                        ["lengthBeforeFade"] = 0.1
                    },
                    ["power"] = {
                        ["fadeOutTime"] = 0.3,
                        ["lengthBeforeFade"] = 0.1
                    }
                },
                ["health"] = {
                    ["text_format"] = ""
                }
            },
            ["focus"] = {
                ["cutaway"] = {
                    ["health"] = {
                        ["enabled"] = true,
                        ["fadeOutTime"] = 0.3,
                        ["lengthBeforeFade"] = 0.1
                    }
                },
                ["debuffs"] = {
                    ["countFontSize"] = 15,
                    ["yOffset"] = 80,
                    ["anchorPoint"] = "TOPLEFT",
                    ["spacing"] = 3,
                    ["priority"] = "Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable",
                    ["countFont"] = "Montserrat Bold",
                    ["perrow"] = 4,
                    ["attachTo"] = "BUFFS"
                },
                ["disableTargetGlow"] = true,
                ["raidRoleIcons"] = {
                    ["enable"] = true,
                    ["position"] = "TOPLEFT",
                    ["xOffset"] = 0,
                    ["yOffset"] = 0
                },
                ["resurrectIcon"] = {
                    ["attachTo"] = "CENTER",
                    ["size"] = 30,
                    ["enable"] = true,
                    ["xOffset"] = 0,
                    ["attachToObject"] = "Frame",
                    ["yOffset"] = 0
                },
                ["phaseIndicator"] = {
                    ["anchorPoint"] = "CENTER",
                    ["scale"] = 0.8,
                    ["xOffset"] = 0,
                    ["enable"] = true,
                    ["yOffset"] = 0
                },
                ["aurabar"] = {
                    ["maxBars"] = 6,
                    ["detachedWidth"] = 270
                },
                ["middleClickFocus"] = true,
                ["pvpIcon"] = {
                    ["anchorPoint"] = "CENTER",
                    ["scale"] = 1,
                    ["xOffset"] = 0,
                    ["enable"] = false,
                    ["yOffset"] = 0
                },
                ["customTexts"] = {
                    ["Wind Name"] = {
                        ["attachTextTo"] = "Health",
                        ["yOffset"] = 27,
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["xOffset"] = 4,
                        ["text_format"] = "[name]",
                        ["size"] = 12
                    },
                    ["Wind Power"] = {
                        ["attachTextTo"] = "Health",
                        ["xOffset"] = -1,
                        ["text_format"] = "[mouseover][power:current-percent]",
                        ["yOffset"] = -14,
                        ["font"] = "Accidental Presidency" ..
                            (W.CompatibleFont and " (en)" or ""),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["size"] = 16
                    },
                    ["Wind Health"] = {
                        ["attachTextTo"] = "Health",
                        ["xOffset"] = -2,
                        ["text_format"] = "[health:percent-nostatus] || [curhp]",
                        ["yOffset"] = -27,
                        ["font"] = "Accidental Presidency" ..
                            (W.CompatibleFont and " (en)" or ""),
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["size"] = 16
                    }
                },
                ["width"] = 138,
                ["infoPanel"] = {
                    ["height"] = 20
                },
                ["power"] = {
                    ["height"] = 4
                },
                ["name"] = {
                    ["text_format"] = ""
                },
                ["height"] = 30,
                ["orientation"] = "RIGHT",
                ["buffs"] = {
                    ["enable"] = true,
                    ["yOffset"] = -80,
                    ["anchorPoint"] = "TOPLEFT",
                    ["spacing"] = 2,
                    ["priority"] = "Blacklist,Personal,nonPersonal",
                    ["perrow"] = 5,
                    ["maxDuration"] = 0
                },
                ["castbar"] = {
                    ["iconAttachedTo"] = "Castbar",
                    ["iconSize"] = 27,
                    ["icon"] = false,
                    ["iconAttached"] = false,
                    ["width"] = 138,
                    ["displayTarget"] = true,
                    ["height"] = 20,
                    ["timeToHold"] = 0.4,
                    ["textColor"] = {
                        ["b"] = 1,
                        ["g"] = 1,
                        ["r"] = 1
                    }
                }
            },
            ["target"] = {
                ["debuffs"] = {
                    ["countFontSize"] = 15,
                    ["yOffset"] = 80,
                    ["anchorPoint"] = "TOPLEFT",
                    ["spacing"] = 3,
                    ["countFont"] = "Montserrat Bold",
                    ["perrow"] = 6
                },
                ["health"] = {
                    ["text_format"] = ""
                },
                ["raidRoleIcons"] = {
                    ["xOffset"] = 3
                },
                ["aurabar"] = {
                    ["enable"] = false
                },
                ["cutaway"] = {
                    ["health"] = {
                        ["enabled"] = true,
                        ["fadeOutTime"] = 0.3,
                        ["lengthBeforeFade"] = 0.1
                    }
                },
                ["castbar"] = {
                    ["iconAttachedTo"] = "Castbar",
                    ["iconXOffset"] = -4,
                    ["iconSize"] = 24,
                    ["format"] = "REMAININGMAX",
                    ["iconAttached"] = false,
                    ["width"] = 310,
                    ["displayTarget"] = true,
                    ["height"] = 24,
                    ["timeToHold"] = 0.4,
                    ["textColor"] = {
                        ["b"] = 1,
                        ["g"] = 1,
                        ["r"] = 1
                    }
                },
                ["customTexts"] = {
                    ["Wind Name"] = {
                        ["attachTextTo"] = "Health",
                        ["yOffset"] = 25,
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = 3,
                        ["enable"] = true,
                        ["text_format"] = "[name]",
                        ["size"] = 12
                    },
                    ["Wind Power"] = {
                        ["attachTextTo"] = "Health",
                        ["enable"] = true,
                        ["text_format"] = "[mouseover][power:percent-nosign]",
                        ["yOffset"] = -14,
                        ["font"] = "Accidental Presidency" ..
                            (W.CompatibleFont and " (en)" or ""),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = -2,
                        ["size"] = 16
                    },
                    ["Wind Health"] = {
                        ["attachTextTo"] = "Health",
                        ["enable"] = true,
                        ["text_format"] = "[health:percent-nostatus] || [curhp]",
                        ["yOffset"] = -27,
                        ["font"] = "Accidental Presidency" ..
                            (W.CompatibleFont and " (en)" or ""),
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = -2,
                        ["size"] = 16
                    }
                },
                ["width"] = 220,
                ["power"] = {
                    ["text_format"] = "",
                    ["height"] = 4
                },
                ["name"] = {
                    ["text_format"] = ""
                },
                ["height"] = 30,
                ["buffs"] = {
                    ["yOffset"] = -80,
                    ["anchorPoint"] = "TOPLEFT",
                    ["spacing"] = 2
                }
            },
            ["raid"] = {
                ["portrait"] = {
                    ["fullOverlay"] = true
                },
                ["customTexts"] = {
                    ["Wind Name"] = {
                        ["attachTextTo"] = "Health",
                        ["yOffset"] = -11,
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = 1,
                        ["enable"] = true,
                        ["text_format"] = "[namecolor][name:short]",
                        ["size"] = 10
                    }
                },
                ["name"] = {
                    ["text_format"] = ""
                },
                ["height"] = 40,
                ["rdebuffs"] = {
                    ["xOffset"] = 23,
                    ["yOffset"] = 14,
                    ["font"] = "Montserrat" .. (W.CompatibleFont and " (en)" or ""),
                    ["fontOutline"] = "OUTLINE",
                    ["size"] = 25
                },
                ["roleIcon"] = {
                    ["yOffset"] = -2,
                    ["position"] = "TOPLEFT",
                    ["xOffset"] = 2
                },
                ["power"] = {
                    ["height"] = 4
                },
                ["summonIcon"] = {
                    ["attachTo"] = "TOPRIGHT"
                },
                ["width"] = 72
            },
            ["boss"] = {
                ["debuffs"] = {
                    ["sizeOverride"] = 30,
                    ["yOffset"] = 0,
                    ["spacing"] = 3,
                    ["countFont"] = "Montserrat" .. (W.CompatibleFont and " (en)" or ""),
                    ["perrow"] = 4,
                    ["xOffset"] = -5
                },
                ["spacing"] = 50,
                ["health"] = {
                    ["text_format"] = ""
                },
                ["cutaway"] = {
                    ["health"] = {
                        ["enabled"] = true,
                        ["fadeOutTime"] = 0.3,
                        ["lengthBeforeFade"] = 0.2
                    }
                },
                ["castbar"] = {
                    ["width"] = 220,
                    ["height"] = 24
                },
                ["customTexts"] = {
                    ["Wind Name"] = {
                        ["attachTextTo"] = "Health",
                        ["yOffset"] = 25,
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = -1,
                        ["enable"] = true,
                        ["text_format"] = "[name]",
                        ["size"] = 12
                    },
                    ["Wind Power"] = {
                        ["attachTextTo"] = "Health",
                        ["enable"] = true,
                        ["text_format"] = "[mouseover][power:current-percent]",
                        ["yOffset"] = -14,
                        ["font"] = "Accidental Presidency" ..
                            (W.CompatibleFont and " (en)" or ""),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = 0,
                        ["size"] = 14
                    },
                    ["Wind Health"] = {
                        ["attachTextTo"] = "Health",
                        ["enable"] = true,
                        ["text_format"] = "[health:percent-nostatus] || [health:current]",
                        ["yOffset"] = 0,
                        ["font"] = "Accidental Presidency" ..
                            (W.CompatibleFont and " (en)" or ""),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = 0,
                        ["size"] = 16
                    }
                },
                ["width"] = 220,
                ["name"] = {
                    ["text_format"] = ""
                },
                ["height"] = 30,
                ["buffs"] = {
                    ["sizeOverride"] = 30,
                    ["yOffset"] = 0,
                    ["anchorPoint"] = "RIGHT",
                    ["spacing"] = 3,
                    ["countFont"] = "Montserrat" .. (W.CompatibleFont and " (en)" or ""),
                    ["attachTo"] = "HEALTH",
                    ["xOffset"] = 5
                },
                ["power"] = {
                    ["text_format"] = "",
                    ["height"] = 4
                }
            },
            ["party"] = {
                ["debuffs"] = {
                    ["sizeOverride"] = 34,
                    ["xOffset"] = 3,
                    ["countFont"] = "Montserrat" .. (W.CompatibleFont and " (en)" or ""),
                    ["perrow"] = 5
                },
                ["customTexts"] = {
                    ["Wind Health Percent"] = {
                        ["attachTextTo"] = "Health",
                        ["enable"] = true,
                        ["text_format"] = "[health:percent-nostatus-nosign]",
                        ["yOffset"] = 0,
                        ["font"] = "Accidental Presidency" ..
                            (W.CompatibleFont and " (en)" or ""),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = -2,
                        ["size"] = 22
                    },
                    ["Wind Name"] = {
                        ["attachTextTo"] = "Health",
                        ["yOffset"] = 1,
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = 22,
                        ["enable"] = true,
                        ["text_format"] = "[namecolor][name] [smartlevel]",
                        ["size"] = 12
                    },
                    ["Wind Power"] = {
                        ["attachTextTo"] = "Health",
                        ["enable"] = true,
                        ["text_format"] = "[mouseover][power:percent-nosign]",
                        ["yOffset"] = -16,
                        ["font"] = "Accidental Presidency" ..
                            (W.CompatibleFont and " (en)" or ""),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = -2,
                        ["size"] = 13
                    }
                },
                ["name"] = {
                    ["text_format"] = ""
                },
                ["height"] = 35,
                ["verticalSpacing"] = 5,
                ["rdebuffs"] = {
                    ["xOffset"] = 28,
                    ["yOffset"] = 6,
                    ["font"] = "Montserrat" .. (W.CompatibleFont and " (en)" or ""),
                    ["fontOutline"] = "OUTLINE"
                },
                ["raidRoleIcons"] = {
                    ["xOffset"] = 3
                },
                ["growthDirection"] = "DOWN_RIGHT",
                ["disableFocusGlow"] = true,
                ["groupBy"] = "ROLE2",
                ["cutaway"] = {
                    ["health"] = {
                        ["enabled"] = true
                    }
                },
                ["roleIcon"] = {
                    ["yOffset"] = 0,
                    ["position"] = "LEFT",
                    ["xOffset"] = 5
                },
                ["castbar"] = {
                    ["width"] = 154
                },
                ["summonIcon"] = {
                    ["attachTo"] = "RIGHT",
                    ["xOffset"] = -20
                },
                ["width"] = 154,
                ["health"] = {
                    ["text_format"] = ""
                },
                ["power"] = {
                    ["text_format"] = "",
                    ["height"] = 4,
                    ["hideonnpc"] = true
                },
                ["buffs"] = {
                    ["sizeOverride"] = 34,
                    ["enable"] = true,
                    ["countFont"] = "Montserrat" .. (W.CompatibleFont and " (en)" or ""),
                    ["perrow"] = 3,
                    ["xOffset"] = -3
                }
            }
        },
        ["smoothbars"] = true,
        ["colors"] = {
            ["customhealthbackdrop"] = true,
            ["borderColor"] = {
                ["a"] = 1
            },
            ["healthMultiplier"] = 0.75,
            ["colorhealthbyvalue"] = false,
            ["health_backdrop"] = {
                ["r"] = 0.5137254901960784,
                ["g"] = 0.5137254901960784,
                ["b"] = 0.5137254901960784
            },
            ["power"] = {
                ["MANA"] = {
                    ["r"] = 0.3098039215686275,
                    ["g"] = 0.4509803921568628,
                    ["b"] = 0.6313725490196078
                },
                ["RUNIC_POWER"] = {
                    ["g"] = 0.8196078431372549
                },
                ["MAELSTROM"] = {
                    ["r"] = 0.2156862745098039,
                    ["g"] = 0.2588235294117647,
                    ["b"] = 0.9803921568627451
                },
                ["ENERGY"] = {
                    ["r"] = 0.6509803921568628,
                    ["g"] = 0.6313725490196078,
                    ["b"] = 0.3490196078431372
                }
            },
            ["castColor"] = {
                ["a"] = 1,
                ["r"] = 0.2588235294117647,
                ["g"] = 0.7098039215686275,
                ["b"] = 1
            },
            ["frameGlow"] = {
                ["targetGlow"] = {
                    ["enable"] = false
                },
                ["mouseoverGlow"] = {
                    ["color"] = {
                        ["a"] = 0.1000000238418579,
                        ["r"] = 0.4470588235294117,
                        ["g"] = 0.4470588235294117,
                        ["b"] = 0.4470588235294117
                    }
                }
            },
            ["castNoInterrupt"] = {
                ["a"] = 1,
                ["r"] = 1,
                ["g"] = 0.3882352941176471,
                ["b"] = 0.4941176470588236
            },
            ["health"] = {
                ["r"] = 0.1333333333333333,
                ["g"] = 0.1333333333333333,
                ["b"] = 0.1333333333333333
            },
            ["powerclass"] = true,
            ["transparentHealth"] = true
        },
        ["fontOutline"] = "OUTLINE",
        ["cooldown"] = {
            ["fonts"] = {
                ["enable"] = true,
                ["fontSize"] = 17
            }
        }
    },
    ["datatexts"] = {
        ["panels"] = {
            ["MinimapPanel"] = {
                ["enable"] = false
            },
            ["RightChatDataPanel"] = {
                ["enable"] = false
            },
            ["LeftChatDataPanel"] = {
                ["enable"] = false
            }
        }
    },
    ["actionbar"] = {
        ["bar3"] = {
            ["buttonspacing"] = 4,
            ["buttons"] = 8,
            ["buttonsPerRow"] = 4
        },
        ["fontOutline"] = "OUTLINE",
        ["bar1"] = {
            ["buttonspacing"] = 4
        },
        ["transparent"] = true,
        ["font"] = "Montserrat" .. (W.CompatibleFont and " (en)" or ""),
        ["hotkeyTextYOffset"] = -2,
        ["rightClickSelfCast"] = true,
        ["barPet"] = {
            ["buttonspacing"] = 4,
            ["backdrop"] = false,
            ["inheritGlobalFade"] = true,
            ["buttonsize"] = 37
        },
        ["globalFadeAlpha"] = 0.7000000000000001,
        ["microbar"] = {
            ["buttonSpacing"] = 4
        },
        ["hideCooldownBling"] = true,
        ["bar2"] = {
            ["buttonspacing"] = 4,
            ["enabled"] = true
        },
        ["bar5"] = {
            ["enabled"] = false
        },
        ["zoneActionButton"] = {
            ["clean"] = true
        },
        ["stanceBar"] = {
            ["buttonspacing"] = 4,
            ["buttonsize"] = 24
        },
        ["bar4"] = {
            ["inheritGlobalFade"] = true,
            ["backdrop"] = false
        }
    },
    ["nameplates"] = {
        ["statusbar"] = "WindTools Glow",
        ["cutaway"] = {
            ["health"] = {
                ["enabled"] = true,
                ["fadeOutTime"] = 0.3,
                ["lengthBeforeFade"] = 0.2
            }
        },
        ["units"] = {
            ["TARGET"] = {
                ["glowStyle"] = "style7"
            },
            ["PLAYER"] = {
                ["buffs"] = {
                    ["countFont"] = "Montserrat Bold"
                }
            }
        },
        ["smoothbars"] = true
    },
    ["bags"] = {
        ["itemLevelFont"] = "Montserrat" .. (W.CompatibleFont and " (en)" or ""),
        ["currencyFormat"] = "ICON",
        ["itemLevelFontOutline"] = "OUTLINE",
        ["useBlizzardCleanup"] = true,
        ["junkDesaturate"] = true,
        ["countFont"] = "Montserrat" .. (W.CompatibleFont and " (en)" or ""),
        ["clearSearchOnClose"] = true,
        ["countFontOutline"] = "OUTLINE",
        ["vendorGrays"] = {
            ["enable"] = true
        },
        ["transparent"] = true,
        ["showBindType"] = true,
        ["moneyFormat"] = "SHORTINT"
    },
    ["cooldown"] = {
        ["fonts"] = {
            ["enable"] = true,
            ["font"] = "Accidental Presidency" .. (W.CompatibleFont and " (en)" or ""),
            ["fontSize"] = 27
        }
    },
    ["auras"] = {
        ["debuffs"] = {
            ["countFontSize"] = 18,
            ["durationFontSize"] = 18,
            ["size"] = 42
        },
        ["timeYOffset"] = 6,
        ["fontOutline"] = "OUTLINE",
        ["countYOffset"] = 24,
        ["font"] = "Roadway" .. (W.CompatibleFont and " (en)" or ""),
        ["buffs"] = {
            ["countFontSize"] = 19,
            ["durationFontSize"] = 14,
            ["size"] = 36
        }
    }
}

function W:Fang2houUIProfile()
    local P = select(4, _G.ElvUI)
    E:CopyTable(E.db, P)
    E:CopyTable(E.db, profile)
    E:StaggeredUpdateAll()
end

