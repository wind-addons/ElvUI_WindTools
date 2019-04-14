-- 原创模块
local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")
local OT = E:NewModule('Wind_ObjectiveTacker', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local _G = _G

function OT:ChangeFonts()
    local function set_header()
        local frame = _G.ObjectiveTrackerFrame.MODULES
        if frame then
            for i = 1, #frame do
                local modules = frame[i]
                if modules then
                    modules.Header.Background:SetAtlas(nil)
                    local text = modules.Header.Text
                    text:FontTemplate(LSM:Fetch('font', OT.db.header.font), OT.db.header.size, OT.db.header.style)
                    text:SetParent(modules.Header)
                end
            end
        end
    end

    local function set_text(self, block)
        local text = block.HeaderText
        if text then
            text:FontTemplate(LSM:Fetch('font', OT.db.title.font), OT.db.title.size, OT.db.title.style)
            for objectiveKey, line in pairs(block.lines) do
                line.Text:FontTemplate(LSM:Fetch('font', OT.db.info.font), OT.db.info.size, OT.db.info.style)
            end
        end
    end

    local function set_wq_text(self, font_string)
        if font_string then font_string:FontTemplate(LSM:Fetch('font', OT.db.info.font), OT.db.info.size, OT.db.info.style) end
    end

    local function hook_wq_text(self)
        for _, block in pairs(WORLD_QUEST_TRACKER_MODULE.usedBlocks) do
            for objectiveKey, line in pairs(block.lines) do
                if objectiveKey == 0 then
                    line.Text:FontTemplate(LSM:Fetch('font', OT.db.title.font), OT.db.title.size, OT.db.title.style)
                elseif objectiveKey then
                    line.Text:FontTemplate(LSM:Fetch('font', OT.db.info.font), OT.db.info.size, OT.db.info.style)
                end
            end
        end
    end

    hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", set_text)
    hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "Update", hook_wq_text)
    hooksecurefunc("ObjectiveTracker_Update", set_header)
end

function OT:ChangeColors()
    if not IsAddOnLoaded("Blizzard_ObjectiveTracker") then return end
    
    -- Title color
    if self.db.title.color.enabled then
        local db = self.db.title.color
        local class_color = _G.RAID_CLASS_COLORS[E.myclass]

        local cr = db.class_color and class_color.r or db.custom_color.r
        local cg = db.class_color and class_color.g or db.custom_color.g
        local cb = db.class_color and class_color.b or db.custom_color.b
        _G.OBJECTIVE_TRACKER_COLOR["Header"] = {r = cr, g = cg, b = cb}
        
        local cr = db.class_color and class_color.r or db.custom_color_highlight.r
        local cg = db.class_color and class_color.g or db.custom_color_highlight.g
        local cb = db.class_color and class_color.b or db.custom_color_highlight.b
        _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"] = {r = cr, g = cg, b = cb}
    end
end

function OT:Initialize()
    self.db = E.db.WindTools.Quest["Objective Tracker"]
    if not self.db.enabled then return end
    self:ChangeFonts()
    self:ChangeColors()
end

local function InitializeCallback()
    OT:Initialize()
end

E:RegisterModule(OT:GetName(), InitializeCallback)