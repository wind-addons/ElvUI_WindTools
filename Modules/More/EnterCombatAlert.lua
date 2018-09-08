-- 原作：TinyUntitled 的 Player lua中的一段
-- loudsoul (http://bbs.ngacn.cc/read.php?tid=10240957)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 增加自定义文字设定项

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local EnterCombatAlert = E:NewModule('Wind_EnterCombatAlert');

function EnterCombatAlert:Initialize()
	self.db = E.db.WindTools["More Tools"]["Enter Combat Alert"]
	if not self.db.enabled then return end

	local enterCombat = L["Enter Combat"]
	local leaveCombat = L["Leave Combat"]
	
	if self.db.custom_text then
		enterCombat = self.db.custom_text_enter
		leaveCombat = self.db.custom_text_leave
	end

	local alertFrame = CreateFrame("Frame")
	alertFrame:SetSize(400, 65)
	alertFrame:SetPoint("TOP", 0, -280)
	alertFrame:SetScale(self.db.scale)
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
			self:SetAlpha(1 - (self.timer - 2) /(self.totalTime - 2))
		end
	end)
	alertFrame:SetScript("OnShow", function(self)
		self.totalTime = 2.5
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

local function InitializeCallback()
	EnterCombatAlert:Initialize()
end

E:RegisterModule(EnterCombatAlert:GetName(), InitializeCallback)