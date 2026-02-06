local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local A = W:GetModule("Announcement") ---@class Announcement

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local IsInGroup = IsInGroup
local RunNextFrame = RunNextFrame
local UnitName = UnitName

local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE

A.EventList = {
	"CHALLENGE_MODE_COMPLETED",
	"CHAT_MSG_ADDON",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_SYSTEM",
	"GROUP_ROSTER_UPDATE",
	"LFG_COMPLETION_REWARD",
	"PARTY_LEADER_CHANGED",
	"PLAYER_ENTERING_WORLD",
	"SCENARIO_COMPLETED",
	"UNIT_SPELLCAST_SUCCEEDED",
}

A.MessageList = {
	"WINDTOOLS_PLAYER_KEYSTONE_CHANGED",
}

-- CHAT_MSG_SYSTEM: text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons
function A:CHAT_MSG_SYSTEM(event, text)
	self:ResetInstanceUpdateIgnoreState(event, text)
	RunNextFrame(function()
		self:ResetInstance(text)
	end)
end

function A:CHAT_MSG_PARTY(event, ...)
	self:KeystoneLink(event, ...)
end

function A:CHAT_MSG_PARTY_LEADER(event, ...)
	self:KeystoneLink(event, ...)
end

function A:CHAT_MSG_GUILD(event, ...)
	self:KeystoneLink(event, ...)
end

function A:SCENARIO_COMPLETED(_, questID)
	-- Only say goodbye when in a LFG group
	if questID and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and UnitName("party1") then
		self:Goodbye()
	end
end

function A:LFG_COMPLETION_REWARD()
	self:Goodbye()
end

function A:PLAYER_ENTERING_WORLD()
	E:Delay(4, self.ResetAuthority, self)
	E:Delay(10, self.ResetAuthority, self)
end

function A:CHALLENGE_MODE_COMPLETED()
	self:Goodbye()
end

function A:CHAT_MSG_ADDON(_, prefix, text)
	if prefix == self.prefix then
		self:ReceiveLevel(text)
	end
end

function A:GROUP_ROSTER_UPDATE()
	self:ResetAuthority()
end

function A:UNIT_SPELLCAST_SUCCEEDED(event, unitTarget, _, spellId)
	-- TODO: check the new event returns
	if spellId and E:IsSecretValue(spellId) then
		return
	end

	self:Utility(event, UnitName(unitTarget), spellId)
end

function A:PARTY_LEADER_CHANGED(event)
	self:ResetInstanceUpdateIgnoreState(event)
end

function A:WINDTOOLS_PLAYER_KEYSTONE_CHANGED(_, ...)
	self:Keystone(...)
end
