local W, F, E, L = unpack(select(2, ...))
local FT = W:NewModule("Filter", "AceEvent-3.0")

local ConsoleExec = ConsoleExec
local GetCVar = GetCVar
local C_BattleNet = C_BattleNet
local C_BattleNet_GetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo

do
    local updated = false
    function FT:UpdateAPI()
        if updated then
            return
        end

        -- Solution from https://nga.178.com/read.php?tid=27432996
        function C_BattleNet.GetFriendGameAccountInfo(...)
            local gameAccountInfo = C_BattleNet_GetFriendGameAccountInfo(...)
            gameAccountInfo.isInCurrentRegion = true
            return gameAccountInfo
        end

        updated = true
    end
end

function FT:LOADING_SCREEN_DISABLED()
    if GetCVar("portal") == "CN" and GetCVar("profanityFilter") == "1" then
        ConsoleExec("portal TW")
        ConsoleExec("profanityFilter 0")
    end

    self:UpdateAPI()
end

function FT:Initialize()
    if not E.db.WT.social.filter.enable then
        return
    end

    self.db = E.db.WT.social.filter

    if self.db.unblockProfanityFilter then
        self:RegisterEvent("LOADING_SCREEN_DISABLED")
    end
end

function FT:ProfileUpdate()
    self.db = E.db.WT.social.filter

    if self.db.unblockProfanityFilter then
        self:RegisterEvent("LOADING_SCREEN_DISABLED")
    else
        self:UnregisterEvent("LOADING_SCREEN_DISABLED")
    end
end

W:RegisterModule(FT:GetName())
