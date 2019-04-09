local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")

local _G = _G

P["WindTools"]["Interface"] = {
	["Auto Buttons"] = {
		["enabled"] = true,
		["questNum"] = 5,
		["itemList"] = {},
		["slotNum"] = 5,
		["AptifactItem"] = true,
		["slotList"] = {},
		["countFontSize"] = 18,
		["bindFontSize"] = 10,
		["whiteList"] = {
			[90006] = true, -- 影踪派任务道具
			[86534] = true,
			[86536] = true,
			[76097] = true, -- 神效治疗药水
			[76098] = true, -- 神效法力药水
			[5512] = true,  -- 治疗石
			[36799] = true, -- 法力宝石
			[81901] = true, -- 闪耀法力宝石
			[76089] = true, -- 兔妖之啮 
			[76090] = true, -- 群山药水 
			[76093] = true, -- 青龙药水 
			[76094] = true, -- 炼金师药水
			[76095] = true, -- 魔古之力药水 
			[86125] = true, -- 咔啡压榨机
			[86569] = true, -- 狂乱水晶
			[118922] = true, -- 奥拉留斯的低语水晶
			[127843] = true,
			[49040] = true, -- 基维斯
			[132514] = true, -- 自动铁锤
	
			--公会及荣誉军旗
			[63359] = true,
			[64398] = true,
			[64399] = true,
			[18606] = true,
			[64400] = true,
			[64401] = true,
			[64402] = true,
			[18607] = true,
	
			--wod 药水
			[116266] = true,
			[116276] = true,		
			[116268] = true,
			[116271] = true,
			[118711] = true,
			[118704] = true,
			[109217] = true,
			[109218] = true,
			[109219] = true,
			[109220] = true,
			[109221] = true,
			[109222] = true,
			[109223] = true,
			[118269] = true, -- 要塞绿苹果
			[122453] = true, -- 炼金专用药水
			[122451] = true,
			[122454] = true,
			[122452] = true,
			[122455] = true,
			[122456] = true,	
			[116411] = true, -- 保护卷轴
	
			--Legion
			[118330] = true, -- Pile of Weapons
			[122100] = true, -- Soul Gem
			[127030] = true, -- Granny's Flare Grenades
			[127295] = true, -- Blazing Torch
			[128651] = true, -- Critter Hand Cannon
			[128772] = true, -- Branch of the Runewood
			[129161] = true, -- Stormforged Horn
			[129725] = true, -- Smoldering Torch
			[131931] = true, -- Khadgar's Wand
			[133756] = true, -- Fresh Mound of Flesh
			[133882] = true, -- Trap Rune
			[133897] = true, -- Telemancy Beacon
			[133925] = true, -- Fel Lash
			[133999] = true, -- Inert Crystal
			[136605] = true, -- Solendra's Compassion
			[137299] = true, -- Nightborne Spellblad
			[138146] = true, -- Rediant Ley Crystal
			[140916] = true, -- Satchel of Locklimb Powder
			[109076] = true, -- 地精滑翔器工具包
			[147707] = true, -- 改装的邪能焦镜
			[142117] = true, -- 延时之力
			[153023] = true, -- 光铸调和符文
			
			--BFA
			[163224] = true, -- 力量战斗药水
			[163223] = true, -- 敏捷战斗药水
			[163222] = true, -- 智力战斗药水
		},
		["blankList"] = {},
		["blankitemID"] = "",
		["itemID"] = "",
		["questPerRow"] = 5,
		["questSize"] = 40,
		["slotPerRow"] = 5,
		["slotSize"] = 40,
	},
	["Dragon Overlay"] = {
		['enabled'] = false,
		['Strata'] = '3-MEDIUM',
		['Level'] = 12,
		['IconSize'] = 32,
		['Width'] = 128,
		['Height'] = 64,
		['worldboss'] = 'Chromatic',
		['elite'] = 'HeavenlyGolden',
		['rare'] = 'Onyx',
		['rareelite'] = 'HeavenlyOnyx',
		['ClassIcon'] = false,
		['ClassIconPoints'] = {
			['point'] = 'CENTER',
			['relativePoint'] = 'TOP',
			['xOffset'] = 0,
			['yOffset'] = 5,
		},
		['DragonPoints'] = {
			['point'] = 'CENTER',
			['relativePoint'] = 'TOP',
			['xOffset'] = 0,
			['yOffset'] = 5,
		},
		['FlipDragon'] = false,
	},
	["Skins"] = {
		enabled = true,
		elvui = {
			actionbars = true,
			auras = true,
			castbar = true,
			classbar = true,
			general = true,
			unitframe = true,
			quest_item = true,
			tooltips = true,
			databars = true,
		},
		addonskins = {
			bigwigs = true,
			general = true,
			weakaura = true,
		},
		ime = {
			no_backdrop = true,
			width = 200,
			label = {
				font = E.db.general.font,
				size = E.db.general.fontSize + 3,
				style = "OUTLINE",
			},
			candidate = {
				font = E.db.general.font,
				size = E.db.general.fontSize + 3,
				style = "OUTLINE",
			},
		},
	},
	["Enhanced World Map"] = {
		["enabled"] = false,
		["scale"] = 1.2,
		["reveal"] = true,
	},
	["iShadow"] = {
		["enabled"] = true,
		["level"] = 50,
	},
	["Minimap Buttons"] = {
		["enabled"] = false,
		['skinStyle'] = 'HORIZONTAL',
		['backdrop'] = false,
		['layoutDirection'] = 'NORMAL',
		['buttonSize'] = 28,
		['mouseover'] = false,
		['mbcalendar'] =  false,
		['mbgarrison'] = false,
		['buttonsPerRow'] = 5,
	},
	["Enhanced Tooltip"] = {
		["Offset"] = {
			["mouseOffsetX"] = 0,
			["mouseOffsetY"] = 0,
			["overrideCombat"] = false,
		},
		["Progression"] = {
			["enabled"] = true,
			["Dungeon"] = {
				["enabled"] = true,
				["MythicDungeon"] = false,
				["Mythic+"] = true,
			},
			["Raid"] = {
				["enabled"] = true,
				["Uldir"] = false,
				["BattleOfDazaralor"] = true,
				["CrucibleOfStorms"] = false,
			}
		},
	},
	["Skip Azerite Animations"] = {
		["enabled"] = true,
	}
}

WT.ToolConfigs["Interface"] = {
	["Auto Buttons"] = {
		tDesc   = L["Add two bars to contain questitem buttons and inventoryitem buttons."],
		oAuthor = "EUI",
		cAuthor = "SomeBlu",
		["featureconfig"] = {
			order = 5,
			get = function(info) return E.db.WindTools["Interface"]["Auto Buttons"][ info[#info] ] end,
			set = function(info, value) E.db.WindTools["Interface"]["Auto Buttons"][ info[#info] ] = value; E:GetModule('Wind_AutoButton'):UpdateAutoButton() end,
			name = L["Auto QuestItem Button"],
			args = {
				["bindFontSize"] = {
					order = 0,
					type = "range",
					min = 4, max = 40, step =1,
					name = L["Keybind Text"]..L["Font Size"],
				},
				["countFontSize"] = {
					order = 1,
					type = "range",
					min = 4, max = 40, step =1,
					name = L["Item Count"]..L["Font Size"],
				},
				["AptifactItem"] = {
					order = 2,
					name = ARTIFACT_POWER,
					set = function(info, value)
						E.db.WindTools["Interface"]["Auto Buttons"].AptifactItem = value;
						E:GetModule('Wind_AutoButton'):ScanItem("BAG_UPDATE_DELAYED");
					end,
				},
				["spacer0"] = {
					order = 3,
					type = "description",
					name = "",
					width = "full",
				},
				["questNum"] = {
					order = 4,
					type = "range",
					name = L["Quset Button Number"],
					min = 0, max = 12, step = 1,
				},
				["questPerRow"] = {
					order = 5,
					type = "range",
					name = L["Buttons Per Row"],
					min = 1, max = 12, step = 1,
				},
				["questSize"] = {
					order = 6,
					type = "range",
					name = L["Size"],
					min = 10, max = 100, step = 1,
				},
				["spacer1"] = {
					order = 7,
					type = "description",
					name = "",
					width = "full",
				},
				["slotNum"] = {
					order = 8,
					type = "range",
					name = L["Slot Button Number"],
					min = 0, max = 12, step = 1,
				},
				["slotPerRow"] = {
					order = 9,
					type = "range",
					name = L["Buttons Per Row"],
					min = 1, max = 12, step = 1,
				},
				["slotSize"] = {
					order = 10,
					type = "range",
					name = L["Size"],
					min = 10, max = 100, step = 1,
				},
				["spacer2"] = {
					order = 11,
					type = "description",
					name = "",
					width = "full",
				},				
				["itemID"] = {
					order = 12,
					type = "input",
					name = L["Whitelist"]..L["Item-ID"],
					get = function() return whiteItemID or "" end,
					set = function(info, value) whiteItemID = value end,
				},
				["AddItemID"] = {
					order = 13,
					type = "execute",
					name = L["Add ItemID"],
					func = function()
						if not tonumber(whiteItemID) then
							E:Print(L["Must is itemID!"]);
							return;
						end
						local id = tonumber(whiteItemID)
						if not GetItemInfo(id) then
							E:Print(whiteItemID.. "is error itemID");
							return;
						end
						E.db.WindTools["Interface"]["Auto Buttons"].whiteList[id] = true;
						WT.ToolConfigs["Interface"]["Auto Buttons"].featureconfig.args.whiteList.values[id] = GetItemInfo(id);
						E:GetModule('Wind_AutoButton'):UpdateAutoButton();
					end,
				},
				["DeleteItemID"] = {
					order = 14,
					type = "execute",
					name = L["Delete ItemID"],
					func = function()
						if not tonumber(whiteItemID) then
							E:Print(L["Must is itemID!"]);
							return;
						end
						local id = tonumber(whiteItemID)
						if not GetItemInfo(id) then
							E:Print(whiteItemID.. "is error itemID");
							return;
						end
						if E.db.WindTools["Interface"]["Auto Buttons"].whiteList[id] == true or E.db.WindTools["Interface"]["Auto Buttons"].whiteList[id] == false then
							E.db.WindTools["Interface"]["Auto Buttons"].whiteList[id] = nil;
							WT.ToolConfigs["Interface"]["Auto Buttons"].featureconfig.args.whiteList.values[id] = nil;
						end
						E:GetModule('Wind_AutoButton'):UpdateAutoButton();
					end,
				},					
				["whiteList"] = {
					order = 15,
					type = "multiselect",
					name = L["Whitelist"],
					get = function(info, k) return E.db.WindTools["Interface"]["Auto Buttons"].whiteList[k] end,
					set = function(info, k, v) E.db.WindTools["Interface"]["Auto Buttons"].whiteList[k] = v; E:GetModule('Wind_AutoButton'):UpdateAutoButton() end,
					values = {}
				},
				["spacer4"] = {
					order = 16,
					type = "description",
					name = "",
					width = "full",
				},
				["blackitemID"] = {
					order = 17,
					type = "input",
					name = L["Blacklist"]..L["Item-ID"],
					get = function() return blackItemID or "" end,
					set = function(info, value) blackItemID = value end,
				},
				["AddblankItemID"] = {
					order = 18,
					type = "execute",
					name = L["Add ItemID"],
					func = function() 
						if not tonumber(blackItemID) then
							E:Print(L["Must is itemID!"]);
							return;
						end
						local id = tonumber(blackItemID)							
						if not GetItemInfo(id) then
							E:Print(blackItemID.. "is error itemID");
							return;
						end
						E.db.WindTools["Interface"]["Auto Buttons"].blankList[id] = true;
						WT.ToolConfigs["Interface"]["Auto Buttons"].featureconfig.args.blankList.values[id] = GetItemInfo(id);
						E:GetModule('Wind_AutoButton'):UpdateAutoButton();
					end,
				},
				["DeleteblankItemID"] = {
					order = 19,
					type = "execute",
					name = L["Delete ItemID"],
					func = function()
						if not tonumber(blackItemID) then
							E:Print(L["Must is itemID!"]);
							return;
						end
						local id = tonumber(blackItemID)
						if not GetItemInfo(id) then
							E:Print(blackItemID.. "is error itemID");
							return;
						end
						if E.db.WindTools["Interface"]["Auto Buttons"].blankList[id] == true or E.db.WindTools["Interface"]["Auto Buttons"].blankList[id] == false then
							E.db.WindTools["Interface"]["Auto Buttons"].blankList[id] = nil;
							WT.ToolConfigs["Interface"]["Auto Buttons"].featureconfig.args.blankList.values[id] = nil;
						end
						E:GetModule('Wind_AutoButton'):UpdateAutoButton();
					end,
				},
				["blankList"] = {
					order = 20,
					type = "multiselect",
					name = L["Blacklist"],
					get = function(info, k) return E.db.WindTools["Interface"]["Auto Buttons"].blankList[k] end,
					set = function(info, k, v) E.db.WindTools["Interface"]["Auto Buttons"].blankList[k] = v; E:GetModule('Wind_AutoButton'):UpdateAutoButton() end,
					values = {}
				},
			},
		},
		func = function()
			-- for k, v in pairs(E.db.WindTools["Interface"]["Auto Buttons"].itemList) do
			-- 	WT.ToolConfigs["Interface"].featureconfig.args.itemList.values[k] = k
			-- end
			-- for k, v in pairs(E.db.WindTools["Interface"]["Auto Buttons"].slotList) do
			-- 	WT.ToolConfigs["Interface"].featureconfig.args.slotList.values[k] = k
			-- end
			for k, v in pairs(E.db.WindTools["Interface"]["Auto Buttons"].whiteList) do
				if type(k) == "string" then k = tonumber(k) end
				if GetItemInfo(k) then
					WT.ToolConfigs["Interface"]["Auto Buttons"].featureconfig.args.whiteList.values[k] = GetItemInfo(k);
				end
			end
			for k, v in pairs(E.db.WindTools["Interface"]["Auto Buttons"].blankList) do
				if type(k) == "string" then k = tonumber(k) end
				if GetItemInfo(k) then
					WT.ToolConfigs["Interface"]["Auto Buttons"].featureconfig.args.blankList.values[k] = GetItemInfo(k);
				end
			end
		end,
	},
	["Dragon Overlay"] = {
		tDesc   = L["Provides an overlay on UnitFrames for Boss, Elite, Rare and RareElite"],
		oAuthor = "Azilroka",
		cAuthor = "houshuu",
		["general"] = {
			order = 5,
			name = L['General'],
			get = function(info) return E.db.WindTools["Interface"]["Dragon Overlay"][info[#info]] end,
			set = function(info, value) E.db.WindTools["Interface"]["Dragon Overlay"][info[#info]] = value; E:GetModule('Wind_DragonOverlay'):SetOverlay() end,
			args = {
				["ClassIcon"] = {
					order = 0,
					name = L['Class Icon'],
				},
				["FlipDragon"] = {
					order = 1,
					name = L['Flip Dragon'],
				},
				["Strata"] = {
					order = 2,
					type = 'select',
					name = L['Frame Strata'],
					values = {
						['1-BACKGROUND'] = 'BACKGROUND',
						['2-LOW'] = 'LOW',
						['3-MEDIUM'] = 'MEDIUM',
						['4-HIGH'] = 'HIGH',
						['5-DIALOG'] = 'DIALOG',
						['6-FULLSCREEN'] = 'FULLSCREEN',
						['7-FULLSCREEN_DIALOG'] = 'FULLSCREEN_DIALOG',
						['8-TOOLTIP'] = 'TOOLTIP',
					},
				},
				["Level"] = {
					order = 3,
					type = 'range',
					name = L['Frame Level'],
					min = 0, max = 255, step = 1,
				},
				["IconSize"] = {
					order = 4,
					type = 'range',
					name = L['Icon Size'],
					min = 1, max = 255, step = 1,
				},
				["Width"] = {
					order = 5,
					type = 'range',
					name = L['Width'],
					min = 1, max = 255, step = 1,
				},
				["Height"] = {
					order = 6,
					type = 'range',
					name = L['Height'],
					min = 1, max = 255, step = 1,
				},
			},
		},
		func = function()
			local Options = WT.ToolConfigs["Interface"]["Dragon Overlay"]
			local Order = 6
			for Option, Name in pairs({ ['ClassIconPoints'] = L['Class Icon Points'], ['DragonPoints'] = L['Dragon Points'] }) do
				Options[Option] = {
					order = Order,
					name = Name,
					get = function(info) return E.db.WindTools["Interface"]["Dragon Overlay"][Option][info[#info]] end,
					set = function(info, value) E.db.WindTools["Interface"]["Dragon Overlay"][Option][info[#info]] = value;E:GetModule('Wind_DragonOverlay'):SetOverlay() end,
					args = {
						["point"] = {
							name = L['Anchor Point'],
							order = 1,
							type = 'select',
							values = {},
						},
						["relativePoint"] = {
							name = L['Relative Point'],
							order = 2,
							type = 'select',
							values = {},
						},
						["xOffset"] = {
							order = 3,
							type = 'range',
							name = L['X Offset'],
							min = -350, max = 350, step = 1,
						},
						["yOffset"] = {
							order = 4,
							type = 'range',
							name = L['Y Offset'],
							min = -350, max = 350, step = 1,
						},
					},
				}
		
				for _, Point in pairs({ 'point', 'relativePoint' }) do
					Options[Option].args[Point].values = {
						['CENTER'] = 'CENTER',
						['BOTTOM'] = 'BOTTOM',
						['TOP'] = 'TOP',
						['LEFT'] = 'LEFT',
						['RIGHT'] = 'RIGHT',
						['BOTTOMLEFT'] = 'BOTTOMLEFT',
						['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
						['TOPLEFT'] = 'TOPLEFT',
						['TOPRIGHT'] = 'TOPRIGHT',
					}
				end
		
				Order = Order + 1
			end
		
			local MenuItems = {
				['elite'] = L['Elite'],
				['rare'] = L['Rare'],
				['rareelite'] = L['RareElite'],
				['worldboss'] = L['World Boss'],
			}
		
			Options.DragonTexture = {
				order = Order,
				name = L["Dragon Texture"],
				args = {}
			}
			Order = 1
		
			for Option, Name in pairs(MenuItems) do
				Options.DragonTexture.args[Option] = {
					order = Order,
					name = Name,
					type = "select",
					get = function(info) return E.db.WindTools["Interface"]["Dragon Overlay"][Option] end,
					set = function(info, value) E.db.WindTools["Interface"]["Dragon Overlay"][Option] = value;E:GetModule('Wind_DragonOverlay'):SetOverlay() end,
					values = {
						['Chromatic'] = L["Chromatic"],
						['Azure'] = L["Azure"],
						['Crimson'] = L["Crimson"],
						['Golden'] = L["Golden"],
						['Jade'] = L["Jade"],
						['Onyx'] = L["Onyx"],
						['HeavenlyBlue'] = L["Heavenly Blue"],
						['HeavenlyCrimson'] = L["Heavenly Crimson"],
						['HeavenlyGolden'] = L["Heavenly Golden"],
						['HeavenlyJade'] = L["Heavenly Jade"],
						['HeavenlyOnyx'] = L["Heavenly Onyx"],
						['ClassicElite'] = L["Classic Elite"],
						['ClassicRareElite'] = L["Classic Rare Elite"],
						['ClassicRare'] = L["Classic Rare"],
						['ClassicBoss'] = L["Classic Boss"],
					},
				}
				Options.DragonTexture.args[Option..'Desc'] = {
					order = Order + 1,
					type = 'description',
					name = '',
					image = function() return E:GetModule('Wind_DragonOverlay').Textures[E.db.WindTools["Interface"]["Dragon Overlay"][Option]], 128, 32 end,
					imageCoords = function() return {E.db.WindTools["Interface"]["Dragon Overlay"][Option]['FlipDragon'] and 1 or 0, E.db.WindTools["Interface"]["Dragon Overlay"][Option]['FlipDragon'] and 0 or 1, 0, 1} end,
				}
				Order = Order + 2
			end
		end,
	},
	["Skins"] = {
		tDesc   = L["Provide a new style for ElvUI."],
		oAuthor = "houshuu",
		cAuthor = "houshuu",
		["elvui"] = {
			order = 5,
			name = "ElvUI"..L["Frame Setting"],
			get = function(info) return E.db.WindTools.Interface.Skins.elvui[info[#info]] end,
			set = function(info, value) E.db.WindTools.Interface.Skins.elvui[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {}
		},
		["addonskins"] = {
			order = 6,
			name = "AddOnSkins",
			hidden = function() return not IsAddOnLoaded("AddOnSkins") end,
			get = function(info) return E.db.WindTools.Interface.Skins.addonskins[info[#info]] end,
			set = function(info, value) E.db.WindTools.Interface.Skins.addonskins[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {}
		},
		["ime"] = {
			order = 7,
			name = L["IME"],
			get = function(info) return E.db.WindTools.Interface.Skins.ime[info[#info]] end,
			set = function(info, value) E.db.WindTools.Interface.Skins.ime[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {
				no_backdrop = {
					order = 1,
					name = L["No backdrop"],
				},
				width = {
					order = 2,
					type = "range",
					name = L["Width"],
					desc = L["You can set width to display long text."],
					min = 100, max = 600, step = 1,
				},
				label = {
					order = 3,
					name = L["Label"],
					get = function(info) return E.db.WindTools.Interface.Skins.ime.label[info[#info]] end,
					set = function(info, value) E.db.WindTools.Interface.Skins.ime.label[info[#info]] = value end,
					args = {
						font = {
							type = 'select', dialogControl = 'LSM30_Font',
							order = 1,
							name = L['Font'],
							values = LSM:HashTable('font'),
						},
						size = {
							order = 2,
							name = L['Size'],
							type = 'range',
							min = 6, max = 22, step = 1,
						},
						style = {
							order = 3,
							name = L["Style"],
							type = 'select',
							values = {
								['NONE'] = L['None'],
								['OUTLINE'] = L['OUTLINE'],
								['MONOCHROME'] = L['MONOCHROME'],
								['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
								['THICKOUTLINE'] = L['THICKOUTLINE'],
							},
						},
					},
				},
				candidate = {
					order = 4,
					name = L["Candidate"],
					get = function(info) return E.db.WindTools.Interface.Skins.ime.candidate[info[#info]] end,
					set = function(info, value) E.db.WindTools.Interface.Skins.ime.candidate[info[#info]] = value end,
					args = {
						font = {
							type = 'select', dialogControl = 'LSM30_Font',
							order = 1,
							name = L['Font'],
							values = LSM:HashTable('font'),
						},
						size = {
							order = 2,
							name = L['Size'],
							type = 'range',
							min = 6, max = 22, step = 1,
						},
						style = {
							order = 3,
							name = L["Style"],
							type = 'select',
							values = {
								['NONE'] = L['None'],
								['OUTLINE'] = L['OUTLINE'],
								['MONOCHROME'] = L['MONOCHROME'],
								['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
								['THICKOUTLINE'] = L['THICKOUTLINE'],
							},
						},
					},
				},
			}
		},
		func = function()
			local WS = E:GetModule('Wind_Skins')
			local Options = WT.ToolConfigs.Interface.Skins
			local optOrder = 1
			for k, v in pairs(WS.elvui_frame_list) do
				Options.elvui.args[k]={
					order = optOrder,
					name = v,
				}
				optOrder = optOrder + 1
			end

			optOrder = 1
			for k, v in pairs(WS.addonskins_list) do
				Options.addonskins.args[k]={
					order = optOrder,
					name = v,
				}
				optOrder = optOrder + 1
			end
		end,
	},
	["Enhanced World Map"] = {
		tDesc   = L["Customize your world map."],
		oAuthor = "houshuu",
		cAuthor = "houshuu",
		["scale"] = {
			order = 5,
			type = "range",
			name = L["World Map Frame Size"],
			min = 0.5, max = 2, step = 0.1,
			disabled = function() return not E.db.WindTools["Interface"]["Enhanced World Map"]["enabled"] end,
			get = function(info) return E.db.WindTools["Interface"]["Enhanced World Map"]["scale"] end,
			set = function(info, value) E.db.WindTools["Interface"]["Enhanced World Map"]["scale"] = value; E:GetModule("Wind_EnhancedWorldMap"):SetMapScale() end
		},
		["usereveal"] = {
			order = 6,
			name = L["Reveal"],
			disabled = function() return not E.db.WindTools["Interface"]["Enhanced World Map"]["enabled"] end,
			get = function(info) return E.db.WindTools["Interface"]["Enhanced World Map"]["reveal"] end,
			set = function(info, value) E.db.WindTools["Interface"]["Enhanced World Map"]["reveal"] = value; E:StaticPopup_Show("PRIVATE_RL")  end,
		},
	},
	["iShadow"] = {
		tDesc   = L["Movie effect for WoW."],
		oAuthor = "iShadow",
		cAuthor = "houshuu",
		["setlevel"] = {
			order = 5,
			type = "range",
			name = L["Shadow Level"],
			min = 1, max = 100, step = 1,
			get = function(info) return E.db.WindTools["Interface"]["iShadow"]["level"] end,
			set = function(info, value) E.db.WindTools["Interface"]["iShadow"]["level"] = value; E:GetModule("Wind_iShadow"):SetShadowLevel(value) end
		},
		["setleveldesc"] = {
			order = 6,
			type = "description",
			name = L["Default is 50."],
		},
	},
	["Minimap Buttons"] = {
		tDesc   = L["Add a bar to contain minimap buttons."],
		oAuthor = "ElvUI Enhanced",
		cAuthor = "houshuu",
		["featureconfig"] = {
			order = 5,
			get = function(info) return E.db.WindTools["Interface"]["Minimap Buttons"][ info[#info] ] end,
			set = function(info, value) E.db.WindTools["Interface"]["Minimap Buttons"][ info[#info] ] = value; E:GetModule("Wind_MinimapButtons"):UpdateLayout() end,
			name = L["Minimap Button Bar"],
			args = {
				["skinStyle"] = {
					order = 1,
					type = 'select',
					name = L['Skin Style'],
					desc = L['Change settings for how the minimap buttons are skinned.'],
					set = function(info, value) E.db.WindTools["Interface"]["Minimap Buttons"][ info[#info] ] = value; E:GetModule("Wind_MinimapButtons"):UpdateSkinStyle() end,
					values = {
						['NOANCHOR'] = L['No Anchor Bar'],
						['HORIZONTAL'] = L['Horizontal Anchor Bar'],
						['VERTICAL'] = L['Vertical Anchor Bar'],
					},
				},
				["layoutDirection"] = {
					order = 2,
					type = 'select',
					name = L['Layout Direction'],
					desc = L['Normal is right to left or top to bottom, or select reversed to switch directions.'],
					values = {
						['NORMAL'] = L['Normal'],
						['REVERSED'] = L['Reversed'],
					},
				},
				["buttonSize"] = {
					order = 3,
					type = 'range',
					name = L['Button Size'],
					desc = L['The size of the minimap buttons.'],
					min = 16, max = 40, step = 1,
					disabled = function() return E.db.WindTools["Interface"]["Minimap Buttons"]["skinStyle"] == 'NOANCHOR' end,
				},
				["buttonsPerRow"] = {
					order = 4,
					type = 'range',
					name = L['Buttons per row'],
					desc = L['The max number of buttons when a new row starts.'],
					min = 2, max = 20, step = 1,
					--disabled = function() return not E.db.WindTools["Interface"]["Minimap Buttons"]["skinButtons"] or E.db.WindTools["Interface"]["Minimap Buttons"]["skinStyle"] == 'NOANCHOR' end,
				},
				["backdrop"] = {
					order = 5,
					name = L["Backdrop"],
					disabled = function() return E.db.WindTools["Interface"]["Minimap Buttons"]["skinStyle"] == 'NOANCHOR' end,
				},			
				["mouseover"] = {
					order = 6,
					name = L['Mouse Over'],
					desc = L['The frame is not shown unless you mouse over the frame.'],
					disabled = function() return E.db.WindTools["Interface"]["Minimap Buttons"]["skinStyle"] == 'NOANCHOR' end,
					set = function(info, value) E.db.WindTools["Interface"]["Minimap Buttons"]["mouseover"] = value; E:GetModule("Wind_MinimapButtons"):ChangeMouseOverSetting() end,
				},
				["mmbuttons"] = {
					order = 7,
					name = L["Minimap Buttons"],
					args = {
						["mbgarrison"] = {
							order = 1,
							name = GARRISON_LOCATION_TOOLTIP,
							disabled = function() return E.db.WindTools["Interface"]["Minimap Buttons"]["skinStyle"] == 'NOANCHOR' end,
							set = function(info, value) E.db.WindTools["Interface"]["Minimap Buttons"]["mbgarrison"] = value; E:StaticPopup_Show("PRIVATE_RL") end,
						},
						["mbcalendar"] = {
							order = 2,
							name = L['Calendar'],
							disabled = function() return E.db.WindTools["Interface"]["Minimap Buttons"]["skinStyle"] == 'NOANCHOR' end,
							set = function(info, value) E.db.WindTools["Interface"]["Minimap Buttons"]["mbcalendar"] = value; E:StaticPopup_Show("PRIVATE_RL") end,
						}
					}
				}
			}
		},
	},
	["Enhanced Tooltip"] = {
		tDesc   = L["Useful tooltip tweaks."],
		oAuthor = "Nick Bockmeulen, houshuu",
		cAuthor = "SomeBlu",
		["progression"] = {
			order = 5,
			name = L["Progression"],
			desc  = L["Add progression info to tooltip."],
			get = function(info) return E.db.WindTools["Interface"]["Enhanced Tooltip"]["Progression"][info[#info]] end,
			set = function(info, value) E.db.WindTools["Interface"]["Enhanced Tooltip"]["Progression"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {
				["enabled"] = {
					order = 1,
					name = L["Enable"],
				},
				["Dungeon"] = {
					order = 2,
					name = L["Dungeon"],
					get = function(info) return E.db.WindTools["Interface"]["Enhanced Tooltip"]["Progression"]["Dungeon"][info[#info]] end,
					set = function(info, value) E.db.WindTools["Interface"]["Enhanced Tooltip"]["Progression"]["Dungeon"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					disabled = function() return not E.db.WindTools["Interface"]["Enhanced Tooltip"]["enabled"] or not E.db.WindTools["Interface"]["Enhanced Tooltip"]["Progression"]["enabled"] or not E.db.WindTools["Interface"]["Enhanced Tooltip"]["Progression"]["Dungeon"]["enabled"] end,
					args = {
						["enabled"] = {
							order = 1,
							name = L["Enable"],
							disabled = function() return not E.db.WindTools["Interface"]["Enhanced Tooltip"]["enabled"] or not E.db.WindTools["Interface"]["Enhanced Tooltip"]["Progression"]["enabled"] end,
						},
						["MythicDungeon"] = {
							order = 2,
							name = L["MythicDungeon"],
						},
						["Mythic+"] = {
							order = 3,
							name = L["Mythic+"],
						},
					}
				},
				["Raid"] = {
					order = 3,
					name = L["Raid"],
					get = function(info) return E.db.WindTools["Interface"]["Enhanced Tooltip"]["Progression"]["Raid"][info[#info]] end,
					set = function(info, value) E.db.WindTools["Interface"]["Enhanced Tooltip"]["Progression"]["Raid"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					disabled = function() return not E.db.WindTools["Interface"]["Enhanced Tooltip"]["enabled"] or not E.db.WindTools["Interface"]["Enhanced Tooltip"]["Progression"]["enabled"] or not E.db.WindTools["Interface"]["Enhanced Tooltip"]["Progression"]["Raid"]["enabled"] end,
					args = {
						["enabled"] = {
							order = 1,
							name = L["Enable"],
							disabled = function() return not E.db.WindTools["Interface"]["Enhanced Tooltip"]["enabled"] or not E.db.WindTools["Interface"]["Enhanced Tooltip"]["Progression"]["enabled"] end,
						},
						["Uldir"] = {
							order = 2,
							name = L["Uldir"],
						},
						["BattleOfDazaralor"] = {
							order = 3,
							name = L["BattleOfDazaralor"],
						},
						["CrucibleOfStorms"] = {
							order = 4,
							name = L["CrucibleOfStorms"],
						},
					}
				}
			}
		},
	},
	["Skip Azerite Animations"] = {
		tDesc   = L["Skips the reveal animation of a new azerite armor piece and the animation after you select a trait."],
		oAuthor = "Permok",
		cAuthor = "SomeBlu",
	}
}