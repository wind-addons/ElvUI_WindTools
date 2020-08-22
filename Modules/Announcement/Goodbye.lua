local W, F, E, L = unpack(select(2, ...))
local A = W:GetModule("Announcement")
local C_Timer_After = C_Timer.After

function A:Goodbye()
	local config = self.db.goodbye
	if not config.enable then return end

    -- 延后 1 秒防止喊话过快阻挡其他系统信息
	C_Timer_After(config.delay + 1, function()
        A:SendMessage(config.text, A:GetChannel(config.channel))
    end)
end