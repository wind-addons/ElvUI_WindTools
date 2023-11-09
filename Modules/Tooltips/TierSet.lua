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

-- https://www.wowhead.com/guide/raids/amirdrassil-the-dreams-hope/tier-sets
-- JavaScript to get tier set ids (used in the specific class tier set page)
-- var a = ""; document.querySelector(".icon-list > tbody").children.forEach((child) => {const name = child.querySelector("td > a").innerText; const id = child.querySelector("td > a").href.match(/item=([0-9]*)/)[1]; a += `[${id}] = true, -- ${name}\n` }); console.log(a);
local tierSetsID = {
    -- HUNTER
    [207216] = true, -- Blazing Dreamstalker's Finest Hunt
    [207217] = true, -- Blazing Dreamstalker's Shellgreaves
    [207218] = true, -- Blazing Dreamstalker's Flamewaker Horns
    [207219] = true, -- Blazing Dreamstalker's Skinners
    [207221] = true, -- Blazing Dreamstalker's Scaled Hauberk
    -- WARRIOR
    [207180] = true, -- Molten Vanguard's Shouldervents
    [207181] = true, -- Molten Vanguard's Steel Tassets
    [207182] = true, -- Molten Vanguard's Domeplate
    [207183] = true, -- Molten Vanguard's Crushers
    [207185] = true, -- Molten Vanguard's Plackart
    -- PALADIN
    [207189] = true, -- Zealous Pyreknight's Ailettes
    [207190] = true, -- Zealous Pyreknight's Cuisses
    [207191] = true, -- Zealous Pyreknight's Barbute
    [207192] = true, -- Zealous Pyreknight's Jeweled Gauntlets
    [207194] = true, -- Zealous Pyreknight's Warplate
    -- ROGUE
    [207234] = true, -- Lucid Shadewalker's Bladed Spaulders
    [207235] = true, -- Lucid Shadewalker's Chausses
    [207236] = true, -- Lucid Shadewalker's Deathmask
    [207237] = true, -- Lucid Shadewalker's Clawgrips
    [207239] = true, -- Lucid Shadewalker's Cuirass
    -- PRIEST
    [207279] = true, -- Shoulderguardians of Lunar Communion
    [207280] = true, -- Leggings of Lunar Communion
    [207281] = true, -- Crest of Lunar Communion
    [207282] = true, -- Touch of Lunar Communion
    [207284] = true, -- Cassock of Lunar Communion
    -- DK
    [207198] = true, -- Skewers of the Risen Nightmare
    [207199] = true, -- Greaves of the Risen Nightmare
    [207200] = true, -- Piercing Gaze of the Risen Nightmare
    [207201] = true, -- Thorns of the Risen Nightmare
    [207203] = true, -- Casket of the Risen Nightmare
    -- SHAMAN
    [207207] = true, -- Greatwolf Outcast's Companions
    [207208] = true, -- Greatwolf Outcast's Fur-Lined Kilt
    [207209] = true, -- Greatwolf Outcast's Jaws
    [207210] = true, -- Greatwolf Outcast's Grips
    [207212] = true, -- Greatwolf Outcast's Harness
    -- MAGE
    [207288] = true, -- Wayward Chronomancer's Metronomes
    [207289] = true, -- Wayward Chronomancer's Pantaloons
    [207290] = true, -- Wayward Chronomancer's Chronocap
    [207291] = true, -- Wayward Chronomancer's Gloves
    [207293] = true, -- Wayward Chronomancer's Patchwork
    -- WARLOCK
    [207270] = true, -- Devout Ashdevil's Hatespikes
    [207271] = true, -- Devout Ashdevil's Tights
    [207272] = true, -- Devout Ashdevil's Grimhorns
    [207273] = true, -- Devout Ashdevil's Claws
    [207275] = true, -- Devout Ashdevil's Razorhide
    -- MONK
    [207243] = true, -- Mystic Heron's Hopeful Effigy
    [207244] = true, -- Mystic Heron's Waders
    [207245] = true, -- Mystic Heron's Hatsuburi
    [207246] = true, -- Mystic Heron's Glovebills
    [207248] = true, -- Mystic Heron's Burdens
    -- DRUID
    [207252] = true, -- Benevolent Embersage's Wisdom
    [207253] = true, -- Benevolent Embersage's Leggings
    [207254] = true, -- Benevolent Embersage's Casque
    [207255] = true, -- Benevolent Embersage's Talons
    [207257] = true, -- Benevolent Embersage's Robe
    -- DH
    [207261] = true, -- Screaming Torchfiend's Horned Memento
    [207262] = true, -- Screaming Torchfiend's Blazewraps
    [207263] = true, -- Screaming Torchfiend's Burning Scowl
    [207264] = true, -- Screaming Torchfiend's Grasp
    [207266] = true, -- Screaming Torchfiend's Binding
    -- EVOKER
    [207225] = true, -- Weyrnkeeper's Timeless Sandbrace
    [207226] = true, -- Weyrnkeeper's Timeless Breeches
    [207227] = true, -- Weyrnkeeper's Timeless Dracoif
    [207228] = true, -- Weyrnkeeper's Timeless Clawguards
    [207230] = true, -- Weyrnkeeper's Timeless Raiment
}

local formatSets = {
    [1] = " |cff14b200(1/4)", -- green
    [2] = " |cff0091f2(2/4)", -- blue
    [3] = " |cff0091f2(3/4)", -- blue
    [4] = " |cffc745f9(4/4)", -- purple
    [5] = " |cffc745f9(5/5)" -- purple
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
