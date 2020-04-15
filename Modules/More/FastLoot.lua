-- 原作：Leatrix Plus 的一个增强组件
-- 原作者：Leatrix (https://wow.curseforge.com/projects/leatrix-plus)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 增加速度设定项

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local WT = E:GetModule("WindTools")
local FL = E:NewModule('Wind_FastLoot', 'AceEvent-3.0');

local GetTime = GetTime
local LootSlot = LootSlot
local GetCVarBool = GetCVarBool
local IsModifiedClick = IsModifiedClick

function FL:LOOT_READY()
	local tDelay = 0
	if GetTime() - tDelay >= self.db.speed then
		tDelay = GetTime()
		if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
			for i = GetNumLootItems(), 1, -1 do
				LootSlot(i)
			end
			tDelay = GetTime()
		end
	end
end

function FL:Initialize()
	if not E.db.WindTools["More Tools"]["Fast Loot"]["enabled"] then return end
	self.db = E.db.WindTools["More Tools"]["Fast Loot"]

	tinsert(WT.UpdateAll, function()
		FL.db = E.db.WindTools["More Tools"]["Fast Loot"]
	end)

	self:RegisterEvent("LOOT_READY")
end

local function InitializeCallback()
	FL:Initialize()
end

E:RegisterModule(FL:GetName(), InitializeCallback)