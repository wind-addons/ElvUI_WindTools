-- 原作：Leatrix Plus 的一个增强组件
-- 原作者：Leatrix (https://wow.curseforge.com/projects/leatrix-plus)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 增加速度设定项

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local FastLoot = E:NewModule('FastLoot', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

P["WindTools"]["Fast Loot"] = {
	["enabled"] = true,
	["speed"] = 0.3,
}

function FastLoot:Initialize()
	if not E.db.WindTools["Fast Loot"]["enabled"] then return end
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

local function InsertOptions()
	local Options = {
		setspeed = {
			order = 11,
			type = "range",
			name = L["Fast Loot Speed"],
			min = 0.1, max = 0.5, step = 0.1,
			get = function(info) return E.db.WindTools["Fast Loot"]["speed"] end,
			set = function(info, value) E.db.WindTools["Fast Loot"]["speed"] = value;end
		},
		setspeeddesc = {
			order = 12,
			type = "description",
			name = L["Default is 0.3, DO NOT change it unless Fast Loot is not worked."],
		}
	}

	for k, v in pairs(Options) do
		E.Options.args.WindTools.args["More Tools"].args["Fast Loot"].args[k] = v
	end
end
WT.ToolConfigs["Fast Loot"] = InsertOptions
E:RegisterModule(FastLoot:GetName())