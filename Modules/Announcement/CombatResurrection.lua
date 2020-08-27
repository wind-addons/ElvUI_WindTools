local W, F, E, L = unpack(select(2, ...))
local A = W:GetModule("Announcement")

local gsub = gsub
local UnitGroupRolesAssigned = UnitGroupRolesAssigned

local CombatResurrectionList = {
    [61999] = true, -- 盟友復生
    [20484] = true, -- 復生
    [20707] = true, -- 靈魂石
    [265116] = true -- 不穩定的時間轉移器（工程學）
}

-- 格式化自定义字符串
local function FormatMessage(message, sourceName, destName, spellId)
    destName = destName:gsub("%-[^|]+", "")
    sourceName = sourceName:gsub("%-[^|]+", "")
    message = gsub(message, "%%player%%", sourceName)
    message = gsub(message, "%%target%%", destName)
    message = gsub(message, "%%spell%%", GetSpellLink(spellId))
    return message
end

function A:CombatResurrection(sourceGUID, sourceName, destName, spellId)
    local config = self.db.combatResurrection
    if not config or not config.enable or not sourceName or not destName then
        return
    end

    if CombatResurrectionList[spellId] then
        local needAnnounce = true

        if config.onlySourceIsPlayer and sourceGUID ~= W.PlayerGUID then
            needAnnounce = false
        end

        if needAnnounce then
            self:SendMessage(
                FormatMessage(config.text, sourceName, destName, spellId),
                self:GetChannel(config.channel),
                config.raidWarning
            )
        end
    end
end
