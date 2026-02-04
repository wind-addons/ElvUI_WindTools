local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local UF = E:GetModule("UnitFrames")
local RI = W:NewModule("RoleIcon")

function RI:Initialize()
	self.db = E.private.WT.unitFrames.roleIcon

	if not self.db or not self.db.enable then
		return
	end

	local pack = self.db.enable and self.db.roleIconStyle or "DEFAULT"
	UF.RoleIconTextures = W.Media.RoleIcons[pack]
end

W:RegisterModule(RI:GetName())
