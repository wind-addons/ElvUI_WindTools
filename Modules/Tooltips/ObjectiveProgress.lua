local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local T = W.Modules.Tooltips
local OP = E.Libs.ObjectiveProgress
local C = W.Utilities.Color

local _G = _G
local format = format
local next = next
local select = select
local strjoin = strjoin
local strsplit = strsplit
local tonumber = tonumber

local GetInstanceInfo = GetInstanceInfo

local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetLogIndexForQuestID = C_QuestLog.GetLogIndexForQuestID
local TooltipDataProcessor_AddTooltipPostCall = TooltipDataProcessor.AddTooltipPostCall

local GameTooltip = _G.GameTooltip

local Enum_TooltipDataType_Unit = Enum.TooltipDataType.Unit

local accuracy

local icon1 = F.GetIconString(132147, 14)
local icon2 = F.GetIconString(5926319, 14)

local function addObjectiveProgress(tt, data)
	if not tt or not tt == _G.GameTooltip and not tt.NumLines or tt:NumLines() == 0 then
		return
	end

	local npcID = data and data.guid and E:NotSecretValue(data.guid) and select(6, strsplit("-", data.guid))

	if not npcID or npcID == "" then
		return
	end

	npcID = tonumber(npcID)

	local weightsTable = OP:GetNPCWeightByCurrentQuests(npcID)
	if weightsTable then
		for questID, npcWeight in next, weightsTable do
			local logIndex = questID and C_QuestLog_GetLogIndexForQuestID(questID)
			local info = logIndex and C_QuestLog_GetInfo(logIndex)
			if info and info.title then
				for i = 1, tt:NumLines() do
					local text = _G["GameTooltipTextLeft" .. i]
					if text and text:GetText() == info.title then
						text:SetText(text:GetText() .. format(" + %s%%", E:Round(npcWeight, accuracy)))
					end
				end
			end
		end
	end

	local difficultyID = select(3, GetInstanceInfo())
	if not difficultyID or difficultyID ~= 8 then
		return
	end

	if _G.MDT and _G.MDT.GetEnemyForces and not tt.__windEnemyProgress then
		tt.__windEnemyProgress = true
		local count, max = _G.MDT:GetEnemyForces(npcID)

		if count and max and count > 0 and max > 0 then
			local left = strjoin(
				" ",
				icon1,
				C.StringByTemplate(count, "teal-500"),
				C.StringByTemplate("-", "neutral-50"),
				C.StringByTemplate(max, "amber-300")
			)
			local right = strjoin(
				" ",
				icon2,
				C.StringByTemplate(E:Round(100 * count / max, accuracy), "sky-500"),
				C.StringByTemplate("%", "neutral-50")
			)
			tt:AddDoubleLine(left, right)
			tt:Show()
		end
	end
end

function T:ObjectiveProgress()
	if not E.private.WT.tooltips.objectiveProgress.enable then
		return
	end

	accuracy = E.private.WT.tooltips.objectiveProgress.accuracy

	TooltipDataProcessor_AddTooltipPostCall(Enum_TooltipDataType_Unit, addObjectiveProgress)

	GameTooltip:HookScript("OnTooltipCleared", function(tt)
		tt.__windEnemyProgress = nil
	end)
end

T:AddCallback("ObjectiveProgress")
