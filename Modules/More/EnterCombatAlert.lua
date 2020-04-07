-- 原创模块

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")
local ECA = E:NewModule('Wind_EnterCombatAlert', 'AceEvent-3.0', 'AceTimer-3.0');

function ECA:CreateAlert()
	if self.alert then return end
	local alert = CreateFrame("Frame", "Wind_EnterCombatAlertFrame", UIParent)
	alert:SetClampedToScreen(true)
	alert:SetSize(300, 65)
	alert:Point("TOP", 0, -280)
	alert:SetScale(self.db.style.scale)
	alert:Hide()

	alert.Bg = alert:CreateTexture(nil, "BACKGROUND")
	alert.Bg:SetTexture("Interface\\LevelUp\\MinorTalents")
	alert.Bg:Point("TOP")
	alert.Bg:SetSize(400, 60)
	alert.Bg:SetTexCoord(0, 400/512, 341/512, 407/512)
	alert.Bg:SetVertexColor(1, 1, 1, 0.4)

	alert.text = alert:CreateFontString(nil)
	alert.text:Point("CENTER", 0, -1)

	self.alert = alert
end

function ECA:RefreshAlert()
	wipe(self.animationQueue)
	
	self.alert.text:FontTemplate(LSM:Fetch('font', self.db.style.font_name), self.db.style.font_size, self.db.style.font_flag)
	
	if self.db.style.use_backdrop then
		self.alert.Bg:Show()
	else
		self.alert.Bg:Hide()
	end
end

function ECA:FadeIn(second, func)
	local fadeInfo = {};

	fadeInfo.mode = "IN"
	fadeInfo.timeToFade = second
	fadeInfo.startAlpha = 0
	fadeInfo.endAlpha = 1
	fadeInfo.finishedFunc = function()
		if func then func() end
	end
	UIFrameFade(self.alert, fadeInfo)
end

function ECA:FadeOut(second, func)
	local fadeInfo = {};

	fadeInfo.mode = "OUT"
	fadeInfo.timeToFade = second
	fadeInfo.startAlpha = 1
	fadeInfo.endAlpha = 0
	fadeInfo.finishedFunc = function()
		if func then func() end
	end
	UIFrameFade(self.alert, fadeInfo)
end

local function executeNextAnimation()
	if ECA.animationQueue and ECA.animationQueue[1] then
		local func = ECA.animationQueue[1]
		func()
		tremove(ECA.animationQueue, 1)
	end
end

function ECA:AnimateAlert(changeTextFunc)
	local stay_duration = self.db.style.stay_duration
	local animation_duration = self.db.style.animation_duration
	
	-- 如果已经在动画，则清除全部剩余动作
	if self.inAnimation then
		if self.animationTimer then
			-- 如果正在待机中，直接更改文字可能视觉效果较好
			changeTextFunc()
			return
		else
			wipe(self.animationQueue)
			-- 防止瞬间改变带来突兀感
			tinsert(self.animationQueue, function()
				changeTextFunc()
				ECA:FadeIn(animation_duration, executeNextAnimation)
			end)
		end
	else
		self.inAnimation = true
		changeTextFunc()
		self:FadeIn(animation_duration, executeNextAnimation)
	end

	tinsert(self.animationQueue, function()
		ECA.animationTimer = C_Timer.NewTimer(stay_duration, executeNextAnimation)
	end)

	tinsert(self.animationQueue, function()
		ECA.animationTimer = nil
		ECA:FadeOut(animation_duration, executeNextAnimation)
	end)

	tinsert(self.animationQueue, function()
		ECA.inAnimation = false
	end)

	self.inAnimation = true
end

function ECA:PLAYER_REGEN_DISABLED()
	local color = self.db.style.font_color_enter
	self:AnimateAlert(function()
		self.alert.text:SetText(self.db.custom_text.enabled and self.db.custom_text.custom_enter_text or L["Enter Combat"])
		self.alert.text:SetTextColor(color.r,color.g,color.b,color.a)
	end)
end

function ECA:PLAYER_REGEN_ENABLED()
	local color = self.db.style.font_color_leave
	self:AnimateAlert(function()
		self.alert.text:SetText(self.db.custom_text.enabled and self.db.custom_text.custom_leave_text or L["Leave Combat"])
		self.alert.text:SetTextColor(color.r,color.g,color.b,color.a)
	end)
end

function ECA:Initialize()
	if not E.db.WindTools["More Tools"]["Enter Combat Alert"].enabled then return end

	self.db = E.db.WindTools["More Tools"]["Enter Combat Alert"]
	tinsert(WT.UpdateAll, function()
		ECA.db = E.db.WindTools["More Tools"]["Enter Combat Alert"]
		ECA:CreateAlert()
	end)

	ECA.inAnimation = false
	self.animationQueue = {}

	self:CreateAlert()
	self:RefreshAlert()

	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")

	E:CreateMover(self.alert, "alertFrameMover", L["Enter Combat Alert"], nil, nil, nil, 'WINDTOOLS,ALL', function() return EnterCombatAlert.db.enabled; end)
end

local function InitializeCallback()
	ECA:Initialize()
end

E:RegisterModule(ECA:GetName(), InitializeCallback)