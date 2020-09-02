local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:DressUpFrame()
    if not self:CheckDB("dressingroom", "dressingRoom") then
        return
    end

    self:CreateShadow(_G.DressUpFrame)
end

S:AddCallback("DressUpFrame")
