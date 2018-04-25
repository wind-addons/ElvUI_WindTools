-- 原作：Leatrix Plus 的一个增强组件
-- 原作者：Leatrix (https://wow.curseforge.com/projects/leatrix-plus)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 增加设定项，且绑定于 ElvUI 配置

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local NoEffect = E:NewModule('NoEffect', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

P["WindTools"]["No Effect"] = {
	["enabled"] = true,
	["NoEffectsGlow"] = true,
	["NoEffectsDeath"] = true,
	["NoEffectsNether"] = true,
}

function NoEffect:Initialize()
	if not E.db.WindTools["No Effect"]["enabled"] then return end

	if E.db.WindTools["No Effect"]["NoEffectsGlow"] then
		SetCVar("ffxGlow", "0")
	else
		SetCVar("ffxGlow", "1")
	end

	if E.db.WindTools["No Effect"]["NoEffectsDeath"] then
		SetCVar("ffxDeath", "0")
	else
		SetCVar("ffxDeath", "1")
	end

	if E.db.WindTools["No Effect"]["NoEffectsNether"] then
		SetCVar("ffxNether", "0")
	else
		SetCVar("ffxNether", "1")
	end
end

local function InsertOptions()
	E.Options.args.WindTools.args["Visual"].args["No Effect"].args["GlowEffect"] = {
		order = 10,
		type = "group",
		name = L["Glow Effect"],
		args = {
			seteffect = {
				order = 1,
				type = "toggle",
				name = L["Disable"],
				get = function(info) return E.db.WindTools["No Effect"]["NoEffectsGlow"] end,
				set = function(info, value) E.db.WindTools["No Effect"]["NoEffectsGlow"] = value;E:StaticPopup_Show("PRIVATE_RL")end
			},
		}
	}
	E.Options.args.WindTools.args["Visual"].args["No Effect"].args["DeathEffect"] = {
		order = 11,
		type = "group",
		name = L["Death Effect"],
		args = {
			seteffect = {
				order = 1,
				type = "toggle",
				name = L["Disable"],
				get = function(info) return E.db.WindTools["No Effect"]["NoEffectsDeath"] end,
				set = function(info, value) E.db.WindTools["No Effect"]["NoEffectsDeath"] = value;E:StaticPopup_Show("PRIVATE_RL")end
			},
		}
	}
	E.Options.args.WindTools.args["Visual"].args["No Effect"].args["NetherEffect"] = {
		order = 12,
		type = "group",
		name = L["Nether Effect"],
		args = {
			seteffect = {
				order = 1,
				type = "toggle",
				name = L["Disable"],
				get = function(info) return E.db.WindTools["No Effect"]["NoEffectsNether"] end,
				set = function(info, value) E.db.WindTools["No Effect"]["NoEffectsNether"] = value;E:StaticPopup_Show("PRIVATE_RL")end
			},
		}
	}
end

WT.ToolConfigs["No Effect"] = InsertOptions
E:RegisterModule(NoEffect:GetName())