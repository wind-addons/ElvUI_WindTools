local W, F, E, L = unpack(select(2, ...))
local A = E:GetModule('Auras')
local S = W:GetModule('Skins')

local _G = _G

function S:ElvUI_Panels()
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.panels) then return end

    if _G.ElvUI_TopPanel then S:CreateShadow(_G.ElvUI_TopPanel) end
    if _G.ElvUI_BottomPanel then S:CreateShadow(_G.ElvUI_BottomPanel) end
    
end

S:AddCallback('ElvUI_Panels')
