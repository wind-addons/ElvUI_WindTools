local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')
local UF = E:GetModule('UnitFrames')

local _G = _G
local hooksecurefunc = hooksecurefunc

function S:ElvUI_ClassBars()
    if not E.private.unitframe.enable then return end
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.classBars) then return end

    hooksecurefunc(UF, "Configure_ClassBar", function(_, frame)
        local bar = frame[frame.ClassBar]
        if bar then S:CreateShadow(bar) end
    end)
end

S:AddCallback('ElvUI_ClassBars')
