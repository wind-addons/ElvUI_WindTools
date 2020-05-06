local W, F, E, L = unpack(select(2, ...))
local C = W:NewModule('CombatAlert', 'AceEvent-3.0')

local unpack = unpack
local CreateFrame = CreateFrame

function C:UpdateConfigs() end

function C:CreateAnimationFrame()
    if self.animationFrame then return end

    local frame, tex, anime
    -- 动画核心区域透明框体（方便通过 ElvUI 移动）
    frame = CreateFrame("Frame", nil, self.alert)
    frame:Point("TOP", 0, 0)
    self.animationFrame = frame

    -- 盾
    frame = CreateFrame("Frame", nil, self.animationFrame)
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(3)
    frame:SetAlpha(0)
    frame:Hide()
    tex = frame:CreateTexture()
    tex:SetTexture(F.GetTexture("Shield.tga", "Textures"))
    tex:SetAllPoints()
    anime = frame:CreateAnimationGroup()
    anime.moveToCenter = anime:CreateAnimation("Translation")
    anime.fadeIn = anime:CreateAnimation("Alpha")
    anime.fadeIn:SetFromAlpha(0)
    anime.fadeIn:SetToAlpha(1)
    anime.fadeIn:SetSmoothing("IN")
    anime.fadeOut = anime:CreateAnimation("Alpha")
    anime.fadeOut:SetFromAlpha(1)
    anime.fadeOut:SetToAlpha(0)
    anime.fadeOut:SetSmoothing("OUT")
    frame.a = anime
    frame:SetScript("OnShow", function(self) self.a:Play() end)
    anime:SetScript("OnFinished", function(self) self:GetParent():Hide() end)
    self.animationFrame.shield = frame

    -- 剑 ↗
    frame = CreateFrame("Frame", nil, self.animationFrame)
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(2)
    frame:SetAlpha(0)
    frame:Hide()
    tex = frame:CreateTexture()
    tex:SetTexture(F.GetTexture("Sword.tga", "Textures"))
    tex:SetAllPoints()
    anime = frame:CreateAnimationGroup()
    anime.moveToCenter = anime:CreateAnimation("Translation")
    anime.fadeIn = anime:CreateAnimation("Alpha")
    anime.fadeIn:SetFromAlpha(0)
    anime.fadeIn:SetToAlpha(1)
    anime.fadeIn:SetSmoothing("IN")
    anime.fadeOut = anime:CreateAnimation("Alpha")
    anime.fadeOut:SetFromAlpha(1)
    anime.fadeOut:SetToAlpha(0)
    anime.fadeOut:SetSmoothing("OUT")
    frame.a = anime
    frame.shield = self.animationFrame.shield
    frame:SetScript("OnShow", function(self) self.a:Play() end)
    anime:SetScript("OnFinished", function(self) self:GetParent():Hide() end)
    anime.fadeIn:SetScript("OnFinished", function(self) self:GetParent():GetParent().shield:Show() end)
    self.animationFrame.swordLeftToRight = frame

    -- 剑 ↖
    frame = CreateFrame("Frame", nil, self.animationFrame)
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(1)
    frame:SetAlpha(0)
    frame:Hide()
    tex = frame:CreateTexture()
    tex:SetTexture(F.GetTexture("Sword.tga", "Textures"))
    local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = tex:GetTexCoord() -- 沿 y 轴翻转素材
    tex:SetTexCoord(URx, URy, LRx, LRy, ULx, ULy, LLx, LLy)
    tex:SetAllPoints()
    anime = frame:CreateAnimationGroup()
    anime.moveToCenter = anime:CreateAnimation("Translation")
    anime.fadeIn = anime:CreateAnimation("Alpha")
    anime.fadeIn:SetFromAlpha(0)
    anime.fadeIn:SetToAlpha(1)
    anime.fadeIn:SetSmoothing("IN")
    anime.fadeOut = anime:CreateAnimation("Alpha")
    anime.fadeOut:SetFromAlpha(1)
    anime.fadeOut:SetToAlpha(0)
    anime.fadeOut:SetSmoothing("OUT")
    frame.a = anime
    frame:SetScript("OnShow", function(self) self.a:Play() end)
    anime:SetScript("OnFinished", function(self) self:GetParent():Hide() end)
    self.animationFrame.swordRightToLeft = frame
end

function C:UpdateAnimationFrame()
    if not self.animationFrame then return end
    local timerSpeed = 1 / self.db.animateSpeed
    local animationFrameSize = {240 * self.db.animationSize, 220 * self.db.animationSize}
    local textureSize = 200 * self.db.animationSize
    local swordOffset = 150 * self.db.animationSize
    local swordAnimationRange = 130 * self.db.animationSize
    local shieldOffset = 50 * self.db.animationSize
    local shieldAnimationRange = 65 * self.db.animationSize

    -- 动画尺寸
    self.animationFrame:Size(unpack(animationFrameSize))

    self.animationFrame.shield:Size(0.8 * textureSize, 0.8 * textureSize)
    self.animationFrame.shield:Point("CENTER", 0, shieldOffset)

    self.animationFrame.swordLeftToRight:Size(textureSize, textureSize)
    self.animationFrame.swordLeftToRight:Point("CENTER", -swordOffset, -swordOffset)

    self.animationFrame.swordRightToLeft:Size(textureSize, textureSize)
    self.animationFrame.swordRightToLeft:Point("CENTER", swordOffset, -swordOffset)

    -- 动画时间更新
    local anime, delay

    delay = 0
    anime = self.animationFrame.shield.a
    anime.moveToCenter:SetOffset(0, -shieldAnimationRange)
    anime.moveToCenter:SetDuration(0.3 * timerSpeed)
    anime.moveToCenter:SetStartDelay(delay * timerSpeed) -- 进场
    anime.fadeIn:SetDuration(0.3 * timerSpeed)
    anime.fadeIn:SetStartDelay(delay * timerSpeed) -- 进场
    delay = delay + 0.3 + 0.3 -- 停留0.3秒
    anime.fadeOut:SetDuration(0.3 * timerSpeed)
    anime.fadeOut:SetStartDelay(delay * timerSpeed) -- 退场

    delay = 0
    anime = self.animationFrame.swordLeftToRight.a
    anime.moveToCenter:SetOffset(swordAnimationRange, swordAnimationRange)
    anime.moveToCenter:SetDuration(0.5 * timerSpeed)
    anime.moveToCenter:SetStartDelay(delay * timerSpeed) -- 进场
    anime.fadeIn:SetDuration(0.5 * timerSpeed)
    anime.fadeIn:SetStartDelay(delay * timerSpeed) -- 进场
    delay = delay + 0.5 + 0.6 -- 停留0.6秒
    anime.fadeOut:SetDuration(0.3 * timerSpeed)
    anime.fadeOut:SetStartDelay(delay * timerSpeed) -- 退场

    delay = 0
    anime = self.animationFrame.swordRightToLeft.a
    anime.moveToCenter:SetOffset(-swordAnimationRange, swordAnimationRange)
    anime.moveToCenter:SetDuration(0.5 * timerSpeed)
    anime.moveToCenter:SetStartDelay(delay) -- 进场
    anime.fadeIn:SetDuration(0.5 * timerSpeed)
    anime.fadeIn:SetStartDelay(delay * timerSpeed) -- 进场
    delay = delay + 0.5 + 0.6 -- 停留0.6秒
    anime.fadeOut:SetDuration(0.3 * timerSpeed)
    anime.fadeOut:SetStartDelay(delay * timerSpeed) -- 退场
end

function C:StartAnimation(enterCombat)
    if not self.animationFrame then
        C:CreateAnimationFrame()
        C:UpdateAnimationFrame()
    end

    if enterCombat then
        self.animationFrame.swordLeftToRight:Show()
        self.animationFrame.swordRightToLeft:Show()
        -- 盾牌动画会由左到右的剑自动触发
    else
    end
end

function C:CreateTextFrame()
    if self.textFrame then return end
end

function C:ShowAlert() end

function C:QueueAlert() end

function C:CheckNextAlert() end

function C:PLAYER_REGEN_DISABLED() self:StartAnimation(true) end

function C:PLAYER_REGEN_ENABLED() self:StartAnimation(false) end

function C:ConstructFrames()
    local frame = CreateFrame("Frame", "WindToolsCombatAlertFrame", E.UIParent)
    frame:Point("TOP", 0, -200)
    self.alert = frame

    self:CreateAnimationFrame()
    self:UpdateAnimationFrame()
    self:CreateTextFrame()

    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")

    local width = self.animationFrame:GetWidth()
    local height = self.animationFrame:GetHeight()

    self.alert:Size(width, height)

    E:CreateMover(self.alert, "combatAlertFrameMover", L["Combat Alert"], nil, nil, nil, 'ALL,WINDTOOLS',
                  function() return C.db.enabled; end)
end

function C:Initialize()
    if not E.db.WT.combat.combatAlert.enable then return end
    self.db = E.db.WT.combat.combatAlert

    self:RegisterEvent("PLAYER_ENTERING_WORLD", "ConstructFrames")
end

function C:ProfileUpdate()
    if E.db.WT.combat.combatAlert.enable then
        self:ConstructFrames()
    else
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        self:UnregisterEvent("PLAYER_REGEN_DISABLED")
    end
end

W:RegisterModule(C:GetName())
