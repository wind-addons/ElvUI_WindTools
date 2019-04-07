-- 简单阴影
-- 考虑到效能，不会添加通用函数来加阴影
-- 作者：houshuu
local E, L, V, P, G = unpack(ElvUI)
local WT         = E:GetModule("WindTools")
local A          = E:GetModule('Auras')
local UF         = E:GetModule('UnitFrames')
local TT         = E:GetModule('Tooltip')
local EasyShadow = E:NewModule('Wind_EasyShadow')
local ElvUF      = ElvUF
local LSM        = LibStub("LibSharedMedia-3.0")
local _G         = _G

-- 初始化颜色
local borderr, borderg, borderb = 0, 0, 0
local backdropr, backdropg, backdropb = 0, 0, 0

-- 不需要检测插件载入即可上阴影的框体
EasyShadow.BlzFrames = {
	["MMHolder"] = L["MiniMap"],
	["GameMenuFrame"] = L["Game Menu"],
	["InterfaceOptionsFrame"] = L["Interface Options"],
	["VideoOptionsFrame"] = L["Video Options"],
}

EasyShadow.ElvUIActionbars = {
	["ElvUI_Bar1Button"] = L["Action Bar"].." 1",
	["ElvUI_Bar2Button"] = L["Action Bar"].." 2",
	["ElvUI_Bar3Button"] = L["Action Bar"].." 3",
	["ElvUI_Bar4Button"] = L["Action Bar"].." 4",
	["ElvUI_Bar5Button"] = L["Action Bar"].." 5",
	["ElvUI_Bar6Button"] = L["Action Bar"].." 6",
	["ElvUI_StanceBarButton"] = L["StanceBar"],
}

EasyShadow.ElvUIFrames = {
	["Aura"] = L["Auras"],
	["Castbar"] = L["Cast Bar"],
	["CastbarIcon"] = L["Cast Bar Icon"],
	["UnitFrames"] = L["Unit Frames"],
	["Classbar"] = L["Class Bar"],
	["UnitFrameAura"] = L["Unit Frame Aura"],
	["QuestIconShadow"] = L["Quest Icon"],
	["Tooltip"] = L["Game Tooltip"],
}

local function CreateMyShadow(frame, size, backalpha, borderalpha)
	if not frame or frame.shadow then return end
	local back = backalpha or 0.5
	local border = backalpha or 0.6

	local shadow = CreateFrame("Frame", nil, frame)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(frame:GetFrameStrata())
	shadow:SetOutside(frame, size, size)
	shadow:SetBackdrop({
		edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = E:Scale(size),
		insets = {left = E:Scale(size), right = E:Scale(size), top = E:Scale(size), bottom = E:Scale(size)},
	})
	shadow:SetBackdropColor(backdropr, backdropg, backdropb, back)
	shadow:SetBackdropBorderColor(borderr, borderg, borderb, border)

	frame.shadow = shadow
end

-- 来自 NDui by siweia
local function shadowQuestIcon(_, block)
	local itemButton = block.itemButton
	if itemButton and not itemButton.styled then
		CreateMyShadow(itemButton, 3)
		itemButton.styled = true
	end
	local rightButton = block.rightButton
	if rightButton and not rightButton.styled then
		CreateMyShadow(rightButton, 3)
		rightButton.styled = true
	end
end

function EasyShadow:ShadowBlzFrames()
	if not self.db then return end
	for k, v in pairs(self.BlzFrames) do
		if self.db.BlzFrames[k] then CreateMyShadow(_G[k], 3) end
	end
	
end

function EasyShadow:ShadowElvUIActionbars()
	if not self.db then return end
	for k, v in pairs(self.ElvUIActionbars) do
		if self.db.ElvUIActionbars[k] then 
			for i = 1, 12 do CreateMyShadow(_G[k..i], 3) end
		end
	end
end

function EasyShadow:ShadowElvUIFrames()
	if not self.db then return end
	CreateMyShadow(_G["ElvUI_AzeriteBar"], 3)

	if self.db.ElvUIFrames.Aura then
		hooksecurefunc(A, "CreateIcon", function(self, button)
			CreateMyShadow(button, 4)
		end)
		hooksecurefunc(A, "UpdateAura", function(self, button, index)
			CreateMyShadow(button, 4)
		end)
	end

	if self.db.ElvUIFrames.QuestIconShadow then
		hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", shadowQuestIcon)
		hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", shadowQuestIcon)
	end

	if self.db.ElvUIFrames.UnitFrames then
		hooksecurefunc(UF, "UpdateNameSettings", function(_, frame)
			CreateMyShadow(frame, 4, 0.5, 0.8)
		end)
	end

	if self.db.ElvUIFrames.Castbar then
		hooksecurefunc(UF, "Configure_Castbar", function(_, frame)
			CreateMyShadow(frame.Castbar, 3)
		end)
	end

	if self.db.ElvUIFrames.CastbarIcon then
		hooksecurefunc(UF, "Configure_Castbar", function(_, frame)
			CreateMyShadow(frame.Castbar.ButtonIcon.bg, 3)
		end)	
	end

	if self.db.ElvUIFrames.UnitFrameAura then
		hooksecurefunc(UF, "UpdateAuraSettings", function(_,  _, button)
			CreateMyShadow(button, 2, 0.5, 1)
		end)
	end

	if self.db.ElvUIFrames.Classbar then
		hooksecurefunc(UF, "Configure_ClassBar", function(_, frame)
			local bars = frame[frame.ClassBar]
			if not bars then return end
			CreateMyShadow(bars, 4, 0.5, 0.8)
		end)
	end
	
	if self.db.ElvUIFrames.Tooltip then
		hooksecurefunc(TT, "SetStyle", function(_, tt)
			CreateMyShadow(tt, 4)
		end)
		hooksecurefunc(TT, "GameTooltip_SetDefaultAnchor", function(_, tt)
			if tt:IsForbidden() then return end
			if E.private.tooltip.enable ~= true then return end
			CreateMyShadow(_G["GameTooltipStatusBar"], 4, 0.8, 0)
		end)
	end
end

function EasyShadow:Initialize()
	self.db = E.db.WindTools["Interface"]["EasyShadow"]
	if not self.db["enabled"] then return end
	
	self:ShadowBlzFrames()
	self:ShadowElvUIActionbars()
	self:ShadowElvUIFrames()
end

local function InitializeCallback()
	EasyShadow:Initialize()
end
E:RegisterModule(EasyShadow:GetName(), InitializeCallback)