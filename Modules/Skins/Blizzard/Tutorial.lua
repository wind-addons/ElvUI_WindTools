local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, table, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:TutorialFrame()
	if not self:CheckDB("tutorials", "tutorial") then
		return
	end

	self:CreateShadow(_G.TutorialFrame)
end

S:AddCallback("TutorialFrame")
