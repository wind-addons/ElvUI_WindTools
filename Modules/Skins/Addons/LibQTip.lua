local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local TT = E:GetModule("Tooltip")

local _G = _G
local hooksecurefunc = hooksecurefunc

-- Modified from MerathilisUI

local function reskinLib(self)
	for _, tooltip in self:IterateTooltips() do
		TT:SetStyle(tooltip)
	end
end

function S:LibQTip()
	local LQT = _G.LibStub("LibQTip-1.0", true)
	if LQT then
		hooksecurefunc(LQT, "Acquire", reskinLib)
	end

	-- RareScanner's modified version
	local LQTRS = _G.LibStub("LibQTip-1.0RS", true)
	if LQTRS then
		hooksecurefunc(LQTRS, "Acquire", reskinLib)
	end
end

S:AddCallback("LibQTip")
