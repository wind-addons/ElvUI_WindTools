local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local pairs = pairs
local UIDROPDOWNMENU_MAXLEVELS = UIDROPDOWNMENU_MAXLEVELS

function S:Blizzard_DeathRecap()
    self:CreateShadow(_G.DeathRecapFrame)
end

function S:SkinSkipButton(frame)
    if frame and frame.CloseDialog then
        self:CreateBackdropShadowAfterElvUISkins(frame.CloseDialog)
    end
end

function S:BlizzardMiscFrames()
    if not self:CheckDB("misc") then
        return
    end

    -- 一些菜单框体
    local miscFrames = {
        "GameMenuFrame",
        "InterfaceOptionsFrame",
        "VideoOptionsFrame",
        "AudioOptionsFrame",
        "AutoCompleteBox"
    }

    for _, frame in pairs(miscFrames) do
        self:CreateBackdropShadowAfterElvUISkins(_G[frame])
    end

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
        local bg = _G["DropDownList" .. i .. "MenuBackdrop"]
        if bg then
            if not bg.backdrop then
                bg:CreateBackdrop("Transparent")
            end
            self:CreateBackdropShadow(bg)
        end
    end

    -- 错误提示
    if _G.UIErrorsFrame then
        F.SetFontWithDB(_G.UIErrorsFrame, E.private.WT.skins.errorMessage)
    end

    if _G.ActionStatus.Text then
        F.SetFontWithDB(_G.ActionStatus.Text, E.private.WT.skins.errorMessage)
    end

    -- 灵魂医者传送按钮
    self:CreateBackdropShadowAfterElvUISkins(_G.GhostFrameContentsFrame)

    -- 跳过剧情
    self:CreateBackdropShadowAfterElvUISkins(_G.CinematicFrameCloseDialog)

    -- 举报玩家
    self:CreateBackdropShadowAfterElvUISkins(_G.PlayerReportFrame)
    self:CreateBackdropShadowAfterElvUISkins(_G.ReportCheatingDialog)

    -- 分离物品
    self:CreateBackdropShadowAfterElvUISkins(_G.StackSplitFrame)

    -- 聊天设定
    self:CreateBackdropShadowAfterElvUISkins(_G.ChatConfigFrame)

    -- 颜色选择器
    self:CreateBackdropShadowAfterElvUISkins(_G.ColorPickerFrame)

    -- What's new
    self:CreateBackdropShadowAfterElvUISkins(_G.SplashFrame)
end

S:AddCallback("BlizzardMiscFrames")
S:AddCallbackForAddon("Blizzard_DeathRecap")
