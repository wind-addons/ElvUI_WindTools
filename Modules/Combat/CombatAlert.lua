local W, F, E, L = unpack(select(2, ...))
local C = W:NewModule("CombatAlert", "AceEvent-3.0")
local A = F.Animation

local unpack, tinsert, tremove = unpack, tinsert, tremove
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
    frame:Point("TOP", 0, 0)
    self.animationFrame = frame

    -- 盾
    frame = A.CreateAnimationFrame(name, self.animationFrame, "HIGH", 3, true, F.GetTexture("Shield.tga", "Textures"))
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
    A.AddScale(anime, "scale", {1, 1}, {0.1, 0.1})
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
    frame = A.CreateAnimationFrame(name, self.animationFrame, "HIGH", 2, true, F.GetTexture("Sword.tga", "Textures"))
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
    anime.fadeIn:SetScript(
        "OnFinished",
        function()
            self.animationFrame.shield:Show()
            self.animationFrame.shield.enter:Play()
        end
    )
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
    frame =
        A.CreateAnimationFrame(name, self.animationFrame, "HIGH", 2, true, F.GetTexture("Sword.tga", "Textures"), true)
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

    local animationFrameSize = {240 * self.db.animationSize, 220 * self.db.animationSize}
    local textureSize = 200 * self.db.animationSize
    local swordAnimationRange = 130 * self.db.animationSize
    local shieldAnimationRange = 65 * self.db.animationSize

    local f = self.animationFrame

    -- 动画尺寸
    f:Size(unpack(animationFrameSize))

    f.shield:Size(0.8 * textureSize, 0.8 * textureSize)
    f.shield.enter.moveToCenter:SetOffset(0, -shieldAnimationRange)

    f.swordLeftToRight:Size(textureSize, textureSize)
    f.swordLeftToRight.enter.moveToCenter:SetOffset(swordAnimationRange, swordAnimationRange)
    f.swordLeftToRight.leave.moveToCorner:SetOffset(swordAnimationRange, swordAnimationRange)

    f.swordRightToLeft:Size(textureSize, textureSize)
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

    local frame = CreateFrame("Frame", nil, self.alert)
	frame:Point("TOP", self.animationFrame or self.alert, 0, -20)
    frame.text = frame:CreateFontString(nil)
    frame.text:Point("CENTER", 0, 0)
    
    self.textFrame = frame
end

-- 通知控制
function C:ShowAlert(enterCombat)
    if not self.animationFrame then
        F.DebugMessage(C, "找不到动画框架")
    end

    if isPlaying then
        self:QueueAlert(enterCombat)
        return
    end

    isPlaying = true

    local f = self.animationFrame
    local swordOffsetEnter = 150 * self.db.animationSize
    local swordOffsetLeave = 20 * self.db.animationSize
    local shieldOffsetEnter = 50 * self.db.animationSize
    local shieldOffsetLeave = -15 * self.db.animationSize

    f.shield.enter:Stop()
    f.swordLeftToRight.enter:Stop()
    f.swordRightToLeft.enter:Stop()
    f.shield.leave:Stop()
    f.swordLeftToRight.leave:Stop()
    f.swordRightToLeft.leave:Stop()

    if enterCombat then
        -- 盾牌动画会由左到右的剑自动触发
        f.shield:Point("CENTER", 0, shieldOffsetEnter)
        f.swordLeftToRight:Point("CENTER", -swordOffsetEnter, -swordOffsetEnter)
        f.swordRightToLeft:Point("CENTER", swordOffsetEnter, -swordOffsetEnter)
        f.swordLeftToRight:Show()
        f.swordRightToLeft:Show()
        f.swordLeftToRight.enter:Restart()
        f.swordRightToLeft.enter:Restart()
    else
        f.shield:Point("CENTER", 0, shieldOffsetLeave)
        f.swordLeftToRight:Point("CENTER", -swordOffsetLeave, -swordOffsetLeave)
        f.swordRightToLeft:Point("CENTER", swordOffsetLeave, -swordOffsetLeave)
        f.shield:Show()
        f.swordLeftToRight:Show()
        f.swordRightToLeft:Show()
        f.shield.leave:Restart()
        f.swordLeftToRight.leave:Restart()
        f.swordRightToLeft.leave:Restart()
    end
end

function C:QueueAlert(enterCombat)
    tinsert(alertQueue, enterCombat)
end

function C.LoadNextAlert()
    isPlaying = false

    if alertQueue and alertQueue[1] then
        local enterCombat = alertQueue[1]
        C:StartAnimation(enterCombat)
        tremove(alertQueue, 1)
    end
end

-- 事件绑定
function C:PLAYER_REGEN_DISABLED()
    self:ShowAlert(true)
end

function C:PLAYER_REGEN_ENABLED()
    self:ShowAlert(false)
end

-- 更新配置
function C:UpdateMover()
    if not self.alert then
        return
    end
    local width = self.animationFrame:GetWidth()
    local height = self.animationFrame:GetHeight()
    self.alert:Size(width, height)
end

function C:UpdateFrames()
    if not self.alert then
        self:ConstructFrames()
    else
        self:UpdateAnimationFrame()
        self:UpdateMover()
    end
end

function C:ConstructFrames()
    self.alert = CreateFrame("Frame", nil, E.UIParent)
    self.alert:Point("TOP", 0, -200)
    self:CreateAnimationFrame()
    self:CreateTextFrame()

    self:UpdateAnimationFrame()
    self:UpdateMover()

    E:CreateMover(
        self.alert,
        "WTCombatAlertFrameMover",
        L["Combat Alert"],
        nil,
        nil,
        nil,
        "ALL,WINDTOOLS",
        function()
            return E.db.WT.combat.combatAlert.enable
        end
    )

    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
end

function C:ProfileUpdate()
    if E.db.WT.combat.combatAlert.enable then
        self:UpdateFrames()
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        self:RegisterEvent("PLAYER_REGEN_DISABLED")
    else
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        self:UnregisterEvent("PLAYER_REGEN_DISABLED")
    end
end

function C:Initialize()
    if not E.db.WT.combat.combatAlert.enable then
        return
    end
    self.db = E.db.WT.combat.combatAlert

    self:RegisterEvent("PLAYER_ENTERING_WORLD", "ConstructFrames")
end

W:RegisterModule(C:GetName())
