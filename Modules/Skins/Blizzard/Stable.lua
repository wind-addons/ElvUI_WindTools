local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_StableUI()
	if not self:CheckDB("stable") then
		return
	end

	self:CreateShadow(_G.StableFrame)
end

S:AddCallbackForAddon("Blizzard_StableUI")
