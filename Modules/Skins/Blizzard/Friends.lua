local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

local CreateColor = CreateColor

local function UpdateFriendButton(button)
	if button.right then
		return
	end

	button.right = button:CreateTexture(nil, "BACKGROUND")
	button.right:SetWidth(button:GetWidth() / 2)
	button.right:SetHeight(32)
	button.right:SetPoint("LEFT", button, "CENTER", 0)
	button.right:SetTexture(E.Media.Textures.White8x8)
	button.right:SetGradient("HORIZONTAL", CreateColor(0.243, 0.57, 1, 0), CreateColor(0.243, 0.57, 1, 0.25))

	if button.gameIcon then
		button.gameIcon:HookScript("OnShow", function()
			button.right:Show()
		end)

		button.gameIcon:HookScript("OnHide", function()
			button.right:Hide()
		end)

		if button.gameIcon:IsShown() then
			button.right:Show()
		else
			button.right:Hide()
		end
	end
end

local function UpdateRewards()
	for tab in _G.RecruitAFriendRewardsFrame.rewardTabPool:EnumerateActive() do
		if not tab.__windSkin then
			S:CreateBackdropShadow(tab)
			local relativeTo = select(2, tab:GetPoint(1))
			if relativeTo and relativeTo == _G.RecruitAFriendRewardsFrame then
				F.Move(tab, 4, 0)
			end
			tab.__windSkin = true
		end
	end
end

function S:FriendsFrame()
	if not self:CheckDB("friends") then
		return
	end

	_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame:ClearAllPoints()
	_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame:Point("TOPLEFT", _G.FriendsFrame, "TOPRIGHT", 3, -1)

	local frames = {
		_G.FriendsFrame,
		_G.FriendsFriendsFrame,
		_G.AddFriendFrame,
		_G.RecruitAFriendFrame.SplashFrame,
		_G.RecruitAFriendRewardsFrame,
		_G.RecruitAFriendRecruitmentFrame,
		_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame,
		_G.FriendsFrameBattlenetFrame.BroadcastFrame,
		_G.QuickJoinRoleSelectionFrame,
	}

	for _, frame in pairs(frames) do
		self:CreateShadow(frame)
	end

	self:CreateShadow(_G.BNToastFrame)

	for i = 1, 4 do
		self:ReskinTab(_G["FriendsFrameTab" .. i])
	end

	self:SecureHook("FriendsFrame_UpdateFriendButton", UpdateFriendButton)
	self:SecureHook(_G.RecruitAFriendRewardsFrame, "UpdateRewards", UpdateRewards)
	UpdateRewards()
end

S:AddCallback("FriendsFrame")
