local W, F, E, L = unpack(select(2, ...))
local C = W:NewModule('CombatAlert', 'AceEvent-3.0')
local A = F.Animation

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
    frame = A.CreateAnimationFrame(name, self.animationFrame, "HIGH", 3, true, F.GetTexture("Shield.tga", "Textures"))
    anime = A.CreateAnimationGroup(frame, "anime")
    A.AddTranslation(anime, "moveToCenter")
    A.AddFadeIn(anime, "fadeIn")
    A.AddFadeOut(anime, "fadeOut")
    A.SetAnimationWhileShowing(frame, anime)
    anime.moveToCenter:SetDuration(0.3)
    anime.moveToCenter:SetStartDelay(0) -- 进场
    anime.fadeIn:SetDuration(0.3)
    anime.fadeIn:SetStartDelay(0) -- 进场
    anime.fadeOut:SetDuration(0.3)
    anime.fadeOut:SetStartDelay(0.3 + 0.3) -- 退场
    self.animationFrame.shield = frame

    -- 剑 ↗
    frame = A.CreateAnimationFrame(name, self.animationFrame, "HIGH", 2, true, F.GetTexture("Sword.tga", "Textures"))
    anime = A.CreateAnimationGroup(frame, "anime")
    A.AddTranslation(anime, "moveToCenter")
    A.AddFadeIn(anime, "fadeIn")
    A.AddFadeOut(anime, "fadeOut")
    A.SetAnimationWhileShowing(frame, anime)
    anime.moveToCenter:SetDuration(0.5)
    anime.moveToCenter:SetStartDelay(0) -- 进场
    anime.fadeIn:SetDuration(0.5)
    anime.fadeIn:SetStartDelay(0) -- 进场
    anime.fadeOut:SetDuration(0.3)
    anime.fadeOut:SetStartDelay(0.5 + 0.6) -- 退场
    anime.fadeIn:SetScript("OnFinished", function() self.animationFrame.shield:Show() end)
    self.animationFrame.swordLeftToRight = frame

    -- 剑 ↖
    frame = A.CreateAnimationFrame(name, self.animationFrame, "HIGH", 2, true, F.GetTexture("Sword.tga", "Textures"),
                                   true)
    anime = A.CreateAnimationGroup(frame, "anime")
    A.AddTranslation(anime, "moveToCenter")
    A.AddFadeIn(anime, "fadeIn")
    A.AddFadeOut(anime, "fadeOut")
    A.SetAnimationWhileShowing(frame, anime)
    anime.moveToCenter:SetDuration(0.5)
    anime.moveToCenter:SetStartDelay(0) -- 进场
    anime.fadeIn:SetDuration(0.5)
    anime.fadeIn:SetStartDelay(0) -- 进场
    anime.fadeOut:SetDuration(0.3)
    anime.fadeOut:SetStartDelay(0.5 + 0.6) -- 退场
    self.animationFrame.swordRightToLeft = frame
end

function C:UpdateAnimationFrame()
    if not self.animationFrame then return end
    local animationFrameSize = {240 * self.db.animationSize, 220 * self.db.animationSize}
    local textureSize = 200 * self.db.animationSize
    local swordOffset = 150 * self.db.animationSize
    local swordAnimationRange = 130 * self.db.animationSize
    local shieldOffset = 50 * self.db.animationSize
    local shieldAnimationRange = 65 * self.db.animationSize

    local f = self.animationFrame

    -- 动画尺寸
    f:Size(unpack(animationFrameSize))

    f.shield:Size(0.8 * textureSize, 0.8 * textureSize)
    f.shield:Point("CENTER", 0, shieldOffset)
    f.shield.anime.moveToCenter:SetOffset(0, -shieldAnimationRange)

    f.swordLeftToRight:Size(textureSize, textureSize)
    f.swordLeftToRight:Point("CENTER", -swordOffset, -swordOffset)
    f.swordLeftToRight.anime.moveToCenter:SetOffset(swordAnimationRange, swordAnimationRange)

    f.swordRightToLeft:Size(textureSize, textureSize)
    f.swordRightToLeft:Point("CENTER", swordOffset, -swordOffset)
    f.swordRightToLeft.anime.moveToCenter:SetOffset(-swordAnimationRange, swordAnimationRange)

    -- 动画时间更新
    A.SpeedAnimationGroup(f.shield.anime, self.db.animateSpeed)
    A.SpeedAnimationGroup(f.swordLeftToRight.anime, self.db.animateSpeed)
    A.SpeedAnimationGroup(f.swordRightToLeft.anime, self.db.animateSpeed)
end

function C:StartAnimation(enterCombat)
    if not self.animationFrame then F.DebugMessage(C, "找不到动画框架") end

    if enterCombat then
        self.animationFrame.swordLeftToRight:Show()
        self.animationFrame.swordRightToLeft:Show()
        -- 盾牌动画会由左到右的剑自动触发
    else
    end
end

function C:CreateTextFrame() if self.textFrame then return end end

function C:ShowAlert() end

function C:QueueAlert() end

function C:CheckNextAlert() end

function C:PLAYER_REGEN_DISABLED() self:StartAnimation(true) end

function C:PLAYER_REGEN_ENABLED() self:StartAnimation(false) end

function C:UpdateMover()
    if not self.alert then return end
    local width = self.animationFrame:GetWidth()
    local height = self.animationFrame:GetHeight()
    self.alert:Size(width, height)
end

function C:UpdateFrames()
    if not self.alert then self:ConstructFrames() end
    self:UpdateAnimationFrame()
    self:UpdateMover()
end

function C:ConstructFrames()
    self.alert = CreateFrame("Frame", nil, E.UIParent)
    self.alert:Point("TOP", 0, -200)
    self:CreateAnimationFrame()
    self:CreateTextFrame()

    self:UpdateAnimationFrame()
    self:UpdateMover()

    E:CreateMover(self.alert, "WTCombatAlertFrameMover", L["Combat Alert"], nil, nil, nil, 'ALL,WINDTOOLS',
                  function() return E.db.WT.combat.combatAlert.enable end)

    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
end

function C:Initialize()
    if not E.db.WT.combat.combatAlert.enable then return end
    self.db = E.db.WT.combat.combatAlert

    self:RegisterEvent("PLAYER_ENTERING_WORLD", "ConstructFrames")
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

W:RegisterModule(C:GetName())
