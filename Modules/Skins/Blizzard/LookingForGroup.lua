local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local pairs = pairs

function S:LookingForGroupFrames()
    if not self:CheckDB("lfg", "lookingForGroup") then
        return
    end

    local frames = {
        _G.PVEFrame,
        _G.LFGDungeonReadyDialog,
        _G.LFGDungeonReadyStatus,
        _G.ReadyCheckFrame,
        _G.QueueStatusFrame,
        _G.LFDReadyCheckPopup,
        _G.LFGListInviteDialog,
        _G.LFGListApplicationDialog
    }

    for _, frame in pairs(frames) do
        self:CreateBackdropShadowAfterElvUISkins(frame)
    end

    for i = 1, 3 do
        self:ReskinTab(_G["PVEFrameTab" .. i])
    end

    F.SetFontOutline(_G.LFDQueueFrameRandomScrollFrameChildFrameDescription, E.db.general.font, "-1")
end

S:AddCallback("LookingForGroupFrames")
