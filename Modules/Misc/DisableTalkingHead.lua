local W, F, E, L = unpack(select(2, ...))
local M = W:GetModule("Misc")

local hooksecurefunc = hooksecurefunc

function M:DisableTalkingHead()
    if _G.TalkingHeadFrame then
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
