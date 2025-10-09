local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

local function SkinRecentAllyEntry(button)
	if not button or button.__windSkinned then
		return
	end

	if button.PartyButton then
		local partyButton = button.PartyButton

		S:Proxy("HandleButton", partyButton)

		local normalTexture = partyButton:GetNormalTexture()
		if normalTexture then
			normalTexture:SetTexture("Interface\\FriendsFrame\\TravelPass-Invite")
			normalTexture:SetTexCoord(0.01562500, 0.26562500, 0.27343750, 0.52343750)
			normalTexture:SetAllPoints(partyButton)
			normalTexture:SetVertexColor(1, 1, 1, 1)
		end

		local pushedTexture = partyButton:GetPushedTexture()
		if pushedTexture then
			pushedTexture:SetTexture("Interface\\FriendsFrame\\TravelPass-Invite")
			pushedTexture:SetTexCoord(0.42187500, 0.67187500, 0.27343750, 0.52343750)
			pushedTexture:SetAllPoints(partyButton)
			pushedTexture:SetVertexColor(1, 1, 1, 1)
		end

		local highlightTexture = partyButton:GetHighlightTexture()
		if highlightTexture then
			highlightTexture:SetTexture("Interface\\FriendsFrame\\TravelPass-Invite")
			highlightTexture:SetTexCoord(0.42187500, 0.67187500, 0.00781250, 0.25781250)
			highlightTexture:SetAllPoints(partyButton)
			highlightTexture:SetVertexColor(1, 1, 1, 0.5)
		end

		local disabledTexture = partyButton:GetDisabledTexture()
		if disabledTexture then
			disabledTexture:SetTexture("Interface\\FriendsFrame\\TravelPass-Invite")
			disabledTexture:SetTexCoord(0.01562500, 0.26562500, 0.00781250, 0.25781250)
			disabledTexture:SetAllPoints(partyButton)
			disabledTexture:SetVertexColor(0.5, 0.5, 0.5, 1)
		end
	end

	button.__windSkinned = true
end

function S:RecentAlliesFrame()
	if not self:CheckDB("friends", "recentAllies") then
		return
	end

	local RecentAlliesFrame = _G.RecentAlliesFrame
	if not RecentAlliesFrame then
		return
	end

	self:CreateShadow(RecentAlliesFrame)

	if RecentAlliesFrame.List and RecentAlliesFrame.List.ScrollBox then
		hooksecurefunc(RecentAlliesFrame.List.ScrollBox, "Update", function(scrollBox)
			local target = scrollBox:GetScrollTarget()
			if not target or not target.GetChildren then
				return
			end

			for _, button in pairs({ target:GetChildren() }) do
				SkinRecentAllyEntry(button)
			end
		end)
	end
end

S:AddCallback("RecentAlliesFrame")
