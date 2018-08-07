-- 作者：houshuu
local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local EasyShadow = E:NewModule('EasyShadow')
local ElvUF = ElvUF
local LSM = LibStub("LibSharedMedia-3.0")
local addonName, addonTable = ...
local _G = _G

-- Default options
P["WindTools"]["EasyShadow"] = {
	["enabled"] = true,
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

function EasyShadow:CreateMyShadow(frame, size)
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
		Bar1 = {
			order = 11,
			type = "toggle",
			name = L["Bar 1"],
			get = function(info)
				return E.db.WindTools["EasyShadow"]["Bar1"]
			end,
			set = function(info, value)
				E.db.WindTools["EasyShadow"]["Bar1"] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		Bar2 = {
			order = 12,
			type = "toggle",
			name = L["Bar 2"],
			get = function(info)
				return E.db.WindTools["EasyShadow"]["Bar2"]
			end,
			set = function(info, value)
				E.db.WindTools["EasyShadow"]["Bar2"] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		Bar3 = {
			order = 13,
			type = "toggle",
			name = L["Bar 3"],
			get = function(info)
				return E.db.WindTools["EasyShadow"]["Bar3"]
			end,
			set = function(info, value)
				E.db.WindTools["EasyShadow"]["Bar3"] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		Bar4 = {
			order = 14,
			type = "toggle",
			name = L["Bar 4"],
			get = function(info)
				return E.db.WindTools["EasyShadow"]["Bar4"]
			end,
			set = function(info, value)
				E.db.WindTools["EasyShadow"]["Bar4"] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		Bar5 = {
			order = 15,
			type = "toggle",
			name = L["Bar 5"],
			get = function(info)
				return E.db.WindTools["EasyShadow"]["Bar5"]
			end,
			set = function(info, value)
				E.db.WindTools["EasyShadow"]["Bar5"] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		Bar6 = {
			order = 16,
			type = "toggle",
			name = L["Bar 6"],
			get = function(info)
				return E.db.WindTools["EasyShadow"]["Bar6"]
			end,
			set = function(info, value)
				E.db.WindTools["EasyShadow"]["Bar6"] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		GameTooltip = {
			order = 17,
			type = "toggle",
			name = L["Game Tooltip"],
			get = function(info)
				return E.db.WindTools["EasyShadow"]["GameTooltip"]
			end,
			set = function(info, value)
				E.db.WindTools["EasyShadow"]["GameTooltip"] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		MiniMap = {
			order = 18,
			type = "toggle",
			name = L["MiniMap"],
			get = function(info)
				return E.db.WindTools["EasyShadow"]["MiniMap"]
			end,
			set = function(info, value)
				E.db.WindTools["EasyShadow"]["MiniMap"] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		GameMenu = {
			order = 19,
			type = "toggle",
			name = L["Game Menu"],
			get = function(info)
				return E.db.WindTools["EasyShadow"]["GameMenu"]
			end,
			set = function(info, value)
				E.db.WindTools["EasyShadow"]["GameMenu"] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		InterfaceOptions = {
			order = 20,
			type = "toggle",
			name = L["Interface Options"],
			get = function(info)
				return E.db.WindTools["EasyShadow"]["InterfaceOptions"]
			end,
			set = function(info, value)
				E.db.WindTools["EasyShadow"]["InterfaceOptions"] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		VideoOptions = {
			order = 21,
			type = "toggle",
			name = L["Video Options"],
			get = function(info)
				return E.db.WindTools["EasyShadow"]["VideoOptions"]
			end,
			set = function(info, value)
				E.db.WindTools["EasyShadow"]["VideoOptions"] = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		}
	}

	for k, v in pairs(Options) do
		E.Options.args.WindTools.args["Visual"].args["EasyShadow"].args[k] = v
	end
end

function EasyShadow:Update()
	if E.db.WindTools["EasyShadow"]["GameTooltip"] then
		local frame = _G["GameTooltip"]
		self:CreateMyShadow(frame, 3)
	end

	if E.db.WindTools["EasyShadow"]["MiniMap"] then
		local frame = _G["MMHolder"]
		self:CreateMyShadow(frame, 5)
	end

	if E.db.WindTools["EasyShadow"]["GameMenu"] then
		local frame = _G["GameMenuFrame"]
		self:CreateMyShadow(frame, 5)
	end

	if E.db.WindTools["EasyShadow"]["InterfaceOptions"] then
		local frame = _G["InterfaceOptionsFrame"]
		self:CreateMyShadow(frame, 5)
	end

	if E.db.WindTools["EasyShadow"]["VideoOptions"] then
		local frame = _G["VideoOptionsFrame"]
		self:CreateMyShadow(frame, 5)
	end

	if E.db.WindTools["EasyShadow"]["Bar1"] then
		for i = 1, 12 do
			local frame = _G["ElvUI_Bar1Button"..i]
			self:CreateMyShadow(frame, 4)
		end
	end

	if E.db.WindTools["EasyShadow"]["Bar2"] then
		for i = 1, 12 do
			local frame = _G["ElvUI_Bar2Button"..i]
			self:CreateMyShadow(frame, 4)
		end
	end

	if E.db.WindTools["EasyShadow"]["Bar3"] then
		for i = 1, 12 do
			local frame = _G["ElvUI_Bar3Button"..i]
			self:CreateMyShadow(frame, 4)
		end
	end

	if E.db.WindTools["EasyShadow"]["Bar4"] then
		for i = 1, 12 do
			local shadowframe = _G["ElvUI_Bar4Button"..i]
			self:CreateMyShadow(shadowframe, 4)
		end
	end

	if E.db.WindTools["EasyShadow"]["Bar5"] then
		for i = 1, 12 do
			local shadowframe = _G["ElvUI_Bar5Button"..i]
			self:CreateMyShadow(shadowframe, 4)
		end
	end

	if E.db.WindTools["EasyShadow"]["Bar6"] then
		for i = 1, 12 do
			local shadowframe = _G["ElvUI_Bar6Button"..i]
			self:CreateMyShadow(shadowframe, 4)
		end
	end
end

function EasyShadow:Initialize()
	if not E.db.WindTools["EasyShadow"]["enabled"] then return end
	self:Update()
end

WT.ToolConfigs["EasyShadow"] = InsertOptions
E:RegisterModule(EasyShadow:GetName())