local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_Communities()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.communities) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.communities) then
        return
    end

    if _G.CommunitiesFrame then
        local f = _G.CommunitiesFrame
        S:CreateShadow(f)
        S:CreateShadow(f.ChatTab)
        S:CreateShadow(f.RosterTab)
        S:CreateShadow(f.GuildBenefitsTab)
        S:CreateShadow(f.GuildInfoTab)
        S:CreateShadow(f.GuildMemberDetailFrame)
        S:CreateShadow(f.ClubFinderInvitationFrame)
        if _G.CommunitiesGuildLogFrame then
            S:CreateShadow(_G.CommunitiesGuildLogFrame)
        end
    end

    -- 搜寻社群
    if _G.ClubFinderCommunityAndGuildFinderFrame then
        local f = _G.ClubFinderCommunityAndGuildFinderFrame
        if f.ClubFinderPendingTab then
            S:CreateShadow(f.ClubFinderPendingTab)
        end
        if f.ClubFinderSearchTab then
            S:CreateShadow(f.ClubFinderSearchTab)
        end
        if f.RequestToJoinFrame then
            S:CreateShadow(f.RequestToJoinFrame)
        end
    end

    -- 搜寻公会
    if _G.ClubFinderGuildFinderFrame then
        local f = _G.ClubFinderGuildFinderFrame
        if f.ClubFinderPendingTab then
            S:CreateShadow(f.ClubFinderPendingTab)
        end
        if f.ClubFinderSearchTab then
            S:CreateShadow(f.ClubFinderSearchTab)
        end
        if f.RequestToJoinFrame then
            S:CreateShadow(f.RequestToJoinFrame)
        end
    end
end

S:AddCallbackForAddon("Blizzard_Communities")
