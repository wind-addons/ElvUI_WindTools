-- 原创模块

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local WT = E:GetModule("WindTools")
local TCM = E:NewModule('Wind_TabChatMod', 'AceHook-3.0', 'AceEvent-3.0');

local pairs = pairs
local tostring = tostring
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local IsInGuild = IsInGuild
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
local hooksecurefunc = hooksecurefunc
local CanEditOfficerNote = CanEditOfficerNote
local UnitIsGroupAssistant = UnitIsGroupAssistant
local IsEveryoneAssistant = IsEveryoneAssistant
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitInBattleground = UnitInBattleground
local UnitFullName = UnitFullName

-- 频道循环列表
local ChannelList = { "SAY", "YELL", "PARTY", "INSTANCE_CHAT", "RAID", "RAID_WARNING", "BATTLEGROUND", "GUILD", "OFFICER" }
local ChannelListWithWhisper = { "SAY", "YELL", "PARTY", "INSTANCE_CHAT", "RAID", "RAID_WARNING", "BATTLEGROUND", "GUILD", "OFFICER", "WHISPER", "BN_WHISPER"}

-- 缓存 Index 方便查找
local NumberOfChannelList = #ChannelList
local NumberOfChannelListWithWhisper = #ChannelListWithWhisper

local IndexOfChannelList={}
local IndexOfChannelListWithWhisper={}

for k, v in pairs(ChannelList) do IndexOfChannelList[v] = k end
for k, v in pairs(ChannelListWithWhisper) do IndexOfChannelListWithWhisper[v] = k end

function TCM:CheckAvailability(type)
	if type == "YELL" then
		return self.db.use_yell
	elseif type == "PARTY" then
		return IsInGroup(LE_PARTY_CATEGORY_HOME)
	elseif type == "INSTANCE_CHAT" then
		return IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
	elseif type == "RAID" then
		return IsInRaid()
	elseif type == "RAID_WARNING" then
		if self.db.use_raid_warning and IsInRaid() then
			if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant() then
				return true
			end
		end
		return false
	elseif type == "BATTLEGROUND" then
		return UnitInBattleground("player")
	elseif type == "GUILD" then
		return IsInGuild()
	elseif type == "OFFICER" then
		return self.db.use_officer and IsInGuild() and CanEditOfficerNote()
	end

	return true
end

function TCM:RefreshWhisperTargets()
	if not self.db.whisper_targets then return 0 end

	local newTargets = {}
	local currentTime = time()
	local expirationTime = 10*60 -- 10 分钟过期

	local numberOfTargets = 0

	for target, data in pairs(self.db.whisper_targets) do
		local targetTime, targetType = unpack(data)
		if (currentTime - targetTime) < expirationTime then
			newTargets[target] = { targetTime, targetType }
			numberOfTargets = numberOfTargets + 1
		end
	end
	
	wipe(self.db.whisper_targets)
	self.db.whisper_targets = newTargets

	return numberOfTargets
end

function TCM:UpdateWhisperTargets(target, chatTime, type)
	if not self.db.whisper_targets then return end
	local currentTime = chatTime or time()

	-- 本服玩家去除服务器名
	local name, server = strsplit("-", target)
	if (server) and (server == self.ServerName) then target = name end

	self.db.whisper_targets[target] = { currentTime, type }
end

function TCM:GetNextWhisper(currentTarget)
	local chatType = "NONE"
	local tellTarget = nil
	local oldTime = 0
	local limit = time()
	local needSwitch = false

	if self:RefreshWhisperTargets() ~= 0 then
		-- 设定一定要早于当前密语历史目标
		if currentTarget and self.db.whisper_targets[currentTarget] then
			limit = self.db.whisper_targets[currentTarget][1]
		end

		-- 当前不是密语状况下就算一个历史数据也要切换过去
		if not currentTarget then needSwitch = true end

		-- 遍历历史寻找到 早一个历史目标 或者 初始化频道变换的目标
		for target, data in pairs(self.db.whisper_targets) do
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
function TCM:GetLastWhisper()
	local chatType = "NONE"
	local tellTarget = nil
	local oldTime = 0
	local limit = time()
	local needSwitch = false

	if self:RefreshWhisperTargets() ~= 0 then
		-- 遍历历史寻找到 最后一个历史目标
		for target, data in pairs(self.db.whisper_targets) do
			local targetTime, targetType = unpack(data)
			if (targetTime > oldTime) then
				tellTarget = target
				chatType = targetType
				oldTime = targetTime
			end
		end
	end

	return chatType, tellTarget
end

function TCM:GetNext(chatType, currentTarget)
	local newChatType, newTarget, nextIndex

	if self.db.whisper_cycle then
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
					UIErrorsFrame:AddMessage(L["There is no more whisper targets"], 1, 0, 0, 53, 5);
				end
			end
		else
			-- 常规的频道变换
			nextIndex = IndexOfChannelList[chatType] % NumberOfChannelList + 1
			while(not TCM:CheckAvailability(ChannelList[nextIndex])) do
				nextIndex = nextIndex % NumberOfChannelList + 1
			end
			return ChannelListWithWhisper[nextIndex], nil
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
			while(not TCM:CheckAvailability(ChannelListWithWhisper[nextIndex])) do
				nextIndex = nextIndex % NumberOfChannelListWithWhisper + 1
			end
			-- 一旦循环到密语部分，就进行特殊处理
			newChatType = ChannelListWithWhisper[nextIndex]
			if newChatType == "WHISPER" or newChatType == "BN_WHISPER" then
				-- 查找下一个密语目标
				newChatType, newTarget = self:GetNextWhisper(tellTarget)
				if newChatType == "NONE" then
					-- 如果当前用户已经是密语循环的最后或者没有密语历史目标，跳到说
					newChatType = ChannelListWithWhisper[1]
				end
			end
		end
	end

	return newChatType, newTarget
end

function TCM:TabPressed()
	if strsub(tostring(self:GetText()), 1, 1) == "/" then return end

	local chatType = self:GetAttribute("chatType")
	local tellTarget = self:GetAttribute("tellTarget")

	local newChatType, newTellTarget = TCM:GetNext(chatType, tellTarget)

	self:SetAttribute("chatType", newChatType)

	if newTellTarget then
		self:SetAttribute("tellTarget", newTellTarget)
	end

	ChatEdit_UpdateHeader(self)
end

-- 接收密语
function TCM:CHAT_MSG_WHISPER(_, _, author)
	-- 自己别给自己发
	if author == self.PlayerName.."-"..self.ServerName then return end
	self:UpdateWhisperTargets(author, nil, "WHISPER")
end

-- 发送密语
function TCM:CHAT_MSG_WHISPER_INFORM(_, _, author)
	-- 自己别给自己发
	if author == self.PlayerName.."-"..self.ServerName then return end
	self:UpdateWhisperTargets(author, nil, "WHISPER")
end

-- 接收战网聊天
function TCM:CHAT_MSG_BN_WHISPER(_, _, author)
	self:UpdateWhisperTargets(author, nil, "BN_WHISPER")
end

-- 发送战网聊天
function TCM:CHAT_MSG_BN_WHISPER_INFORM(_, _, author)
	self:UpdateWhisperTargets(author, nil, "BN_WHISPER")
end

function TCM:Initialize()
	self.db = E.db.WindTools["Chat"]["Tab Chat Mod"]
	if not self.db.enabled then return end

	tinsert(WT.UpdateAll, function()
		TCM.db = E.db.WindTools["Chat"]["Tab Chat Mod"]
		TCM:RefreshWhisperTargets()
	end)

	-- 缓存 { 密语对象 = {时间, 方式} }
	if not self.db.whisper_targets then self.db.whisper_targets = {} end

	self.PlayerName, self.ServerName = UnitFullName("player")

	hooksecurefunc("ChatEdit_CustomTabPressed", TCM.TabPressed)

	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
end

local function InitializeCallback()
	TCM:Initialize()
end
E:RegisterModule(TCM:GetName(), InitializeCallback)