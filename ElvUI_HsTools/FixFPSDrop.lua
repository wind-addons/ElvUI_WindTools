-- 解决CVar导致的FPS骤降
-- 原作者：Flamacue
-- 修改：无

local Frame = CreateFrame("Frame")
Frame:RegisterEvent("PLAYER_LOGIN")

Frame:SetScript("OnEvent", function(...)
SetCVar("nameplateMaxDistance", 45)
SetCVar("nameplateLargeTopInset", -1)
SetCVar("nameplateOtherTopInset", -1)
SetCVar("nameplateLargeBottomInset", -1)
SetCVar("nameplateOtherBottomInset", -1)
SetCVar("nameplateHorizontalScale", 1)
SetCVar("nameplateLargerScale", 1)
SetCVar("nameplateSelectedScale", 0.9)
SetCVar("nameplateMinAlpha", 0.8)
SetCVar("ShowDispelDebuffs", 0)
SetCVar("NoBuffDebuffFilterOnTarget", 1)
end)