local W, F, E, L, _, _, G = unpack(select(2, ...))
local CL = W:NewModule("ChatLink", "AceEvent-3.0")

local _G = _G
local match, format, gsub = string.match, format, gsub
local pairs, unpack, tostring = pairs, unpack, tostring
local select, ceil, tonumber = select, ceil, tonumber
local GetItemInfo = GetItemInfo
local GetItemIcon = GetItemIcon
local GetSpellTexture = GetSpellTexture
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter

local ItemLevelTooltip = E.ScanTooltip
local ItemLevelPattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)")

local IconString = "|T%s:18:21:0:0:64:64:5:59:10:54"

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
    local id = match(Hyperlink, "Hitem:(%d-):")
    if (not id) then
        return
    end
    id = tonumber(id)

    -- 获取物品实际等级
    if CL.db.level or CL.db.slot then
        local text, level, extraname, slot
        local link = match(Hyperlink, "|H(.-)|h")
        ItemLevelTooltip:SetOwner(_G.UIParent, "ANCHOR_NONE")
        ItemLevelTooltip:ClearLines()
        ItemLevelTooltip:SetHyperlink(link)

        if CL.db.level then
            for i = 2, 5 do
                local leftText = _G[ItemLevelTooltip:GetName() .. "TextLeft" .. i]
                if leftText then
                    text = leftText:GetText() or ""
                    level = match(text, ItemLevelPattern)
                    if (level) then
                        break
                    end
                end
            end
        end

        -- 获取是护甲还是武器
        local type = select(6, GetItemInfo(id))
        -- 护甲类
        if type == _G.ARMOR and CL.db.armorCategory then
            local equipLoc = select(9, GetItemInfo(id))
            if equipLoc ~= "" then
                if SearchArmorType[equipLoc] then
                    -- 如果有护甲分类的
                    local armorType = select(7, GetItemInfo(id))
                    if G.general.locale == "zhTW" or G.general.locale == "zhCN" then
                        slot = armorType .. (abbrList[equipLoc] or _G[equipLoc])
                    else
                        slot = armorType .. " " .. (abbrList[equipLoc] or _G[equipLoc])
                    end
                else
                    slot = abbrList[equipLoc] or _G[equipLoc]
                end
            end
        end

        -- 武器类
        if type == _G.WEAPON and CL.db.weaponCategory then
            local equipLoc = select(9, GetItemInfo(id))
            if equipLoc ~= "" then
                local weaponType = select(7, GetItemInfo(id))
                slot = weaponType or abbrList[equipLoc] or _G[equipLoc]
            end
        end

        if (level and extraname) then
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. level .. ":%1:" .. extraname .. "]|h")
        elseif (level and slot) then
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. level .. "-" .. slot .. ":%1]|h")
        elseif (level) then
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. level .. ":%1]|h")
        elseif (slot) then
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. slot .. ":%1]|h")
        end
    end

    -- 腐化信息
    -- if CL.db.link.add_corruption_rank then
    --     local corruptionInfo = E:GetModule("Wind_CorruptionRank"):Corruption_Search(Hyperlink)

    --     if corruptionInfo then
    --         local spellName = GetSpellInfo(corruptionInfo.spellID)
    --         local levelText = corruptionInfo.level
    --         levelText = levelText:gsub("%s?%(.-%)", "")
    --         if levelText ~= "" then
    --             -- 阿拉伯数字貌似好看点？
    --             spellName = spellName .. string.len(levelText)
    --         end
    --         Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[%1/" .. spellName .. "]|h")
    --     end
    -- end

    if CL.db.icon then
        local texture = GetItemIcon(id)
        local icon = format(IconString .. ":255:255:255|t", texture)
        Hyperlink = icon .. " " .. Hyperlink
    end

    return Hyperlink
end

local function AddSpellInfo(Hyperlink)
    -- 法术图标
    local id = match(Hyperlink, "Hspell:(%d-):")
    if (not id) then
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
    -- PVP 天赋
    local id = match(Hyperlink, "Hpvptal:(%d-)|")
    if (not id) then
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
    -- 天赋
    local id = match(Hyperlink, "Htalent:(%d-)|")
    if (not id) then
        return
    end

    if CL.db.icon then
        local texture = select(3, GetTalentInfoByID(tonumber(id)))
        local icon = format(IconString .. ":255:255:255|t", texture)
        Hyperlink = icon .. " " .. Hyperlink
    end

    return Hyperlink
end

function CL:Initialize()
    self.db = E.db.WT.social.chatLink

    local function filter(self, event, msg, ...)
        -- print(msg:gsub("\124", "\124\124"))
        msg = msg:gsub("(|Hitem:%d+:.-|h.-|h)", AddItemInfo)
        msg = msg:gsub("(|Hspell:%d+:%d+|h.-|h)", AddSpellInfo)
        msg = msg:gsub("(|Htalent:%d+|h.-|h)", AddTalentInfo)
        msg = msg:gsub("(|Hpvptal:%d+|h.-|h)", AddPvPTalentInfo)
        return false, msg, ...
    end

    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", filter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", filter)

    self.initialized = true
end

function CL:ProfileUpdate()
    self.db = E.db.WT.social.chatLink

    if self.db.enable and not self.initialized then
        self:Initialize()
    end
end

W:RegisterModule(CL:GetName())
