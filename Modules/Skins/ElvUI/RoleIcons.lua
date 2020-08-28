local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local InCombatLockdown = InCombatLockdown

function S:RoleIcons()
    local style = E.private.WT.skins.elvui.roleIconStyle
    
    if style == "FFXIV" then
        E.Media.Textures.Tank = W.Media.Textures.ffxivTank
        E.Media.Textures.DPS = W.Media.Textures.ffxivDPS
        E.Media.Textures.Header = W.Media.Textures.ffxivHeader
    end
end

S:AddCallback("RoleIcons")
