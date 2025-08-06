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

-- https://www.wowhead.com/guide/raids/manaforge-omega/tier-set-overview
-- JavaScript to get tier set ids (used in the specific class tier set page)
-- console.log(Array.from(document.querySelector('.icon-list>tbody').children).reduce((s,c)=>{const a=c.querySelector('td>a');return s+`[${a.href.match(/item=(\d+)/)[1]}] = true, -- ${a.innerText}\n`},''));
local tierSetsID = {
	-- HUNTER
	[237649] = true, -- Midnight Herald's Hauberk
	[237647] = true, -- Midnight Herald's Gloves
	[237646] = true, -- Midnight Herald's Cowl
	[237645] = true, -- Midnight Herald's Petticoat
	[237644] = true, -- Midnight Herald's Shadowguards
	-- WARRIOR
	[237613] = true, -- Living Weapon's Bulwark
	[237611] = true, -- Living Weapon's Crushers
	[237610] = true, -- Living Weapon's Faceshield
	[237609] = true, -- Living Weapon's Legguards
	[237608] = true, -- Living Weapon's Ramparts
	-- PALADIN
	[237622] = true, -- Cuirass of the Lucent Battalion
	[237620] = true, -- Protectors of the Lucent Battalion
	[237619] = true, -- Lightmane of the Lucent Battalion
	[237618] = true, -- Cuisses of the Lucent Battalion
	[237617] = true, -- Chargers of the Lucent Battalion
	-- ROGUE
	[237667] = true, -- Tactical Vest of the Sudden Eclipse
	[237665] = true, -- Deathgrips of the Sudden Eclipse
	[237664] = true, -- Hood of the Sudden Eclipse
	[237663] = true, -- Pants of the Sudden Eclipse
	[237662] = true, -- Smokemantle of the Sudden Eclipse
	-- PRIEST
	[237710] = true, -- Dying Star's Caress
	[237709] = true, -- Dying Star's Veil
	[237708] = true, -- Dying Star's Leggings
	[237712] = true, -- Dying Star's Cassock
	[237707] = true, -- Dying Star's Pyrelights
	-- DK
	[237631] = true, -- Hollow Sentinel's Breastplate
	[237629] = true, -- Hollow Sentinel's Gauntlets
	[237628] = true, -- Hollow Sentinel's Stonemask
	[237627] = true, -- Hollow Sentinel's Stonekilt
	[237626] = true, -- Hollow Sentinel's Perches
	-- SHAMAN
	[237640] = true, -- Furs of Channeled Fury
	[237638] = true, -- Claws of Channeled Fury
	[237637] = true, -- Aspect of Channeled Fury
	[237636] = true, -- Tassets of Channeled Fury
	[237635] = true, -- Fangs of Channeled Fury
	-- MAGE
	[237721] = true, -- Augur's Ephemeral Habiliments
	[237719] = true, -- Augur's Ephemeral Mitts
	[237718] = true, -- Augur's Ephemeral Wide-Brim
	[237717] = true, -- Augur's Ephemeral Trousers
	[237716] = true, -- Augur's Ephemeral Orbs of Power
	-- WARLOCK
	[237701] = true, -- Inquisitor's Clutches of Madness
	[237700] = true, -- Inquisitor's Portal to Madness
	[237699] = true, -- Inquisitor's Leggings of Madness
	[237703] = true, -- Inquisitor's Robes of Madness
	[237698] = true, -- Inquisitor's Gaze of Madness
	-- MONK
	[237676] = true, -- Gi of Fallen Storms
	[237674] = true, -- Grasp of Fallen Storms
	[237673] = true, -- Half-Mask of Fallen Storms
	[237672] = true, -- Legwraps of Fallen Storms
	[237671] = true, -- Glyphs of Fallen Storms
	-- DRUID
	[237685] = true, -- Vest of the Mother Eagle
	[237683] = true, -- Wings of the Mother Eagle
	[237682] = true, -- Skymane of the Mother Eagle
	[237681] = true, -- Breeches of the Mother Eagle
	[237680] = true, -- Ritual Pauldrons of the Mother Eagle
	-- DH
	[237694] = true, -- Charhound's Vicious Bindings
	[237692] = true, -- Charhound's Vicious Felclaws
	[237691] = true, -- Charhound's Vicious Scalp
	[237690] = true, -- Charhound's Vicious Hidecoat
	[237689] = true, -- Charhound's Vicious Hornguards
	-- EVOKER
	[237658] = true, -- Spellweaver's Immaculate Crestward
	[237656] = true, -- Spellweaver's Immaculate Scaleguards
	[237655] = true, -- Spellweaver's Immaculate Focus
	[237654] = true, -- Spellweaver's Immaculate Runeslacks
	[237653] = true, -- Spellweaver's Immaculate Pauldrons
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
