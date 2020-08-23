local W, F, E, L = unpack(select(2, ...))
local A = W:GetModule("Announcement")
local strsplit, gsub = strsplit, gsub
local GetSpellLink = GetSpellLink

local MonkProvokeAllCache = {}

local TauntSpellList = {
    [355] = true, -- 嘲諷（戰士）
    [56222] = true, -- 黑暗赦令（死亡騎士）
    [6795] = true, -- 低吼（德魯伊 熊形態）
    [62124] = true, -- 清算之手（聖騎士）
    [116189] = true, -- 嘲心嘯（武僧）
    [118635] = true, -- 嘲心嘯（武僧圖騰 玄牛雕像 算作玩家群嘲）
    [196727] = true, -- 嘲心嘯（武僧守護者 玄牛怒兆）
    [281854] = true, -- 折磨（惡魔獵人 災虐）
    [185245] = true, -- 折磨（惡魔獵人 復仇）
    [2649] = true, -- 低吼（獵人寵物）
    [17735] = true -- 受難（術士寵物虛無行者）
}

function A:Taunt(timestamp, event, sourceGUID, sourceName, destGUID, destName, spellId)
    local config = self.db.taunt
    if not config or not config.enable then
        return
    end

    if not spellId or not sourceGUID or not destGUID or not TauntSpellList[spellId] then
        return
    end

    local sourceType = strsplit("-", sourceGUID)
    local petOwner, petRole

    -- 格式化自定义字符串
    local function FormatMessageWithPet(message)
        petOwner = petOwner:gsub("%-[^|]+", "")
        destName = destName:gsub("%-[^|]+", "")
        sourceName = sourceName:gsub("%-[^|]+", "")
        message = gsub(message, "%%player%%", petOwner)
        message = gsub(message, "%%target%%", destName)
        message = gsub(message, "%%spell%%", GetSpellLink(spellId))
        message = gsub(message, "%%pet%%", sourceName)
        message = gsub(message, "%%pet_role%%", petRole)
        return message
    end

    local function FormatMessageWithoutPet(message)
        destName = destName:gsub("%-[^|]+", "")
        sourceName = sourceName:gsub("%-[^|]+", "")
        message = gsub(message, "%%player%%", sourceName)
        message = gsub(message, "%%target%%", destName)
        message = gsub(message, "%%spell%%", GetSpellLink(spellId))
        return message
    end

    if event == "SPELL_AURA_APPLIED" then
        -- 嘲讽成功
        if sourceType == "Player" then
            if sourceName == W.PlayerName then
                if config.player.player.enable then
                    if spellId == 118635 then
                        -- 武僧群嘲防刷屏
                        if not MonkProvokeAllCache[sourceGUID] or timestamp - MonkProvokeAllCache[sourceGUID] > 1 then
                            MonkProvokeAllCache[sourceGUID] = timestamp
                            self:SendMessage(
                                FormatMessageWithoutPet(config.player.player.provokeAllText),
                                self:GetChannel(config.player.player.channel)
                            )
                        end
                    else
                        self:SendMessage(
                            FormatMessageWithoutPet(config.player.player.successText),
                            self:GetChannel(config.player.player.channel)
                        )
                    end
                end
            elseif config.others.player.enable then
                if spellId == 118635 then
                    -- 武僧群嘲防刷屏
                    if not MonkProvokeAllCache[sourceGUID] or timestamp - MonkProvokeAllCache[sourceGUID] > 1 then
                        MonkProvokeAllCache[sourceGUID] = timestamp
                        self:SendMessage(
                            FormatMessageWithoutPet(config.others.player.provokeAllText),
                            self:GetChannel(config.others.player.channel)
                        )
                    end
                else
                    self:SendMessage(
                        FormatMessageWithoutPet(config.others.player.successText),
                        self:GetChannel(config.others.player.channel)
                    )
                end
            end
        elseif sourceType == "Pet" or sourceType == "Creature" then
            petOwner, petRole = self:GetPetInfo(sourceName)
            if petOwner == W.PlayerName then
                if config.player.pet.enable then
                    self:SendMessage(
                        FormatMessageWithPet(config.player.pet.successText),
                        self:GetChannel(config.player.pet.channel)
                    )
                end
            elseif config.others.pet.enable then
                self:SendMessage(
                    FormatMessageWithPet(config.others.pet.successText),
                    self:GetChannel(config.others.pet.channel)
                )
            end
        end
    elseif event == "SPELL_MISSED" then
        -- 嘲讽失败
        if sourceType == "Player" then
            if sourceName == W.PlayerName then
                if config.player.player.enable then
                    self:SendMessage(
                        FormatMessageWithoutPet(config.player.player.failedText),
                        self:GetChannel(config.player.player.channel)
                    )
                end
            elseif config.others.player.enable then
                self:SendMessage(
                    FormatMessageWithoutPet(config.others.player.failedText),
                    self:GetChannel(config.others.player.channel)
                )
            end
        elseif sourceType == "Pet" or sourceType == "Creature" then
            petOwner, petRole = self:GetPetInfo(sourceName)
            if petOwner == W.PlayerName then
                if config.player.pet.enable then
                    self:SendMessage(
                        FormatMessageWithPet(config.player.pet.failedText),
                        self:GetChannel(config.player.pet.channel)
                    )
                end
            elseif config.others.pet.enable then
                self:SendMessage(
                    FormatMessageWithPet(config.others.pet.failedText),
                    self:GetChannel(config.others.pet.channel)
                )
            end
        end
    end
end
