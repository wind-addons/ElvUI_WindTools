local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_Soulbinds()
	if not self:CheckDB("soulbinds") then
		return
	end

	self:CreateShadow(_G.SoulbindViewer)
end

S:AddCallbackForAddon("Blizzard_Soulbinds")
