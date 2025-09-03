local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local MF = W.Modules.MoveFrames ---@type MoveFrames

local _G = _G
local next = next
local hooksecurefunc = hooksecurefunc
local unpack = unpack

local CreateFrame = CreateFrame

local C_AddOns_GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local function isUnofficialVersion()
	return C_AddOns_GetAddOnMetadata("WorldQuestTab", "IconAtlas") ~= "Worldquest-icon"
end

-- Modified from ElvUI WorldMap skin
local function reskinTab(tab)
	tab:CreateBackdrop()
	tab:Size(30, 40)

	if tab.Icon then
		F.InternalizeMethod(tab.Icon, "SetPoint", true)
		F.InternalizeMethod(tab.Icon, "ClearAllPoints", true)
		F.CallMethod(tab.Icon, "ClearAllPoints")
		F.CallMethod(tab.Icon, "SetPoint", "CENTER")
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
	S:Proxy("HandleTrimScrollBar", container.ScrollBar)
end

local function reskinQuestContainer(container)
	reskinContainer(container)
	S:Proxy("HandleDropDownBox", container.SortDropdown)
	S:Proxy("HandleButton", container.FilterDropdown, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")
	container.FilterBar:StripTextures()
end

local function reskinWhatsNew(container)
	reskinContainer(container)

	container.CloseButton:Size(20, 20)
	S:Proxy("HandleCloseButton", container.CloseButton)
end

local function reskinSettings(container)
	reskinContainer(container)
end

local function reskinFlightMapContainer(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	F.InternalizeMethod(frame, "SetPoint")
	hooksecurefunc(frame, "SetPoint", function(self)
		F.Move(self, 15, 0)
	end)

	hooksecurefunc(frame, "SetParent", function(self, parent)
		MF:InternalHandle(self, parent)
	end)

	if _G.WQT_FlightMapContainerButton then
		S:Proxy("HandleButton", _G.WQT_FlightMapContainerButton)
		_G.WQT_FlightMapContainerButton:SetTemplate("Transparent")
		S:CreateShadow(_G.WQT_FlightMapContainerButton)
	end
end

local function settingsCategory(frame)
	if frame.ExpandIcon then
		S:Proxy("HandleButton", frame, true, nil, nil, true)
		local container = CreateFrame("Frame", nil, frame:GetParent())
		frame.Highlight:SetAlpha(0)
		frame.backdrop:SetInside(frame, 10, 5)

		F.Move(frame.Title, 0, -2)
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
		frame.backdrop:Point("TOPLEFT", frame.BGLeft)
		frame.backdrop:Point("BOTTOMRIGHT", frame.BGRight)
		hooksecurefunc(frame, "SetExpanded", function(self, expanded)
			self.windSelectedTexture:SetShown(expanded)
		end)
	end
end

local function settingsCheckbox(frame)
	S:Proxy("HandleCheckBox", frame.CheckBox)
end

local function settingsSlider(frame)
	S:Proxy("HandleStepSlider", frame.SliderWithSteppers)
	S:Proxy("HandleNextPrevButton", frame.SliderWithSteppers.Back, "left")
	S:Proxy("HandleNextPrevButton", frame.SliderWithSteppers.Forward, "right")
	S:Proxy("HandleEditBox", frame.TextBox)
end

local function settingsColor(frame)
	S:Proxy("HandleButton", frame.Picker)
	S:Proxy("HandleButton", frame.ResetButton)
end

local function settingsDropDown(frame)
	S:Proxy("HandleDropDownBox", frame.Dropdown, frame:GetWidth())
end

local function settingsButton(frame)
	S:Proxy("HandleButton", frame.Button)
end

local function settingsTextInput(frame)
	S:Proxy("HandleEditBox", frame.TextBox)
end

local function listButton(button)
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
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.worldQuestTab or isUnofficialVersion() then
		return
	end

	self:DisableAddOnSkin("WorldQuestTab")

	local tab = _G.WQT_QuestMapTab
	if tab then
		reskinTab(tab)
		F.InternalizeMethod(tab, "SetPoint")
		hooksecurefunc(tab, "SetPoint", function()
			F.Move(tab, 0, -2)
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

	if _G.WQT_FlightMapContainer then
		reskinFlightMapContainer(_G.WQT_FlightMapContainer)
	end
end

S:AddCallbackForAddon("WorldQuestTab")

if isUnofficialVersion() then
	F.TaskManager:AfterLogin(function()
		E.private.WT.skins.addons.worldQuestTab = false
	end)
else
	local isLoaded, isFinished = C_AddOns_IsAddOnLoaded("WorldQuestTab")
	if isLoaded and isFinished then
		local function wrap(func)
			return function(...)
				local args = { ... }
				F.TaskManager:AfterLogin(function()
					if not E.private.WT.skins.enable or not E.private.WT.skins.addons.worldQuestTab then
						return
					end
					func(unpack(args))
				end)
			end
		end

		S:TryPostHook("WQT_SettingsCategoryMixin", "Init", wrap(settingsCategory))
		S:TryPostHook("WQT_SettingsCheckboxMixin", "Init", wrap(settingsCheckbox))
		S:TryPostHook("WQT_SettingsSliderMixin", "Init", wrap(settingsSlider))
		S:TryPostHook("WQT_SettingsColorMixin", "Init", wrap(settingsColor))
		S:TryPostHook("WQT_SettingsDropDownMixin", "Init", wrap(settingsDropDown))
		S:TryPostHook("WQT_SettingsButtonMixin", "Init", wrap(settingsButton))
		S:TryPostHook("WQT_SettingsConfirmButtonMixin", "Init", wrap(settingsButton))
		S:TryPostHook("WQT_SettingsTextInputMixin", "Init", wrap(settingsTextInput))
		S:TryPostHook("WQT_ListButtonMixin", "Update", wrap(listButton))
	end
end
