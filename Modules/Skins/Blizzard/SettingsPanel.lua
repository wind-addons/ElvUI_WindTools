local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:SettingsPanel()
	if not self:CheckDB("blizzardOptions", "settingsPanel") then
		return
	end

	self:CreateBackdropShadow(_G.SettingsPanel)
end

S:AddCallback("SettingsPanel")
