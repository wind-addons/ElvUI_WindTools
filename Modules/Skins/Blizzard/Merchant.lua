local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:MerchantFrame()
    if not self:CheckDB("merchant") then
        return
    end

    self:CreateBackdropShadow(_G.MerchantFrame)

    for i = 1, 2 do
        self:CreateBackdropShadow(_G["MerchantFrameTab" .. i])
    end
end

S:AddCallback("MerchantFrame")
