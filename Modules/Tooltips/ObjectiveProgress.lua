local W, F, E, L = unpack(select(2, ...))
local T = W.Modules.Tooltips
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
local TooltipDataProcessor_AddTooltipPostCall = TooltipDataProcessor.AddTooltipPostCall

local Enum_TooltipDataType_Unit = Enum.TooltipDataType.Unit

local accuracy

local function addObjectiveProgress(tt, data)
    if not tt or not tt == _G.GameTooltip and not tt.NumLines or tt:NumLines() == 0 then
        return
    end

    local npcID = select(6, strsplit("-", data.guid))

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

    TooltipDataProcessor_AddTooltipPostCall(Enum_TooltipDataType_Unit, addObjectiveProgress)
end

T:AddCallback("ObjectiveProgress")
