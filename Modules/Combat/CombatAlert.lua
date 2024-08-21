local W, F, E, L = unpack((select(2, ...)))
local C = W:NewModule("CombatAlert", "AceEvent-3.0")
local A = F.Animation

local unpack, tinsert, tremove, max = unpack, tinsert, tremove, max
local CreateFrame = CreateFrame

local isPlaying = false
local alertQueue = {}

-- 动画
function C:CreateAnimationFrame()
	if self.animationFrame then
		return
	end

	local frame, anime
	frame = CreateFrame("Frame", nil, self.alert)
	frame:SetPoint("TOP", 0, 0)
	self.animationFrame = frame

	-- 盾
	frame = A.CreateAnimationFrame(nil, self.animationFrame, "HIGH", 3, true, W.Media.Textures.shield)
	anime = A.CreateAnimationGroup(frame, "enter") -- 进入战斗
	A.AddTranslation(anime, "moveToCenter")
	A.AddFadeIn(anime, "fadeIn")
	A.AddFadeOut(anime, "fadeOut")
	A.CloseAnimationOnHide(frame, anime, C.LoadNextAlert)
	anime.moveToCenter:SetDuration(0.2)
	anime.moveToCenter:SetStartDelay(0)
	anime.fadeIn:SetDuration(0.2)
	anime.fadeIn:SetStartDelay(0)
	anime.fadeOut:SetDuration(0.3)
	anime.fadeOut:SetStartDelay(0.5)
	anime = A.CreateAnimationGroup(frame, "leave") -- 离开战斗
	A.AddScale(anime, "scale", { 1, 1 }, { 0.1, 0.1 })
	A.AddFadeIn(anime, "fadeIn")
	A.AddFadeOut(anime, "fadeOut")
	anime.fadeIn:SetDuration(0.3)
	anime.fadeIn:SetStartDelay(0)
	anime.scale:SetDuration(0.6)
	anime.scale:SetStartDelay(0.6)
	anime.fadeOut:SetDuration(0.6)
	anime.fadeOut:SetStartDelay(0.6)
	A.CloseAnimationOnHide(frame, anime, C.LoadNextAlert)
	self.animationFrame.shield = frame

	-- 剑 ↗
	frame = A.CreateAnimationFrame(nil, self.animationFrame, "HIGH", 2, true, W.Media.Textures.sword)
	anime = A.CreateAnimationGroup(frame, "enter") -- 进入战斗
	A.AddTranslation(anime, "moveToCenter")
	A.AddFadeIn(anime, "fadeIn")
	A.AddFadeOut(anime, "fadeOut")
	A.CloseAnimationOnHide(frame, anime)
	anime.moveToCenter:SetDuration(0.4)
	anime.moveToCenter:SetStartDelay(0)
	anime.fadeIn:SetDuration(0.4)
	anime.fadeIn:SetStartDelay(0)
	anime.fadeOut:SetDuration(0.3)
	anime.fadeOut:SetStartDelay(0.9)
	anime.fadeIn:SetScript("OnFinished", function()
		self.animationFrame.shield:Show()
		self.animationFrame.shield.enter:Play()
	end)
	anime = A.CreateAnimationGroup(frame, "leave") -- 离开战斗
	A.AddTranslation(anime, "moveToCorner")
	A.AddFadeIn(anime, "fadeIn")
	A.AddFadeOut(anime, "fadeOut")
	anime.fadeIn:SetDuration(0.3)
	anime.fadeIn:SetStartDelay(0)
	anime.moveToCorner:SetDuration(0.6)
	anime.moveToCorner:SetStartDelay(0.6)
	anime.fadeOut:SetDuration(0.6)
	anime.fadeOut:SetStartDelay(0.6)
	A.CloseAnimationOnHide(frame, anime)
	self.animationFrame.swordLeftToRight = frame

	-- 剑 ↖
	frame = A.CreateAnimationFrame(nil, self.animationFrame, "HIGH", 2, true, W.Media.Textures.sword, true)
	anime = A.CreateAnimationGroup(frame, "enter") -- 进入战斗
	A.AddTranslation(anime, "moveToCenter")
	A.AddFadeIn(anime, "fadeIn")
	A.AddFadeOut(anime, "fadeOut")
	A.CloseAnimationOnHide(frame, anime)
	anime.moveToCenter:SetDuration(0.4)
	anime.moveToCenter:SetStartDelay(0)
	anime.fadeIn:SetDuration(0.4)
	anime.fadeIn:SetStartDelay(0)
	anime.fadeOut:SetDuration(0.3)
	anime.fadeOut:SetStartDelay(0.9)
	anime = A.CreateAnimationGroup(frame, "leave") -- 离开战斗
	A.AddTranslation(anime, "moveToCorner")
	A.AddFadeIn(anime, "fadeIn")
	A.AddFadeOut(anime, "fadeOut")
	anime.fadeIn:SetDuration(0.3)
	anime.fadeIn:SetStartDelay(0)
	anime.moveToCorner:SetDuration(0.6)
	anime.moveToCorner:SetStartDelay(0.6)
	anime.fadeOut:SetDuration(0.6)
	anime.fadeOut:SetStartDelay(0.6)
	A.CloseAnimationOnHide(frame, anime)
	self.animationFrame.swordRightToLeft = frame
end

function C:UpdateAnimationFrame()
	if not self.animationFrame then
		return
	end

	local animationFrameSize = { 240 * self.db.animationSize, 220 * self.db.animationSize }
	local textureSize = 200 * self.db.animationSize
	local swordAnimationRange = 130 * self.db.animationSize
	local shieldAnimationRange = 65 * self.db.animationSize

	local f = self.animationFrame

	-- 动画尺寸
	f:SetSize(unpack(animationFrameSize))

	f.shield:Hide()
	f.shield:SetSize(0.8 * textureSize, 0.8 * textureSize)
	f.shield.enter.moveToCenter:SetOffset(0, -shieldAnimationRange)

	f.swordLeftToRight:Hide()
	f.swordLeftToRight:SetSize(textureSize, textureSize)
	f.swordLeftToRight.enter.moveToCenter:SetOffset(swordAnimationRange, swordAnimationRange)
	f.swordLeftToRight.leave.moveToCorner:SetOffset(swordAnimationRange, swordAnimationRange)

	f.swordRightToLeft:Hide()
	f.swordRightToLeft:SetSize(textureSize, textureSize)
	f.swordRightToLeft.enter.moveToCenter:SetOffset(-swordAnimationRange, swordAnimationRange)
	f.swordRightToLeft.leave.moveToCorner:SetOffset(-swordAnimationRange, swordAnimationRange)

	-- 动画时间更新
	A.SpeedAnimationGroup(f.shield.enter, self.db.speed)
	A.SpeedAnimationGroup(f.swordLeftToRight.enter, self.db.speed)
	A.SpeedAnimationGroup(f.swordRightToLeft.enter, self.db.speed)
	A.SpeedAnimationGroup(f.shield.leave, self.db.speed)
	A.SpeedAnimationGroup(f.swordLeftToRight.leave, self.db.speed)
	A.SpeedAnimationGroup(f.swordRightToLeft.leave, self.db.speed)
end

-- 文字
function C:CreateTextFrame()
	if self.textFrame then
		return
	end

	local frame = A.CreateAnimationFrame(nil, self.alert, "HIGH", 4, true)
	frame.text = frame:CreateFontString()
	frame.text:SetPoint("CENTER", 0, 0)
	frame.text:SetJustifyV("MIDDLE")
	frame.text:SetJustifyH("CENTER")

	local anime = A.CreateAnimationGroup(frame, "enter")
	A.AddTranslation(anime, "moveUp")
	A.AddTranslation(anime, "moveDown")
	A.AddFadeIn(anime, "fadeIn")
	A.AddFadeOut(anime, "fadeOut")
	anime.moveUp:SetDuration(0.4)
	anime.moveUp:SetStartDelay(0)
	anime.moveDown:SetDuration(0.1)
	anime.moveDown:SetStartDelay(0.4)
	anime.fadeIn:SetDuration(0.5)
	anime.fadeIn:SetStartDelay(0)
	anime.fadeOut:SetDuration(0.3)
	anime.fadeOut:SetStartDelay(0.9)
	anime = A.CreateAnimationGroup(frame, "leave")
	A.AddFadeIn(anime, "fadeIn")
	A.AddFadeOut(anime, "fadeOut")
	A.AddTranslation(anime, "moveUp")
	anime.fadeIn:SetDuration(0.3)
	anime.fadeIn:SetStartDelay(0)
	anime.fadeOut:SetDuration(0.6)
	anime.fadeOut:SetStartDelay(0.6)
	anime.moveUp:SetDuration(0.6)
	anime.moveUp:SetStartDelay(0.6)

	self.textFrame = frame
end

function C:UpdateTextFrame()
	if not self.textFrame then
		return
	end

	local moveUpOffset = 160 * self.db.animationSize
	local moveDownOffset = -40 * self.db.animationSize

	local f = self.textFrame

	f:Hide()
	F.SetFontWithDB(f.text, self.db.font)
	f.text:SetText(self.db.enterText)
	f:SetSize(f.text:GetStringWidth(), f.text:GetStringHeight())

	-- 动画尺寸更新
	f.enter.moveUp:SetOffset(0, moveUpOffset)
	f.enter.moveDown:SetOffset(0, moveDownOffset)
	f.leave.moveUp:SetOffset(0, -moveDownOffset)

	-- 动画时间更新
	A.SpeedAnimationGroup(f.enter, self.db.speed)
	A.SpeedAnimationGroup(f.leave, self.db.speed)

	-- 上方动画窗体如果不存在，确认下个提示的工作就交给文字窗体了
	if not self.db.animation then
		A.CloseAnimationOnHide(f, "enter", C.LoadNextAlert)
		A.CloseAnimationOnHide(f, "leave", C.LoadNextAlert)
	else
		A.CloseAnimationOnHide(f, "enter")
		A.CloseAnimationOnHide(f, "leave")
	end
end

-- 通知控制
function C:ShowAlert(alertType)
	if not self.animationFrame then
		self:Log("debug", "not animation frame")
	end

	if not self.textFrame then
		self:Log("debug", "not text frame")
	end

	if isPlaying then
		self:QueueAlert(alertType)
		return
	end

	isPlaying = true

	local a = self.animationFrame
	local t = self.textFrame
	local swordOffsetEnter = 150 * self.db.animationSize
	local swordOffsetLeave = 20 * self.db.animationSize
	local shieldOffsetEnter = 50 * self.db.animationSize
	local shieldOffsetLeave = -15 * self.db.animationSize
	local textOffsetEnter = -120 * self.db.animationSize
	local textOffsetLeave = -20 * self.db.animationSize

	if self.db.animation then
		a.shield.enter:Stop()
		a.swordLeftToRight.enter:Stop()
		a.swordRightToLeft.enter:Stop()
		a.shield.leave:Stop()
		a.swordLeftToRight.leave:Stop()
		a.swordRightToLeft.leave:Stop()
	end
	if self.db.text then
		t.enter:Stop()
		t.leave:Stop()
	end

	if alertType == "ENTER" then
		if self.db.animation then
			-- 盾牌动画会由左到右的剑自动触发
			a.shield:SetPoint("CENTER", 0, shieldOffsetEnter)
			a.swordLeftToRight:SetPoint("CENTER", -swordOffsetEnter, -swordOffsetEnter)
			a.swordRightToLeft:SetPoint("CENTER", swordOffsetEnter, -swordOffsetEnter)
			a.swordLeftToRight:Show()
			a.swordRightToLeft:Show()
			a.swordLeftToRight.enter:Restart()
			a.swordRightToLeft.enter:Restart()
		end

		if self.db.text then
			t.text:SetText(self.db.enterText)
			F.SetFontColorWithDB(t.text, self.db.enterColor)
			t:SetSize(t.text:GetStringWidth(), t.text:GetStringHeight())
			t:SetPoint("TOP", self.db.animation and self.animationFrame or self.alert, "BOTTOM", 0, textOffsetEnter)
			t:Show()
			t.enter:Restart()
		end
	else
		if self.db.animation then
			a.shield:SetPoint("CENTER", 0, shieldOffsetLeave)
			a.swordLeftToRight:SetPoint("CENTER", -swordOffsetLeave, -swordOffsetLeave)
			a.swordRightToLeft:SetPoint("CENTER", swordOffsetLeave, -swordOffsetLeave)
			a.shield:Show()
			a.swordLeftToRight:Show()
			a.swordRightToLeft:Show()
			a.shield.leave:Restart()
			a.swordLeftToRight.leave:Restart()
			a.swordRightToLeft.leave:Restart()
		end

		if self.db.text then
			t.text:SetText(self.db.leaveText)
			F.SetFontColorWithDB(t.text, self.db.leaveColor)
			t:SetSize(t.text:GetStringWidth(), t.text:GetStringHeight())
			t:SetPoint("TOP", self.db.animation and self.animationFrame or self.alert, "BOTTOM", 0, textOffsetLeave)
			t:Show()
			t.leave:Restart()
		end
	end
end

function C:QueueAlert(alertType)
	tinsert(alertQueue, alertType)
end

function C.LoadNextAlert()
	isPlaying = false

	if alertQueue and alertQueue[1] then
		C:ShowAlert(alertQueue[1])
		tremove(alertQueue, 1)
	end
end

-- 事件绑定
function C:PLAYER_REGEN_DISABLED()
	self:ShowAlert("ENTER")
end

function C:PLAYER_REGEN_ENABLED()
	self:ShowAlert("LEAVE")
end

-- 更新配置
function C:UpdateMover()
	if not self.alert then
		return
	end

	local width = 0
	local height = 0

	if self.db.animation and self.animationFrame then
		width = width + (self.animationFrame:GetWidth() or 0)
		height = height + (self.animationFrame:GetHeight() or 0)
	end

	if self.db.text and self.textFrame then
		width = max(width, self.animationFrame:GetWidth())
		height = height + self.textFrame:GetHeight()
	end

	if width ~= 0 and height ~= 0 then
		self.alert:SetSize(width, height)
	end
end

function C:UpdateFrames()
	if not self.alert then
		self:ConstructFrames()
	else
		self:UpdateAnimationFrame()
		self:UpdateTextFrame()
		self:UpdateMover()
	end
end

function C:ConstructFrames()
	self.alert = CreateFrame("Frame", nil, E.UIParent)
	self.alert:SetPoint("TOP", 0, -200)
	self:CreateAnimationFrame()
	self:CreateTextFrame()

	self:UpdateAnimationFrame()
	self:UpdateTextFrame()
	self:UpdateMover()

	E:CreateMover(self.alert, "WTCombatAlertFrameMover", L["Combat Alert"], nil, nil, nil, "ALL,WINDTOOLS", function()
		return E.db.WT.combat.combatAlert.enable
	end, "WindTools,combat,combatAlert")

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
end

function C:ProfileUpdate()
	if E.db.WT.combat.combatAlert.enable then
		self.db = E.db.WT.combat.combatAlert
		self:UpdateFrames()
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
	else
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	end
end

function C:Preview()
	self:ShowAlert("ENTER")
	self:QueueAlert("LEAVE")
end

function C:Initialize()
	if not E.db.WT.combat.combatAlert.enable then
		return
	end
	self.db = E.db.WT.combat.combatAlert

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "ConstructFrames")
end

W:RegisterModule(C:GetName())
