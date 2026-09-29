local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_StableUI")
data.toggle = "stable"

local _G = _G

function S:Blizzard_StableUI()
	self:CreateShadow(_G.StableFrame)
end

