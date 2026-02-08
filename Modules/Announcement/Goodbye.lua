local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local A = W:GetModule("Announcement") ---@class Announcement

function A:Goodbye()
	local db = self.db.goodbye
	if not db or not db.enable then
		return
	end

	self:SendMessage(db.text, self:GetChannel(db.channel))
end

function A:DelayedGoodbye()
	E:Delay(1, self.Goodbye, self)
end
