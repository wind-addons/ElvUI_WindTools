local W, F, E, L = unpack(select(2, ...))
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

-- https://www.wowhead.com/guide/vault-incarnates-dragonflight-class-tier-set-overview-primalist-bonuses
local tierSetsID = {
    -- HUNTER
    [200387] = true,
    [200389] = true,
    [200390] = true,
    [200391] = true,
    [200392] = true,
    -- WARRIOR
    [200423] = true,
    [200425] = true,
    [200426] = true,
    [200427] = true,
    [200428] = true,
    -- PALADIN
    [200414] = true,
    [200416] = true,
    [200417] = true,
    [200418] = true,
    [200419] = true,
    -- ROGUE
    [200369] = true,
    [200371] = true,
    [200372] = true,
    [200373] = true,
    [200374] = true,
    -- PRIEST
    [200326] = true,
    [200327] = true,
    [200328] = true,
    [200324] = true,
    [200329] = true,
    -- DK
    [200405] = true,
    [200407] = true,
    [200408] = true,
    [200409] = true,
    [200410] = true,
    -- SHAMAN
    [200396] = true,
    [200398] = true,
    [200399] = true,
    [200400] = true,
    [200401] = true,
    -- MAGE
    [200315] = true,
    [200317] = true,
    [200318] = true,
    [200319] = true,
    [200320] = true,
    -- WARLOCK
    [200335] = true,
    [200336] = true,
    [200337] = true,
    [200333] = true,
    [200338] = true,
    -- MONK
    [200360] = true,
    [200362] = true,
    [200363] = true,
    [200364] = true,
    [200365] = true,
    -- DRUID
    [200351] = true,
    [200353] = true,
    [200354] = true,
    [200355] = true,
    [200356] = true,
    -- DH
    [200342] = true,
    [200344] = true,
    [200345] = true,
    [200346] = true,
    [200347] = true,
    [200356] = true,
    -- EVOKER
    [200378] = true,
    [200380] = true,
    [200381] = true,
    [200382] = true,
    [200383] = true
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
