-- 导入自 Fxxkyou
-- https://nga.178.com/read.php?tid=21171325
local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local WUF = E:NewModule('Wind_UnblockFilter', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')

local ConsoleExec = ConsoleExec

function WUF:LOADING_SCREEN_DISABLED()
    if GetCVar('profanityFilter') == "1" then
        ConsoleExec("portal TW")
        ConsoleExec("profanityFilter 0")
    end
end

function WUF:Initialize()
    self.db = E.db.WindTools["Chat"]["Unblock Filter"]
    if not self.db.enabled then return end

    tinsert(WT.UpdateAll, function()
        WUF.db = E.db.WindTools["Chat"]["Unblock Filter"]
    end)

    self:RegisterEvent("LOADING_SCREEN_DISABLED")
end

local function InitializeCallback()
    WUF:Initialize()
end

E:RegisterModule(WUF:GetName(), InitializeCallback)