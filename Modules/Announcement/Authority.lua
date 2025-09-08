local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local A = W:GetModule("Announcement") ---@class Announcement

local assert = assert
local format = format
local strmatch = strmatch
local strsplit = strsplit
local tonumber = tonumber

local IsInGroup = IsInGroup
local IsInRaid = IsInRaid

local C_ChatInfo_RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix
local C_ChatInfo_SendAddonMessage = C_ChatInfo.SendAddonMessage

local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE

-- 前缀
A.prefix = "WT_AS"

-- 基础信息
local myServerID, myPlayerUID

-- 频道分级, 优先高级别的玩家
local channelLevel = {
	EMOTE = 1,
	SAY = 2,
	YELL = 3,
	PARTY = 4,
	INSTANCE_CHAT = 5,
	RAID = 6,
	RAID_WARNING = 7,
}

-- 缓存最高权限
local cache = {}

local function GetBestChannel()
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
		return "RAID"
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return "PARTY"
	end
end

function A:InitializeAuthority()
	local successfulRequest = C_ChatInfo_RegisterAddonMessagePrefix(self.prefix)
	assert(successfulRequest, L["The addon message prefix registration is failed."])

	local guidSplitted = { strsplit("-", E.myguid) }
	myServerID = tonumber(guidSplitted[2], 10)
	myPlayerUID = tonumber(guidSplitted[3], 16)
end

function A:CheckAuthority(key)
	if IsInGroup() and cache[key] then
		if cache[key].playerUID ~= myPlayerUID or cache[key].serverID ~= myServerID then
			return false
		end
	end

	return true
end

function A:SendMyLevel(key, value)
	if not IsInGroup() or not key or not value then
		return
	end

	local message = format("%s=%s;%d;%d", key, value, myServerID, myPlayerUID)
	C_ChatInfo_SendAddonMessage(self.prefix, message, GetBestChannel())
end

function A:ReceiveLevel(message)
	if message == "RESET_AUTHORITY" then
		self:UpdatePartyInfo()
		return
	end

	local key, value, serverID, playerUID = strmatch(message, "^(.-)=([0-9]-);([0-9]-);([0-9]+)")
	value = tonumber(value)
	serverID = tonumber(serverID)
	playerUID = tonumber(playerUID)

	if not cache[key] then
		cache[key] = {
			value = value,
			serverID = serverID,
			playerUID = playerUID,
		}
		return
	end

	local needUpdate = false
	if value > cache[key].value then -- 等级比较
		needUpdate = true
	elseif value == cache[key].value then
		if serverID > cache[key].serverID then -- 服务器 ID 比较
			needUpdate = true
		elseif serverID == cache[key].serverID then
			if playerUID > cache[key].playerUID then -- 玩家 ID 比较
				needUpdate = true
			end
		end
	end

	if needUpdate then
		cache[key].value = value
		cache[key].serverID = serverID
		cache[key].playerUID = playerUID
	end
end

function A:ResetAuthority()
	if not IsInGroup() then
		return
	end

	C_ChatInfo_SendAddonMessage(self.prefix, "RESET_AUTHORITY", GetBestChannel())
end

do
	local waitSend = false
	function A:UpdatePartyInfo()
		if waitSend then
			return
		end

		if not IsInGroup() then
			return
		end

		waitSend = true
		E:Delay(0.5, function()
			if IsInGroup() then
				cache = {}
				self:SendInterruptConfig()
				self:SendDispelConfig()
				self:SendUtilityConfig()
				self:SendCombatResurrectionConfig()
				self:SendTauntConfig()
				self:SendThreatTransferConfig()
			end
			waitSend = false
		end)
	end
end

-- INTERRUPT_OTHERS
function A:SendInterruptConfig()
	if not self.db.interrupt.others.enable then
		return
	end

	local channel = self:GetChannel(self.db.interrupt.others.channel)
	self:SendMyLevel("INTERRUPT_OTHERS", channelLevel[channel])
end

-- DISPEL_OTHERS
function A:SendDispelConfig()
	if not self.db.dispel.others.enable then
		return
	end

	local channel = self:GetChannel(self.db.dispel.others.channel)
	self:SendMyLevel("DISPEL_OTHERS", channelLevel[channel])
end

-- UTILITY
function A:SendUtilityConfig()
	if not self.db.utility.enable then
		return
	end

	local channel = self:GetChannel(self.db.utility.channel)
	self:SendMyLevel("UTILITY", channelLevel[channel])
end

-- COMBAT_RESURRECTION
function A:SendCombatResurrectionConfig()
	if not self.db.combatResurrection.enable then
		return
	end

	if self.db.combatResurrection.onlySourceIsPlayer then
		return
	end

	local channel = self:GetChannel(self.db.combatResurrection.channel)

	if channel == "RAID" and self.db.combatResurrection.raidWarning then
		channel = "RAID_WARNING"
	end

	self:SendMyLevel("COMBAT_RESURRECTION", channelLevel[channel])
end

-- TAUNT_OTHERS
-- TAUNT_OTHERS_PET
function A:SendTauntConfig()
	if not self.db.taunt.enable then
		return
	end

	if self.db.taunt.others.player.enable then
		local channel = self:GetChannel(self.db.taunt.others.player.channel)
		self:SendMyLevel("TAUNT_OTHERS", channelLevel[channel])
	end

	if self.db.taunt.others.pet.enable then
		local channel = self:GetChannel(self.db.taunt.others.pet.channel)
		self:SendMyLevel("TAUNT_OTHERS_PET", channelLevel[channel])
	end
end

-- THREAT_TRANSFER
function A:SendThreatTransferConfig()
	if not self.db.threatTransfer.enable then
		return
	end

	local channel = self:GetChannel(self.db.threatTransfer.channel)

	if channel == "RAID" and self.db.threatTransfer.raidWarning then
		channel = "RAID_WARNING"
	end

	local value = channelLevel[channel]
	if not self.db.threatTransfer.onlyNotTank then
		value = value + 100
	end

	self:SendMyLevel("THREAT_TRANSFER", value)
end
