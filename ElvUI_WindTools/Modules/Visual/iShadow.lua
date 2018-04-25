-- 原作：iShadow
-- 原作者：Selias2k(https://wow.curseforge.com/projects/ishadow)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 精简代码，移动设定项绑定 ElvUI 配置

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local iShadow = E:NewModule('iShadow', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

P["WindTools"]["iShadow"] = {
	["enabled"] = true,
	["level"] = 50,
}

function iShadow:SetShadowLevel(n)
	self.f:SetAlpha(n/100)
end

function iShadow:Initialize()
	if not E.db.WindTools["iShadow"]["enabled"] then return end

	self.f = CreateFrame("Frame", "ShadowBackground")
	self.f:SetPoint("TOPLEFT")
	self.f:SetPoint("BOTTOMRIGHT")
	self.f:SetFrameLevel(0)
	self.f:SetFrameStrata("BACKGROUND")
	self.f.tex = self.f:CreateTexture()
	self.f.tex:SetTexture([[Interface\Addons\ElvUI_WindTools\Texture\shadow.tga]])
	self.f.tex:SetAllPoints(f)

	self:SetShadowLevel((E.db.WindTools["iShadow"]["level"] or 50))
end


local function InsertOptions()
	E.Options.args.WindTools.args["Visual"].args["iShadow"].args["additionalconfig"] = {
		order = 10,
		type = "group",
		name = L["Shadow Level"],
		args = {
			setlevel = {
				order = 1,
				type = "range",
				name = L["Shadow Level"],
				min = 1, max = 100, step = 1,
				get = function(info) return E.db.WindTools["iShadow"]["level"] end,
				set = function(info, value) E.db.WindTools["iShadow"]["level"] = value;E:StaticPopup_Show("PRIVATE_RL")end
			},
			setleveldesc = {
				order = 2,
				type = "description",
				name = L["Default is 50."],
			}
		}
	}
end

WT.ToolConfigs["iShadow"] = InsertOptions
E:RegisterModule(iShadow:GetName())