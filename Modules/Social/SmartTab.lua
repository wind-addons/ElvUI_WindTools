local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local CB = W:GetModule("ChatBar") ---@class ChatBar
local ST = W:NewModule("SmartTab", "AceHook-3.0", "AceEvent-3.0")

local _G = _G
local ipairs = ipairs
local pairs = pairs
local strsub = strsub
local tAppendAll = tAppendAll
local time = time
local tostring = tostring
local unpack = unpack
local wipe = wipe

local Ambiguate = Ambiguate
local CopyTable = CopyTable
local IsEveryoneAssistant = IsEveryoneAssistant
local IsInGroup = IsInGroup
local IsInGuild = IsInGuild
local IsInRaid = IsInRaid
local UnitInBattleground = UnitInBattleground
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsGroupLeader = UnitIsGroupLeader

local C_GuildInfo_IsGuildOfficer = C_GuildInfo.IsGuildOfficer

local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE

local ChannelList = {
	"SAY",
	"YELL",
	"PARTY",
	"INSTANCE_CHAT",
	"RAID",
	"RAID_WARNING",
	"BATTLEGROUND",
	"GUILD",
	"OFFICER",
	"CHATBAR_WORLD",
}

local ChannelListWithWhisper = CopyTable(ChannelList)
tAppendAll(ChannelListWithWhisper, {
	"WHISPER",
	"BN_WHISPER",
})

local NumberOfChannelList = #ChannelList
local NumberOfChannelListWithWhisper = #ChannelListWithWhisper
local IndexOfChannelList = tInvert(ChannelList)
local IndexOfChannelListWithWhisper = tInvert(ChannelListWithWhisper)

local nextChatType, nextTellTarget

function ST:CheckAvailability(chatType)
	if chatType == "YELL" then
		return self.db.yell
	elseif chatType == "PARTY" then
		return IsInGroup(LE_PARTY_CATEGORY_HOME)
	elseif chatType == "INSTANCE_CHAT" then
		return IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
	elseif chatType == "RAID" then
		return IsInRaid()
	elseif chatType == "RAID_WARNING" then
		if self.db.raidWarning and IsInRaid() then
			if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant() then
				return true
			end
		end
		return false
	elseif chatType == "BATTLEGROUND" then
		return self.db.battleground and UnitInBattleground("player")
	elseif chatType == "GUILD" then
		return IsInGuild()
	elseif chatType == "OFFICER" then
		return self.db.officer and IsInGuild() and C_GuildInfo_IsGuildOfficer()
	elseif chatType == "CHATBAR_WORLD" then
		return self.db.world
	end

	return true
end

function ST:RefreshWhisperTargets()
	if not self.private.whisperTargets then
		return 0
	end

	local newTargets = {}
	local currentTime = time()
	local expirationTime = self.db.historyLimit and 60 * self.db.historyLimit or 600

	local numberOfTargets = 0

	for target, data in pairs(self.private.whisperTargets) do
		local targetTime, targetType = unpack(data)
		if (currentTime - targetTime) < expirationTime then
			newTargets[target] = { targetTime, targetType }
			numberOfTargets = numberOfTargets + 1
		end
	end

	wipe(self.private.whisperTargets)
	self.private.whisperTargets = newTargets

	return numberOfTargets
end

function ST:UpdateWhisperTargets(target, chatTime, type)
	if not self.private.whisperTargets then
		return
	end

	local name = Ambiguate(target, "none")

	self.private.whisperTargets[name] = { chatTime or time(), type }
end

function ST:GetNextWhisper(currentTarget)
	local chatType = "NONE"
	local tellTarget = nil
	local oldTime = 0
	local limit = time()
	local needSwitch = false

	if self:RefreshWhisperTargets() ~= 0 then
		if currentTarget and self.private.whisperTargets[currentTarget] then
			limit = self.private.whisperTargets[currentTarget][1]
		end

		-- Force switch when not in whisper
		if not currentTarget then
			needSwitch = true
		end

		-- Iterate through history to find an earlier historical target or initialize the channel change target
		for target, data in pairs(self.private.whisperTargets) do
			local targetTime, targetType = unpack(data)
			if (targetTime > oldTime and targetTime < limit) or needSwitch then
				tellTarget = target
				chatType = targetType
				oldTime = targetTime
				needSwitch = false
			end
		end
	end

	return chatType, tellTarget
end

function ST:GetLastWhisper()
	local tellTarget, chatType, oldTime = nil, "NONE", 0

	if self:RefreshWhisperTargets() ~= 0 then
		-- Iterate through history to find the last historical target
		for target, data in pairs(self.private.whisperTargets) do
			local targetTime, targetType = unpack(data)
			if targetTime > oldTime then
				tellTarget, chatType, oldTime = target, targetType, targetTime
			end
		end
	end

	return chatType, tellTarget
end

function ST:GetNext(chatType, currentTarget)
	local newChatType, newTarget, nextIndex

	if chatType == "CHANNEL" then
		return "SAY"
	end

	if self.db.whisperCycle then
		if chatType == "WHISPER" or chatType == "BN_WHISPER" then
			-- Whisper and Battle.net whisper limited search
			newChatType, newTarget = self:GetNextWhisper(currentTarget)
			if newChatType == "NONE" then
				-- If there is no earlier target, try to get the last one in the table
				newChatType, newTarget = self:GetLastWhisper()
				if newChatType == "NONE" then
					newChatType = chatType
					newTarget = currentTarget
					_G.UIErrorsFrame:AddMessage(L["There is no more whisper targets"], RED_FONT_COLOR:GetRGBA())
				end
			end
		else
			-- Regular channel change
			nextIndex = IndexOfChannelList[chatType] % NumberOfChannelList + 1
			while not self:CheckAvailability(ChannelList[nextIndex]) do
				nextIndex = nextIndex % NumberOfChannelList + 1
			end
			newChatType = ChannelListWithWhisper[nextIndex]
		end
	elseif chatType == "WHISPER" or chatType == "BN_WHISPER" then
		-- If currently in whisper, directly find the next whisper target
		newChatType, newTarget = self:GetNextWhisper(currentTarget)
		if newChatType == "NONE" then
			-- If the current user is already the last in the whisper cycle or there are no whisper history targets, jump to say
			newChatType = ChannelListWithWhisper[1]
		end
	else
		-- Regular channel cycle
		nextIndex = IndexOfChannelListWithWhisper[chatType] % NumberOfChannelListWithWhisper + 1
		while not self:CheckAvailability(ChannelListWithWhisper[nextIndex]) do
			nextIndex = nextIndex % NumberOfChannelListWithWhisper + 1
		end
		-- Once cycling to the whisper part, special handling is performed
		newChatType = ChannelListWithWhisper[nextIndex]
		if newChatType == "WHISPER" or newChatType == "BN_WHISPER" then
			-- Find the next whisper target
			newChatType, newTarget = self:GetNextWhisper(currentTarget)
			if newChatType == "NONE" then
				-- If the current user is already the last in the whisper cycle or there are no whisper history targets, jump to say
				newChatType = ChannelListWithWhisper[1]
			end
		end
	end

	return newChatType, newTarget
end

function ST:TabPressed(frame)
	if not self.db.enable then
		return
	end

	if strsub(tostring(frame:GetText()), 1, 1) == "/" then
		return
	end

	nextChatType, nextTellTarget = nil, nil
	nextChatType, nextTellTarget = self:GetNext(frame:GetAttribute("chatType"), frame:GetAttribute("tellTarget"))
end

function ST:SecureTabPressed(frame)
	if not self.db.enable then
		return
	end

	if nextChatType == "CHATBAR_WORLD" then
		local worldChannelID = CB:GetWorldChannelID()
		if worldChannelID > 0 then
			frame:SetAttribute("channelTarget", worldChannelID)
			nextChatType = "CHANNEL"
		else
			-- If the world channel is not available, skip to the next channel
			nextChatType, nextTellTarget = self:GetNext(nextChatType, nextTellTarget)
		end
	end

	frame:SetAttribute("chatType", nextChatType)

	if nextTellTarget then
		frame:SetAttribute("tellTarget", nextTellTarget)
	end

	_G.ACTIVE_CHAT_EDIT_BOX = frame
	_G.LAST_ACTIVE_CHAT_EDIT_BOX = frame

	frame:UpdateHeader()
end

function ST:CHAT_MSG_WHISPER(_, _, author)
	if Ambiguate(author, "none") == E.myname then
		return
	end

	self:UpdateWhisperTargets(author, nil, "WHISPER")
end

function ST:CHAT_MSG_WHISPER_INFORM(_, _, author)
	if Ambiguate(author, "none") == E.myname then
		return
	end

	self:UpdateWhisperTargets(author, nil, "WHISPER")
end

function ST:CHAT_MSG_BN_WHISPER(_, _, author)
	self:UpdateWhisperTargets(author, nil, "BN_WHISPER")
end

function ST:CHAT_MSG_BN_WHISPER_INFORM(_, _, author)
	self:UpdateWhisperTargets(author, nil, "BN_WHISPER")
end

function ST:Initialize()
	self.db = E.db.WT.social.smartTab
	self.private = E.private.WT.social.smartTab

	self:SecureHook("ChatEdit_CustomTabPressed", "TabPressed")

	for _, frameName in ipairs(_G.CHAT_FRAMES) do
		local chat = _G[frameName]
		if chat and chat.editBox then
			self:SecureHook(chat.editBox, "SecureTabPressed", "SecureTabPressed")
		end
	end

	if not self.db.enable then
		return
	end

	self:RefreshWhisperTargets()

	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
end

function ST:ProfileUpdate()
	self.db = E.db.WT.social.smartTab

	if not self.db.enable then
		self:UnregisterEvent("CHAT_MSG_WHISPER")
		self:UnregisterEvent("CHAT_MSG_WHISPER_INFORM")
		self:UnregisterEvent("CHAT_MSG_BN_WHISPER")
		self:UnregisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
		return
	end

	self:RefreshWhisperTargets()

	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
end

W:RegisterModule(ST:GetName())
