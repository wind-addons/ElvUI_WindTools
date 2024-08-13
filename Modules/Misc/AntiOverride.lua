local W, F, E, L = unpack((select(2, ...)))
local M = W.Modules.Misc

local _G = _G

local function FixLanguageFilterSideEffects()
    local GetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo
    function C_BattleNet.GetFriendGameAccountInfo(...)
        local gameAccountInfo = GetFriendGameAccountInfo(...)
        if gameAccountInfo then
            gameAccountInfo.isInCurrentRegion = true
        end
        return gameAccountInfo
    end

    local GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
    function C_BattleNet.GetFriendAccountInfo(...)
        local accountInfo = GetFriendAccountInfo(...)
        if accountInfo and accountInfo.gameAccountInfo then
            accountInfo.gameAccountInfo.isInCurrentRegion = true
        end
        return accountInfo
    end
end

-- from https://www.curseforge.com/wow/addons/fckyou
function M:AntiOverride()
    if not E.private.WT.misc.antiOverride then
        return
    end

    if not BNFeaturesEnabledAndConnected() then
        return
    end

    if GetCVar("portal") == "CN" then
        ConsoleExec("portal TW")
        FixLanguageFilterSideEffects()
    end

    SetCVar("profanityFilter", 0)
    SetCVar("overrideArchive", 0)
end

M:AddCallback("AntiOverride")
