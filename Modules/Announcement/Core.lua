local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local A = W:NewModule("Announcement", "AceEvent-3.0") ---@class Announcement : AceModule, AceEvent-3.0
local ChatThrottleLib = _G.ChatThrottleLib

local _G = _G

local format = format
local pairs = pairs
local time = time

local IsEveryoneAssistant = IsEveryoneAssistant
local IsInGroup = IsInGroup
local IsInInstance = IsInInstance
local IsInRaid = IsInRaid
local IsPartyLFG = IsPartyLFG
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsGroupLeader = UnitIsGroupLeader

local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME

A.history = {}

function A:CheckBeforeSend(text, channel)
	if not self.db.sameMessageInterval or self.db.sameMessageInterval == 0 then
		return true
	end

	local key = text .. "_@@@_" .. channel

	if self.history[key] and time() < self.history[key] + self.db.sameMessageInterval then
		return false
	end

	self.history[key] = time()
	return true
end

---Send Message
---@param text string The text you want to send to others
---@param channel any The channel in Blizzard codes format
---@param raidWarning any Let the function send raid warning if possible
---@param whisperTarget any The target if the channel is whisper
function A:SendMessage(text, channel, raidWarning, whisperTarget)
	-- Skip if the channel is NONE
	if channel == "NONE" then
		return
	end

	-- Change channel if it is protected by Blizzard
	if channel == "YELL" or channel == "SAY" then
		if not IsInInstance() then
			channel = "SELF"
		end
	end

	if channel == "SELF" then
		_G.DEFAULT_CHAT_FRAME:AddMessage(text)
		return
	end

	if channel == "WHISPER" then
		if whisperTarget then
			ChatThrottleLib:SendChatMessage("NORMAL", "WT", text, channel, nil, whisperTarget)
		end
		return
	end

	if channel == "EMOTE" then
		if self.db and self.db.emoteFormat then
			text = format(self.db.emoteFormat, text)
		else
			text = ": " .. text
		end
	end

	if channel == "RAID" and raidWarning and IsInRaid(LE_PARTY_CATEGORY_HOME) then
		if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant() then
			channel = "RAID_WARNING"
		end
	end

	if self:CheckBeforeSend(text, channel) then
		ChatThrottleLib:SendChatMessage("NORMAL", "WT", text, channel)
	end
end

---Fetch the most suitable channel configuration
---@param channelDB table Channel configuration table
---@return string
function A:GetChannel(channelDB)
	if
		(IsPartyLFG() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE))
		and channelDB.instance
	then
		return channelDB.instance
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) and channelDB.raid then
		return channelDB.raid
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) and channelDB.party then
		return channelDB.party
	elseif channelDB.solo and channelDB.solo then
		return channelDB.solo
	end
	return "NONE"
end

function A:Initialize()
	self.db = E.db.WT.announcement

	if not self.db.enable or self.initialized then
		return
	end

	if self.db.interrupt.enable and E.db.general.interruptAnnounce ~= "NONE" then
		E.db.general.interruptAnnounce = "NONE"
	end

	for _, event in pairs(self.EventList) do
		A:RegisterEvent(event)
	end

	for _, message in pairs(self.MessageList) do
		A:RegisterMessage(message)
	end

	self.initialized = true
end

function A:ProfileUpdate()
	self:Initialize()

	if self.db.interrupt.enable and E.db.general.interruptAnnounce ~= "NONE" then
		E.db.general.interruptAnnounce = "NONE"
	end

	if self.db.enable or not self.initialized then
		return
	end

	-- If the module is disabled from profile, unregister all events and reset authority
	for _, event in pairs(self.EventList) do
		A:UnregisterEvent(event)
	end

	for _, message in pairs(self.MessageList) do
		A:UnregisterMessage(message)
	end

	self.initialized = false
end

W:RegisterModule(A:GetName())
