local W, F, E, L = unpack(select(2, ...))
local OT = W:NewModule("ObjectiveTracker", "AceHook-3.0", "AceEvent-3.0")

local _G = _G
local abs = abs
local format = format
local floor = floor
local ipairs = ipairs
local min = min
local pairs = pairs
local strmatch = strmatch
local tonumber = tonumber

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

local color = {
    start = {
        r = 1.000,
        g = 0.647,
        b = 0.008
    },
    complete = {
        r = 0.180,
        g = 0.835,
        b = 0.451
    }
}

local function GetColor(progress)
    local r = (color.complete.r - color.start.r) * progress + color.start.r
    local g = (color.complete.g - color.start.g) * progress + color.start.g
    local b = (color.complete.r - color.start.b) * progress + color.start.b

    -- 色彩亮度补偿

    local addition = 0.35
    r = min(r + abs(0.5 - progress) * addition, r)
    g = min(g + abs(0.5 - progress) * addition, g)
    b = min(b + abs(0.5 - progress) * addition, b)

    return {r = r, g = g, b = b}
end

function OT:ChangeQuestHeaderStyle()
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

function OT:ChangeQuestFontStyle(_, block)
    if not self.db or not block then
        return
    end

    if block.HeaderText then
        F.SetFontWithDB(block.HeaderText, self.db.title)
        local height = block.HeaderText:GetStringHeight() + 2
        if height ~= block.HeaderText:GetHeight() then
            block.HeaderText:SetHeight(height)
        end
    end

    if block.currentLine then
        if block.currentLine.objectiveKey == 0 then
            F.SetFontWithDB(block.currentLine.Text, self.db.title)
            local height = block.currentLine.Text:GetStringHeight() + 4
            if height ~= block.currentLine.Text:GetHeight() then
                block.currentLine.Text:SetHeight(height)
            end
        else
            F.SetFontWithDB(block.currentLine.Text, self.db.info)
            self:ChangeDashStyle(block.currentLine, "Dash")

            local widthBefore = block.currentLine.Text:GetStringWidth()
            self:ColorfulProgression(block.currentLine.Text)
            local widthAfter = block.currentLine.Text:GetStringWidth()
            if
                floor(widthAfter / _G.OBJECTIVE_TRACKER_TEXT_WIDTH) >
                    floor(widthBefore / _G.OBJECTIVE_TRACKER_TEXT_WIDTH)
             then
                block.height = block.height + self.db.info.size + 2
            end
        end
    end
end

function OT:ScenarioObjectiveBlock_UpdateCriteria()
    if _G.ScenarioObjectiveBlock then
        local childs = {_G.ScenarioObjectiveBlock:GetChildren()}
        for _, child in pairs(childs) do
            if child.Text then
                F.SetFontWithDB(child.Text, self.db.info)
                self:ChangeDashStyle(child, "Icon")

                local widthBefore = child.Text:GetStringWidth()
                self:ColorfulProgression(child.Text)
                local widthAfter = child.Text:GetStringWidth()
                if
                    floor(widthAfter / _G.OBJECTIVE_TRACKER_TEXT_WIDTH) >
                        floor(widthBefore / _G.OBJECTIVE_TRACKER_TEXT_WIDTH)
                 then
                    _G.ScenarioObjectiveBlock.height = _G.ScenarioObjectiveBlock.height + self.db.info.size + 2
                end
                child.windStyle = true
            end
        end
    end
end

function OT:ChangeDashStyle(currentLine, target)
    if not self.db or not currentLine or not currentLine[target] then
        return
    end

    if self.db.noDash then
        currentLine[target]:Hide()
        currentLine.Text:ClearAllPoints()
        currentLine.Text:Point("TOPLEFT", currentLine[target], "TOPLEFT", 0, 0)
    else
        if target == "Dash" then
            F.SetFontWithDB(currentLine[target], self.db.info)
        end
        currentLine[target]:Show()
        currentLine.Text:ClearAllPoints()
        currentLine.Text:Point("TOPLEFT", currentLine[target], "TOPRIGHT", 0, 0)
    end
end

function OT:ColorfulProgression(text)
    if not self.db or not text then
        return
    end

    local info = text:GetText()
    if not info then
        return
    end

    local current, required, details = strmatch(info, "^(%d-)/(%d-) (.+)")
    if not (current and required and details) then
        return
    end

    local oldHeight = text:GetHeight()
    local progress = tonumber(current) / tonumber(required)

    if self.db.colorfulProgress then
        info = F.CreateColorString(current .. "/" .. required, GetColor(progress))
        info = info .. " " .. details
    end

    if self.db.percentage then
        local percentage = format("[%.f%%]", progress * 100)
        if self.db.colorfulPercentage then
            percentage = F.CreateColorString(percentage, GetColor(progress))
        end
        info = info .. " " .. percentage
    end

    text:SetText(info)
end

function OT:ChangeQuestTitleColor()
    if not IsAddOnLoaded("Blizzard_ObjectiveTracker") then
        return
    end

    local config = self.db.titleColor
    if not config then
        return
    end

    if config.enable then
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

function OT:UpdateTextWidth()
    if self.db.noDash then
        _G.OBJECTIVE_TRACKER_TEXT_WIDTH = _G.OBJECTIVE_TRACKER_LINE_WIDTH - 12
    else
        _G.OBJECTIVE_TRACKER_TEXT_WIDTH = _G.OBJECTIVE_TRACKER_LINE_WIDTH - _G.OBJECTIVE_TRACKER_DASH_WIDTH - 12
    end
end

function OT:Initialize()
    self.db = E.db.WT.quest.objectiveTracker
    if not self.db.enable then
        return
    end

    self:ChangeQuestTitleColor()
    self:UpdateTextWidth()

    local trackerModules = {
        -- _G.SCENARIO_CONTENT_TRACKER_MODULE,
        _G.UI_WIDGET_TRACKER_MODULE,
        _G.BONUS_OBJECTIVE_TRACKER_MODULE,
        _G.WORLD_QUEST_TRACKER_MODULE,
        _G.CAMPAIGN_QUEST_TRACKER_MODULE,
        _G.QUEST_TRACKER_MODULE,
        _G.ACHIEVEMENT_TRACKER_MODULE
    }

    for _, module in pairs(trackerModules) do
        self:SecureHook(module, "AddObjective", "ChangeQuestFontStyle")
    end

    self:SecureHook("ObjectiveTracker_Update", "ChangeQuestHeaderStyle")
    self:SecureHook(_G.SCENARIO_CONTENT_TRACKER_MODULE, "UpdateCriteria", "ScenarioObjectiveBlock_UpdateCriteria")
end

W:RegisterModule(OT:GetName())
