local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_AzeriteEssenceUI()
	if not self:CheckDB("azeriteEssence") then
		return
	end

	self:CreateShadow(_G.AzeriteEssenceUI)
end

S:AddCallbackForAddon("Blizzard_AzeriteEssenceUI")
