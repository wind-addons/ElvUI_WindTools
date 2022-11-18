local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

local function updateClassIcon(button)
    if not button.expanded then
        return
    end

    local memberInfo = button:GetMemberInfo()
    if memberInfo and memberInfo.classID then
        print(memberInfo.classID)
    end
end

function S:Blizzard_Communities()
    if not self:CheckDB("communities") then
        return
    end

    local CommunitiesFrame = _G.CommunitiesFrame
    if not CommunitiesFrame then
        return
    end

    self:CreateShadow(CommunitiesFrame)
    self:CreateShadow(CommunitiesFrame.ChatTab)
    self:CreateShadow(CommunitiesFrame.RosterTab)
    self:CreateShadow(CommunitiesFrame.GuildBenefitsTab)
    self:CreateShadow(CommunitiesFrame.GuildInfoTab)
    self:CreateShadow(CommunitiesFrame.GuildMemberDetailFrame)
    self:CreateShadow(CommunitiesFrame.ClubFinderInvitationFrame)

    self:CreateShadow(_G.CommunitiesGuildLogFrame)
    self:CreateShadow(_G.CommunitiesSettingsDialog)

    local ClubFinderCommunityAndGuildFinderFrame = _G.ClubFinderCommunityAndGuildFinderFrame
    if ClubFinderCommunityAndGuildFinderFrame then
        self:CreateShadow(ClubFinderCommunityAndGuildFinderFrame.ClubFinderPendingTab)
        self:CreateShadow(ClubFinderCommunityAndGuildFinderFrame.ClubFinderSearchTab)
        self:CreateShadow(ClubFinderCommunityAndGuildFinderFrame.RequestToJoinFrame)
    end

    local ClubFinderCommunityAndGuildFinderFrame = _G.ClubFinderCommunityAndGuildFinderFrame
    if ClubFinderCommunityAndGuildFinderFrame then
        self:CreateShadow(ClubFinderCommunityAndGuildFinderFrame.ClubFinderPendingTab)
        self:CreateShadow(ClubFinderCommunityAndGuildFinderFrame.ClubFinderSearchTab)
        self:CreateShadow(ClubFinderCommunityAndGuildFinderFrame.RequestToJoinFrame)
    end

    self:CreateBackdropShadow(_G.CommunitiesFrame.RecruitmentDialog)
end

S:AddCallbackForAddon("Blizzard_Communities")
