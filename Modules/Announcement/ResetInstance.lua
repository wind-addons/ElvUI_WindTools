local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local A = W:GetModule("Announcement") ---@class Announcement
local cache = W.Utilities.Cache

local _G = _G
local format = format
local gsub = gsub
local pairs = pairs
local strmatch = strmatch

local UnitIsGroupLeader = UnitIsGroupLeader

local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME

local msgList = {
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
		ignoreOn = { "partyLeaderChanged" },
		throttleKey = "ANNDungeonDifficultyChanged",
	},
	ERR_RAID_DIFFICULTY_CHANGED_S = {
		message = L["Raid difficulty set to >> %s <<"],
		isDifficultyChange = true,
		notMatch = gsub(_G.ERR_LEGACY_RAID_DIFFICULTY_CHANGED_S, "%%s", ".+"),
		ignoreOn = { "partyLeaderChanged" },
		throttleKey = "ANNRaidDifficultyChanged",
	},
}

local ignoreCondition = {
	partyLeaderChanged = nil,
}

---@type Cache
local resetMessageCache = cache.New({
	defaultTTL = 10, -- 1 second
	maxLength = nil,
	autoCleanup = true,
	cleanupInterval = 60,
})

function A:ResetInstanceIgnoreUpdate(event)
	if event == "PARTY_LEADER_CHANGED" then
		local time = time()
		ignoreCondition.partyLeaderChanged = time
		E:Delay(1, function()
			if ignoreCondition.partyLeaderChanged == time then
				ignoreCondition.partyLeaderChanged = nil
			end
		end)
	end
end

function A:ResetInstance(text)
	local config = self.db.resetInstance
	if not config or not config.enable then
		return
	end

	for messageKey, data in pairs(msgList) do
		local template = _G[messageKey]
		if strmatch(text, gsub(template, "%%s", ".+")) then
			if data.notMatch and strmatch(text, data.notMatch) then
				return
			end

			if data.ignoreOn then
				for _, conditionKey in pairs(data.ignoreOn) do
					if ignoreCondition[conditionKey] then
						print("Ignored reset instance announcement due to condition:", conditionKey)
						return
					end
				end
			end

			if data.isDifficultyChange then
				if not config.difficultyChange or not UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME) then
					print("Ignored reset instance announcement due to difficulty change or not being group leader")
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
						self:SendMessage(message, channel)
					end)
				else
					self:SendMessage(message, channel)
				end
			end
			return
		end
	end
end
