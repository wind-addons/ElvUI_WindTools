local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

local function SkinAchievementFrame(tried)
    tried = tried or 0
    if _G.AchievementFrame.backdrop then
        S:CreateShadow(_G.AchievementFrame.backdrop)
    else
        if tried < 20 then
            E:Delay(
                .1,
                function()
                    SkinAchievementFrame(tried)
                end
            )
        end
    end
end

function S:Blizzard_AchievementUI()
    if not self:CheckDB("achievement", "achievements") then
        return
    end

    SkinAchievementFrame()

    for i = 1, 3 do
        self:CreateBackdropShadowAfterElvUISkins(_G["AchievementFrameTab" .. i])
    end
end

S:AddCallbackForAddon("Blizzard_AchievementUI")
