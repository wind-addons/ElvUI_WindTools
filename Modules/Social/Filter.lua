local W, F, E, L = unpack(select(2, ...))
local FT = W:NewModule("Filter", "AceEvent-3.0")

local GetCVar, ConsoleExec = GetCVar, ConsoleExec

function FT:LOADING_SCREEN_DISABLED()
    -- 导入自 Fxxkyou
    -- https://nga.178.com/read.php?tid=21171325
    if GetCVar("profanityFilter") == "1" then
        ConsoleExec("portal TW")
        ConsoleExec("profanityFilter 0")
    end
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
