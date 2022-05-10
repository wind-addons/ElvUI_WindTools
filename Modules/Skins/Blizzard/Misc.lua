local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G
local pairs = pairs
local UIDROPDOWNMENU_MAXLEVELS = UIDROPDOWNMENU_MAXLEVELS

function S:Blizzard_DeathRecap()
    self:CreateBackdropShadow(_G.DeathRecapFrame)
end

function S:SkinSkipButton(frame)
    if frame and frame.CloseDialog then
        self:CreateShadow(frame.CloseDialog)
    end
end

function S:BlizzardMiscFrames()
    if not self:CheckDB("misc") then
        return
    end

    self:CreateShadow(_G.GameMenuFrame)
    self:CreateShadow(_G.AutoCompleteBox)

    -- 跳过剧情
    self:SecureHook("CinematicFrame_OnDisplaySizeChanged", "SkinSkipButton")
    self:SecureHook("MovieFrame_PlayMovie", "SkinSkipButton")

    -- 聊天菜单
    local chatMenus = {"ChatMenu", "EmoteMenu", "LanguageMenu", "VoiceMacroMenu"}

    for _, menu in pairs(chatMenus) do
        self:SecureHookScript(_G[menu], "OnShow", "CreateShadow")
    end

    -- 下拉菜单
    for i = 1, UIDROPDOWNMENU_MAXLEVELS, 1 do
        local f = _G["DropDownList" .. i .. "Backdrop"]
        self:CreateShadow(f)

        f = _G["DropDownList" .. i .. "MenuBackdrop"]
        self:CreateShadow(f)
    end

    -- 错误提示
    if _G.UIErrorsFrame then
        F.SetFontWithDB(_G.UIErrorsFrame, E.private.WT.skins.errorMessage)
    end

    if _G.ActionStatus.Text then
        F.SetFontWithDB(_G.ActionStatus.Text, E.private.WT.skins.errorMessage)
    end

    -- 灵魂医者传送按钮
    self:CreateShadow(_G.GhostFrameContentsFrame)

    -- 跳过剧情
    self:CreateShadow(_G.CinematicFrameCloseDialog)

    -- 举报玩家
    self:CreateShadow(_G.PlayerReportFrame)
    self:CreateShadow(_G.ReportCheatingDialog)

    -- 分离物品
    self:CreateShadow(_G.StackSplitFrame)

    -- 聊天设定
    self:CreateShadow(_G.ChatConfigFrame)

    -- 颜色选择器
    self:CreateShadow(_G.ColorPickerFrame)

    -- UIWidget
    self:SecureHook(
        ES,
        "SkinStatusBarWidget",
        function(_, widgetFrame)
            if widgetFrame.Label then
                F.SetFontOutline(widgetFrame.Label)
            end
            if widgetFrame.Bar then
                self:CreateBackdropShadow(widgetFrame.Bar)
                if widgetFrame.Bar.Label then
                    F.SetFontOutline(widgetFrame.Bar.Label)
                end
            end
        end
    )

    self:SecureHook(
        _G.UIWidgetTemplateStatusBarMixin,
        "Setup",
        function(widgetFrame)
            if widgetFrame.Label then
                F.SetFontOutline(widgetFrame.Label)
            end

            if widgetFrame.Bar then
                self:CreateBackdropShadow(widgetFrame.Bar)
                if widgetFrame.Bar.Label then
                    F.SetFontOutline(widgetFrame.Bar.Label)
                end
            end

            if widgetFrame.isJailersTowerBar and self:CheckDB(nil, "scenario") then
                bar:SetWidth(234)
            end
        end
    )

    self:SecureHook(
        _G.UIWidgetTemplateCaptureBarMixin,
        "Setup",
        function(widgetFrame)
            local bar = widgetFrame.Bar
            if bar then
                self:CreateBackdropShadow(bar)
            end
        end
    )
end

S:AddCallback("BlizzardMiscFrames")
S:AddCallbackForAddon("Blizzard_DeathRecap")
