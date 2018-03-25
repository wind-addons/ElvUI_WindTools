-- 关闭部分效果
-- 原作者：Leatrix
-- 修改：houshuu

----------------------------------------------------------------------
-- Manage effects
----------------------------------------------------------------------

-- 效果开关
local NoEffectsGlow = "On"
local NoEffectsDeath = "On"
local NoEffectsNether = "On"

-- Function to set effects
local function SetEffects()
	if NoEffectsGlow == "On" then
		SetCVar("ffxGlow", "0")
	else
		SetCVar("ffxGlow", "1")
	end
	if NoEffectsDeath == "On" then
		SetCVar("ffxDeath", "0")
	else
		SetCVar("ffxDeath", "1")
	end
	if NoEffectsNether == "On" then
		SetCVar("ffxNether", "0")
	else
		SetCVar("ffxNether", "1")
	end
end