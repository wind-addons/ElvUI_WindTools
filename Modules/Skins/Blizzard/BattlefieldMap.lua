local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_BattlefieldMap()
	if not self:CheckDB("bgmap", "battlefieldMap") then
		return
	end

	self:CreateBackdropShadow(_G.BattlefieldMapFrame)
	self:CreateBackdropShadow(_G.BattlefieldMapTab)
end

S:AddCallbackForAddon("Blizzard_BattlefieldMap")
