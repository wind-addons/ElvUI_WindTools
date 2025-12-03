local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local A = W:GetModule("Announcement") ---@class Announcement
local cache = W.Utilities.Cache

local _G = _G
local format = format
local gsub = gsub
local pairs = pairs
local strmatch = strmatch
local time = time

local UnitIsGroupLeader = UnitIsGroupLeader

local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
local ERR_RAID_CONVERTED_TO_PARTY = ERR_RAID_CONVERTED_TO_PARTY
local ERR_PARTY_CONVERTED_TO_RAID = ERR_PARTY_CONVERTED_TO_RAID

local messageData = {
	INSTANCE_RESET_SUCCESS = {
		message = L["%s has been reset"],
	},
	INSTANCE_RESET_FAILED = {
		message = L["Cannot reset %s (There are players still inside the instance.)"],
	},
	INSTANCE_RESET_FAILED_ZONING = {
		message = L["Cannot reset %s (There are players in your party attempting to zone into an instance.)"],
	},
	INSTANCE_RESET_FAILED_OFFLINE = {
		message = L["Cannot reset %s (There are players offline in your party.)"],
	},
	ERR_DUNGEON_DIFFICULTY_CHANGED_S = {
		message = L["Dungeon difficulty set to >> %s <<"],
		isDifficultyChange = true,
		ignoreOn = { "partyLeaderChanged", "justChangedGroupType" },
		throttleKey = "ANNDungeonDifficultyChanged",
	},
	ERR_RAID_DIFFICULTY_CHANGED_S = {
		message = L["Raid difficulty set to >> %s <<"],
		isDifficultyChange = true,
		notMatch = gsub(_G.ERR_LEGACY_RAID_DIFFICULTY_CHANGED_S, "%%s", ".+"),
		ignoreOn = { "partyLeaderChanged", "justChangedGroupType" },
		throttleKey = "ANNRaidDifficultyChanged",
	},
}

local ignoreCondition = {
	justChangedGroupType = nil,
	partyLeaderChanged = nil,
}

---@type Cache
local resetMessageCache = cache.New({
	defaultTTL = 10, -- 1 second
	maxLength = nil,
	autoCleanup = true,
	cleanupInterval = 60,
})

function A:ResetInstanceUpdateIgnoreState(event, text)
	local t = time()
	if event == "PARTY_LEADER_CHANGED" then
		ignoreCondition.partyLeaderChanged = t
		E:Delay(1, function()
			if ignoreCondition.partyLeaderChanged == t then
				ignoreCondition.partyLeaderChanged = nil
			end
		end)
	elseif event == "CHAT_MSG_SYSTEM" then
		if text and (text == ERR_RAID_CONVERTED_TO_PARTY or text == ERR_PARTY_CONVERTED_TO_RAID) then
			ignoreCondition.justChangedGroupType = t
			E:Delay(1, function()
				if ignoreCondition.justChangedGroupType == t then
					ignoreCondition.justChangedGroupType = nil
				end
			end)
			return
		end
	end
end

function A:ResetInstance(text)
	local config = self.db.resetInstance
	if not config or not config.enable then
		return
	end

	for key, data in pairs(messageData) do
		local template = _G[key]
		if strmatch(text, gsub(template, "%%s", ".+")) then
			if data.notMatch and strmatch(text, data.notMatch) then
				return
			end

			if data.ignoreOn then
				for _, conditionKey in pairs(data.ignoreOn) do
					if ignoreCondition[conditionKey] then
						return
					end
				end
			end

			if data.isDifficultyChange then
				if not config.difficultyChange or not UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME) then
					return
				end
			end

			local instance = strmatch(text, gsub(template, "%%s", "(.+)"))
			local message = format(data.message, instance)
			local channel = self:GetChannel(config.channel)

			local cached = resetMessageCache:Get(channel) ---@type string?
			if not cached or cached ~= message then
				resetMessageCache:Set(channel, message)
				if data.throttleKey then
					F.ThrottleFirst(0.5, data.throttleKey, function()
						if channel == self:GetChannel(config.channel) then
							self:SendMessage(message, channel)
						end
					end)
				else
					self:SendMessage(message, channel)
				end
			end
			return
		end
	end
end
