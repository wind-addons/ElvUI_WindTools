local W, F, E, L = unpack(select(2, ...))
local M = W.Modules.Misc

local _G = _G

function M:DelayScreenshot()
    E:Delay(1, _G.Screenshot)
end

function M:AutoScreenShot()
    if E.private.WT.misc.autoScreenshot then
        M:RegisterEvent("ACHIEVEMENT_EARNED", "DelayScreenshot")  
    end
end

M:AddCallback("AutoScreenShot")
