local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local TT = E:GetModule("Tooltip")

local _G = _G
local hooksecurefunc = hooksecurefunc

-- From MerathilisUI
function S:LibQTip()
	-- Handle RareScanner's custom LibQTip-1.0RS tooltips
	local LQTRS = _G.LibStub("LibQTip-1.0RS", true)
	if LQTRS then
		hooksecurefunc(LQTRS, "Acquire", function()
			for _, tooltip in LQTRS:IterateTooltips() do
				TT:SetStyle(tooltip)
			end
		end)
	end

	-- Handle LibQTip-1.0 tooltips
	local LQT = _G.LibStub("LibQTip-1.0", true)
	if LQT then
		hooksecurefunc(LQT, "Acquire", function()
			for _, tooltip in LQT:IterateTooltips() do
				TT:SetStyle(tooltip)
			end
		end)
	end
end

S:AddCallback("LibQTip")
