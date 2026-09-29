local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_AzeriteEssenceUI")
data.toggle = "azeriteEssence"

local _G = _G

function S:Blizzard_AzeriteEssenceUI()
	self:CreateShadow(_G.AzeriteEssenceUI)
end

