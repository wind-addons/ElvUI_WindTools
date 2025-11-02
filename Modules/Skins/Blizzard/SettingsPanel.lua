local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

local function SettingsListScrollUpdateChild(child)
	if child.__windSkin then
		return
	end

	if child.Checkbox then
		S.Widgets:HandleCheckBox(nil, child.Checkbox)
	end

	child.__windSkin = true
end

local function SettingsListScrollUpdate(frame)
	frame:ForEachFrame(SettingsListScrollUpdateChild)
end

function S:SettingsPanel()
	if not self:CheckDB("blizzardOptions", "settingsPanel") then
		return
	end

	self:CreateBackdropShadow(_G.SettingsPanel)

	hooksecurefunc(_G.SettingsPanel.Container.SettingsList.ScrollBox, "Update", SettingsListScrollUpdate)
end

S:AddCallback("SettingsPanel")
