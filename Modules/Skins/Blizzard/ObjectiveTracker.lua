local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

local data = S:AddCallback("Blizzard_ObjectiveTracker", "objectiveTracker")

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

function data:ReskinObjectiveTrackerHeader(header)
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

function data:ReskinObjectiveTrackerBlockRightEdgeButton(block) -- self is the hooked block or the tracker module, not data
	local frame = block.rightEdgeFrame
	if not frame then
		return
	end

	if frame.template == "QuestObjectiveFindGroupButtonTemplate" and not frame.__windSkin then
		frame:GetNormalTexture():SetAlpha(0)
		frame:GetPushedTexture():SetAlpha(0)
		frame:GetHighlightTexture():SetAlpha(0)
		S:Proxy("HandleButton", frame, nil, nil, nil, true)
		frame.backdrop:SetInside(frame, 4, 4)
		S:CreateBackdropShadow(frame)
		frame.__windSkin = true
	end

	if frame.template == "QuestObjectiveItemButtonTemplate" and not frame.__windSkin then
		ReskinQuestIcon(frame)
		S:CreateShadow(frame)
		frame.__windSkin = true
	end
end

function data:ReskinObjectiveTrackerBlock(block) -- self is the tracker module, not data
	data.ReskinObjectiveTrackerBlockRightEdgeButton(self, block)

	if block.AddRightEdgeFrame and not S:IsHooked(block, "AddRightEdgeFrame") then
		S:SecureHook(block, "AddRightEdgeFrame", data.ReskinObjectiveTrackerBlockRightEdgeButton)
	end
end

function data:SkinProgressBar(key) -- self is the tracker module, not data
	local tracker = self
	local progressBar = tracker.usedProgressBars[key]
	if not progressBar or not progressBar.Bar or progressBar.__windSkin then
		return
	end

	S:CreateBackdropShadow(progressBar.Bar)

	if progressBar.Bar.Icon then
		S:CreateBackdropShadow(progressBar.Bar.Icon)
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

function data:SkinTimerBar(key) -- self is the tracker module, not data
	local tracker = self
	local timerBar = tracker.usedTimerBars[key]
	S:CreateBackdropShadow(timerBar and timerBar.Bar)
end

function S:Blizzard_ObjectiveTracker()
	self.questItemButtons = {}

	local MainHeader = _G.ObjectiveTrackerFrame.Header
	data:ReskinObjectiveTrackerHeader(MainHeader)

	for _, tracker in pairs(trackers) do
		data:ReskinObjectiveTrackerHeader(tracker.Header)

		for _, block in pairs(tracker.usedBlocks or {}) do
			data.ReskinObjectiveTrackerBlock(tracker, block)
		end

		self:SecureHook(tracker, "AddBlock", data.ReskinObjectiveTrackerBlock)
		self:SecureHook(tracker, "GetProgressBar", data.SkinProgressBar)
		self:SecureHook(tracker, "GetTimerBar", data.SkinTimerBar)
	end
end
