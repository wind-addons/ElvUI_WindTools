-- 原作：(无名代码片段)
-- 原作者：heng9999（http://nga.178.com/read.php?tid=5522598&page=1#pid95992230Anchor）
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 添加自定义功能开关

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local WT = E:GetModule("WindTools")
local TabChatMod = E:NewModule('Wind_TabChatMod', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

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

-- 频道循环列表
local ChannelList = { "SAY", "YELL", "PARTY", "INSTANCE_CHAT", "RAID", "RAID_WARNING", "BATTLEGROUND", "GUILD", "OFFICER" }

-- 缓存 Index 方便查找
local IndexOfChannel={}
for k, v in pairs(ChannelList) do
	IndexOfChannel[v] = k
end
local NumberOfChennels = #ChannelList

-- 检查是否可用
function TabChatMod:CheckChannel(channelName)
	if channelName == "YELL" then
		return self.db.use_yell
	elseif channelName == "PARTY" then
		return IsInGroup(LE_PARTY_CATEGORY_HOME)
	elseif channelName == "INSTANCE_CHAT" then
		return IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
	elseif channelName == "RAID" then
		return IsInRaid()
	elseif channelName == "RAID_WARNING" then
		if self.db.use_raid_warning and IsInRaid() then
			if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant() then
				return true
			end
		end
		return false
	elseif channelName == "BATTLEGROUND" then
		return UnitInBattleground("player")
	elseif channelName == "GUILD" then
		return IsInGuild()
	elseif channelName == "OFFICER" then
		return self.db.use_officer and IsInGuild() and CanEditOfficerNote()
	end

	return true
end

function TabChatMod:GetNextChannel(currentIndex)
	-- 密语是否加入循环
	if not currentIndex then
		if not self.db.whisper_cycle then currentIndex = 0 else return end
	end

	-- 循环中去找下个可用的频道
	currentIndex = currentIndex % NumberOfChennels + 1
	while(not TabChatMod:CheckChannel(ChannelList[currentIndex])) do
		currentIndex = currentIndex % NumberOfChennels + 1
	end

	return ChannelList[currentIndex]
end

function TabChatMod:TabPressed()
	if strsub(tostring(self:GetText()), 1, 1) == "/" then return end
	local currentIndex = IndexOfChannel[self:GetAttribute("chatType")]
	self:SetAttribute("chatType", TabChatMod:GetNextChannel(currentIndex))
	ChatEdit_UpdateHeader(self)
end

function TabChatMod:Initialize()
	self.db = E.db.WindTools["Chat"]["Tab Chat Mod"]
	if not self.db.enabled then return end

	tinsert(WT.UpdateAll, function()
		TabChatMod.db = E.db.WindTools["Chat"]["Tab Chat Mod"]
	end)

	hooksecurefunc("ChatEdit_CustomTabPressed", TabChatMod.TabPressed)
end

local function InitializeCallback()
	TabChatMod:Initialize()
end
E:RegisterModule(TabChatMod:GetName(), InitializeCallback)