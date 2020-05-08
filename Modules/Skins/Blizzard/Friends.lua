local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local pairs = pairs

function S:FriendsFrame()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.friends) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.friends) then
        return
    end

    local frames = {
        _G.FriendsFrame,
        _G.QuickJoinFrame,
        _G.AddFriendFrame,
        _G.BNToastFrame,
        _G.RecruitAFriendFrame.SplashFrame,
        _G.RecruitAFriendRewardsFrame,
        _G.RecruitAFriendRecruitmentFrame,
        _G.FriendsFrameBattlenetFrame.BroadcastFrame
    }

    for _, frame in pairs(frames) do
        S:CreateShadow(frame)
    end
    for i = 1, 4 do
        S:CreateBackdropShadow(_G["FriendsFrameTab" .. i])
    end
end

S:AddCallback("FriendsFrame")
