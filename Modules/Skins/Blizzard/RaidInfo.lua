local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:RaidInfoFrame()
	if not self:CheckDB("nonraid", "raidInfo") then
		return
	end

	self:CreateShadow(_G.RaidInfoFrame)
end

S:AddCallback("RaidInfoFrame")
