local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

local trackers = {
	_G.ScenarioObjectiveTracker,
	_G.UIWidgetObjectiveTracker,
	_G.CampaignQuestObjectiveTracker,
	_G.QuestObjectiveTracker,
	_G.AdventureObjectiveTracker,
	_G.AchievementObjectiveTracker,
	_G.MonthlyActivitiesObjectiveTracker,
	_G.ProfessionsRecipeTracker,
	_G.BonusObjectiveTracker,
	_G.WorldQuestObjectiveTracker,
}

function S:ReskinObjectiveTrackerHeader(header)
	if not header or not header.Text then
		return
	end

	if E.private and E.private.WT and E.private.WT.quest.objectiveTracker.enable then
		return
	end

	F.SetFont(header.Text)
end

-- Copied from ElvUI ObjectiveTracker skin
local function ReskinQuestIcon(button)
	if not button then
		return
	end

	if not button.IsSkinned then
		button:Size(24)
		button:SetNormalTexture(E.ClearTexture)
		button:SetPushedTexture(E.ClearTexture)
		button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)

		local icon = button.icon or button.Icon
		if icon then
			S:Proxy("HandleIcon", icon, true)
			icon:SetInside()
		end

		button.IsSkinned = true
	end

	if button.backdrop then
		button.backdrop:SetFrameLevel(0)
	end
end

function S:ReskinObjectiveTrackerBlockRightEdgeButton(_, block)
	local frame = block.rightEdgeFrame
	if not frame then
		return
	end

	if frame.template == "QuestObjectiveFindGroupButtonTemplate" and not frame.__windSkin then
		frame:GetNormalTexture():SetAlpha(0)
		frame:GetPushedTexture():SetAlpha(0)
		frame:GetHighlightTexture():SetAlpha(0)
		self:Proxy("HandleButton", frame, nil, nil, nil, true)
		frame.backdrop:SetInside(frame, 4, 4)
		self:CreateBackdropShadow(frame)
		frame.__windSkin = true
	end

	if frame.template == "QuestObjectiveItemButtonTemplate" and not frame.__windSkin then
		ReskinQuestIcon(frame)
		self:CreateShadow(frame)
		frame.__windSkin = true
	end
end

function S:ReskinObjectiveTrackerBlock(_, block)
	self:ReskinObjectiveTrackerBlockRightEdgeButton(_, block)

	if block.AddRightEdgeFrame and not self:IsHooked(block, "AddRightEdgeFrame") then
		self:SecureHook(block, "AddRightEdgeFrame", "ReskinObjectiveTrackerBlockRightEdgeButton")
	end
end

function S:SkinProgressBar(tracker, key)
	local progressBar = tracker.usedProgressBars[key]
	if not progressBar or not progressBar.Bar or progressBar.__windSkin then
		return
	end

	self:CreateBackdropShadow(progressBar.Bar)

	if progressBar.Bar.Icon then
		self:CreateBackdropShadow(progressBar.Bar.Icon)
	end

	-- move text to center
	if progressBar.Bar.Label then
		progressBar.Bar.Label:ClearAllPoints()
		progressBar.Bar.Label:Point("CENTER", progressBar.Bar, 0, 0)
		F.SetFont(progressBar.Bar.Label)
	end

	-- change font style of header
	if not E.private.WT.quest.objectiveTracker.menuTitle.enable then
		if _G.ObjectiveTrackerFrame and _G.ObjectiveTrackerFrame.HeaderMenu then
			F.SetFont(_G.ObjectiveTrackerFrame.HeaderMenu.Title)
		end
	end

	progressBar.__windSkin = true
end

function S:SkinTimerBar(tracker, key)
	local timerBar = tracker.usedTimerBars[key]
	self:CreateBackdropShadow(timerBar and timerBar.Bar)
end

function S:Blizzard_ObjectiveTracker()
	if not self:CheckDB("objectiveTracker") then
		return
	end

	self.questItemButtons = {}

	local MainHeader = _G.ObjectiveTrackerFrame.Header
	self:ReskinObjectiveTrackerHeader(MainHeader)

	for _, tracker in pairs(trackers) do
		self:ReskinObjectiveTrackerHeader(tracker.Header)

		for _, block in pairs(tracker.usedBlocks or {}) do
			self:ReskinObjectiveTrackerBlock(tracker, block)
		end

		self:SecureHook(tracker, "AddBlock", "ReskinObjectiveTrackerBlock")
		self:SecureHook(tracker, "GetProgressBar", "SkinProgressBar")
		self:SecureHook(tracker, "GetTimerBar", "SkinTimerBar")
	end
end

S:AddCallback("Blizzard_ObjectiveTracker")
