local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local pairs = pairs

local CreateColor = CreateColor

function S:UpdateFriendButton(button)
	if not button.right then
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

	self:SecureHook("FriendsFrame_UpdateFriendButton", "UpdateFriendButton")
end

S:AddCallback("FriendsFrame")
