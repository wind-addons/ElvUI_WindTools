local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local T = W.Modules.Tooltips
local LibStub = LibStub

local _G = _G
local format = format
local next = next
local select = select
local strsplit = strsplit
local tonumber = tonumber

local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetLogIndexForQuestID = C_QuestLog.GetLogIndexForQuestID
local TooltipDataProcessor_AddTooltipPostCall = TooltipDataProcessor.AddTooltipPostCall

local Enum_TooltipDataType_Unit = Enum.TooltipDataType.Unit

local accuracy

local function AddObjectiveProgress(tt, data)
	if not tt or not tt == _G.GameTooltip and not tt.NumLines or tt:NumLines() == 0 then
		return
	end

	local npcID = data and data.guid and E:NotSecretValue(data.guid) and select(6, strsplit("-", data.guid))

	if not npcID or npcID == "" then
		return
	end

	npcID = tonumber(npcID)

	local OP = LibStub("LibObjectiveProgress", true) or E.Libs.ObjectiveProgressWT
	local weightsTable = OP:GetNPCWeightByCurrentQuests(npcID)
	if not weightsTable then
		return
	end

	for questID, npcWeight in next, weightsTable do
		local logIndex = questID and C_QuestLog_GetLogIndexForQuestID(questID)
		local info = logIndex and C_QuestLog_GetInfo(logIndex)
		if info and info.title then
			for i = 1, tt:NumLines() do
				local text = _G["GameTooltipTextLeft" .. i]
				local textStr = text and text:GetText()
				if E:NotSecretValue(textStr) and textStr and textStr == info.title then
					text:SetText(textStr .. format(" + %s%%", E:Round(npcWeight, accuracy)))
				end
			end
		end
	end
end

function T:ObjectiveProgress()
	if not E.private.WT.tooltips.objectiveProgress.enable then
		return
	end

	accuracy = E.private.WT.tooltips.objectiveProgress.accuracy

	TooltipDataProcessor_AddTooltipPostCall(Enum_TooltipDataType_Unit, AddObjectiveProgress)
end

T:AddCallback("ObjectiveProgress")
