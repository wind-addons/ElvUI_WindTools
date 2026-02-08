local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local A = W:GetModule("Announcement") ---@class Announcement

local IsInGroup = IsInGroup
local RunNextFrame = RunNextFrame
local UnitName = UnitName

local C_RestrictedActions_IsAddOnRestrictionActive = C_RestrictedActions.IsAddOnRestrictionActive

local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
local Enum_AddOnRestrictionType_ChallengeMode = Enum.AddOnRestrictionType.ChallengeMode

A.EventList = {
	"CHALLENGE_MODE_COMPLETED",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_SYSTEM",
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
	E:Delay(1, function()
		-- Only say goodbye when in a LFG group
		if questID and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and UnitName("party1") then
			self:Goodbye()
		end
	end)
end

function A:LFG_COMPLETION_REWARD()
	E:Delay(1, self.Goodbye, self)
end

function A:CHALLENGE_MODE_COMPLETED()
	E:Delay(1, self.Goodbye, self)
end

function A:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellID)
	if C_RestrictedActions_IsAddOnRestrictionActive(Enum_AddOnRestrictionType_ChallengeMode) then
		return
	end

	if E:IsSecretValue(spellID) or not spellID then
		return
	end

	self:Utility(spellID)
end

function A:PARTY_LEADER_CHANGED(event)
	self:ResetInstanceUpdateIgnoreState(event)
end

function A:WINDTOOLS_PLAYER_KEYSTONE_CHANGED(_, ...)
	self:Keystone(...)
end

function A:PLAYER_ENTERING_WORLD()
	self:GetAvailableUtilitySpells()
end
