local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs
local hooksecurefunc = hooksecurefunc

local SettingsPanel = SettingsPanel

function S:BugSack_OpenSack()
	if _G.BugSackFrame.__windSkin then
		return
	end

	local bugSackFrame = _G.BugSackFrame

	bugSackFrame:StripTextures()
	bugSackFrame:SetTemplate("Transparent")
	self:CreateShadow(bugSackFrame)

	for _, child in pairs({ bugSackFrame:GetChildren() }) do
		local numRegions = child:GetNumRegions()

		if numRegions == 1 then
			local text = child:GetRegions()
			if text and text:GetObjectType() == "FontString" then
				F.SetFont(text)
			end
		elseif numRegions == 4 then
			self:Proxy("HandleCloseButton", child)
		end
	end

	self:Proxy("HandleScrollBar", _G.BugSackScrollScrollBar)

	for _, region in pairs({ _G.BugSackScrollText:GetRegions() }) do
		if region and region:GetObjectType() == "FontString" then
			F.SetFont(region)
		end
	end

	if _G.BugSackNextButton and _G.BugSackPrevButton and _G.BugSackSendButton then
		local width, height = _G.BugSackSendButton:GetSize()
		_G.BugSackSendButton:Size(width - 8, height)
		_G.BugSackSendButton:ClearAllPoints()
		_G.BugSackSendButton:Point("LEFT", _G.BugSackPrevButton, "RIGHT", 4, 0)
		_G.BugSackSendButton:Point("RIGHT", _G.BugSackNextButton, "LEFT", -4, 0)

		self:Proxy("HandleButton", _G.BugSackNextButton)
		self:Proxy("HandleButton", _G.BugSackPrevButton)
		self:Proxy("HandleButton", _G.BugSackSendButton)
	end

	local tabs = {
		_G.BugSackTabAll,
		_G.BugSackTabLast,
		_G.BugSackTabSession,
	}

	for _, tab in pairs(tabs) do
		self:Proxy("HandleTab", tab)
		self:CreateBackdropShadow(tab)

		local point, relativeTo, relativePoint, xOffset, yOffset = tab:GetPoint(1)

		tab:ClearAllPoints()

		if yOffset ~= 0 then
			yOffset = -2
		end

		tab:Point(point, relativeTo, relativePoint, xOffset, yOffset)
	end

	bugSackFrame.__windSkin = true
end

function S:BugSack()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.bugSack then
		return
	end

	if not _G.BugSack then
		return
	end

	self:DisableAddOnSkin("BugSack")

	self:SecureHook(_G.BugSack, "OpenSack", "BugSack_OpenSack")

	-- Handle the special dropdown in settings
	hooksecurefunc(SettingsPanel.Container.SettingsList.ScrollBox, "Update", function(scrollBox)
		scrollBox:ForEachFrame(function(frame)
			if frame.soundDropdown and frame.soundDropdown.intrinsic == "DropdownButton" then
				self:Proxy("HandleDropDownBox", frame.soundDropdown)
			end
		end)
	end)
end

S:AddCallbackForAddon("BugSack")
