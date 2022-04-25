local W, F, E, L = unpack(select(2, ...))
local ET = E:GetModule("Tooltip")
local T = W:GetModule("Tooltips")
local LibOR = LibStub("LibOpenRaid-1.0", true)

-- Modified from NDui_Plus Tooltips
local format = format
local pairs = pairs
local select = select
local strmatch = strmatch
local strsplit = strsplit
local strsub = strsub
local tonumber = tonumber

local Ambiguate = Ambiguate
local GetNumGroupMembers = GetNumGroupMembers
local GetRaidRosterInfo = GetRaidRosterInfo
local GetUnitName = GetUnitName
local IsAddOnLoaded = IsAddOnLoaded
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local UnitGUID = UnitGUID
local UnitIsUnit = UnitIsUnit

local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE

local C_ChatInfo_RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix
local C_ChatInfo_SendAddonMessage = C_ChatInfo.SendAddonMessage
local C_Covenants_GetActiveCovenantID = C_Covenants.GetActiveCovenantID

local locales = {
    ["Kyrian"] = L["Kyrian"],
    ["Venthyr"] = L["Venthyr"],
    ["NightFae"] = L["NightFae"],
    ["Necrolord"] = L["Necrolord"]
}

local covenantMap = {
    [1] = "Kyrian",
    [2] = "Venthyr",
    [3] = "NightFae",
    [4] = "Necrolord"
}

-- Credit: OmniCD
local covenantAbilities = {
    [324739] = 1,
    [323436] = 1,
    [312202] = 1,
    [306830] = 1,
    [326434] = 1,
    [338142] = 1,
    [338035] = 1,
    [338018] = 1,
    [327022] = 1,
    [327037] = 1,
    [327071] = 1,
    [308491] = 1,
    [307443] = 1,
    [310454] = 1,
    [304971] = 1,
    [325013] = 1,
    [323547] = 1,
    [324386] = 1,
    [312321] = 1,
    [307865] = 1,
    [300728] = 2,
    [311648] = 2,
    [317009] = 2,
    [323546] = 2,
    [324149] = 2,
    [314793] = 2,
    [326860] = 2,
    [316958] = 2,
    [323673] = 2,
    [323654] = 2,
    [320674] = 2,
    [321792] = 2,
    [317483] = 2,
    [317488] = 2,
    [310143] = 3,
    [324128] = 3,
    [323639] = 3,
    [323764] = 3,
    [328231] = 3,
    [314791] = 3,
    [327104] = 3,
    [328622] = 3,
    [328282] = 3,
    [328620] = 3,
    [328281] = 3,
    [327661] = 3,
    [328305] = 3,
    [328923] = 3,
    [325640] = 3,
    [325886] = 3,
    [319217] = 3,
    [324631] = 4,
    [315443] = 4,
    [329554] = 4,
    [325727] = 4,
    [325028] = 4,
    [324220] = 4,
    [325216] = 4,
    [328204] = 4,
    [324724] = 4,
    [328547] = 4,
    [326059] = 4,
    [325289] = 4,
    [324143] = 4
}

local DCLoaded

local ZT_Prefix = "ZenTracker"
local DC_Prefix = "DCOribos"
local OmniCD_Prefix = "OmniCD"
local MRT_Prefix = "EXRTADD"

local addonPrefixes = {
    [ZT_Prefix] = true,
    [DC_Prefix] = true,
    [OmniCD_Prefix] = true,
    [MRT_Prefix] = true
}

local cache = {}
local askedPlayers = {}

local function GetBestChannel()
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
        return "INSTANCE_CHAT"
    elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
        return "RAID"
    elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
        return "PARTY"
    end
end

local function HandleRosterUpdate()
    if not IsInGroup() then
        return
    end

    for i = 1, GetNumGroupMembers() do
        local name = GetRaidRosterInfo(i)
        if name and name ~= E.myname and not askedPlayers[name] then
            if not DCLoaded then
                C_ChatInfo_SendAddonMessage(DC_Prefix, format("ASK:%s", name), GetBestChannel())
            end
            C_ChatInfo_SendAddonMessage(MRT_Prefix, format("inspect\tREQ\tS\t%s", name), GetBestChannel())
            askedPlayers[name] = true
        end
    end

    LibOR.RequestAllData()
end

local function GetCovenantID(unit, guid)
    local covenantID = cache[guid]
    if not covenantID then
        local playerInfo = LibOR.UnitInfoManager.GetUnitInfo(UnitName(unit))
        covenantID = playerInfo and playerInfo.covenantId
    end

    return covenantID
end

local function HandleAddonMessage(_, _, ...)
    local prefix, msg, _, sender = ...
    sender = Ambiguate(sender, "none")
    if sender == E.myname then
        return
    end

    askedPlayers[sender] = true
    if not addonPrefixes[prefix] then
        return
    end

    if prefix == ZT_Prefix then
        local version, type, guid, _, _, _, _, covenantID = strsplit(":", msg)
        version = tonumber(version)
        if (version and version > 3) and (type and type == "H") and guid then
            covenantID = tonumber(covenantID)
            if covenantID and (not cache[guid] or cache[guid] ~= covenantID) then
                cache[guid] = covenantID
            end
        end
    elseif prefix == OmniCD_Prefix then
        local header, guid, body = strmatch(msg, "(.-),(.-),(.+)")
        if (header and guid and body) and (header == "INF" or header == "REQ" or header == "UPD") then
            local covenantID = select(15, strsplit(",", body))
            covenantID = tonumber(covenantID)
            if covenantID and (not cache[guid] or cache[guid] ~= covenantID) then
                cache[guid] = covenantID
            end
        end
    elseif prefix == DC_Prefix then
        local playerName, covenantID = strsplit(":", msg)
        if playerName == "ASK" then
            return
        end

        local guid = UnitGUID(sender)
        covenantID = tonumber(covenantID)
        if covenantID and guid and (not cache[guid] or cache[guid] ~= covenantID) then
            cache[guid] = covenantID
        end
    elseif prefix == MRT_Prefix then
        local modPrefix, subPrefix, soulbinds = strsplit("\t", msg)
        if
            (modPrefix and modPrefix == "inspect") and (subPrefix and subPrefix == "R") and
                (soulbinds and strsub(soulbinds, 1, 1) == "S")
         then
            local guid = UnitGUID(sender)
            local covenantID = select(2, strsplit(":", soulbinds))
            covenantID = tonumber(covenantID)
            if covenantID and guid and (not cache[guid] or cache[guid] ~= covenantID) then
                cache[guid] = covenantID
            end
        end
    end
end

local function HandleSpellCast(unit, _, spellID)
    local covenantID = covenantAbilities[spellID]
    if covenantID then
        local guid = UnitGUID(unit)
        if guid and (not cache[guid] or cache[guid] ~= covenantID) then
            cache[guid] = covenantID
        end
    end
end

function T:Covenant(tt, unit, guid)
    if not self.db.covenant then
        return
    end

    local covenantID
    if UnitIsUnit(unit, "player") then
        covenantID = C_Covenants_GetActiveCovenantID()
    else
        covenantID = GetCovenantID(unit, guid)
    end

    local covenantName = covenantMap[covenantID]

    if covenantID and covenantID ~= 0 then
        tt:AddDoubleLine(
            L["Covenant"] .. ":",
            F.GetIconString(W.Media.Icons["covenant" .. covenantName], 14) .. " " .. locales[covenantName],
            nil,
            nil,
            nil,
            1,
            1,
            1
        )
    end
end

function T:InitializeCovenant()
    if not self.db.covenant then
        return
    end

    DCLoaded = IsAddOnLoaded("Details_Covenants")

    for prefix in pairs(addonPrefixes) do
        C_ChatInfo_RegisterAddonMessagePrefix(prefix)
    end

    HandleRosterUpdate()

    self:AddEventCallback("CHAT_MSG_ADDON", HandleAddonMessage)
    self:AddEventCallback("GROUP_ROSTER_UPDATE", HandleRosterUpdate)
    self:AddEventCallback("UNIT_SPELLCAST_SUCCEEDED", HandleSpellCast)
    self:AddInspectInfoCallback(2, "Covenant", true)
end

T:AddCallback("InitializeCovenant")
