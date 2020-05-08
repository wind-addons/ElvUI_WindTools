local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc

local function SkinStatusReport()
    S:CreateShadow(_G.ElvUIStatusReport)
    S:CreateShadow(_G.ElvUIStatusPlugins)
end

function S:ElvUI_StatusReport()
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.statusReport) then
        return
    end

    if E.StatusFrame then
        SkinStatusReport()
    end

    hooksecurefunc(E, "CreateStatusFrame", SkinStatusReport)
end

S:AddCallback("ElvUI_StatusReport")
