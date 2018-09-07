-- 原作：Leatrix Plus 的一个增强组件
-- 原作者：Leatrix (https://wow.curseforge.com/projects/leatrix-plus)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 增加速度设定项

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local FastLoot = E:NewModule('Wind_FastLoot');

function FastLoot:Initialize()
	if not E.db.WindTools["More Tools"]["Fast Loot"]["enabled"] then return end
	local faster = CreateFrame("Frame")
	faster:RegisterEvent("LOOT_READY")
	faster:SetScript("OnEvent",function()
		local tDelay = 0
		if GetTime() - tDelay >= 0.3 then
			tDelay = GetTime()
			if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
				for i = GetNumLootItems(), 1, -1 do
					LootSlot(i)
				end
				tDelay = GetTime()
			end
		end
	end)
end

local function InitializeCallback()
	FastLoot:Initialize()
end

E:RegisterModule(FastLoot:GetName(), InitializeCallback)