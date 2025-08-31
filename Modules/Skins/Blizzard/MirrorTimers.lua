local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

function S:MirrorTimers()
	if not self:CheckDB("mirrorTimers") then
		return
	end

	hooksecurefunc(_G.MirrorTimerContainer, "SetupTimer", function(container, timer)
		local bar = container:GetAvailableTimer(timer)
		if not bar then
			return
		end

		self:CreateShadow(bar)
	end)
end

S:AddCallback("MirrorTimers")
