-- 原作：TinyUntitled 的 Player lua中的一段
-- loudsoul (http://bbs.ngacn.cc/read.php?tid=10240957)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 增加自定义文字设定项

local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")
local EnterCombatAlert = E:NewModule('Wind_EnterCombatAlert');

function EnterCombatAlert:Initialize()
	self.db = E.db.WindTools["More Tools"]["Enter Combat Alert"]
	if not self.db.enabled then return end

	local enterCombat = L["Enter Combat"]
	local leaveCombat = L["Leave Combat"]
	
	-- Load custom text
	if self.db.custom_text.enabled then
		enterCombat = self.db.custom_text_enter
		leaveCombat = self.db.custom_text_leave
	end

	-- Cache color setting
	local color_enter = self.db.style.font_color_enter
	local color_leave = self.db.style.font_color_leave

	-- Create frame
	local alertFrame = CreateFrame("Frame", "alertFrame", UIParent)
	alertFrame:SetClampedToScreen(true)
	alertFrame:SetSize(300, 65)
	alertFrame:SetPoint("TOP", 0, -280)
	alertFrame:SetScale(self.db.style.scale)
	alertFrame:Hide()

	-- Use backdrop
	if self.db.style.use_backdrop then
		alertFrame.Bg = alertFrame:CreateTexture(nil, "BACKGROUND")
		alertFrame.Bg:SetTexture("Interface\\LevelUp\\MinorTalents")
		alertFrame.Bg:SetPoint("TOP")
		alertFrame.Bg:SetSize(400, 60)
		alertFrame.Bg:SetTexCoord(0, 400/512, 341/512, 407/512)
		alertFrame.Bg:SetVertexColor(1, 1, 1, 0.4)
	end

	-- Set text
	alertFrame.text = alertFrame:CreateFontString(nil)
	--alertFrame.text = alertFrame:CreateFontString(nil, "ARTWORK", "GameFont_Gigantic")
	alertFrame.text:SetFont(LSM:Fetch('font', self.db.style.font_name), self.db.style.font_size, self.db.style.font_flag)
	alertFrame.text:SetPoint("CENTER", 0, -1)
	
	-- Animation
	alertFrame:SetScript("OnShow", function(self)
		self.totalTime = 2.5
		self.timer = 0
	end)

	alertFrame:SetScript("OnUpdate", function(self, elapsed)
		self.timer = self.timer + elapsed
		if (self.timer > self.totalTime) then self:Hide() end
		if (self.timer <= 0.5) then
			self:SetAlpha(self.timer * 2)
		elseif (self.timer > 2) then
			self:SetAlpha(1 - (self.timer - 2) /(self.totalTime - 2))
		end
	end)

	-- Change text
	alertFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	alertFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	alertFrame:SetScript("OnEvent", function(self, event, ...)
		self:Hide()
		if (event == "PLAYER_REGEN_DISABLED") then
			self.text:SetText(enterCombat)
			self.text:SetTextColor(color_enter.r,color_enter.g,color_enter.b,color_enter.a)
		elseif (event == "PLAYER_REGEN_ENABLED") then
			self.text:SetText(leaveCombat)
			self.text:SetTextColor(color_leave.r,color_leave.g,color_leave.b,color_leave.a)
		end
		self:Show()
	end)

	-- Create ElvUI mover
	E:CreateMover(alertFrame, "alertFrameMover", L["Enter Combat Alert"], nil, nil, nil, "ALL", function() return E.db.WindTools["Interface"]["Enter Combat Alert"].enabled; end)
end

local function InitializeCallback()
	EnterCombatAlert:Initialize()
end

E:RegisterModule(EnterCombatAlert:GetName(), InitializeCallback)