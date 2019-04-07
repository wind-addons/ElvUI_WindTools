-- 简单阴影
-- 考虑到效能，不会添加通用函数来加阴影
-- 作者：houshuu

-- AddonSkins 部分来源于 BenikUI
local E, L, V, P, G = unpack(ElvUI)
local AS            = unpack(AddOnSkins)
local WT         = E:GetModule("WindTools")
local A          = E:GetModule('Auras')
local UF         = E:GetModule('UnitFrames')
local TT         = E:GetModule('Tooltip')
local DATABAR    = E:GetModule('DataBars')
local EasyShadow = E:NewModule('Wind_EasyShadow')
local ElvUF      = ElvUF
local LSM        = LibStub("LibSharedMedia-3.0")
local _G         = _G

-- 初始化颜色
local borderr, borderg, borderb = 0, 0, 0
local backdropr, backdropg, backdropb = 0, 0, 0

-- 不需要检测插件载入即可上阴影的框体
EasyShadow.BlzFrames = {
	["MMHolder"] = L["MiniMap"],
	["GameMenuFrame"] = L["Game Menu"],
	["InterfaceOptionsFrame"] = L["Interface Options"],
	["VideoOptionsFrame"] = L["Video Options"],
}

EasyShadow.ElvUIActionbars = {
	["ElvUI_Bar1Button"] = L["Action Bar"].." 1",
	["ElvUI_Bar2Button"] = L["Action Bar"].." 2",
	["ElvUI_Bar3Button"] = L["Action Bar"].." 3",
	["ElvUI_Bar4Button"] = L["Action Bar"].." 4",
	["ElvUI_Bar5Button"] = L["Action Bar"].." 5",
	["ElvUI_Bar6Button"] = L["Action Bar"].." 6",
	["ElvUI_StanceBarButton"] = L["StanceBar"],
	["ElvUI_TotemBarTotem"] = L["TotemBar"],
}

EasyShadow.ElvUIFrames = {
	["Aura"] = L["Auras"],
	["Castbar"] = L["Cast Bar"],
	["CastbarIcon"] = L["Cast Bar Icon"],
	["UnitFrames"] = L["Unit Frames"],
	["Classbar"] = L["Class Bar"],
	["UnitFrameAura"] = L["Unit Frame Aura"],
	["QuestIconShadow"] = L["Quest Icon"],
	["Tooltip"] = L["Game Tooltip"],
	["Databars"] = L["Databars"],
}

local function CreateMyShadow(frame, size, backalpha, borderalpha)
	if not frame or frame.shadow then return end
	local back = backalpha or 0.5
	local border = backalpha or 0.6

	local shadow = CreateFrame("Frame", nil, frame)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(frame:GetFrameStrata())
	shadow:SetOutside(frame, size, size)
	shadow:SetBackdrop({
		edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = E:Scale(size),
		insets = {left = E:Scale(size), right = E:Scale(size), top = E:Scale(size), bottom = E:Scale(size)},
	})
	shadow:SetBackdropColor(backdropr, backdropg, backdropb, back)
	shadow:SetBackdropBorderColor(borderr, borderg, borderb, border)

	frame.shadow = shadow
end

-- 来自 NDui by siweia
local function shadowQuestIcon(_, block)
	local itemButton = block.itemButton
	if itemButton and not itemButton.styled then
		CreateMyShadow(itemButton, 3)
		itemButton.styled = true
	end
	local rightButton = block.rightButton
	if rightButton and not rightButton.styled then
		CreateMyShadow(rightButton, 3)
		rightButton.styled = true
	end
end

function EasyShadow:ShadowBlzFrames()
	if not self.db then return end
	for k, v in pairs(self.BlzFrames) do
		if self.db.BlzFrames[k] then CreateMyShadow(_G[k], 3) end
	end
	
end

function EasyShadow:ShadowElvUIActionbars()
	if not self.db then return end
	for k, v in pairs(self.ElvUIActionbars) do
		if self.db.ElvUIActionbars[k] then 
			for i = 1, 12 do CreateMyShadow(_G[k..i], 3) end
		end
	end
end

function EasyShadow:ShadowElvUIFrames()
	if not self.db then return end

	if self.db.ElvUIFrames.Aura then
		hooksecurefunc(A, "CreateIcon", function(self, button)
			CreateMyShadow(button, 4)
		end)
		hooksecurefunc(A, "UpdateAura", function(self, button, index)
			CreateMyShadow(button, 4)
		end)
	end

	if self.db.ElvUIFrames.QuestIconShadow then
		hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", shadowQuestIcon)
		hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", shadowQuestIcon)
	end

	if self.db.ElvUIFrames.UnitFrames then
		hooksecurefunc(UF, "UpdateNameSettings", function(_, frame)
			CreateMyShadow(frame, 4, 0.5, 0.8)
		end)
	end

	if self.db.ElvUIFrames.Castbar then
		hooksecurefunc(UF, "Configure_Castbar", function(_, frame)
			CreateMyShadow(frame.Castbar, 3)
		end)
	end

	if self.db.ElvUIFrames.CastbarIcon then
		hooksecurefunc(UF, "Configure_Castbar", function(_, frame)
			CreateMyShadow(frame.Castbar.ButtonIcon.bg, 3)
		end)	
	end

	if self.db.ElvUIFrames.UnitFrameAura then
		hooksecurefunc(UF, "UpdateAuraSettings", function(_,  _, button)
			CreateMyShadow(button, 2, 0.5, 1)
		end)
	end

	if self.db.ElvUIFrames.Classbar then
		hooksecurefunc(UF, "Configure_ClassBar", function(_, frame)
			local bars = frame[frame.ClassBar]
			if not bars then return end
			CreateMyShadow(bars, 4, 0.5, 0.8)
		end)
	end
	
	if self.db.ElvUIFrames.Tooltip then
		hooksecurefunc(TT, "SetStyle", function(_, tt)
			CreateMyShadow(tt, 4)
		end)
		hooksecurefunc(TT, "GameTooltip_SetDefaultAnchor", function(_, tt)
			if tt:IsForbidden() then return end
			if E.private.tooltip.enable ~= true then return end
			CreateMyShadow(_G["GameTooltipStatusBar"], 4, 0.8, 0)
		end)
	end

	if self.db.ElvUIFrames.Databars then
		if DATABAR.db.azerite.enable then CreateMyShadow(_G["ElvUI_AzeriteBar"], 2) end
		if DATABAR.db.experience.enable then CreateMyShadow(_G["ElvUI_ExperienceBar"], 2) end
		if DATABAR.db.reputation.enable then CreateMyShadow(_G["ElvUI_ReputationBar"], 2) end
		if DATABAR.db.honor.enable then CreateMyShadow(_G["ElvUI_HonorBar"], 2) end
	end
end

function EasyShadow:Initialize()
	self.db = E.db.WindTools["Interface"]["EasyShadow"]
	if not self.db["enabled"] then return end
	
	self:ShadowBlzFrames()
	self:ShadowElvUIActionbars()
	self:ShadowElvUIFrames()
	self:AddOnSkins()
end

function EasyShadow:AddOnSkins()
	-- Bigwigs
	if AS:CheckAddOn('BigWigs') then
		AS:RegisterSkin('BigWigs', EasyShadow.BigWigs, 'ADDON_LOADED')
		AS:RegisterSkinForPreload('BigWigs_Plugins', EasyShadow.BigWigs)
	end
end

function EasyShadow:BigWigs(event, addon)
	if event == 'PLAYER_ENTERING_WORLD' then
		if BigWigsLoader then
			BigWigsLoader.RegisterMessage('AddOnSkins', "BigWigs_FrameCreated", function(event, frame, name)
				if name == "QueueTimer" then
					AS:SkinStatusBar(frame)
					frame:ClearAllPoints()
					frame:SetPoint('TOP', '$parent', 'BOTTOM', 0, -(AS.PixelPerfect and 2 or 4))
					frame:SetHeight(16)
					if EasyShadow.db.AddonSkins.bigwigs then CreateMyShadow(frame, 3) end
				end
			end)
		end
	end

	if event == 'ADDON_LOADED' and addon == 'BigWigs_Plugins' then
		if EasyShadow.db.AddonSkins.bigwigs then
			CreateMyShadow(BigWigsInfoBox, 3)
			CreateMyShadow(BigWigsAltPower, 3)
		end

		local buttonsize = 19
		local FreeBackgrounds = {}

		local CreateBG = function()
			local BG = CreateFrame('Frame')
			BG:SetTemplate('Transparent')
			if EasyShadow.db.AddonSkins.bigwigs then
				CreateMyShadow(BG, 2)
			end

			return BG
		end

		local function FreeStyle(bar, FreeBackgrounds)
			local bg = bar:Get('bigwigs:AddOnSkins:bg')
			if bg then
				bg:ClearAllPoints()
				bg:SetParent(UIParent)
				bg:Hide()
				FreeBackgrounds[#FreeBackgrounds + 1] = bg
			end

			local ibg = bar:Get('bigwigs:AddOnSkins:ibg')
			if ibg then
				ibg:ClearAllPoints()
				ibg:SetParent(UIParent)
				ibg:Hide()
				FreeBackgrounds[#FreeBackgrounds + 1] = ibg
			end

			bar.candyBarIconFrame:ClearAllPoints()
			bar.candyBarIconFrame:SetPoint('TOPLEFT')
			bar.candyBarIconFrame:SetPoint('BOTTOMLEFT')

			bar.candyBarBar:ClearAllPoints()
			bar.candyBarBar.SetPoint = nil
			bar.candyBarBar:SetPoint('TOPRIGHT')
			bar.candyBarBar:SetPoint('BOTTOMRIGHT')
		end

		local function GetBG(FreeBackgrounds)
			if #FreeBackgrounds > 0 then
				return tremove(FreeBackgrounds)
			else
				return CreateBG()
			end
		end

		local function SetupBG(bg, bar, ibg)
			bg:SetParent(bar)
			bg:SetFrameStrata(bar:GetFrameStrata())
			bg:SetFrameLevel(bar:GetFrameLevel() - 1)
			bg:ClearAllPoints()
			if ibg then
				bg:SetOutside(bar.candyBarIconFrame)
				bg:SetBackdropColor(0, 0, 0, 0)
			else
				bg:SetOutside(bar)
				bg:SetBackdropColor(unpack(AS.BackdropColor))
			end
			bg:Show()
		end

		local function ApplyStyle(bar, FreeBackgrounds, buttonsize)
			bar:SetHeight(buttonsize)

			local bg = GetBG(FreeBackgrounds)
			SetupBG(bg, bar)
			bar:Set('bigwigs:AddOnSkins:bg', bg)

			if bar.candyBarIconFrame:GetTexture() then
				local ibg = GetBG(FreeBackgrounds)
				SetupBG(ibg, bar, true)
				bar:Set('bigwigs:AddOnSkins:ibg', ibg)
			end

			bar.candyBarBar:ClearAllPoints()
			bar.candyBarBar:SetAllPoints(bar)
			bar.candyBarBar.SetPoint = AS.Noop
			bar.candyBarBar:SetStatusBarTexture(AS.NormTex)
			bar.candyBarBackground:SetTexture(AS.NormTex)

			bar.candyBarIconFrame:ClearAllPoints()
			bar.candyBarIconFrame:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMLEFT', -7, 0)
			bar.candyBarIconFrame:SetSize(buttonsize, buttonsize)
			AS:SkinTexture(bar.candyBarIconFrame)

			bar.candyBarLabel:ClearAllPoints()
			bar.candyBarLabel:SetPoint("LEFT", bar, "LEFT", 2, 0)
			bar.candyBarLabel:SetPoint("RIGHT", bar, "RIGHT", -2, 0)

			bar.candyBarDuration:ClearAllPoints()
			bar.candyBarDuration:SetPoint("LEFT", bar, "LEFT", 2, 0)
			bar.candyBarDuration:SetPoint("RIGHT", bar, "RIGHT", -2, 0)
		end

		local function ApplyStyleHalfBar(bar, FreeBackgrounds, buttonsize)
			local bg = GetBG(FreeBackgrounds)
			SetupBG(bg, bar)
			bar:Set('bigwigs:AddOnSkins:bg', bg)

			if bar.candyBarIconFrame:GetTexture() then
				local ibg = GetBG(FreeBackgrounds)
				SetupBG(ibg, bar, true)
				bar:Set('bigwigs:AddOnSkins:ibg', ibg)
			end

			bar:SetHeight(buttonsize / 2)

			bar.candyBarBar:ClearAllPoints()
			bar.candyBarBar:SetAllPoints(bar)
			bar.candyBarBar.SetPoint = AS.Noop
			bar.candyBarBar:SetStatusBarTexture(AS.NormTex)
			bar.candyBarBackground:SetTexture(unpack(AS.BackdropColor))

			bar.candyBarIconFrame:ClearAllPoints()
			bar.candyBarIconFrame:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMLEFT', -7, 0)
			bar.candyBarIconFrame:SetSize(buttonsize, buttonsize)
			AS:SkinTexture(bar.candyBarIconFrame)

			bar.candyBarLabel:ClearAllPoints()
			bar.candyBarLabel:SetPoint("LEFT", bar, "LEFT", 2, AS:AdjustForTheme(10))
			bar.candyBarLabel:SetPoint("RIGHT", bar, "RIGHT", -2, AS:AdjustForTheme(10))

			bar.candyBarDuration:ClearAllPoints()
			bar.candyBarDuration:SetPoint("LEFT", bar, "LEFT", 2, AS:AdjustForTheme(10))
			bar.candyBarDuration:SetPoint("RIGHT", bar, "RIGHT", -2, AS:AdjustForTheme(10))

			AS:SkinTexture(bar.candyBarIconFrame)
		end

		local BigWigsBars = BigWigs:GetPlugin('Bars')
		BigWigsBars:RegisterBarStyle('AddOnSkins', {
			apiVersion = 1,
			version = 1,
			GetSpacing = function() return 3 end,
			ApplyStyle = function(bar) ApplyStyle(bar, FreeBackgrounds, buttonsize) end,
			BarStopped = function(bar) FreeStyle(bar, FreeBackgrounds) end,
			GetStyleName = function() return 'AddOnSkins' end,
		})
		BigWigsBars:RegisterBarStyle('AddOnSkins Half-Bar', {
			apiVersion = 1,
			version = 1,
			GetSpacing = function() return 13 end,
			ApplyStyle = function(bar) ApplyStyleHalfBar(bar, FreeBackgrounds, buttonsize) end,
			BarStopped = function(bar) FreeStyle(bar, FreeBackgrounds) end,
			GetStyleName = function() return 'AddOnSkins Half-Bar' end,
		})

		AS:UnregisterSkinEvent('BigWigs', event)
	end
end

local function InitializeCallback()
	EasyShadow:Initialize()
end
E:RegisterModule(EasyShadow:GetName(), InitializeCallback)