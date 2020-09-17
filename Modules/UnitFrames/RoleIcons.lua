local W, F, E, L = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")
local RI = W:NewModule("RoleIcons")

local _G = _G

local RoleIconTextures = {
    FFXIV = {
        TANK = W.Media.Icons.ffxivTank,
        HEALER = W.Media.Icons.ffxivHealer,
        DAMAGER = W.Media.Icons.ffxivDPS
    },
    HEXAGON = {
        TANK = W.Media.Icons.hexagonTank,
        HEALER = W.Media.Icons.hexagonHealer,
        DAMAGER = W.Media.Icons.hexagonDPS
    },
    SUNUI = {
        TANK = W.Media.Icons.sunUITank,
        HEALER = W.Media.Icons.sunUIHealer,
        DAMAGER = W.Media.Icons.sunUIDPS
    },
    DEFAULT = {
        TANK = E.Media.Textures.Tank,
        HEALER = E.Media.Textures.Healer,
        DAMAGER = E.Media.Textures.DPS
    },
    BLIZZARD = {
        TANK = gsub(_G.INLINE_TANK_ICON, ":16:16", ""),
        HEALER = gsub(_G.INLINE_HEALER_ICON, ":16:16", ""),
        DAMAGER = gsub(_G.INLINE_DAMAGER_ICON, ":16:16", "")
    }
}

function RI:Initialize()
    self.db = E.private.WT.unitFrames.roleIcons
    if not self.db or not self.db.enable then
        return
    end

    local pack = self.db.enable and self.db.pack or "DEFAULT"
    UF.RoleIconTextures = RoleIconTextures[pack]
end

W:RegisterModule(RI:GetName())
