local W, F, E, L = unpack(select(2, ...))
local T = W:GetModule("Tooltips")
local LOP = LibStub("LibObjectiveProgress-1.0")

local _G = _G
local floor = floor
local format = format
local next = next
local select = select
local tonumber = tonumber
local tostring = tostring

local UnitGUID = UnitGUID
local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetLogIndexForQuestID = C_QuestLog.GetLogIndexForQuestID

local accuracy

function T:AddObjectiveProgress(tt)
    if not tt or not tt.NumLines or tt:NumLines() == 0 then
        return
    end

    local name, unit = tt:GetUnit()
    local GUID = unit and UnitGUID(unit)
    local npcID = GUID and select(6, ("-"):split(GUID))

    if not npcID or npcID == "" then
        return
    end

    local weightsTable = LOP:GetNPCWeightByCurrentQuests(tonumber(npcID))
    if not weightsTable then
        return
    end

    for questID, npcWeight in next, weightsTable do
        local info = C_QuestLog_GetInfo(C_QuestLog_GetLogIndexForQuestID(questID))
        for i = 1, tt:NumLines() do
            local text = _G["GameTooltipTextLeft" .. i]
            if text and text:GetText() == info.title then
                text:SetText(text:GetText() .. format(" + %s%%", F.Round(npcWeight, accuracy)))
            end
        end
    end
end

function T:ObjectiveProgress()
    if not E.private.WT.tooltips.objectiveProgress then
        return
    end

    accuracy = E.private.WT.tooltips.objectiveProgressAccuracy

    T:SecureHookScript(_G.GameTooltip, "OnTooltipSetUnit", "AddObjectiveProgress")
end

T:AddCallback("ObjectiveProgress")
