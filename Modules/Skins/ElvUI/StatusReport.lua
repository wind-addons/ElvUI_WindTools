local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

local data = S:AddCallback("ElvUI_StatusReport", S:CreateElvUICheck("statusReport"))

function data:SkinStatusReport() -- self is ElvUI (E) when hooked, not data
	S:CreateBackdropShadow(_G.ElvUIStatusReport)
	S:CreateBackdropShadow(_G.ElvUIStatusPlugins)
end

function S:ElvUI_StatusReport()
	if E.StatusFrame then
		data:SkinStatusReport()
	end

	self:SecureHook(E, "CreateStatusFrame", data.SkinStatusReport)
end
