local W, F, E, L = unpack(select(2, ...))
local A = W:GetModule("Announcement")

local _G = _G
local gsub, strsub, strsplit = gsub, strsub, strsplit
local UnitGUID, GetSpellLink = UnitGUID, GetSpellLink
local IsInInstance, UnitInRaid, UnitInParty = IsInInstance, UnitInRaid, UnitInParty

local function GetPetOwner(petName)
    E.ScanTooltip:SetOwner(_G.UIParent, "ANCHOR_NONE")
    E.ScanTooltip:ClearLines()
    E.ScanTooltip:SetUnit(petName)
    local details = E.ScanTooltip.TextLeft2:GetText()
    print(details)
    if not details then
        return
    end

    local delimiter
    if strsub(E:GetLocale(), 0, 2) == "zh" then
        delimiter = "的"
    else
        delimiter = "'s"
    end

    local owner = strsplit(delimiter, details)

    return owner
end

function A:Interrupt(sourceGUID, sourceName, destName, spellId, extraSpellId)
    local config = self.db.interrupt

    if not config.enable then
        return
    end

    if config.onlyInstance and IsInInstance() then
        return
    end

    if not (spellId and extraSpellId) then
        return
    end

    -- 格式化自定义字符串
    local function FormatMessage(message)
        message = gsub(message, "%%player%%", sourceName)
        message = gsub(message, "%%target%%", destName)
        message = gsub(message, "%%player_spell%%", GetSpellLink(spellId))
        message = gsub(message, "%%target_spell%%", GetSpellLink(extraSpellId))
        return message
    end

    if sourceGUID == UnitGUID("player") or sourceGUID == UnitGUID("pet") then
        -- 自己及宠物打断
        if config.player.enable then
            self:SendMessage(FormatMessage(config.player.text), self:GetChannel(config.player.channel))
            print(sourceName)
            print(GetPetOwner(sourceName))
        end
    elseif config.others.enable then
        -- 他人打断
        local sourceType = strsplit("-", sourceGUID)

        if sourceType == "Pet" then
            sourceName = GetPetOwner(sourceName)
        end

        if not UnitInRaid(sourceName) or not UnitInParty(sourceName) then
            return
        end

        self:SendMessage(FormatMessage(config.others.text), self:GetChannel(config.others.channel))
    end
end
