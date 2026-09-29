local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_BattlefieldMap")
data.toggle = "bgmap"
data.private = "battlefieldMap"

local _G = _G

function S:Blizzard_BattlefieldMap()
	self:CreateBackdropShadow(_G.BattlefieldMapFrame)
	self:CreateBackdropShadow(_G.BattlefieldMapTab)
end

