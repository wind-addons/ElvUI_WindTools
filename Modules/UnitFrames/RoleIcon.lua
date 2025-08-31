local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local UF = E:GetModule("UnitFrames")
local RI = W:NewModule("RoleIcon")

local _G = _G

local RoleIconTextures = {
	PHILMOD = {
		TANK = W.Media.Icons.philModTank,
		HEALER = W.Media.Icons.philModHealer,
		DAMAGER = W.Media.Icons.philModDPS,
	},
	FFXIV = {
		TANK = W.Media.Icons.ffxivTank,
		HEALER = W.Media.Icons.ffxivHealer,
		DAMAGER = W.Media.Icons.ffxivDPS,
	},
	HEXAGON = {
		TANK = W.Media.Icons.hexagonTank,
		HEALER = W.Media.Icons.hexagonHealer,
		DAMAGER = W.Media.Icons.hexagonDPS,
	},
	SUNUI = {
		TANK = W.Media.Icons.sunUITank,
		HEALER = W.Media.Icons.sunUIHealer,
		DAMAGER = W.Media.Icons.sunUIDPS,
	},
	LYNUI = {
		TANK = W.Media.Icons.lynUITank,
		HEALER = W.Media.Icons.lynUIHealer,
		DAMAGER = W.Media.Icons.lynUIDPS,
	},
	ELVUI_OLD = {
		TANK = W.Media.Icons.elvUIOldTank,
		HEALER = W.Media.Icons.elvUIOldHealer,
		DAMAGER = W.Media.Icons.elvUIOldDPS,
	},
	DEFAULT = {
		TANK = E.Media.Textures.Tank,
		HEALER = E.Media.Textures.Healer,
		DAMAGER = E.Media.Textures.DPS,
	},
}

function RI:Initialize()
	self.db = E.private.WT.unitFrames.roleIcon
	if not self.db or not self.db.enable then
		return
	end

	local pack = self.db.enable and self.db.roleIconStyle or "DEFAULT"
	UF.RoleIconTextures = RoleIconTextures[pack]
end

W:RegisterModule(RI:GetName())
