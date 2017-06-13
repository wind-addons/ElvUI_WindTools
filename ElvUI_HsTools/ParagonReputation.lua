-- 巅峰声望取代崇拜
-- 原作者：Paragon Reputation
-- 修改：无

		-----------------------------------------------
		-- Paragon Reputation 1.12 by Sev (Drakkari) --
		-----------------------------------------------

		--[[	Special thanks to Ammako for
				helping me with the vars and
				the options.					]]--

ParagonReputation = {} -- Localization
local L = ParagonReputation -- GetStrings
local faction = CreateFrame("FRAME") -- FactionName
local math = CreateFrame("FRAME") -- ReputationMath
local reward = CreateFrame("FRAME")	-- RewardToast
local id = {} -- FactionID
local rep = {} -- FactionRep
local gain = {} -- FactionRepGain
local toast = false -- ActiveToastCheck
local rewardid = {
	[46777] = 2045, -- Armies of Legionfall
	[46745] = 1900, -- Court of Farondis
	[46747] = 1883, -- Dreamweavers
	[46743] = 1828, -- Highmountain Tribes
	[46748] = 1859, -- The Nightfallen
	[46749] = 1894, -- The Wardens
	[46746] = 1948  -- Valarjar
}

faction:RegisterEvent("PLAYER_LOGIN") -- RegisterLogin/Reload
math:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE") -- RegisterReputationMessage
reward:RegisterEvent("QUEST_ACCEPTED") --RegisterQuestAccepted

-- Get Paragon Factions
faction:SetScript("OnEvent",function()
	local factionIndex = 1
	repeat
		local name, _, _, _, _, _, _, _, _, _, _, _, _, factionID = GetFactionInfo(factionIndex)
		if factionID and C_Reputation.IsFactionParagon(factionID) then
			local currentValue = C_Reputation.GetFactionParagonInfo(factionID)
			table.insert(faction,name)
			table.insert(id,factionID)
			table.insert(rep,currentValue)
			table.insert(gain,0)
		end
	factionIndex = factionIndex + 1
	until factionIndex > 200
end)

-- Calculate Reputation Gains
math:SetScript("OnEvent",function(_,_,msg,...)
	for n = 1, #faction do
		local msgrep = gsub(FACTION_STANDING_INCREASED_GENERIC,"%%s",faction[n])
		if string.match(msgrep, msg) then
			local currentValue = C_Reputation.GetFactionParagonInfo(id[n])
			gain[n] = currentValue - rep[n]
			rep[n] = rep[n] + gain[n]
		end
	end
end)

-- Filter Reputation Messages
ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_FACTION_CHANGE",function(_,_,msg,...)
	for n = 1, #faction do
		local msgrep = gsub(FACTION_STANDING_INCREASED_GENERIC,"%%s",faction[n])
		if string.match(msgrep, msg) then
			msg=format(FACTION_STANDING_INCREASED,faction[n],gain[n])
		end
	end
	return false,msg,...
end)

-- Reputation Frame
hooksecurefunc("ReputationFrame_Update",function()
	ReputationFrame.paragonFramesPool:ReleaseAll()
	local numFactions = GetNumFactions()
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
	for i=1, NUM_FACTIONS_DISPLAYED, 1 do
		local factionIndex = factionOffset + i
		local factionRow = _G["ReputationBar"..i]
		local factionBar = _G["ReputationBar"..i.."ReputationBar"]
		local factionStanding = _G["ReputationBar"..i.."ReputationBarFactionStanding"]
		if ( factionIndex <= numFactions ) then
			local _, _, _, _, _, _, _, _, _, _, _, _, _, factionID = GetFactionInfo(factionIndex)
			if factionID and C_Reputation.IsFactionParagon(factionID) then
				local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
				local value = mod(currentValue, threshold)
				if hasRewardPending then
					local paragonFrame = ReputationFrame.paragonFramesPool:Acquire()
					paragonFrame.factionID = factionID
					paragonFrame:SetPoint("RIGHT", factionRow, 11, 0)
					paragonFrame.Glow:SetShown(true)
					paragonFrame.Check:SetShown(true)
					paragonFrame:Show()
					value = value + threshold
				end
				factionBar:SetMinMaxValues(0, threshold)
				factionBar:SetValue(value)
				factionBar:SetStatusBarColor(ParagonReputationDB.r, ParagonReputationDB.g, ParagonReputationDB.b)
				factionRow.rolloverText = HIGHLIGHT_FONT_COLOR_CODE.." "..format(REPUTATION_PROGRESS_FORMAT, value, threshold)..FONT_COLOR_CODE_CLOSE
				if ParagonReputationDB.default == true then
					factionStanding:SetText(L["PARAGON"])
					factionRow.standingText = L["PARAGON"]
				elseif ParagonReputationDB.total == true  then
					factionStanding:SetText(value)
					factionRow.standingText = value
				elseif ParagonReputationDB.value == true then
					factionStanding:SetText(" "..value.." / "..threshold)
					factionRow.standingText = (" "..value.." / "..threshold)
					factionRow.rolloverText = nil					
				elseif ParagonReputationDB.deficit == true then
					if hasRewardPending then
						value = value - threshold
						factionStanding:SetText("+"..value)
						factionRow.standingText = "+"..value
					else
						value = threshold - value
						factionStanding:SetText(value)
						factionRow.standingText = value
					end
					factionRow.rolloverText = nil
				end
			end
		else
			factionRow:Hide()
		end
	end
end)

-- Reward Toast
reward:SetScript("OnEvent",function(self,event,...)
	if ParagonReputationDB.enable == true then
		local _, _, _, _, _, _, _, questID = GetQuestLogTitle(...)
		if rewardid[questID] then
			if toast == false then
				toast = true
				if ParagonReputationDB.sound == true then PlaySoundKitID(44295, "master", true) end
				local name = GetFactionInfoByID(rewardid[questID])
				local questIndex = GetQuestLogIndexByID(questID)
				local text = GetQuestLogCompletionText(questIndex)
				local reset = ParagonReputationDB.fade + 1
				paragon_toast:EnableMouse(false)
				paragon_toast_title:SetText(name)
				paragon_toast_title:SetAlpha(0)
				paragon_toast_text:SetText(text)
				paragon_toast_text:SetAlpha(0)
				paragon_toast_reset_button:Hide()
				paragon_toast_lock_button:Hide()
				UIFrameFadeIn(paragon_toast, .5, 0, 1)
				C_Timer.After(.5,function()
					UIFrameFadeIn(paragon_toast_title, .5, 0, 1)
				end)
				C_Timer.After(.75,function()
					UIFrameFadeIn(paragon_toast_text, .5, 0, 1)
				end)
				C_Timer.After(ParagonReputationDB.fade,function()
					UIFrameFadeOut(paragon_toast, 1, 1, 0)
				end)
				C_Timer.After(reset,function()
					toast = false
					paragon_toast:Hide()
				end)
			end
		end
	end
end)

-- Reputation Watchbar (Thanks Hoalz)
hooksecurefunc("MainMenuBar_UpdateExperienceBars",function()
	local name, standingID, _, _, _, factionID = GetWatchedFactionInfo()
	if standingID == MAX_REPUTATION_REACTION then
		ReputationWatchBar.StatusBar:SetAnimatedValues(1, 0, 1)
	end
	if factionID and ReputationWatchBar:IsShown() and C_Reputation.IsFactionParagon(factionID) then
		local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
		local value = mod(currentValue, threshold)
		if hasRewardPending then
			value = value + threshold
		end
		local overlayText = name.." ".. HIGHLIGHT_FONT_COLOR_CODE.." "..format(REPUTATION_PROGRESS_FORMAT, value, threshold)..FONT_COLOR_CODE_CLOSE
		ReputationWatchBar.OverlayFrame.Text:SetText(overlayText)
		ReputationWatchBar.StatusBar:SetAnimatedValues(value, 0, threshold)
		ReputationWatchBar.StatusBar:SetStatusBarColor(ParagonReputationDB.r, ParagonReputationDB.g, ParagonReputationDB.b)
	end
end)

-- Reputation Watchbar (Paragon Tooltip Hide)
hooksecurefunc("ReputationParagonWatchBar_OnEnter",function(self)
	local _, _, _, _, _, factionID = GetWatchedFactionInfo()
	local _, _, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
	if not hasRewardPending then
		ReputationParagonTooltip:Hide()
	end
end)