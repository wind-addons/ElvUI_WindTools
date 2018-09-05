-- 原作：任务增强
-- 原作者：wandercga（http://bbs.nga.cn/read.php?tid=7485904）
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 添加6个自定义功能开关
-- 支持 Legion 版本
-- 不显示最高等级（110）的任务等级

local E, L, V, P, G = unpack(ElvUI)
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")
local QuestListEnhanced = E:NewModule('Wind_QuestListEnhanced', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local _G = _G

-- 追踪栏显示任务等级
local function SetBlockHeader_hook()
	if not E.db.WindTools["Quest"]["Quest List Enhanced"]["enabled"] then return end
	if not E.db.WindTools["Quest"]["Quest List Enhanced"]["titlelevel"] then return end
	for i = 1, GetNumQuestWatches() do
		local questID, title, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i)
		if ( not questID ) then
			break
		end
		local oldBlock = QUEST_TRACKER_MODULE:GetExistingBlock(questID)
		if oldBlock then
			local oldHeight = QUEST_TRACKER_MODULE:SetStringText(oldBlock.HeaderText, title, nil, OBJECTIVE_TRACKER_COLOR["Header"])
			local questLevel = select(2, GetQuestLogTitle(questLogIndex))
			local newTitle = title
			-- 除去120等级的任务等级提示
			if questLevel ~= 120 or not E.db.WindTools["Quest"]["Quest List Enhanced"]["ignorehightlevel"] then
				newTitle = "["..questLevel.."] "..title
			end
				-- 燃烧王座任务名缩短
				-- newTitle = string.gsub(newTitle, "，燃烧王座", "")
				-- newTitle = string.gsub(newTitle, "，燃燒王座", "")
			local newHeight = QUEST_TRACKER_MODULE:SetStringText(oldBlock.HeaderText, newTitle, nil, OBJECTIVE_TRACKER_COLOR["Header"])
		end
	end
end

-- 任务详细信息显示任务等级
local function QuestInfo_hook(template, parentFrame, acceptButton, material, mapView)
	if not E.db.WindTools["Quest"]["Quest List Enhanced"]["enabled"] then return end
	if not E.db.WindTools["Quest"]["Quest List Enhanced"]["detaillevel"] then return end
	local elementsTable = template.elements
	for i = 1, #elementsTable, 3 do
		if elementsTable[i] == QuestInfo_ShowTitle then
			if QuestInfoFrame.questLog then
				local questLogIndex = GetQuestLogSelection()
				local level = select(2, GetQuestLogTitle(questLogIndex))
				local newTitle = "["..level.."] "..QuestInfoTitleHeader:GetText()
				QuestInfoTitleHeader:SetText(newTitle)
			end
		end
	end
end

function QuestListEnhanced:Initialize()
	if not E.db.WindTools["Quest"]["Quest List Enhanced"]["enabled"] then return end

	local trackerWidth = E.db.WindTools["Quest"]["Quest List Enhanced"]["width"]
	local vm = ObjectiveTrackerFrame

	local r, g, b = 103/255, 103/255, 103/255
	local class = select(2, UnitClass("player"))
	local colour = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
	hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
		local fontname = E.db.WindTools["Quest"]["Quest List Enhanced"]["titlefont"]
		local fontsize = E.db.WindTools["Quest"]["Quest List Enhanced"]["titlefontsize"]
		local fontflag = E.db.WindTools["Quest"]["Quest List Enhanced"]["titlefontflag"]

		block.HeaderText:SetFont(LSM:Fetch('font', fontname), fontsize, fontflag)
		block.HeaderText:SetShadowOffset(.7, -.7)
		block.HeaderText:SetShadowColor(0, 0, 0, 1)
		if E.db.WindTools["Quest"]["Quest List Enhanced"]["titlecolor"] then
			block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
		end
		block.HeaderText:SetJustifyH("Left")
		block.HeaderText:SetWidth(trackerWidth)
		local heightcheck = block.HeaderText:GetNumLines()      
		if heightcheck == 2 then
			local height = block:GetHeight()   
			block:SetHeight(height + 2)
		end

		fontname = E.db.WindTools["Quest"]["Quest List Enhanced"]["infofont"]
		fontsize = E.db.WindTools["Quest"]["Quest List Enhanced"]["infofontsize"]
		fontflag = E.db.WindTools["Quest"]["Quest List Enhanced"]["infofontflag"]

		for objectiveKey, line in pairs(block.lines) do
			line.Text:SetFont(LSM:Fetch('font', fontname), fontsize, fontflag)
		end
	end)

	local function hoverquest(_, block)
	    block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
	end
	  
	local function hoverachieve( _, block)
		block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
	end

	hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "SetBlockHeader", function(_, block)
		if not E.db.WindTools["Quest"]["Quest List Enhanced"]["enabled"] then return end
	    local trackedAchievements = {GetTrackedAchievements()}
	    
	    for i = 1, #trackedAchievements do
		    local achieveID = trackedAchievements[i]
		    local _, achievementName, _, completed, _, _, _, description, _, icon, _, _, wasEarnedByMe = GetAchievementInfo(achieveID)
	        local showAchievement = true
	        
		    if wasEarnedByMe then
			    showAchievement = false
		    elseif displayOnlyArena then
			    if GetAchievementCategory(achieveID)~=ARENA_CATEGORY then
				    showAchievement = false
			    end
		    end
		    
	        if showAchievement then
	            block.HeaderText:SetFont(STANDARD_TEXT_FONT, 13,"OUTLINE")
	            block.HeaderText:SetShadowOffset(.7, -.7)
	            block.HeaderText:SetShadowColor(0, 0, 0, 1)
	            if E.db.WindTools["Quest"]["Quest List Enhanced"]["titlecolor"] then
					block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
				end
	            block.HeaderText:SetJustifyH("Left")
	            block.HeaderText:SetWidth(trackerWidth)
	        end
	    end
	end)

	if E.db.WindTools["Quest"]["Quest List Enhanced"]["titlecolor"] then
		hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderEnter", hoverquest)  
		hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderLeave", hoverquest)
		hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "OnBlockHeaderEnter", hoverachieve)
		hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "OnBlockHeaderLeave", hoverachieve)
	end
	hooksecurefunc(QUEST_TRACKER_MODULE, "Update", SetBlockHeader_hook)
	hooksecurefunc("QuestInfo_Display", QuestInfo_hook)

	if not E.db.WindTools["Quest"]["Quest List Enhanced"]["frametitle"] then
		_G["ObjectiveTrackerFrame"].HeaderMenu.Title:Hide()
		_G["ObjectiveTrackerBlocksFrame"].QuestHeader.Text:Hide()
		hooksecurefunc("ObjectiveTracker_Collapse", function() _G["ObjectiveTrackerFrame"].HeaderMenu.Title:Hide() end)
		hooksecurefunc("ObjectiveTracker_Expand", function() _G["ObjectiveTrackerBlocksFrame"].QuestHeader.Text:Hide() end)
		if E.db.WindTools["Quest"]["Quest List Enhanced"]["leftside"] then
			local HM = _G["ObjectiveTrackerFrame"].HeaderMenu
			local ofx = -E.db.WindTools["Quest"]["Quest List Enhanced"]["leftsidesize"]-E.db.WindTools["Quest"]["Quest List Enhanced"]["width"]+8
			HM.MinimizeButton:SetPoint("TOPRIGHT", ofx, 0)
			HM.MinimizeButton:SetSize(E.db.WindTools["Quest"]["Quest List Enhanced"]["leftsidesize"], E.db.WindTools["Quest"]["Quest List Enhanced"]["leftsidesize"])
		end
	end
end

local function InitializeCallback()
	QuestListEnhanced:Initialize()
end
E:RegisterModule(QuestListEnhanced:GetName(), InitializeCallback)