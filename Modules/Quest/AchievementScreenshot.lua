local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local AS = W:NewModule("AchievementScreenshot", "AceEvent-3.0", "AceHook-3.0") ---@class AchievementScreenshot : AceModule, AceEvent-3.0, AceHook-3.0
local CA = W:GetModule("CombatAlert") ---@class CombatAlert

local _G = _G

local RunNextFrame = RunNextFrame

local blizzardAlertFrame ---@type Frame?
local isProcessingScreenshot = false

function AS:DelayScreenshot(_, _, alreadyEarnedOnAccount)
	if isProcessingScreenshot then
		return
	end

	if alreadyEarnedOnAccount and self.db.ignoreAlreadyEarned then
		self:Log("debug", "Ignoring screenshot for already earned achievement.")
		return
	end

	isProcessingScreenshot = true

	-- Add a slight delay to ensure achievements earned simultaneously are processed only once
	E:Delay(0.1, function()
		F.WaitFor(function()
			if blizzardAlertFrame and blizzardAlertFrame.IsShown and blizzardAlertFrame:IsShown() then
				return true
			end

			return false
		end, function()
			--- Cache the config for async operations
			local hideCombatAlert = self.db
				and self.db.hideCombatAlert
				and CA
				and CA.AlertFrame
				and CA.AlertFrame:IsShown()
			local forceShowUI = self.db and self.db.forceShowUI and not _G.UIParent:IsShown()
			local chatMessage = self.db and self.db.chatMessage

			if hideCombatAlert then
				CA.AlertFrame:Hide()
			end

			if forceShowUI then
				_G.UIParent:Show()
			end

			E:Delay(1.4, function()
				_G.Screenshot()
				RunNextFrame(function()
					if chatMessage then
						F.Print(L["Screenshot has been automatically taken."])
					end

					if hideCombatAlert then
						CA.AlertFrame:Show()
					end

					isProcessingScreenshot = false
				end)
			end)
		end, 0.1, 20)
	end)
end

function AS:AddAlertFrame(_, frame)
	blizzardAlertFrame = frame
	E:Delay(2, function()
		if frame == blizzardAlertFrame then
			blizzardAlertFrame = nil
		end
	end)
end

function AS:Initialize()
	self.db = E.db.WT.quest.achievementScreenshot

	if self.initialized or not self.db.enable then
		return
	end

	self:RegisterEvent("ACHIEVEMENT_EARNED", "DelayScreenshot")
	self:SecureHook(_G.AchievementAlertSystem:GetAlertContainer(), "AddAlertFrame")

	self.initialized = true
end
function AS:ProfileUpdate()
	self:Initialize()

	if self.initialized and not self.db.enable then
		self:UnregisterEvent("ACHIEVEMENT_EARNED")
		self:UnhookAll()
		self.initialized = false
	end
end

W:RegisterModule(AS:GetName())
