local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:HelpFrame()
    if not self:CheckDB("help") then
        return
    end

    self:CreateShadow(_G.HelpFrame)
    self:CreateShadow(_G.HelpFrame.Header)
end

S:AddCallback("HelpFrame")
