local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local CA = W:NewModule("CombatAlert", "AceEvent-3.0") ---@class CombatAlert: AceModule, AceEvent-3.0
local C = W.Utilities.Color

local _G = _G
local assert = assert
local ipairs = ipairs
local max = max
local tinsert = tinsert
local tremove = tremove

local CreateAnimationGroup = _G.CreateAnimationGroup
local CreateFrame = CreateFrame

local isPlaying = false
local alertQueue = {}

local ANIMATION_TIMINGS = {
	SHIELD_ENTER_MOVE_FADE = 0.2,
	SHIELD_ENTER_SLEEP = 0.5,
	SHIELD_ENTER_FADEOUT = 0.3,
	SHIELD_LEAVE_FADEIN = 0.3,
	SHIELD_LEAVE_SLEEP = 0.5,
	SHIELD_LEAVE_MOVE_SCALE_FADEOUT = 0.6,

	SWORD_ENTER_MOVE_FADE = 0.4,
	SWORD_ENTER_SLEEP = 0.6,
	SWORD_ENTER_FADEOUT = 0.3,
	SWORD_LEAVE_FADEIN = 0.3,
	SWORD_LEAVE_SLEEP = 0.5,
	SWORD_LEAVE_MOVE = 0.35,
	SWORD_LEAVE_FADEOUT = 0.3,

	TEXT_ENTER_MOVE_UP = 0.4,
	TEXT_ENTER_FADEIN = 0.5,
	TEXT_ENTER_MOVE_DOWN = 0.1,
	TEXT_ENTER_SLEEP = 0.4,
	TEXT_ENTER_FADEOUT = 0.3,
	TEXT_LEAVE_FADEIN = 0.3,
	TEXT_LEAVE_SLEEP = 0.6,
	TEXT_LEAVE_MOVE_FADEOUT = 0.6,
}

---Create a fade-in animation for an animation group
---@param animGroup LibAnimAnimationGroup Animation group to add to
---@param duration number Animation duration in seconds
---@param order number Animation order
---@return LibAnimAnimation fadeIn Created fade-in animation
local function createFadeIn(animGroup, duration, order)
	local fadeIn = animGroup:CreateAnimation("fade")
	assert(fadeIn, "Failed to create fade-in animation")
	fadeIn:SetDuration(duration)
	fadeIn:SetChange(1)
	fadeIn:SetOrder(order)
	return fadeIn
end

---Create a fade-out animation for an animation group
---@param animGroup LibAnimAnimationGroup Animation group to add to
---@param duration number Animation duration in seconds
---@param order number Animation order
---@return LibAnimAnimation fadeOut Created fade-out animation
local function createFadeOut(animGroup, duration, order)
	local fadeOut = animGroup:CreateAnimation("fade")
	assert(fadeOut, "Failed to create fade-out animation")
	fadeOut:SetDuration(duration)
	fadeOut:SetChange(0)
	fadeOut:SetOrder(order)
	return fadeOut
end

---Create a move animation for an animation group
---@param animGroup LibAnimAnimationGroup Animation group to add to
---@param duration number Animation duration in seconds
---@param order number Animation order
---@return LibAnimAnimation move Created move animation
local function createMove(animGroup, duration, order)
	local move = animGroup:CreateAnimation("move")
	assert(move, "Failed to create move animation")
	move:SetDuration(duration)
	move:SetOrder(order)
	return move
end

---Create a sleep (delay) animation for an animation group
---@param animGroup LibAnimAnimationGroup Animation group to add to
---@param duration number Animation duration in seconds
---@param order number Animation order
---@return LibAnimAnimation sleep Created sleep animation
local function createSleep(animGroup, duration, order)
	local sleep = animGroup:CreateAnimation("sleep")
	assert(sleep, "Failed to create sleep animation")
	sleep:SetDuration(duration)
	sleep:SetOrder(order)
	return sleep
end

---Create shield frame with enter/leave animations
---@param parent Frame Parent frame to attach to
---@return Frame ShieldFrame Shield frame with animations
function CA:CreateShieldFrame(parent)
	local ShieldFrame = CreateFrame("Frame", nil, parent)
	ShieldFrame:SetFrameStrata("HIGH")
	ShieldFrame:SetFrameLevel(3)
	ShieldFrame:SetAlpha(0)
	ShieldFrame:Hide()

	local texture = ShieldFrame:CreateTexture()
	texture:SetTexture(W.Media.Textures.shield)
	texture:SetAllPoints()
	ShieldFrame.texture = texture

	-- Enter combat animation: Move to center + fade in -> delay -> fade out
	local enterGroup = CreateAnimationGroup(ShieldFrame)
	ShieldFrame.enter = enterGroup

	-- Order 1: Move upward and fade in simultaneously
	ShieldFrame.enter.moveToCenter = createMove(enterGroup, ANIMATION_TIMINGS.SHIELD_ENTER_MOVE_FADE, 1)
	ShieldFrame.enter.fadeIn = createFadeIn(enterGroup, ANIMATION_TIMINGS.SHIELD_ENTER_MOVE_FADE, 1)

	-- Order 2: Delay
	createSleep(enterGroup, ANIMATION_TIMINGS.SHIELD_ENTER_SLEEP, 2)

	-- Order 3: Fade out
	ShieldFrame.enter.fadeOut = createFadeOut(enterGroup, ANIMATION_TIMINGS.SHIELD_ENTER_FADEOUT, 3)

	enterGroup:SetScript("OnFinished", function()
		ShieldFrame:Hide()
		self:LoadNextAlert()
	end)

	-- Leave combat animation: Fade in -> delay -> move up + scale down + fade out
	local leaveGroup = CreateAnimationGroup(ShieldFrame)
	ShieldFrame.leave = leaveGroup

	-- Order 1: Fade in
	ShieldFrame.leave.fadeIn = createFadeIn(leaveGroup, ANIMATION_TIMINGS.SHIELD_LEAVE_FADEIN, 1)

	-- Order 2: Delay
	createSleep(leaveGroup, ANIMATION_TIMINGS.SHIELD_LEAVE_SLEEP, 2)

	-- Order 3: Move upward, scale down, and fade out simultaneously
	ShieldFrame.leave.moveUp = createMove(leaveGroup, ANIMATION_TIMINGS.SHIELD_LEAVE_MOVE_SCALE_FADEOUT, 3)

	local scaleWidth = leaveGroup:CreateAnimation("width")
	assert(scaleWidth, "Failed to create width animation")
	scaleWidth:SetDuration(ANIMATION_TIMINGS.SHIELD_LEAVE_MOVE_SCALE_FADEOUT)
	scaleWidth:SetOrder(3)
	ShieldFrame.leave.scaleWidth = scaleWidth

	local scaleHeight = leaveGroup:CreateAnimation("height")
	assert(scaleHeight, "Failed to create height animation")
	scaleHeight:SetDuration(ANIMATION_TIMINGS.SHIELD_LEAVE_MOVE_SCALE_FADEOUT)
	scaleHeight:SetOrder(3)
	ShieldFrame.leave.scaleHeight = scaleHeight

	ShieldFrame.leave.fadeOut = createFadeOut(leaveGroup, ANIMATION_TIMINGS.SHIELD_LEAVE_MOVE_SCALE_FADEOUT, 3)

	leaveGroup:SetScript("OnFinished", function()
		ShieldFrame:Hide()
		self:LoadNextAlert()
	end)

	return ShieldFrame
end

---Create sword frame with enter/leave animations
---@param parent Frame Parent frame to attach to
---@param flipHorizontal boolean Whether to flip the sword texture horizontally
---@return Frame SwordFrame Sword frame with animations
function CA:CreateSwordFrame(parent, flipHorizontal)
	local SwordFrame = CreateFrame("Frame", nil, parent)
	SwordFrame:SetFrameStrata("HIGH")
	SwordFrame:SetFrameLevel(2)
	SwordFrame:SetAlpha(0)
	SwordFrame:Hide()

	local texture = SwordFrame:CreateTexture()
	texture:SetTexture(W.Media.Textures.sword)

	if flipHorizontal then
		local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = texture:GetTexCoord()
		texture:SetTexCoord(URx, URy, LRx, LRy, ULx, ULy, LLx, LLy)
	end

	texture:SetAllPoints()
	SwordFrame.texture = texture

	-- Enter combat animation: Move to center + fade in -> delay -> fade out
	local enterGroup = CreateAnimationGroup(SwordFrame)
	SwordFrame.enter = enterGroup

	-- Step 1: Move toward center and fade in simultaneously
	SwordFrame.enter.moveToCenter = createMove(enterGroup, ANIMATION_TIMINGS.SWORD_ENTER_MOVE_FADE, 1)
	SwordFrame.enter.fadeIn = createFadeIn(enterGroup, ANIMATION_TIMINGS.SWORD_ENTER_MOVE_FADE, 1)

	-- Trigger shield animation when first sword finishes fading in
	if not flipHorizontal then
		SwordFrame.enter.fadeIn:SetScript("OnFinished", function()
			self.AnimationContainerFrame.ShieldFrame:Show()
			self.AnimationContainerFrame.ShieldFrame.enter:Play()
		end)
	end

	-- Step 2: Delay
	createSleep(enterGroup, ANIMATION_TIMINGS.SWORD_ENTER_SLEEP, 2)

	-- Step 3: Fade out
	SwordFrame.enter.fadeOut = createFadeOut(enterGroup, ANIMATION_TIMINGS.SWORD_ENTER_FADEOUT, 3)

	enterGroup:SetScript("OnFinished", function()
		SwordFrame:Hide()
	end)

	-- Leave combat animation: Fade in -> delay -> move to corner + fade out
	local leaveGroup = CreateAnimationGroup(SwordFrame)
	SwordFrame.leave = leaveGroup

	-- Step 1: Fade in
	SwordFrame.leave.fadeIn = createFadeIn(leaveGroup, ANIMATION_TIMINGS.SWORD_LEAVE_FADEIN, 1)

	-- Step 2: Delay
	createSleep(leaveGroup, ANIMATION_TIMINGS.SWORD_LEAVE_SLEEP, 2)

	-- Step 3: Move to corner and fade out (note: move is slightly longer than fade)
	SwordFrame.leave.moveToCorner = createMove(leaveGroup, ANIMATION_TIMINGS.SWORD_LEAVE_MOVE, 3)
	SwordFrame.leave.fadeOut = createFadeOut(leaveGroup, ANIMATION_TIMINGS.SWORD_LEAVE_FADEOUT, 3)

	leaveGroup:SetScript("OnFinished", function()
		SwordFrame:Hide()
	end)

	return SwordFrame
end

function CA:CreateAnimationFrame()
	if self.AnimationContainerFrame then
		return
	end

	-- Main container for all animation elements
	local ContainerFrame = CreateFrame("Frame", nil, self.AlertFrame)
	ContainerFrame:Point("TOP", 0, 0)
	self.AnimationContainerFrame = ContainerFrame

	-- Create shield (center element)
	ContainerFrame.ShieldFrame = self:CreateShieldFrame(ContainerFrame)

	-- Create left-to-right sword (from bottom-left corner)
	ContainerFrame.SwordLeftToRight = self:CreateSwordFrame(ContainerFrame, false)

	-- Create right-to-left sword (from bottom-right corner, flipped)
	ContainerFrame.SwordRightToLeft = self:CreateSwordFrame(ContainerFrame, true)
end

function CA:UpdateAnimationFrame()
	if not self.AnimationContainerFrame then
		return
	end

	local animationSize = self.db.animationSize
	local speedMultiplier = 1 / self.db.speed

	-- Calculate sizes and offsets based on animation scale
	local containerWidth = 240 * animationSize
	local containerHeight = 220 * animationSize
	local textureSize = 200 * animationSize
	local swordMovementRange = 130 * animationSize
	local shieldMovementRange = 65 * animationSize

	local container = self.AnimationContainerFrame

	container:Size(containerWidth, containerHeight)

	local shield = container.ShieldFrame
	shield:Hide()
	shield:Size(0.8 * textureSize)

	shield.enter.moveToCenter:SetOffset(0, -shieldMovementRange)
	shield.leave.moveUp:SetOffset(0, shieldMovementRange)

	local initialSize = 0.8 * textureSize
	shield.leave.scaleWidth:SetChange(initialSize * 0.1)
	shield.leave.scaleHeight:SetChange(initialSize * 0.1)

	for _, anim in ipairs(shield.enter.Animations) do
		if anim.Type == "move" or (anim.Type == "fade" and anim.Order == 1) then
			anim:SetDuration(ANIMATION_TIMINGS.SHIELD_ENTER_MOVE_FADE * speedMultiplier)
		elseif anim.Type == "sleep" then
			anim:SetDuration(ANIMATION_TIMINGS.SHIELD_ENTER_SLEEP * speedMultiplier)
		elseif anim.Type == "fade" and anim.Order == 3 then
			anim:SetDuration(ANIMATION_TIMINGS.SHIELD_ENTER_FADEOUT * speedMultiplier)
		end
	end

	for _, anim in ipairs(shield.leave.Animations) do
		if anim.Type == "fade" and anim.Order == 1 then
			anim:SetDuration(ANIMATION_TIMINGS.SHIELD_LEAVE_FADEIN * speedMultiplier)
		elseif anim.Type == "sleep" then
			anim:SetDuration(ANIMATION_TIMINGS.SHIELD_LEAVE_SLEEP * speedMultiplier)
		elseif anim.Type == "move" or anim.Type == "width" or anim.Type == "height" then
			anim:SetDuration(ANIMATION_TIMINGS.SHIELD_LEAVE_MOVE_SCALE_FADEOUT * speedMultiplier)
		elseif anim.Type == "fade" and anim.Order == 3 then
			anim:SetDuration(ANIMATION_TIMINGS.SHIELD_LEAVE_MOVE_SCALE_FADEOUT * speedMultiplier)
		end
	end

	-- Update left-to-right sword
	local swordLTR = container.SwordLeftToRight
	swordLTR:Hide()
	swordLTR:Size(textureSize)
	swordLTR.enter.moveToCenter:SetOffset(swordMovementRange, swordMovementRange)
	swordLTR.leave.moveToCorner:SetOffset(swordMovementRange, swordMovementRange)

	-- Update sword animation timings (left-to-right)
	for _, anim in ipairs(swordLTR.enter.Animations) do
		if anim.Type == "move" or (anim.Type == "fade" and anim.Order == 1) then
			anim:SetDuration(ANIMATION_TIMINGS.SWORD_ENTER_MOVE_FADE * speedMultiplier)
		elseif anim.Type == "sleep" then
			anim:SetDuration(ANIMATION_TIMINGS.SWORD_ENTER_SLEEP * speedMultiplier)
		elseif anim.Type == "fade" and anim.Order == 3 then
			anim:SetDuration(ANIMATION_TIMINGS.SWORD_ENTER_FADEOUT * speedMultiplier)
		end
	end

	for _, anim in ipairs(swordLTR.leave.Animations) do
		if anim.Type == "fade" and anim.Order == 1 then
			anim:SetDuration(ANIMATION_TIMINGS.SWORD_LEAVE_FADEIN * speedMultiplier)
		elseif anim.Type == "sleep" then
			anim:SetDuration(ANIMATION_TIMINGS.SWORD_LEAVE_SLEEP * speedMultiplier)
		elseif anim.Type == "move" then
			anim:SetDuration(ANIMATION_TIMINGS.SWORD_LEAVE_MOVE * speedMultiplier)
		elseif anim.Type == "fade" and anim.Order == 3 then
			anim:SetDuration(ANIMATION_TIMINGS.SWORD_LEAVE_FADEOUT * speedMultiplier)
		end
	end

	-- Update right-to-left sword
	local swordRTL = container.SwordRightToLeft
	swordRTL:Hide()
	swordRTL:Size(textureSize)
	swordRTL.enter.moveToCenter:SetOffset(-swordMovementRange, swordMovementRange)
	swordRTL.leave.moveToCorner:SetOffset(-swordMovementRange, swordMovementRange)

	-- Update sword animation timings (right-to-left)
	for _, anim in ipairs(swordRTL.enter.Animations) do
		if anim.Type == "move" or (anim.Type == "fade" and anim.Order == 1) then
			anim:SetDuration(ANIMATION_TIMINGS.SWORD_ENTER_MOVE_FADE * speedMultiplier)
		elseif anim.Type == "sleep" then
			anim:SetDuration(ANIMATION_TIMINGS.SWORD_ENTER_SLEEP * speedMultiplier)
		elseif anim.Type == "fade" and anim.Order == 3 then
			anim:SetDuration(ANIMATION_TIMINGS.SWORD_ENTER_FADEOUT * speedMultiplier)
		end
	end

	for _, anim in ipairs(swordRTL.leave.Animations) do
		if anim.Type == "fade" and anim.Order == 1 then
			anim:SetDuration(ANIMATION_TIMINGS.SWORD_LEAVE_FADEIN * speedMultiplier)
		elseif anim.Type == "sleep" then
			anim:SetDuration(ANIMATION_TIMINGS.SWORD_LEAVE_SLEEP * speedMultiplier)
		elseif anim.Type == "move" then
			anim:SetDuration(ANIMATION_TIMINGS.SWORD_LEAVE_MOVE * speedMultiplier)
		elseif anim.Type == "fade" and anim.Order == 3 then
			anim:SetDuration(ANIMATION_TIMINGS.SWORD_LEAVE_FADEOUT * speedMultiplier)
		end
	end
end

---Create text frame with enter/leave animations
function CA:CreateTextFrame()
	if self.TextFrame then
		return
	end

	local TextFrame = CreateFrame("Frame", nil, self.AlertFrame)
	TextFrame:SetFrameStrata("HIGH")
	TextFrame:SetFrameLevel(4)
	TextFrame:SetAlpha(0)
	TextFrame:Hide()

	TextFrame.text = TextFrame:CreateFontString()
	TextFrame.text:Point("CENTER", 0, 0)
	TextFrame.text:SetJustifyV("MIDDLE")
	TextFrame.text:SetJustifyH("CENTER")

	-- Enter combat animation: Move up + fade in -> move down slightly -> delay -> fade out
	local enterGroup = CreateAnimationGroup(TextFrame)
	TextFrame.enter = enterGroup

	-- Step 1: Move upward and fade in simultaneously
	TextFrame.enter.moveUp = createMove(enterGroup, ANIMATION_TIMINGS.TEXT_ENTER_MOVE_UP, 1)
	TextFrame.enter.fadeIn = createFadeIn(enterGroup, ANIMATION_TIMINGS.TEXT_ENTER_FADEIN, 1)

	-- Step 2: Move down slightly (bounce effect)
	TextFrame.enter.moveDown = createMove(enterGroup, ANIMATION_TIMINGS.TEXT_ENTER_MOVE_DOWN, 2)

	-- Step 3: Delay
	createSleep(enterGroup, ANIMATION_TIMINGS.TEXT_ENTER_SLEEP, 3)

	-- Step 4: Fade out
	TextFrame.enter.fadeOut = createFadeOut(enterGroup, ANIMATION_TIMINGS.TEXT_ENTER_FADEOUT, 4)

	-- Leave combat animation: Fade in -> delay -> move up + fade out
	local leaveGroup = CreateAnimationGroup(TextFrame)
	TextFrame.leave = leaveGroup

	-- Step 1: Fade in
	TextFrame.leave.fadeIn = createFadeIn(leaveGroup, ANIMATION_TIMINGS.TEXT_LEAVE_FADEIN, 1)

	-- Step 2: Delay
	createSleep(leaveGroup, ANIMATION_TIMINGS.TEXT_LEAVE_SLEEP, 2)

	-- Step 3: Move upward and fade out simultaneously
	TextFrame.leave.moveUp = createMove(leaveGroup, ANIMATION_TIMINGS.TEXT_LEAVE_MOVE_FADEOUT, 3)
	TextFrame.leave.fadeOut = createFadeOut(leaveGroup, ANIMATION_TIMINGS.TEXT_LEAVE_MOVE_FADEOUT, 3)

	self.TextFrame = TextFrame
end

function CA:UpdateTextFrame()
	if not self.TextFrame then
		return
	end

	local animationSize = self.db.animationSize
	local speedMultiplier = 1 / self.db.speed

	-- Calculate movement offsets based on animation scale
	local moveUpOffset = 160 * animationSize
	local moveDownOffset = -60 * animationSize

	local textFrame = self.TextFrame

	textFrame:Hide()
	F.SetFontWithDB(textFrame.text, self.db.font)
	textFrame.text:SetText(self.db.enterText)
	textFrame:Size(textFrame.text:GetStringWidth(), textFrame.text:GetStringHeight())

	-- Update animation offsets
	textFrame.enter.moveUp:SetOffset(0, moveUpOffset)
	textFrame.enter.moveDown:SetOffset(0, moveDownOffset)
	textFrame.leave.moveUp:SetOffset(0, -moveDownOffset)

	-- Update enter animation timings
	for _, anim in ipairs(textFrame.enter.Animations) do
		if anim.Type == "move" and anim.Order == 1 then
			anim:SetDuration(ANIMATION_TIMINGS.TEXT_ENTER_MOVE_UP * speedMultiplier)
		elseif anim.Type == "fade" and anim.Order == 1 then
			anim:SetDuration(ANIMATION_TIMINGS.TEXT_ENTER_FADEIN * speedMultiplier)
		elseif anim.Type == "move" and anim.Order == 2 then
			anim:SetDuration(ANIMATION_TIMINGS.TEXT_ENTER_MOVE_DOWN * speedMultiplier)
		elseif anim.Type == "sleep" then
			anim:SetDuration(ANIMATION_TIMINGS.TEXT_ENTER_SLEEP * speedMultiplier)
		elseif anim.Type == "fade" and anim.Order == 4 then
			anim:SetDuration(ANIMATION_TIMINGS.TEXT_ENTER_FADEOUT * speedMultiplier)
		end
	end

	-- Update leave animation timings
	for _, anim in ipairs(textFrame.leave.Animations) do
		if anim.Type == "fade" and anim.Order == 1 then
			anim:SetDuration(ANIMATION_TIMINGS.TEXT_LEAVE_FADEIN * speedMultiplier)
		elseif anim.Type == "sleep" then
			anim:SetDuration(ANIMATION_TIMINGS.TEXT_LEAVE_SLEEP * speedMultiplier)
		elseif anim.Type == "move" or (anim.Type == "fade" and anim.Order == 3) then
			anim:SetDuration(ANIMATION_TIMINGS.TEXT_LEAVE_MOVE_FADEOUT * speedMultiplier)
		end
	end

	-- If animation is disabled, text frame is responsible for loading next alert
	local OnFinished = function()
		textFrame:Hide()
		if not self.db.animation then
			self:LoadNextAlert()
		end
	end

	textFrame.enter.fadeOut:SetScript("OnFinished", OnFinished)
	textFrame.leave.fadeOut:SetScript("OnFinished", OnFinished)
end

---Display combat alert animation and text
---@param alertType "ENTER"|"LEAVE" Type of alert to show
function CA:ShowAlert(alertType)
	if not self.AnimationContainerFrame then
		self:Log("debug", "Animation container frame not initialized")
	end

	if not self.TextFrame then
		self:Log("debug", "Text frame not initialized")
	end

	-- Queue alert if one is already playing
	if isPlaying then
		self:QueueAlert(alertType)
		return
	end

	isPlaying = true

	local container = self.AnimationContainerFrame
	local textFrame = self.TextFrame
	local animationSize = self.db.animationSize

	-- Calculate positioning offsets for different animation states
	local swordOffsetEnter = 150 * animationSize
	local swordOffsetLeave = 20 * animationSize
	local shieldOffsetEnter = 50 * animationSize
	local shieldOffsetLeave = -15 * animationSize
	local textOffsetEnter = -100 * animationSize
	local textOffsetLeave = 0

	-- Stop any running animations
	if self.db.animation then
		container.ShieldFrame.enter:Stop()
		container.SwordLeftToRight.enter:Stop()
		container.SwordRightToLeft.enter:Stop()
		container.ShieldFrame.leave:Stop()
		container.SwordLeftToRight.leave:Stop()
		container.SwordRightToLeft.leave:Stop()
	end

	if self.db.text then
		textFrame.enter:Stop()
		textFrame.leave:Stop()
	end

	if alertType == "ENTER" then
		-- Enter combat sequence
		if self.db.animation then
			local textureSize = 200 * animationSize
			-- Position and show sword frames
			container.SwordLeftToRight:Size(textureSize)
			container.SwordLeftToRight:Point("CENTER", -swordOffsetEnter, -swordOffsetEnter)
			container.SwordLeftToRight:Show()

			container.SwordRightToLeft:Size(textureSize)
			container.SwordRightToLeft:Point("CENTER", swordOffsetEnter, -swordOffsetEnter)
			container.SwordRightToLeft:Show()

			-- Position shield frame (will be shown by sword animation callback)
			container.ShieldFrame:Size(0.8 * textureSize)
			container.ShieldFrame:Point("CENTER", 0, shieldOffsetEnter)

			-- Start sword animations (shield triggers from sword callback)
			container.SwordLeftToRight.enter:Play()
			container.SwordRightToLeft.enter:Play()
		end

		if self.db.text then
			local coloredText =
				C.GradientStringByRGB(self.db.enterText, self.db.enterColor.left, self.db.enterColor.right)
			textFrame.text:SetText(coloredText)
			textFrame:Size(textFrame.text:GetStringWidth(), textFrame.text:GetStringHeight())

			-- Position text below animations or alert frame
			local anchorFrame = self.db.animation and self.AnimationContainerFrame or self.AlertFrame
			textFrame:Point("TOP", anchorFrame, "BOTTOM", 0, textOffsetEnter)
			textFrame:Show()
			textFrame.enter:Play()
		end
	else
		-- Leave combat sequence
		if self.db.animation then
			local textureSize = 200 * animationSize

			-- Position and show all frames (including shield)
			container.ShieldFrame:Size(0.8 * textureSize)
			container.ShieldFrame:Point("CENTER", 0, shieldOffsetLeave)
			container.ShieldFrame:Show()

			container.SwordLeftToRight:Size(textureSize)
			container.SwordLeftToRight:Point("CENTER", -swordOffsetLeave, -swordOffsetLeave)
			container.SwordLeftToRight:Show()

			container.SwordRightToLeft:Size(textureSize)
			container.SwordRightToLeft:Point("CENTER", swordOffsetLeave, -swordOffsetLeave)
			container.SwordRightToLeft:Show()

			-- Start all leave animations simultaneously
			container.ShieldFrame.leave:Play()
			container.SwordLeftToRight.leave:Play()
			container.SwordRightToLeft.leave:Play()
		end

		if self.db.text then
			local coloredText =
				C.GradientStringByRGB(self.db.leaveText, self.db.leaveColor.left, self.db.leaveColor.right)
			textFrame.text:SetText(coloredText)
			textFrame:Size(textFrame.text:GetStringWidth(), textFrame.text:GetStringHeight())

			-- Position text below animations or alert frame
			local anchorFrame = self.db.animation and self.AnimationContainerFrame or self.AlertFrame
			textFrame:Point("TOP", anchorFrame, "BOTTOM", 0, textOffsetLeave)
			textFrame:Show()
			textFrame.leave:Play()
		end
	end
end

---Add an alert to the queue for later playback
---@param alertType "ENTER"|"LEAVE" Type of alert to queue
function CA:QueueAlert(alertType)
	tinsert(alertQueue, alertType)
end

---Load and play the next queued alert, if any
function CA:LoadNextAlert()
	isPlaying = false

	if alertQueue and alertQueue[1] then
		self:ShowAlert(alertQueue[1])
		tremove(alertQueue, 1)
	end
end

---Event handler: Player enters combat
function CA:PLAYER_REGEN_DISABLED()
	self:ShowAlert("ENTER")
end

function CA:PLAYER_REGEN_ENABLED()
	self:ShowAlert("LEAVE")
end

function CA:UpdateMover()
	if not self.AlertFrame then
		return
	end

	local width = 0
	local height = 0

	if self.db.animation and self.AnimationContainerFrame then
		width = width + (self.AnimationContainerFrame:GetWidth() or 0)
		height = height + (self.AnimationContainerFrame:GetHeight() or 0)
	end

	if self.db.text and self.TextFrame then
		width = max(width, self.AnimationContainerFrame:GetWidth() or 0)
		height = height + (self.TextFrame:GetHeight() or 0)
	end

	if width ~= 0 and height ~= 0 then
		self.AlertFrame:Size(width, height)
	end
end

function CA:UpdateFrames()
	if not self.AlertFrame then
		self:ConstructFrames()
	else
		self:UpdateAnimationFrame()
		self:UpdateTextFrame()
		self:UpdateMover()
	end
end

function CA:ConstructFrames()
	self.AlertFrame = CreateFrame("Frame", nil, E.UIParent)
	self.AlertFrame:Point("TOP", 0, -200)

	self:CreateAnimationFrame()
	self:CreateTextFrame()
	self:UpdateAnimationFrame()
	self:UpdateTextFrame()
	self:UpdateMover()

	E:CreateMover(
		self.AlertFrame,
		"WTCombatAlertFrameMover",
		L["Combat Alert"],
		nil,
		nil,
		nil,
		"ALL,WINDTOOLS",
		function()
			return E.db.WT.combat.combatAlert.enable
		end,
		"WindTools,combat,combatAlert"
	)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
end
function CA:Preview()
	self:ShowAlert("ENTER")
	self:QueueAlert("LEAVE")
end

function CA:Initialize()
	if not E.db.WT.combat.combatAlert.enable then
		return
	end

	self.db = E.db.WT.combat.combatAlert
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "ConstructFrames")
end

function CA:ProfileUpdate()
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

W:RegisterModule(CA:GetName())
