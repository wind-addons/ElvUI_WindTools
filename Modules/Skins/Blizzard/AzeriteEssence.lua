local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_AzeriteEssenceUI()
	if not self:CheckDB("azeriteEssence") then
		return
	end

	self:CreateShadow(_G.AzeriteEssenceUI)
end

S:AddCallbackForAddon("Blizzard_AzeriteEssenceUI")
