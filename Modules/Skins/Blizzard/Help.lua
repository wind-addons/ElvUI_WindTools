local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:HelpFrame()
	if not self:CheckDB("help") then
		return
	end

	self:CreateBackdropShadow(_G.HelpFrame)
end

S:AddCallback("HelpFrame")
