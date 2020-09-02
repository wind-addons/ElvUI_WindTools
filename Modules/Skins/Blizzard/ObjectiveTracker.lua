local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc

function S:SkinOjectiveTrackerHeaders()
    local frame = _G.ObjectiveTrackerFrame.MODULES
    if frame then
        for i = 1, #frame do
            if frame[i] then
                F.SetFontOutline(frame[i].Header.Text)
            end
        end
    end
end

function S:SkinItemButton(_, block)
    local item = block.itemButton
    if item and not item.windStyle then
        self:CreateShadow(item)
        item.windStyle = true
    end
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
    self:CreateBackdropShadowAfterElvUISkins(bar)

    -- 稍微移动下图标位置，防止阴影重叠，更加美观！
    if icon then
        self:CreateBackdropShadowAfterElvUISkins(progressBar)
        icon:Point("LEFT", bar, "RIGHT", E.PixelMode and 7 or 11, 0)
    end

    -- 修正字体位置
    if label then
        label:ClearAllPoints()
        label:Point("CENTER", bar, 0, 0)
        F.SetFontOutline(label)
    end

    progressBar.windStyle = true
end

function S:SkinTimerBars(_, _, line)
    local timerBar = line and line.TimerBar
    local bar = timerBar and timerBar.Bar
    if bar.windStyle then
        return
    end
    self:CreateBackdropShadowAfterElvUISkins(bar)
end

function S:ObjectiveTrackerFrame()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.objectiveTracker) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.objectiveTracker) then
        return
    end

    local ObjectiveTrackerFrame = _G.ObjectiveTrackerFrame
    local minimizeButton = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton

    S:SecureHook("ObjectiveTracker_Update", "SkinOjectiveTrackerHeaders")
    S:SecureHook("QuestObjectiveSetupBlockButton_FindGroup", "SkinFindGroupButton")
    S:SecureHook(_G.BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
    S:SecureHook(_G.WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
    S:SecureHook(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
    S:SecureHook(_G.SCENARIO_TRACKER_MODULE, "AddProgressBar", "SkinProgressBars")
    S:SecureHook(_G.QUEST_TRACKER_MODULE, "AddTimerBar", "SkinTimerBars")
    S:SecureHook(_G.SCENARIO_TRACKER_MODULE, "AddTimerBar", "SkinTimerBars")
    S:SecureHook(_G.ACHIEVEMENT_TRACKER_MODULE, "AddTimerBar", "SkinTimerBars")
    S:SecureHook(_G.QUEST_TRACKER_MODULE, "SetBlockHeader", "SkinItemButton")
    S:SecureHook(_G.WORLD_QUEST_TRACKER_MODULE, "AddObjective", "SkinItemButton")
end

S:AddCallback("ObjectiveTrackerFrame")
