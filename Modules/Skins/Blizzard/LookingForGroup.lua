local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

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
        _G.LFDRoleCheckPopup,
        _G.ReadyCheckFrame,
        _G.QueueStatusFrame,
        _G.LFDReadyCheckPopup,
        _G.LFGListInviteDialog,
        _G.LFGListApplicationDialog
    }

    for _, frame in pairs(frames) do
        self:CreateShadow(frame)
    end

    for i = 1, 3 do
        self:ReskinTab(_G["PVEFrameTab" .. i])
    end

    if _G.LFDQueueFrameRandomScrollFrameChildFrame then
        local frame = _G.LFDQueueFrameRandomScrollFrameChildFrame
        F.SetFontOutline(frame.title, E.db.general.font)
        F.SetFontOutline(frame.description, E.db.general.font)
        F.SetFontOutline(frame.rewardsLabel, E.db.general.font)
        F.SetFontOutline(frame.rewardsDescription, E.db.general.font)
    end
end

S:AddCallback("LookingForGroupFrames")
