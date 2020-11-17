local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:StaticPopup()
    if not self:CheckDB(nil, "staticPopup") then
        return
    end

    for i = 1, 4 do
        local f = _G["StaticPopup" .. i]
        if f then
            self:CreateBackdropShadow(f)
        end
    end
end

S:AddCallback("StaticPopup")
