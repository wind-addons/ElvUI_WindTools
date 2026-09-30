local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs
local hooksecurefunc = hooksecurefunc

local SettingsPanel = SettingsPanel

local data = S:AddCallbackForAddon("BugSack", nil, S:CreateAddonCheck("bugSack"))

function data:OpenSack() -- self is BugSack, not data
	local bugSackFrame = _G.BugSackFrame
	if not bugSackFrame or bugSackFrame.__windSkin then
		return
	end

	S:Proxy("HandlePortraitFrame", bugSackFrame)
	S:CreateShadow(bugSackFrame)

	local titleContainer = bugSackFrame.TitleContainer or bugSackFrame
	for _, region in pairs({ titleContainer:GetRegions() }) do
		if region and region:GetObjectType() == "FontString" then
			F.SetFont(region)
		end
	end

	local textArea = _G.BugSackScrollText
	local scrollFrame = textArea and textArea:GetParent()
	local scrollBar = scrollFrame and scrollFrame.ScrollBar
	if scrollBar then
		S:Proxy("HandleTrimScrollBar", scrollBar)
	end

	if textArea then
		for _, region in pairs({ textArea:GetRegions() }) do
			if region and region:GetObjectType() == "FontString" then
				F.SetFont(region)
			end
		end
	end

	local prevButton = _G.BugSackPrevButton
	local nextButton = _G.BugSackNextButton
	local sendButton = _G.BugSackSendButton

	for _, button in pairs({ prevButton, nextButton, sendButton }) do
		if button then
			S:Proxy("HandleButton", button, nil, nil, nil, true)
			button:Height(24)
		end
	end

	if prevButton then
		prevButton:ClearAllPoints()
		prevButton:Point("BOTTOMLEFT", bugSackFrame, "BOTTOMLEFT", 12, 6)
	end

	if nextButton then
		nextButton:ClearAllPoints()
		nextButton:Point("BOTTOMRIGHT", bugSackFrame, "BOTTOMRIGHT", -12, 6)
	end

	if sendButton then
		sendButton:ClearAllPoints()
		sendButton:Point("LEFT", prevButton, "RIGHT", 1, 0)
		sendButton:Point("RIGHT", nextButton, "LEFT", -1, 0)
	end

	local allTab = _G.BugSackTabAll
	local lastTab = _G.BugSackTabLast
	local sessionTab = _G.BugSackTabSession

	for _, tab in pairs({ allTab, lastTab, sessionTab }) do
		if tab then
			S:Proxy("HandleTab", tab)
			S:CreateBackdropShadow(tab)
		end
	end

	if sessionTab then
		sessionTab:ClearAllPoints()
		sessionTab:Point("CENTER", bugSackFrame, "BOTTOM", 0, -16)

		if allTab then
			allTab:ClearAllPoints()
			allTab:Point("LEFT", sessionTab, "RIGHT", -4, 0)
		end

		if lastTab then
			lastTab:ClearAllPoints()
			lastTab:Point("RIGHT", sessionTab, "LEFT", 4, 0)
		end
	end

	bugSackFrame.__windSkin = true
end

function S:BugSack()
	if not _G.BugSack then
		return
	end

	self:DisableAddOnSkin("BugSack")

	self:SecureHook(_G.BugSack, "OpenSack", data.OpenSack)

	-- Handle the special dropdown in settings
	hooksecurefunc(SettingsPanel.Container.SettingsList.ScrollBox, "Update", function(scrollBox)
		scrollBox:ForEachFrame(function(frame)
			if frame.soundDropdown and frame.soundDropdown.intrinsic == "DropdownButton" then
				self:Proxy("HandleDropDownBox", frame.soundDropdown)
			end
		end)
	end)
end
