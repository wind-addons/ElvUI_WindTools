local W, F, E, L = unpack(select(2, ...))
local M = W:GetModule("Misc")

local _G = _G
local hooksecurefunc = hooksecurefunc
local TalkingHeadFrame_CloseImmediately

function M:DisableTalkingHead()
    if _G.TalkingHeadFrame then
        TalkingHeadFrame_CloseImmediately = _G.TalkingHeadFrame_CloseImmediately
        hooksecurefunc(
            "TalkingHeadFrame_PlayCurrent",
            function()
                if E.private.WT.misc.disableTalkingHead then
                    TalkingHeadFrame_CloseImmediately()
                end
            end
        )
    else
        hooksecurefunc(
            "TalkingHead_LoadUI",
            function()
                TalkingHeadFrame_CloseImmediately = _G.TalkingHeadFrame_CloseImmediately
                hooksecurefunc(
                    "TalkingHeadFrame_PlayCurrent",
                    function()
                        if E.private.WT.misc.disableTalkingHead then
                            TalkingHeadFrame_CloseImmediately()
                        end
                    end
                )
            end
        )
    end
end

M:AddCallback("DisableTalkingHead")
