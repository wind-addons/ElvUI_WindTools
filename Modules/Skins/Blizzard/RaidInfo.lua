local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:RaidInfoFrame()
	if not self:CheckDB("nonraid", "raidInfo") then
		return
	end

	self:CreateShadow(_G.RaidInfoFrame)
end

S:AddCallback("RaidInfoFrame")
