local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local A = W:GetModule("Announcement") ---@class Announcement

function A:Goodbye()
	local config = self.db.goodbye
	if not config or not config.enable then
		return
	end

	E:Delay(config.delay + 1, function()
		self:SendMessage(config.text, self:GetChannel(config.channel))
	end)
end
