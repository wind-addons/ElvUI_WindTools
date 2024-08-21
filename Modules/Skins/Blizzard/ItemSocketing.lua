local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_ItemSocketingUI()
	if not self:CheckDB("socket", "itemSocketing") then
		return
	end

	self:CreateShadow(_G.ItemSocketingFrame)
end

S:AddCallbackForAddon("Blizzard_ItemSocketingUI")
