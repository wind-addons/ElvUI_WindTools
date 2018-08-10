-- CVars 快速编辑
-- 作者：houshuu
-------------------

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local CVarsTool = E:NewModule('CVarsTool', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

P["WindTools"]["CVarsTool"] = {
	["enabled"] = false,
	["GlowEffect"] = false,
	["DeathEffect"] = false,
	["NetherEffect"] = false,
	["AutoCompare"] = true,
	["TooltipsTrack"] = true,
}

function CVarsTool:Update()
	if E.db.WindTools["CVarsTool"]["GlowEffect"] then
		SetCVar("ffxGlow", "1")
	else
		SetCVar("ffxGlow", "0")
	end

	if E.db.WindTools["CVarsTool"]["DeathEffect"] then
		SetCVar("ffxDeath", "1")
	else
		SetCVar("ffxDeath", "0")
	end

	if E.db.WindTools["CVarsTool"]["NetherEffect"] then
		SetCVar("ffxNether", "1")
	else
		SetCVar("ffxNether", "0")
	end

	if E.db.WindTools["CVarsTool"]["AutoCompare"] then
		SetCVar("alwaysCompareItems", "1")
	else
		SetCVar("alwaysCompareItems", "0")
	end

	if E.db.WindTools["CVarsTool"]["TooltipsTrack"] then
		SetCVar("showQuestTrackingTooltips", "1")
	else
		SetCVar("showQuestTrackingTooltips", "0")
	end

end

function CVarsTool:Initialize()
	if not E.db.WindTools["CVarsTool"]["enabled"] then return end
	self.Update()
end

local function InsertOptions()
	local Options = {
		CVarsTool = {
			order = 11,
			type = "group",
			name = L["Effect Control"],
			guiInline = true,
			get = function(info) return E.db.WindTools["CVarsTool"][info[#info]] end,
			set = function(info, value) E.db.WindTools["CVarsTool"][info[#info]] = value; CVarsTool:Update() end,
			args = {
				GlowEffect = {
					order = 1,
					type = "toggle",
					name = L["Glow Effect"],
				},
				DeathEffect = {
					order = 2,
					type = "toggle",
					name = L["Death Effect"],
				},
				NetherEffect = {
					order = 3,
					type = "toggle",
					name = L["Nether Effect"],
				},
			}
		},
		convenience = {
			order = 11,
			type = "group",
			name = L["Convenient Setting"],
			guiInline = true,
			get = function(info) return E.db.WindTools["CVarsTool"][info[#info]] end,
			set = function(info, value) E.db.WindTools["CVarsTool"][info[#info]] = value; CVarsTool:Update() end,
			args = {
				AutoCompare = {
					order = 1,
					type = "toggle",
					name = L["Auto Compare"],
				},
				TooltipsTrack = {
					order = 2,
					type = "toggle",
					name = L["Tooltips quest info"],
				}
			}
		},
	}

	for k, v in pairs(Options) do
		E.Options.args.WindTools.args["More Tools"].args["CVarsTool"].args[k] = v
	end
end

WT.ToolConfigs["CVarsTool"] = InsertOptions
E:RegisterModule(CVarsTool:GetName())