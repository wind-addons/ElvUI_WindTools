local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:ElvUI_SkinStatusReport()
	self:CreateBackdropShadow(_G.ElvUIStatusReport)
	self:CreateBackdropShadow(_G.ElvUIStatusPlugins)
end

function S:ElvUI_StatusReport()
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.statusReport) then
		return
	end

	if E.StatusFrame then
		self:ElvUI_SkinStatusReport()
	end

	self:SecureHook(E, "CreateStatusFrame", "ElvUI_SkinStatusReport")
end

S:AddCallback("ElvUI_StatusReport")
