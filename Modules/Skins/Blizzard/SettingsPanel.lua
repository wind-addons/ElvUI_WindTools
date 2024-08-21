local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

local pairs = pairs

function S:SettingsPanel()
	if not self:CheckDB("blizzardOptions", "settingsPanel") then
		return
	end

	self:CreateBackdropShadow(_G.SettingsPanel)
end

S:AddCallback("SettingsPanel")
