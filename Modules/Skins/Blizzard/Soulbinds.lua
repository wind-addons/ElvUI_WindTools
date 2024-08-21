local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_Soulbinds()
	if not self:CheckDB("soulbinds") then
		return
	end

	self:CreateShadow(_G.SoulbindViewer)
end

S:AddCallbackForAddon("Blizzard_Soulbinds")
