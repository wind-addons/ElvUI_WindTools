local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local ES = E.Skins
local C = W.Utilities.Color

local _G = _G
local assert = assert
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local type = type

local CreateFrame = CreateFrame
local LibStub = LibStub

local function SkinViaRawHook(object, method, func, noLabel)
	local NetEaseGUI = LibStub("NetEaseGUI-2.0")
	local module = NetEaseGUI and NetEaseGUI:GetClass(object)
	if module and module[method] then
		local original = module[method]
		module[method] = function(self, ...)
			original(self, ...)
			if noLabel then
				func(self, ...)
			else
				if not self.__windSkin then
					func(self, ...)
					self.__windSkin = true
				end
			end
		end
	end
end

local function SkinViaAceGUICallback(object, event, func, pre)
	assert(object.SetCallback, "object does not have SetCallback method")
	local originalCallback = object.events[event]
	assert(originalCallback, "event '" .. event .. "' does not exist on the object")
	object:SetCallback(event, function(self, ...)
		if pre then
			func(self, ...)
		end
		originalCallback(self, ...)

		if not pre then
			func(self, ...)
		end
	end)
end

local function ReskinDropDown(dropdown)
	if dropdown.__windSkin then
		return
	end

	dropdown:StripTextures()
	dropdown:CreateBackdrop()
	dropdown.backdrop:ClearAllPoints()
	dropdown.backdrop:SetOutside(dropdown, 1, -3)

	S:Proxy("HandleNextPrevButton", dropdown.MenuButton, "down")

	dropdown.__windSkin = true
end

local function ReskinInputBox(inputBox)
	if inputBox.__windSkin then
		return
	end

	for _, region in pairs({ inputBox:GetRegions() }) do
		if region.GetObjectType and region:GetObjectType() == "Texture" then
			if S:IsTexturePathEqual(region, [[Interface\Common\Common-Input-Border]]) then
				region:Kill()
			end
		end
	end
	S:Proxy("HandleEditBox", inputBox)
	if inputBox.SearchIcon then
		S:Reposition(inputBox.backdrop, inputBox, 1, 3, 2, -1, -2)
		F.Move(inputBox.SearchIcon, 0, 2)
	else
		S:Reposition(inputBox.backdrop, inputBox, -1, 0, 0, -1, -1)
	end

	inputBox.__windSkin = true
end

local function ReskinCheckBoxWithInputs(frame)
	if frame.__windSkin then
		return
	end

	if frame.Check then
		S:Proxy("HandleCheckBox", frame.Check)
	end

	if frame.MinBox then
		frame.MinBox:StripTextures()
		S:Proxy("HandleEditBox", frame.MinBox)
		frame.MinBox.backdrop:NudgePoint(6, 0, nil, "TOPLEFT")
		frame.MinBox.backdrop:NudgePoint(-6, 0, nil, "BOTTOMRIGHT")
	end

	if frame.MaxBox then
		frame.MaxBox:StripTextures()
		S:Proxy("HandleEditBox", frame.MaxBox)
		frame.MaxBox.backdrop:NudgePoint(6, 0, nil, "TOPLEFT")
		frame.MaxBox.backdrop:NudgePoint(-6, 0, nil, "BOTTOMRIGHT")
	end

	frame.__windSkin = true
end

local function ReskinListTitle(listTitle)
	if listTitle.__windSkin then
		return
	end

	for _, button in pairs(listTitle.sortButtons) do
		button:StripTextures()
		S:Proxy("HandleButton", button, nil, nil, nil, true)
		button.backdrop:ClearAllPoints()
		button.backdrop:SetOutside(button, -2, 0)
	end

	local ScrollBar = listTitle:GetScrollBar()
	if ScrollBar then
		S:Proxy("HandleNextPrevButton", ScrollBar.ScrollUpButton, "up")
		S:Proxy("HandleNextPrevButton", ScrollBar.ScrollDownButton, "down")
		S:Proxy("HandleScrollBar", ScrollBar)
	end

	listTitle.__windSkin = true
end

local function ReskinMainPanel(mainPanel)
	if not mainPanel then
		return
	end

	S:Proxy("HandlePortraitFrame", mainPanel)
	S:CreateShadow(mainPanel)
	S:MerathilisUISkin(mainPanel)
	mainPanel.PortraitFrame:Hide()
	local CustomCloseButton =
		CreateFrame("Button", "WTMeetingStoneCloseButton", mainPanel, "UIPanelCloseButton, BackdropTemplate")
	---@cast CustomCloseButton Button
	CustomCloseButton:Point("TOPRIGHT", mainPanel.backdrop, "TOPRIGHT", 0, 0)
	CustomCloseButton:SetScript("OnClick", mainPanel.CloseButton:GetScript("OnClick"))
	CustomCloseButton:SetHitRectInsets(3, 3, 3, 3)
	S:Proxy("HandleCloseButton", CustomCloseButton)
	mainPanel
		.CloseButton--[[@as Button]]
		:Kill()
	mainPanel.CloseButton = CustomCloseButton

	-- Helper Blocker (版本信息)
	local HelpBlocker = mainPanel.blockers["HelpBlocker"]
	if HelpBlocker then
		SkinViaAceGUICallback(HelpBlocker, "OnInit", function(blocker)
			blocker:StripTextures()
			blocker:SetTemplate("Default")
		end, true)

		SkinViaAceGUICallback(HelpBlocker, "OnInit", function(blocker)
			for _, child in pairs({ blocker:GetChildren() }) do
				if child.GetObjectType and child:GetObjectType() == "Button" then
					S:Proxy("HandleButton", child)
					child:SetTemplate("Transparent")
				end
			end
		end)
	end

	-- Announcement Blocker (活动公告)
	local AnnBlocker = mainPanel.blockers["AnnBlocker"]
	if AnnBlocker then
		SkinViaAceGUICallback(AnnBlocker, "OnInit", function(blocker)
			blocker:StripTextures()
			blocker:SetTemplate("Transparent")

			local NoticeContainer = blocker.NoticeContainer
			local NoticeFrame = NoticeContainer and NoticeContainer:GetParent()
			if NoticeFrame then
				local KnowButton = NoticeFrame.btnKnow
				if KnowButton then
					S:Proxy("HandleButton", KnowButton)
				end
			end
		end)
	end

	-- Tabs
	SkinViaRawHook("BottomTabButton", "SetStatus", function(tab)
		tab:StripTextures()
		S:Proxy("HandleTab", tab)
		S:ReskinTab(tab)

		local fontString = tab:GetFontString()
		F.SetFont(fontString)
		fontString:ClearAllPoints()
		fontString:Point("CENTER", tab, "CENTER", 0, 1)
		F.InternalizeMethod(fontString, "SetPoint", true)
		tab:SetWidth(tab:GetTextWidth() + 30)
	end)
end

local function ReskinBrowsePanel(panel)
	if not panel then
		return
	end

	-- Check Buttons: Auto join (自动进组) / Double Click Join (双击加入)
	for _, child in pairs({ panel:GetChildren() }) do
		if child.GetObjectType and child:GetObjectType() == "CheckButton" then
			S:Proxy("HandleCheckBox", child)
		end
	end

	-- Refresh (重置)
	local RefreshButton = panel.RefreshButton
	if RefreshButton then
		S:Proxy("HandleButton", RefreshButton, nil, nil, nil, true)
		RefreshButton.backdrop:ClearAllPoints()
		RefreshButton.backdrop:SetOutside(RefreshButton, -1, -1)
	end

	-- Mythic+ (大秘境)
	local ExSearchButton = panel.ExSearchButton
	if ExSearchButton then
		S:Proxy("HandleButton", ExSearchButton, nil, nil, nil, true)
		ExSearchButton.backdrop:ClearAllPoints()
		ExSearchButton.backdrop:SetOutside(ExSearchButton, -1, -1)
	end

	-- Advanced Filter (高级过滤)
	local AdvButton = panel.AdvButton
	if AdvButton then
		S:Proxy("HandleButton", AdvButton, nil, nil, nil, true)
		AdvButton.backdrop:ClearAllPoints()
		AdvButton.backdrop:SetOutside(AdvButton, -1, -1)
		if AdvButton.Shine then
			panel.AdvButton.Shine:Hide()
		end
	end

	-- Auto Complete Frame (活动搜索框)
	local AutoCompleteFrame = panel.AutoCompleteFrame
	if AutoCompleteFrame then
		AutoCompleteFrame:StripTextures()
		AutoCompleteFrame:CreateBackdrop()
		AutoCompleteFrame.backdrop:ClearAllPoints()
		AutoCompleteFrame.backdrop:SetOutside(AutoCompleteFrame, 2, 2)
		local ScrollBar = AutoCompleteFrame:GetScrollBar()

		if ScrollBar then
			S:Proxy("HandleNextPrevButton", ScrollBar.ScrollUpButton, "up")
			S:Proxy("HandleNextPrevButton", ScrollBar.ScrollDownButton, "down")
			S:Proxy("HandleScrollBar", ScrollBar)
		end
	end

	local SignUpButton = panel.SignUpButton
	if SignUpButton then
		S:Proxy("HandleButton", SignUpButton)
	end

	local ActivityDropdown = panel.ActivityDropdown
	if ActivityDropdown then
		ReskinDropDown(ActivityDropdown)
	end

	local ActivityList = panel.ActivityList
	if ActivityList then
		ReskinListTitle(ActivityList)
	end

	local NoResultBlocker = panel.NoResultBlocker
	if NoResultBlocker then
		S:Proxy("HandleButton", NoResultBlocker.Button)
		F.SetFont(NoResultBlocker.Label)
	end

	-- Advanced Filter Subframe (高级过滤)
	local AdvFilterPanel = panel.AdvFilterPanel
	if AdvFilterPanel then
		S:Proxy("HandlePortraitFrame", AdvFilterPanel)
		S:CreateShadow(AdvFilterPanel)
		for _, child in pairs({ AdvFilterPanel:GetChildren() }) do
			if child.GetObjectType and child:GetObjectType() == "Button" then
				if child.GetText and child:GetText() ~= "" and child:GetText() ~= nil then
					S:Proxy("HandleButton", child)
					local text = child:GetText()
					if text == _G.RESET then
						F.Move(child, -2, 0)
					elseif text == _G.REFRESH then
						F.Move(child, 2, 0)
					end
				else
					S:Proxy("HandleCloseButton", child)
				end
			end
		end

		for _, child in pairs({ AdvFilterPanel.Inset:GetChildren() }) do
			ReskinCheckBoxWithInputs(child)
		end
	end

	-- Mythic+ Subframe (大秘境过滤)
	local ExSearchPanel = panel.ExSearchPanel
	if ExSearchPanel then
		S:Proxy("HandlePortraitFrame", ExSearchPanel)
		S:CreateShadow(ExSearchPanel)
		for _, child in pairs({ ExSearchPanel:GetChildren() }) do
			if child.GetObjectType and child:GetObjectType() == "Button" then
				if child.GetText and child:GetText() ~= "" and child:GetText() ~= nil then
					S:Proxy("HandleButton", child, nil, nil, nil, true)
					child.backdrop:ClearAllPoints()
					child.backdrop:SetOutside(child, -1, 0)
				else
					S:Proxy("HandleCloseButton", child)
				end
			end
		end

		for _, child in pairs({ ExSearchPanel.Inset:GetChildren() }) do
			ReskinCheckBoxWithInputs(child)
		end
	end
end

local function ReskinDataBroker(broker)
	if not broker then
		return
	end

	local BrokerPanel = broker.BrokerPanel
	if BrokerPanel then
		BrokerPanel:SetTemplate("Transparent")
		S:CreateShadow(BrokerPanel)
		S:MerathilisUISkin(BrokerPanel)
	end
end

local function ReskinManagerPanel(panel)
	for _, child in pairs({ panel:GetChildren() }) do
		if child.CreateWidget then
			panel.LeftPart = child
		elseif child.ApplicantList then
			panel.RightPart = child
		end
	end

	local RefreshButton = panel.RefreshButton
	if RefreshButton then
		S:Proxy("HandleButton", RefreshButton, nil, nil, nil, true)
		RefreshButton.backdrop:ClearAllPoints()
		RefreshButton.backdrop:SetOutside(RefreshButton, -1, -2)
	end

	for _, child in pairs({ panel.LeftPart:GetChildren() }) do
		if child.GetObjectType and child:GetObjectType() == "CheckButton" then
			S:Proxy("HandleCheckBox", child)
		else
			local firstRegion = child:GetRegions()
			if firstRegion and firstRegion.GetObjectType and firstRegion:GetObjectType() == "Texture" then
				if S:IsTexturePathEqual(firstRegion, [[Interface\FriendsFrame\UI-ChannelFrame-VerticalBar]]) then
					child:StripTextures()
				end
			end
		end
	end

	local LeftPart = panel.LeftPart
	if LeftPart then
		local CreateButton = LeftPart.CreateButton
		if CreateButton then
			S:Proxy("HandleButton", CreateButton)
		end

		local DisbandButton = LeftPart.DisbandButton
		if DisbandButton then
			S:Proxy("HandleButton", DisbandButton)
		end

		local CreateWidget = LeftPart.CreateWidget
		if CreateWidget then
			for _, child in pairs({ CreateWidget:GetChildren() }) do
				for _, subChild in pairs({ child:GetChildren() }) do
					if subChild.MenuButton and subChild.Text then
						ReskinDropDown(subChild)
						F.Move(subChild, 3, 0)
						subChild:SetWidth(subChild:GetWidth() - 6)
					elseif subChild.tLeft and subChild.tRight then
						ReskinInputBox(subChild)
					elseif subChild:GetObjectType() == "CheckButton" then
						S:Proxy("HandleCheckBox", subChild)
					end
				end

				if child.Bg then
					child.Bg:NudgePoint(6, 0, nil, "BOTTOMRIGHT")
				end
			end
		end
	end

	local ApplicantList = panel.RightPart and panel.RightPart.ApplicantList
	if ApplicantList then
		ReskinListTitle(ApplicantList)
	end
end

local function ReskinLocomotiveIntroduce(panel)
	if not panel then
		return
	end

	for _, child in pairs({ panel:GetChildren() }) do
		if child.GetObjectType and child:GetObjectType() == "Frame" then
			child:SetBackdrop(nil)
			child:CreateBackdrop("Transparent")
			child.backdrop:SetInside(child, 3, 3)
		end
	end
end

local function ReskinAssociationPanel(panel)
	if not panel then
		return
	end

	local ActivityDropdown = panel.ActivityDropdown
	if ActivityDropdown then
		ReskinDropDown(ActivityDropdown)
		F.Move(ActivityDropdown, 0, -2)
	end

	local suggestionDropdown = panel.suggestionDropdown
	if suggestionDropdown then
		suggestionDropdown:StripTextures()
		suggestionDropdown:SetTemplate("Transparent")
		S:CreateShadow(suggestionDropdown)

		for _, child in pairs({ suggestionDropdown:GetChildren() }) do
			if child.GetObjectType and child:GetObjectType() == "ScrollFrame" then
				local ScrollBar = child.ScrollBar
				if ScrollBar then
					S:Proxy("HandleScrollBar", ScrollBar)
				end
			end
		end

		suggestionDropdown.__windSkin = true
	end

	local filtrateCount = panel.filtrateCount
	if filtrateCount then
		S:Proxy("HandleCheckBox", filtrateCount)
		filtrateCount.__windSkin = true
	end

	local IgnoreList = panel.IgnoreList
	if IgnoreList then
		ReskinListTitle(IgnoreList)
		IgnoreList.__windSkin = true
	end

	for _, child in pairs({ panel:GetChildren() }) do
		if not child.__windSkin then
			if child.GetObjectType and child:GetObjectType() == "EditBox" then
				S:Proxy("HandleEditBox", child)
			elseif child.GetObjectType and child:GetObjectType() == "Button" then
				S:Proxy("HandleButton", child)
			end
		end
	end
end

local function ReskinRecentPanel(panel)
	if not panel then
		return
	end

	local ActivityDropdown = panel.ActivityDropdown
	if ActivityDropdown then
		ReskinDropDown(ActivityDropdown)
	end

	local ClassDropdown = panel.ClassDropdown
	if ClassDropdown then
		ReskinDropDown(ClassDropdown)
	end

	local RoleDropdown = panel.RoleDropdown
	if RoleDropdown then
		ReskinDropDown(RoleDropdown)
	end

	local SearchInput = panel.SearchInput
	if SearchInput then
		ReskinInputBox(SearchInput)
		F.Move(SearchInput, -10, 0)
	end

	local BatchDeleteButton = panel.BatchDeleteButton
	if BatchDeleteButton then
		S:Proxy("HandleButton", BatchDeleteButton)
	end

	local MemberList = panel.MemberList
	if MemberList then
		ReskinListTitle(MemberList)
	end
end

local function ReskinIgnoreListPanel(panel)
	if not panel then
		return
	end

	if panel.IgnoreList then
		ReskinListTitle(panel.IgnoreList)
	end

	for _, child in pairs({ panel:GetChildren() }) do
		if child.GetObjectType and child:GetObjectType() == "Button" and child.Left and child.Right then
			S:Proxy("HandleButton", child)
		end
	end
end

local function ReskinMiscellaneous()
	-- DropMenu
	SkinViaRawHook("DropMenu", "Open", function(dropMenu, level)
		local menu = dropMenu.menuList[level or 1]
		if not menu or menu.__windSkin then
			return
		end

		menu:StripTextures()
		menu:SetTemplate("Transparent")
		S:CreateShadow(menu)

		dropMenu.__windSkin = true
	end, true)

	-- DropMenuItem
	SkinViaRawHook("DropMenuItem", "SetHasArrow", function(dropMenuItem)
		if not dropMenuItem.Arrow then
			return
		end

		dropMenuItem.Arrow:Size(11)
		dropMenuItem.Arrow:SetTexture(E.Media.Textures.ArrowUp)
		dropMenuItem.Arrow:SetRotation(ES.ArrowRotation.right)
		dropMenuItem.Arrow:SetVertexColor(1, 1, 1)
	end)

	-- Scroll Bar
	SkinViaRawHook("PageScrollBar", "Constructor", function(scrollBar)
		S:Proxy("HandleScrollBar", scrollBar)
	end)

	-- List elements
	SkinViaRawHook("ListView", "UpdateItems", function(view)
		for i = 1, #view.buttons do
			local button = view:GetButton(i)
			if button:IsShown() and not button.__windSkin then
				button:StripTextures()
				button:SetTemplate("Transparent")

				button:SetHighlightTexture(E.Media.Textures.White8x8)
				local highlightTex = button:GetHighlightTexture()
				highlightTex:SetVertexColor(C.ExtractRGBAFromTemplate("neutral-50", 0.3))
				highlightTex:SetInside()
				highlightTex:SetBlendMode("DISABLE")

				local selectedTex = button:CreateTexture(nil)
				selectedTex:SetTexture(E.Media.Textures.White8x8)
				selectedTex:SetVertexColor(C.ExtractRGBAFromTemplate("yellow-500", 0.3))
				selectedTex:SetInside()
				selectedTex:Hide()
				selectedTex:SetBlendMode("DISABLE")

				hooksecurefunc(button, "SetChecked", function(_, isChecked)
					selectedTex:SetShown(isChecked)
				end)

				if button["@"] and button["@"].Check then
					S:Proxy("HandleCheckBox", button["@"].Check)
					button["@"].Check:ClearAllPoints()
					button["@"].Check:Point("CENTER")
					button["@"].Check:Size(24)
					F.InternalizeMethod(button["@"].Check, "SetSize", true)
				end

				button.__windSkin = true
			end
		end
	end, true)
end

function S:MeetingStone()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.meetingStone then
		return
	end

	local LibNetEaseEnv = LibStub("NetEaseEnv-1.0")
	local LibNetEaseGUI = LibStub("NetEaseGUI-2.0")
	local MeetingStone = LibStub("AceAddon-3.0"):GetAddon("MeetingStone")

	if not LibNetEaseEnv or not LibNetEaseGUI then
		return
	end

	local NEG
	for k in pairs(LibNetEaseEnv._NSInclude) do
		if type(k) == "table" then
			NEG = k
		end
	end

	if not NEG then
		return
	end

	local function GetModule(name)
		return NEG[name] or MeetingStone and MeetingStone:GetModule(name, true)
	end

	-- Broker Panel (悬浮框)
	ReskinDataBroker(GetModule("DataBroker"))

	-- Main Panel
	ReskinMainPanel(GetModule("MainPanel"))

	-- Browse Panel (查找活动)
	ReskinBrowsePanel(GetModule("BrowsePanel"))

	-- Manager Panel (管理活动)
	ReskinManagerPanel(GetModule("ManagerPanel"))

	-- Locomotive Introduce (火车头)
	ReskinLocomotiveIntroduce(GetModule("LocomotiveIntroduce"))

	-- Association Panel (公会招募)
	ReskinAssociationPanel(GetModule("AssociationPanel"))

	-- Recent Panel (最近玩友)
	ReskinRecentPanel(GetModule("RecentPanel"))

	-- Ignore List Panel (屏蔽玩家列表)
	ReskinIgnoreListPanel(GetModule("IgnoreListPanel"))

	-- Miscellaneous Elements
	ReskinMiscellaneous()
end

S:AddCallbackForAddon("MeetingStone")
