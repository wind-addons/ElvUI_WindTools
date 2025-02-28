local W, F, E, L = unpack((select(2, ...)))
local ET = E:GetModule("Tooltip")
local T = W.Modules.Tooltips

local _G = _G

local pairs = pairs
local select = select
local strmatch = strmatch
local tinsert = tinsert
local tonumber = tonumber

local UnitGUID = UnitGUID

local cache = {}
local locked = {}

-- https://www.wowhead.com/guide/raids/liberation-of-undermine/tier-set-overview
-- JavaScript to get tier set ids (used in the specific class tier set page)
-- var a = ""; document.querySelector(".icon-list > tbody").children.forEach((child) => {const name = child.querySelector("td > a").innerText; const id = child.querySelector("td > a").href.match(/item=([0-9]*)/)[1]; a += `[${id}] = true, -- ${name}\n` }); console.log(a);
local tierSetsID = {
	-- HUNTER
	[229274] = true, -- Tireless Collector's Battlegear
	[229272] = true, -- Tireless Collector's Gauntlets
	[229271] = true, -- Tireless Collector's Chained Cowl
	[229270] = true, -- Tireless Collector's Armored Breeches
	[229269] = true, -- Tireless Collector's Hunted Heads
	-- WARRIOR
	[229238] = true, -- Enforcer's Backalley Vestplate
	[229236] = true, -- Enforcer's Backalley Crushers
	[229235] = true, -- Enforcer's Backalley Faceshield
	[229234] = true, -- Enforcer's Backalley Chausses
	[229233] = true, -- Enforcer's Backalley Shoulderplates
	-- PALADIN
	[229247] = true, -- Aureate Sentry's Encasement
	[229245] = true, -- Aureate Sentry's Gauntlets
	[229244] = true, -- Aureate Sentry's Pledge
	[229243] = true, -- Aureate Sentry's Legguards
	[229242] = true, -- Aureate Sentry's Roaring Will
	-- ROGUE
	[229292] = true, -- Spectral Gambler's Vest
	[229290] = true, -- Spectral Gambler's Gloves
	[229289] = true, -- Spectral Gambler's Damned Visage
	[229288] = true, -- Spectral Gambler's Pantaloons
	[229287] = true, -- Spectral Gambler's Bladed Mantle
	-- PRIEST
	[229337] = true, -- Confessor's Unshakable Vestment
	[229335] = true, -- Confessor's Unshakable Mitts
	[229334] = true, -- Confessor's Unshakable Halo
	[229333] = true, -- Confessor's Unshakable Leggings
	[229332] = true, -- Confessor's Unshakable Radiance
	-- DK
	[229256] = true, -- Cauldron Champion's Ribcage
	[229254] = true, -- Cauldron Champion's Fistguards
	[229253] = true, -- Cauldron Champion's Crown
	[229252] = true, -- Cauldron Champion's Tattered Cuisses
	[229251] = true, -- Cauldron Champion's Screamplate
	-- SHAMAN
	[229265] = true, -- Gale Sovereign's Clouded Hauberk
	[229263] = true, -- Gale Sovereign's Grasps
	[229262] = true, -- Gale Sovereign's Charged Hood
	[229261] = true, -- Gale Sovereign's Pantaloons
	[229260] = true, -- Gale Sovereign's Zephyrs
	-- MAGE
	[229346] = true, -- Aspectral Emissary's Primal Robes
	[229344] = true, -- Aspectral Emissary's Hardened Grasp
	[229343] = true, -- Aspectral Emissary's Crystalline Cowl
	[229342] = true, -- Aspectral Emissary's Trousers
	[229341] = true, -- Aspectral Emissary's Arcane Vents
	-- WARLOCK
	[229326] = true, -- Spliced Fiendtrader's Demonic Grasp
	[229325] = true, -- Spliced Fiendtrader's Transcendence
	[229324] = true, -- Spliced Fiendtrader's Skin Tights
	[229328] = true, -- Spliced Fiendtrader's Surgical Gown
	[229323] = true, -- Spliced Fiendtrader's Loyal Servants
	-- MONK
	[229301] = true, -- Ageless Serpent's Inked Coils
	[229299] = true, -- Ageless Serpent's Handguards
	[229298] = true, -- Ageless Serpent's Mane
	[229297] = true, -- Ageless Serpent's Leggings
	[229296] = true, -- Ageless Serpent's Shoulderpads
	-- DRUID
	[229310] = true, -- Robes of Reclaiming Blight
	[229308] = true, -- Grips of Reclaiming Blight
	[229307] = true, -- Branches of Reclaiming Blight
	[229306] = true, -- Moccasins of Reclaiming Blight
	[229305] = true, -- Jaws of Reclaiming Blight
	-- DH
	[229319] = true, -- Fel-Dealer's Soul Engine
	[229317] = true, -- Fel-Dealer's Underhandlers
	[229316] = true, -- Fel-Dealer's Visor
	[229315] = true, -- Fel-Dealer's Fur Kilt
	[229314] = true, -- Fel-Dealer's Recycled Reavers
	-- EVOKER
	[229283] = true, -- Opulent Treasurescale's Tunic
	[229281] = true, -- Opulent Treasurescale's Gold-Counters
	[229280] = true, -- Opulent Treasurescale's Crowned Jewel
	[229279] = true, -- Opulent Treasurescale's Petticoat
	[229278] = true, -- Opulent Treasurescale's Gleaming Mantle
}

local formatSets = {
	[1] = " |cff14b200(1/4)", -- green
	[2] = " |cff0091f2(2/4)", -- blue
	[3] = " |cff0091f2(3/4)", -- blue
	[4] = " |cffc745f9(4/4)", -- purple
	[5] = " |cffc745f9(5/5)", -- purple
}

local function ResetCache(_, _, guid)
	cache[guid] = {}
	locked[guid] = nil
end

function T:ElvUITooltipPopulateInspectGUIDCache(_, unitGUID, itemLevel)
	-- After ElvUI calculated the average item level, the process of scanning should be done.
	locked[unitGUID] = true
end

function T:ElvUIScanTooltipSetInventoryItem(tt, unit, slot)
	local guid = UnitGUID(unit)
	if guid and cache[guid] and not locked[guid] then
		local itemLink = select(2, tt:GetItem())
		local itemID = itemLink and strmatch(itemLink, "item:(%d+):")
		if itemID then
			itemID = tonumber(itemID)
			if tierSetsID[itemID] then
				for _, i in pairs(cache[guid]) do
					if i == itemID then
						return
					end
				end
				tinsert(cache[guid], itemID)
			end
		end
	end
end

function T:TierSet(tt, unit, guid)
	-- ElvUI do not scan player itself
	if guid == E.myguid then
		ResetCache(nil, nil, guid)
		for i = 1, 17 do
			if i ~= 4 then
				E:GetGearSlotInfo("player", i)
			end
		end
		locked[guid] = true
	end

	if not cache[guid] or #cache[guid] == 0 then
		return
	end

	for i = 1, tt:NumLines() do
		local leftTip = _G["GameTooltipTextLeft" .. i]
		local leftTipText = leftTip:GetText()
		if leftTipText and leftTipText == L["Item Level:"] then
			local rightTip = _G["GameTooltipTextRight" .. i]
			local rightTipText = rightTip:GetText()
			rightTipText = formatSets[#cache[guid]] .. "|r " .. rightTipText
			rightTip:SetText(rightTipText)
			return
		end
	end
end

function T:InitializeTierSet()
	if not self.db.tierSet then
		return
	end

	T:Hook(ET, "INSPECT_READY", ResetCache, true)
	T:Hook(ET, "PopulateInspectGUIDCache", "ElvUITooltipPopulateInspectGUIDCache")
	T:SecureHook(E.ScanTooltip, "SetInventoryItem", "ElvUIScanTooltipSetInventoryItem")
	T:AddInspectInfoCallback(1, "TierSet", true)
end

T:AddCallback("InitializeTierSet")
