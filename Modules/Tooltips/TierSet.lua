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

-- https://www.wowhead.com/guide/raids/nerubar-palace/tier-sets
-- JavaScript to get tier set ids (used in the specific class tier set page)
-- var a = ""; document.querySelector(".icon-list > tbody").children.forEach((child) => {const name = child.querySelector("td > a").innerText; const id = child.querySelector("td > a").href.match(/item=([0-9]*)/)[1]; a += `[${id}] = true, -- ${name}\n` }); console.log(a);
local tierSetsID = {
	-- HUNTER
	[212023] = true, -- Lightless Scavenger's Tunic
	[212021] = true, -- Lightless Scavenger's Mitts
	[212020] = true, -- Lightless Scavenger's Skull
	[212019] = true, -- Lightless Scavenger's Stalkings
	[212018] = true, -- Lightless Scavenger's Taxidermy
	-- WARRIOR
	[211987] = true, -- Warsculptor's Furred Plastron
	[211985] = true, -- Warsculptor's Crushers
	[211984] = true, -- Warsculptor's Barbute
	[211983] = true, -- Warsculptor's Cuisses
	[211982] = true, -- Warsculptor's Horned Spaulders
	-- PALADIN
	[211996] = true, -- Entombed Seraph's Breastplate
	[211994] = true, -- Entombed Seraph's Castigation
	[211993] = true, -- Entombed Seraph's Casque
	[211992] = true, -- Entombed Seraph's Greaves
	[211991] = true, -- Entombed Seraph's Plumes
	-- ROGUE
	[212041] = true, -- K'areshi Phantom's Nexus Wraps
	[212039] = true, -- K'areshi Phantom's Grips
	[212038] = true, -- K'areshi Phantom's Emptiness
	[212037] = true, -- K'areshi Phantom's Leggings
	[212036] = true, -- K'areshi Phantom's Shoulderpads
	-- PRIEST
	[212084] = true, -- Living Luster's Touch
	[212083] = true, -- Living Luster's Semblance
	[212082] = true, -- Living Luster's Trousers
	[212086] = true, -- Living Luster's Raiment
	[212081] = true, -- Living Luster's Dominion
	-- DK
	[212005] = true, -- Exhumed Centurion's Breastplate
	[212003] = true, -- Exhumed Centurion's Gauntlets
	[212002] = true, -- Exhumed Centurion's Galea
	[212001] = true, -- Exhumed Centurion's Chausses
	[212000] = true, -- Exhumed Centurion's Spikes
	-- SHAMAN
	[212014] = true, -- Vestments of the Forgotten Reservoir
	[212012] = true, -- Covenant of the Forgotten Reservoir
	[212011] = true, -- Noetic of the Forgotten Reservoir
	[212010] = true, -- Sarong of the Forgotten Reservoir
	[212009] = true, -- Concourse of the Forgotten Reservoir
	-- MAGE
	[212095] = true, -- Runecoat of Violet Rebirth
	[212093] = true, -- Jeweled Gauntlets of Violet Rebirth
	[212092] = true, -- Hood of Violet Rebirth
	[212091] = true, -- Coattails of Violet Rebirth
	[212090] = true, -- Beacons of Violet Rebirth
	-- WARLOCK
	[212075] = true, -- Hexflame Coven's Sleeves
	[212074] = true, -- Hexflame Coven's All-Seeing Eye
	[212073] = true, -- Hexflame Coven's Leggings
	[212077] = true, -- Hexflame Coven's Ritual Harness
	[212072] = true, -- Hexflame Coven's Altar
	-- MONK
	[212050] = true, -- Gatecrasher's Gi
	[212048] = true, -- Gatecrasher's Protectors
	[212047] = true, -- Gatecrasher's Horns
	[212046] = true, -- Gatecrasher's Kilt
	[212045] = true, -- Gatecrasher's Enduring Effigy
	-- DRUID
	[212059] = true, -- Hide of the Greatlynx
	[212057] = true, -- Eviscerators of the Greatlynx
	[212056] = true, -- Mask of the Greatlynx
	[212055] = true, -- Leggings of the Greatlynx
	[212054] = true, -- Maw of the Greatlynx
	-- DH
	[212068] = true, -- Chestguard of the Hypogeal Nemesis
	[212066] = true, -- Claws of the Hypogeal Nemesis
	[212065] = true, -- Impalers of the Hypogeal Nemesis
	[212064] = true, -- Pantaloons of the Hypogeal Nemesis
	[212063] = true, -- War-Mantle of the Hypogeal Nemesis
	-- EVOKER
	[212032] = true, -- Scales of the Destroyer
	[212030] = true, -- Rippers of the Destroyer
	[212029] = true, -- Horns of the Destroyer
	[212028] = true, -- Legguards of the Destroyer
	[212027] = true, -- Fumaroles of the Destroyer
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

	T:Hook(ET, "INSPECT_READY", ResetCache)
	T:Hook(ET, "PopulateInspectGUIDCache", "ElvUITooltipPopulateInspectGUIDCache")
	T:SecureHook(E.ScanTooltip, "SetInventoryItem", "ElvUIScanTooltipSetInventoryItem")
	T:AddInspectInfoCallback(1, "TierSet", true)
end

T:AddCallback("InitializeTierSet")
