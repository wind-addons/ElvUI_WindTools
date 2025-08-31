local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local A = W:GetModule("Announcement")

local _G = _G
local format = format
local gsub = gsub
local pairs = pairs
local strmatch = strmatch

local msgList = {
	INSTANCE_RESET_SUCCESS = L["%s has been reset"],
	INSTANCE_RESET_FAILED = L["Cannot reset %s (There are players still inside the instance.)"],
	INSTANCE_RESET_FAILED_ZONING = L["Cannot reset %s (There are players in your party attempting to zone into an instance.)"],
	INSTANCE_RESET_FAILED_OFFLINE = L["Cannot reset %s (There are players offline in your party.)"],
}

function A:ResetInstance(text)
	local config = self.db.resetInstance
	if not config or not config.enable then
		return
	end

	for systemMessage, friendlyMessage in pairs(msgList) do
		systemMessage = _G[systemMessage]
		if strmatch(text, gsub(systemMessage, "%%s", ".+")) then
			local instance = strmatch(text, gsub(systemMessage, "%%s", "(.+)"))
			local prefix = config.prefix and "<" .. W.PlainTitle .. "> " or ""
			self:SendMessage(format(prefix .. friendlyMessage, instance), self:GetChannel(config.channel))
			return
		end
	end
end
