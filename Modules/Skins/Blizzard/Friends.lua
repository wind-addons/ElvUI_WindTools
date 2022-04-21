local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local pairs = pairs

function S:FriendsFrame()
    if not self:CheckDB("friends") then
        return
    end

    local frames = {
        _G.FriendsFrame,
        _G.FriendsFriendsFrame,
        _G.AddFriendFrame,
        _G.RecruitAFriendFrame.SplashFrame,
        _G.RecruitAFriendRewardsFrame,
        _G.RecruitAFriendRecruitmentFrame,
        _G.FriendsFrameBattlenetFrame.BroadcastFrame
    }

    for _, frame in pairs(frames) do
        self:CreateShadow(frame)
    end

    self:CreateShadow(_G.BNToastFrame)

    for i = 1, 4 do
        self:ReskinTab(_G["FriendsFrameTab" .. i])
    end
end

S:AddCallback("FriendsFrame")
