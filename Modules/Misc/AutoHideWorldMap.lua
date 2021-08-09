local W, F, E, L = unpack(select(2, ...))
local AHW = W:NewModule("AutoHideWorldMap", "AceEvent-3.0")

local _G = _G
local HideUIPanel = HideUIPanel

function AHW:PLAYER_REGEN_DISABLED()
    if _G.WorldMapFrame:IsShown() then
        HideUIPanel(_G.WorldMapFrame)
    end
end

function AHW:Initialize()
    if not E.private.WT.misc.autoHideWorldMap then
        return
    end

    AHW:RegisterEvent("PLAYER_REGEN_DISABLED")
end

W:RegisterModule(AHW:GetName())
