local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

function S:ElvUI_StatusReport()
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.statusReport) then return end

    if E.StatusFrame then S:CreateShadow(E.StatusFrame) end
    hooksecurefunc(E, "CreateStatusFrame", function() S:CreateShadow(_G.ElvUIStatusReport) end)
end

S:AddCallback('ElvUI_StatusReport')
