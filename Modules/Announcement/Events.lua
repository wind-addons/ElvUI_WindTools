local W, F, E, L = unpack(select(2, ...))
local A = W:GetModule("Announcement")

A.EventList = {
    "CHAT_MSG_SYSTEM",
    "COMBAT_LOG_EVENT_UNFILTERED"
}

-- CHAT_MSG_SYSTEM: text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons
function A:CHAT_MSG_SYSTEM(event, text)
    local data = {}
    data.text = text

    self:ResetInstance(data) -- 重置副本
end

function A:COMBAT_LOG_EVENT_UNFILTERED()
    -- 参数列表
    -- https://wow.gamepedia.com/COMBAT_LOG_EVENT#Base_Parameters
    local combatInfo = {CombatLogGetCurrentEventInfo()}
    local timestamp = combatInfo[1]
    local event = combatInfo[2]
    local sourceGUID = combatInfo[4]
    local sourceName = combatInfo[5]
    local destGUID = combatInfo[8]
    local destName = combatInfo[9]
    local spellId = combatInfo[12]

    if event == "SPELL_CAST_SUCCESS" then
        self:ThanksForResurrection(sourceGUID, sourceName, destGUID, destName, spellId)
        -- if self:Combat(CombatLogGetCurrentEventInfo()) then return end
        -- self:Utility(CombatLogGetCurrentEventInfo())
    elseif event == "SPELL_SUMMON" then
        -- self:Utility(CombatLogGetCurrentEventInfo())
    elseif event == "SPELL_CREATE" then
        -- self:Utility(CombatLogGetCurrentEventInfo())
    elseif event == "SPELL_INTERRUPT" then
        local extraSpellId = combatInfo[15]
        self:Interrupt(sourceGUID, sourceName, destName, spellId, extraSpellId)
    elseif event == "SPELL_AURA_APPLIED" then
        self:Taunt(timestamp, event, sourceGUID, sourceName, destGUID, destName, spellId)
    elseif event == "SPELL_MISSED" then
        self:Taunt(timestamp, event, sourceGUID, sourceName, destGUID, destName, spellId)
    end
end
