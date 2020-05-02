local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:FriendsFrame()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.character) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.character) then return end

    S:CreateShadow(_G.FriendsFrame)
    S:CreateShadow(_G.RecruitAFriendRewardsFrame)
    S:CreateShadow(_G.RecruitAFriendRecruitmentFrame)
    S:CreateShadow(_G.FriendsFrameBattlenetFrame.BroadcastFrame)

    for i = 1, 4 do S:CreateTabShadow(_G["FriendsFrameTab" .. i]) end
end

S:AddCallback('FriendsFrame')