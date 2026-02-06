local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local A = W:GetModule("Announcement") ---@class Announcement
local KI = W:GetModule("KeystoneInfo") ---@class KeystoneInfo

local gsub = gsub
local strlower = strlower

function A:Keystone(_, _, link)
	local config = self.db.keystone

	if not config or not config.enable then
		return
	end

	local message = gsub(config.text, "%%keystone%%", link)
	self:SendMessage(message, self:GetChannel(config.channel))
end

function A:KeystoneLink(event, text)
	local config = self.db.keystone

	if not config or not config.enable or not config.command then
		return
	end

	if E:IsSecretValue(text) or not text or strlower(text) ~= "!keys" then
		return
	end

	local channel
	if event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
		channel = "PARTY"
	elseif event == "CHAT_MSG_GUILD" then
		channel = "GUILD"
	end

	if channel then
		local link = KI:GetPlayerKeystoneLink()
		if link then
			self:SendMessage(link, channel)
		end
	end
end
