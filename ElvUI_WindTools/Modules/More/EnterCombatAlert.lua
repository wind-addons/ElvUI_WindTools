-- 原作：TinyUntitled 的 Player lua中的一段
-- loudsoul (http://bbs.ngacn.cc/read.php?tid=10240957)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 增加自定义文字设定项

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local EnterCombatAlert = E:NewModule('EnterCombatAlert');

P["WindTools"]["Enter Combat Alert"] = {
	["enabled"] = true,
	["custom_text"] = false,
	["custom_text_enter"] = "",
	["custom_text_leave"] = "",
	["scale"] = 0.65,
}

function EnterCombatAlert:Initialize()
	if not E.db.WindTools["Enter Combat Alert"]["enabled"] then return end
	local locale = GetLocale()
	local enterCombat = L["Enter Combat"]
	local leaveCombat = L["Leave Combat"]
	
	if E.db.WindTools["Enter Combat Alert"]["custom_text"] then
		enterCombat = E.db.WindTools["Enter Combat Alert"]["custom_text_enter"]
		leaveCombat = E.db.WindTools["Enter Combat Alert"]["custom_text_leave"]
	end

	local alertFrame = CreateFrame("Frame")
	alertFrame:SetSize(400, 65)
	alertFrame:SetPoint("TOP", 0, -280)
	alertFrame:SetScale(E.db.WindTools["Enter Combat Alert"]["scale"])
	alertFrame:Hide()
	alertFrame.Bg = alertFrame:CreateTexture(nil, "BACKGROUND")
	alertFrame.Bg:SetTexture("Interface\\LevelUp\\MinorTalents")
	alertFrame.Bg:SetPoint("TOP")
	alertFrame.Bg:SetSize(400, 67)
	alertFrame.Bg:SetTexCoord(0, 400/512, 341/512, 407/512)
	alertFrame.Bg:SetVertexColor(1, 1, 1, 0.4)
	alertFrame.text = alertFrame:CreateFontString(nil, "ARTWORK", "GameFont_Gigantic")
	alertFrame.text:SetPoint("CENTER")
	alertFrame:SetScript("OnUpdate", function(self, elapsed)
		self.timer = self.timer + elapsed
		if (self.timer > self.totalTime) then self:Hide() end
		if (self.timer <= 0.5) then
			self:SetAlpha(self.timer * 2)
		elseif (self.timer > 2) then
			self:SetAlpha(1-self.timer/self.totalTime)
		end
	end)
	alertFrame:SetScript("OnShow", function(self)
		self.totalTime = 3.2
		self.timer = 0
	end)
	alertFrame:SetScript("OnEvent", function(self, event, ...)
		self:Hide()
		if (event == "PLAYER_REGEN_DISABLED") then
			self.text:SetText(enterCombat)
		elseif (event == "PLAYER_REGEN_ENABLED") then
			self.text:SetText(leaveCombat)
		end
		self:Show()
	end)
	alertFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	alertFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
end

local function InsertOptions()
	E.Options.args.WindTools.args["More Tools"].args["Enter Combat Alert"].args["additionalconfig"] = {
		order = 10,
		type = "group",
		name = L["Setting"],
		args = {
			custom_text = {
				order = 1,
				type = "toggle",
				name = L["Use custom text"],
				disabled = function() return not E.db.WindTools["Enter Combat Alert"]["enabled"] end,
				get = function(info) return E.db.WindTools["Enter Combat Alert"]["custom_text"] end,
				set = function(info, value) E.db.WindTools["Enter Combat Alert"]["custom_text"] = value; E:StaticPopup_Show("PRIVATE_RL")  end,
			},
			custom_enter_combat = {
				order = 2,
				type = "input",
				name = L["Custom text (Enter)"],
				width = 'full',
				disabled = function() return not E.db.WindTools["Enter Combat Alert"]["custom_text"] end,
				get = function(info) return E.db.WindTools["Enter Combat Alert"]["custom_text_enter"] end,
				set = function(info, value) E.db.WindTools["Enter Combat Alert"]["custom_text_enter"] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
			custom_leave_combat = {
				order = 3,
				type = "input",
				disabled = function() return not E.db.WindTools["Enter Combat Alert"]["customtext"] end,
				name = L["Custom text (Leave)"],
				width = 'full',
				disabled = function() return not E.db.WindTools["Enter Combat Alert"]["custom_text"] end,
				get = function(info) return E.db.WindTools["Enter Combat Alert"]["custom_text_leave"] end,
				set = function(info, value) E.db.WindTools["Enter Combat Alert"]["custom_text_leave"] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
			custom_leave_combat = {
				order = 3,
				type = "input",
				disabled = function() return not E.db.WindTools["Enter Combat Alert"]["customtext"] end,
				name = L["Custom text (Leave)"],
				width = 'full',
				get = function(info) return E.db.WindTools["Enter Combat Alert"]["custom_text_leave"] end,
				set = function(info, value) E.db.WindTools["Enter Combat Alert"]["custom_text_leave"] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
			setscale = {
				order = 4,
				type = "range",
				name = L["Scale"],
				desc = L["Default is 0.65"],
				min = 0.1, max = 1.0, step = 0.01,
				get = function(info) return E.db.WindTools["Enter Combat Alert"]["scale"] end,
				set = function(info, value) E.db.WindTools["Enter Combat Alert"]["scale"] = value; E:StaticPopup_Show("PRIVATE_RL")end
			},
		}
	}
end
WT.ToolConfigs["Enter Combat Alert"] = InsertOptions
E:RegisterModule(EnterCombatAlert:GetName())