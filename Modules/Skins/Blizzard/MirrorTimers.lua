local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:MirrorTimers()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.mirrorTimers) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.mirrorTimers) then return end

    for i = 1, MIRRORTIMER_NUMTIMERS do
        local statusBar = _G['MirrorTimer' .. i .. 'StatusBar']
        if statusBar.backdrop then
            statusBar.backdrop:SetTemplate('Tranparent')
            S:CreateShadow(statusBar.backdrop)
        end
    end
end

S:AddCallback('MirrorTimers')
