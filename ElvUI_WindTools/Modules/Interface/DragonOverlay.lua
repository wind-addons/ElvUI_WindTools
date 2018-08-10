-- 原作：ProjectAzilroka
-- 原作者：Azilroka(https://www.tukui.org/addons.php?id=79)
-- 导入：houshuu
-------------------
local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local DO = E:NewModule('DragonOverlay', 'AceEvent-3.0')

local _G = _G
local pairs, tinsert, select, unpack = pairs, tinsert, select, unpack
local strfind, strsub = strfind, strsub
local UnitIsPlayer, UnitClass, UnitClassification = UnitIsPlayer, UnitClass, UnitClassification

local MediaPath = 'Interface\\AddOns\\ElvUI_WindTools\\Texture\\DragonOverlay\\'

P["WindTools"]["Dragon Overlay"] = {
	['enabled'] = false,
	['Strata'] = 'MEDIUM',
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
}

DO.Textures = {
	['Azure'] = MediaPath..'Azure',
	['Chromatic'] = MediaPath..'Chromatic',
	['Crimson'] = MediaPath..'Crimson',
	['Golden'] = MediaPath..'Golden',
	['Jade'] = MediaPath..'Jade',
	['Onyx'] = MediaPath..'Onyx',
	['HeavenlyBlue'] = MediaPath..'HeavenlyBlue',
	['HeavenlyCrimson'] = MediaPath..'HeavenlyCrimson',
	['HeavenlyGolden'] = MediaPath..'HeavenlyGolden',
	['HeavenlyJade'] = MediaPath..'HeavenlyJade',
	['HeavenlyOnyx'] = MediaPath..'HeavenlyOnyx',
	['ClassicElite'] = MediaPath..'ClassicElite',
	['ClassicRareElite'] = MediaPath..'ClassicRareElite',
	['ClassicRare'] = MediaPath..'ClassicRare',
	['ClassicBoss'] = MediaPath..'ClassicBoss',
}

function DO:SetOverlay()
	local Points = 'DragonPoints'
	local TargetClass = UnitClassification('target')
	local Texture = DO.Textures[self.db[TargetClass]]

	if UnitIsPlayer('target') and self.db['ClassIcon'] then
		TargetClass = select(2, UnitClass('target'))
		self.frame:SetSize(self.db.IconSize, DO.db.IconSize)
		self.frame.Texture:SetTexture([[Interface\WorldStateFrame\Icons-Classes]])
		self.frame.Texture:SetTexCoord(unpack(CLASS_ICON_TCOORDS[TargetClass]))
		Points = 'ClassIconPoints'
	else
		self.frame:SetSize(DO.db.Width, DO.db.Height)
		self.frame.Texture:SetTexture(Texture)
		self.frame.Texture:SetTexCoord(self.db['FlipDragon'] and 1 or 0, self.db['FlipDragon'] and 0 or 1, 0, 1)
	end

	self.frame:ClearAllPoints()
	self.frame:SetPoint(self.db[Points]['point'], _G["ElvUF_Target"].Health, self.db[Points]['relativePoint'], self.db[Points]['xOffset'], self.db[Points]['yOffset'])
	self.frame:SetParent("ElvUF_Target")
	self.frame:SetFrameStrata(strsub(self.db['Strata'], 3))
	self.frame:SetFrameLevel(self.db['Level'])
end

local function InsertOptions()
	local Options = {
		general = {
			order = 12,
			type = 'group',
			name = L['General'],
			guiInline = true,
			get = function(info) return E.db.WindTools["Dragon Overlay"][info[#info]] end,
			set = function(info, value) E.db.WindTools["Dragon Overlay"][info[#info]] = value; DO:SetOverlay() end,
			args = {
				ClassIcon = {
					order = 0,
					type = 'toggle',
					name = L['Class Icon'],
				},
				FlipDragon = {
					order = 1,
					type = 'toggle',
					name = L['Flip Dragon'],
				},
				Strata = {
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
				Level = {
					order = 3,
					type = 'range',
					name = L['Frame Level'],
					min = 0, max = 255, step = 1,
				},
				IconSize = {
					order = 4,
					type = 'range',
					name = L['Icon Size'],
					min = 1, max = 255, step = 1,
				},
				Width = {
					order = 5,
					type = 'range',
					name = L['Width'],
					min = 1, max = 255, step = 1,
				},
				Height = {
					order = 6,
					type = 'range',
					name = L['Height'],
					min = 1, max = 255, step = 1,
				},
			},
		}
	}

	local Order = 13
	for Option, Name in pairs({ ['ClassIconPoints'] = L['Class Icon Points'], ['DragonPoints'] = L['Dragon Points'] }) do
		Options[Option] = {
			order = Order,
			type = 'group',
			name = Name,
			guiInline = true,
			get = function(info) return E.db.WindTools["Dragon Overlay"][Option][info[#info]] end,
			set = function(info, value) E.db.WindTools["Dragon Overlay"][Option][info[#info]] = value;DO:SetOverlay() end,
			args = {
				point = {
					name = L['Anchor Point'],
					order = 1,
					type = 'select',
					values = {},
				},
				relativePoint = {
					name = L['Relative Point'],
					order = 2,
					type = 'select',
					values = {},
				},
				xOffset = {
					order = 3,
					type = 'range',
					name = L['X Offset'],
					min = -350, max = 350, step = 1,
				},
				yOffset = {
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
		type = 'group',
		name = L["Dragon Texture"],
		guiInline = true,
		args = {}
	}
	Order = 1

	for Option, Name in pairs(MenuItems) do
		Options.DragonTexture.args[Option] = {
			order = Order,
			name = Name,
			type = "select",
			get = function(info) return E.db.WindTools["Dragon Overlay"][Option] end,
			set = function(info, value) E.db.WindTools["Dragon Overlay"][Option] = value;DO:SetOverlay() end,
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
			image = function() return DO.Textures[E.db.WindTools["Dragon Overlay"][Option]], 128, 32 end,
			imageCoords = function() return {E.db.WindTools["Dragon Overlay"][Option]['FlipDragon'] and 1 or 0, E.db.WindTools["Dragon Overlay"][Option]['FlipDragon'] and 0 or 1, 0, 1} end,
		}
		Order = Order + 2
	end

	for k, v in pairs(Options) do
		E.Options.args.WindTools.args["Interface"].args["Dragon Overlay"].args[k] = v
	end
end

function DO:Initialize()
	self.db = E.db.WindTools["Dragon Overlay"]
	if not self.db["enabled"] then return end

	local frame = CreateFrame("Frame", 'DragonOverlayFrame', UIParent)
	frame.Texture = frame:CreateTexture(nil, 'ARTWORK')
	frame.Texture:SetAllPoints()
	DO.frame = frame
	DO:RegisterEvent('PLAYER_TARGET_CHANGED', 'SetOverlay')
end

WT.ToolConfigs["Dragon Overlay"] = InsertOptions
E:RegisterModule(DO:GetName())