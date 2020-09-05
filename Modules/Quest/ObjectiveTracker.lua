local W, F, E, L = unpack(select(2, ...))
local OT = W:NewModule("ObjectiveTracker", "AceHook-3.0", "AceEvent-3.0")

local _G = _G
local pairs, ipairs = pairs, ipairs
local IsAddOnLoaded = IsAddOnLoaded
local ObjectiveTracker_Update = ObjectiveTracker_Update

local SystemCache = {
    ["Header"] = {
        r = _G.OBJECTIVE_TRACKER_COLOR["Header"].r,
        g = _G.OBJECTIVE_TRACKER_COLOR["Header"].g,
        b = _G.OBJECTIVE_TRACKER_COLOR["Header"].b
    },
    ["HeaderHighlight"] = {
        r = _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].r,
        g = _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].g,
        b = _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].b
    }
}

local classColor = _G.RAID_CLASS_COLORS[E.myclass]

function OT:UpdateBonusFont()
    local frame = _G.BONUS_OBJECTIVE_TRACKER_MODULE
    local config = self.db

    if not config or not frame or not frame.usedBlocks then
        return
    end

    for _, block in pairs(frame.usedBlocks) do
        if not block.WTStyle then
            if not (not block.ScrollContents) or not block.ScrollContents.GetChildren then
                return
            end

            for index, line in pairs({block.ScrollContents:GetChildren()}) do
                if line and line.Text then
                    F.SetFontWithDB(line.Text, index == 1 and config.title or config.info)
                end
            end

            block.WTStyle = true
        end
    end
end

function OT:UpdateHeaderFont()
    local frame = _G.ObjectiveTrackerFrame.MODULES
    local config = self.db.header

    if not config or not frame then
        return
    end

    for i = 1, #frame do
        local modules = frame[i]
        if modules then
            local text = modules.Header.Text
            F.SetFontWithDB(text, config)
        end
    end
end

function OT:UpdateQuestFont(module, block)
    if not self.db or not block then
        return
    end

    if block.HeaderText and not block.HeaderText.windStyle then
        F.SetFontWithDB(block.HeaderText, self.db.title)
        block.HeaderText.windStyle = true
    end

    if block.currentLine and not block.currentLine.windStyle then
        F.SetFontWithDB(block.currentLine.Text, self.db.info)
        if block.currentLine.Dash then
            if self.db.noDash then
            block.currentLine.Dash:Hide()
            block.currentLine.Text:ClearAllPoints()
            block.currentLine.Text:Point("TOPLEFT", block.currentLine.Dash, "TOPLEFT", 0, 0)
            else
                F.SetFontWithDB(block.currentLine.Dash, self.db.info)
            end
        end

        block.currentLine.windStyle = true
    end

    -- self:UpdateBonusFont()
end

function OT:UpdateTitleColor()
    if not IsAddOnLoaded("Blizzard_ObjectiveTracker") then
        return
    end

    local config = self.db.titleColor
    if not config then
        return
    end

    if config.enable and not self.titleColorChanged then
        _G.OBJECTIVE_TRACKER_COLOR["Header"] = {
            r = config.classColor and classColor.r or config.customColorNormal.r,
            g = config.classColor and classColor.g or config.customColorNormal.g,
            b = config.classColor and classColor.b or config.customColorNormal.b
        }

        _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"] = {
            r = config.classColor and classColor.r or config.customColorHighlight.r,
            g = config.classColor and classColor.g or config.customColorHighlight.g,
            b = config.classColor and classColor.b or config.customColorHighlight.b
        }

        self.titleColorChanged = true
        ObjectiveTracker_Update()
    elseif not config.enable and self.titleColorChanged then
        _G.OBJECTIVE_TRACKER_COLOR["Header"] = {
            r = SystemCache["Header"].r,
            g = SystemCache["Header"].g,
            b = SystemCache["Header"].b
        }

        _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"] = {
            r = SystemCache["HeaderHighlight"].r,
            g = SystemCache["HeaderHighlight"].g,
            b = SystemCache["HeaderHighlight"].b
        }

        self.titleColorChanged = false
        ObjectiveTracker_Update()
    end
end

function OT:Initialize()
    self.db = E.db.WT.quest.objectiveTracker
    if not self.db.enable or self.initialized then
        return
    end

    self:UpdateTitleColor()

    local trackerModules = {
        _G.SCENARIO_CONTENT_TRACKER_MODULE,
        _G.UI_WIDGET_TRACKER_MODULE,
        _G.BONUS_OBJECTIVE_TRACKER_MODULE,
        _G.WORLD_QUEST_TRACKER_MODULE,
        _G.CAMPAIGN_QUEST_TRACKER_MODULE,
        _G.QUEST_TRACKER_MODULE,
        _G.ACHIEVEMENT_TRACKER_MODULE
    }

    self:SecureHook("ObjectiveTracker_Update", "UpdateHeaderFont")

    for _, module in pairs(trackerModules) do
        self:SecureHook(module, "AddObjective", "UpdateQuestFont")
    end

    self.initialized = true
end

function OT:ProfileUpdate()
    self:Initialize()
    self:UpdateTitleColor()
end

W:RegisterModule(OT:GetName())
