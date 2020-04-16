-- 皮肤增强
-- 作者：houshuu
-- AddonSkins, 任务追踪, 部分 ElvUI 组件美化修改自 BenikUI
local _G = _G
local unpack = unpack
local hooksecurefunc = hooksecurefunc
local _
local find = string.find

local E, L, V, P, G = unpack(ElvUI); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local WT = E:GetModule("WindTools")
local A = E:GetModule('Auras')
local S = E:GetModule('Skins')
local AB = E:GetModule('ActionBars')
local UF = E:GetModule('UnitFrames')
local TT = E:GetModule('Tooltip')
local DATABAR = E:GetModule('DataBars')
local AFK = E:GetModule('AFK')
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
    ["left_chat_panel"] = L["Left chat panel"],
    ["right_chat_panel"] = L["Right chat panel"],
    ["editbox"] = L["Edit box"],
    ["lang_icon"] = L["Language indicator"],
    ["losscontrol"] = L["Loss of control"],
    ["character_frame"] = CHARACTER_INFO,
    ["scenario_background"] = L["Scenario stage background"]
}

WS.addonskins_list = {
    ["general"] = L["General"],
    ["weakaura"] = L["Weakauras2"],
    ["bigwigs"] = L["Bigwigs"],
    ["immersion"] = L["Immersion"]
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
    ["FriendsTooltip"] = true,
    ["RaidInfoFrame"] = true,
    ["RecruitAFriendRewardsFrame"] = true,
    ["RecruitAFriendRecruitmentFrame"] = true,
    ["PVEFrame"] = true,
    ["LFGDungeonReadyDialog"] = true,
    ["LFGDungeonReadyStatus"] = true,
    ["SpellBookFrame"] = true,
    ["BNToastFrame"] = true,
    ["MailFrame"] = true,
    ["OpenMailFrame"] = true,
    ["ReadyCheckFrame"] = true,
    ["IMECandidatesFrame"] = true,
    ["RaidUtility_ShowButton"] = true,
    ["RaidUtility_CloseButton"] = true,
    ["RaidUtilityRoleIcons"] = true,
    ["RaidUtilityPanel"] = true,
    ["WorldMapFrame"] = false,
    ["LeaveVehicleButton"] = true,
    ["GhostFrameContentsFrame"] = true,
    ["ReputationDetailFrame"] = true,
    ["CinematicFrameCloseDialog"] = true,
    ["TaxiFrame"] = true,
    ["DressUpFrame"] = true,
    ["MainMenuBarVehicleLeaveButton"] = true,
    ["ItemTextFrame"] = true
}

WS.lazy_load_list = {
    ["Blizzard_GarrisonUI"] = {
        "GarrisonLandingPage",
        "GarrisonMissionFrame",
        "GarrisonShipyardFrame",
        "OrderHallMissionFrame",
        "BFAMissionFrame",
        "OrderHallCommandBar"
    },
    ["Blizzard_BindingUI"] = {"KeyBindingFrame"},
    ["Blizzard_ChallengesUI"] = {"ChallengesKeystoneFrame"},
    ["Blizzard_Calendar"] = {"CalendarFrame", "CalendarViewHolidayFrame"},
    ["Blizzard_AuctionHouseUI"] = {"AuctionHouseFrame"},
    ["Blizzard_WarboardUI"] = {"WarboardQuestChoiceFrame"},
    ["Blizzard_BarbershopUI"] = {"BarberShopFrame"},
    ["Blizzard_MacroUI"] = {"MacroPopupFrame"},
    ["Blizzard_TalentUI"] = {"PlayerTalentFrameTalentsPvpTalentFrameTalentList"}
}

function WS:SkinFont(font, size, style)
    local oldSize = select(2, font:GetFont())
    local newSize = size or oldSize
    local newStyle = style or "OUTLINE"
    font:FontTemplate(E.media.normFont, newSize, newStyle)
    font:SetShadowColor(0, 0, 0, 0)
    font.SetShadowColor = E.noop
end

local function shadow_immersion(self, event, addon)

    if ImmersionFrame.TalkBox.TextFrame.SpeechProgress and
        not ImmersionFrame.TalkBox.TextFrame.SpeechProgress.hasWindSkin then
        ImmersionFrame.TalkBox.TextFrame.SpeechProgress:FontTemplate()
        ImmersionFrame.TalkBox.TextFrame.SpeechProgress.hasWindSkin = true
    end

    if ImmersionFrame.hasWindSkin then return end
    ImmersionFrame.TalkBox.BackgroundFrame:StripTextures()
    ImmersionFrame.TalkBox.BackgroundFrame:CreateBackdrop('Transparent')

    ImmersionFrame.TalkBox.BackgroundFrame.backdrop:SetPoint('TOPLEFT', ImmersionFrame.TalkBox.BackgroundFrame,
                                                             'TOPLEFT', 11, -12)
    ImmersionFrame.TalkBox.BackgroundFrame.backdrop:SetPoint('BOTTOMRIGHT', ImmersionFrame.TalkBox.BackgroundFrame,
                                                             'BOTTOMRIGHT', -11, 9)
    ImmersionFrame.TalkBox.BackgroundFrame.backdrop:CreateShadow()

    ImmersionFrame.TalkBox.PortraitFrame:StripTextures()

    if not ImmersionFrame.TalkBox.MainFrame.CloseButton.windSkin then
        S:HandleCloseButton(ImmersionFrame.TalkBox.MainFrame.CloseButton)
        ImmersionFrame.TalkBox.MainFrame.CloseButton.windSkin = true
    end

    ImmersionFrame.TalkBox.Hilite:SetTemplate()
    ImmersionFrame.TalkBox.Hilite:SetBackdropBorderColor(0, 0.44, .87, 1)
    ImmersionFrame.TalkBox.Hilite:SetBackdropColor(0, 0, 0, 0)
    ImmersionFrame.TalkBox.Hilite:SetPoint('TOPLEFT', ImmersionFrame.TalkBox.BackgroundFrame, 'TOPLEFT', 11, -12)
    ImmersionFrame.TalkBox.Hilite:SetPoint('BOTTOMRIGHT', ImmersionFrame.TalkBox.BackgroundFrame, 'BOTTOMRIGHT', -11, 9)

    ImmersionFrame.TalkBox.MainFrame.Model.ModelShadow:SetDrawLayer("OVERLAY", 7)
    ImmersionFrame.TalkBox.MainFrame.Model.ModelShadow:SetPoint("BOTTOMRIGHT", 2, -2)
    ImmersionFrame.TalkBox.MainFrame.Model.ModelShadow:SetAlpha(.8)
    ImmersionFrame.TalkBox.MainFrame.Model.PortraitBG:Hide()

    ImmersionFrame.TalkBox.NameFrame.Name:FontTemplate(E.media.normFont, 20, "OUTLINE")
    ImmersionFrame.TalkBox.NameFrame.Name:SetShadowColor(0, 0, 0, 0)
    ImmersionFrame.TalkBox.NameFrame.Name.SetShadowColor = E.noop

    ImmersionFrame.TalkBox.TextFrame.Text:FontTemplate(E.media.normFont, 16, "OUTLINE")
    ImmersionFrame.TalkBox.TextFrame.Text:SetShadowColor(0, 0, 0, 0)
    ImmersionFrame.TalkBox.TextFrame.Text.SetShadowColor = E.noop

    ImmersionFrame.TalkBox.Elements:StripTextures()
    ImmersionFrame.TalkBox.Elements:CreateBackdrop('Transparent')
    ImmersionFrame.TalkBox.Elements.backdrop:SetPoint('TOPLEFT', ImmersionFrame.TalkBox.Elements, 'TOPLEFT', 16, -16)
    ImmersionFrame.TalkBox.Elements.backdrop:SetPoint('BOTTOMRIGHT', ImmersionFrame.TalkBox.Elements, 'BOTTOMRIGHT',
                                                      -16, 16)
    ImmersionFrame.TalkBox.Elements.backdrop:CreateShadow()

    ImmersionFrame.TalkBox.MainFrame.Overlay:Kill()

    S:HandleStatusBar(ImmersionFrame.TalkBox.ReputationBar)
    ImmersionFrame.TalkBox.ReputationBar:ClearAllPoints()
    ImmersionFrame.TalkBox.ReputationBar:SetPoint('TOPLEFT', ImmersionFrame.TalkBox, 'BOTTOMLEFT', -20, 10)
    ImmersionFrame.TalkBox.ReputationBar.icon:SetAlpha(0)

    ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ItemHighlight.Icon:Hide();
    ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ItemHighlight.Icon.Show = function() end;

    ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ItemHighlight.NameTag:Hide();
    ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ItemHighlight.NameTag.Show = function() end;

    ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ItemHighlight.TextSheen:Hide();
    ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ItemHighlight.TextSheen.Show = function() end;

    -- 需求物品
    WS:SkinFont(ImmersionFrame.TalkBox.Elements.Progress.ReqText)
    -- 任务奖励
    WS:SkinFont(ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.Header, 16)
    WS:SkinFont(ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ItemReceiveText, 14)
    WS:SkinFont(ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.XPFrame.ReceiveText, 14)
    WS:SkinFont(ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.XPFrame.ValueText, 14)
    -- 任务目标
    WS:SkinFont(ImmersionFrame.TalkBox.Elements.Content.ObjectivesHeader, 16)
    WS:SkinFont(ImmersionFrame.TalkBox.Elements.Content.ObjectivesText, 14)

    if ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.MoneyFrame then
        local buttons = {ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.MoneyFrame:GetChildren()}
        for _, v in pairs(buttons) do WS:SkinFont(v.Text, 14) end
    end

    local function SkinReward(Button)
        if Button.Icon then
            Button:CreateBackdrop('Transparent')

            if Button.NameFrame then Button.NameFrame:Hide() end

            if Button.Border then Button.Border:Hide() end

            if Button.Mask then Button.Mask:Hide() end

            Button.backdrop:SetPoint('TOPLEFT', Button.Icon, 'TOPRIGHT', 0, 0)
            Button.backdrop:SetPoint('BOTTOMLEFT', Button.Icon, 'BOTTOMRIGHT', 0, 0)
            Button.backdrop:SetPoint('RIGHT', Button, 'RIGHT', -5, 0)

            S:HandleIcon(Button.Icon)
            Button.Icon:CreateBackdrop()
            Button.Icon.backdrop:SetBackdropColor(0, 0, 0, 0)
            Button.Icon.backdrop:SetOutside(Button.Icon)

            Button.Name:FontTemplate(E.media.normFont, 14, "OUTLINE")
            Button.Name:SetShadowColor(0, 0, 0, 0)
            Button.Name.SetShadowColor = E.noop

            Button.AutoCastShine = CreateFrame('Frame', '$parentShine', Button, 'AutoCastShineTemplate')
            Button.AutoCastShine:SetParent(Button.Icon.backdrop)
            Button.AutoCastShine:SetAllPoints()

            for _, sparks in pairs(Button.AutoCastShine.sparkles) do
                sparks:SetSize(sparks:GetWidth() * 2, sparks:GetHeight() * 2)
            end

            Button:SetScript("OnUpdate", function(self)
                if ImmersionFrame.TalkBox.Elements.chooseItems and ImmersionFrame.TalkBox.Elements.itemChoice ==
                    self:GetID() then
                    AutoCastShine_AutoCastStart(self.AutoCastShine, 0, .44, .87)
                    self.backdrop:SetBackdropBorderColor(0, 0.44, .87, 1)
                else
                    self.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
                    AutoCastShine_AutoCastStop(self.AutoCastShine)
                end
            end)
        end

        if Button.CircleBackground then
            Button.CircleBackground:SetTexture()
            Button.CircleBackgroundGlow:SetTexture()
            hooksecurefunc(Button.ValueText, "SetText", function(self, text)
                Button.Count:SetText('+' .. text)
                self:Hide()
            end)
        end
    end

    SkinReward(ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ArtifactXPFrame)
    SkinReward(ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.HonorFrame)
    SkinReward(ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.MoneyFrame)
    SkinReward(ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.TitleFrame)
    SkinReward(ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.SkillPointFrame)

    ImmersionFrame:HookScript('OnEvent', function(self)
        for _, Button in ipairs(self.TitleButtons.Buttons) do
            if Button and not Button.backdrop then
                for _, region in pairs({Button:GetRegions()}) do
                    if region:GetObjectType() == "Texture" then
                        if not (region:GetName() and find(region:GetName(), "Icon")) then
                            region:StripTextures()
                        end
                    end
                end
                Button:CreateBackdrop('Transparent')
                Button.Overlay:Kill()
                Button.backdrop:CreateShadow()
                Button.backdrop:SetInside(Button, 4, 4)
                Button.Hilite:SetTemplate()
                Button.Hilite:SetBackdropBorderColor(0, 0.44, .87, 1)
                Button.Hilite:SetBackdropColor(0, 0, 0, 0)
                Button.Hilite:SetAllPoints(Button.backdrop)
                Button:SetHighlightTexture('')
                WS:SkinFont(Button.Label)
            end
        end
        for _, Button in ipairs(self.TalkBox.Elements.Content.RewardsFrame.Buttons) do
            if Button and not Button.backdrop then SkinReward(Button) end
        end
        for _, Button in ipairs(self.TalkBox.Elements.Progress.Buttons) do
            if Button and not Button.backdrop then
                Button:StripTextures()
                Button:CreateBackdrop('Transparent')
                S:HandleIcon(Button.Icon)
                Button.NameFrame:Hide()
                Button.Border:Hide()
                Button.Mask:Hide()

                Button.backdrop:SetPoint('TOPLEFT', Button.Icon, 'TOPRIGHT', 0, 0)
                Button.backdrop:SetPoint('BOTTOMLEFT', Button.Icon, 'BOTTOMRIGHT', 0, 0)
                Button.backdrop:SetPoint('RIGHT', Button, 'RIGHT', -5, 0)
            end
        end
    end)
    ImmersionFrame.hasWindSkin = true
end

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
            GetStyleName = function() return 'AddOnSkins' end
        })
        BigWigsBars:RegisterBarStyle('AddOnSkins Half-Bar', {
            apiVersion = 1,
            version = 1,
            GetSpacing = function() return 13 end,
            ApplyStyle = function(bar) ApplyStyleHalfBar(bar, FreeBackgrounds, buttonsize) end,
            BarStopped = function(bar) FreeStyle(bar, FreeBackgrounds) end,
            GetStyleName = function() return 'AddOnSkins Half-Bar' end
        })

        AS:UnregisterSkinEvent('BigWigs', event)
    end
end

local function shadow_weakauras()
    local function Skin_WeakAuras(frame) if not frame.shadow then frame:CreateShadow(2) end end

    local regionTypes = WeakAuras.regionTypes
    local Create_Icon, Modify_Icon = regionTypes.icon.create, regionTypes.icon.modify
    local Create_AuraBar, Modify_AuraBar = regionTypes.aurabar.create, regionTypes.aurabar.modify

    regionTypes.icon.create = function(parent, data)
        local region = Create_Icon(parent, data)
        Skin_WeakAuras(region)
        return region
    end

    regionTypes.aurabar.create = function(parent)
        local region = Create_AuraBar(parent)
        Skin_WeakAuras(region)
        return region
    end

    regionTypes.icon.modify = function(parent, region, data)
        Modify_Icon(parent, region, data)
        Skin_WeakAuras(region)
    end

    regionTypes.aurabar.modify = function(parent, region, data)
        Modify_AuraBar(parent, region, data)
        Skin_WeakAuras(region)
    end

    for weakAura in pairs(WeakAuras.regions) do
        local regions = WeakAuras.regions[weakAura]
        if regions.regionType == 'icon' or regions.regionType == 'aurabar' then Skin_WeakAuras(regions.region) end
    end
end

local function shadow_objective_tracker()
    -- 修改自 BenikUI

    -- 收起按钮
    ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:CreateShadow(5)
    ObjectiveTrackerFrame.HeaderMenu.MinimizeButton.shadow:SetOutside()

    local function ProgressBarsShadows(_, _, line)
        local progressBar = line and line.ProgressBar
        local bar = progressBar and progressBar.Bar
        if not bar then return end
        local icon = bar.Icon
        local label = bar.Label

        if not progressBar.hasShadow then
            if not bar.backdrop then
                bar:CreateShadow()
            else
                bar.backdrop:CreateShadow()
            end

            if progressBar.backdrop then
                progressBar.backdrop:SetTemplate('Transparent')
                progressBar.backdrop:CreateShadow()
            end

            -- 稍微移动下图标位置，防止阴影重叠，更加美观！
            if icon then icon:Point("LEFT", bar, "RIGHT", E.PixelMode and 7 or 11, 0) end
            -- 顺便修正一下字体位置，反正不知道为什么 ElvUI 要往上移动一个像素
            if label then
                label:ClearAllPoints()
                label:Point("CENTER", bar, 0, 0)
                label:FontTemplate(E.media.normFont, 13, "OUTLINE")
            end
            progressBar.hasShadow = true
        end
    end

    local function ItemButtonShadows(self, block)
        local item = block.itemButton
        if item and not item.shadow then item:CreateShadow() end
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

    hooksecurefunc(_G.BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", ProgressBarsShadows)
    hooksecurefunc(_G.WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", ProgressBarsShadows)
    hooksecurefunc(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", ProgressBarsShadows)
    hooksecurefunc(_G.SCENARIO_TRACKER_MODULE, "AddProgressBar", ProgressBarsShadows)
    hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", ItemButtonShadows)
    hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", ItemButtonShadows)
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
        if alert.Icon and alert.Icon.Texture and alert.Icon.Texture.b then
            alert.Icon.Texture.b:Point("TOPLEFT", alert.Icon.Texture, "TOPLEFT", -1, 1)
            alert.Icon.Texture.b:Point("BOTTOMRIGHT", alert.Icon.Texture, "BOTTOMRIGHT", 1, -1)
            alert.Icon.Texture.b:CreateShadow(5)
        end
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

    -- 专业技能
    hooksecurefunc(_G.DigsiteCompleteAlertSystem, "setUpFunction", create_alert_shadow)
    hooksecurefunc(_G.NewRecipeLearnedAlertSystem, "setUpFunction", create_alert_shadow)

    -- 宠物 / 坐骑
    hooksecurefunc(_G.NewPetAlertSystem, "setUpFunction", create_alert_shadow)
    hooksecurefunc(_G.NewMountAlertSystem, "setUpFunction", create_alert_shadow)
    hooksecurefunc(_G.NewToyAlertSystem, "setUpFunction", create_alert_shadow)

    -- 其它
    hooksecurefunc(_G.EntitlementDeliveredAlertSystem, "setUpFunction", create_alert_shadow)
    hooksecurefunc(_G.RafRewardDeliveredAlertSystem, "setUpFunction", create_alert_shadow)
end

local function CreateTabShadow(tab)
    if not tab then return end
    if tab and tab.backdrop and not tab.hasWindSkin then
        tab:StripTextures()
        tab:CreateBackdrop('Transparent')
        tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -1 or -3)
        tab.backdrop:Point("BOTTOMRIGHT", -10, 3)
        tab.backdrop:CreateShadow(2)
        tab.hasWindSkin = true
    else
        tab:CreateShadow(2)
    end
end

function WS:ADDON_LOADED(_, addon)
    if not self.db.elvui.general then return end

    if self.lazy_load_list[addon] then
        for _, frame in pairs(self.lazy_load_list[addon]) do if _G[frame] then _G[frame]:CreateShadow(4) end end
    end

    -- 离开界面
    AFK.AFKMode.bottom:CreateShadow(10)

    AFK.AFKMode.bottom.logo:Size(512, 128)
    AFK.AFKMode.bottom.logo:SetTexture("Interface\\Addons\\ElvUI_WindTools\\Texture\\WindTools.blp")

    -- 离开界面字体位置美观性调整
    AFK.AFKMode.bottom.logo:ClearAllPoints()
    AFK.AFKMode.bottom.logo:Point("CENTER", AFK.AFKMode.bottom, "CENTER", 0, 25)

    AFK.AFKMode.bottom.guild:ClearAllPoints()
    AFK.AFKMode.bottom.guild:Point("TOPLEFT", AFK.AFKMode.bottom.name, "BOTTOMLEFT", 0, -11)

    AFK.AFKMode.bottom.time:ClearAllPoints()
    AFK.AFKMode.bottom.time:Point("TOPLEFT", AFK.AFKMode.bottom.guild, "BOTTOMLEFT", 0, -11)

    -- 特写框架
    if E.private.skins.blizzard.enable and E.private.skins.blizzard.talkinghead and addon == "Blizzard_TalkingHeadUI" then
        local f = _G.TalkingHeadFrame
        if f then
            f:CreateShadow(6)
            WS:SkinFont(f.NameFrame.Name)
            WS:SkinFont(f.TextFrame.Text)
        end
    end

    -- 公会
    if addon == "Blizzard_Communities" then
        if _G.CommunitiesFrame then
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

        -- 搜寻社群
        if _G.ClubFinderCommunityAndGuildFinderFrame then
            local frame = _G.ClubFinderCommunityAndGuildFinderFrame
            if frame.ClubFinderPendingTab then frame.ClubFinderPendingTab:CreateShadow() end
            if frame.ClubFinderSearchTab then frame.ClubFinderSearchTab:CreateShadow() end
            if frame.RequestToJoinFrame then frame.RequestToJoinFrame:CreateShadow() end
        end

        -- 搜寻公会
        if _G.ClubFinderGuildFinderFrame then
            local frame = _G.ClubFinderGuildFinderFrame
            if frame.ClubFinderPendingTab then frame.ClubFinderPendingTab:CreateShadow() end
            if frame.ClubFinderSearchTab then frame.ClubFinderSearchTab:CreateShadow() end
            if frame.RequestToJoinFrame then frame.RequestToJoinFrame:CreateShadow() end
        end
    end

    -- 冒险指南标签页
    if addon == "Blizzard_EncounterJournal" then
        local frames = {
            "EncounterJournalEncounterFrameInfoOverviewTab",
            "EncounterJournalEncounterFrameInfoLootTab",
            "EncounterJournalEncounterFrameInfoBossTab",
            "EncounterJournalEncounterFrameInfoModelTab"
        }

        for _, frame in pairs(frames) do
            if _G[frame] and _G[frame].backdrop then
                _G[frame].backdrop:SetTemplate('Transparent')
                _G[frame].backdrop:CreateShadow(2)
            end
        end
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
            if frame.Border then
                if _G[frame] and _G[frame].Border then _G[frame].backdrop:CreateShadow(4) end
            else
                if _G[frame] then _G[frame]:CreateShadow() end
            end
        else
            if _G[frame] and _G[frame].backdrop then _G[frame].backdrop:CreateShadow(4) end
        end
    end

    -- 商人界面
    if _G.MerchantFrame then
        _G.MerchantFrame.backdrop:CreateShadow()
        _G.MerchantFrameTab1.backdrop:CreateShadow(2)
        _G.MerchantFrameTab2.backdrop:CreateShadow(2)
    end

    -- 暴雪通知
    for i = 1, 4 do
        local alert = _G["StaticPopup" .. i]
        if alert then alert:CreateShadow() end
    end

    -- 人物面板标签页
    for i = 1, 4 do CreateTabShadow(_G["CharacterFrameTab" .. i]) end

    -- 好友面板标签页
    for i = 1, 4 do CreateTabShadow(_G["FriendsFrameTab" .. i]) end

    -- 地城团队标签页
    for i = 1, 3 do CreateTabShadow(_G["PVEFrameTab" .. i]) end

    -- 天赋标签页
    for i = 1, 3 do CreateTabShadow(_G["PlayerTalentFrameTab" .. i]) end

    -- 法术书标签页
    for i = 1, 5 do CreateTabShadow(_G["SpellBookFrameTabButton" .. i]) end

    -- 法术书侧栏
    for i = 1, MAX_SKILLLINE_TABS do CreateTabShadow(_G["SpellBookSkillLineTab" .. i]) end

    -- 邮件界面标签页
    for i = 1, 2 do CreateTabShadow(_G["MailFrameTab" .. i]) end

    -- 镜像时间条 呼吸条
    for i = 1, MIRRORTIMER_NUMTIMERS do
        local statusBar = _G['MirrorTimer' .. i .. 'StatusBar']
        if statusBar.backdrop then
            statusBar.backdrop:SetTemplate('Tranparent')
            statusBar.backdrop:CreateShadow()
        end
    end

    -- 任务追踪
    shadow_objective_tracker()
end

function WS:ShadowElvUIFrames()
    if not self.db then return end

    if self.db.elvui.general then
        -- 为 ElvUI 美化皮肤模块添加阴影功能
        hooksecurefunc(S, "HandleTab", function(self, tab) CreateTabShadow(tab) end)
        hooksecurefunc(S, "HandlePortraitFrame",
                       function(self, f) if f and f.backdrop then f.backdrop:CreateShadow() end end)
        if _G.ElvUIVendorGraysFrame then _G.ElvUIVendorGraysFrame:CreateShadow() end

        -- 提醒
        shadow_alerts()

        -- ElvUI 设定
        hooksecurefunc(E, "ToggleOptionsUI", function()
            local frame = E:Config_GetWindow()
            frame:CreateShadow()
        end)

        -- 跳过剧情
        hooksecurefunc('MovieFrame_PlayMovie', function(f) if f.CloseDialog then f.CloseDialog:CreateShadow() end end)

        -- 美化遗漏天赋提示
        if E.global.general.showMissingTalentAlert then
            local TalentMicroButtonAlert = _G.TalentMicroButtonAlert
            if not TalentMicroButtonAlert.shadow then
                -- 防止重复扩大
                TalentMicroButtonAlert:SetWidth(TalentMicroButtonAlert:GetWidth() + 50)
                TalentMicroButtonAlert.Text:SetWidth(TalentMicroButtonAlert.Text:GetWidth() + 50)
            end
            TalentMicroButtonAlert:CreateShadow()
        end

        -- 世界地图任务界面背景
        local QuestScrollFrame = _G.QuestScrollFrame
        if QuestScrollFrame.Background then QuestScrollFrame.Background:Kill() end
        if QuestScrollFrame.DetailFrame and QuestScrollFrame.DetailFrame.backdrop then
            QuestScrollFrame.DetailFrame.backdrop:SetTemplate("Transparent")
        end

        local QuestMapFrame = _G.QuestMapFrame
        if QuestMapFrame.DetailsFrame then
            if QuestMapFrame.DetailsFrame.backdrop then
                QuestMapFrame.DetailsFrame.backdrop:SetTemplate("Transparent")
            end
            if QuestMapFrame.DetailsFrame.RewardsFrame then
                QuestMapFrame.DetailsFrame.RewardsFrame:SetTemplate("Transparent")
            end
        end

        -- 弹出通知
        for i = 1, 3 do
            local f = _G.ElvUI_StaticPopup1
            if f then f:CreateShadow() end
        end
    end

    if self.db.elvui.scenario_background then
        hooksecurefunc("ScenarioStage_CustomizeBlock", function(stageBlock, scenarioType, widgetSetID, textureKitID)
            if widgetSetID then return end
            stageBlock.NormalBG:StripTextures()
            if not stageBlock.backdrop then
                stageBlock:CreateBackdrop('Transparent')
                stageBlock.backdrop:SetPoint("TOPLEFT", stageBlock.NormalBG, "TOPLEFT", 4, -4)
                stageBlock.backdrop:SetPoint("BOTTOMRIGHT", stageBlock.NormalBG, "BOTTOMRIGHT", -4, 4)
                stageBlock.backdrop:CreateShadow()
            end
        end)
    end

    -- 光环条
    if self.db.elvui.auras then
        hooksecurefunc(A, "CreateIcon", function(_, button) if button then button:CreateShadow() end end)
        hooksecurefunc(A, "UpdateAura", function(_, button) if button then button:CreateShadow() end end)
    end

    if self.db.elvui.character_frame then
        local CharacterModelFrame = _G.CharacterModelFrame
        CharacterModelFrame:SetTemplate("Transparent")
        CharacterModelFrame:DisableDrawLayer("BACKGROUND")
        CharacterModelFrame:DisableDrawLayer("BORDER")
        CharacterModelFrame:DisableDrawLayer("OVERLAY")
        if CharacterModelFrame.backdrop then CharacterModelFrame.backdrop:Kill() end
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
                if db.threatStyle == 'GLOW' and parent.shadow then
                    parent.shadow:SetShown(not threat.glow:IsShown())
                end
            end
        end)

        -- 为分离的能量条提供阴影
        hooksecurefunc(UF, "Configure_Power", function(_, frame)
            if frame.USE_POWERBAR and frame.POWERBAR_DETACHED then frame.Power:CreateShadow() end
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
            if not frame.db.castbar.iconAttached then frame.Castbar.ButtonIcon.bg:CreateShadow() end
        end)
    end

    -- 鼠标提示
    if self.db.elvui.tooltips then
        local styleTT = {
            _G.ItemRefTooltip,
            _G.FriendsTooltip,
            _G.WarCampaignTooltip,
            _G.EmbeddedItemTooltip,
            _G.ReputationParagonTooltip,
            -- already have locals
            StoryTooltip,
            GameTooltip
        }

        for _, tt in pairs(styleTT) do
            if not tt or (tt == E.ScanTooltip or tt.IsEmbedded) or tt:IsForbidden() or tt.hasWindSkin then
                return
            end
            tt:CreateShadow(4)
            tt.hasWindSkin = true
        end

        hooksecurefunc(TT, "SetStyle", function(_, tt)
            if (tt.StatusBar) then tt.StatusBar:CreateShadow(4) end
            if not tt or (tt == E.ScanTooltip or tt.IsEmbedded) or tt:IsForbidden() or tt.hasWindSkin then
                return
            end
            tt:CreateShadow(4)
            tt.hasWindSkin = true
        end)
        hooksecurefunc(TT, "GameTooltip_SetDefaultAnchor", function(_, tt)
            if (tt.StatusBar) then tt.StatusBar:CreateShadow(4) end
            if tt:IsForbidden() or E.private.tooltip.enable ~= true or tt.hasWindSkin then return end
            if _G.GameTooltipStatusBar then _G.GameTooltipStatusBar:CreateShadow(4) end
            tt.hasWindSkin = true
        end)
        hooksecurefunc("QueueStatusFrame_Update", function(self)
            if not self.hasWindSkin then
                self:CreateShadow()
                self.hasWindSkin = true
            end
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
            "PetActionButton"
        }
        for _, item in pairs(actionbar_list) do
            for i = 1, 12 do
                local button = _G[item .. i]
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

        hooksecurefunc(AB, "StyleButton",
                       function(_, button) if button.backdrop then button.backdrop:CreateShadow() end end)

        -- 微型系统条
        for i = 1, #MICRO_BUTTONS do
            if _G[MICRO_BUTTONS[i]].backdrop then _G[MICRO_BUTTONS[i]].backdrop:CreateShadow() end
        end
    end

    -- 额外能量条
    if self.db.elvui.altpowerbar then
        local bar = _G.ElvUI_AltPowerBar
        if not bar then return end
        bar.backdrop:SetTemplate('Transparent')
        bar.backdrop:CreateShadow()
        bar.text:ClearAllPoints()
        bar.text:SetPoint("CENTER", 0, -1)
    end

    -- 上下条
    if self.db.elvui.top_and_bottom_panel then
        if _G.ElvUI_TopPanel then _G.ElvUI_TopPanel:CreateShadow() end
        if _G.ElvUI_BottomPanel then _G.ElvUI_BottomPanel:CreateShadow() end
    end

    -- 聊天面板
    if self.db.elvui.left_chat_panel then if _G.LeftChatPanel then _G.LeftChatPanel:CreateShadow() end end
    if self.db.elvui.right_chat_panel then if _G.RightChatPanel then _G.RightChatPanel:CreateShadow() end end

    for i = 1, NUM_CHAT_WINDOWS do
        -- 输入框
        local editBox = _G['ChatFrame' .. i .. 'EditBox']
        -- 输入法语言标识
        local langIcon = _G['ChatFrame' .. i .. 'EditBoxLanguage']
        if editBox and self.db.elvui.editbox then editBox:CreateShadow(5) end

        if editBox and langIcon and self.db.elvui.lang_icon then
            S:HandlePortraitFrame(langIcon)
            langIcon:SetSize(20, 22)
            langIcon:ClearAllPoints()
            langIcon:SetPoint("TOPLEFT", editBox, "TOPRIGHT", 7, 0)
            langIcon:CreateShadow(5)
        end
    end
end

function WS:CustomSkins()
    -- 输入法候选框
    if _G.IMECandidatesFrame then
        local frame = _G.IMECandidatesFrame
        local db = self.db.ime
        if db and db.no_backdrop then S:HandlePortraitFrame(frame) end
        for i = 1, 10 do
            if frame["c" .. i] then
                frame["c" .. i].label:FontTemplate(LSM:Fetch('font', db.label.font), db.label.size, db.label.style)
                frame["c" .. i].candidate:FontTemplate(LSM:Fetch('font', db.candidate.font), db.candidate.size,
                                                       db.candidate.style)
                frame["c" .. i].candidate:SetWidth(db.width)
            end
        end
    end

    -- 错误提示
    if _G.UIErrorsFrame and self.db.ui_errors.enabled then
        local db = self.db.ui_errors
        _G.UIErrorsFrame:FontTemplate(LSM:Fetch('font', db.font), db.size, "OUTLINE")
        _G.ActionStatusText:FontTemplate(LSM:Fetch('font', db.font), db.size, "OUTLINE")
    end

    -- 失去控制
    if self.db.elvui.losscontrol then
        local function changeLocPos(s)
            s.Icon:ClearAllPoints()
            s.Icon:Point("LEFT", s, "LEFT", 0, 0)

            -- 没有框架可以上阴影，自己做个同大小且重叠的
            if not s.WindBG then
                local bg = CreateFrame("Frame", nil, s)
                bg:Size(s.Icon:GetWidth(), s.Icon:GetHeight())
                bg:Point("TOPLEFT", s.Icon, "TOPLEFT", 0, 0)
                bg:CreateShadow(5)
                s.WindBG = bg
            end

            s.AbilityName:ClearAllPoints()
            s.AbilityName:Point("TOPLEFT", s.Icon, "TOPRIGHT", 10, 0)

            -- 时间归位
            s.TimeLeft:ClearAllPoints()
            s.TimeLeft.NumberText:ClearAllPoints()
            s.TimeLeft.NumberText:Point("BOTTOMLEFT", s.Icon, "BOTTOMRIGHT", 10, 0)

            s.TimeLeft.SecondsText:ClearAllPoints()
            s.TimeLeft.SecondsText:Point("TOPLEFT", s.TimeLeft.NumberText, "TOPRIGHT", 3, 0)

            s:Size(s.Icon:GetWidth() + 10 + s.AbilityName:GetWidth(), s.Icon:GetHeight())
        end
        hooksecurefunc("LossOfControlFrame_SetUpDisplay", changeLocPos)
    end

    -- 声望详细窗口对齐
    hooksecurefunc("ReputationFrame_Update", function(self)
        _G.ReputationDetailFrame:ClearAllPoints()
        _G.ReputationDetailFrame:Point("TOPLEFT", _G.ReputationFrame, "TOPRIGHT", 5, 0)
    end)
end

function WS:AddOnSkins()
    -- 用 AddOnSkins 美化的窗体标签页
    AS = unpack(AddOnSkins)

    -- AddOnSkins
    if self.db.addonskins.general then
        local function WindAS_SkinCloseButton(self, Button, Reposition)
            if Button.windSkin then return end
            if Reposition then
                S:HandleCloseButton(Button, "TOPRIGHT", 2, 2)
            else
                S:HandleCloseButton(Button)
            end

            Button.windSkin = true
        end

        local function WindAS_SkinFrame(self, frame, template, override, kill)
            local name = frame and frame.GetName and frame:GetName()
            local insetFrame = name and _G[name .. 'Inset'] or frame.Inset
            local closeButton = name and _G[name .. 'CloseButton'] or frame.CloseButton
            if not override then frame:StripTextures() end
            frame:SetTemplate('Transparent')
            frame:CreateShadow()
            if insetFrame then AS:SkinFrame(insetFrame) end
            if closeButton then WindAS_SkinCloseButton(closeButton) end
        end

        AS.SkinFrame = WindAS_SkinFrame
        AS.SkinCloseButton = WindAS_SkinCloseButton

        hooksecurefunc(AS, "SkinTab", function(self, f)
            if f.Backdrop then f.Backdrop:Kill() end
            S:HandleTab(f)
        end)

        AS.SkinTooltip = function(self, frame, scale)
            for _, Region in pairs(AS.Blizzard.Tooltip) do
                if tooltip[Region] then tooltip[Region]:SetTexture() end
            end
            WindAS_SkinFrame(self, tooltip)
            if scale then tooltip:SetScale(AS.UIScale) end
        end

        AS.SkinScrollBar = function(self, frame)
            S.HandleScrollBar(self, frame)
            frame:CreateShadow()
        end

        AS.SkinButton = function(self, button, strip) S.HandleButton(self, button, strip) end
    end

    -- Weakaura
    if self.db.addonskins.weakaura and AS:CheckAddOn('WeakAuras') then
        AS:RegisterSkin('WeakAuras2', shadow_weakauras, 'ADDON_LOADED')
    end

    -- Bigwigs
    if self.db.addonskins.bigwigs and AS:CheckAddOn('BigWigs') then
        AS:RegisterSkin('BigWigs', shadow_bigwigs, 'ADDON_LOADED')
        AS:RegisterSkinForPreload('BigWigs_Plugins', shadow_bigwigs)
    end

    -- Immersion
    if self.db.addonskins.immersion and AS:CheckAddOn('Immersion') then
        AS:RegisterSkin('Immersion', shadow_immersion, 'ADDON_LOADED')
    end
end

function WS:Initialize()
    if not E.db.WindTools.Interface.Skins.enabled then return end

    self.db = E.db.WindTools.Interface.Skins
    tinsert(WT.UpdateAll, function()
        WS.db = E.db.WindTools.Interface.Skins
        WS:ShadowElvUIFrames()
        WS:ShadowGeneralFrames()
        WS:CustomSkins()
        if IsAddOnLoaded("AddOnSkins") then WS:AddOnSkins() end
    end)

    self:ShadowElvUIFrames()
    self:ShadowGeneralFrames()
    self:CustomSkins()
    if IsAddOnLoaded("AddOnSkins") then self:AddOnSkins() end
    self:RegisterEvent('ADDON_LOADED')
end

local function InitializeCallback() WS:Initialize() end

E:RegisterModule(WS:GetName(), InitializeCallback)
