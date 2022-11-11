local W, F, E, L = unpack(select(2, ...))
local M = W.Modules.Misc

local _G = _G

local alertFrame

function M:DelayScreenshot(_one, _two, _three, tried)
    if not tried then
        tried = 0
    end

    if tried > 30 then
        return
    end

    print(tried)

    E:Delay(
        0.5,
        function()
            if alertFrame and alertFrame.IsShown and alertFrame:IsShown() and _G.Screenshot then
                _G.Screenshot()
            else
                self:DelayScreenshot(nil, nil, nil, tried + 1)
            end
        end
    )
end

function M:AutoScreenShot()
    if E.private.WT.misc.autoScreenshot then
        self:RegisterEvent("ACHIEVEMENT_EARNED", "DelayScreenshot")
        hooksecurefunc(
            _G.AchievementAlertSystem,
            "setUpFunction",
            function(frame)
                E:Delay(
                    1, -- achievement alert frame will be shown after 1 second
                    function()
                        local thisFrame = frame
                        alertFrame = frame
                        E:Delay(
                            16, -- wait for 15 seconds
                            function()
                                if thisFrame == alertFrame then
                                    alertFrame = nil
                                end
                            end
                        )
                    end
                )
            end
        )
    end
end

M:AddCallback("AutoScreenShot")
