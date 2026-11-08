local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

if not E.Forever then
	return
end

local _G = _G
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local next = next

-- ElvUI skins the Forever group finder in its "lfg" skin
S:AddCallbackForAddon("Blizzard_GroupFinder_VanillaStyle", "LFGListing", "lfg", "lookingForGroup")

-- Pass the ElvUI font explicitly, the group finder uses its own font objects
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

-- Blizzard calls SetFontObject on every init, so the font is set again each time
local function UpdateActivityGroupButton(button)
	if button and button.NameButton then
		SetFont(button.NameButton.Name)
	end
end

local function UpdateActivityButton(button)
	if not button then
		return
	end

	if button.NameButton then
		SetFont(button.NameButton.Name)
	end
	SetFont(button.Level)
end

local function UpdateCategoryButton(frame, btnIndex)
	local button = frame.CategoryButtons and frame.CategoryButtons[btnIndex]
	if button and not button.__windSkin then
		SetButtonFont(button)
		button.__windSkin = true
	end
end

function S:LFGListing()
	local parentFrame = _G.LFGParentFrame
	local listingFrame = _G.LFGListingFrame
	if not parentFrame or not listingFrame then
		return
	end

	-- Listing, browse and who list share the parent frame and swap on tab change
	for _, frame in next, { listingFrame, _G.LFGBrowseFrame, _G.LFGWhoListFrame } do
		self:CreateShadow(frame)
	end

	for _, tab in next, { parentFrame.ListingTab, parentFrame.BrowsingTab, parentFrame.WhoListingTab } do
		self:ReskinTab(tab)
	end

	-- Listing
	local titleText = listingFrame.TitleContainer and listingFrame.TitleContainer.TitleText
	SetFont(titleText)

	SetButtonFont(listingFrame.BackButton)
	SetButtonFont(listingFrame.PostButton)

	local groupRoleButtons = listingFrame.GroupRoleButtons
	if groupRoleButtons then
		SetButtonFont(groupRoleButtons.RolePollButton)
		if groupRoleButtons.RoleDropdown then
			SetFont(groupRoleButtons.RoleDropdown.Text)
		end
	end

	if listingFrame.NewPlayerFriendlyButton then
		F.SetFrameFontOutline(listingFrame.NewPlayerFriendlyButton, E.db.general.font)
	end

	local activityView = listingFrame.ActivityView
	if activityView then
		SetFont(activityView.VoiceChatLabel)

		if activityView.LevelRangesCheckbox then
			SetFont(activityView.LevelRangesCheckbox.Text)
		end

		for _, key in next, { "PlayStyleDropdown", "VoiceChatDropdown" } do
			local dropdown = activityView[key]
			if dropdown then
				SetFont(dropdown.Text)
			end
		end
	end

	local comment = _G.LFGListingComment
	if comment then
		SetFont(comment.CharCount)
		if comment.EditBox then
			SetFont(comment.EditBox)
			SetFont(comment.EditBox.Instructions)
		end
	end

	local lockedView = listingFrame.LockedView
	if lockedView then
		SetFont(lockedView.ErrorText)
		SetFont(lockedView.ActivityText)
	end

	local categorySelection = listingFrame.CategoryView and listingFrame.CategoryView.CategorySelection
	if categorySelection and categorySelection.CategoryButtons then
		for index in ipairs(categorySelection.CategoryButtons) do
			UpdateCategoryButton(categorySelection, index)
		end
	end

	hooksecurefunc("LFGListingCategorySelection_AddButton", UpdateCategoryButton)
	hooksecurefunc("LFGListingActivityView_InitActivityButton", UpdateActivityButton)
	hooksecurefunc("LFGListingActivityView_InitActivityGroupButton", UpdateActivityGroupButton)
end
