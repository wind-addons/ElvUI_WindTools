local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")
local OT = E:NewModule('Wind_ObjectiveTacker', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local _G = _G

local function hook_fonts()
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

  hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", set_text)
  hooksecurefunc("ObjectiveTracker_Update", set_header)
  hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "SetStringText", set_wq_text)
end

function OT:Initialize()
  self.db = E.db.WindTools.Quest["Objective Tracker"]
  if not self.db.enabled then return end
  hook_fonts()
end

local function InitializeCallback()
  OT:Initialize()
end

E:RegisterModule(OT:GetName(), InitializeCallback)