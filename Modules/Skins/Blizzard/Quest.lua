local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local select = select
local strmatch = strmatch
local unpack = unpack

local CreateFrame = CreateFrame
local GetMaterialTextColors = GetMaterialTextColors
local GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
local GetQuestID = GetQuestID
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard

local C_QuestInfoSystem_GetQuestRewardSpells = C_QuestInfoSystem.GetQuestRewardSpells
local C_QuestLog_GetNextWaypointText = C_QuestLog.GetNextWaypointText
local C_QuestLog_GetSelectedQuest = C_QuestLog.GetSelectedQuest

local QUEST_OBJECTIVE_COMPLETED_FONT_COLOR = QUEST_OBJECTIVE_COMPLETED_FONT_COLOR
local MAX_OBJECTIVES = MAX_OBJECTIVES

local DEFAULT_COLOR = GetMaterialTextColors("Default")
local COMPLETED_COLOR = QUEST_OBJECTIVE_COMPLETED_FONT_COLOR:GetRGB()

local function GetCurrentQuestID()
	if _G.QuestInfoFrame.questLog then
		return C_QuestLog_GetSelectedQuest()
	else
		return GetQuestID()
	end
end

local function ApplyObjectiveTextColoring()
	if not _G.QuestInfoFrame.questLog then
		return
	end

	local questID = GetCurrentQuestID()
	local numVisibleObjectives = 0

	local waypointText = C_QuestLog_GetNextWaypointText(questID)
	if waypointText then
		numVisibleObjectives = numVisibleObjectives + 1
		local objectiveFrame = _G["QuestInfoObjective" .. numVisibleObjectives] --[[@as FontString?]]
		if objectiveFrame then
			objectiveFrame:SetTextColor(0, 0.82, 0.82) -- Cyan for waypoints
		end
	end

	-- Process all quest objectives
	for objectiveIndex = 1, GetNumQuestLeaderBoards() do
		local description, objectiveType, isCompleted = GetQuestLogLeaderBoard(objectiveIndex)

		if
			description
			and objectiveType ~= "spell"
			and objectiveType ~= "log"
			and numVisibleObjectives < MAX_OBJECTIVES
		then
			numVisibleObjectives = numVisibleObjectives + 1
			local objectiveFrame = _G["QuestInfoObjective" .. numVisibleObjectives] --[[@as FontString?]]
			if objectiveFrame then
				if isCompleted then
					objectiveFrame:SetTextColor(0.2, 1, 0.2) -- Green for completed
				else
					objectiveFrame:SetTextColor(1, 1, 1) -- White for incomplete
				end
			end
		end
	end
end

---Replaces default quest text colors with enhanced visibility colors
---@param textObject FontString The text object to modify
---@param redValue number The red component of the current color
---@param greenValue number The green component of the current color
---@param blueValue number The blue component of the current color
local function ReplaceQuestTextColor(textObject, redValue, greenValue, blueValue)
	if F.IsAlmost({ redValue, greenValue, blueValue }, { 0, 0.82, 0.82 }, 0.002) then
		return
	elseif redValue == 0 or redValue == DEFAULT_COLOR[1] then
		textObject:SetTextColor(1, 1, 1) -- White for better readability
	elseif redValue == COMPLETED_COLOR then
		textObject:SetTextColor(0.7, 0.7, 0.7) -- Muted for completed objectives
	end
end

---Applies minimal styling to reward buttons while preserving functionality
---@param rewardButton Button The reward button frame to style
local function StyleRewardButton(rewardButton)
	if not rewardButton then
		return
	end

	if rewardButton.NameFrame then
		rewardButton.NameFrame:Hide()
	end

	if not rewardButton.Icon then
		return
	end

	rewardButton.Icon:CreateBackdrop("Transparent")
	rewardButton.Icon:SetTexCoord(unpack(E.TexCoords))
	S:CreateBackdropShadow(rewardButton.Icon)
	S:BindShadowColorWithBorder(rewardButton.Icon.backdrop)

	rewardButton:CreateBackdrop("Transparent")
	S:CreateBackdropShadow(rewardButton)
	rewardButton.backdrop:ClearAllPoints()
	rewardButton.backdrop:Point("TOPRIGHT", rewardButton, "TOPRIGHT", -4, 0)
	rewardButton.backdrop:Point("BOTTOMLEFT", rewardButton.Icon.backdrop, "BOTTOMRIGHT", 2, 0)
end

---Applies styling to reward buttons with specific size requirements
---@param rewardButton Button The reward button frame to style
---@param isMapQuestInfo boolean Boolean indicating if this is for the map quest info frame
local function StyleRewardButtonWithSize(rewardButton, isMapQuestInfo)
	if not rewardButton then
		return
	end

	StyleRewardButton(rewardButton)

	if rewardButton.Icon then
		rewardButton.Icon:Size(isMapQuestInfo and 29 or 34)
	end
end

---Applies comprehensive styling to spell objective buttons
---@param spellButton Button The spell objective button frame to style
local function StyleSpellObjectiveButton(spellButton)
	if not spellButton then
		return
	end

	local buttonName = spellButton:GetName()
	local spellIcon = spellButton.Icon --[[@as Texture?]]

	if _G[buttonName .. "NameFrame"] then
		_G[buttonName .. "NameFrame"]:Hide()
	end
	if _G[buttonName .. "SpellBorder"] then
		_G[buttonName .. "SpellBorder"]:Hide()
	end

	if spellIcon then
		spellIcon:Point("TOPLEFT", 3, -2)
		spellIcon:SetDrawLayer("ARTWORK")
		spellIcon:SetTexCoord(unpack(E.TexCoords))
		S:CreateBackdropShadow(spellIcon)
	end

	local backgroundFrame = CreateFrame("Frame", nil, spellButton)
	backgroundFrame:Point("TOPLEFT", 2, -1)
	backgroundFrame:Point("BOTTOMRIGHT", 0, 14)
	backgroundFrame:SetFrameLevel(0)
	backgroundFrame:CreateBackdrop("Transparent")
end

---Hook function to maintain yellow text color for headers
---@param textFrame FontString The text frame being modified
---@param redValue number Red component of the color
---@param greenValue number Green component of the color
---@param blueValue number Blue component of the color
local function MaintainYellowTextColor(textFrame, redValue, greenValue, blueValue)
	if redValue ~= 1 or greenValue ~= 0.8 or blueValue ~= 0 then
		textFrame:SetTextColor(1, 0.8, 0) -- Force yellow color
	end
end

---Configures font with yellow coloring and outline for quest headers
---@param fontObject FontString The font object to configure
local function ConfigureYellowHeaderFont(fontObject)
	if not fontObject then
		return
	end

	F.SetFont(fontObject)
	fontObject:SetTextColor(1, 0.8, 0) -- Yellow for headers
	fontObject:SetShadowColor(0, 0, 0, 0)
	hooksecurefunc(fontObject, "SetTextColor", MaintainYellowTextColor)
end

---Hook function to maintain white text color for content
---@param textFrame FontString The text frame being modified
---@param redValue number Red component of the color
---@param greenValue number Green component of the color
---@param blueValue number Blue component of the color
local function MaintainWhiteTextColor(textFrame, redValue, greenValue, blueValue)
	if redValue ~= 1 or greenValue ~= 1 or blueValue ~= 1 then
		textFrame:SetTextColor(1, 1, 1) -- Force white color
	end
end

---Configures font with white coloring and outline for quest content
---@param fontObject FontString The font object to configure
local function ConfigureWhiteContentFont(fontObject)
	if not fontObject then
		return
	end

	F.SetFont(fontObject)
	fontObject:SetTextColor(1, 1, 1) -- White for content
	fontObject:SetShadowColor(0, 0, 0, 0)
	hooksecurefunc(fontObject, "SetTextColor", MaintainWhiteTextColor)
end

local function QuestInfo_Display()
	for _, objectiveText in pairs(_G.QuestInfoObjectivesFrame.Objectives) do
		if objectiveText and not objectiveText.__windSkin then
			if E.private.skins.parchmentRemoverEnable then
				F.SetFont(objectiveText)

				if not objectiveText.colorHooked then
					hooksecurefunc(objectiveText, "SetTextColor", ReplaceQuestTextColor)
					local currentRed, currentGreen, currentBlue = objectiveText:GetTextColor()
					objectiveText:SetTextColor(currentRed, currentGreen, currentBlue)
					objectiveText.colorHooked = true
				end
			end
			objectiveText.__windSkin = true
		end
	end

	local questRewardsFrame = _G.QuestInfoFrame.rewardsFrame
	if questRewardsFrame then
		local isQuestLogContext = _G.QuestInfoFrame.questLog ~= nil
		local currentQuestID = isQuestLogContext and C_QuestLog_GetSelectedQuest() or GetQuestID()

		if currentQuestID then
			local availableSpellRewards = C_QuestInfoSystem_GetQuestRewardSpells(currentQuestID) or {}

			if #availableSpellRewards > 0 then
				for spellHeader in questRewardsFrame.spellHeaderPool:EnumerateActive() do
					spellHeader:SetVertexColor(1, 1, 1)
				end

				-- Style follower rewards with quality-based border colors
				for followerReward in questRewardsFrame.followerRewardPool:EnumerateActive() do
					local portraitFrame = followerReward.PortraitFrame
					if portraitFrame and portraitFrame.squareBG then
						local r, g, b = E:GetItemQualityColor(portraitFrame.quality) or 1, 1, 1
						portraitFrame.squareBG:SetBackdropBorderColor(r, g, b)
					end
				end

				for spellReward in questRewardsFrame.spellRewardPool:EnumerateActive() do
					if not spellReward.__windSkin then
						if spellReward.Icon then
							spellReward.Icon:CreateBackdrop()
							spellReward.Icon:SetTexCoord(unpack(E.TexCoords))
							S:CreateBackdropShadow(spellReward.Icon)
							S:BindShadowColorWithBorder(spellReward.Icon.backdrop)
						end
						spellReward.__windSkin = true
					end
				end
			end

			for reputationReward in questRewardsFrame.reputationRewardPool:EnumerateActive() do
				if not reputationReward.__windSkin then
					if reputationReward.Icon then
						reputationReward.Icon:CreateBackdrop()
						reputationReward.Icon:SetTexCoord(unpack(E.TexCoords))
						S:CreateBackdropShadow(reputationReward.Icon)
						S:BindShadowColorWithBorder(reputationReward.Icon.backdrop)
					end
					reputationReward.__windSkin = true
				end
			end
		end
	end
end

function S:BlizzardQuestFrames()
	if not self:CheckDB("quest") then
		return
	end

	-- Apply shadow effects to main quest frames
	self:CreateShadow(_G.QuestFrame)
	self:CreateShadow(_G.QuestModelScene)
	self:CreateBackdropShadow(_G.QuestModelScene.ModelTextFrame)
	self:Reposition(_G.QuestModelScene.ModelTextFrame.backdrop, _G.QuestModelScene.ModelTextFrame, 0, 8, 5, 0, 0)
	self:CreateShadow(_G.QuestLogPopupDetailFrame)
	self:CreateShadow(_G.QuestNPCModelTextFrame)

	hooksecurefunc("QuestInfo_Display", QuestInfo_Display)

	if _G.QuestInfoItemHighlight then
		_G.QuestInfoItemHighlight:Kill()
	end

	if _G.QuestInfoSpellObjectiveFrame then
		StyleSpellObjectiveButton(_G.QuestInfoSpellObjectiveFrame)
	end

	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, buttonIndex)
		local rewardButton = rewardsFrame.RewardButtons[buttonIndex]
		if rewardButton and not rewardButton.wtRestyled then
			StyleRewardButtonWithSize(rewardButton, rewardsFrame == _G.MapQuestInfoRewardsFrame)
			rewardButton.wtRestyled = true
		end
	end)

	if _G.MapQuestInfoRewardsFrame then
		local mapRewardFrameNames = {
			"HonorFrame",
			"MoneyFrame",
			"SkillPointFrame",
			"XPFrame",
			"ArtifactXPFrame",
			"TitleFrame",
			"WarModeBonusFrame",
		}

		for _, rewardFrameName in pairs(mapRewardFrameNames) do
			local rewardFrame = _G.MapQuestInfoRewardsFrame[rewardFrameName]
			if rewardFrame then
				StyleRewardButtonWithSize(rewardFrame, true)
			end
		end

		-- Configure XP frame text shadow
		if _G.MapQuestInfoRewardsFrame.XPFrame and _G.MapQuestInfoRewardsFrame.XPFrame.Name then
			_G.MapQuestInfoRewardsFrame.XPFrame.Name:SetShadowOffset(0, 0)
		end
	end

	if _G.QuestInfoRewardsFrame then
		local questRewardFrameNames = { "HonorFrame", "SkillPointFrame", "ArtifactXPFrame", "WarModeBonusFrame" }

		for _, rewardFrameName in pairs(questRewardFrameNames) do
			local rewardFrame = _G.QuestInfoRewardsFrame[rewardFrameName]
			if rewardFrame then
				StyleRewardButtonWithSize(rewardFrame, false)
			end
		end
	end

	if _G.QuestInfoPlayerTitleFrame then
		local titleRewardFrame = _G.QuestInfoPlayerTitleFrame
		local titleIcon = titleRewardFrame.Icon

		if titleIcon then
			titleIcon:SetTexCoord(unpack(E.TexCoords))
			titleIcon:CreateBackdrop("Transparent")
		end

		-- Hide decorative regions while preserving functionality
		for regionIndex = 2, 4 do
			local region = select(regionIndex, titleRewardFrame:GetRegions())
			if region then
				region:Hide()
			end
		end

		titleRewardFrame:CreateBackdrop("Transparent")
		if titleIcon then
			titleRewardFrame.backdrop:Point("TOPLEFT", titleIcon, "TOPRIGHT", 0, 2)
			titleRewardFrame.backdrop:Point("BOTTOMRIGHT", titleIcon, "BOTTOMRIGHT", 220, -1)
		end
	end

	F.SetFont(_G.QuestNPCModelText)
	F.SetFont(_G.QuestNPCModelNameText)

	if not E.private.skins.parchmentRemoverEnable then
		return
	end

	hooksecurefunc("QuestMapFrame_ShowQuestDetails", ApplyObjectiveTextColoring)

	if _G.QuestInfoRequiredMoneyText then
		hooksecurefunc(_G.QuestInfoRequiredMoneyText, "SetTextColor", function(textFrame, redValue)
			if redValue == 0 then
				textFrame:SetTextColor(0.8, 0.8, 0.8, 1) -- Insufficient funds - muted
			elseif redValue == 0.2 then
				textFrame:SetTextColor(1, 1, 1, 1) -- Sufficient funds - white
			end
		end)
		hooksecurefunc(_G.QuestInfoRequiredMoneyText, "SetTextColor", ReplaceQuestTextColor)
	end

	local questHeaderFonts = {
		_G.QuestInfoTitleHeader,
		_G.QuestInfoDescriptionHeader,
		_G.QuestInfoObjectivesHeader,
		_G.QuestInfoRewardsFrame and _G.QuestInfoRewardsFrame.Header,
		_G.QuestInfoAccountCompletedNotice,
	}

	for _, headerFont in pairs(questHeaderFonts) do
		if headerFont then
			ConfigureYellowHeaderFont(headerFont)
		end
	end

	local questContentFonts = {
		_G.QuestInfoDescriptionText,
		_G.QuestInfoObjectivesText,
		_G.QuestInfoGroupSize,
		_G.QuestInfoRewardText,
		_G.QuestInfoTimerText,
		_G.QuestInfoSpellObjectiveLearnLabel,
		_G.QuestInfoRewardsFrame and _G.QuestInfoRewardsFrame.ItemChooseText,
		_G.QuestInfoRewardsFrame and _G.QuestInfoRewardsFrame.ItemReceiveText,
		_G.QuestInfoRewardsFrame and _G.QuestInfoRewardsFrame.PlayerTitleText,
		_G.QuestInfoRewardsFrame and _G.QuestInfoRewardsFrame.XPFrame and _G.QuestInfoRewardsFrame.XPFrame.ReceiveText,
	}

	for _, contentFont in pairs(questContentFonts) do
		if contentFont then
			ConfigureWhiteContentFont(contentFont)
		end
	end

	if _G.QuestInfoSpellObjectiveLearnLabel then
		hooksecurefunc(_G.QuestInfoSpellObjectiveLearnLabel, "SetTextColor", ReplaceQuestTextColor)
	end

	if _G.QuestInfoQuestType then
		hooksecurefunc(_G.QuestInfoQuestType, "SetTextColor", function(textFrame, redValue, greenValue, blueValue)
			if not (redValue == 1 and greenValue == 1 and blueValue == 1) then
				textFrame:SetTextColor(1, 1, 1)
			end
		end)
	end

	if _G.QuestInfoSealFrame and _G.QuestInfoSealFrame.Text then
		local sealColorReplacements = {
			["480404"] = "c20606", -- Red color replacement
			["042c54"] = "1c86ee", -- Blue color replacement
		}

		hooksecurefunc(_G.QuestInfoSealFrame.Text, "SetText", function(textFrame, textContent)
			if textContent and textContent ~= "" then
				local colorString, displayText = strmatch(textContent, "|c[fF][fF](%x%x%x%x%x%x)(.-)|r")
				if colorString and displayText then
					colorString = sealColorReplacements[colorString] or "99ccff"
					textFrame:SetFormattedText("|cff%s%s|r", colorString, displayText)
				end
			end
		end)
	end
end

S:AddCallback("BlizzardQuestFrames")
