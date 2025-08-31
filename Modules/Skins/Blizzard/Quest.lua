local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs
local select = select
local strmatch = strmatch
local unpack = unpack

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard
local GetQuestID = GetQuestID

local C_QuestInfoSystem_GetQuestRewardSpells = C_QuestInfoSystem.GetQuestRewardSpells
local C_QuestLog_GetNextWaypointText = C_QuestLog.GetNextWaypointText
local C_QuestLog_GetSelectedQuest = C_QuestLog.GetSelectedQuest

--[[
	Quest Frame Skinning Helper Functions
	Provides comprehensive styling for quest frames, objectives, and reward displays
--]]

-- Color constants for objective text styling
local DEFAULT_COLOR = GetMaterialTextColors("Default")
local COMPLETED_COLOR = QUEST_OBJECTIVE_COMPLETED_FONT_COLOR:GetRGB()

--[[
	Determines the appropriate quest ID based on current context
	@return number - The current quest ID
--]]
local function GetCurrentQuestID()
	if _G.QuestInfoFrame.questLog then
		return C_QuestLog_GetSelectedQuest()
	else
		return GetQuestID()
	end
end

--[[
	Applies color coding to quest objectives based on completion status
	Colors: Cyan for waypoints, Green for completed, White for incomplete
--]]
local function ApplyObjectiveTextColoring()
	if not _G.QuestInfoFrame.questLog then
		return
	end

	local questID = GetCurrentQuestID()
	local numVisibleObjectives = 0

	-- Handle waypoint objectives with cyan coloring
	local waypointText = C_QuestLog_GetNextWaypointText(questID)
	if waypointText then
		numVisibleObjectives = numVisibleObjectives + 1
		local objectiveFrame = _G["QuestInfoObjective" .. numVisibleObjectives]
		if objectiveFrame then
			objectiveFrame:SetTextColor(0, 0.82, 0.82) -- Cyan for waypoints
		end
	end

	-- Process all quest objectives
	for objectiveIndex = 1, GetNumQuestLeaderBoards() do
		local description, objectiveType, isCompleted = GetQuestLogLeaderBoard(objectiveIndex)

		-- Filter out system objectives and ensure we don't exceed display limits
		if
			description
			and objectiveType ~= "spell"
			and objectiveType ~= "log"
			and numVisibleObjectives < _G.MAX_OBJECTIVES
		then
			numVisibleObjectives = numVisibleObjectives + 1
			local objectiveFrame = _G["QuestInfoObjective" .. numVisibleObjectives]
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

--[[
	Replaces default quest text colors with enhanced visibility colors
	@param textObject - The text object to modify
	@param redValue - The red component of the current color
--]]
local function ReplaceQuestTextColor(textObject, redValue, greenValue, blueValue)
	if redValue == 0 and F.IsAlmost(greenValue, 0.82) and F.IsAlmost(blueValue, 0.82) then
		return
	elseif redValue == 0 or redValue == DEFAULT_COLOR[1] then
		textObject:SetTextColor(1, 1, 1) -- White for better readability
	elseif redValue == COMPLETED_COLOR then
		textObject:SetTextColor(0.7, 0.7, 0.7) -- Muted for completed objectives
	end
end

--[[
	Applies minimal styling to reward buttons while preserving functionality
	@param rewardButton - The reward button frame to style
--]]
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

--[[
	Applies styling to reward buttons with specific size requirements
	@param rewardButton - The reward button frame to style
	@param isMapQuestInfo - Boolean indicating if this is for the map quest info frame
--]]
local function StyleRewardButtonWithSize(rewardButton, isMapQuestInfo)
	if not rewardButton then
		return
	end

	StyleRewardButton(rewardButton)

	-- Apply size-specific adjustments based on context
	if rewardButton.Icon then
		if isMapQuestInfo then
			rewardButton.Icon:Size(29, 29) -- Smaller size for map quest info
		else
			rewardButton.Icon:Size(34, 34) -- Standard size for regular quest info
		end
	end
end

--[[
	Applies comprehensive styling to spell objective buttons
	@param spellButton - The spell objective button frame to style
--]]
local function StyleSpellObjectiveButton(spellButton)
	if not spellButton then
		return
	end

	local buttonName = spellButton:GetName()
	local spellIcon = spellButton.Icon

	-- Hide default decorative frames
	if _G[buttonName .. "NameFrame"] then
		_G[buttonName .. "NameFrame"]:Hide()
	end
	if _G[buttonName .. "SpellBorder"] then
		_G[buttonName .. "SpellBorder"]:Hide()
	end

	-- Style the spell icon
	if spellIcon then
		spellIcon:Point("TOPLEFT", 3, -2)
		spellIcon:SetDrawLayer("ARTWORK")
		spellIcon:SetTexCoord(unpack(E.TexCoords))
		S:CreateBackdropShadow(spellIcon)
	end

	-- Create background frame for the spell button
	local backgroundFrame = CreateFrame("Frame", nil, spellButton)
	backgroundFrame:Point("TOPLEFT", 2, -1)
	backgroundFrame:Point("BOTTOMRIGHT", 0, 14)
	backgroundFrame:SetFrameLevel(0)
	backgroundFrame:CreateBackdrop("Transparent")
end

--[[
	Hook function to maintain yellow text color for headers
	@param textFrame - The text frame being modified
	@param redValue - Red component of the color
	@param greenValue - Green component of the color
	@param blueValue - Blue component of the color
--]]
local function MaintainYellowTextColor(textFrame, redValue, greenValue, blueValue)
	if redValue ~= 1 or greenValue ~= 0.8 or blueValue ~= 0 then
		textFrame:SetTextColor(1, 0.8, 0) -- Force yellow color
	end
end

--[[
	Configures font with yellow coloring and outline for quest headers
	@param fontObject - The font object to configure
--]]
local function ConfigureYellowHeaderFont(fontObject)
	if not fontObject then
		return
	end

	F.SetFontOutline(fontObject)
	fontObject:SetTextColor(1, 0.8, 0) -- Yellow for headers
	fontObject:SetShadowColor(0, 0, 0, 0)
	hooksecurefunc(fontObject, "SetTextColor", MaintainYellowTextColor)
end

--[[
	Hook function to maintain white text color for content
	@param textFrame - The text frame being modified
	@param redValue - Red component of the color
	@param greenValue - Green component of the color
	@param blueValue - Blue component of the color
--]]
local function MaintainWhiteTextColor(textFrame, redValue, greenValue, blueValue)
	if redValue ~= 1 or greenValue ~= 1 or blueValue ~= 1 then
		textFrame:SetTextColor(1, 1, 1) -- Force white color
	end
end

--[[
	Configures font with white coloring and outline for quest content
	@param fontObject - The font object to configure
--]]
local function ConfigureWhiteContentFont(fontObject)
	if not fontObject then
		return
	end

	F.SetFontOutline(fontObject)
	fontObject:SetTextColor(1, 1, 1) -- White for content
	fontObject:SetShadowColor(0, 0, 0, 0)
	hooksecurefunc(fontObject, "SetTextColor", MaintainWhiteTextColor)
end

--[[
	Main quest info display function that handles dynamic styling
	Called whenever quest information is displayed or updated
--]]
local function QuestInfo_Display()
	-- Apply styling to quest objective text elements
	for _, objectiveText in pairs(_G.QuestInfoObjectivesFrame.Objectives) do
		if objectiveText and not objectiveText.__windSkin then
			if E.private.skins.parchmentRemoverEnable then
				F.SetFontOutline(objectiveText)

				-- Hook text color changes to maintain our styling
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

	-- Handle dynamic quest reward styling
	local questRewardsFrame = _G.QuestInfoFrame.rewardsFrame
	if questRewardsFrame then
		local isQuestLogContext = _G.QuestInfoFrame.questLog ~= nil
		local currentQuestID = isQuestLogContext and C_QuestLog_GetSelectedQuest() or GetQuestID()

		if currentQuestID then
			local availableSpellRewards = C_QuestInfoSystem_GetQuestRewardSpells(currentQuestID) or {}

			-- Process spell-related rewards if they exist
			if #availableSpellRewards > 0 then
				-- Style spell headers with proper coloring
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

			-- Apply minimal styling to reputation rewards while preserving icons
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

--[[
	Main initialization function for Blizzard quest frame skinning
	Sets up shadows, hooks, and applies comprehensive styling to all quest-related frames
--]]
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

	-- Hook the main quest info display function for dynamic updates
	hooksecurefunc("QuestInfo_Display", QuestInfo_Display)

	-- Remove default item highlight for cleaner appearance
	if _G.QuestInfoItemHighlight then
		_G.QuestInfoItemHighlight:Kill()
	end

	-- Apply styling to spell objective frame
	if _G.QuestInfoSpellObjectiveFrame then
		StyleSpellObjectiveButton(_G.QuestInfoSpellObjectiveFrame)
	end

	-- Hook dynamic quest reward button creation
	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, buttonIndex)
		local rewardButton = rewardsFrame.RewardButtons[buttonIndex]
		if rewardButton and not rewardButton.wtRestyled then
			StyleRewardButtonWithSize(rewardButton, rewardsFrame == _G.MapQuestInfoRewardsFrame)
			rewardButton.wtRestyled = true
		end
	end)

	-- Style static reward frames for map quest info
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

	-- Style static reward frames for regular quest info
	if _G.QuestInfoRewardsFrame then
		local questRewardFrameNames = { "HonorFrame", "SkillPointFrame", "ArtifactXPFrame", "WarModeBonusFrame" }

		for _, rewardFrameName in pairs(questRewardFrameNames) do
			local rewardFrame = _G.QuestInfoRewardsFrame[rewardFrameName]
			if rewardFrame then
				StyleRewardButtonWithSize(rewardFrame)
			end
		end
	end

	-- Style the title reward frame with proper backdrop
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

		-- Create backdrop for the title frame
		titleRewardFrame:CreateBackdrop("Transparent")
		if titleIcon then
			titleRewardFrame.backdrop:Point("TOPLEFT", titleIcon, "TOPRIGHT", 0, 2)
			titleRewardFrame.backdrop:Point("BOTTOMRIGHT", titleIcon, "BOTTOMRIGHT", 220, -1)
		end
	end

	-- Apply font outlines to model-related text elements
	F.SetFontOutline(_G.QuestNPCModelText)
	F.SetFontOutline(_G.QuestNPCModelNameText)

	-- Only Modify the text colors if parchment is disabled
	if not E.private.skins.parchmentRemoverEnable then
		return
	end

	-- Hook quest map frame for objective text coloring
	hooksecurefunc("QuestMapFrame_ShowQuestDetails", ApplyObjectiveTextColoring)

	-- Configure money requirement text color handling
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

	-- Configure yellow text styling for quest headers
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

	-- Configure white text styling for quest content
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

	-- Configure spell objective learn label text color handling
	if _G.QuestInfoSpellObjectiveLearnLabel then
		hooksecurefunc(_G.QuestInfoSpellObjectiveLearnLabel, "SetTextColor", ReplaceQuestTextColor)
	end

	-- Configure quest type text to maintain white coloring
	if _G.QuestInfoQuestType then
		hooksecurefunc(_G.QuestInfoQuestType, "SetTextColor", function(textFrame, redValue, greenValue, blueValue)
			if not (redValue == 1 and greenValue == 1 and blueValue == 1) then
				textFrame:SetTextColor(1, 1, 1)
			end
		end)
	end

	-- Configure quest seal frame text color replacement
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
