local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallback("EditModeManager", "editor", "editModeManager")

function S:EditModeManager()
	self:CreateBackdropShadow(_G.EditModeManagerFrame)
	self:CreateBackdropShadow(_G.EditModeNewLayoutDialog)
	self:CreateBackdropShadow(_G.EditModeUnsavedChangesDialog)
	self:CreateBackdropShadow(_G.EditModeImportLayoutDialog)
	self:CreateBackdropShadow(_G.EditModeSystemSettingsDialog)
end
