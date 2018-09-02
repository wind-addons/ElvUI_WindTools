-- 原作：iShadow
-- 原作者：Selias2k(https://wow.curseforge.com/projects/ishadow)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 精简代码，移动设定项绑定 ElvUI 配置

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local iShadow = E:NewModule('Wind_iShadow', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

function iShadow:SetShadowLevel(n)
	self.f:SetAlpha(n/100)
end

function iShadow:Initialize()
	if not E.db.WindTools["Interface"]["iShadow"]["enabled"] then return end

	self.f = CreateFrame("Frame", "ShadowBackground")
	self.f:SetPoint("TOPLEFT")
	self.f:SetPoint("BOTTOMRIGHT")
	self.f:SetFrameLevel(0)
	self.f:SetFrameStrata("BACKGROUND")
	self.f.tex = self.f:CreateTexture()
	self.f.tex:SetTexture([[Interface\Addons\ElvUI_WindTools\Texture\shadow.tga]])
	self.f.tex:SetAllPoints(f)

	self:SetShadowLevel((E.db.WindTools["Interface"]["iShadow"]["level"] or 50))
end

local function InitializeCallback()
	iShadow:Initialize()
end
E:RegisterModule(iShadow:GetName(), InitializeCallback)