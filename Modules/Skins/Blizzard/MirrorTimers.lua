local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

function S:MirrorTimers()
    if not self:CheckDB("mirrorTimers") then
        return
    end

    hooksecurefunc(_G.MirrorTimerMixin, "Setup", function(timer)
        if timer and timer.StatusBar then
            self:CreateShadow(timer.StatusBar)
        end
    end)
end

S:AddCallback("MirrorTimers")
