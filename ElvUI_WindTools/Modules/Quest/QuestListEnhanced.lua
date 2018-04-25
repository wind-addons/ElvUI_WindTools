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
local WT = E:GetModule("WindTools")
local QuestListEnhanced = E:NewModule('QuestListEnhanced', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

P["WindTools"]["Quest List Enhanced"] = {
	["enabled"] = true,
	["titlecolor"] = true,
	["titlelevel"] = true,
	["detaillevel"] = true,
	["titlefontsize"] = 13,
	["height"] = 450,
	["width"] = 240,
}
if not E.db.WindTools["Quest List Enhanced"]["enabled"] then return end

local vmheight = E.db.WindTools["Quest List Enhanced"]["height"]
local vmwidth = E.db.WindTools["Quest List Enhanced"]["width"]
local vm = ObjectiveTrackerFrame

-- 任务追踪名称职业着色 -------------------------------------------------------
local r, g, b = 103/255, 103/255, 103/255
local class = select(2, UnitClass("player"))
local colour = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
block.HeaderText:SetFont(STANDARD_TEXT_FONT, E.db.WindTools["Quest List Enhanced"]["titlefontsize"], "OUTLINE")
block.HeaderText:SetShadowOffset(.7, -.7)
block.HeaderText:SetShadowColor(0, 0, 0, 1)
if E.db.WindTools["Quest List Enhanced"]["titlecolor"] then
	block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
end
block.HeaderText:SetJustifyH("Left")
block.HeaderText:SetWidth(vmwidth)
local heightcheck = block.HeaderText:GetNumLines()      
	if heightcheck == 2 then
		local height = block:GetHeight()     
		block:SetHeight(height + 2)
	end
end)

local function hoverquest(_, block)
	if not E.db.WindTools["Quest List Enhanced"]["titlecolor"] then return end
    block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
end

hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderEnter", hoverquest)  
hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderLeave", hoverquest)
hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "SetBlockHeader", function(_, block)
	if not E.db.WindTools["Quest List Enhanced"]["enabled"] then return end
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
            if E.db.WindTools["Quest List Enhanced"]["titlecolor"] then
				block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
			end
            block.HeaderText:SetJustifyH("Left")
            block.HeaderText:SetWidth(vmwidth)
        end
    end
end)
  
local function hoverachieve(_, block)
	if not (E.db.WindTools["Quest List Enhanced"]["enabled"] or E.db.WindTools["Quest List Enhanced"]["titlecolor"]) then return end
	block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
end
  
hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "OnBlockHeaderEnter", hoverachieve)
hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "OnBlockHeaderLeave", hoverachieve)


-- 追踪栏显示任务等级
local QuestLevelPatch = {}
function SetBlockHeader_hook()
	if not E.db.WindTools["Quest List Enhanced"]["enabled"] then return end
	if not E.db.WindTools["Quest List Enhanced"]["titlelevel"] then return end
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
			-- 除去110等级的任务等级提示
			if questLevel ~= 110 then
				newTitle = "["..questLevel.."] "..title
			end
				-- 燃烧王座任务名缩短
				newTitle = string.gsub(newTitle, "，燃烧王座", "")
				newTitle = string.gsub(newTitle, "，燃燒王座", "")
			local newHeight = QUEST_TRACKER_MODULE:SetStringText(oldBlock.HeaderText, newTitle, nil, OBJECTIVE_TRACKER_COLOR["Header"])
		end
	end
end
hooksecurefunc(QUEST_TRACKER_MODULE, "Update", SetBlockHeader_hook)

-- 任务详细信息显示任务等级
function QuestInfo_hook(template, parentFrame, acceptButton, material, mapView)
	if not E.db.WindTools["Quest List Enhanced"]["enabled"] then return end
	if not E.db.WindTools["Quest List Enhanced"]["detaillevel"] then return end
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
hooksecurefunc("QuestInfo_Display", QuestInfo_hook)

local function InsertOptions()
	E.Options.args.WindTools.args["Quest"].args["Quest List Enhanced"].args["additionalconfig"] = {
		order = 10,
		type = "group",
		name = L["Setting"],
		args = {
			setfont = {
				order = 1,
				type = "range",
				name = L["Title fontsize"],
				min = 8, max = 19, step = 1,
				get = function(info) return E.db.WindTools["Quest List Enhanced"]["titlefontsize"] end,
				set = function(info, value) E.db.WindTools["Quest List Enhanced"]["titlefontsize"] = value;end
			},
			titlecolor = {
				order = 2,
				type = "toggle",
				name = L["Class Color"],
				get = function(info) return E.db.WindTools["Quest List Enhanced"]["titlecolor"] end,
				set = function(info, value) E.db.WindTools["Quest List Enhanced"]["titlecolor"] = value; E:StaticPopup_Show("PRIVATE_RL")end
			},
			titlelevel = {
				order = 3,
				type = "toggle",
				name = L["Tracker Level"],
				desc = L["Display level info in quest title (Tracker)"],
				get = function(info) return E.db.WindTools["Quest List Enhanced"]["titlelevel"] end,
				set = function(info, value) E.db.WindTools["Quest List Enhanced"]["titlelevel"] = value;end
			},
			detaillevel = {
				order = 4,
				type = "toggle",
				name = L["Quest details level"],
				desc = L["Display level info in quest title (Quest details)"],
				get = function(info) return E.db.WindTools["Quest List Enhanced"]["detaillevel"] end,
				set = function(info, value) E.db.WindTools["Quest List Enhanced"]["detaillevel"] = value;end
			},
			frameheight = {
				order = 5,
				type = 'range',
				name = L["Tracker height"],
				min = 350, max = 550, step = 1,
				get = function(info) return E.db.WindTools["Quest List Enhanced"]["height"] end,
				set = function(info, value) E.db.WindTools["Quest List Enhanced"]["height"] = value;end
			},
			framewidth = {
				order = 6,
				type = 'range',
				name = L["Tracker width"],
				min = 200, max = 300, step = 1,
				get = function(info) return E.db.WindTools["Quest List Enhanced"]["width"] end,
				set = function(info, value) E.db.WindTools["Quest List Enhanced"]["width"] = value;end
			},
		}
	}
end
WT.ToolConfigs["Quest List Enhanced"] = InsertOptions
E:RegisterModule(QuestListEnhanced:GetName())