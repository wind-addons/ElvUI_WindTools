-- 作者：houshuu
local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local DTH = E:NewModule('Wind_DisableTalkingHead', 'AceHook-3.0')

local _G = _G
local TalkingHeadFrame_CloseImmediately = TalkingHeadFrame_CloseImmediately

function DTH:Initialize()

    if not E.db.WindTools["Quest"]["Disable Talking Head"]["enabled"] then return end
    self.db = E.db.WindTools["Quest"]["Disable Talking Head"]

    tinsert(WT.UpdateAll, function() DTH.db = E.db.WindTools["Quest"]["Disable Talking Head"] end)

    if _G.TalkingHeadFrame then
        hooksecurefunc("TalkingHeadFrame_PlayCurrent",
                       function() if DTH.db.enabled then TalkingHeadFrame_CloseImmediately() end end)
    else
        hooksecurefunc('TalkingHead_LoadUI', function()
            hooksecurefunc("TalkingHeadFrame_PlayCurrent",
                           function() if DTH.db.enabled then TalkingHeadFrame_CloseImmediately() end end)
        end)
    end

end

local function InitializeCallback() DTH:Initialize() end
E:RegisterModule(DTH:GetName(), InitializeCallback)
