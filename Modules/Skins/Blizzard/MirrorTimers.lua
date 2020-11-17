local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local MIRRORTIMER_NUMTIMERS = MIRRORTIMER_NUMTIMERS

function S:MirrorTimers()
    if not self:CheckDB("mirrorTimers") then
        return
    end

    for i = 1, MIRRORTIMER_NUMTIMERS do
        local statusBar = _G["MirrorTimer" .. i .. "StatusBar"]
        self:CreateBackdropShadow(statusBar, true)
    end
end

S:AddCallback("MirrorTimers")
