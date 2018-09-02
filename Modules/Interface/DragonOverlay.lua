-- 原作：ProjectAzilroka
-- 原作者：Azilroka(https://www.tukui.org/addons.php?id=79)
-- 导入：houshuu
-------------------
local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local DO = E:NewModule('Wind_DragonOverlay', 'AceEvent-3.0')

local _G = _G
local pairs, tinsert, select, unpack = pairs, tinsert, select, unpack
local strfind, strsub = strfind, strsub
local UnitIsPlayer, UnitClass, UnitClassification = UnitIsPlayer, UnitClass, UnitClassification

local MediaPath = 'Interface\\AddOns\\ElvUI_WindTools\\Texture\\DragonOverlay\\'

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

function DO:Initialize()
	self.db = E.db.WindTools["Dragon Overlay"]
	if not self.db["enabled"] then return end

	local frame = CreateFrame("Frame", 'DragonOverlayFrame', UIParent)
	frame.Texture = frame:CreateTexture(nil, 'ARTWORK')
	frame.Texture:SetAllPoints()
	DO.frame = frame
	DO:RegisterEvent('PLAYER_TARGET_CHANGED', 'SetOverlay')
end

local function InitializeCallback()
	DO:Initialize()
end
E:RegisterModule(DO:GetName(), InitializeCallback)