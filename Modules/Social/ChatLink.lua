local W, F, E, L, _, _, G = unpack(select(2, ...))
local CL = W:NewModule("ChatLink", "AceEvent-3.0")

local _G = _G
local ceil = ceil
local format = format
local gsub = gsub
local pairs = pairs
local select = select
local strmatch = strmatch
local tonumber = tonumber
local tostring = tostring
local unpack = unpack

local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter
local GetItemIcon = GetItemIcon
local GetItemInfo = GetItemInfo
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local GetSpellTexture = GetSpellTexture
local GetTalentInfoByID = GetTalentInfoByID

local ItemLevelPattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)")

local IconString = "|T%s:16:18:0:0:64:64:4:60:7:57"

local SearchArmorType = {
    INVTYPE_HEAD = true,
    INVTYPE_SHOULDER = true,
    INVTYPE_CHEST = true,
    INVTYPE_WRIST = true,
    INVTYPE_HAND = true,
    INVTYPE_WAIST = true,
    INVTYPE_LEGS = true,
    INVTYPE_FEET = true
}

local abbrList = {
    INVTYPE_HEAD = L["[ABBR] Head"],
    INVTYPE_NECK = L["[ABBR] Neck"],
    INVTYPE_SHOULDER = L["[ABBR] Shoulders"],
    INVTYPE_CLOAK = L["[ABBR] Back"],
    INVTYPE_CHEST = L["[ABBR] Chest"],
    INVTYPE_WRIST = L["[ABBR] Wrist"],
    INVTYPE_HAND = L["[ABBR] Hands"],
    INVTYPE_WAIST = L["[ABBR] Waist"],
    INVTYPE_LEGS = L["[ABBR] Legs"],
    INVTYPE_FEET = L["[ABBR] Feet"],
    INVTYPE_HOLDABLE = L["[ABBR] Held In Off-hand"],
    INVTYPE_FINGER = L["[ABBR] Finger"],
    INVTYPE_TRINKET = L["[ABBR] Trinket"]
}

local function AddItemInfo(Hyperlink)
    local id = strmatch(Hyperlink, "Hitem:(%d-):")
    if not id then
        return
    end
    id = tonumber(id)

    -- Get real item level
    if CL.db.level or CL.db.slot then
        local text, level, extraname, slot
        E.ScanTooltip:SetOwner(_G.UIParent, "ANCHOR_NONE")
        E.ScanTooltip:ClearLines()
        E.ScanTooltip:SetHyperlink(Hyperlink)

        if CL.db.level then
            for i = 2, 5 do
                local leftText = _G[E.ScanTooltip:GetName() .. "TextLeft" .. i]
                if leftText then
                    text = leftText:GetText() or ""
                    level = strmatch(text, ItemLevelPattern)
                    if level then
                        break
                    end
                end
            end
        end

        -- Is the item a weapon?
        local type = select(6, GetItemInfo(id))
        -- armor
        if type == _G.ARMOR and CL.db.armorCategory then
            local equipLoc = select(9, GetItemInfo(id))
            if equipLoc ~= "" then
                if SearchArmorType[equipLoc] then
                    -- if the item is armor, then get the armor category
                    local armorType = select(7, GetItemInfo(id))
                    if E.global.general.locale == "zhTW" or E.global.general.locale == "zhCN" then
                        slot = armorType .. (abbrList[equipLoc] or _G[equipLoc])
                    else
                        slot = armorType .. " " .. (abbrList[equipLoc] or _G[equipLoc])
                    end
                else
                    slot = abbrList[equipLoc] or _G[equipLoc]
                end
            end
        end

        -- weapon
        if type == _G.WEAPON and CL.db.weaponCategory then
            local equipLoc = select(9, GetItemInfo(id))
            if equipLoc ~= "" then
                local weaponType = select(7, GetItemInfo(id))
                slot = weaponType or abbrList[equipLoc] or _G[equipLoc]
            end
        end

        if level and extraname then
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. level .. ":%1:" .. extraname .. "]|h")
        elseif level and slot then
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. level .. "-" .. slot .. ":%1]|h")
        elseif level then
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. level .. ":%1]|h")
        elseif slot then
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. slot .. ":%1]|h")
        end
    end

    if CL.db.icon then
        local texture = GetItemIcon(id)
        local icon = format(IconString .. ":255:255:255|t", texture)
        Hyperlink = icon .. " " .. Hyperlink
    end

    return Hyperlink
end

local function AddSpellInfo(Hyperlink)
    -- spell icon
    local id = strmatch(Hyperlink, "Hspell:(%d-):")
    if not id then
        return
    end

    if CL.db.icon then
        local texture = GetSpellTexture(tonumber(id))
        local icon = format(IconString .. ":255:255:255|t", texture)
        Hyperlink = icon .. " |cff71d5ff" .. Hyperlink .. "|r" -- I dk why the color is needed, but worked!
    end

    return Hyperlink
end

local function AddEnchantInfo(Hyperlink)
    -- enchant
    local id = strmatch(Hyperlink, "Henchant:(%d-)\124")
    if not id then
        return
    end

    if CL.db.icon then
        local texture = GetSpellTexture(tonumber(id))
        local icon = format(IconString .. ":255:255:255|t", texture)
        Hyperlink = icon .. " " .. Hyperlink
    end

    return Hyperlink
end

local function AddPvPTalentInfo(Hyperlink)
    -- PVP talent
    local id = strmatch(Hyperlink, "Hpvptal:(%d-)|")
    if not id then
        return
    end

    if CL.db.icon then
        local texture = select(3, GetPvpTalentInfoByID(tonumber(id)))
        local icon = format(IconString .. ":255:255:255|t", texture)
        Hyperlink = icon .. " " .. Hyperlink
    end

    return Hyperlink
end

local function AddTalentInfo(Hyperlink)
    -- talent
    local id = strmatch(Hyperlink, "Htalent:(%d-)|")
    if not id then
        return
    end

    if CL.db.icon then
        local texture = select(3, GetTalentInfoByID(tonumber(id)))
        local icon = format(IconString .. ":255:255:255|t", texture)
        Hyperlink = icon .. " " .. Hyperlink
    end

    return Hyperlink
end

function CL:Filter(event, msg, ...)
    if CL.db.enable then
        msg = gsub(msg, "(|Hitem:%d+:.-|h.-|h)", AddItemInfo)
        msg = gsub(msg, "(|Hspell:%d+:%d+|h.-|h)", AddSpellInfo)
        msg = gsub(msg, "(|Henchant:%d+|h.-|h)", AddEnchantInfo)
        msg = gsub(msg, "(|Htalent:%d+|h.-|h)", AddTalentInfo)
        msg = gsub(msg, "(|Hpvptal:%d+|h.-|h)", AddPvPTalentInfo)
    end
    return false, msg, ...
end

function CL:Initialize()
    self.db = E.db.WT.social.chatLink

    local events = {
        "CHAT_MSG_ACHIEVEMENT",
        "CHAT_MSG_BATTLEGROUND",
        "CHAT_MSG_BN_WHISPER",
        "CHAT_MSG_CHANNEL",
        "CHAT_MSG_COMMUNITIES_CHANNEL",
        "CHAT_MSG_EMOTE",
        "CHAT_MSG_GUILD",
        "CHAT_MSG_INSTANCE_CHAT",
        "CHAT_MSG_INSTANCE_CHAT_LEADER",
        "CHAT_MSG_LOOT",
        "CHAT_MSG_OFFICER",
        "CHAT_MSG_PARTY",
        "CHAT_MSG_PARTY_LEADER",
        "CHAT_MSG_RAID",
        "CHAT_MSG_RAID_LEADER",
        "CHAT_MSG_SAY",
        "CHAT_MSG_TRADESKILLS",
        "CHAT_MSG_WHISPER",
        "CHAT_MSG_WHISPER_INFORM",
        "CHAT_MSG_YELL"
    }

    for _, event in pairs(events) do
        ChatFrame_AddMessageEventFilter(event, self.Filter)
    end

    self.initialized = true
end

function CL:ProfileUpdate()
    self.db = E.db.WT.social.chatLink

    if self.db.enable and not self.initialized then
        self:Initialize()
    end
end

W:RegisterModule(CL:GetName())
