local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("ElvUI_StatusReport")
data.check = function()
	return (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.statusReport)
end

local _G = _G

function S:ElvUI_SkinStatusReport()
	self:CreateBackdropShadow(_G.ElvUIStatusReport)
	self:CreateBackdropShadow(_G.ElvUIStatusPlugins)
end

function S:ElvUI_StatusReport()
	if E.StatusFrame then
		self:ElvUI_SkinStatusReport()
	end

	self:SecureHook(E, "CreateStatusFrame", "ElvUI_SkinStatusReport")
end

