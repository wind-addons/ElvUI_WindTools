local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local DT = E:GetModule("DataTexts")

local _G = _G
local pairs = pairs

function S:ElvUI_SkinDataPanel(_, name)
    local panel = DT:FetchFrame(name)
    self:CreateShadow(panel)
end

function S:ElvUI_DataPanels()
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.dataPanels) then
        return
    end

    if DT.PanelPool.InUse then
        for name, frame in pairs(DT.PanelPool.InUse) do
            self:CreateShadow(frame)
        end
    end

    if DT.PanelPool.Free then
        for name, frame in pairs(DT.PanelPool.Free) do
            self:CreateShadow(frame)
        end
    end

    self:SecureHook(DT, "BuildPanelFrame", "ElvUI_SkinDataPanel")
end

S:AddCallback("ElvUI_DataPanels")
