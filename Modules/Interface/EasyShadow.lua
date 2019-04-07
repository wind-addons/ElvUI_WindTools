-- 简单阴影
-- 考虑到效能，不会添加通用函数来加阴影
-- 作者：houshuu
-- AddonSkins 美化修改自 BenikUI
-- 任务图标美化修改自 NDui
local E, L, V, P, G = unpack(ElvUI)
local AS            = unpack(AddOnSkins)
local WT         = E:GetModule("WindTools")
local A          = E:GetModule('Auras')
local S          = E:GetModule('Skins')
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

EasyShadow.elvui_frame_list = {
	["actionbars"] = L["Actionbars"],
	["auras"] = L["Auras"],
	["castbar"] = L["Cast Bar"],
	["classbar"] = L["Class Bar"],
	["databars"] = L["Databars"],
	["general"] = L["General"],
	["quest_item"] = L["Quest Icon"],
	["unitframes"] = L["Unit Frames"],
	["tooltips"] = L["Game Tooltip"],
}

EasyShadow.addonskins_list = {
	["weakaura"] = L["Weakaura 2"],
	["bigWigs"] = L["Bigwigs"],
	["general"] = L["General"],
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

local function mirrorTimersShadows()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.mirrorTimers ~= true then return end

	for i = 1, MIRRORTIMER_NUMTIMERS do
		local statusBar = _G['MirrorTimer'..i..'StatusBar']
		statusBar.backdrop:CreateSoftShadow()
	end
end


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

local function WeakAurasShadows()
	local function Skin_WeakAuras(frame, ftype)
		if frame.Backdrop then CreateMyShadow(frame.Backdrop, 2) end
	end
	local Create_Icon, Modify_Icon = WeakAuras.regionTypes.icon.create, WeakAuras.regionTypes.icon.modify
	local Create_AuraBar, Modify_AuraBar = WeakAuras.regionTypes.aurabar.create, WeakAuras.regionTypes.aurabar.modify

	WeakAuras.regionTypes.icon.create = function(parent, data)
		local region = Create_Icon(parent, data)
		Skin_WeakAuras(region, 'icon')
		return region
	end

	WeakAuras.regionTypes.aurabar.create = function(parent)
		local region = Create_AuraBar(parent)
		Skin_WeakAuras(region, 'aurabar')
		return region
	end

	WeakAuras.regionTypes.icon.modify = function(parent, region, data)
		Modify_Icon(parent, region, data)
		Skin_WeakAuras(region, 'icon')
	end

	WeakAuras.regionTypes.aurabar.modify = function(parent, region, data)
		Modify_AuraBar(parent, region, data)
		Skin_WeakAuras(region, 'aurabar')
	end

	for weakAura, _ in pairs(WeakAuras.regions) do
		if WeakAuras.regions[weakAura].regionType == 'icon' or WeakAuras.regions[weakAura].regionType == 'aurabar' then
			Skin_WeakAuras(WeakAuras.regions[weakAura].region, WeakAuras.regions[weakAura].regionType)
		end
	end
end

function EasyShadow:ShadowBlzFrames()
	if not self.db then return end
	for k, v in pairs(self.BlzFrames) do
		if self.db.BlzFrames[k] then CreateMyShadow(_G[k], 4) end
	end
end

function EasyShadow:ShadowElvUIFrames()
	if not self.db then return end

	if self.db.elvui.general then
		-- ElvUI 美化标签页
		hooksecurefunc(S, "HandleTab", function(_, tab)
			if not tab then return end
			if tab.backdrop then CreateMyShadow(tab.backdrop, 2) end
		end)

		-- ElvUI 美化按钮
		hooksecurefunc(S, "HandleButton", function(_, button)
			if not button then return end
			CreateMyShadow(button, 2)
		end)

		-- ElvUI 框体渲染
		hooksecurefunc(S, "HandlePortraitFrame", function(_, frame)
			if not frame then return end
			if frame.backdrop then CreateMyShadow(frame.backdrop, 2) end
		end)

		-- ElvUI 美化图标
		-- hooksecurefunc(S, "HandleIcon", function(_, icon)
		-- 	if not icon then return end
		-- 	CreateMyShadow(icon,2)
		-- end)

		-- 团队控制
		if E.private.general.raidUtility then
			if _G["RaidUtility_ShowButton"] then
				CreateMyShadow(_G["RaidUtility_ShowButton"], 4)
			end
			if _G["RaidUtilityPanel"] then
				CreateMyShadow(_G["RaidUtilityPanel"], 4)
			end
		end

		CreateMyShadow(EquipmentFlyoutFrameButtons, 2)

	end

	-- 光环条
	if self.db.elvui.auras then
		hooksecurefunc(A, "CreateIcon", function(self, button)
			if button then CreateMyShadow(button, 4) end
		end)
		hooksecurefunc(A, "UpdateAura", function(self, button, index)
			if button then CreateMyShadow(button, 4) end
		end)
	end

	-- 任务物品
	if self.db.elvui.quest_item then
		hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", shadowQuestIcon)
		hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", shadowQuestIcon)
	end

	-- 单位框体
	if self.db.elvui.unitframes then
		hooksecurefunc(UF, "UpdateNameSettings", function(_, frame)
			CreateMyShadow(frame, 4, 0.5, 0.8)
		end)

		hooksecurefunc(UF, "UpdateAuraSettings", function(_,  _, button)
			CreateMyShadow(button, 2, 0.5, 1)
		end)
	end

	-- 职业条
	if self.db.elvui.classbar then
		hooksecurefunc(UF, "Configure_ClassBar", function(_, frame)
			local bars = frame[frame.ClassBar]
			if not bars then return end
			CreateMyShadow(bars, 4, 0.5, 0.8)
		end)
	end

	-- 施法条
	if self.db.elvui.castbar then
		hooksecurefunc(UF, "Configure_Castbar", function(_, frame)
			CreateMyShadow(frame.Castbar, 3)
			if not frame.db.castbar.iconAttached then
				CreateMyShadow(frame.Castbar.ButtonIcon.bg, 3)
			end
		end)
	end

	-- 鼠标提示
	if self.db.elvui.Tootooltipsltip then
		hooksecurefunc(TT, "SetStyle", function(_, tt)
			CreateMyShadow(tt, 4)
		end)
		hooksecurefunc(TT, "GameTooltip_SetDefaultAnchor", function(_, tt)
			if tt:IsForbidden() then return end
			if E.private.tooltip.enable ~= true then return end
			CreateMyShadow(_G["GameTooltipStatusBar"], 4, 0.8, 0)
		end)
	end

	-- 数据条
	if self.db.elvui.databars then
		if DATABAR.db.azerite.enable then CreateMyShadow(_G["ElvUI_AzeriteBar"], 2) end
		if DATABAR.db.experience.enable then CreateMyShadow(_G["ElvUI_ExperienceBar"], 2) end
		if DATABAR.db.reputation.enable then CreateMyShadow(_G["ElvUI_ReputationBar"], 2) end
		if DATABAR.db.honor.enable then CreateMyShadow(_G["ElvUI_HonorBar"], 2) end
	end

	if self.db.elvui.actionbars or true then
		-- 常规动作条
		local actionbar_list = {
			"Bar1Button",
			"Bar2Button",
			"Bar3Button",
			"Bar4Button",
			"Bar5Button",
			"Bar6Button",
			"StanceBarButton",
			"BarPetButton",
			"TotemBarTotem",
		}
		for _, item in pairs(actionbar_list) do
			for i = 1, 12 do
				local button = _G["ElvUI_"..item..i]
				if button and button.backdrop then CreateMyShadow(button.backdrop, 3) end
			end
		end
		-- 非常规动作条
		CreateMyShadow(_G.ZoneAbilityFrame.SpellButton, 3)
	end
end

function EasyShadow:Initialize()
	self.db = E.db.WindTools["Interface"]["EasyShadow"]
	if not self.db["enabled"] then return end

	self:ShadowBlzFrames()
	self:ShadowElvUIFrames()
	self:AddOnSkins()
end

function EasyShadow:AddOnSkins()
	-- 用 AddOnSkins 美化的窗体标签页
	if self.db.addonskins.general then
		hooksecurefunc(AS, "SkinTab", function()
			if not tab then return end
			if tab.backdrop then CreateMyShadow(tab.Backdrop, 2, 1, 0.5) end
		end)
	end
	
	-- Weakaura
	if self.db.addonskins.weakaura and AS:CheckAddOn('WeakAuras') then
		AS:RegisterSkin('WeakAuras', WeakAurasShadows, 'ADDON_LOADED')
	end

	-- Bigwigs
	if self.db.addonskins.bigwigs and AS:CheckAddOn('BigWigs') then
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
					CreateMyShadow(frame, 3)
				end
			end)
		end
	end

	if event == 'ADDON_LOADED' and addon == 'BigWigs_Plugins' then
		CreateMyShadow(BigWigsInfoBox, 3)
		CreateMyShadow(BigWigsAltPower, 3)

		local buttonsize = 19
		local FreeBackgrounds = {}

		local CreateBG = function()
			local BG = CreateFrame('Frame')
			BG:SetTemplate('Transparent')
			CreateMyShadow(BG, 2)

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