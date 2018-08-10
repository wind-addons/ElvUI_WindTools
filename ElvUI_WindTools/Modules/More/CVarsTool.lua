-- CVars 快速编辑
-- 作者：houshuu
-------------------

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local CVarsTool = E:NewModule('CVarsTool', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

-- 将部分值为 0/1 的 CVar 查询结果转换为布尔值
local function GetCVarBool(cvar)
	local current = GetCVar(cvar)
	if current == "1" then
		return true
	elseif current == "0" then
		return false
	else
		return nil
	end
end
-- 将布尔值转换为部分值为 0/1 的 CVar，并设定
local function SetCVarBool(cvar, value)
	if value then
		SetCVar(cvar, 1)
	else
		SetCVar(cvar, 0)
	end
end


-- function CVarsTool:Update()
-- 	if E.db.WindTools["CVarsTool"]["GlowEffect"] then
-- 		SetCVar("ffxGlow", "1")
-- 	else
-- 		SetCVar("ffxGlow", "0")
-- 	end

-- 	if E.db.WindTools["CVarsTool"]["DeathEffect"] then
-- 		SetCVar("ffxDeath", "1")
-- 	else
-- 		SetCVar("ffxDeath", "0")
-- 	end

-- 	if E.db.WindTools["CVarsTool"]["NetherEffect"] then
-- 		SetCVar("ffxNether", "1")
-- 	else
-- 		SetCVar("ffxNether", "0")
-- 	end

-- 	if E.db.WindTools["CVarsTool"]["AutoCompare"] then
-- 		SetCVar("alwaysCompareItems", "1")
-- 	else
-- 		SetCVar("alwaysCompareItems", "0")
-- 	end

-- 	if E.db.WindTools["CVarsTool"]["TooltipsTrack"] then
-- 		SetCVar("showQuestTrackingTooltips", "1")
-- 	else
-- 		SetCVar("showQuestTrackingTooltips", "0")
-- 	end

-- end

function CVarsTool:Initialize()
	-- if not E.db.WindTools["CVarsTool"]["enabled"] then return end
	-- self.Update()
end

local function InsertOptions()
	local Options = {
		EffectControl = {
			order = 11,
			type = "group",
			name = L["Effect Control"],
			guiInline = true,
			get = function(info) return GetCVarBool(info[#info]) end,
			set = function(info, value) SetCVarBool(info[#info], value) end,
			args = {
				ffxGlow = {
					order = 1,
					type = "toggle",
					name = L["Glow Effect"],
				},
				ffxDeath = {
					order = 2,
					type = "toggle",
					name = L["Death Effect"],
				},
				ffxNether = {
					order = 3,
					type = "toggle",
					name = L["Nether Effect"],
				},
			}
		},
		convenience = {
			order = 12,
			type = "group",
			name = L["Convenient Setting"],
			guiInline = true,
			get = function(info) return GetCVarBool(info[#info]) end,
			set = function(info, value) SetCVarBool(info[#info], value) end,
			args = {
				alwaysCompareItems = {
					order = 1,
					type = "toggle",
					name = L["Auto Compare"],
				},
				showQuestTrackingTooltips = {
					order = 2,
					type = "toggle",
					name = L["Tooltips quest info"],
				}
			}
		},
		fix = {
			order = 13,
			type = "group",
			name = L["Fix Problem"],
			guiInline = true,
			get = function(info) return GetCVarBool(info[#info]) end,
			set = function(info, value) SetCVarBool(info[#info], value) end,
			args = {
				rawMouseEnable = {
					order = 1,
					type = "toggle",
					name = L["Raw Mouse"],
				},
				rawMouseAccelerationEnable  = {
					order = 2,
					type = "toggle",
					name = L["Raw Mouse Acceleration"],
				}
			}
		},
	}

	for k, v in pairs(Options) do
		E.Options.args.WindTools.args["More Tools"].args["CVarsTool"].args[k] = v
	end

	E.Options.args.WindTools.args["More Tools"].args["CVarsTool"].args["enablebtn"] = {
		order = 4,
		type = "description",
		name = "\n",
	}
end

WT.ToolConfigs["CVarsTool"] = InsertOptions
E:RegisterModule(CVarsTool:GetName())