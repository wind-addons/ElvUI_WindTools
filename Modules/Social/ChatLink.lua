local W, F, E, L, _, _, G = unpack(select(2, ...))
local CL = W:NewModule("ChatLink")

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
local GetItemInfoInstant = GetItemInfoInstant
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local GetSpellTexture = GetSpellTexture
local GetTalentInfoByID = GetTalentInfoByID

local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_Item_GetItemNameByID = C_Item.GetItemNameByID
local C_Soulbinds_GetConduitCollectionData = C_Soulbinds.GetConduitCollectionData

local ICON_STRING = "|T%s:16:18:0:0:64:64:4:60:7:57:255:255:255|t"

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

local function AddItemInfo(link)
    local itemID, itemType, itemSubType, itemEquipLoc, icon, classID, subclassID = GetItemInfoInstant(link)

    if not itemID then
        return
    end

    if CL.db.translateItem then
        local localizedName = C_Item_GetItemNameByID(itemID)
        if localizedName then
            local professionIcon = strmatch(link, "|A:Professions.-|a")
            if professionIcon then
                localizedName = localizedName .. " " .. professionIcon
            end
            link = gsub(link, "|h%[(.+)%]|h", "|h[" .. localizedName .. "]|h")
        end
    end

    local level, slot

    -- item Level
    if CL.db.level then
        level = F.GetRealItemLevelByLink(link)
    end

    -- armor
    if itemType == _G.ARMOR and CL.db.armorCategory then
        if itemEquipLoc ~= "" then
            if SearchArmorType[itemEquipLoc] then
                if E.global.general.locale == "zhTW" or E.global.general.locale == "zhCN" then
                    slot = itemSubType .. (abbrList[itemEquipLoc] or _G[itemEquipLoc])
                else
                    slot = itemSubType .. " " .. (abbrList[itemEquipLoc] or _G[itemEquipLoc])
                end
            else
                slot = abbrList[itemEquipLoc] or _G[itemEquipLoc]
            end
        end
    end

    -- weapon
    if itemType == _G.WEAPON and CL.db.weaponCategory then
        if itemEquipLoc ~= "" then
            slot = itemSubType or abbrList[itemEquipLoc] or _G[itemEquipLoc]
        end
    end

    if level and slot then
        link = gsub(link, "|h%[(.-)%]|h", "|h[" .. level .. "-" .. slot .. ":%1]|h")
    elseif level then
        link = gsub(link, "|h%[(.-)%]|h", "|h[" .. level .. ":%1]|h")
    elseif slot then
        link = gsub(link, "|h%[(.-)%]|h", "|h[" .. slot .. ":%1]|h")
    end

    if CL.db.icon then
        link = format(ICON_STRING, icon) .. " " .. link
    end

    return link
end

local function AddKeystoneIcon(link)
    local itemID, mapID, level = strmatch(link, "Hkeystone:(%d-):(%d-):(%d-):")
    if not (itemID and mapID and level and itemID == "180653") then
        return
    end

    if CL.db.icon then
        local texture = select(4, C_ChallengeMode_GetMapUIInfo(tonumber(mapID)))
        local icon = texture and format(ICON_STRING, texture)
        if icon then
            link = icon .. " " .. link
        end
    end

    return link
end

local function AddConduitIcon(link)
    local conduitID = strmatch(link, "Hconduit:(%d-):")
    if not conduitID then
        return
    end

    if CL.db.icon then
        local conduitCollectionData = C_Soulbinds_GetConduitCollectionData(conduitID)
        local conduitItemID = conduitCollectionData and conduitCollectionData.conduitItemID

        if conduitItemID then
            local texture = select(5, GetItemInfoInstant(conduitItemID))
            local icon = texture and format(ICON_STRING, texture)
            if icon then
                link = icon .. " " .. link
            end
        end
    end

    return link
end

local function AddSpellInfo(link)
    -- spell icon
    local id = strmatch(link, "Hspell:(%d-):")
    if not id then
        return
    end

    if CL.db.icon then
        local texture = GetSpellTexture(tonumber(id))
        local icon = texture and format(ICON_STRING, texture)
        if icon then
            link = icon .. " |cff71d5ff" .. link .. "|r" -- I dk why the color is needed, but worked!
        end
    end

    return link
end

local function AddEnchantInfo(link)
    -- enchant
    local id = strmatch(link, "Henchant:(%d-)\124")
    if not id then
        return
    end

    if CL.db.icon then
        local texture = GetSpellTexture(tonumber(id))
        local icon = texture and format(ICON_STRING, texture)
        if icon then
            link = icon .. " " .. link
        end
    end

    return link
end

local function AddPvPTalentInfo(link)
    -- PVP talent
    local id = strmatch(link, "Hpvptal:(%d-)|")
    if not id then
        return
    end

    if CL.db.icon then
        local texture = select(3, GetPvpTalentInfoByID(tonumber(id)))
        local icon = texture and format(ICON_STRING, texture)
        if icon then
            link = icon .. " " .. link
        end
    end

    return link
end

local function AddTalentInfo(link)
    -- talent
    local id = strmatch(link, "Htalent:(%d-)|")
    if not id then
        return
    end

    if CL.db.icon then
        local texture = select(3, GetTalentInfoByID(tonumber(id)))
        local icon = texture and format(ICON_STRING, texture)
        if icon then
            link = icon .. " " .. link
        end
    end

    return link
end

function CL:Filter(event, msg, ...)
    if CL.db.enable then
        msg = gsub(msg, "(|cff71d5ff|Hconduit:%d+:.-|h.-|h|r)", AddConduitIcon)
        msg = gsub(msg, "(|cffa335ee|Hkeystone:%d+:.-|h.-|h|r)", AddKeystoneIcon)
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
