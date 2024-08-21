local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:EditModeManager()
	if not self:CheckDB("editor", "editModeManager") then
		return
	end

	self:CreateBackdropShadow(_G.EditModeManagerFrame)
	self:CreateBackdropShadow(_G.EditModeNewLayoutDialog)
	self:CreateBackdropShadow(_G.EditModeUnsavedChangesDialog)
	self:CreateBackdropShadow(_G.EditModeImportLayoutDialog)
	self:CreateBackdropShadow(_G.EditModeSystemSettingsDialog)
end

S:AddCallback("EditModeManager")
