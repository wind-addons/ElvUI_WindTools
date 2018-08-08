-- 作者：houshuu
local E, L, V, P, G = unpack(ElvUI)
local WT         = E:GetModule("WindTools")
local A          = E:GetModule('Auras')
local EasyShadow = E:NewModule('EasyShadow')
local ElvUF      = ElvUF
local LSM        = LibStub("LibSharedMedia-3.0")
local addonName,  addonTable = ...
local _G         = _G

-- Default options
P["WindTools"]["EasyShadow"] = {
	["enabled"] = true,
	["AuraShadow"] = true,
	["QuestIconShadow"] = true,
	["Bar1"] = false,
	["Bar2"] = false,
	["Bar3"] = false,
	["Bar4"] = false,
	["Bar5"] = false,
	["Bar6"] = false,
	["GameTooltip"] = true,
	["MiniMap"] = true,
	["GameMenu"] = true,
	["InterfaceOptions"] = true,
	["VideoOptions"] = true,
}

-- 选择你喜欢的颜色
local borderr, borderg, borderb = 0, 0, 0
local backdropr, backdropg, backdropb = 0, 0, 0

local function CreateMyShadow(frame, size)
	local shadow = CreateFrame("Frame", nil, frame)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(frame:GetFrameStrata())
	shadow:SetOutside(frame, size, size)
	shadow:SetBackdrop({
		edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = E:Scale(5),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})
	shadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	shadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.8)
	frame.shadow = shadow
end

local function InsertOptions()
	local Options = {
		Actionbar = {
			order = 11,
			type = "group",
			name = L["ActionBars"],
			guiInline = true,
			get = function(info) return E.db.WindTools["EasyShadow"][info[#info]] end,
			set = function(info, value) E.db.WindTools["EasyShadow"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {
				Bar1 = {
					order = 1,
					type = "toggle",
					name = L["ActionBars"].."1",
				},
				Bar2 = {
					order = 2,
					type = "toggle",
					name = L["ActionBars"].."2",
				},
				Bar3 = {
					order = 1,
					type = "toggle",
					name = L["ActionBars"].."3",
				},
				Bar4 = {
					order = 4,
					type = "toggle",
					name = L["ActionBars"].."4",
				},
				Bar5 = {
					order = 5,
					type = "toggle",
					name = L["ActionBars"].."5",
				},
				Bar6 = {
					order = 6,
					type = "toggle",
					name = L["ActionBars"].."6",
				},
			}
		},
		Menus = {
			order = 12,
			type = "group",
			name = L["Game Menu"],
			guiInline = true,
			get = function(info) return E.db.WindTools["EasyShadow"][info[#info]] end,
			set = function(info, value) E.db.WindTools["EasyShadow"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {
				GameTooltip = {
					order = 1,
					type = "toggle",
					name = L["Game Tooltip"],
				},
				MiniMap = {
					order = 2,
					type = "toggle",
					name = L["MiniMap"],
				},
				GameMenu = {
					order = 3,
					type = "toggle",
					name = L["Game Menu"],
				},
				InterfaceOptions = {
					order = 4,
					type = "toggle",
					name = L["Interface Options"],
				},
				VideoOptions = {
					order = 5,
					type = "toggle",
					name = L["Video Options"],
				}
			}
		},
		Others = {
			order = 13,
			type = "group",
			name = L["Other Setting"],
			guiInline = true,
			get = function(info) return E.db.WindTools["EasyShadow"][info[#info]] end,
			set = function(info, value) E.db.WindTools["EasyShadow"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			args = {
				AuraShadow = {
					order = 1,
					type = "toggle",
					name = L["Auras"],
				},
				QuestIconShadow = {
					order = 2,
					type = "toggle",
					name = L["Quest Icon"],
				},
			}
		}
	}

	for k, v in pairs(Options) do
		E.Options.args.WindTools.args["Interface"].args["EasyShadow"].args[k] = v
	end
end

function EasyShadow:Update()
	if E.db.WindTools["EasyShadow"]["GameTooltip"] then
		local frame = _G["GameTooltip"]
		CreateMyShadow(frame, 3)
	end

	if E.db.WindTools["EasyShadow"]["MiniMap"] then
		local frame = _G["MMHolder"]
		CreateMyShadow(frame, 5)
	end

	if E.db.WindTools["EasyShadow"]["GameMenu"] then
		local frame = _G["GameMenuFrame"]
		CreateMyShadow(frame, 5)
	end

	if E.db.WindTools["EasyShadow"]["InterfaceOptions"] then
		local frame = _G["InterfaceOptionsFrame"]
		CreateMyShadow(frame, 5)
	end

	if E.db.WindTools["EasyShadow"]["VideoOptions"] then
		local frame = _G["VideoOptionsFrame"]
		CreateMyShadow(frame, 5)
	end

	if E.db.WindTools["EasyShadow"]["Bar1"] then
		for i = 1, 12 do
			local frame = _G["ElvUI_Bar1Button"..i]
			CreateMyShadow(frame, 4)
		end
	end

	if E.db.WindTools["EasyShadow"]["Bar2"] then
		for i = 1, 12 do
			local frame = _G["ElvUI_Bar2Button"..i]
			CreateMyShadow(frame, 4)
		end
	end

	if E.db.WindTools["EasyShadow"]["Bar3"] then
		for i = 1, 12 do
			local frame = _G["ElvUI_Bar3Button"..i]
			CreateMyShadow(frame, 4)
		end
	end

	if E.db.WindTools["EasyShadow"]["Bar4"] then
		for i = 1, 12 do
			local shadowframe = _G["ElvUI_Bar4Button"..i]
			CreateMyShadow(shadowframe, 4)
		end
	end

	if E.db.WindTools["EasyShadow"]["Bar5"] then
		for i = 1, 12 do
			local shadowframe = _G["ElvUI_Bar5Button"..i]
			CreateMyShadow(shadowframe, 4)
		end
	end

	if E.db.WindTools["EasyShadow"]["Bar6"] then
		for i = 1, 12 do
			local shadowframe = _G["ElvUI_Bar6Button"..i]
			CreateMyShadow(shadowframe, 4)
		end
	end
end

local function shadowQuestIcon(_, block)
	local itemButton = block.itemButton
	if itemButton and not itemButton.styled then
		itemButton:CreateShadow()
		itemButton.styled = true
	end
	local rightButton = block.rightButton
	if rightButton and not rightButton.styled then
		rightButton:CreateShadow()
		rightButton.styled = true
	end
end

function EasyShadow:Initialize()
	if not E.db.WindTools["EasyShadow"]["enabled"] then return end
	self:Update()
	if E.db.WindTools["EasyShadow"]["AuraShadow"] then
		hooksecurefunc(A, "CreateIcon", function(self, button)
			if not button.shadowed then
				button:CreateShadow()
				button.shadowed = true
			end
		end)
		hooksecurefunc(A, "UpdateAura", function(self, button, index)
			if not button.shadowed then
				button:CreateShadow()
				button.shadowed = true
			end
		end)
	end

	if E.db.WindTools["EasyShadow"]["QuestIconShadow"] then
		hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", shadowQuestIcon)
		hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", shadowQuestIcon)
	end
end

WT.ToolConfigs["EasyShadow"] = InsertOptions
E:RegisterModule(EasyShadow:GetName())