local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")
local OT = E:NewModule('Wind_ObjectiveTacker', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local _G = _G

function OT:SetCustomFont()
    local function set_header()
		local frame = _G.ObjectiveTrackerFrame.MODULES
		if frame then
			for i = 1, #frame do
				local modules = frame[i]
				if modules then
					modules.Header.Background:SetAtlas(nil)
					local text = modules.Header.Text
					text:FontTemplate(nil, E.db.general.fontSize + 2, "OUTLINE")
					text:SetParent(modules.Header)
				end
			end
		end
	end

	local function set_text(self, block)
		local text = block.HeaderText
		if text then 
			text:FontTemplate(nil, E.db.general.fontSize, "OUTLINE")
			for objectiveKey, line in pairs(block.lines) do
				line.Text:FontTemplate(nil, E.db.general.fontSize, "OUTLINE")
			end
		end
	end

	local function set_wq_text(self, font_string)
		if font_string then font_string:FontTemplate(nil, nil, "OUTLINE") end
    end

	hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", set_text)
	hooksecurefunc("ObjectiveTracker_Update", set_header)
	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "SetStringText", set_wq_text)
end

function OT:Initialize()
    self.db = E.db.WindTools.Quest["Objective Tracker"]
    if not self.db.enabled then return 
    
    self:SetCustomFont()
end

local function InitializeCallback()
	OT:Initialize()
end

E:RegisterModule(OT:GetName(), InitializeCallback)