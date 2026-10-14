local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs
local hooksecurefunc = hooksecurefunc

local data = S:AddCallbackForAddon("BugSack", nil, S:CreateAddonCheck("bugSack"))

local function SkinTitle(parent)
	if not parent then
		return
	end

	for _, region in pairs({ parent:GetRegions() }) do
		if region and region:IsObjectType("FontString") then
			F.SetFont(region)
		end
	end

	for _, child in pairs({ parent:GetChildren() }) do
		if child:IsObjectType("EditBox") and child ~= _G.BugSackScrollText then
			S:Proxy("HandleEditBox", child)
		elseif child:IsObjectType("Button") and not child:GetName() and not child:GetNormalTexture() then
			-- Session title is an unnamed button with no normal texture. Named sack buttons and the close button stay untouched.
			local fontString = child:GetFontString()
			if fontString then
				F.SetFont(fontString)
			end
		end
	end
end

local ACTIVE_TAB_TEXTURES = {
	"LeftActive",
	"MiddleActive",
	"RightActive",
	"LeftHighlight",
	"MiddleHighlight",
	"RightHighlight",
}

local function HideTabTexture(texture)
	if not texture or texture.__windHidden then
		return
	end

	texture.__windHidden = true
	texture:Hide()
	texture:SetAlpha(0)
	hooksecurefunc(texture, "Show", texture.Hide)
end

-- PanelTemplates_TabResize clamps the label to the blizzard side caps, which truncates longer locale strings.
local function FitBugSackTab(tab)
	local text = tab.Text
	if not text then
		return
	end

	if tab.Left then
		tab.Left:SetWidth(0)
	end
	if tab.Right then
		tab.Right:SetWidth(0)
	end

	text:SetWidth(0)

	local textWidth = text:GetStringWidth()
	if not textWidth or textWidth <= 0 then
		return
	end

	-- Match ElvUI's tab backdrop inset so the label stays inside the skinned backdrop.
	local sideInset = E.Modern and 3 or 10
	local tabWidth = textWidth + sideInset * 2 + 12
	if tabWidth < 36 then
		tabWidth = 36
	end

	tab:SetWidth(tabWidth)
	tab.selectedTextY = 1
	tab.deselectedTextY = 1
	text:SetPoint("CENTER", tab, "CENTER", 0, 1)
end

local function SkinBugSackTab(tab)
	S:Proxy("HandleTab", tab)
	S:ReskinTab(tab)

	for _, textureKey in pairs(ACTIVE_TAB_TEXTURES) do
		HideTabTexture(tab[textureKey])
	end

	if not tab.__windTabFit then
		tab.__windTabFit = true
		tab:HookScript("OnShow", FitBugSackTab)
		tab:HookScript("OnEvent", FitBugSackTab)
	end

	FitBugSackTab(tab)
end

local function SkinOptions(optionsFrame)
	for _, child in pairs({ optionsFrame:GetChildren() }) do
		if child:IsObjectType("CheckButton") then
			S:Proxy("HandleCheckBox", child)
		elseif child:IsObjectType("Frame") then
			for _, subChild in pairs({ child:GetChildren() }) do
				if subChild.SetupMenu then
					S:Proxy("HandleDropDownBox", subChild, subChild:GetWidth())
				end
			end
		end
	end
end

function data:OpenSack() -- self is BugSack, not data
	local bugSackFrame = _G.BugSackFrame
	if not bugSackFrame or bugSackFrame.__windSkin then
		return
	end

	S:Proxy("HandlePortraitFrame", bugSackFrame)
	S:CreateShadow(bugSackFrame)

	local titleContainer = bugSackFrame.TitleContainer
	if titleContainer then
		SkinTitle(titleContainer)
	else
		SkinTitle(bugSackFrame)
	end

	-- BugSack 12.1.2 removed the BugSackScrollScrollBar global. Retail and Forever
	-- build a MinimalScrollBar (Back/Forward); classic still uses a UIPanel slider.
	local textArea = _G.BugSackScrollText
	local scrollFrame = textArea and textArea:GetParent()
	local scrollBar = (scrollFrame and scrollFrame.ScrollBar) or _G.BugSackScrollScrollBar
	if scrollBar then
		if scrollBar.Back and scrollBar.Forward then
			S:Proxy("HandleTrimScrollBar", scrollBar)
		else
			S:Proxy("HandleScrollBar", scrollBar)
		end
	end

	for _, button in pairs({
		_G.BugSackPrevButton,
		_G.BugSackNextButton,
		_G.BugSackSendButton,
		_G.BugSackWipeButton,
	}) do
		if button then
			S:Proxy("HandleButton", button, nil, nil, nil, true)
		end
	end

	for _, tab in pairs({
		_G.BugSackTabAll,
		_G.BugSackTabSession,
		_G.BugSackTabLast,
		_G.BugSackTabOptions,
	}) do
		if tab then
			SkinBugSackTab(tab)
		end
	end

	if scrollFrame then
		for _, child in pairs({ bugSackFrame:GetChildren() }) do
			local _, anchorTo = child:GetPoint()
			if anchorTo == scrollFrame then
				SkinOptions(child)
			end
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

	if _G.BugSack.OpenConfig then
		self:SecureHook(_G.BugSack, "OpenConfig", data.OpenSack)
	end

	if _G.BugSackFrame then
		data.OpenSack()
	end
end
