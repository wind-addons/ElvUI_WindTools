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

		local icon = partyButton:CreateTexture(nil, "ARTWORK")
		icon:SetTexture("Interface\\FriendsFrame\\TravelPass-Invite")
		icon:SetTexCoord(0.01562500, 0.39062500, 0.27343750, 0.52343750)
		icon:SetAllPoints(partyButton)
		icon:SetVertexColor(1, 1, 1, 1)

		partyButton.inviteIcon = icon
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
