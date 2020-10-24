local W, F, E, L, V, P, G = unpack(select(2, ...))

local worldChannel
if W.Locale == "zhCN" then
    worldChannel = "大脚世界频道"
else
    worldChannel = "組隊頻道"
end

local function GetCompatibleFont(name)
    return name .. (W.CompatibleFont and " (en)" or "")
end

local profile = {
    ["databars"] = {
        ["threat"] = {
            ["fontOutline"] = "OUTLINE",
            ["width"] = 417
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
            ["fontSize"] = 8,
            ["hideAtMaxLevel"] = false,
            ["fontOutline"] = "OUTLINE",
            ["height"] = 5,
            ["width"] = 222
        },
        ["azerite"] = {
            ["height"] = 5
        },
        ["customTexture"] = true,
        ["transparent"] = false
    },
    ["general"] = {
        ["totems"] = {
            ["growthDirection"] = "HORIZONTAL",
            ["size"] = 35
        },
        ["fontSize"] = 13,
        ["autoTrackReputation"] = true,
        ["autoAcceptInvite"] = true,
        ["autoRepair"] = "PLAYER",
        ["minimap"] = {
            ["size"] = 220,
            ["icons"] = {
                ["lfgEye"] = {
                    ["position"] = "BOTTOMLEFT",
                    ["yOffset"] = 18
                },
                ["mail"] = {
                    ["yOffset"] = -60
                },
                ["classHall"] = {
                    ["yOffset"] = -30,
                    ["position"] = "TOPRIGHT"
                }
            }
        },
        ["decimalLength"] = 0,
        ["talkingHeadFrameBackdrop"] = true,
        ["resurrectSound"] = true,
        ["backdropfadecolor"] = {
            ["a"] = 0.75,
            ["r"] = 0.047058823529412,
            ["g"] = 0.047058823529412,
            ["b"] = 0.047058823529412
        },
        ["valuecolor"] = {
            ["r"] = 0.058823529411765,
            ["g"] = 0.67843137254902,
            ["b"] = 1
        },
        ["loginmessage"] = false,
        ["itemLevel"] = {
            ["itemLevelFontSize"] = 14
        },
        ["backdropcolor"] = {
            ["r"] = 0.11764705882353,
            ["g"] = 0.11764705882353,
            ["b"] = 0.11764705882353
        },
        ["objectiveFrameAutoHideInKeystone"] = true,
        ["altPowerBar"] = {
            ["statusBarColorGradient"] = true,
            ["smoothbars"] = true
        },
        ["stickyFrames"] = false,
        ["bonusObjectivePosition"] = "RIGHT",
        ["bottomPanel"] = false
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
        ["WTChatBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,45,25",
        ["WTMinimapButtonBarAnchor"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-225",
        ["ElvUF_FocusMover"] = "TOP,ElvUIParent,TOP,341,-502",
        ["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,317",
        ["MicrobarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-658,372",
        ["VehicleSeatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-467,52",
        ["DurabilityFrameMover"] = "TOPLEFT,ElvUF_PlayerMover,BOTTOMLEFT,0,-200",
        ["ExperienceBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-211",
        ["ElvUF_TargetTargetMover"] = "TOPLEFT,ElvUF_TargetMover,TOPRIGHT,5,0",
        ["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,300,300",
        ["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-300,300",
        ["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-45,25",
        ["TotemBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-334,255",
        ["MirrorTimer1Mover"] = "TOP,ElvUIParent,TOP,0,-116",
        ["ElvUF_PetMover"] = "TOPRIGHT,ElvUF_PlayerMover,TOPLEFT,-5,0",
        ["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,-72,62",
        ["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,-72,26",
        ["BelowMinimapContainerMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-36,-276",
        ["ElvAB_4"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-25,337",
        ["WTParagonReputationToastFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,203",
        ["AzeriteBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-218",
        ["AltPowerBarMover"] = "TOP,ElvUIParent,TOP,6,-164",
        ["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,216,26",
        ["ElvAB_5"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-711,123",
        ["VehicleLeaveButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,420",
        ["VOICECHAT"] = "TOPLEFT,ElvUIParent,TOPLEFT,336,-26",
        ["ElvAB_6"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-621,217",
        ["ObjectiveFrameMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,121,-25",
        ["BNETMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,44,224",
        ["ShiftAB"] = "BOTTOMLEFT,ElvAB_1,TOPLEFT,0,5",
        ["ArenaHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-215,366",
        ["HonorBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-625,-212",
        ["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,14,382",
        ["ReputationBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-204",
        ["TalkingHeadFrameMover"] = "TOP,ElvUIParent,TOP,0,-180",
        ["BossHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-240,360",
        ["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,300",
        ["SocialMenuMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,16,127",
        ["ElvUF_PartyMover"] = "RIGHT,ElvUIParent,CENTER,-300,100",
        ["AlertFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,180",
        ["DebuffsMover"] = "TOP,ElvUIParent,TOP,144,-397",
        ["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-25"
    },
    ["v11NamePlateReset"] = true,
    ["tooltip"] = {
        ["itemCount"] = "BOTH",
        ["healthBar"] = {
            ["statusPosition"] = "TOP",
            ["fontSize"] = 15
        },
        ["headerFontSize"] = 15,
        ["textFontSize"] = 13,
        ["fontOutline"] = "OUTLINE",
        ["cursorAnchorType"] = "ANCHOR_CURSOR_RIGHT",
        ["colorAlpha"] = 0.75,
        ["smallTextFontSize"] = 13
    },
    ["chat"] = {
        ["socialQueueMessages"] = true,
        ["fontSize"] = 13,
        ["tabFontOutline"] = "OUTLINE",
        ["keywordSound"] = "OnePlus Surprise",
        ["timeStampFormat"] = "%H:%M ",
        ["useAltKey"] = true,
        ["tabFontSize"] = 13,
        ["customTimeColor"] = {
            ["r"] = 1,
            ["g"] = 0.76470588235294,
            ["b"] = 0.38039215686275
        },
        ["maxLines"] = 2000,
        ["editBoxPosition"] = "ABOVE_CHAT",
        ["channelAlerts"] = {
            ["WHISPER"] = "OnePlus Light"
        },
        ["fontOutline"] = "OUTLINE",
        ["hideChatToggles"] = true,
        ["keywords"] = "%MYNAME%",
        ["tabSelector"] = "NONE",
        ["panelBackdrop"] = "HIDEBOTH"
    },
    ["WT"] = {
        ["announcement"] = {
            ["quest"] = {
                ["includeDetails"] = false,
                ["paused"] = false
            }
        },
        ["combat"] = {
            ["raidMarkers"] = {
                ["mouseOver"] = true,
                ["visibility"] = "ALWAYS"
            }
        },
        ["tooltips"] = {
            ["yOffsetOfHealthBar"] = 5,
            ["yOffsetOfHealthText"] = -7
        },
        ["unitFrames"] = {
            ["castBar"] = {
                ["player"] = {
                    ["enable"] = true,
                    ["text"] = {
                        ["offsetX"] = 6,
                        ["font"] = {
                            ["size"] = 13
                        }
                    },
                    ["time"] = {
                        ["offsetX"] = -5,
                        ["font"] = {
                            ["size"] = 13
                        }
                    }
                },
                ["enable"] = true
            }
        },
        ["item"] = {
            ["extraItemsBar"] = {
                ["bar2"] = {
                    ["numButtons"] = 10,
                    ["buttonsPerRow"] = 10,
                    ["backdrop"] = false
                },
                ["bar1"] = {
                    ["backdrop"] = false
                },
                ["bar3"] = {
                    ["backdrop"] = false
                }
            }
        },
        ["maps"] = {
            ["rectangleMinimap"] = {
                ["enable"] = true
            },
            ["whoClicked"] = {
                ["stayTime"] = 1.5,
                ["yOffset"] = 27
            }
        },
        ["skins"] = {
            ["vignetting"] = {
                ["level"] = 38
            }
        },
        ["social"] = {
            ["chatBar"] = {
                ["channels"] = {
                    ["world"] = {
                        ["enable"] = worldChannel and true or false,
                        ["name"] = worldChannel
                    }
                }
            }
        }
    },
    ["unitframe"] = {
        ["fontSize"] = 12,
        ["units"] = {
            ["pet"] = {
                ["debuffs"] = {
                    ["countFontSize"] = 15,
                    ["countFont"] = GetCompatibleFont("Montserrat Bold"),
                    ["enable"] = true,
                    ["yOffset"] = 80,
                    ["anchorPoint"] = "TOPLEFT",
                    ["spacing"] = 3,
                    ["priority"] = "Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable",
                    ["attachTo"] = "BUFFS",
                    ["perrow"] = 4
                },
                ["aurabar"] = {
                    ["attachTo"] = "DEBUFFS",
                    ["spacing"] = 0,
                    ["detachedWidth"] = 270,
                    ["priority"] = "Blacklist,blockNoDuration,Personal,Boss,RaidDebuffs,PlayerBuffs",
                    ["yOffset"] = 0
                },
                ["cutaway"] = {
                    ["health"] = {
                        ["enabled"] = true,
                        ["fadeOutTime"] = 0.3,
                        ["lengthBeforeFade"] = 0.1
                    }
                },
                ["power"] = {
                    ["height"] = 4
                },
                ["customTexts"] = {
                    ["Name"] = {
                        ["attachTextTo"] = "Health",
                        ["size"] = 12,
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = -2,
                        ["enable"] = true,
                        ["text_format"] = "[name]",
                        ["yOffset"] = 27
                    },
                    ["Power"] = {
                        ["attachTextTo"] = "Health",
                        ["xOffset"] = 2,
                        ["text_format"] = "[mouseover][power:current-percent]",
                        ["yOffset"] = -14,
                        ["font"] = GetCompatibleFont("Accidental Presidency"),
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["size"] = 16
                    },
                    ["Health"] = {
                        ["attachTextTo"] = "Health",
                        ["xOffset"] = 3,
                        ["text_format"] = "[curhp] || [health:percent-nostatus]",
                        ["yOffset"] = -27,
                        ["font"] = GetCompatibleFont("Accidental Presidency"),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["size"] = 16
                    }
                },
                ["width"] = 100,
                ["infoPanel"] = {
                    ["height"] = 20
                },
                ["height"] = 30,
                ["name"] = {
                    ["text_format"] = ""
                },
                ["castbar"] = {
                    ["iconAttachedTo"] = "Castbar",
                    ["timeToHold"] = 0.4,
                    ["height"] = 20,
                    ["displayTarget"] = true,
                    ["width"] = 100,
                    ["iconSize"] = 27,
                    ["iconAttached"] = false,
                    ["icon"] = false,
                    ["textColor"] = {
                        ["b"] = 1,
                        ["g"] = 1,
                        ["r"] = 1
                    }
                },
                ["orientation"] = "RIGHT",
                ["buffs"] = {
                    ["anchorPoint"] = "TOPLEFT",
                    ["spacing"] = 2,
                    ["maxDuration"] = 0,
                    ["priority"] = "Blacklist,Personal,nonPersonal",
                    ["perrow"] = 5,
                    ["yOffset"] = -80
                },
                ["fader"] = {
                    ["playertarget"] = true,
                    ["focus"] = true,
                    ["combat"] = true,
                    ["power"] = true,
                    ["health"] = true,
                    ["casting"] = true,
                    ["range"] = false,
                    ["minAlpha"] = 0
                }
            },
            ["boss"] = {
                ["cutaway"] = {
                    ["health"] = {
                        ["enabled"] = true,
                        ["fadeOutTime"] = 0.3,
                        ["lengthBeforeFade"] = 0.2
                    }
                },
                ["debuffs"] = {
                    ["sizeOverride"] = 30,
                    ["spacing"] = 3,
                    ["xOffset"] = -5,
                    ["perrow"] = 4,
                    ["countFont"] = GetCompatibleFont("Montserrat Bold"),
                    ["yOffset"] = 0
                },
                ["power"] = {
                    ["height"] = 4,
                    ["text_format"] = ""
                },
                ["customTexts"] = {
                    ["Name"] = {
                        ["attachTextTo"] = "Health",
                        ["size"] = 12,
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = -1,
                        ["enable"] = true,
                        ["text_format"] = "[name]",
                        ["yOffset"] = 25
                    },
                    ["Power"] = {
                        ["attachTextTo"] = "Health",
                        ["xOffset"] = 0,
                        ["text_format"] = "[mouseover][power:current-percent]",
                        ["yOffset"] = -14,
                        ["font"] = GetCompatibleFont("Accidental Presidency"),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["size"] = 14
                    },
                    ["Health"] = {
                        ["attachTextTo"] = "Health",
                        ["xOffset"] = 0,
                        ["text_format"] = "[health:percent-nostatus] || [health:current]",
                        ["yOffset"] = 0,
                        ["font"] = GetCompatibleFont("Accidental Presidency"),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["size"] = 16
                    }
                },
                ["castbar"] = {
                    ["height"] = 24,
                    ["width"] = 220
                },
                ["width"] = 220,
                ["name"] = {
                    ["text_format"] = ""
                },
                ["spacing"] = 50,
                ["height"] = 30,
                ["buffs"] = {
                    ["anchorPoint"] = "RIGHT",
                    ["sizeOverride"] = 30,
                    ["spacing"] = 3,
                    ["xOffset"] = 5,
                    ["attachTo"] = "HEALTH",
                    ["countFont"] = GetCompatibleFont("Montserrat Bold"),
                    ["yOffset"] = 0
                },
                ["health"] = {
                    ["text_format"] = ""
                }
            },
            ["targettarget"] = {
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
                ["debuffs"] = {
                    ["anchorPoint"] = "TOPRIGHT",
                    ["attachTo"] = "FRAME",
                    ["perrow"] = 4,
                    ["yOffset"] = 20
                },
                ["power"] = {
                    ["height"] = 4
                },
                ["customTexts"] = {
                    ["Name"] = {
                        ["attachTextTo"] = "Health",
                        ["size"] = 12,
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = 3,
                        ["enable"] = true,
                        ["text_format"] = "[name]",
                        ["yOffset"] = 25
                    },
                    ["Power"] = {
                        ["attachTextTo"] = "Health",
                        ["xOffset"] = -2,
                        ["text_format"] = "[mouseover][power:percent-nosign]",
                        ["yOffset"] = -14,
                        ["font"] = GetCompatibleFont("Accidental Presidency"),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["size"] = 16
                    },
                    ["Health"] = {
                        ["attachTextTo"] = "Health",
                        ["xOffset"] = -2,
                        ["text_format"] = "[health:percent-nostatus] || [curhp]",
                        ["yOffset"] = -27,
                        ["font"] = GetCompatibleFont("Accidental Presidency"),
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["size"] = 16
                    }
                },
                ["width"] = 100,
                ["name"] = {
                    ["text_format"] = ""
                },
                ["height"] = 30
            },
            ["player"] = {
                ["debuffs"] = {
                    ["enable"] = false
                },
                ["portrait"] = {
                    ["overlayAlpha"] = 0.2,
                    ["camDistanceScale"] = 2.88,
                    ["overlay"] = true
                },
                ["raidRoleIcons"] = {
                    ["xOffset"] = 3,
                    ["position"] = "TOPRIGHT"
                },
                ["disableFocusGlow"] = false,
                ["fader"] = {
                    ["enable"] = true,
                    ["vehicle"] = false,
                    ["minAlpha"] = 0
                },
                ["power"] = {
                    ["height"] = 15,
                    ["text_format"] = "",
                    ["detachFromFrame"] = true
                },
                ["cutaway"] = {
                    ["health"] = {
                        ["enabled"] = true,
                        ["fadeOutTime"] = 0.3,
                        ["lengthBeforeFade"] = 0.1
                    },
                    ["power"] = {
                        ["lengthBeforeFade"] = 0.1,
                        ["fadeOutTime"] = 0.3
                    }
                },
                ["classbar"] = {
                    ["height"] = 13,
                    ["detachFromFrame"] = true
                },
                ["aurabar"] = {
                    ["enable"] = false
                },
                ["RestIcon"] = {
                    ["anchorPoint"] = "BOTTOMLEFT",
                    ["yOffset"] = 13,
                    ["size"] = 21,
                    ["color"] = {
                        ["g"] = 0.55686274509804,
                        ["r"] = 0.20392156862745
                    },
                    ["xOffset"] = 13,
                    ["defaultColor"] = false,
                    ["texture"] = "RESTING1"
                },
                ["disableTargetGlow"] = false,
                ["customTexts"] = {
                    ["Name"] = {
                        ["attachTextTo"] = "Health",
                        ["size"] = 12,
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = -2,
                        ["enable"] = true,
                        ["text_format"] = "[name]",
                        ["yOffset"] = 25
                    },
                    ["Power"] = {
                        ["attachTextTo"] = "Power",
                        ["xOffset"] = 0,
                        ["text_format"] = "[power:current]",
                        ["yOffset"] = 7,
                        ["font"] = GetCompatibleFont("Accidental Presidency"),
                        ["justifyH"] = "CENTER",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["size"] = 22
                    },
                    ["Health"] = {
                        ["attachTextTo"] = "Health",
                        ["xOffset"] = 4,
                        ["text_format"] = "[curhp] || [health:percent-nostatus]",
                        ["yOffset"] = -27,
                        ["font"] = GetCompatibleFont("Accidental Presidency"),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["size"] = 16
                    }
                },
                ["disableMouseoverGlow"] = true,
                ["width"] = 220,
                ["infoPanel"] = {
                    ["height"] = 14,
                    ["transparent"] = true
                },
                ["castbar"] = {
                    ["textColor"] = {
                        ["b"] = 1,
                        ["g"] = 1,
                        ["r"] = 1
                    },
                    ["xOffsetTime"] = 0,
                    ["iconAttachedTo"] = "Castbar",
                    ["width"] = 257,
                    ["iconXOffset"] = -4,
                    ["height"] = 24,
                    ["displayTarget"] = true,
                    ["xOffsetText"] = 0,
                    ["iconSize"] = 24,
                    ["format"] = "REMAININGMAX",
                    ["iconAttached"] = false,
                    ["latency"] = false
                },
                ["health"] = {
                    ["text_format"] = ""
                },
                ["height"] = 30,
                ["pvp"] = {
                    ["position"] = "RIGHT"
                },
                ["raidicon"] = {
                    ["size"] = 19
                }
            },
            ["focus"] = {
                ["debuffs"] = {
                    ["anchorPoint"] = "TOPLEFT",
                    ["countFont"] = "Montserrat Bold",
                    ["attachTo"] = "BUFFS",
                    ["spacing"] = 3,
                    ["perrow"] = 4,
                    ["priority"] = "Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable",
                    ["countFontSize"] = 15,
                    ["yOffset"] = 80
                },
                ["disableTargetGlow"] = true,
                ["aurabar"] = {
                    ["maxBars"] = 6,
                    ["detachedWidth"] = 270
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
                    ["timeToHold"] = 0.4,
                    ["height"] = 20,
                    ["displayTarget"] = true,
                    ["width"] = 138,
                    ["iconSize"] = 27,
                    ["iconAttached"] = false,
                    ["icon"] = false,
                    ["textColor"] = {
                        ["b"] = 1,
                        ["g"] = 1,
                        ["r"] = 1
                    }
                },
                ["power"] = {
                    ["height"] = 4
                },
                ["customTexts"] = {
                    ["Name"] = {
                        ["attachTextTo"] = "Health",
                        ["size"] = 12,
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["xOffset"] = 4,
                        ["text_format"] = "[name]",
                        ["yOffset"] = 27
                    },
                    ["Power"] = {
                        ["attachTextTo"] = "Health",
                        ["enable"] = true,
                        ["text_format"] = "[mouseover][power:current-percent]",
                        ["yOffset"] = -14,
                        ["font"] = GetCompatibleFont("Accidental Presidency"),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = -1,
                        ["size"] = 16
                    },
                    ["Health"] = {
                        ["attachTextTo"] = "Health",
                        ["enable"] = true,
                        ["text_format"] = "[health:percent-nostatus] || [curhp]",
                        ["yOffset"] = -27,
                        ["font"] = GetCompatibleFont("Accidental Presidency"),
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = -2,
                        ["size"] = 16
                    }
                },
                ["orientation"] = "RIGHT",
                ["width"] = 138,
                ["infoPanel"] = {
                    ["height"] = 20
                },
                ["height"] = 30,
                ["buffs"] = {
                    ["anchorPoint"] = "TOPLEFT",
                    ["maxDuration"] = 0,
                    ["spacing"] = 2,
                    ["enable"] = true,
                    ["priority"] = "Blacklist,Personal,nonPersonal",
                    ["perrow"] = 5,
                    ["yOffset"] = -80
                },
                ["name"] = {
                    ["text_format"] = ""
                }
            },
            ["target"] = {
                ["debuffs"] = {
                    ["anchorPoint"] = "TOPLEFT",
                    ["countFont"] = "Montserrat Bold",
                    ["spacing"] = 3,
                    ["perrow"] = 6,
                    ["countFontSize"] = 15,
                    ["yOffset"] = 80
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
                ["power"] = {
                    ["height"] = 4,
                    ["text_format"] = ""
                },
                ["customTexts"] = {
                    ["Name"] = {
                        ["attachTextTo"] = "Health",
                        ["size"] = 12,
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = 3,
                        ["enable"] = true,
                        ["text_format"] = "[name]",
                        ["yOffset"] = 25
                    },
                    ["Power"] = {
                        ["attachTextTo"] = "Health",
                        ["xOffset"] = -2,
                        ["text_format"] = "[mouseover][power:percent-nosign]",
                        ["yOffset"] = -14,
                        ["font"] = GetCompatibleFont("Accidental Presidency"),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["size"] = 16
                    },
                    ["Health"] = {
                        ["attachTextTo"] = "Health",
                        ["xOffset"] = -2,
                        ["text_format"] = "[health:percent-nostatus] || [curhp]",
                        ["yOffset"] = -27,
                        ["font"] = GetCompatibleFont("Accidental Presidency"),
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["size"] = 16
                    }
                },
                ["width"] = 220,
                ["health"] = {
                    ["text_format"] = ""
                },
                ["name"] = {
                    ["text_format"] = ""
                },
                ["castbar"] = {
                    ["iconAttachedTo"] = "Castbar",
                    ["iconAttached"] = false,
                    ["iconXOffset"] = -4,
                    ["height"] = 24,
                    ["displayTarget"] = true,
                    ["width"] = 310,
                    ["iconSize"] = 24,
                    ["format"] = "REMAININGMAX",
                    ["timeToHold"] = 0.4,
                    ["textColor"] = {
                        ["b"] = 1,
                        ["g"] = 1,
                        ["r"] = 1
                    }
                },
                ["height"] = 30,
                ["buffs"] = {
                    ["anchorPoint"] = "TOPLEFT",
                    ["spacing"] = 2,
                    ["yOffset"] = -80
                }
            },
            ["raid"] = {
                ["portrait"] = {
                    ["fullOverlay"] = true
                },
                ["rdebuffs"] = {
                    ["font"] = GetCompatibleFont("Montserrat Bold"),
                    ["size"] = 25,
                    ["fontOutline"] = "OUTLINE",
                    ["xOffset"] = 23,
                    ["yOffset"] = 14
                },
                ["power"] = {
                    ["height"] = 4
                },
                ["customTexts"] = {
                    ["Name"] = {
                        ["attachTextTo"] = "Health",
                        ["size"] = 10,
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = 1,
                        ["enable"] = true,
                        ["text_format"] = "[namecolor][name:short]",
                        ["yOffset"] = -11
                    }
                },
                ["summonIcon"] = {
                    ["attachTo"] = "TOPRIGHT"
                },
                ["roleIcon"] = {
                    ["xOffset"] = 2,
                    ["position"] = "TOPLEFT",
                    ["yOffset"] = -2
                },
                ["width"] = 72,
                ["name"] = {
                    ["text_format"] = ""
                },
                ["height"] = 40
            },
            ["party"] = {
                ["debuffs"] = {
                    ["xOffset"] = 3,
                    ["sizeOverride"] = 34,
                    ["countFont"] = GetCompatibleFont("Montserrat Bold"),
                    ["perrow"] = 5
                },
                ["groupBy"] = "ROLE2",
                ["rdebuffs"] = {
                    ["font"] = GetCompatibleFont("Montserrat Bold"),
                    ["fontOutline"] = "OUTLINE",
                    ["xOffset"] = 28,
                    ["yOffset"] = 6
                },
                ["raidRoleIcons"] = {
                    ["xOffset"] = 3
                },
                ["growthDirection"] = "DOWN_RIGHT",
                ["disableFocusGlow"] = true,
                ["verticalSpacing"] = 5,
                ["health"] = {
                    ["text_format"] = ""
                },
                ["cutaway"] = {
                    ["health"] = {
                        ["enabled"] = true
                    }
                },
                ["power"] = {
                    ["height"] = 4,
                    ["hideonnpc"] = true,
                    ["text_format"] = ""
                },
                ["customTexts"] = {
                    ["Name"] = {
                        ["attachTextTo"] = "Health",
                        ["size"] = 12,
                        ["justifyH"] = "LEFT",
                        ["fontOutline"] = "OUTLINE",
                        ["xOffset"] = 22,
                        ["enable"] = true,
                        ["text_format"] = "[namecolor][name] [smartlevel]",
                        ["yOffset"] = 1
                    },
                    ["Health Percent"] = {
                        ["attachTextTo"] = "Health",
                        ["xOffset"] = -2,
                        ["text_format"] = "[health:percent-nostatus-nosign]",
                        ["yOffset"] = 0,
                        ["font"] = GetCompatibleFont("Accidental Presidency"),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["size"] = 22
                    },
                    ["Power"] = {
                        ["attachTextTo"] = "Health",
                        ["xOffset"] = -2,
                        ["text_format"] = "[mouseover][power:percent-nosign]",
                        ["yOffset"] = -16,
                        ["font"] = GetCompatibleFont("Accidental Presidency"),
                        ["justifyH"] = "RIGHT",
                        ["fontOutline"] = "OUTLINE",
                        ["enable"] = true,
                        ["size"] = 13
                    }
                },
                ["summonIcon"] = {
                    ["attachTo"] = "RIGHT",
                    ["xOffset"] = -20
                },
                ["width"] = 154,
                ["castbar"] = {
                    ["width"] = 154
                },
                ["name"] = {
                    ["text_format"] = ""
                },
                ["roleIcon"] = {
                    ["xOffset"] = 5,
                    ["position"] = "LEFT",
                    ["yOffset"] = 0
                },
                ["height"] = 35,
                ["buffs"] = {
                    ["countFont"] = GetCompatibleFont("Montserrat Bold"),
                    ["enable"] = true,
                    ["xOffset"] = -3,
                    ["sizeOverride"] = 34,
                    ["perrow"] = 3
                }
            }
        },
        ["statusbar"] = "WindTools Glow",
        ["colors"] = {
            ["powerclass"] = true,
            ["colorhealthbyvalue"] = false,
            ["customhealthbackdrop"] = true,
            ["healthMultiplier"] = 0.75,
            ["power"] = {
                ["RUNIC_POWER"] = {
                    ["g"] = 0.81960784313725
                },
                ["MANA"] = {
                    ["r"] = 0.30980392156863,
                    ["g"] = 0.45098039215686,
                    ["b"] = 0.63137254901961
                },
                ["MAELSTROM"] = {
                    ["r"] = 0.2156862745098,
                    ["g"] = 0.25882352941176,
                    ["b"] = 0.98039215686275
                },
                ["ENERGY"] = {
                    ["r"] = 0.65098039215686,
                    ["g"] = 0.63137254901961,
                    ["b"] = 0.34901960784314
                }
            },
            ["castColor"] = {
                ["r"] = 0.25882352941176,
                ["g"] = 0.70980392156863,
                ["b"] = 1
            },
            ["transparentHealth"] = true,
            ["frameGlow"] = {
                ["targetGlow"] = {
                    ["enable"] = false
                },
                ["mouseoverGlow"] = {
                    ["color"] = {
                        ["a"] = 0.10000002384186,
                        ["r"] = 0.44705882352941,
                        ["g"] = 0.44705882352941,
                        ["b"] = 0.44705882352941
                    }
                }
            },
            ["castNoInterrupt"] = {
                ["r"] = 1,
                ["g"] = 0.38823529411765,
                ["b"] = 0.49411764705882
            },
            ["health_backdrop"] = {
                ["r"] = 0.51372549019608,
                ["g"] = 0.51372549019608,
                ["b"] = 0.51372549019608
            },
            ["health"] = {
                ["r"] = 0.13333333333333,
                ["g"] = 0.13333333333333,
                ["b"] = 0.13333333333333
            }
        },
        ["fontOutline"] = "OUTLINE",
        ["smoothbars"] = true,
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
                [1] = "Time",
                ["enable"] = false
            }
        }
    },
    ["actionbar"] = {
        ["bar3"] = {
            ["buttonspacing"] = 4,
            ["buttonsPerRow"] = 4,
            ["buttons"] = 8
        },
        ["rightClickSelfCast"] = true,
        ["globalFadeAlpha"] = 0.7,
        ["zoneActionButton"] = {
            ["clean"] = true
        },
        ["fontOutline"] = "OUTLINE",
        ["microbar"] = {
            ["buttonSpacing"] = 4
        },
        ["hideCooldownBling"] = true,
        ["bar2"] = {
            ["enabled"] = true,
            ["buttonspacing"] = 4
        },
        ["bar1"] = {
            ["buttonspacing"] = 4
        },
        ["bar5"] = {
            ["enabled"] = false
        },
        ["extraActionButton"] = {
            ["clean"] = true
        },
        ["font"] = GetCompatibleFont("Montserrat Bold"),
        ["transparent"] = true,
        ["hotkeyTextYOffset"] = -2,
        ["stanceBar"] = {
            ["buttonsize"] = 24,
            ["buttonspacing"] = 4
        },
        ["barPet"] = {
            ["buttonspacing"] = 4,
            ["inheritGlobalFade"] = true,
            ["backdrop"] = false,
            ["buttonsize"] = 37
        },
        ["bar4"] = {
            ["inheritGlobalFade"] = true,
            ["backdrop"] = false
        }
    },
    ["bags"] = {
        ["itemLevelFont"] = GetCompatibleFont("Montserrat Bold"),
        ["currencyFormat"] = "ICON",
        ["countFont"] = GetCompatibleFont("Montserrat Bold"),
        ["vendorGrays"] = {
            ["enable"] = true
        },
        ["transparent"] = true,
        ["clearSearchOnClose"] = true,
        ["countFontOutline"] = "OUTLINE",
        ["junkDesaturate"] = true,
        ["moneyFormat"] = "SHORTINT",
        ["useBlizzardCleanup"] = true,
        ["showBindType"] = true,
        ["itemLevelFontOutline"] = "OUTLINE"
    },
    ["cooldown"] = {
        ["fonts"] = {
            ["enable"] = true,
            ["font"] = GetCompatibleFont("Accidental Presidency"),
            ["fontSize"] = 27
        }
    },
    ["auras"] = {
        ["debuffs"] = {
            ["countFontSize"] = 18,
            ["durationFontSize"] = 18,
            ["size"] = 42
        },
        ["buffs"] = {
            ["countFontSize"] = 19,
            ["durationFontSize"] = 14,
            ["size"] = 36
        },
        ["fontOutline"] = "OUTLINE",
        ["font"] = GetCompatibleFont("Roadway"),
        ["countYOffset"] = 24,
        ["timeYOffset"] = 6
    }
}

function W:Fang2houUIProfile()
    local P = select(4, _G.ElvUI)
    E:CopyTable(E.db, P)
    E:CopyTable(E.db, profile)

    if W.Locale == "zhTW" then
        E.db["general"]["font"] = "預設"
    elseif W.Locale == "zhCN" then
        E.db["general"]["font"] = "默认"
    elseif W.Locale == "koKR" then
        E.db["general"]["font"] = "기본 글꼴"
    end

    E:StaggeredUpdateAll()
end
