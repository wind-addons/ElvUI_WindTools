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
            button.backdrop:Point("TOPLEFT", button, "TOPLEFT", 10, -3)
            button.backdrop:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -10, 3)
            self:CreateShadow(button.backdrop)

            button.Hilite:StripTextures()
            button.Overlay:StripTextures()
            button.BottomEdge:StripTextures()
            button.BottomLeftCorner:StripTextures()
            button.BottomRightCorner:StripTextures()
            button.Center:StripTextures()
            button.LeftEdge:StripTextures()
            button.RightEdge:StripTextures()
            button.TopEdge:StripTextures()
            button.TopLeftCorner:StripTextures()
            button.TopRightCorner:StripTextures()

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
    self:Immersion_ReskinTitleButton(_G.ImmersionFrame)
    self.reskinButtonAttemptCount = 0
    self.reskinButtonTimer = self:ScheduleRepeatingTimer("AttemptReskinButton", 0.1)
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
    F.SetFontOutline(talkBox.TextFrame.SpeechProgress, "Montserrat", "-2")

    -- 关闭按钮
    ES:HandleCloseButton(talkBox.MainFrame.CloseButton)

    -- 去除任务细节窗口 (下窗口) 背景
    local elements = talkBox.Elements
    elements.BottomEdge:StripTextures()
    elements.BottomLeftCorner:StripTextures()
    elements.BottomRightCorner:StripTextures()
    elements.Center:StripTextures()
    elements.LeftEdge:StripTextures()
    elements.RightEdge:StripTextures()
    elements.TopEdge:StripTextures()
    elements.TopLeftCorner:StripTextures()
    elements.TopRightCorner:StripTextures()
    elements:CreateBackdrop("Transparent")
    elements.backdrop:ClearAllPoints()
    elements.backdrop:Point("TOPLEFT", elements, "TOPLEFT", 10, -5)
    elements.backdrop:Point("BOTTOMRIGHT", elements, "BOTTOMRIGHT", -10, 5)
    S:CreateShadow(elements.backdrop)

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