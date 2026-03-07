local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local M = W.Modules.Misc ---@class Misc

local C_CVar_SetCVar = C_CVar.SetCVar

function M:AntiOverride()
	if not E.private.WT.misc.antiOverride then
		return
	end

	C_CVar_SetCVar("profanityFilter", 0)
	C_CVar_SetCVar("overrideArchive", 0)
end

M:AddCallback("AntiOverride")
