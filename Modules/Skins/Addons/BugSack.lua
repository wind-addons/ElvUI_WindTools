local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

function S:BugSack_InterfaceOptionOnShow(frame)
	if frame.__windSkin then
		return
	end

	if _G.BugSackFontSize then
		local dropdown = _G.BugSackFontSize
		self:Proxy("HandleDropDownBox", dropdown, nil, nil, true)

		local point, relativeTo, relativePoint, xOffset, yOffset = dropdown:GetPoint(1)
		dropdown:ClearAllPoints()
		dropdown:SetPoint(point, relativeTo, relativePoint, xOffset - 1, yOffset)

		dropdown.__windSkinMarked = true
	end

	if _G.BugSackSoundDropdown then
		local dropdown = _G.BugSackSoundDropdown
		self:Proxy("HandleDropDownBox", dropdown, nil, nil, true)

		local point, relativeTo, relativePoint = dropdown:GetPoint(1)
		dropdown:ClearAllPoints()
		dropdown:SetPoint(point, relativeTo, relativePoint)

		dropdown.__windSkinMarked = true
	end

	for _, child in pairs({ frame:GetChildren() }) do
		if child.__windSkinMarked then
			child.__windSkinMarked = nil
		else
			local objectType = child:GetObjectType()
			if objectType == "Button" then
				self:Proxy("HandleButton", child)
			elseif objectType == "CheckButton" then
				self:Proxy("HandleCheckBox", child)

				-- fix master channel checkbox position
				local point, relativeTo, relativePoint = child:GetPoint(1)
				if point == "LEFT" and relativeTo == _G.BugSackSoundDropdown then
					child:ClearAllPoints()
					child:SetPoint(point, relativeTo, relativePoint, 0, 3)
				end
			end
		end
	end

	frame.__windSkin = true
end

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
				F.SetFontOutline(text)
			end
		elseif numRegions == 4 then
			self:Proxy("HandleCloseButton", child)
		end
	end

	self:Proxy("HandleScrollBar", _G.BugSackScrollScrollBar)

	for _, region in pairs({ _G.BugSackScrollText:GetRegions() }) do
		if region and region:GetObjectType() == "FontString" then
			F.SetFontOutline(region)
		end
	end

	if _G.BugSackNextButton and _G.BugSackPrevButton and _G.BugSackSendButton then
		local width, height = _G.BugSackSendButton:GetSize()
		_G.BugSackSendButton:SetSize(width - 8, height)
		_G.BugSackSendButton:ClearAllPoints()
		_G.BugSackSendButton:SetPoint("LEFT", _G.BugSackPrevButton, "RIGHT", 4, 0)
		_G.BugSackSendButton:SetPoint("RIGHT", _G.BugSackNextButton, "LEFT", -4, 0)

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

		tab:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
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

	self:SecureHookScript(_G.BugSack.frame, "OnShow", "BugSack_InterfaceOptionOnShow")
	self:SecureHook(_G.BugSack, "OpenSack", "BugSack_OpenSack")
	self:DisableAddOnSkin("BugSack")
end

S:AddCallbackForAddon("BugSack")
