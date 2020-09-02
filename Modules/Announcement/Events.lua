local W, F, E, L = unpack(select(2, ...))
local A = W:GetModule("Announcement")

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

A.EventList = {
    "CHAT_MSG_SYSTEM",
    "COMBAT_LOG_EVENT_UNFILTERED",
    "LFG_COMPLETION_REWARD",
    "CHALLENGE_MODE_COMPLETED",
    "QUEST_LOG_UPDATE"
}

-- CHAT_MSG_SYSTEM: text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons
function A:CHAT_MSG_SYSTEM(event, text)
    local data = {}

    self:ResetInstance(text) -- 重置副本
end

function A:COMBAT_LOG_EVENT_UNFILTERED()
    local combatInfo = {CombatLogGetCurrentEventInfo()}
    -- 参数列表
    -- https://wow.gamepedia.com/COMBAT_LOG_EVENT#Base_Parameters
    local timestamp = combatInfo[1]
    local event = combatInfo[2]
    local sourceGUID = combatInfo[4]
    local sourceName = combatInfo[5]
    local destGUID = combatInfo[8]
    local destName = combatInfo[9]
    local spellId = combatInfo[12]

    if event == "SPELL_CAST_SUCCESS" then
        self:ThreatTransfer(sourceGUID, sourceName, destGUID, destName, spellId)
        self:CombatResurrection(sourceGUID, sourceName, destName, spellId)
        self:Utility(event, sourceName, spellId)
        self:ThanksForResurrection(sourceGUID, sourceName, destGUID, destName, spellId)
    elseif event == "SPELL_SUMMON" then
        self:Utility(event, sourceName, spellId)
    elseif event == "SPELL_CREATE" then
        self:Utility(event, sourceName, spellId)
    elseif event == "SPELL_INTERRUPT" then
        local extraSpellId = combatInfo[15]
        self:Interrupt(sourceGUID, sourceName, destName, spellId, extraSpellId)
    elseif event == "SPELL_AURA_APPLIED" then
        self:Taunt(timestamp, event, sourceGUID, sourceName, destGUID, destName, spellId)
    elseif event == "SPELL_MISSED" then
        self:Taunt(timestamp, event, sourceGUID, sourceName, destGUID, destName, spellId)
    end
end

function A:LFG_COMPLETION_REWARD()
    self:Goodbye()
end

function A:CHALLENGE_MODE_COMPLETED()
    self:Goodbye()
end

-- TODO: SCENARIO_COMPLETED 场景完成事件

function A:QUEST_LOG_UPDATE()
    self:Quest()
end
