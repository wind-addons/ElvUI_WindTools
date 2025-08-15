local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G
local pairs = pairs
local strmatch = strmatch

function S:PremadeGroupsFilter_SetPoint(frame, point, relativeFrame, relativePoint, x, y)
	if point == "TOPLEFT" and relativePoint == "TOPRIGHT" then
		if (not x and not y) or (x == 0 and y == 0) then
			frame:ClearAllPoints()
			frame:SetPoint("TOPLEFT", relativeFrame, "TOPRIGHT", 5, 0)
		end
	end
end

function S:PremadeGroupsFilter()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.premadeGroupsFilter then
		return
	end

	self:DisableAddOnSkin("PremadeGroupsFilter")

	local frame = _G.PremadeGroupsFilterDialog
	self:Proxy("HandlePortraitFrame", frame, true)

	-- Extend 1 pixel looks as same height as PVEFrame
	frame.backdrop:SetTemplate("Transparent")
	frame.backdrop:ClearAllPoints()
	frame.backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 0)
	frame.backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)

	self:CreateBackdropShadow(frame, true)
	self:MerathilisUISkin(frame)

	-- Because we added shadow, moving the frame a little bit right looks better
	self:SecureHook(frame, "SetPoint", "PremadeGroupsFilter_SetPoint")

	for i = 1, frame:GetNumPoints() do
		S:PremadeGroupsFilter_SetPoint(frame, frame:GetPoint())
	end

	if frame.Advanced then
		for _, region in pairs({ frame.Advanced:GetRegions() }) do
			local name = region.GetName and region:GetName()
			if name and (strmatch(name, "Corner") or strmatch(name, "Border")) then
				region:StripTextures()
			end
		end
	end

	if frame.Expression then
		self:Proxy("HandleEditBox", frame.Expression)
	end

	if frame.ResetButton then
		self:Proxy("HandleButton", frame.ResetButton)
	end

	if frame.RefreshButton then
		self:Proxy("HandleButton", frame.RefreshButton)
	end

	if frame.MaxMinButtonFrame.MinimizeButton then
		self:Proxy("HandleNextPrevButton", frame.MaxMinButtonFrame.MinimizeButton, "up", nil, true)
		frame.MaxMinButtonFrame.MinimizeButton:ClearAllPoints()
		frame.MaxMinButtonFrame.MinimizeButton:Point("RIGHT", frame.CloseButton, "LEFT")
	end

	if frame.MaxMinButtonFrame.MaximizeButton then
		self:Proxy("HandleNextPrevButton", frame.MaxMinButtonFrame.MaximizeButton, "down", nil, true)
		frame.MaxMinButtonFrame.MaximizeButton:ClearAllPoints()
		frame.MaxMinButtonFrame.MaximizeButton:Point("RIGHT", frame.CloseButton, "LEFT")
	end

	for _, line in pairs({
		"Difficulty",
		"Defeated",
		"MPRating",
		"PVPRating",
		"Members",
		"Tanks",
		"Heals",
		"Dps",
	}) do
		if frame[line] then
			if frame[line].Act then
				self:Proxy("HandleCheckBox", frame[line].Act)
				frame[line].Act:Size(24)
				frame[line].Act:ClearAllPoints()
				frame[line].Act:Point("LEFT", frame[line], "LEFT", 3, -3)
			end

			if line == "Defeated" and frame[line].Title then
				frame[line].Title:SetHeight(18)
			end

			if frame[line].DropDown then
				self:Proxy("HandleDropDownBox", frame[line].DropDown)
			end

			if frame[line].Min then
				self:Proxy("HandleEditBox", frame[line].Min)
				frame[line].Min.backdrop:ClearAllPoints()
				frame[line].Min.backdrop:SetOutside(frame[line].Min, 0, 0)
			end

			if frame[line].Max then
				self:Proxy("HandleEditBox", frame[line].Max)
				frame[line].Max.backdrop:ClearAllPoints()
				frame[line].Max.backdrop:SetOutside(frame[line].Max, 0, 0)
			end
		end
	end

	if frame.Sorting and frame.Sorting.SortingExpression then
		self:Proxy("HandleEditBox", frame.Sorting.SortingExpression)
		frame.Sorting.SortingExpression.backdrop:ClearAllPoints()
		frame.Sorting.SortingExpression.backdrop:SetOutside(frame.Sorting.SortingExpression, 1, -2)
	end

	if _G.UsePFGButton then
		self:Proxy("HandleCheckBox", _G.UsePFGButton)
		_G.UsePFGButton:ClearAllPoints()
		_G.UsePFGButton:SetPoint("RIGHT", _G.LFGListFrame.SearchPanel.RefreshButton, "LEFT", -50, 0)
	end
end

S:AddCallbackForAddon("PremadeGroupsFilter")
