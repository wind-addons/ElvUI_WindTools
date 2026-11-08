local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

if not E.Forever then
	return
end

local _G = _G
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local next = next

-- ElvUI skins SocialUIFrame as part of its "friends" skin
S:AddCallback("SocialUI", "friends", "socialUI")

-- SocialUI uses UserScaledFont* objects, which ElvUI does not replace,
-- so pass the ElvUI font explicitly instead of keeping the current font path
local function SetFont(text)
	if text then
		F.SetFont(text, E.db.general.font)
	end
end

local function SetButtonFont(button)
	if button and button.GetFontString then
		SetFont(button:GetFontString())
	end
end

local function SetTitleFont(frame)
	local titleText = frame and frame.TitleContainer and frame.TitleContainer.TitleText
	if titleText then
		SetFont(titleText)
	end
end

local function ReskinSocialTab(tab)
	if not tab or tab.__windSkin then
		return
	end

	S:ReskinTab(tab)

	if tab.Count then
		SetFont(tab.Count)
	end

	tab.__windSkin = true
end

local function UpdateSocialTabs(frame)
	for _, data in ipairs(frame.availableTabData or {}) do
		ReskinSocialTab(frame:GetTabByType(data.tabType))
	end
end

-- Headers in the contacts scroll boxes (friends, recent allies, quick join, requests, recruits)
local function UpdateSocialRow(row)
	if row.__windSkin then
		return
	end

	if row.CollapseButton and row.ButtonText then
		SetFont(row.ButtonText)
	end

	row.__windSkin = true
end

local function UpdateIgnoreRow(row)
	if row.__windSkin then
		return
	end

	SetFont(row.Name)
	SetFont(row.Text)

	row.__windSkin = true
end

local function HandleContactsFrame(frame)
	if not frame then
		return
	end

	SetButtonFont(frame.ActionButton)

	if frame.FriendsDisabledText then
		SetFont(frame.FriendsDisabledText)
	end

	if frame.ScrollBox then
		hooksecurefunc(frame.ScrollBox, "Update", function(scrollBox)
			scrollBox:ForEachFrame(UpdateSocialRow)
		end)
	end
end

local function HandleRaidFrame(raidFrame)
	if not raidFrame then
		return
	end

	SetButtonFont(raidFrame.RaidInfoButton)
	SetButtonFont(raidFrame.ConvertToRaidButton)

	if raidFrame.AllAssistCheckButton then
		F.SetFrameFontOutline(raidFrame.AllAssistCheckButton, E.db.general.font)
	end
end

local function HandleRaidInfoFrame(raidInfo)
	if not raidInfo then
		return
	end

	S:CreateShadow(raidInfo)
	SetButtonFont(raidInfo.ExtendButton)
	F.SetFrameFontOutline(raidInfo, E.db.general.font)
end

function S:SocialUI()
	local socialFrame = _G.SocialUIFrame
	if not socialFrame then
		return
	end

	self:CreateShadow(socialFrame)
	SetTitleFont(socialFrame)

	-- Tabs are pooled and rebuilt by RefreshTabs
	hooksecurefunc(socialFrame, "RefreshTabs", UpdateSocialTabs)
	if socialFrame.availableTabData then
		UpdateSocialTabs(socialFrame)
	end

	-- Battle.net bar
	local bnetControls = socialFrame.BattleNetBar and socialFrame.BattleNetBar.ControlsContainer
	if bnetControls then
		local battleTag = bnetControls.PersonalBattleTagDisplay
		if battleTag and battleTag.DisplayText then
			SetFont(battleTag.DisplayText)
		end

		local statusDropdown = bnetControls.OnlineStatusDropdown
		if statusDropdown and statusDropdown.Text then
			SetFont(statusDropdown.Text)
		end
	end

	-- Side windows
	local notice = socialFrame.BattleNetUnavailableNoticeFrame
	if notice then
		self:CreateShadow(notice)
		SetFont(notice.Text)
		if notice.Header then
			SetFont(notice.Header.HeaderText)
		end
	end

	local broadcast = socialFrame.BattleNetBroadcastFrame
	if broadcast then
		self:CreateShadow(broadcast)
		SetFont(broadcast.Title)
		SetButtonFont(broadcast.UpdateButton)
		SetButtonFont(broadcast.CancelButton)
		if broadcast.EditBox then
			SetFont(broadcast.EditBox.PromptText)
		end
	end

	local ignoreList = socialFrame.IgnoreListFrame
	if ignoreList then
		self:CreateShadow(ignoreList)
		SetTitleFont(ignoreList)
		SetButtonFont(ignoreList.BlockButton)
		SetButtonFont(ignoreList.UnblockButton)
		if ignoreList.ScrollBox then
			hooksecurefunc(ignoreList.ScrollBox, "Update", function(scrollBox)
				scrollBox:ForEachFrame(UpdateIgnoreRow)
			end)
		end
	end

	-- Tab content frames
	for _, frame in next, {
		socialFrame.FriendsList,
		socialFrame.RecentAlliesList,
		socialFrame.QuickJoinFrame,
		socialFrame.FriendRequestsList,
		socialFrame.RecruitAFriendFrame,
	} do
		HandleContactsFrame(frame)
	end

	local requests = socialFrame.FriendRequestsList
	if requests and requests.RealIDWarning then
		SetButtonFont(requests.RealIDWarning.ContinueButton)
	end

	local recruit = socialFrame.RecruitAFriendFrame
	if recruit and recruit.RewardClaiming then
		SetButtonFont(recruit.RewardClaiming.ClaimOrViewRewardButton)
	end

	HandleRaidFrame(socialFrame.RaidFrame)
	HandleRaidInfoFrame(socialFrame.RaidInfoFrame)
end
