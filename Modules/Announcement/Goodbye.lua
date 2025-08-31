local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local A = W:GetModule("Announcement")

function A:Goodbye()
	local config = self.db.goodbye
	if not config or not config.enable then
		return
	end

	-- 延后 1 秒防止喊话过快阻挡其他系统信息
	E:Delay(config.delay + 1, function()
		A:SendMessage(config.text, A:GetChannel(config.channel))
	end)
end
