-- PlaystyleString erorr fixer
-- https://github.com/ChrisKader/LFMPlus/blob/main/core.lua
function LFMPlus_GetPlaystyleString(playstyle, activityInfo)
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

--There is no reason to do this api func protected, but they do.
C_LFGList.GetPlaystyleString = function(playstyle, activityInfo)
    return LFMPlus_GetPlaystyleString(playstyle, activityInfo)
end

--Protected func, not completable with addons. No name when creating activity without authenticator now.
function LFGListEntryCreation_SetTitleFromActivityInfo(_)
end
