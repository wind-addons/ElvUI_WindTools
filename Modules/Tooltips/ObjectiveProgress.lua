local W, F, E, L = unpack(select(2, ...))
local T = W:GetModule("Tooltips")
local LOP = LibStub("LibObjectiveProgress-1.0")

local _G = _G
local tonumber = tonumber
local next = next

local UnitGUID = UnitGUID
local select, tostring, floor = select, tostring, math.floor

local C_TaskQuest_GetQuestInfoByQuestID = C_TaskQuest.GetQuestInfoByQuestID

function T:OnTooltipSetUnit(tt)
    if not tt or not tt.NumLines or tt:NumLines() == 0 then
        return
    end

    local name, unit = tt:GetUnit()
    if not unit then
        return
    end

    local GUID = UnitGUID(unit)
    if not GUID or GUID == "" then
        return
    end

    local npcID = select(6, ("-"):split(GUID))
    if not npcID or npcID == "" then
        return
    end

    local weightsTable = LOP:GetNPCWeightByCurrentQuests(tonumber(npcID))
    if not weightsTable then
        return
    end

    for questID, npcWeight in next, weightsTable do
        local questTitle = C_TaskQuest_GetQuestInfoByQuestID(questID)
        for j = 1, tt:NumLines() do
            if _G["GameTooltipTextLeft" .. j] and _G["GameTooltipTextLeft" .. j]:GetText() == questTitle then
                _G["GameTooltipTextLeft" .. j]:SetText(
                    _G["GameTooltipTextLeft" .. j]:GetText() ..
                        " - " .. tostring(floor((npcWeight * 100) + 0.5) / 100) .. "%"
                )
            end
        end
    end
end

function T:ObjectiveProgress()
    if not E.private.WT.tooltips.objectiveProgress then
        return
    end

    T:SecureHookScript(_G.GameTooltip, "OnTooltipSetUnit", "OnTooltipSetUnit")
end

T:AddCallback("ObjectiveProgress")
