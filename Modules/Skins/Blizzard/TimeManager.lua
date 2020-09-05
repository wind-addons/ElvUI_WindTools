local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_TimeManager()
    if not self:CheckDB("timemanager", "timeManager") then
        return
    end

    local frame = _G.StopwatchFrame
    if not frame then
        return
    end

    self:CreateShadow(frame.backdrop)
    _G.StopwatchTicker:ClearAllPoints()
    _G.StopwatchTicker:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -49, 1)
end

S:AddCallbackForAddon("Blizzard_TimeManager")
