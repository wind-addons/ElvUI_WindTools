local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs
local select = select

local CreateColor = CreateColor

local function ReskinFriendButton(button)
	if button.right then
		return
	end

	button.right = button:CreateTexture(nil, "BACKGROUND")
	button.right:Width(button:GetWidth() / 2)
	button.right:Height(32)
	button.right:Point("LEFT", button, "CENTER", 0)
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

local function ReskinPartyButton(button)
	if button.__windSkin then
		return
	end

	button:Width(button:GetWidth() - 4)

	S:Proxy("HandleButton", button)

	local normal = button:GetNormalTexture()
	normal:SetTexture(W.Media.Icons.buttonPlus)
	normal:SetTexCoord(0, 1, 0, 1)
	normal:Size(14)
	normal:ClearAllPoints()
	normal:Point("CENTER")
	normal:SetVertexColor(1, 1, 1, 1)

	local disabled = button:GetDisabledTexture()
	disabled:SetTexture(W.Media.Icons.buttonPlus)
	disabled:SetTexCoord(0, 1, 0, 1)
	disabled:Size(14)
	disabled:ClearAllPoints()
	disabled:Point("CENTER")
	disabled:SetVertexColor(0.4, 0.4, 0.4, 1)
	disabled:SetDesaturated(true)

	F.Move(button, -3, 0)

	button.__windSkin = true
end

local function ReskinRecentAllyButton(button)
	local normal = button:GetNormalTexture()
	normal:SetTexture(E.media.blankTex)
	normal:Width(button:GetWidth() / 2)
	normal:Height(button:GetHeight() - 2)
	normal:Point("LEFT", button, "CENTER", 0)
	normal:SetGradient("HORIZONTAL", CreateColor(0.243, 0.57, 1, 0), CreateColor(0.243, 0.57, 1, 0.25))

	if not button.__windSkin then
		local highlight = button:GetHighlightTexture()
		highlight:SetTexture(E.media.blankTex)
		highlight:SetVertexColor(0.243, 0.57, 1, 0.2)
		highlight:SetInside(button)

		F.InternalizeMethod(highlight, "SetTexture", true)
		F.InternalizeMethod(highlight, "SetVertexColor", true)

		button:HookScript("OnEnter", function()
			highlight:Show()
		end)

		button:HookScript("OnLeave", function()
			highlight:Hide()
		end)

		button.__windSkin = true
	end

	ReskinPartyButton(button.PartyButton)
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

	for _, tab in next, { _G.FriendsTabHeader.TabSystem:GetChildren() } do
		local Text = tab.Text
		if Text then
			hooksecurefunc(Text, "SetPoint", function(text, point, relativeTo, relativePoint, xOffset, yOffset)
				if point == "CENTER" and relativeTo == tab and relativePoint == "CENTER" then
					if F.IsAlmost(xOffset, 0) and (F.IsAlmost(yOffset, -3) or F.IsAlmost(yOffset, 0)) then
						Text:ClearAllPoints()
						Text:Point("CENTER", tab, "CENTER", 0, 1)
					end
				end
			end)
		end
	end

	self:SecureHook("FriendsFrame_UpdateFriendButton", ReskinFriendButton)

	local RecentAlliesFrame = _G.RecentAlliesFrame
	if RecentAlliesFrame and RecentAlliesFrame.List and RecentAlliesFrame.List.ScrollBox then
		self:SecureHook(RecentAlliesFrame.List.ScrollBox, "Update", function(scrollBox)
			scrollBox:ForEachFrame(ReskinRecentAllyButton)
		end)
	end

	self:SecureHook(_G.RecruitAFriendRewardsFrame, "UpdateRewards", UpdateRewards)
	UpdateRewards()
end

S:AddCallback("FriendsFrame")
