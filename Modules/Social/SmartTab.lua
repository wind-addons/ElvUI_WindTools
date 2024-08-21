local W, F, E, L = unpack((select(2, ...)))
local ST = W:NewModule("SmartTab", "AceHook-3.0", "AceEvent-3.0")

local _G = _G
local pairs = pairs
local strsplit = strsplit
local strsub = strsub
local time = time
local tostring = tostring
local unpack = unpack
local wipe = wipe

local IsEveryoneAssistant = IsEveryoneAssistant
local IsInGroup = IsInGroup
local IsInGuild = IsInGuild
local IsInRaid = IsInRaid
local UnitInBattleground = UnitInBattleground
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsGroupLeader = UnitIsGroupLeader

local C_GuildInfo_IsGuildOfficer = C_GuildInfo.IsGuildOfficer

local ACTIVE_CHAT_EDIT_BOX = ACTIVE_CHAT_EDIT_BOX
local LAST_ACTIVE_CHAT_EDIT_BOX = LAST_ACTIVE_CHAT_EDIT_BOX
local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE

-- 频道循环列表
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
}

local ChannelListWithWhisper = {
	"SAY",
	"YELL",
	"PARTY",
	"INSTANCE_CHAT",
	"RAID",
	"RAID_WARNING",
	"BATTLEGROUND",
	"GUILD",
	"OFFICER",
	"WHISPER",
	"BN_WHISPER",
}

-- 缓存 Index 方便查找
local NumberOfChannelList = #ChannelList
local NumberOfChannelListWithWhisper = #ChannelListWithWhisper

local IndexOfChannelList = {}
local IndexOfChannelListWithWhisper = {}

for k, v in pairs(ChannelList) do
	IndexOfChannelList[v] = k
end
for k, v in pairs(ChannelListWithWhisper) do
	IndexOfChannelListWithWhisper[v] = k
end

-- 用于锁定对象
local nextChatType
local nextTellTarget

function ST:CheckAvailability(type)
	if type == "YELL" then
		return self.db.yell
	elseif type == "PARTY" then
		return IsInGroup(LE_PARTY_CATEGORY_HOME)
	elseif type == "INSTANCE_CHAT" then
		return IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
	elseif type == "RAID" then
		return IsInRaid()
	elseif type == "RAID_WARNING" then
		if self.db.raidWarning and IsInRaid() then
			if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant() then
				return true
			end
		end
		return false
	elseif type == "BATTLEGROUND" then
		return self.db.battleground and UnitInBattleground("player")
	elseif type == "GUILD" then
		return IsInGuild()
	elseif type == "OFFICER" then
		return self.db.officer and IsInGuild() and C_GuildInfo_IsGuildOfficer()
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
	local currentTime = chatTime or time()

	-- 本服玩家去除服务器名
	local name, server = strsplit("-", target)
	if server and (server == E.myrealm) then
		target = name
	end

	self.private.whisperTargets[target] = { currentTime, type }
end

function ST:GetNextWhisper(currentTarget)
	local chatType = "NONE"
	local tellTarget = nil
	local oldTime = 0
	local limit = time()
	local needSwitch = false

	if self:RefreshWhisperTargets() ~= 0 then
		-- 设定一定要早于当前密语历史目标
		if currentTarget and self.private.whisperTargets[currentTarget] then
			limit = self.private.whisperTargets[currentTarget][1]
		end

		-- 当前不是密语状况下就算一个历史数据也要切换过去
		if not currentTarget then
			needSwitch = true
		end

		-- 遍历历史寻找到 早一个历史目标 或者 初始化频道变换的目标
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

-- 仅用来密语独立循环使用
function ST:GetLastWhisper()
	local chatType = "NONE"
	local tellTarget = nil
	local oldTime = 0
	local limit = time()
	local needSwitch = false

	if self:RefreshWhisperTargets() ~= 0 then
		-- 遍历历史寻找到 最后一个历史目标
		for target, data in pairs(self.private.whisperTargets) do
			local targetTime, targetType = unpack(data)
			if targetTime > oldTime then
				tellTarget = target
				chatType = targetType
				oldTime = targetTime
			end
		end
	end

	return chatType, tellTarget
end

function ST:GetNext(chatType, currentTarget)
	local newChatType, newTarget, nextIndex

	if chatType == "CHANNEL" then
		chatType = "SAY"
	end

	if self.db.whisperCycle then
		if chatType == "WHISPER" or chatType == "BN_WHISPER" then
			-- 密语+战网聊天限定进行寻找
			newChatType, newTarget = self:GetNextWhisper(currentTarget)
			if newChatType == "NONE" then
				-- 如果没有更早的目标，就尝试获取表内最后一个
				newChatType, newTarget = self:GetLastWhisper()
				if newChatType == "NONE" then
					-- 如果表内为空，则什么都不改变
					newChatType = chatType
					newTarget = currentTarget
					_G.UIErrorsFrame:AddMessage(L["There is no more whisper targets"], 1, 0, 0)
				end
			end
		else
			-- 常规的频道变换
			nextIndex = IndexOfChannelList[chatType] % NumberOfChannelList + 1
			while not ST:CheckAvailability(ChannelList[nextIndex]) do
				nextIndex = nextIndex % NumberOfChannelList + 1
			end
			newChatType = ChannelListWithWhisper[nextIndex]
		end
	else
		if chatType == "WHISPER" or chatType == "BN_WHISPER" then
			-- 如果当前就在密语状况中，直接查找下一个密语目标
			newChatType, newTarget = self:GetNextWhisper(currentTarget)
			if newChatType == "NONE" then
				-- 如果当前用户已经是密语循环的最后或者没有密语历史目标，跳到说
				newChatType = ChannelListWithWhisper[1]
			end
		else
			-- 正常的一个频道循环
			nextIndex = IndexOfChannelListWithWhisper[chatType] % NumberOfChannelListWithWhisper + 1
			while not ST:CheckAvailability(ChannelListWithWhisper[nextIndex]) do
				nextIndex = nextIndex % NumberOfChannelListWithWhisper + 1
			end
			-- 一旦循环到密语部分，就进行特殊处理
			newChatType = ChannelListWithWhisper[nextIndex]
			if newChatType == "WHISPER" or newChatType == "BN_WHISPER" then
				-- 查找下一个密语目标
				newChatType, newTarget = self:GetNextWhisper(currentTarget)
				if newChatType == "NONE" then
					-- 如果当前用户已经是密语循环的最后或者没有密语历史目标，跳到说
					newChatType = ChannelListWithWhisper[1]
				end
			end
		end
	end

	return newChatType, newTarget
end

function ST:TabPressed(frame)
	if not ST.db.enable then
		return
	end
	if strsub(tostring(frame:GetText()), 1, 1) == "/" then
		return
	end

	nextChatType, nextTellTarget = nil, nil
	nextChatType, nextTellTarget = ST:GetNext(frame:GetAttribute("chatType"), frame:GetAttribute("tellTarget"))
end

function ST:SetNewChat(frame)
	if not ST.db.enable then
		return
	end

	frame:SetAttribute("chatType", nextChatType)

	if nextTellTarget then
		frame:SetAttribute("tellTarget", nextTellTarget)
	end

	ACTIVE_CHAT_EDIT_BOX = frame
	LAST_ACTIVE_CHAT_EDIT_BOX = frame

	_G.ChatEdit_UpdateHeader(frame)
end

-- 接收密语
function ST:CHAT_MSG_WHISPER(_, _, author)
	-- 自己别给自己发
	if author == E.myname .. "-" .. E.myrealm then
		return
	end
	self:UpdateWhisperTargets(author, nil, "WHISPER")
end

-- 发送密语
function ST:CHAT_MSG_WHISPER_INFORM(_, _, author)
	-- 自己别给自己发
	if author == E.myname .. "-" .. E.myrealm then
		return
	end
	self:UpdateWhisperTargets(author, nil, "WHISPER")
end

-- 接收战网聊天
function ST:CHAT_MSG_BN_WHISPER(_, _, author)
	self:UpdateWhisperTargets(author, nil, "BN_WHISPER")
end

-- 发送战网聊天
function ST:CHAT_MSG_BN_WHISPER_INFORM(_, _, author)
	self:UpdateWhisperTargets(author, nil, "BN_WHISPER")
end

function ST:Initialize()
	self.db = E.db.WT.social.smartTab
	self.private = E.private.WT.social.smartTab

	-- 缓存 { 密语对象 = {时间, 方式} }

	self:SecureHook("ChatEdit_CustomTabPressed", "TabPressed")
	self:SecureHook("ChatEdit_SecureTabPressed", "SetNewChat")

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
