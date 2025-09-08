local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local A = W:NewModule("Announcement", "AceEvent-3.0") ---@class Announcement : AceModule, AceEvent-3.0

local _G = _G

local format = format
local pairs = pairs
local time = time

local IsEveryoneAssistant = IsEveryoneAssistant
local IsInGroup = IsInGroup
local IsInInstance = IsInInstance
local IsInRaid = IsInRaid
local IsPartyLFG = IsPartyLFG
local C_ChatInfo_SendChatMessage = C_ChatInfo.SendChatMessage
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid

local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME

A.history = {}

function A:AddHistory(text, channel)
	if not self.db.sameMessageInterval or self.db.sameMessageInterval == 0 then
		return
	end

	self.history[text .. "_@@@_" .. channel] = time()
end

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

--[[
    Send Message
    @param {string} text The text you want to send to others
    @param {string} channel the channel in Blizzard codes format
    @param {boolean} raidWarning Let the function send raid warning if possible
    @param {string} whisperTarget The target if the channel is whisper
]]
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
		_G.ChatFrame1:AddMessage(text)
		return
	end

	if channel == "WHISPER" then
		if whisperTarget then
			C_ChatInfo_SendChatMessage(text, channel, nil, whisperTarget)
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
		C_ChatInfo_SendChatMessage(text, channel)
	end
end

--[[
    获取最适合的频道配置
    @param {object} channelDB 频道配置
    @return {string} 频道
]]
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

do
	local delimiterList = {
		["zhCN"] = "的",
		["zhTW"] = "的",
		["enUS"] = "'s",
		["koKR"] = "의",
	}

	function A:GetPetInfo(petName)
		E.ScanTooltip:SetOwner(_G.UIParent, "ANCHOR_NONE")
		E.ScanTooltip:ClearLines()
		E.ScanTooltip:SetUnit(petName)
		local details = E.ScanTooltip.TextLeft2:GetText()

		if not details then
			return
		end

		local delimiter = delimiterList[W.Locale] or "'s"
		local raw = { F.Strings.Split(details, delimiter) }

		local owner, role = raw[1], raw[#raw]
		if owner and role then
			return owner, role
		end

		return nil, nil
	end
end

function A:IsGroupMember(name)
	if name then
		if UnitInParty(name) then
			return 1
		elseif UnitInRaid(name) then
			return 2
		elseif name == E.myname then
			return 3
		end
	end

	return false
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

	self:InitializeAuthority()
	self:ResetAuthority()
	self:UpdateBlizzardQuestAnnouncement()

	self.initialized = true
end

function A:ProfileUpdate()
	self:Initialize()
	self:UpdateBlizzardQuestAnnouncement()

	if self.db.interrupt.enable and E.db.general.interruptAnnounce ~= "NONE" then
		E.db.general.interruptAnnounce = "NONE"
	end

	if self.db.enable or not self.initialized then
		return
	end

	-- 禁用模块后反注册事件
	for _, event in pairs(self.EventList) do
		A:UnregisterEvent(event)
	end

	self:ResetAuthority()
	self.initialized = false
end

W:RegisterModule(A:GetName())
