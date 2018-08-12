-- 简单阴影
-- 考虑到效能，不会添加通用函数来加阴影
-- 作者：houshuu
local E, L, V, P, G = unpack(ElvUI)
local WT         = E:GetModule("WindTools")
local A          = E:GetModule('Auras')
local UF         = E:GetModule('UnitFrames');
local EasyShadow = E:NewModule('EasyShadow')
local ElvUF      = ElvUF
local LSM        = LibStub("LibSharedMedia-3.0")
local _G         = _G

-- Default options
P["WindTools"]["EasyShadow"] = {
	["enabled"] = true,
	["BlzFrames"] = {
		["GameTooltip"] = true,
		["MMHolder"] = true,
		["GameMenuFrame"] = true,
		["InterfaceOptionsFrame"] = true,
		["VideoOptionsFrame"] = true,
	},
	["ElvUIActionbars"] = {
		["ElvUI_Bar1Button"] = false,
		["ElvUI_Bar2Button"] = false,
		["ElvUI_Bar3Button"] = false,
		["ElvUI_Bar4Button"] = false,
		["ElvUI_Bar5Button"] = false,
		["ElvUI_Bar6Button"] = false,
	},
	["ElvUIFrames"] = {
		["Aura"] = true,
		["Castbar"] = false,
		["CastbarIcon"] = false,
		["Classbar"] = false,
		["UnitFrameAura"] = false,
		["UnitFrames"] = false,
		["QuestIconShadow"] = true,
	}
}

-- 初始化颜色
local borderr, borderg, borderb = 0, 0, 0
local backdropr, backdropg, backdropb = 0, 0, 0

-- 不需要检测插件载入即可上阴影的框体
EasyShadow.BlzFrames = {
	["GameTooltip"] = L["Game Tooltip"],
	["MMHolder"] = L["MiniMap"],
	["GameMenuFrame"] = L["Game Menu"],
	["InterfaceOptionsFrame"] = L["Interface Options"],
	["VideoOptionsFrame"] = L["Video Options"],
}

EasyShadow.ElvUIActionbars = {
	["ElvUI_Bar1Button"] = L["ActionBar"].." 1",
	["ElvUI_Bar2Button"] = L["ActionBar"].." 2",
	["ElvUI_Bar3Button"] = L["ActionBar"].." 3",
	["ElvUI_Bar4Button"] = L["ActionBar"].." 4",
	["ElvUI_Bar5Button"] = L["ActionBar"].." 5",
	["ElvUI_Bar6Button"] = L["Actionbar"].." 6",
}

EasyShadow.ElvUIFrames = {
	["Aura"] = L["Auras"],
	["Castbar"] = L["Cast Bar"],
	["CastbarIcon"] = L["Cast Bar Icon"],
	["UnitFrames"] = L["Unit Frames"],
	["Classbar"] = L["Class Bar"],
	["UnitFrameAura"] = L["Unit Frame Aura"],
	["QuestIconShadow"] = L["Quest Icon"],
}

local function CreateMyShadow(frame, size)
	if frame.shadow then return end

	local shadow = CreateFrame("Frame", nil, frame)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(frame:GetFrameStrata())
	shadow:SetOutside(frame, size, size)
	shadow:SetBackdrop({
		edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = E:Scale(size),
		insets = {left = E:Scale(size), right = E:Scale(size), top = E:Scale(size), bottom = E:Scale(size)},
	})
	shadow:SetBackdropColor(backdropr, backdropg, backdropb, .5)
	shadow:SetBackdropBorderColor(borderr, borderg, borderb, .6)

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

local function InsertOptions()
	local profile = E.db.WindTools["EasyShadow"]

	local Options = {
		BlzFrames = {
			order = 11,
			type = "group",
			name = L["Game Menu"],
			guiInline = true,
			disabled = not profile.enabled,
			get = function(info) return profile.BlzFrames[info[#info]] end,
			set = function(info, value) profile.BlzFrames[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {}
		},
		ElvUIActionbars = {
			order = 12,
			type = "group",
			name = L["ActionBars"],
			guiInline = true,
			disabled = not profile.enabled,
			get = function(info) return profile.ElvUIActionbars[info[#info]] end,
			set = function(info, value) profile.ElvUIActionbars[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {}
		},
		ElvUIFrames = {
			order = 13,
			type = "group",
			name = "ElvUI"..L["Frame Setting"],
			guiInline = true,
			disabled = not profile.enabled,
			get = function(info) return profile.ElvUIFrames[info[#info]] end,
			set = function(info, value) profile.ElvUIFrames[info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {}
		}
	}

	local optOrder = 1
	for k, v in pairs(EasyShadow.BlzFrames) do
		Options.BlzFrames.args[k]={
			order = optOrder,
			type = "toggle",
			name = v,
		}
		optOrder = optOrder + 1
	end

	for i = 1, 6 do
		Options.ElvUIActionbars.args["ElvUI_Bar"..i.."Button"] = {
			order = i,
			type = "toggle",
			name = L["Action Bar"]..i,
		}
	end

	optOrder = 1
	for k, v in pairs(EasyShadow.ElvUIFrames) do
		Options.ElvUIFrames.args[k]={
			order = optOrder,
			type = "toggle",
			name = v,
		}
		optOrder = optOrder + 1
	end

	for k, v in pairs(Options) do
		E.Options.args.WindTools.args["Interface"].args["EasyShadow"].args[k] = v
	end
end

function EasyShadow:ShadowBlzFrames()
	if not self.db then return end
	for k, v in pairs(self.BlzFrames) do
		if self.db.BlzFrames[k] then
			CreateMyShadow(_G[k], 5)
			-- 鼠标提示信息存在多个框体
			-- TODO: 目前还少一个对比装备的框体
			if k == "GameTooltip" then CreateMyShadow(_G["ItemRefTooltip"], 5) end
		end
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
			CreateMyShadow(frame, 4)
		end)
	end

	if self.db.ElvUIFrames.Castbar then
		hooksecurefunc(UF, "Configure_Castbar", function(_, frame)
			CreateMyShadow(frame.Castbar, 4)
		end)
	end

	if self.db.ElvUIFrames.CastbarIcon then
		hooksecurefunc(UF, "Configure_Castbar", function(_, frame)
			CreateMyShadow(frame.Castbar.ButtonIcon.bg, 2)
		end)	
	end

	if self.db.ElvUIFrames.UnitFrameAura then
		hooksecurefunc(UF, "AuraIconUpdate", function(_, _, _, button)
			CreateMyShadow(button, 2)
		end)	
	end

	if self.db.ElvUIFrames.Classbar then
		hooksecurefunc(UF, "Configure_ClassBar", function(_, frame)
			local bars = frame[frame.ClassBar]
			if not bars then return end
			CreateMyShadow(bars, 4)
		end)
	end	
end

function EasyShadow:Initialize()
	self.db = E.db.WindTools["EasyShadow"]
	if not E.db.WindTools["EasyShadow"]["enabled"] then return end
	self:ShadowBlzFrames()
	self:ShadowElvUIActionbars()
	self:ShadowElvUIFrames()
end

WT.ToolConfigs["EasyShadow"] = InsertOptions
E:RegisterModule(EasyShadow:GetName())