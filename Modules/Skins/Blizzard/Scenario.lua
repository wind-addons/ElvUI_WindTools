local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

local hooksecurefunc = hooksecurefunc
local pairs = pairs
local select = select
local unpack = unpack

local CreateFrame = CreateFrame
local GetInstanceInfo = GetInstanceInfo

local C_ChallengeMode_GetAffixInfo = C_ChallengeMode.GetAffixInfo

local function SkinMawBuffsContainer(container)
	container:StripTextures()
	container:GetHighlightTexture():Kill()
	container:GetPushedTexture():Kill()
	local pushed = container:CreateTexture()
	S:Reposition(pushed, container, 0, -11, -11, -17, -4)
	pushed:SetBlendMode("ADD")
	local vr, vg, vb = unpack(E.media.rgbvaluecolor)
	pushed:SetColorTexture(vr, vg, vb, 0.2)
	container:SetPushedTexture(pushed)
	container.SetHighlightAtlas = E.noop
	container.SetPushedAtlas = E.noop
	container.Width = E.noop
	container.SetPushedTextOffset = E.noop

	container:CreateBackdrop("Transparent")
	S:Reposition(container.backdrop, container, 1, -10, -10, -16, -3)
	S:CreateBackdropShadow(container)

	local blockList = container.List
	blockList:StripTextures()
	blockList:CreateBackdrop("Transparent")
	S:Reposition(blockList.backdrop, blockList, 1, -11, -11, -6, -6)
	S:CreateBackdropShadow(blockList)
end

local function ScenarioObjectiveTrackerStage_UpdateStageBlock(block)
	block.NormalBG:SetTexture("")
	block.FinalBG:SetTexture("")

	if not block.backdrop then
		block:CreateBackdrop("Transparent")
		block.backdrop:ClearAllPoints()
		block.backdrop:Point("TOPLEFT", block.GlowTexture, 6, -4)
		block.backdrop:Point("BOTTOMRIGHT", block.GlowTexture, 12, 3)
		S:CreateShadow(block.backdrop)
	end

	if block.UpdateFindGroupButton then
		hooksecurefunc(block, "UpdateFindGroupButton", function(self)
			if self.findGroupButton and not self.findGroupButton.__windSkin then
				S:CreateShadow(self.findGroupButton) -- Need more testing for this button
				self.findGroupButton.__windSkin = true
			end
		end)
	end
end

local function ScenarioObjectiveTrackerChallengeMode_SetUpAffixes(block)
	for frame in block.affixPool:EnumerateActive() do
		if not frame.__windSkin and frame.affixID then
			frame.Border:SetAlpha(0)
			local texPath = select(3, C_ChallengeMode_GetAffixInfo(frame.affixID))
			frame:CreateBackdrop("Transparent")
			frame.backdrop:ClearAllPoints()
			frame.backdrop:SetOutside(frame.Portrait)
			frame.Portrait:SetTexture(texPath)
			frame.Portrait:SetTexCoords()
			frame.__windSkin = true
		end
	end
end

local function ScenarioObjectiveTrackerChallengeMode_Activate(block)
	if block.__windSkin then
		return
	end

	-- Block background
	block.TimerBG:Hide()
	block.TimerBGBack:Hide()

	block:CreateBackdrop("Transparent")
	block.backdrop:ClearAllPoints()
	block.backdrop:SetInside(block, 6, 2)
	S:CreateBackdropShadow(block)

	-- Time bar
	block.StatusBar:CreateBackdrop()
	block.StatusBar.backdrop:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.6)
	block.StatusBar:SetStatusBarTexture(E.media.normTex)
	block.StatusBar:SetStatusBarColor(unpack(E.media.rgbvaluecolor))
	block.StatusBar:Height(12)

	select(3, block:GetRegions()):Hide()

	block.__windSkin = true
end

local function UpdateHooksOfBlock(block)
	-- Stage block
	if block.Stage and block.WidgetContainer and not block.__windStageHooked then
		block.__windStageHooked = true
		hooksecurefunc(block, "UpdateStageBlock", ScenarioObjectiveTrackerStage_UpdateStageBlock)
		ScenarioObjectiveTrackerStage_UpdateStageBlock(block)
	end

	-- Challenge mode block
	if block.DeathCount and not block.__windChanllengeModeHooked then
		block.__windChanllengeModeHooked = true
		hooksecurefunc(block, "Activate", ScenarioObjectiveTrackerChallengeMode_Activate)
		hooksecurefunc(block, "SetUpAffixes", ScenarioObjectiveTrackerChallengeMode_SetUpAffixes)
		ScenarioObjectiveTrackerChallengeMode_Activate(block)
		ScenarioObjectiveTrackerChallengeMode_SetUpAffixes(block)
	end
end

local function UpdateBlock(block)
	if block.__windStageHooked and block.WidgetContainer and block.WidgetContainer.widgetFrames then
		for _, widgetFrame in pairs(block.WidgetContainer.widgetFrames) do
			if widgetFrame.Frame then
				widgetFrame.Frame:SetAlpha(0)
			end

			local bar = widgetFrame.Bar
			if bar and bar.backdrop and not bar.__windSkinBackdropHighContrast then
				local r, g, b, a = bar.backdrop:GetBackdropColor()
				if r + g + b < 0.5 then
					r, g, b = r + 0.2, g + 0.2, b + 0.2
					bar.backdrop:SetBackdropColor(r, g, b, a)
				end

				bar.__windSkinBackdropHighContrast = true
			end

			local timeBar = widgetFrame.TimerBar
			if timeBar and not timeBar.__windSkin then
				F.InternalizeMethod(timeBar, "SetStatusBarTexture", true)
				hooksecurefunc(timeBar, "SetStatusBarTexture", function(frame)
					F.CallMethod(frame, "SetStatusBarTexture", E.media.normTex)
					frame:SetStatusBarColor(unpack(E.media.rgbvaluecolor))
				end)
				timeBar:CreateBackdrop("Transparent")
				timeBar.__windSkin = true
			end

			if widgetFrame.CurrencyContainer then
				for currencyFrame in widgetFrame.currencyPool:EnumerateActive() do
					if not currencyFrame.__windSkin then
						currencyFrame.Icon:SetTexCoords()
						currencyFrame.__windSkin = true
					end
				end
			end

			-- Awakening the Machine
			local mapID = select(8, GetInstanceInfo())
			if mapID and mapID == 2710 and not widgetFrame.__windSkinMoved then
				if widgetFrame.Bar and widgetFrame.Label then
					widgetFrame.Label:Hide()
					F.Move(widgetFrame, 15, 0)
				else
					F.Move(widgetFrame, 10, 0)
				end

				widgetFrame.__windSkinMoved = true
			end
		end
	end

	if block.__windChanllengeModeHooked then
		if block:IsActive() then
			ScenarioObjectiveTrackerChallengeMode_Activate(block)
			ScenarioObjectiveTrackerChallengeMode_SetUpAffixes(block)
		end
	end
end

local function ScenarioObjectiveTracker_AddBlock(_, block)
	if not block then
		return
	end

	UpdateHooksOfBlock(block)
	UpdateBlock(block)
end

local function ScenarioObjectiveTracker_Update(tracker)
	for _, block in pairs(tracker.usedBlocks or {}) do
		UpdateHooksOfBlock(block)
		UpdateBlock(block)
	end
end

local handledSpellFrames, iconBackdrops = {}, {}
local function ReskinSpellFrame(frame)
	if not frame or handledSpellFrames[frame] then
		return
	end

	local SpellName = frame.SpellName
	if SpellName then
		F.SetFont(SpellName)
	end

	local SpellButton = frame.SpellButton
	if SpellButton then
		local normalTex = SpellButton:GetNormalTexture()
		if normalTex then
			normalTex:SetAlpha(0)
		end

		local highlightTex = SpellButton:GetHighlightTexture()
		if highlightTex then
			highlightTex:SetTexture(E.media.blankTex)
			highlightTex:SetTexCoords()
			highlightTex:SetVertexColor(1, 1, 1, 0.25)
		end

		local pushedTex = SpellButton:GetPushedTexture()
		if pushedTex then
			pushedTex:SetTexture(E.media.blankTex)
			pushedTex:SetTexCoords()
			pushedTex:SetVertexColor(1, 1, 1, 0.4)
		end

		local SpellIcon = SpellButton.Icon
		if SpellIcon then
			if not iconBackdrops[SpellIcon] then
				local backdrop = CreateFrame("Frame", nil, E.UIParent)
				backdrop:SetTemplate("Default")
				backdrop.Center:Kill()
				iconBackdrops[SpellIcon] = backdrop
				S:CreateShadow(backdrop)

				-- Handle the release / reuse of the frame
				frame:HookScript("OnHide", function()
					backdrop:Hide()
				end)

				frame:HookScript("OnShow", function()
					backdrop:Show()
				end)
			end

			local backdrop = iconBackdrops[SpellIcon]
			backdrop:ClearAllPoints()
			backdrop:SetOutside(SpellIcon)
			SpellIcon:SetTexCoords()

			SpellButton:HookScript("OnEnter", function()
				backdrop:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
			end)

			SpellButton:HookScript("OnLeave", function()
				backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end)
		end
	end

	handledSpellFrames[frame] = true
end

local function HookSpellFramePool()
	if not _G.ScenarioObjectiveTracker or not _G.ScenarioObjectiveTracker.spellFramePool then
		return
	end

	hooksecurefunc(_G.ScenarioObjectiveTracker.spellFramePool, "Acquire", function(self)
		for frame in self:EnumerateActive() do
			ReskinSpellFrame(frame)
		end
	end)

	for frame in _G.ScenarioObjectiveTracker.spellFramePool:EnumerateActive() do
		ReskinSpellFrame(frame)
	end
end

function S:ScenarioStage()
	if not self:CheckDB(nil, "scenario") then
		return
	end

	local ScenarioObjectiveTracker = _G.ScenarioObjectiveTracker
	if not ScenarioObjectiveTracker then
		return
	end

	hooksecurefunc(ScenarioObjectiveTracker, "Update", ScenarioObjectiveTracker_Update)
	hooksecurefunc(ScenarioObjectiveTracker, "AddBlock", ScenarioObjectiveTracker_AddBlock)

	if ScenarioObjectiveTracker.spellFramePool then
		HookSpellFramePool()
	else
		hooksecurefunc(ScenarioObjectiveTracker, "InitModule", function(self)
			if self.spellFramePool then
				HookSpellFramePool()
			end
		end)
	end

	if ScenarioObjectiveTracker.MawBuffsBlock then
		SkinMawBuffsContainer(ScenarioObjectiveTracker.MawBuffsBlock.Container)
	end
end

S:AddCallback("ScenarioStage")
