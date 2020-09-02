local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:TutorialFrame()
    if not self:CheckDB("tutorials", "tutorial") then
        return
    end

    self:CreateShadow(_G.TutorialFrame)
end

S:AddCallback("TutorialFrame")
