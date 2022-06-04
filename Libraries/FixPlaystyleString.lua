-- from Premade Groups Filter & LFMPlus
if C_LFGList.IsPlayerAuthenticatedForLFG(703) then
    function C_LFGList.GetPlaystyleString(playstyle, activityInfo)
        if
            activityInfo and playstyle ~= (0 or nil) and
                C_LFGList.GetLfgCategoryInfo(activityInfo.categoryID).showPlaystyleDropdown
         then
            local typeStr
            if activityInfo.isMythicPlusActivity then
                typeStr = "GROUP_FINDER_PVE_PLAYSTYLE"
            elseif activityInfo.isRatedPvpActivity then
                typeStr = "GROUP_FINDER_PVP_PLAYSTYLE"
            elseif activityInfo.isCurrentRaidActivity then
                typeStr = "GROUP_FINDER_PVE_RAID_PLAYSTYLE"
            elseif activityInfo.isMythicActivity then
                typeStr = "GROUP_FINDER_PVE_MYTHICZERO_PLAYSTYLE"
            end
            return typeStr and _G[typeStr .. tostring(playstyle)] or nil
        else
            return nil
        end
    end

    function LFGListEntryCreation_SetTitleFromActivityInfo(_)
    end
end
