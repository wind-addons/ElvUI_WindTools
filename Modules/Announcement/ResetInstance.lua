-- 修改自 InstanceResetAnnouncer
-- Novaspark-Firemaw EU (classic) / Venomisto-Frostmourne OCE (retail).
-- https://www.curseforge.com/members/venomisto/projectsd

local W, F, E, L = unpack(select(2, ...))
local A = W:GetModule("Announcement")

local gsub, format, match = string.gsub, string.format, string.match

local msgList = {
    INSTANCE_RESET_SUCCESS = L["%s has been reset"],
    INSTANCE_RESET_FAILED = L["Cannot reset %s (There are players still inside the instance.)"],
    INSTANCE_RESET_FAILED_ZONING = L["Cannot reset %s (There are players in your party attempting to zone into an instance.)"],
    INSTANCE_RESET_FAILED_OFFLINE = L["Cannot reset %s (There are players offline in your party.)"],
}

function A:ResetInstance(event, data)
    if not self.db.resetInstance.enable or event ~= "CHAT_MSG_SYSTEM" then
        return
    end

    local msg = data[1]

    for sysMsg, windMsg in pairs(msgList) do
		sysMsg = _G[sysMsg]
		if (match(msg, gsub(sysMsg, "%%s", ".+"))) then
			local instance = match(msg, gsub(sysMsg, "%%s", "(.+)"));
			local prefix = self.db.resetInstance.prefix and "<WindTools> " or ""
			self:SendMessage(format(prefix..windMsg, instance), self:GetChannel(self.db.resetInstance.channel))
			return
		end
	end

end

A:AddCallbackForEvent("CHAT_MSG_SYSTEM", "ResetInstance")