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
        self:CreateShadow(frame.CloseDialog)
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
        self:CreateShadow(_G[frame])
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
        if _G["DropDownList" .. i] then
            self:CreateShadow(_G["DropDownList" .. i])
        end
    end

    -- 错误提示
    F.SetFontOutline(_G.UIErrorsFrame)
    F.SetFontOutline(_G.ActionStatus.Text)

    -- 灵魂医者传送按钮
    self:CreateShadow(_G.GhostFrameContentsFrame)

    -- 跳过剧情
    self:CreateShadow(_G.CinematicFrameCloseDialog)

    -- 举报玩家
    self:CreateShadow(_G.PlayerReportFrame)
    self:CreateShadow(_G.ReportCheatingDialog)

    -- 聊天设定
    self:CreateShadow(_G.ChatConfigFrame)
end

S:AddCallback("BlizzardMiscFrames")
S:AddCallbackForAddon("Blizzard_DeathRecap")
