local W, F, E, L = unpack(select(2, ...))
local A = W:GetModule("Announcement")

-- CHAT_MSG_SYSTEM: text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons
function A:CHAT_MSG_SYSTEM(event, text)
    local data = {}
    data.text = text

    self:TransferEventInfo(event, data)
end
