local W, F, E, L, V, P, G = unpack(select(2, ...))

local _G = _G
local select = select

local C_CVar_SetCVar = C_CVar.SetCVar

local profile

local function BuildProfile()
    local worldChannel, font1, font2
    if W.Locale == "zhCN" then
        font1 = "默认"
        worldChannel = "大脚世界频道"
    elseif W.Locale == "zhTW" then
        worldChannel = "組隊頻道"
        font1 = "預設"
        font2 = "提示訊息"
    elseif W.Locale == "koKR" then
        font1 = "기본 글꼴"
    else
        font1 = E.db["general"]["font"]
    end

    profile = {
        ["databars"] = {
            ["threat"] = {
                ["width"] = 220,
                ["font"] = font2,
                ["fontOutline"] = "OUTLINE",
                ["fontSize"] = 10
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
                ["width"] = 222,
                ["height"] = 5
            },
            ["customTexture"] = true,
            ["azerite"] = {
                ["height"] = 5
            },
            ["transparent"] = false
        },
        ["general"] = {
            ["decimalLength"] = 0,
            ["backdropfadecolor"] = {
                ["a"] = 0.75,
                ["b"] = 0.047058823529412,
                ["g"] = 0.047058823529412,
                ["r"] = 0.047058823529412
            },
            ["valuecolor"] = {
                ["a"] = 1,
                ["b"] = 1,
                ["g"] = 0.67843137254902,
                ["r"] = 0.058823529411765
            },
            ["loginmessage"] = false,
            ["stickyFrames"] = false,
            ["font"] = font1,
            ["altPowerBar"] = {
                ["smoothbars"] = true,
                ["statusBarColorGradient"] = true,
                ["font"] = font1
            },
            ["fontSize"] = 13,
            ["autoAcceptInvite"] = true,
            ["afk"] = false,
            ["autoRepair"] = "PLAYER",
            ["minimap"] = {
                ["locationFont"] = font2,
                ["icons"] = {
                    ["lfgEye"] = {
                        ["yOffset"] = 18,
                        ["position"] = "BOTTOMLEFT"
                    },
                    ["mail"] = {
                        ["yOffset"] = -22
                    },
                    ["classHall"] = {
                        ["position"] = "TOPRIGHT",
                        ["yOffset"] = -30
                    }
                },
                ["size"] = 220
            },
            ["talkingHeadFrameBackdrop"] = true,
            ["resurrectSound"] = true,
            ["autoTrackReputation"] = true,
            ["smoothingAmount"] = 0.38,
            ["backdropcolor"] = {
                ["b"] = 0.11764705882353,
                ["g"] = 0.11764705882353,
                ["r"] = 0.11764705882353
            },
            ["totems"] = {
                ["size"] = 35,
                ["growthDirection"] = "HORIZONTAL"
            },
            ["bonusObjectivePosition"] = "RIGHT",
            ["bottomPanel"] = false,
            ["itemLevel"] = {
                ["itemLevelFontSize"] = 13,
                ["itemLevelFont"] = font1
            },
            ["objectiveFrameAutoHideInKeystone"] = true
        },
        ["bags"] = {
            ["itemLevelFont"] = F.GetCompatibleFont("Montserrat"),
            ["currencyFormat"] = "ICON",
            ["bagSize"] = 32,
            ["bankSize"] = 32,
            ["moneyFormat"] = "SHORTINT",
            ["useBlizzardCleanup"] = true,
            ["itemLevelFontOutline"] = "OUTLINE",
            ["bagWidth"] = 414,
            ["countFont"] = F.GetCompatibleFont("Montserrat"),
            ["vendorGrays"] = {
                ["enable"] = true
            },
            ["countFontOutline"] = "OUTLINE",
            ["clearSearchOnClose"] = true,
            ["bankWidth"] = 414,
            ["transparent"] = true,
            ["showBindType"] = true,
            ["junkDesaturate"] = true
        },
        ["auras"] = {
            ["debuffs"] = {
                ["countFontSize"] = 14,
                ["countYOffset"] = 34,
                ["timeYOffset"] = 6,
                ["size"] = 42,
                ["timeXOffset"] = 2,
                ["countFont"] = F.GetCompatibleFont("Montserrat"),
                ["fadeThreshold"] = 4,
                ["timeFont"] = F.GetCompatibleFont("Roadway"),
                ["countFontOutline"] = "OUTLINE",
                ["timeFontOutline"] = "OUTLINE",
                ["durationFontSize"] = 18,
                ["timeFontSize"] = 16
            },
            ["fontOutline"] = "OUTLINE",
            ["buffs"] = {
                ["horizontalSpacing"] = 4,
                ["durationFontSize"] = 14,
                ["maxWraps"] = 4,
                ["timeYOffset"] = 6,
                ["countYOffset"] = 26,
                ["wrapAfter"] = 10,
                ["timeXOffset"] = 3,
                ["countFont"] = F.GetCompatibleFont("Montserrat"),
                ["fadeThreshold"] = 4,
                ["timeFont"] = F.GetCompatibleFont("Roadway"),
                ["countFontOutline"] = "OUTLINE",
                ["timeFontOutline"] = "OUTLINE",
                ["countFontSize"] = 14,
                ["timeFontSize"] = 14,
                ["size"] = 34
            },
            ["countYOffset"] = 24,
            ["timeYOffset"] = 6,
            ["font"] = F.GetCompatibleFont("Roadway")
        },
        ["dbConverted"] = 12.13,
        ["WT"] = {
            ["announcement"] = {
                ["quest"] = {
                    ["includeDetails"] = false,
                    ["paused"] = false
                }
            },
            ["maps"] = {
                ["rectangleMinimap"] = {
                    ["enable"] = true
                },
                ["whoClicked"] = {
                    ["yOffset"] = 27,
                    ["stayTime"] = 1.5
                }
            },
            ["tooltips"] = {
                ["yOffsetOfHealthBar"] = 5,
                ["yOffsetOfHealthText"] = -7
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
                        ["countFont"] = {
                            ["size"] = 10
                        },
                        ["backdrop"] = false,
                        ["buttonWidth"] = 29,
                        ["buttonHeight"] = 24,
                        ["bindFont"] = {
                            ["size"] = 10
                        }
                    },
                    ["bar1"] = {
                        ["mouseOver"] = true,
                        ["alphaMin"] = 0.38,
                        ["backdrop"] = false,
                        ["buttonsPerRow"] = 6
                    },
                    ["bar3"] = {
                        ["countFont"] = {
                            ["size"] = 10
                        },
                        ["backdrop"] = false,
                        ["bindFont"] = {
                            ["size"] = 10
                        },
                        ["buttonHeight"] = 24,
                        ["buttonWidth"] = 29
                    }
                }
            },
            ["combat"] = {
                ["combatAlert"] = {
                    ["animationSize"] = 0.8,
                    ["font"] = {
                        ["name"] = font2
                    },
                    ["speed"] = 1.1
                },
                ["raidMarkers"] = {
                    ["tooltip"] = false,
                    ["backdropSpacing"] = 2,
                    ["spacing"] = 5,
                    ["visibility"] = "ALWAYS"
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
                            ["name"] = worldChannel,
                            ["enable"] = not (not worldChannel)
                        }
                    }
                }
            },
            ["quest"] = {
                ["switchButtons"] = {
                    ["hideWithObjectiveTracker"] = true
                }
            },
            ["misc"] = {
                ["disableTalkingHead"] = true,
                ["gameBar"] = {
                    ["right"] = {
                        [7] = "VOLUME"
                    }
                }
            }
        },
        ["movers"] = {
            ["WTRaidMarkersBarAnchor"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-45,25",
            ["TopCenterContainerMover"] = "TOP,ElvUIParent,TOP,0,-75",
            ["ThreatBarMover"] = "TOP,ElvUF_TargetMover,BOTTOM,0,-20",
            ["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,140",
            ["ElvUF_RaidMover"] = "RIGHT,ElvUIParent,CENTER,-150,0",
            ["LeftChatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,43,35",
            ["GMMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,44,224",
            ["BuffsMover"] = "TOPRIGHT,MinimapMover,TOPLEFT,-10,0",
            ["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,211,450",
            ["LootFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,236,96",
            ["ZoneAbility"] = "BOTTOM,ElvUIParent,BOTTOM,259,450",
            ["SocialMenuMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,16,127",
            ["WTMinimapButtonBarAnchor"] = "TOP,MinimapMover,BOTTOM,0,-22",
            ["ElvUF_FocusMover"] = "CENTER,ElvUIParent,CENTER,265,0",
            ["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,310",
            ["DurabilityFrameMover"] = "BOTTOMRIGHT,ElvAB_4,TOPRIGHT,0,20",
            ["VehicleSeatMover"] = "RIGHT,RightChatMover,LEFT,-20,0",
            ["WTChatBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,45,25",
            ["ExperienceBarMover"] = "TOP,MinimapMover,BOTTOM,0,-2",
            ["PetAB"] = "BOTTOM,ElvAB_1,TOP,0,8",
            ["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,300,292",
            ["ElvUF_PetMover"] = "TOPRIGHT,ElvUF_PlayerMover,TOPLEFT,-5,0",
            ["WTExtraItemsBar2Mover"] = "BOTTOMLEFT,RightChatMover,TOPLEFT,-2,3",
            ["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-45,64",
            ["MirrorTimer1Mover"] = "TOP,ElvUIParent,TOP,0,-116",
            ["TalkingHeadFrameMover"] = "TOP,ElvUIParent,TOP,0,-180",
            ["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,59",
            ["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,0,25",
            ["BelowMinimapContainerMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-36,-276",
            ["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,292",
            ["ElvAB_4"] = "BOTTOM,ElvUIParent,BOTTOM,262,25",
            ["AzeriteBarMover"] = "TOP,MinimapMover,BOTTOM,0,-14",
            ["AltPowerBarMover"] = "TOP,ElvUIParent,TOP,0,-140",
            ["WTExtraItemsBar1Mover"] = "BOTTOM,ElvUIParent,BOTTOM,304,370",
            ["ReputationBarMover"] = "TOP,MinimapMover,BOTTOM,0,-8",
            ["VehicleLeaveButton"] = "BOTTOM,ElvAB_1,TOP,0,45",
            ["WTExtraItemsBar3Mover"] = "BOTTOMLEFT,WTExtraItemsBar2Mover,TOPLEFT,0,4",
            ["ElvUF_TargetTargetMover"] = "TOPLEFT,ElvUF_TargetMover,TOPRIGHT,5,0",
            ["ObjectiveFrameMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,121,-25",
            ["BNETMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,44,224",
            ["ShiftAB"] = "BOTTOMLEFT,ElvAB_3,TOPLEFT,0,4",
            ["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,381",
            ["VOICECHAT"] = "TOPLEFT,ElvUIParent,TOPLEFT,336,-26",
            ["ArenaHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-215,366",
            ["TooltipMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-478,0",
            ["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,-261,25",
            ["BossHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-143,360",
            ["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-299,292",
            ["TotemBarMover"] = "TOPLEFT,ElvUF_PlayerMover,BOTTOMLEFT,-4,-4",
            ["ElvUF_PartyMover"] = "RIGHT,ElvUIParent,CENTER,-250,0",
            ["AlertFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,94",
            ["DebuffsMover"] = "TOP,ElvUIParent,TOP,112,-404",
            ["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-25,-25"
        },
        ["chat"] = {
            ["tabFontOutline"] = "OUTLINE",
            ["keywordSound"] = "OnePlus Surprise",
            ["tabFont"] = font2,
            ["useAltKey"] = true,
            ["tabSelectorColor"] = {
                ["r"] = 0.05882352941176471,
                ["g"] = 0.6784313725490196,
                ["b"] = 1
            },
            ["fontOutline"] = "OUTLINE",
            ["maxLines"] = 2000,
            ["tabSelector"] = "BOX1",
            ["customTimeColor"] = {
                ["b"] = 0.38039215686275,
                ["g"] = 0.76470588235294,
                ["r"] = 1
            },
            ["useBTagName"] = true,
            ["separateSizes"] = true,
            ["fadeChatToggles"] = false,
            ["panelHeightRight"] = 162,
            ["font"] = "聊天",
            ["channelAlerts"] = {
                ["WHISPER"] = "OnePlus Light"
            },
            ["panelWidth"] = 406,
            ["fontSize"] = 13,
            ["tabFontSize"] = 13,
            ["editBoxPosition"] = "ABOVE_CHAT_INSIDE",
            ["panelWidthRight"] = 385,
            ["panelBackdrop"] = "RIGHT",
            ["hideChatToggles"] = true,
            ["keywords"] = "%MYNAME%",
            ["timeStampFormat"] = "%H:%M ",
            ["historySize"] = 300,
            ["fadeTabsNoBackdrop"] = false,
            ["hideVoiceButtons"] = true
        },
        ["unitframe"] = {
            ["targetOnMouseDown"] = true,
            ["fontSize"] = 12,
            ["fontOutline"] = "OUTLINE",
            ["units"] = {
                ["party"] = {
                    ["debuffs"] = {
                        ["countFontSize"] = 11,
                        ["sizeOverride"] = 34,
                        ["xOffset"] = 3,
                        ["spacing"] = 2,
                        ["countFont"] = F.GetCompatibleFont("Montserrat"),
                        ["perrow"] = 5
                    },
                    ["customTexts"] = {
                        ["Power"] = {
                            ["attachTextTo"] = "Health",
                            ["enable"] = true,
                            ["text_format"] = "[mouseover][power:percent-nosign]",
                            ["yOffset"] = -15,
                            ["font"] = F.GetCompatibleFont("Accidental Presidency"),
                            ["justifyH"] = "RIGHT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = -2,
                            ["size"] = 15
                        },
                        ["Name"] = {
                            ["attachTextTo"] = "Health",
                            ["enable"] = true,
                            ["text_format"] = "[namecolor][name] [smartlevel]",
                            ["yOffset"] = 1,
                            ["font"] = font2,
                            ["justifyH"] = "LEFT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = 22,
                            ["size"] = 12
                        },
                        ["Health Percent"] = {
                            ["attachTextTo"] = "Health",
                            ["enable"] = true,
                            ["text_format"] = "[health:percent-nostatus-nosign]",
                            ["yOffset"] = 0,
                            ["font"] = F.GetCompatibleFont("Accidental Presidency"),
                            ["justifyH"] = "RIGHT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = -2,
                            ["size"] = 20
                        }
                    },
                    ["name"] = {
                        ["text_format"] = ""
                    },
                    ["height"] = 34,
                    ["buffs"] = {
                        ["countFontSize"] = 11,
                        ["sizeOverride"] = 34,
                        ["enable"] = true,
                        ["spacing"] = 2,
                        ["countFont"] = F.GetCompatibleFont("Montserrat"),
                        ["perrow"] = 3,
                        ["xOffset"] = -3
                    },
                    ["rdebuffs"] = {
                        ["xOffset"] = 28,
                        ["yOffset"] = 6,
                        ["font"] = F.GetCompatibleFont("Montserrat"),
                        ["fontOutline"] = "OUTLINE"
                    },
                    ["raidRoleIcons"] = {
                        ["xOffset"] = 3
                    },
                    ["growthDirection"] = "DOWN_RIGHT",
                    ["disableFocusGlow"] = true,
                    ["groupBy"] = "ROLE",
                    ["buffIndicator"] = {
                        ["size"] = 7
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
                    ["verticalSpacing"] = 5,
                    ["power"] = {
                        ["text_format"] = "",
                        ["height"] = 4,
                        ["hideonnpc"] = true
                    }
                },
                ["focustarget"] = {
                    ["castbar"] = {
                        ["width"] = 100
                    },
                    ["width"] = 100,
                    ["height"] = 33
                },
                ["pet"] = {
                    ["debuffs"] = {
                        ["countFontSize"] = 15,
                        ["enable"] = true,
                        ["yOffset"] = 80,
                        ["anchorPoint"] = "TOPLEFT",
                        ["spacing"] = 3,
                        ["priority"] = "Blacklist,Personal,RaidDebuffs,CCDebuffs,Friendly:Dispellable",
                        ["countFont"] = "Montserrat Bold (en)",
                        ["perrow"] = 4,
                        ["attachTo"] = "BUFFS"
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
                            ["r"] = 1,
                            ["g"] = 1,
                            ["b"] = 1
                        }
                    },
                    ["customTexts"] = {
                        ["Name"] = {
                            ["attachTextTo"] = "Frame",
                            ["enable"] = true,
                            ["text_format"] = "[name]",
                            ["yOffset"] = 27,
                            ["font"] = font2,
                            ["justifyH"] = "LEFT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = 0,
                            ["size"] = 12
                        },
                        ["Health"] = {
                            ["attachTextTo"] = "Health",
                            ["enable"] = true,
                            ["text_format"] = "[namecolor][health:current-nostatus]||r  [health:percent-nostatus]",
                            ["yOffset"] = -16,
                            ["font"] = F.GetCompatibleFont("Accidental Presidency"),
                            ["justifyH"] = "RIGHT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = -4,
                            ["size"] = 17
                        },
                        ["Power"] = {
                            ["attachTextTo"] = "Health",
                            ["enable"] = true,
                            ["text_format"] = "[mouseover][power:current-percent]",
                            ["yOffset"] = -14,
                            ["font"] = F.GetCompatibleFont("Accidental Presidency"),
                            ["justifyH"] = "LEFT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = 2,
                            ["size"] = 16
                        }
                    },
                    ["width"] = 100,
                    ["infoPanel"] = {
                        ["height"] = 20
                    },
                    ["name"] = {
                        ["text_format"] = ""
                    },
                    ["power"] = {
                        ["height"] = 4
                    },
                    ["height"] = 33,
                    ["buffs"] = {
                        ["yOffset"] = -80,
                        ["anchorPoint"] = "TOPLEFT",
                        ["spacing"] = 2,
                        ["priority"] = "Blacklist,Personal,nonPersonal",
                        ["perrow"] = 5,
                        ["maxDuration"] = 0
                    },
                    ["fader"] = {
                        ["hover"] = true,
                        ["unittarget"] = true,
                        ["combat"] = true,
                        ["power"] = true,
                        ["range"] = false,
                        ["minAlpha"] = 0,
                        ["playertarget"] = true,
                        ["health"] = true,
                        ["focus"] = true,
                        ["casting"] = true,
                        ["smooth"] = 0.38
                    },
                    ["orientation"] = "RIGHT"
                },
                ["target"] = {
                    ["debuffs"] = {
                        ["countFontSize"] = 15,
                        ["yOffset"] = 80,
                        ["anchorPoint"] = "TOPLEFT",
                        ["spacing"] = 3,
                        ["countFont"] = F.GetCompatibleFont("Montserrat"),
                        ["perrow"] = 6
                    },
                    ["health"] = {
                        ["text_format"] = ""
                    },
                    ["raidRoleIcons"] = {
                        ["xOffset"] = 3
                    },
                    ["CombatIcon"] = {
                        ["enable"] = false
                    },
                    ["aurabar"] = {
                        ["enable"] = false
                    },
                    ["cutaway"] = {
                        ["health"] = {
                            ["fadeOutTime"] = 0.3,
                            ["lengthBeforeFade"] = 0.1
                        }
                    },
                    ["power"] = {
                        ["text_format"] = "",
                        ["height"] = 4,
                        ["hideonnpc"] = true
                    },
                    ["customTexts"] = {
                        ["Health"] = {
                            ["attachTextTo"] = "Health",
                            ["enable"] = true,
                            ["text_format"] = "[health:percent-nostatus]  [namecolor][health:current-nostatus]||r",
                            ["yOffset"] = -15,
                            ["font"] = F.GetCompatibleFont("Accidental Presidency"),
                            ["justifyH"] = "LEFT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = 5,
                            ["size"] = 17
                        },
                        ["Name"] = {
                            ["attachTextTo"] = "Frame",
                            ["enable"] = true,
                            ["text_format"] = "[name]",
                            ["yOffset"] = 27,
                            ["font"] = font2,
                            ["justifyH"] = "RIGHT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = 3,
                            ["size"] = 12
                        },
                        ["Power"] = {
                            ["attachTextTo"] = "Health",
                            ["enable"] = true,
                            ["text_format"] = "[mouseover][powercolor][power:percent-nosign]",
                            ["yOffset"] = -15,
                            ["font"] = F.GetCompatibleFont("Accidental Presidency"),
                            ["justifyH"] = "RIGHT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = -2,
                            ["size"] = 17
                        }
                    },
                    ["width"] = 220,
                    ["portrait"] = {
                        ["overlay"] = true,
                        ["width"] = 86,
                        ["rotation"] = 300,
                        ["fullOverlay"] = true,
                        ["xOffset"] = 0.3300000000000001
                    },
                    ["name"] = {
                        ["text_format"] = ""
                    },
                    ["castbar"] = {
                        ["yOffsetTime"] = 20,
                        ["xOffsetTime"] = -2,
                        ["iconAttachedTo"] = "Castbar",
                        ["iconXOffset"] = 34,
                        ["yOffsetText"] = 20,
                        ["xOffsetText"] = 40,
                        ["iconSize"] = 29,
                        ["format"] = "REMAININGMAX",
                        ["customTimeFont"] = {
                            ["enable"] = true,
                            ["font"] = F.GetCompatibleFont("Montserrat"),
                            ["fontSize"] = 13
                        },
                        ["iconAttached"] = false,
                        ["customTextFont"] = {
                            ["enable"] = true,
                            ["font"] = font1,
                            ["fontSize"] = 13
                        },
                        ["width"] = 354,
                        ["displayTarget"] = true,
                        ["height"] = 15,
                        ["iconYOffset"] = 13,
                        ["timeToHold"] = 0.4,
                        ["textColor"] = {
                            ["r"] = 1,
                            ["g"] = 1,
                            ["b"] = 1
                        }
                    },
                    ["height"] = 33,
                    ["buffs"] = {
                        ["yOffset"] = -80,
                        ["anchorPoint"] = "TOPLEFT",
                        ["spacing"] = 2,
                        ["countFont"] = F.GetCompatibleFont("Montserrat")
                    },
                    ["fader"] = {
                        ["delay"] = 1,
                        ["smooth"] = 0.38
                    }
                },
                ["arena"] = {
                    ["enable"] = false
                },
                ["boss"] = {
                    ["debuffs"] = {
                        ["sizeOverride"] = 30,
                        ["yOffset"] = 0,
                        ["spacing"] = 3,
                        ["countFont"] = F.GetCompatibleFont("Montserrat"),
                        ["perrow"] = 4,
                        ["xOffset"] = -5
                    },
                    ["spacing"] = 55,
                    ["health"] = {
                        ["text_format"] = ""
                    },
                    ["cutaway"] = {
                        ["health"] = {
                            ["fadeOutTime"] = 0.3,
                            ["lengthBeforeFade"] = 0.2
                        }
                    },
                    ["power"] = {
                        ["text_format"] = "",
                        ["height"] = 4
                    },
                    ["customTexts"] = {
                        ["Name"] = {
                            ["attachTextTo"] = "Frame",
                            ["enable"] = true,
                            ["text_format"] = "[name]",
                            ["yOffset"] = 27,
                            ["font"] = font2,
                            ["justifyH"] = "RIGHT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = 0,
                            ["size"] = 12
                        },
                        ["Health"] = {
                            ["attachTextTo"] = "Health",
                            ["enable"] = true,
                            ["text_format"] = "[health:percent-nostatus]  [namecolor][health:current-nostatus]||r",
                            ["yOffset"] = -16,
                            ["font"] = F.GetCompatibleFont("Accidental Presidency"),
                            ["justifyH"] = "LEFT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = 4,
                            ["size"] = 17
                        },
                        ["Power"] = {
                            ["attachTextTo"] = "Health",
                            ["enable"] = true,
                            ["text_format"] = "[mouseover][power:current-percent]",
                            ["yOffset"] = -14,
                            ["font"] = F.GetCompatibleFont("Accidental Presidency"),
                            ["justifyH"] = "RIGHT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = 0,
                            ["size"] = 14
                        }
                    },
                    ["width"] = 220,
                    ["name"] = {
                        ["text_format"] = ""
                    },
                    ["height"] = 33,
                    ["buffs"] = {
                        ["sizeOverride"] = 30,
                        ["yOffset"] = 0,
                        ["anchorPoint"] = "RIGHT",
                        ["spacing"] = 3,
                        ["countFont"] = F.GetCompatibleFont("Montserrat"),
                        ["attachTo"] = "HEALTH",
                        ["xOffset"] = 5
                    },
                    ["castbar"] = {
                        ["yOffsetTime"] = -18,
                        ["xOffsetTime"] = -2,
                        ["displayTarget"] = true,
                        ["iconXOffset"] = 35,
                        ["yOffsetText"] = -18,
                        ["xOffsetText"] = 40,
                        ["iconSize"] = 29,
                        ["iconPosition"] = "BOTTOMLEFT",
                        ["customTimeFont"] = {
                            ["enable"] = true,
                            ["font"] = F.GetCompatibleFont("Montserrat"),
                            ["fontSize"] = 13
                        },
                        ["iconAttached"] = false,
                        ["customTextFont"] = {
                            ["enable"] = true,
                            ["font"] = font1,
                            ["fontSize"] = 13
                        },
                        ["width"] = 220,
                        ["strataAndLevel"] = {
                            ["useCustomLevel"] = true
                        },
                        ["height"] = 15,
                        ["iconYOffset"] = -7,
                        ["textColor"] = {
                            ["r"] = 1,
                            ["g"] = 1,
                            ["b"] = 1
                        }
                    }
                },
                ["raid40"] = {
                    ["visibility"] = "[@raid31,noexists] hide;show"
                },
                ["focus"] = {
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
                    ["height"] = 33,
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
                    ["power"] = {
                        ["height"] = 4
                    },
                    ["customTexts"] = {
                        ["Name"] = {
                            ["attachTextTo"] = "Health",
                            ["yOffset"] = 27,
                            ["justifyH"] = "RIGHT",
                            ["fontOutline"] = "OUTLINE",
                            ["enable"] = true,
                            ["xOffset"] = 4,
                            ["text_format"] = "[name]",
                            ["size"] = 12
                        },
                        ["Health"] = {
                            ["attachTextTo"] = "Health",
                            ["xOffset"] = 5,
                            ["text_format"] = "[health:percent-nostatus]  [namecolor][health:current-nostatus]||r",
                            ["yOffset"] = -15,
                            ["font"] = F.GetCompatibleFont("Accidental Presidency"),
                            ["justifyH"] = "LEFT",
                            ["fontOutline"] = "OUTLINE",
                            ["enable"] = true,
                            ["size"] = 17
                        },
                        ["Power"] = {
                            ["attachTextTo"] = "Health",
                            ["xOffset"] = -1,
                            ["text_format"] = "[mouseover][power:current-percent]",
                            ["yOffset"] = -14,
                            ["font"] = F.GetCompatibleFont("Accidental Presidency"),
                            ["justifyH"] = "RIGHT",
                            ["fontOutline"] = "OUTLINE",
                            ["enable"] = true,
                            ["size"] = 16
                        }
                    },
                    ["width"] = 150,
                    ["infoPanel"] = {
                        ["height"] = 20
                    },
                    ["name"] = {
                        ["text_format"] = ""
                    },
                    ["orientation"] = "RIGHT",
                    ["buffs"] = {
                        ["yOffset"] = -80,
                        ["anchorPoint"] = "TOPLEFT",
                        ["spacing"] = 3,
                        ["priority"] = "Blacklist,Personal,nonPersonal",
                        ["perrow"] = 5,
                        ["maxDuration"] = 0
                    },
                    ["castbar"] = {
                        ["yOffsetTime"] = -7,
                        ["iconPosition"] = "RIGHT",
                        ["customTextFont"] = {
                            ["enable"] = true,
                            ["font"] = font1,
                            ["fontSize"] = 13
                        },
                        ["yOffsetText"] = -7,
                        ["iconSize"] = 49,
                        ["customTimeFont"] = {
                            ["enable"] = true,
                            ["font"] = F.GetCompatibleFont("Montserrat"),
                            ["fontSize"] = 13
                        },
                        ["iconAttached"] = false,
                        ["iconYOffset"] = -8,
                        ["width"] = 150,
                        ["iconXOffset"] = 3,
                        ["strataAndLevel"] = {
                            ["useCustomLevel"] = true
                        },
                        ["height"] = 15,
                        ["displayTarget"] = true,
                        ["timeToHold"] = 0.4,
                        ["textColor"] = {
                            ["r"] = 1,
                            ["g"] = 1,
                            ["b"] = 1
                        }
                    }
                },
                ["assist"] = {
                    ["enable"] = false
                },
                ["raid"] = {
                    ["portrait"] = {
                        ["fullOverlay"] = true
                    },
                    ["classbar"] = {
                        ["height"] = 8
                    },
                    ["customTexts"] = {
                        ["Name"] = {
                            ["attachTextTo"] = "Frame",
                            ["enable"] = true,
                            ["text_format"] = "[namecolor][name:short]",
                            ["yOffset"] = -5,
                            ["font"] = "聊天",
                            ["justifyH"] = "RIGHT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = 0,
                            ["size"] = 12
                        },
                        ["Deficit"] = {
                            ["attachTextTo"] = "Health",
                            ["xOffset"] = 18,
                            ["text_format"] = "[healthcolor][health:deficit]",
                            ["yOffset"] = 8,
                            ["font"] = F.GetCompatibleFont("Montserrat"),
                            ["justifyH"] = "LEFT",
                            ["fontOutline"] = "OUTLINE",
                            ["enable"] = true,
                            ["size"] = 12
                        }
                    },
                    ["healPrediction"] = {
                        ["enable"] = true,
                        ["absorbStyle"] = "REVERSED",
                        ["height"] = 5
                    },
                    ["name"] = {
                        ["text_format"] = ""
                    },
                    ["height"] = 40,
                    ["visibility"] = "[@raid6,noexists][@raid31,exists] hide;show",
                    ["rdebuffs"] = {
                        ["xOffset"] = 21,
                        ["yOffset"] = 12,
                        ["font"] = F.GetCompatibleFont("Montserrat"),
                        ["fontOutline"] = "OUTLINE",
                        ["size"] = 25
                    },
                    ["roleIcon"] = {
                        ["yOffset"] = -2,
                        ["position"] = "TOPLEFT",
                        ["xOffset"] = 2
                    },
                    ["power"] = {
                        ["powerPrediction"] = true,
                        ["height"] = 4
                    },
                    ["summonIcon"] = {
                        ["attachTo"] = "TOPRIGHT"
                    },
                    ["health"] = {
                        ["text_format"] = ""
                    },
                    ["numGroups"] = 6
                },
                ["player"] = {
                    ["debuffs"] = {
                        ["enable"] = false
                    },
                    ["portrait"] = {
                        ["overlay"] = true,
                        ["fullOverlay"] = true,
                        ["camDistanceScale"] = 2.88,
                        ["overlayAlpha"] = 0.2
                    },
                    ["CombatIcon"] = {
                        ["xOffset"] = 15,
                        ["anchorPoint"] = "BOTTOMLEFT",
                        ["texture"] = "CUSTOM",
                        ["customTexture"] = "Interface/Addons/ElvUI_WindTools/Media/Icons/Combat.tga",
                        ["size"] = 12
                    },
                    ["customTexts"] = {
                        ["Name"] = {
                            ["attachTextTo"] = "Frame",
                            ["xOffset"] = 0,
                            ["text_format"] = "[name]",
                            ["yOffset"] = 27,
                            ["font"] = font2,
                            ["justifyH"] = "LEFT",
                            ["fontOutline"] = "OUTLINE",
                            ["enable"] = true,
                            ["size"] = 12
                        },
                        ["Deficit"] = {
                            ["attachTextTo"] = "Health",
                            ["xOffset"] = -5,
                            ["text_format"] = "[health:deficit-nostatus]",
                            ["yOffset"] = 3,
                            ["font"] = F.GetCompatibleFont("Montserrat"),
                            ["justifyH"] = "RIGHT",
                            ["fontOutline"] = "OUTLINE",
                            ["enable"] = true,
                            ["size"] = 16
                        },
                        ["Health"] = {
                            ["attachTextTo"] = "Health",
                            ["enable"] = true,
                            ["text_format"] = "[namecolor][health:current-nostatus]||r  [health:percent-nostatus]",
                            ["yOffset"] = -16,
                            ["font"] = F.GetCompatibleFont("Accidental Presidency"),
                            ["justifyH"] = "RIGHT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = -4,
                            ["size"] = 17
                        },
                        ["Power"] = {
                            ["attachTextTo"] = "Power",
                            ["enable"] = true,
                            ["text_format"] = "[smart-power-nosign]",
                            ["yOffset"] = 7,
                            ["font"] = F.GetCompatibleFont("Montserrat"),
                            ["justifyH"] = "CENTER",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = 0,
                            ["size"] = 18
                        }
                    },
                    ["healPrediction"] = {
                        ["height"] = 9,
                        ["absorbStyle"] = "REVERSED",
                        ["anchorPoint"] = "TOP"
                    },
                    ["disableMouseoverGlow"] = true,
                    ["infoPanel"] = {
                        ["height"] = 14,
                        ["transparent"] = true
                    },
                    ["height"] = 33,
                    ["raidicon"] = {
                        ["size"] = 20
                    },
                    ["disableFocusGlow"] = false,
                    ["fader"] = {
                        ["enable"] = true,
                        ["minAlpha"] = 0,
                        ["focus"] = true,
                        ["vehicle"] = false,
                        ["smooth"] = 0.38
                    },
                    ["aurabar"] = {
                        ["enable"] = false
                    },
                    ["cutaway"] = {
                        ["health"] = {
                            ["fadeOutTime"] = 0.3,
                            ["lengthBeforeFade"] = 0.1
                        },
                        ["power"] = {
                            ["fadeOutTime"] = 0.3,
                            ["lengthBeforeFade"] = 0.1
                        }
                    },
                    ["classbar"] = {
                        ["detachFromFrame"] = true,
                        ["height"] = 15,
                        ["detachedWidth"] = 270
                    },
                    ["power"] = {
                        ["detachFromFrame"] = true,
                        ["text_format"] = "",
                        ["detachedWidth"] = 270,
                        ["height"] = 15
                    },
                    ["disableTargetGlow"] = false,
                    ["width"] = 220,
                    ["raidRoleIcons"] = {
                        ["xOffset"] = 3,
                        ["position"] = "TOPRIGHT"
                    },
                    ["health"] = {
                        ["text_format"] = ""
                    },
                    ["RestIcon"] = {
                        ["xOffset"] = 15,
                        ["yOffset"] = 0,
                        ["anchorPoint"] = "LEFT",
                        ["color"] = {
                            ["g"] = 0.55686274509804,
                            ["r"] = 0.20392156862745
                        },
                        ["customTexture"] = "Interface/Addons/ElvUI_WindTools/Media/Textures/Rest.tga",
                        ["texture"] = "CUSTOM",
                        ["size"] = 16
                    },
                    ["castbar"] = {
                        ["yOffsetTime"] = 20,
                        ["xOffsetTime"] = -2,
                        ["iconAttachedTo"] = "Castbar",
                        ["iconYOffset"] = 13,
                        ["iconXOffset"] = 34,
                        ["yOffsetText"] = 20,
                        ["xOffsetText"] = 40,
                        ["iconSize"] = 29,
                        ["format"] = "REMAININGMAX",
                        ["customTimeFont"] = {
                            ["enable"] = true,
                            ["font"] = F.GetCompatibleFont("Montserrat"),
                            ["fontSize"] = 13
                        },
                        ["iconAttached"] = false,
                        ["customTextFont"] = {
                            ["enable"] = true,
                            ["font"] = font1,
                            ["fontSize"] = 13
                        },
                        ["displayTarget"] = true,
                        ["height"] = 15,
                        ["textColor"] = {
                            ["r"] = 1,
                            ["g"] = 1,
                            ["b"] = 1
                        }
                    },
                    ["pvp"] = {
                        ["position"] = "RIGHT"
                    }
                },
                ["targettarget"] = {
                    ["debuffs"] = {
                        ["yOffset"] = 20,
                        ["anchorPoint"] = "TOPRIGHT",
                        ["priority"] = "Blacklist,Personal,Boss,Boss,RaidDebuffs,CCDebuffs,Dispellable",
                        ["perrow"] = 4,
                        ["attachTo"] = "FRAME"
                    },
                    ["cutaway"] = {
                        ["health"] = {
                            ["fadeOutTime"] = 0.3,
                            ["lengthBeforeFade"] = 0.1
                        },
                        ["power"] = {
                            ["fadeOutTime"] = 0.3,
                            ["lengthBeforeFade"] = 0.1
                        }
                    },
                    ["power"] = {
                        ["height"] = 4
                    },
                    ["customTexts"] = {
                        ["Name"] = {
                            ["attachTextTo"] = "Frame",
                            ["enable"] = true,
                            ["text_format"] = "[name]",
                            ["yOffset"] = 27,
                            ["font"] = font2,
                            ["justifyH"] = "RIGHT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = 3,
                            ["size"] = 12
                        },
                        ["Health"] = {
                            ["attachTextTo"] = "Health",
                            ["enable"] = true,
                            ["text_format"] = "[health:percent-nostatus]  [namecolor][health:current-nostatus]||r",
                            ["yOffset"] = -15,
                            ["font"] = F.GetCompatibleFont("Accidental Presidency"),
                            ["justifyH"] = "LEFT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = 5,
                            ["size"] = 17
                        },
                        ["Power"] = {
                            ["attachTextTo"] = "Health",
                            ["enable"] = true,
                            ["text_format"] = "[mouseover][powercolor][power:percent-nosign]",
                            ["yOffset"] = -15,
                            ["font"] = F.GetCompatibleFont("Accidental Presidency"),
                            ["justifyH"] = "RIGHT",
                            ["fontOutline"] = "OUTLINE",
                            ["xOffset"] = -2,
                            ["size"] = 17
                        }
                    },
                    ["width"] = 100,
                    ["name"] = {
                        ["text_format"] = ""
                    },
                    ["height"] = 33,
                    ["fader"] = {
                        ["minAlpha"] = 0.38,
                        ["smooth"] = 0.38
                    }
                }
            },
            ["smoothbars"] = true,
            ["colors"] = {
                ["customhealthbackdrop"] = true,
                ["healthMultiplier"] = 0.75,
                ["healPrediction"] = {
                    ["absorbs"] = {
                        ["a"] = 0.4122328162193298,
                        ["r"] = 0.3686274509803922,
                        ["g"] = 0.8784313725490196,
                        ["b"] = 1
                    },
                    ["overabsorbs"] = {
                        ["a"] = 0.3946786522865295,
                        ["r"] = 0.3686274509803922,
                        ["g"] = 0.8784313725490196,
                        ["b"] = 1
                    }
                },
                ["colorhealthbyvalue"] = false,
                ["health_backdrop"] = {
                    ["b"] = 0.51372549019608,
                    ["g"] = 0.51372549019608,
                    ["r"] = 0.51372549019608
                },
                ["power"] = {
                    ["MANA"] = {
                        ["b"] = 0.9764705882352941,
                        ["g"] = 0.611764705882353,
                        ["r"] = 0.1764705882352941
                    },
                    ["RUNIC_POWER"] = {
                        ["g"] = 0.81960784313725
                    },
                    ["MAELSTROM"] = {
                        ["b"] = 0.98039215686275,
                        ["g"] = 0.25882352941176,
                        ["r"] = 0.2156862745098
                    },
                    ["ENERGY"] = {
                        ["b"] = 0.34901960784314,
                        ["g"] = 0.63137254901961,
                        ["r"] = 0.65098039215686
                    }
                },
                ["castColor"] = {
                    ["b"] = 1,
                    ["g"] = 0.70980392156863,
                    ["r"] = 0.25882352941176
                },
                ["transparentHealth"] = true,
                ["frameGlow"] = {
                    ["targetGlow"] = {
                        ["enable"] = false
                    },
                    ["mouseoverGlow"] = {
                        ["color"] = {
                            ["a"] = 0.1200000047683716,
                            ["b"] = 0.4470588235294117,
                            ["g"] = 0.4470588235294117,
                            ["r"] = 0.4470588235294117
                        }
                    }
                },
                ["castNoInterrupt"] = {
                    ["b"] = 0.49411764705882,
                    ["g"] = 0.38823529411765,
                    ["r"] = 1
                },
                ["health"] = {
                    ["b"] = 0.13333333333333,
                    ["g"] = 0.13333333333333,
                    ["r"] = 0.13333333333333
                },
                ["powerclass"] = true
            },
            ["smartRaidFilter"] = false,
            ["statusbar"] = "WindTools Glow",
            ["cooldown"] = {
                ["fonts"] = {
                    ["enable"] = true,
                    ["fontSize"] = 16,
                    ["font"] = F.GetCompatibleFont("Accidental Presidency")
                }
            }
        },
        ["datatexts"] = {
            ["font"] = font2,
            ["fontOutline"] = "OUTLINE",
            ["panels"] = {
                ["MinimapPanel"] = {
                    ["enable"] = false
                },
                ["RightChatDataPanel"] = {
                    ["enable"] = false
                },
                ["LeftChatDataPanel"] = {
                    "Time", -- [1]
                    ["enable"] = false
                }
            }
        },
        ["actionbar"] = {
            ["bar3"] = {
                ["buttonHeight"] = 25,
                ["customHotkeyFont"] = true,
                ["countTextYOffset"] = 2,
                ["hotkeyTextYOffset"] = -2,
                ["buttonsPerRow"] = 3,
                ["countTextXOffset"] = -2,
                ["customCountFont"] = true,
                ["inheritGlobalFade"] = true,
                ["hotkeyFontOutline"] = "OUTLINE",
                ["hotkeyFont"] = F.GetCompatibleFont("Montserrat"),
                ["countFont"] = F.GetCompatibleFont("Montserrat"),
                ["buttonspacing"] = 3,
                ["hotkeyColor"] = {
                    ["a"] = 1,
                    ["r"] = 0.8,
                    ["g"] = 0.8,
                    ["b"] = 0.8
                },
                ["countFontOutline"] = "OUTLINE",
                ["useHotkeyColor"] = true,
                ["buttonsize"] = 31
            },
            ["desaturateOnCooldown"] = true,
            ["fontOutline"] = "OUTLINE",
            ["rightClickSelfCast"] = true,
            ["bar1"] = {
                ["buttonHeight"] = 25,
                ["customHotkeyFont"] = true,
                ["countTextYOffset"] = 2,
                ["hotkeyTextYOffset"] = -2,
                ["countTextXOffset"] = -2,
                ["customCountFont"] = true,
                ["inheritGlobalFade"] = true,
                ["hotkeyFont"] = F.GetCompatibleFont("Montserrat"),
                ["hotkeyFontOutline"] = "OUTLINE",
                ["countFont"] = F.GetCompatibleFont("Montserrat"),
                ["buttonspacing"] = 4,
                ["hotkeyColor"] = {
                    ["a"] = 1,
                    ["b"] = 0.8,
                    ["g"] = 0.8,
                    ["r"] = 0.8
                },
                ["countFontOutline"] = "OUTLINE",
                ["useHotkeyColor"] = true,
                ["buttonsize"] = 31
            },
            ["font"] = F.GetCompatibleFont("Montserrat"),
            ["hotkeyTextXOffset"] = -1,
            ["hotkeyTextYOffset"] = -2,
            ["barPet"] = {
                ["point"] = "TOPLEFT",
                ["buttonspacing"] = 4,
                ["inheritGlobalFade"] = true,
                ["keepSizeRatio"] = false,
                ["buttonHeight"] = 25,
                ["buttonsPerRow"] = 10,
                ["buttonsize"] = 33,
                ["backdrop"] = false
            },
            ["countTextXOffset"] = -2,
            ["extraActionButton"] = {
                ["scale"] = 0.8,
                ["inheritGlobalFade"] = true,
                ["clean"] = true
            },
            ["globalFadeAlpha"] = 0.7,
            ["microbar"] = {
                ["buttonSpacing"] = 4,
                ["buttons"] = 11
            },
            ["hideCooldownBling"] = true,
            ["bar2"] = {
                ["buttonHeight"] = 25,
                ["enabled"] = true,
                ["customHotkeyFont"] = true,
                ["countTextYOffset"] = 2,
                ["hotkeyTextYOffset"] = -2,
                ["countTextXOffset"] = -2,
                ["customCountFont"] = true,
                ["inheritGlobalFade"] = true,
                ["hotkeyFontOutline"] = "OUTLINE",
                ["hotkeyFont"] = F.GetCompatibleFont("Montserrat"),
                ["countFont"] = F.GetCompatibleFont("Montserrat"),
                ["buttonspacing"] = 4,
                ["hotkeyColor"] = {
                    ["a"] = 1,
                    ["r"] = 0.8,
                    ["g"] = 0.8,
                    ["b"] = 0.8
                },
                ["countFontOutline"] = "OUTLINE",
                ["useHotkeyColor"] = true,
                ["buttonsize"] = 31
            },
            ["bar5"] = {
                ["enabled"] = false
            },
            ["zoneActionButton"] = {
                ["scale"] = 0.8,
                ["inheritGlobalFade"] = true,
                ["clean"] = true
            },
            ["useDrawSwipeOnCharges"] = true,
            ["transparent"] = true,
            ["stanceBar"] = {
                ["buttonHeight"] = 12,
                ["inheritGlobalFade"] = true,
                ["backdropSpacing"] = 3,
                ["buttonspacing"] = 3,
                ["buttonsize"] = 24
            },
            ["cooldown"] = {
                ["checkSeconds"] = true,
                ["fonts"] = {
                    ["enable"] = true,
                    ["font"] = F.GetCompatibleFont("Accidental Presidency"),
                    ["fontSize"] = 25
                }
            },
            ["bar4"] = {
                ["hotkeyFontOutline"] = "OUTLINE",
                ["backdrop"] = false,
                ["countTextYOffset"] = 2,
                ["hotkeyTextYOffset"] = -2,
                ["buttonsPerRow"] = 3,
                ["countTextXOffset"] = -2,
                ["point"] = "BOTTOMLEFT",
                ["customCountFont"] = true,
                ["useHotkeyColor"] = true,
                ["hotkeyFont"] = F.GetCompatibleFont("Montserrat"),
                ["customHotkeyFont"] = true,
                ["countFont"] = F.GetCompatibleFont("Montserrat"),
                ["buttons"] = 6,
                ["hotkeyColor"] = {
                    ["a"] = 1,
                    ["b"] = 0.8,
                    ["g"] = 0.8,
                    ["r"] = 0.8
                },
                ["countFontOutline"] = "OUTLINE",
                ["buttonspacing"] = 3,
                ["inheritGlobalFade"] = true,
                ["buttonsize"] = 31
            }
        },
        ["v11NamePlateReset"] = true,
        ["cooldown"] = {
            ["fonts"] = {
                ["enable"] = true,
                ["font"] = F.GetCompatibleFont("Accidental Presidency"),
                ["fontSize"] = 27
            }
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
            ["smallTextFontSize"] = 13
        }
    }
end

function W:Fang2houUIProfile()
    BuildProfile()
    local EP = select(4, _G.ElvUI)
    E:CopyTable(E.db, EP)
    E:CopyTable(E.db, profile)

    if W.Locale == "zhTW" then
        E.db["general"]["font"] = "預設"
    elseif W.Locale == "zhCN" then
        E.db["general"]["font"] = "默认"
    elseif W.Locale == "koKR" then
        E.db["general"]["font"] = "기본 글꼴"
    end

    C_CVar_SetCVar("nameplateOtherTopInset", 0.1)
    C_CVar_SetCVar("nameplateLargeTopInset", 0.1)

    E:StaggeredUpdateAll()
end
