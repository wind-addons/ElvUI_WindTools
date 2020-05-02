local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:Blizzard_MacroUI()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.macro) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.macro) then return end

    S:CreateShadow(_G.MacroFrame)
    S:CreateShadow(_G.MacroPopupFrame)
end

S:AddCallbackForAddon('Blizzard_MacroUI')
