local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_TimeManager()
    if not self:CheckDB("timemanager", "timeManager") then
        return
    end
    
    self:CreateShadow(_G.TimeManagerFrame.backdrop)
    self:CreateShadow(_G.StopwatchFrame.backdrop)
    _G.StopwatchTicker:ClearAllPoints()
    _G.StopwatchTicker:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -49, 1)
end

S:AddCallbackForAddon("Blizzard_TimeManager")
