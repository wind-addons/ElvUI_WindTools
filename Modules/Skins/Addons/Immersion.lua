local W, F, E, L = unpack(select(2, ...))
local ES = E:GetModule("Skins")
local S = W:GetModule("Skins")

local _G = _G
local pairs = pairs

function S:Immersion_ReskinTitleButton(frame)
    for _, button in pairs {frame.TitleButtons:GetChildren()} do
        if button and not button.windStyle then
            ES:HandleButton(button)
            button.backdrop:SetTemplate("Transparent")
            button.backdrop:ClearAllPoints()
            button.backdrop:Point("TOPLEFT", button, "TOPLEFT", 3, -3)
            button.backdrop:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -10, 3)
            self:CreateShadow(button.backdrop)
            self:MerathilisUISkin(button.backdrop)

            button.Hilite:StripTextures()
            button.Overlay:StripTextures()
            button:SetBackdrop(nil)
            F.SetFontOutline(button.Label)
            button.windStyle = true
        end
    end
end

function S:AttemptReskinButton()
    self.reskinButtonAttemptCount = self.reskinButtonAttemptCount + 1
    self:Immersion_ReskinTitleButton(_G.ImmersionFrame)
    if self.reskinButtonAttemptCount == 10 then
        self:CancelTimer(self.reskinButtonTimer)
    end
end

function S:Immersion_Show()
    self:Immersion_SpeechProgressText()
    self:Immersion_ReskinTitleButton(_G.ImmersionFrame)
    self.reskinButtonAttemptCount = 0
    self.reskinButtonTimer = self:ScheduleRepeatingTimer("AttemptReskinButton", 0.1)
    E:Delay(0.1, S.Immersion_ReskinRewards, S)
end

function S:Immersion_ReskinRewards()
    for i=1, 20 do
        local rButton = _G["ImmersionQuestInfoItem"..i]
        if not rButton then
            return
        end

        if not rButton.windStyle then
            if rButton.NameFrame then
                rButton.NameFrame:StripTextures()
                rButton.NameFrame:CreateBackdrop("Transparent")
                rButton.NameFrame.backdrop:ClearAllPoints()
                rButton.NameFrame.backdrop:SetOutside(rButton.NameFrame, -18, -15)
                self:CreateShadow(rButton.NameFrame.backdrop)
            end
            rButton.windStyle = true
        end
    end
end

do -- If there is no speech progress text in first time, the skin will not be apply
    local reskin = false
    function S:Immersion_SpeechProgressText()
        if reskin then
            return
        end
        local talkBox = _G.ImmersionFrame and _G.ImmersionFrame.TalkBox
        if talkBox and talkBox.TextFrame and talkBox.TextFrame.SpeechProgress then
            F.SetFontWithDB(
                talkBox.TextFrame.SpeechProgress,
                {
                    name = "Montserrat" .. (W.CompatibleFont and " (en)" or ""),
                    size = 13,
                    style = "OUTLINE"
                }
            )
            reskin = true
        end
    end
end

function S:Immersion()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.immersion then
        return
    end

    local frame = _G.ImmersionFrame

    -- 谈话窗口 TalkBox
    local talkBox = frame.TalkBox

    -- 美化背景
    talkBox.BackgroundFrame:StripTextures()
    talkBox:CreateBackdrop("Transparent")
    talkBox.backdrop:ClearAllPoints()
    talkBox.backdrop:Point("TOPLEFT", talkBox, "TOPLEFT", 10, -10)
    talkBox.backdrop:Point("BOTTOMRIGHT", talkBox, "BOTTOMRIGHT", -10, 10)
    self:CreateShadow(talkBox.backdrop)
    self:MerathilisUISkin(talkBox.backdrop)

    -- 使用 ElvUI 边框变蓝来替换原高亮特效
    talkBox.Hilite:StripTextures()
    talkBox:HookScript("OnEnter", ES.SetModifiedBackdrop)
    talkBox:HookScript("OnLeave", ES.SetOriginalBackdrop)

    -- 去除模型背景
    talkBox.PortraitFrame:StripTextures()
    talkBox.MainFrame.Model.ModelShadow:StripTextures()
    talkBox.MainFrame.Model.PortraitBG:StripTextures()

    -- 光泽去除
    talkBox.MainFrame.Sheen:StripTextures()
    talkBox.MainFrame.TextSheen:StripTextures()
    talkBox.MainFrame.Overlay:StripTextures()

    -- 对话主窗口文字
    F.SetFontOutline(talkBox.NameFrame.Name)
    F.SetFontOutline(talkBox.TextFrame.Text)

    -- 关闭按钮
    ES:HandleCloseButton(talkBox.MainFrame.CloseButton)

    -- 去除任务细节窗口 (下窗口) 背景
    local elements = talkBox.Elements
    elements:SetBackdrop(nil)
    elements:CreateBackdrop("Transparent")
    elements.backdrop:ClearAllPoints()
    elements.backdrop:Point("TOPLEFT", elements, "TOPLEFT", 10, -5)
    elements.backdrop:Point("BOTTOMRIGHT", elements, "BOTTOMRIGHT", -10, 5)
    S:CreateShadow(elements.backdrop)
    S:MerathilisUISkin(elements.backdrop)

    -- 任务细节窗口文字
    local content = elements.Content
    F.SetFontOutline(content.ObjectivesHeader)
    F.SetFontOutline(content.ObjectivesText)
    F.SetFontOutline(content.RewardText)
    F.SetFontOutline(content.RewardsFrame.Header)
    F.SetFontOutline(content.RewardsFrame.TitleFrame.Name)
    F.SetFontOutline(content.RewardsFrame.XPFrame.ReceiveText)
    F.SetFontOutline(content.RewardsFrame.XPFrame.ValueText)
    F.SetFontOutline(content.RewardsFrame.ItemReceiveText)
    F.SetFontOutline(content.RewardsFrame.ItemChooseText)
    F.SetFontOutline(content.RewardsFrame.PlayerTitleText)
    F.SetFontOutline(content.RewardsFrame.SkillPointFrame.ValueText)

    -- 按钮
    self:SecureHookScript(frame, "OnEvent", "Immersion_ReskinTitleButton")
    self:SecureHook(frame, "Show", "Immersion_Show")
end

S:AddCallbackForAddon("Immersion")
S:DisableAddOnSkin("Immersion")
