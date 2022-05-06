local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

local InCombatLockdown = InCombatLockdown

function S:SkinOjectiveTrackerHeaders()
    if E.private and E.private.WT and E.private.WT.quest.objectiveTracker.enable then
        return
    end

    local frame = _G.ObjectiveTrackerFrame.MODULES
    if frame then
        for i = 1, #frame do
            if frame[i] then
                F.SetFontOutline(frame[i].Header.Text)
            end
        end
    end
end

function S:SkinItemButton(block)
    if InCombatLockdown() then
        return
    end

    local item = block and block.itemButton
    if not item then
        return
    end
    self:CreateBackdropShadow(item, true)
end

function S:SkinFindGroupButton(block)
    if block.hasGroupFinderButton and block.groupFinderButton then
        if block.groupFinderButton and not block.groupFinderButton.windStyle then
            self:CreateShadow(block.groupFinderButton)
            block.groupFinderButton.windStyle = true
        end
    end
end

function S:SkinProgressBars(_, _, line)
    local progressBar = line and line.ProgressBar
    local bar = progressBar and progressBar.Bar
    if not bar or progressBar.windStyle then
        return
    end
    local icon = bar.Icon
    local label = bar.Label

    -- 条阴影
    self:CreateBackdropShadow(bar)

    -- 稍微移动下图标位置，防止阴影重叠，更加美观！
    if icon then
        self:CreateBackdropShadow(progressBar)
        icon:Point("LEFT", bar, "RIGHT", E.PixelMode and 7 or 11, 0)
    end

    -- 修正字体位置
    if label then
        label:ClearAllPoints()
        label:Point("CENTER", bar, 0, 0)
        F.SetFontOutline(label)
    end

    -- 目标字样
    F.SetFontOutline(_G.ObjectiveTrackerFrame.HeaderMenu.Title)

    progressBar.windStyle = true
end

function S:SkinTimerBars(_, _, line)
    local timerBar = line and line.TimerBar
    local bar = timerBar and timerBar.Bar
    if bar.windStyle then
        return
    end
    self:CreateBackdropShadow(bar)
end

function S:ObjectiveTrackerFrame()
    if not self:CheckDB("objectiveTracker") then
        return
    end

    local ObjectiveTrackerFrame = _G.ObjectiveTrackerFrame
    local minimizeButton = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton

    self:SecureHook("ObjectiveTracker_Update", "SkinOjectiveTrackerHeaders")
    self:SecureHook("QuestObjectiveSetupBlockButton_FindGroup", "SkinFindGroupButton")
    self:SecureHook("QuestObjectiveSetupBlockButton_Item", "SkinItemButton")
    self:SecureHook(_G.BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
    self:SecureHook(_G.WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
    self:SecureHook(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
    self:SecureHook(_G.SCENARIO_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
    self:SecureHook(_G.CAMPAIGN_QUEST_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
    self:SecureHook(_G.QUEST_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
    self:SecureHook(_G.QUEST_TRACKER_MODULE, "AddTimerBar", "SkinTimerBars")
    self:SecureHook(_G.SCENARIO_TRACKER_MODULE, "AddTimerBar", "SkinTimerBars")
    self:SecureHook(_G.ACHIEVEMENT_TRACKER_MODULE, "AddTimerBar", "SkinTimerBars")
end

S:AddCallback("ObjectiveTrackerFrame")
