local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_AchievementUI()
    if not self:CheckDB("achievement", "achievements") then
        return
    end

    S:CreateBackdropShadow(_G.AchievementFrame)

    for i = 1, 3 do
        self:ReskinTab(_G["AchievementFrameTab" .. i])
    end
end

S:AddCallbackForAddon("Blizzard_AchievementUI")
