local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G
local pairs = pairs

function S:LookingForGroupFrames()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.lfg) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.lookingForGroup) then return end

    local frames = {
        _G.PVEFrame,
        _G.LFGDungeonReadyDialog,
        _G.LFGDungeonReadyStatus,
        _G.ReadyCheckFrame,
        _G.QueueStatusFrame,
        _G.LFDReadyCheckPopup
    }

    for _, frame in pairs(frames) do S:CreateShadow(frame) end

    for i = 1, 3 do S:CreateTabShadow(_G["PVEFrameTab" .. i]) end
end

S:AddCallback('LookingForGroupFrames')