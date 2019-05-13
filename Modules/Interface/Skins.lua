-- 皮肤增强
-- 作者：houshuu
-- AddonSkins, 任务追踪, 部分 ElvUI 组件美化修改自 BenikUI

local _G = _G
local unpack = unpack
local hooksecurefunc = hooksecurefunc

local E, _, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local L = unpack(select(2, ...))
local WT = E:GetModule("WindTools")
local A = E:GetModule('Auras')
local S = E:GetModule('Skins')
local AB = E:GetModule('ActionBars')
local UF = E:GetModule('UnitFrames')
local TT = E:GetModule('Tooltip')
local DATABAR = E:GetModule('DataBars')
local WS = E:NewModule('Wind_Skins', 'AceEvent-3.0')
local LSM = LibStub("LibSharedMedia-3.0")
local AS

WS.elvui_frame_list = {
	["actionbars"] = L["Action Bars"],
	["auras"] = L["Auras"],
	["castbar"] = L["Cast Bar"],
	["classbar"] = L["Class Bar"],
	["databars"] = L["Databars"],
	["general"] = L["General"],
	["unitframes"] = L["Unit Frames"],
	["tooltips"] = L["Game Tooltip"],
	["altpowerbar"] = L["Altpower Bar"],
	["top_and_bottom_panel"] = L["Top and Bottom panel"],
	["chat_panel"] = L["Chat panel"],
}

WS.addonskins_list = {
	["general"] = L["General"],
	["weakaura"] = L["Weakaura"],
	["bigwigs"] = L["Bigwigs"],
}

WS.blizzard_frames = {
	["MMHolder"] = true,
	["HelpFrame"] = true,
	["HelpFrameHeader"] = true,
	["GameMenuFrame"] = true,
	["InterfaceOptionsFrame"] = true,
	["VideoOptionsFrame"] = true,
	["CharacterFrame"] = true,
	["EquipmentFlyoutFrameButtons"] = true,
	["ElvUI_ContainerFrame"] = true,
	["ElvUI_BankContainerFrame"] = true,
	["AddonList"] = true,
	["BonusRollFrame"] = true,
	["ChatMenu"] = true,
	["SplashFrame"] = true,
	["DropDownList1"] = true,
	["FriendsFrame"] = true,
	["PVEFrame"] = true,
	["SpellBookFrame"] = true,
	["BNToastFrame"] = true,
	["MailFrame"] = true,
	["ReadyCheckFrame"] = true,
	["IMECandidatesFrame"] = true,
	["RaidUtility_ShowButton"] = true,
	["RaidUtility_CloseButton"] = true,
	["RaidUtilityRoleIcons"] = true,
	["RaidUtilityPanel"] = true,
	["WorldMapFrame"] = true,
	["LeaveVehicleButton"] = true,
	["GhostFrameContentsFrame"] = true,
	["ReputationDetailFrame"] = true,
	["CinematicFrameCloseDialog"] = true,
	["TaxiFrame"] = true,
}

WS.lazy_load_list = {
	["Blizzard_GarrisonUI"] = {
		"GarrisonLandingPage",
		"GarrisonMissonFrame",
		"GarrisonShipyardFrame",
		"OrderHallMissionFrame",
		"BFAMissionFrame",
		"OrderHallCommandBar",
	},
	["Blizzard_BindingUI"] = {"KeyBindingFrame"},
	["Blizzard_ChallengesUI"] = {"ChallengesKeystoneFrame"},
	["Blizzard_Calendar"] = {"CalendarFrame", "CalendarViewHolidayFrame"},
}

local function shadow_bigwigs(self, event, addon)
	if event == 'PLAYER_ENTERING_WORLD' then
		if BigWigsLoader then
			BigWigsLoader.RegisterMessage('AddOnSkins', "BigWigs_FrameCreated", function(event, frame, name)
				if name == "QueueTimer" then
					AS:SkinStatusBar(frame)
					frame:ClearAllPoints()
					frame:SetPoint('TOP', '$parent', 'BOTTOM', 0, -(AS.PixelPerfect and 2 or 4))
					frame:SetHeight(16)
					frame:CreateShadow()
				end
			end)
		end
	end

	if event == 'ADDON_LOADED' and addon == 'BigWigs_Plugins' then
		BigWigsInfoBox:CreateShadow()
		BigWigsAltPower:CreateShadow()

		local buttonsize = 19
		local FreeBackgrounds = {}

		local CreateBG = function()
			local BG = CreateFrame('Frame')
			BG:SetTemplate('Transparent')
			BG:CreateShadow()
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

local function shadow_weakauras()
	local function Skin_WeakAuras(frame, ftype)
		if frame.Backdrop then frame.Backdrop:CreateShadow() end
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

local function shadow_objective_tracker()
	-- 修改自 BenikUI

	-- 收起按钮
	ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:CreateShadow(5)
	ObjectiveTrackerFrame.HeaderMenu.MinimizeButton.shadow:SetOutside()

	local function ProgressBarsShadows(self, _, line)
		local progressBar = line and line.ProgressBar
		local bar = progressBar and progressBar.Bar
		if not bar then return end
		local icon = bar.Icon
		local label = bar.Label

		if not progressBar.hasShadow then
			if not bar.backdrop or not progressBar.backdrop then return end
			bar.backdrop:CreateShadow()
			progressBar.backdrop:CreateShadow()
			-- 稍微移动下图标位置，防止阴影重叠，更加美观！
			if icon then icon:Point("LEFT", bar, "RIGHT", E.PixelMode and 7 or 11, 0) end
			-- 顺便修正一下字体位置，反正不知道为什么 ElvUI 要往上移动一个像素
			if label then
				label:ClearAllPoints()
				label:Point("CENTER", bar, 0, 0)
				label:FontTemplate(E.media.normFont, 14, "OUTLINE")
			end
			progressBar.hasShadow = true
		end
	end

	local function ItemButtonShadows(self, block)
		local item = block.itemButton
		if item and not item.shadow then
			item:CreateShadow()
		end
	end

	local function FindGroupButtonShadows(block)
		if block.hasGroupFinderButton and block.groupFinderButton then
			if block.groupFinderButton and not block.groupFinderButton.hasShadow then
				block.groupFinderButton:SetTemplate("Transparent")
				block.groupFinderButton:CreateShadow()
				block.groupFinderButton.hasShadow = true
			end
		end
	end

	hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE,"AddProgressBar", ProgressBarsShadows)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE,"AddProgressBar", ProgressBarsShadows)
	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE,"AddProgressBar", ProgressBarsShadows)
	hooksecurefunc(SCENARIO_TRACKER_MODULE,"AddProgressBar", ProgressBarsShadows)
	hooksecurefunc(QUEST_TRACKER_MODULE,"SetBlockHeader", ItemButtonShadows)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE,"AddObjective", ItemButtonShadows)
	hooksecurefunc("QuestObjectiveSetupBlockButton_FindGroup", FindGroupButtonShadows)
end

local function shadow_alerts()
	local function create_alert_shadow(alert)
		if not alert then return end
		if alert.backdrop then alert.backdrop:CreateShadow() end
		if alert.Label and alert.Icon then
			alert.Label:ClearAllPoints()
			alert.Label:SetPoint("TOPLEFT", alert.Icon, "TOPRIGHT", 5, 2)
		end
		if alert.Icon and alert.Icon.b then alert.Icon.b:CreateShadow() end
		if alert.SpecIcon then alert.SpecIcon.b:CreateShadow() end
	end

	-- 成就
	hooksecurefunc(_G.AchievementAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.CriteriaAlertSystem, "setUpFunction", create_alert_shadow)

	-- 遭遇
	hooksecurefunc(_G.DungeonCompletionAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.GuildChallengeAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.InvasionAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.ScenarioAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.WorldQuestCompleteAlertSystem, "setUpFunction", create_alert_shadow)

	-- 要塞
	hooksecurefunc(_G.GarrisonFollowerAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.GarrisonShipFollowerAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.GarrisonTalentAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.GarrisonBuildingAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.GarrisonMissionAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.GarrisonShipMissionAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.GarrisonRandomMissionAlertSystem, "setUpFunction", create_alert_shadow)

	-- 荣誉
	hooksecurefunc(_G.HonorAwardedAlertSystem, "setUpFunction", create_alert_shadow)

	-- 拾取
	hooksecurefunc(_G.LegendaryItemAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.LootAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.LootUpgradeAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.MoneyWonAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.StorePurchaseAlertSystem, "setUpFunction", create_alert_shadow)
	
	-- 专业技能
	hooksecurefunc(_G.DigsiteCompleteAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.NewRecipeLearnedAlertSystem, "setUpFunction", create_alert_shadow)

	-- 宠物 / 坐骑
	hooksecurefunc(_G.NewPetAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.NewMountAlertSystem, "setUpFunction", create_alert_shadow)
	hooksecurefunc(_G.NewToyAlertSystem, "setUpFunction", create_alert_shadow)
end

function WS:ADDON_LOADED(_, addon)
	if not self.db.elvui.general then return end

	if self.lazy_load_list[addon] then
		for _, frame in pairs(self.lazy_load_list[addon]) do
			if _G[frame] then _G[frame]:CreateShadow(4) end
		end
	end

	-- 公会页面标签页
	if addon == "Blizzard_Communities" and _G.CommunitiesFrame then
		local frame = _G.CommunitiesFrame
		frame.ChatTab:CreateShadow()
		frame.RosterTab:CreateShadow()
		frame.GuildBenefitsTab:CreateShadow()
		frame.GuildInfoTab:CreateShadow()
		frame.GuildMemberDetailFrame:CreateShadow()
		frame.GuildMemberDetailFrame:ClearAllPoints()
		frame.GuildMemberDetailFrame:SetPoint("TOPLEFT", frame, "TOPRIGHT", 5, -76)
		if _G.CommunitiesGuildLogFrame then _G.CommunitiesGuildLogFrame:CreateShadow() end
	end

	-- 職業大廳條
	if addon == "Blizzard_GarrisonUI" and _G.OrderHallCommandBar then
		_G.OrderHallCommandBar.AreaName:FontTemplate(nil, nil, "OUTLINE")
		_G.OrderHallCommandBar.AreaName:ClearAllPoints()
		_G.OrderHallCommandBar.AreaName:SetPoint("CENTER", 0, 0)
	end
end

function WS:ShadowGeneralFrames()
	if not self.db.elvui.general then return end

	for frame, noBackdrop in pairs(self.blizzard_frames) do
		if noBackdrop then
			if _G[frame] then _G[frame]:CreateShadow() end
		else
			if _G[frame] and _G[frame].backdrop then _G[frame].backdrop:CreateShadow() end
		end
	end

	-- 商人界面
	if _G.MerchantFrame then
		_G.MerchantFrame.backdrop:CreateShadow()
		_G.MerchantFrameTab1.backdrop:CreateShadow(2)
		_G.MerchantFrameTab2.backdrop:CreateShadow(2)
	end


	-- 暴雪通知
	for i=1,4 do
		local alert = _G["StaticPopup"..i]
		if alert then alert:CreateShadow() end
	end

	-- 人物面板标签页
	for i=1,4 do
		local tab = _G["CharacterFrameTab"..i]
		if tab and tab.backdrop then tab.backdrop:CreateShadow(2) end
	end

	-- 好友面板标签页
	for i=1,3 do
		local tab = _G["FriendsFrameTab"..i]
		if tab and tab.backdrop then tab.backdrop:CreateShadow(2) end
	end

	-- 地城团队标签页
	for i=1,3 do
		local tab = _G["PVEFrameTab"..i]
		if tab and tab.backdrop then tab.backdrop:CreateShadow(2) end
	end

	-- 法术书标签页
	for i=1,3 do
		local tab = _G["SpellBookFrameTabButton"..i]
		if tab and tab.backdrop then tab.backdrop:CreateShadow(2) end
	end

	-- 法术书侧栏
	for i=1,8 do
		local tab = _G["SpellBookSkillLineTab"..i]
		if tab then tab:CreateShadow(2) end
	end

	-- 镜像时间条 呼吸条
	for i = 1, MIRRORTIMER_NUMTIMERS do
		local statusBar = _G['MirrorTimer'..i..'StatusBar']
		if statusBar.backdrop then statusBar.backdrop:CreateShadow() end
	end

	-- 任务追踪
	shadow_objective_tracker()
end

function WS:ShadowElvUIFrames()
	if not self.db then return end

	if self.db.elvui.general then
		-- 为 ElvUI 美化皮肤模块添加阴影功能
		hooksecurefunc(S, "HandleTab", function(_, tab) if tab and tab.backdrop then tab.backdrop:CreateShadow(2) end end)
		hooksecurefunc(S, "HandlePortraitFrame", function(_, f) if f and f.backdrop then f.backdrop:CreateShadow() end end)
		if _G.ElvUIVendorGraysFrame then _G.ElvUIVendorGraysFrame:CreateShadow() end
		-- 提醒
		shadow_alerts()
	end

	-- 光环条
	if self.db.elvui.auras then
		hooksecurefunc(A, "CreateIcon", function(_, button) if button then button:CreateShadow() end end)
		hooksecurefunc(A, "UpdateAura", function(_, button) if button then button:CreateShadow() end end)
	end

	-- 单位框体
	if self.db.elvui.unitframes then
		-- 低频度更新单位框体外围阴影
		hooksecurefunc(UF, "UpdateNameSettings", function(_, frame) if frame then frame:CreateShadow() end end)
		-- 在 oUF 更新仇恨值阴影时判断是否隐藏美化阴影
		hooksecurefunc(UF, "Configure_Threat", function(_, frame)
			local threat = frame.ThreatIndicator
			if not threat then return end
			threat.PostUpdate = function(self, unit, status, r, g, b)
				UF.UpdateThreat(self, unit, status, r, g, b)
				local parent = self:GetParent()
				if (parent.unit ~= unit) or not unit then return end
				local db = parent.db
				if not db then return end
				if db.threatStyle == 'GLOW' and parent.shadow then parent.shadow:SetShown(not threat.glow:IsShown()) end
			end
		end)
		-- 为分离的能量条提供阴影
		hooksecurefunc(UF, "Configure_Power", function(_, frame)
			if frame.USE_POWERBAR and frame.POWERBAR_DETACHED then 
				frame.Power:CreateShadow()
			end
		end)
		-- 为单位框体光环提供边缘美化
		hooksecurefunc(UF, "UpdateAuraSettings", function(_, _, button) if button then button:CreateShadow() end end)
	end

	-- 职业条
	if self.db.elvui.classbar then
		hooksecurefunc(UF, "Configure_ClassBar", function(_, frame)
			local bars = frame[frame.ClassBar]
			if bars then bars:CreateShadow() end
		end)
	end

	-- 施法条
	if self.db.elvui.castbar then
		hooksecurefunc(UF, "Configure_Castbar", function(_, frame)
			frame.Castbar:CreateShadow()
			if not frame.db.castbar.iconAttached then
				frame.Castbar.ButtonIcon.bg:CreateShadow()
			end
		end)
	end

	-- 鼠标提示
	if self.db.elvui.tooltips then
		hooksecurefunc(TT, "SetStyle", function(_, tt) if tt then tt:CreateShadow(4) end end)
		hooksecurefunc(TT, "GameTooltip_SetDefaultAnchor", function(_, tt)
			if tt:IsForbidden() or E.private.tooltip.enable ~= true then return end
			if _G.GameTooltipStatusBar then _G.GameTooltipStatusBar:CreateShadow(4) end
		end)
	end

	-- 数据条
	if self.db.elvui.databars then
		if DATABAR.db.azerite.enable then _G.ElvUI_AzeriteBar:CreateShadow() end
		if DATABAR.db.experience.enable then _G.ElvUI_ExperienceBar:CreateShadow() end
		if DATABAR.db.reputation.enable then _G.ElvUI_ReputationBar:CreateShadow() end
		if DATABAR.db.honor.enable then _G.ElvUI_HonorBar:CreateShadow() end
	end

	-- 动作条
	if self.db.elvui.actionbars then
		-- 常规动作条
		local actionbar_list = {
			"ElvUI_Bar1Button",
			"ElvUI_Bar2Button",
			"ElvUI_Bar3Button",
			"ElvUI_Bar4Button",
			"ElvUI_Bar5Button",
			"ElvUI_Bar6Button",
			"ElvUI_StanceBarButton",
			"ElvUI_TotemBarTotem",
			"PetActionButton",
		}
		for _, item in pairs(actionbar_list) do
			for i = 1, 12 do
				local button = _G[item..i]
				if button and button.backdrop then button.backdrop:CreateShadow() end
			end
		end

		-- 非常规动作条
		if _G.ZoneAbilityFrame and _G.ZoneAbilityFrame.SpellButton then
			-- 区域技能
			_G.ZoneAbilityFrame.SpellButton:CreateShadow()
			-- 特殊技能栏 1 好像也没遇到需要用到 2 的，先放着吧
			_G.ExtraActionButton1:CreateShadow()
		end

		hooksecurefunc(AB, "StyleButton", function(_, button)
			button.backdrop:CreateShadow()
		end)

	end

	-- 额外能量条
	if self.db.elvui.altpowerbar then
		if not _G.ElvUI_AltPowerBar then return end
		_G.ElvUI_AltPowerBar.backdrop:CreateShadow()
		_G.ElvUI_AltPowerBar.text:ClearAllPoints()
		_G.ElvUI_AltPowerBar.text:SetPoint("CENTER", 0, -1)
	end

	-- 上下条
	if self.db.elvui.top_and_bottom_panel then
		if _G.ElvUI_TopPanel then _G.ElvUI_TopPanel:CreateShadow() end
		if _G.ElvUI_BottomPanel then _G.ElvUI_BottomPanel:CreateShadow() end
	end

	-- 聊天面板
	if self.db.elvui.chat_panel then
		if _G.LeftChatPanel then _G.LeftChatPanel:CreateShadow() end
		if _G.RightChatPanel then _G.RightChatPanel:CreateShadow() end
	end
end

function WS:CustomSkins()
	-- 输入法候选框
	if _G.IMECandidatesFrame then
		local frame = _G.IMECandidatesFrame
		local db = self.db.ime
		if db.no_backdrop then S:HandlePortraitFrame(frame) end
		for i=1,10 do
			if frame["c"..i] then
				frame["c"..i].label:FontTemplate(LSM:Fetch('font', db.label.font), db.label.size, db.label.style)
				frame["c"..i].candidate:FontTemplate(LSM:Fetch('font', db.candidate.font), db.candidate.size, db.candidate.style)
				frame["c"..i].candidate:SetWidth(db.width)
			end
		end
	end

	-- 错误提示
	if _G.UIErrorsFrame and self.db.ui_errors.enabled then
		local db = self.db.ui_errors
		_G.UIErrorsFrame:FontTemplate(LSM:Fetch('font', db.font), db.size, "OUTLINE")
	end
end

function WS:AddOnSkins()
	-- 用 AddOnSkins 美化的窗体标签页
	AS = unpack(AddOnSkins)

	if self.db.addonskins.general then
		hooksecurefunc(AS, "SkinTab", function() if tab and tab.backdrop then tab.backdrop:CreateShadow() end end)
	end
	
	-- Weakaura
	if self.db.addonskins.weakaura and AS:CheckAddOn('WeakAuras') then
		AS:RegisterSkin('WeakAuras', shadow_weakauras, 'ADDON_LOADED')
	end

	-- Bigwigs
	if self.db.addonskins.bigwigs and AS:CheckAddOn('BigWigs') then
		AS:RegisterSkin('BigWigs', shadow_bigwigs, 'ADDON_LOADED')
		AS:RegisterSkinForPreload('BigWigs_Plugins', shadow_bigwigs)
	end
end

function WS:Initialize()
	self.db = E.db.WindTools.Interface.Skins
	if not self.db.enabled then return end
	self:ShadowElvUIFrames()
	self:ShadowGeneralFrames()
	self:CustomSkins()
	if IsAddOnLoaded("AddOnSkins") then
		self:AddOnSkins()
	end
	self:RegisterEvent('ADDON_LOADED')
end

local function InitializeCallback()
	WS:Initialize()
end

E:RegisterModule(WS:GetName(), InitializeCallback)