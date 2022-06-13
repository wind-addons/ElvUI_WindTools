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
    self:CreateShadow(item)
end

function S:SkinFindGroupButton(block)
    if block.hasGroupFinderButton and block.groupFinderButton then
        if block.groupFinderButton and not block.groupFinderButton.__windSkin then
            self:CreateShadow(block.groupFinderButton)
            block.groupFinderButton.__windSkin = true
        end
    end
end

function S:SkinProgressBars(_, _, line)
    local progressBar = line and line.ProgressBar

    if not progressBar or not progressBar.Bar or progressBar.__windSkin then
        return
    end

    self:CreateBackdropShadow(progressBar.Bar)

    -- move down the icon
    if progressBar.Bar.Icon then
        self:CreateBackdropShadow(progressBar)
        progressBar.Bar.Icon:Point("LEFT", progressBar.Bar, "RIGHT", E.PixelMode and 7 or 11, 0)
    end

    -- move text to center
    if progressBar.Bar.Label then
        progressBar.Bar.Label:ClearAllPoints()
        progressBar.Bar.Label:Point("CENTER", progressBar.Bar, 0, 0)
        F.SetFontOutline(progressBar.Bar.Label)
    end

    -- change font style of header
    F.SetFontOutline(_G.ObjectiveTrackerFrame.HeaderMenu.Title)

    progressBar.__windSkin = true
end

function S:SkinTimerBars(_, _, line)
    self:CreateBackdropShadow(line and line.TimerBar and line.TimerBar.Bar)
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
