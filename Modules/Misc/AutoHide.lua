local W, F, E, L = unpack(select(2, ...))
local AH = W:NewModule("AutoHide", "AceEvent-3.0")

local _G = _G
local securecall = securecall
local HideUIPanel = HideUIPanel

function AH:PLAYER_REGEN_DISABLED()
    if E.db.WT.misc.autoHideWorldMap and _G.WorldMapFrame:IsShown() then
        HideUIPanel(_G.WorldMapFrame)
    end

    if E.db.WT.misc.autoHideBag then
        securecall("CloseAllBags")
    end
end

function AH:Initialize()
    AH:RegisterEvent("PLAYER_REGEN_DISABLED")
end

W:RegisterModule(AH:GetName())
