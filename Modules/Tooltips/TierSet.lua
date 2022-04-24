local W, F, E, L = unpack(select(2, ...))
local ET = E:GetModule("Tooltip")
local T = W:GetModule("Tooltips")

local _G = _G

local pairs = pairs
local select = select
local strmatch = strmatch
local tinsert = tinsert
local tonumber = tonumber

local UnitGUID = UnitGUID

local cache = {}
local locked = {}

-- from NDui
local T29Sets = {
    -- HUNTER
    [188856] = true,
    [188858] = true,
    [188859] = true,
    [188860] = true,
    [188861] = true,
    -- WARRIOR
    [188937] = true,
    [188938] = true,
    [188940] = true,
    [188941] = true,
    [188942] = true,
    -- PALADIN
    [188928] = true,
    [188929] = true,
    [188931] = true,
    [188932] = true,
    [188933] = true,
    -- ROGUE
    [188901] = true,
    [188902] = true,
    [188903] = true,
    [188905] = true,
    [188907] = true,
    -- PRIEST
    [188875] = true,
    [188878] = true,
    [188879] = true,
    [188880] = true,
    [188881] = true,
    -- DK
    [188863] = true,
    [188864] = true,
    [188866] = true,
    [188867] = true,
    [188868] = true,
    -- SHAMAN
    [188920] = true,
    [188922] = true,
    [188923] = true,
    [188924] = true,
    [188925] = true,
    -- MAGE
    [188839] = true,
    [188842] = true,
    [188843] = true,
    [188844] = true,
    [188845] = true,
    -- WARLOCK
    [188884] = true,
    [188887] = true,
    [188888] = true,
    [188889] = true,
    [188890] = true,
    -- MONK
    [188910] = true,
    [188911] = true,
    [188912] = true,
    [188914] = true,
    [188916] = true,
    -- DRUID
    [188847] = true,
    [188848] = true,
    [188849] = true,
    [188851] = true,
    [188853] = true,
    -- DH
    [188892] = true,
    [188893] = true,
    [188894] = true,
    [188896] = true,
    [188898] = true
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
            itemID = itemID and tonumber(itemID)
            if T29Sets[tonumber(itemID)] then
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
