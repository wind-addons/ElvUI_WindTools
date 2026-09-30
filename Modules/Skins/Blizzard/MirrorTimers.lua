local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

S:AddCallback("MirrorTimers", "mirrorTimers")

function S:MirrorTimers()
	hooksecurefunc(_G.MirrorTimerContainer, "SetupTimer", function(container, timer)
		local bar = container:GetAvailableTimer(timer)
		if not bar then
			return
		end

		self:CreateShadow(bar)
	end)
end
