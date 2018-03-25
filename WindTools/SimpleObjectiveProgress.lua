--[[
SimpleObjectiveProgress
作者: Simca@Malfurion-US (MMOSimca)
]]--


-- Localized function references
local LOP = _G.LibStub("LibObjectiveProgress-1.0")


-- OnTooltipSetUnit hook function
local function SOP_Hook_OnTooltipSetUnit(self)
    if not self or not self.NumLines or self:NumLines() == 0 then return end

    local name, unit = self:GetUnit()
    if not unit then return end

    local GUID = UnitGUID(unit)
    if not GUID or GUID == "" then return end

    local npcID = select(6, ("-"):split(GUID))
    if not npcID or npcID == "" then return end

    local weightsTable = LOP:GetNPCWeightByCurrentQuests(tonumber(npcID))
    if not weightsTable then return end

    for questID, npcWeight in next, weightsTable do
        local questTitle = C_TaskQuest.GetQuestInfoByQuestID(questID)
        for j = 1, self:NumLines() do
            if _G["GameTooltipTextLeft" .. j] and _G["GameTooltipTextLeft" .. j]:GetText() == questTitle then
                _G["GameTooltipTextLeft" .. j]:SetText(_G["GameTooltipTextLeft" .. j]:GetText() .. " - " .. tostring(math.floor((npcWeight * 100) + 0.5) / 100) .. "%")
            end
        end
    end
end

-- Set our hook function
GameTooltip:HookScript("OnTooltipSetUnit", SOP_Hook_OnTooltipSetUnit)
