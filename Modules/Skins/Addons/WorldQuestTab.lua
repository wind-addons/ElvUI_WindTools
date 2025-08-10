local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G
local next = next
local hooksecurefunc = hooksecurefunc

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local function PositionTabIcons(icon, _, anchor)
	if anchor then
		icon:SetPoint("CENTER")
	end
end

-- Copy from ElvUI WorldMap skin
local function reskinTab(tab)
	if not tab then
		return
	end
	tab:CreateBackdrop()
	tab:Size(30, 40)

	if tab.Icon then
		tab.Icon:ClearAllPoints()
		tab.Icon:SetPoint("CENTER")

		hooksecurefunc(tab.Icon, "SetPoint", PositionTabIcons)
	end

	if tab.Background then
		tab.Background:SetAlpha(0)
	end

	if tab.SelectedTexture then
		tab.SelectedTexture:SetDrawLayer("ARTWORK")
		tab.SelectedTexture:SetColorTexture(1, 0.82, 0, 0.3)
		tab.SelectedTexture:SetAllPoints()
	end

	for _, region in next, { tab:GetRegions() } do
		if region:IsObjectType("Texture") and region:GetAtlas() == "QuestLog-Tab-side-Glow-hover" then
			region:SetColorTexture(1, 1, 1, 0.3)
			region:SetAllPoints()
		end
	end

	if tab.backdrop then
		S:CreateBackdropShadow(tab)
		tab.backdrop:SetTemplate("Transparent")
	end
end

local function reskinContainer(container)
	container.BorderFrame:Hide()
	container.Background:Hide()
	container:CreateBackdrop("Transparent")
	container.backdrop:SetOutside(container.Background)
	S:ESProxy("HandleTrimScrollBar", container.ScrollBar)
end

local function reskinQuestContainer(container)
	reskinContainer(container)
	S:ESProxy("HandleDropDownBox", container.SortDropdown)
	S:ESProxy("HandleButton", container.FilterDropdown, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")
	container.FilterBar:StripTextures()
end

local function reskinWhatsNew(container)
	reskinContainer(container)

	container.CloseButton:Size(20, 20)
	S:ESProxy("HandleCloseButton", container.CloseButton)
end

local function reskinSettings(container)
	reskinContainer(container)
end

local function settingsCategory(frame)
	if frame.ExpandIcon then
		S:ESProxy("HandleButton", frame, true, nil, nil, true)
		local container = CreateFrame("Frame", nil, frame:GetParent())
		frame.Highlight:SetAlpha(0)
		frame.backdrop:SetInside(frame, 10, 5)

		F.MoveFrameWithOffset(frame.Title, 0, -2)
		return
	end

	if frame.BGRight then
		frame:StripTextures()
		frame:CreateBackdrop()

		frame.HighlightMiddle:SetTexture(E.media.blankTex)
		frame.HighlightMiddle:SetVertexColor(1, 1, 1, 0.2)
		frame.HighlightMiddle:SetAllPoints(frame.backdrop)

		frame.windSelectedTexture = frame:CreateTexture(nil, "ARTWORK")
		frame.windSelectedTexture:SetTexture(E.media.blankTex)
		frame.windSelectedTexture:SetVertexColor(unpack(E.media.rgbvaluecolor))
		frame.windSelectedTexture:SetAlpha(0.5)
		frame.windSelectedTexture:SetAllPoints(frame.backdrop)
		frame.windSelectedTexture:Hide()

		frame.BGRight:Hide()
		frame.backdrop:SetPoint("TOPLEFT", frame.BGLeft)
		frame.backdrop:SetPoint("BOTTOMRIGHT", frame.BGRight)
		hooksecurefunc(frame, "SetExpanded", function(self, expanded)
			self.windSelectedTexture:SetShown(expanded)
		end)
	end
end

local function settingsCheckbox(frame)
	if not frame or not frame.CheckBox then
		return
	end
	S:ESProxy("HandleCheckBox", frame.CheckBox)
end

local function settingsSlider(frame)
	if not frame or not frame.SliderWithSteppers or not frame.TextBox then
		return
	end

	S:ESProxy("HandleStepSlider", frame.SliderWithSteppers)
	S:ESProxy("HandleNextPrevButton", frame.SliderWithSteppers.Back, "left")
	S:ESProxy("HandleNextPrevButton", frame.SliderWithSteppers.Forward, "right")
	S:ESProxy("HandleEditBox", frame.TextBox)
end

local function settingsColor(frame)
	if not frame or not frame.Picker or not frame.ResetButton then
		return
	end

	S:ESProxy("HandleButton", frame.Picker)
	S:ESProxy("HandleButton", frame.ResetButton)
end

local function settingsDropDown(frame)
	if not frame or not frame.Dropdown then
		return
	end
	S:ESProxy("HandleDropDownBox", frame.Dropdown, frame:GetWidth())
end

local function settingsButton(frame)
	if not frame or not frame.Button then
		return
	end
	S:ESProxy("HandleButton", frame.Button)
end

local function settingsTextInput(frame)
	if not frame or not frame.TextBox then
		return
	end
	S:ESProxy("HandleEditBox", frame.TextBox)
end

local function listButton(button)
	if not button or button.__windSkin then
		return
	end

	button.Bg:SetTexture(E.media.blankTex)
	button.Bg:SetVertexColor(1, 1, 1, 0.1)

	button.Highlight:StripTextures()
	local tex = button.Highlight:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(E.media.blankTex)
	tex:SetVertexColor(1, 1, 1, 0.2)
	tex:SetAllPoints(button.Bg)
	button.Highlight.windTex = tex
end

function S:WorldQuestTab()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.worldQuestTab then
		return
	end

	if _G.WQT_QuestMapTab then
		reskinTab(_G.WQT_QuestMapTab)
		_G.WQT_QuestMapTab.__SetPoint = _G.WQT_QuestMapTab.SetPoint
		hooksecurefunc(_G.WQT_QuestMapTab, "SetPoint", function()
			F.MoveFrameWithOffset(_G.WQT_QuestMapTab, 0, -2)
		end)
	end

	if _G.WQT_ListContainer then
		reskinQuestContainer(_G.WQT_ListContainer)
	end

	if _G.WQT_WhatsNewFrame then
		reskinWhatsNew(_G.WQT_WhatsNewFrame)
	end

	if _G.WQT_SettingsFrame then
		reskinSettings(_G.WQT_SettingsFrame)
	end
end

S:AddCallbackForAddon("WorldQuestTab")

local isLoaded, isFinished = C_AddOns_IsAddOnLoaded("WorldQuestTab")
if isLoaded and isFinished then
	S:TryPostHook("WQT_SettingsCategoryMixin", "Init", settingsCategory)
	S:TryPostHook("WQT_SettingsCheckboxMixin", "Init", settingsCheckbox)
	S:TryPostHook("WQT_SettingsSliderMixin", "Init", settingsSlider)
	S:TryPostHook("WQT_SettingsColorMixin", "Init", settingsColor)
	S:TryPostHook("WQT_SettingsDropDownMixin", "Init", settingsDropDown)
	S:TryPostHook("WQT_SettingsButtonMixin", "Init", settingsButton)
	S:TryPostHook("WQT_SettingsConfirmButtonMixin", "Init", settingsButton)
	S:TryPostHook("WQT_SettingsTextInputMixin", "Init", settingsTextInput)
	S:TryPostHook("WQT_ListButtonMixin", "Update", listButton)
end
