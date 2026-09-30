local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local ES = E.Skins
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

local data = S:AddCallbackForAddon("Immersion", nil, S:CreateAddonCheck("immersion"))

function data:ReskinTitleButton() -- self is ImmersionFrame, not data
	local frame = self
	for _, button in pairs({ frame.TitleButtons:GetChildren() }) do
		if button and not button.__windSkin then
			S:Proxy("HandleButton", button, nil, nil, nil, true, "Transparent")
			button.backdrop:ClearAllPoints()
			button.backdrop:Point("TOPLEFT", button, "TOPLEFT", 3, -3)
			button.backdrop:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -10, 3)
			S:CreateBackdropShadow(button)
			S:MerathilisUISkin(button.backdrop)

			button.Hilite:StripTextures()
			button.Overlay:StripTextures()
			button:SetBackdrop(nil)
			F.SetFont(button.Label)
			button.__windSkin = true
		end
	end
end

function data:AttemptReskinButton()
	data.reskinButtonAttemptCount = data.reskinButtonAttemptCount + 1
	data.ReskinTitleButton(_G.ImmersionFrame)
	if data.reskinButtonAttemptCount == 10 then
		S:CancelTimer(data.reskinButtonTimer)
	end
end

function data:Show() -- self is ImmersionFrame, not data
	data:SpeechProgressText()
	data.ReskinTitleButton(_G.ImmersionFrame)
	data.reskinButtonAttemptCount = 0
	data.reskinButtonTimer = S:ScheduleRepeatingTimer(data.AttemptReskinButton, 0.1, data)
	E:Delay(0.1, data.ReskinItems, data)
end

function data:ReskinItems()
	for i = 1, 20 do
		local rButton = _G["ImmersionQuestInfoItem" .. i]
		if not rButton then
			break
		end

		if not rButton.__windSkin then
			if rButton.NameFrame then
				rButton.NameFrame:StripTextures()
				rButton.NameFrame:CreateBackdrop("Transparent")
				rButton.NameFrame.backdrop:ClearAllPoints()
				rButton.NameFrame.backdrop:SetOutside(rButton.NameFrame, -18, -15)
				S:CreateBackdropShadow(rButton.NameFrame)
			end
			rButton.__windSkin = true
		end
	end

	for i = 1, 20 do
		local rButton = _G["ImmersionProgressItem" .. i]
		if not rButton then
			break
		end

		if not rButton.__windSkin then
			if rButton.NameFrame then
				rButton.NameFrame:StripTextures()
				rButton.NameFrame:CreateBackdrop("Transparent")
				rButton.NameFrame.backdrop:ClearAllPoints()
				rButton.NameFrame.backdrop:SetOutside(rButton.NameFrame, -18, -15)
				S:CreateBackdropShadow(rButton.NameFrame)
			end
			rButton.__windSkin = true
		end
	end
end

do -- If there is no speech progress text in first time, the skin will not be apply
	local reskin = false
	function data:SpeechProgressText()
		if reskin then
			return
		end
		local talkBox = _G.ImmersionFrame and _G.ImmersionFrame.TalkBox
		if talkBox and talkBox.TextFrame and talkBox.TextFrame.SpeechProgress then
			F.SetFont(talkBox.TextFrame.SpeechProgress, F.GetCompatibleFont("Montserrat"), 13)
			reskin = true
		end
	end
end

function S:Immersion()
	S:DisableAddOnSkin("Immersion")

	local frame = _G.ImmersionFrame

	-- TalkBox
	local talkBox = frame.TalkBox

	-- Backdrop
	talkBox.BackgroundFrame:StripTextures()
	talkBox:CreateBackdrop("Transparent")
	talkBox.backdrop:ClearAllPoints()
	talkBox.backdrop:Point("TOPLEFT", talkBox, "TOPLEFT", 10, -10)
	talkBox.backdrop:Point("BOTTOMRIGHT", talkBox, "BOTTOMRIGHT", -10, 10)
	self:CreateBackdropShadow(talkBox)
	self:MerathilisUISkin(talkBox.backdrop)

	-- Use colored backdrop edge as highlight
	talkBox.Hilite:StripTextures()
	talkBox:HookScript("OnEnter", function(box)
		ES.SetModifiedBackdrop(box)

		if box.backdrop.shadow then
			box.backdrop.shadow:SetBackdropBorderColor(box.backdrop:GetBackdropBorderColor())
		end
	end)

	talkBox:HookScript("OnLeave", function(box)
		ES.SetOriginalBackdrop(box)

		if box.backdrop.shadow then
			box.backdrop.shadow:SetBackdropBorderColor(box.backdrop:GetBackdropBorderColor())
		end
	end)

	-- Remove background of model
	talkBox.PortraitFrame:StripTextures()
	talkBox.MainFrame.Model.ModelShadow:StripTextures()
	talkBox.MainFrame.Model.PortraitBG:StripTextures()

	-- No Sheen
	talkBox.MainFrame.Sheen:StripTextures()
	talkBox.MainFrame.TextSheen:StripTextures()
	talkBox.MainFrame.Overlay:StripTextures()

	-- Text
	F.SetFont(talkBox.NameFrame.Name)
	F.SetFont(talkBox.TextFrame.Text, nil, 15)

	-- Close Button
	self:Proxy("HandleCloseButton", talkBox.MainFrame.CloseButton)

	-- Indicator
	talkBox.MainFrame.Indicator:ClearAllPoints()
	talkBox.MainFrame.Indicator:Point("RIGHT", talkBox.MainFrame.CloseButton, "LEFT", -2, 0)

	-- Reputation bar
	local repBar = talkBox.ReputationBar
	repBar:StripTextures()
	repBar:SetStatusBarTexture(E.media.normTex)
	repBar:CreateBackdrop()
	repBar:ClearAllPoints()
	repBar:Point("TOPLEFT", talkBox, "TOPLEFT", 11, -11)
	repBar:Height(6)

	E:RegisterStatusBar(repBar)

	-- Backdrop of elements (bottom window)
	local elements = talkBox.Elements
	elements:SetBackdrop(nil)
	elements:CreateBackdrop("Transparent")
	elements.backdrop:ClearAllPoints()
	elements.backdrop:Point("TOPLEFT", elements, "TOPLEFT", 10, -5)
	elements.backdrop:Point("BOTTOMRIGHT", elements, "BOTTOMRIGHT", -10, 5)
	F.SetFont(elements.Progress.ReqText)
	S:CreateBackdropShadow(elements)
	S:MerathilisUISkin(elements.backdrop)

	-- Details
	local content = elements.Content
	F.SetFont(content.ObjectivesHeader)
	F.SetFont(content.ObjectivesText)
	F.SetFont(content.RewardText)
	F.SetFont(content.RewardsFrame.Header)
	F.SetFont(content.RewardsFrame.TitleFrame.Name)
	F.SetFont(content.RewardsFrame.XPFrame.ReceiveText)
	F.SetFont(content.RewardsFrame.XPFrame.ValueText)
	F.SetFont(content.RewardsFrame.ItemReceiveText)
	F.SetFont(content.RewardsFrame.ItemChooseText)
	F.SetFont(content.RewardsFrame.PlayerTitleText)
	F.SetFont(content.RewardsFrame.SkillPointFrame.ValueText)

	-- Buttons
	self:SecureHookScript(frame, "OnEvent", data.ReskinTitleButton)
	self:SecureHook(frame, "Show", data.Show)
end
