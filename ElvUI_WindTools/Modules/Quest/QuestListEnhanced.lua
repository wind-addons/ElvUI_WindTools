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
local QuestListEnhanced = E:NewModule('QuestListEnhanced', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local _G = _G

P["WindTools"]["Quest List Enhanced"] = {
	["enabled"] = true,
	["titlecolor"] = true,
	["titlelevel"] = true,
	["detaillevel"] = true,
	["titlefont"] = E.db.general.font,
	["titlefontsize"] = 14,
	["titlefontflag"] = "OUTLINE",
	["infofont"] = E.db.general.font,
	["infofontsize"] = 12,
	["infofontflag"] = "OUTLINE",
	["ignorehightlevel"] = true,
	["width"] = 240,
	["iconshadow"] = true,
	["frametitle"] = true,
	["leftside"] = true,
	["leftsidesize"] = 18,
}

-- 追踪栏显示任务等级
local function SetBlockHeader_hook()
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
			-- 除去120等级的任务等级提示
			if questLevel ~= 120 or not E.db.WindTools["Quest List Enhanced"]["ignorehightlevel"] then
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

local function shadowQuestIcon(_, block)
	local itemButton = block.itemButton
	if itemButton and not itemButton.styled then
		itemButton:CreateShadow()
		itemButton.styled = true
	end
	local rightButton = block.rightButton
	if rightButton and not rightButton.styled then
		rightButton:CreateShadow()
		rightButton.styled = true
	end
end

function QuestListEnhanced:Initialize()
	if not E.db.WindTools["Quest List Enhanced"]["enabled"] then return end

	local trackerWidth = E.db.WindTools["Quest List Enhanced"]["width"]
	local vm = ObjectiveTrackerFrame

	local r, g, b = 103/255, 103/255, 103/255
	local class = select(2, UnitClass("player"))
	local colour = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
	hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
		local fontname = E.db.WindTools["Quest List Enhanced"]["titlefont"]
		local fontsize = E.db.WindTools["Quest List Enhanced"]["titlefontsize"]
		local fontflag = E.db.WindTools["Quest List Enhanced"]["titlefontflag"]

		block.HeaderText:SetFont(LSM:Fetch('font', fontname), fontsize, fontflag)
		block.HeaderText:SetShadowOffset(.7, -.7)
		block.HeaderText:SetShadowColor(0, 0, 0, 1)
		if E.db.WindTools["Quest List Enhanced"]["titlecolor"] then
			block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
		end
		block.HeaderText:SetJustifyH("Left")
		block.HeaderText:SetWidth(trackerWidth)
		local heightcheck = block.HeaderText:GetNumLines()      
		if heightcheck == 2 then
			local height = block:GetHeight()   
			block:SetHeight(height + 2)
		end

		fontname = E.db.WindTools["Quest List Enhanced"]["infofont"]
		fontsize = E.db.WindTools["Quest List Enhanced"]["infofontsize"]
		fontflag = E.db.WindTools["Quest List Enhanced"]["infofontflag"]

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
	            block.HeaderText:SetWidth(trackerWidth)
	        end
	    end
	end)

	if E.db.WindTools["Quest List Enhanced"]["titlecolor"] then
		hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderEnter", hoverquest)  
		hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderLeave", hoverquest)
		hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "OnBlockHeaderEnter", hoverachieve)
		hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "OnBlockHeaderLeave", hoverachieve)
	end
	hooksecurefunc(QUEST_TRACKER_MODULE, "Update", SetBlockHeader_hook)
	hooksecurefunc("QuestInfo_Display", QuestInfo_hook)

	if E.db.WindTools["Quest List Enhanced"]["iconshadow"] then
		hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", shadowQuestIcon)
		hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", shadowQuestIcon)
	end

	if not E.db.WindTools["Quest List Enhanced"]["frametitle"] then
		_G["ObjectiveTrackerFrame"].HeaderMenu.Title:Hide()
		_G["ObjectiveTrackerBlocksFrame"].QuestHeader.Text:Hide()
		hooksecurefunc("ObjectiveTracker_Collapse", function() _G["ObjectiveTrackerFrame"].HeaderMenu.Title:Hide() end)
		hooksecurefunc("ObjectiveTracker_Expand", function() _G["ObjectiveTrackerBlocksFrame"].QuestHeader.Text:Hide() end)
		if E.db.WindTools["Quest List Enhanced"]["leftside"] then
			local HM = _G["ObjectiveTrackerFrame"].HeaderMenu
			local ofx = -E.db.WindTools["Quest List Enhanced"]["leftsidesize"]-E.db.WindTools["Quest List Enhanced"]["width"]+8
			HM.MinimizeButton:SetPoint("TOPRIGHT", ofx, 0)
			HM.MinimizeButton:SetSize(E.db.WindTools["Quest List Enhanced"]["leftsidesize"], E.db.WindTools["Quest List Enhanced"]["leftsidesize"])
		end
	end
end

local function InsertOptions()
	local Options = {
		general = {
			order = 11,
			type = 'group',
			name = L['General'],
			guiInline = true,
			get = function(info) return E.db.WindTools["Quest List Enhanced"][info[#info]] end,
			set = function(info, value) E.db.WindTools["Quest List Enhanced"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL")end,
			args = {
				titlefont = {
					type = 'select', dialogControl = 'LSM30_Font',
					order = 1,
					name = L['Name Font'],
					values = LSM:HashTable('font'),
				},
				titlefontsize = {
					order = 2,
					name = L['Name Font Size'],
					type = 'range',
					min = 6, max = 22, step = 1,
				},
				titlefontflag = {
					name = L["Name Font Flag"],
					order = 3,
					type = 'select',
					values = {
						['NONE'] = L['None'],
						['OUTLINE'] = L['OUTLINE'],
						['MONOCHROME'] = L['MONOCHROME'],
						['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
						['THICKOUTLINE'] = L['THICKOUTLINE'],
					},
				},
				infofont = {
					type = 'select', dialogControl = 'LSM30_Font',
					order = 4,
					name = L['Info Font'],
					values = LSM:HashTable('font'),
				},
				infofontsize = {
					order = 5,
					name = L["Info Font Size"],
					type = 'range',
					min = 6, max = 22, step = 1,
				},
				infofontflag = {
					name = L["Info Font Outline"],
					order = 6,
					type = 'select',
					values = {
						['NONE'] = L['None'],
						['OUTLINE'] = L['OUTLINE'],
						['MONOCHROME'] = L['MONOCHROME'],
						['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
						['THICKOUTLINE'] = L['THICKOUTLINE'],
					},
				},
				titlecolor = {
					order = 7,
					type = "toggle",
					name = L["Class Color"],
				},
			},
		},
		level = {
			order = 12,
			type = 'group',
			name = L['Level'],
			guiInline = true,
			get = function(info) return E.db.WindTools["Quest List Enhanced"][info[#info]] end,
			set = function(info, value) E.db.WindTools["Quest List Enhanced"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL")end,
			args = {
				titlelevel = {
					order = 1,
					type = "toggle",
					name = L["Tracker Level"],
					desc = L["Display level info in quest title (Tracker)"],
				},
				detaillevel = {
					order = 2,
					type = "toggle",
					name = L["Quest details level"],
					desc = L["Display level info in quest title (Quest details)"],
				},
				ignorehighlevel = {
					order = 3,
					type = "toggle",
					name = L["Ignore high level"],
				},
			},
		},
		leftsidemode = {
			order = 13,
			type = 'group',
			name = L["Left Side Minimize Button"],
			guiInline = true,
			disabled = E.db.WindTools["Quest List Enhanced"]["frametitle"],
			set = function(info, value) E.db.WindTools["Quest List Enhanced"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL")end,
			args = {
				leftside = {
					order = 4,
					type  = "toggle",
					name  = L["Enable"],
					get = function(info)
						if not E.db.WindTools["Quest List Enhanced"]["frametitle"] then
							return E.db.WindTools["Quest List Enhanced"]["leftside"]
						else
							return false
						end
					end,
				},
				leftsidesize = {
					order = 5,
					type  = 'range',
					name  = L["Size"],
					get = function(info) return E.db.WindTools["Quest List Enhanced"]["leftsidesize"] end,
					min   = 10,
					max   = 30,
					step  = 1,
				},
			}
		},
		other = {
			order = 14,
			type = 'group',
			name = L['Others'],
			guiInline = true,
			get = function(info) return E.db.WindTools["Quest List Enhanced"][info[#info]] end,
			set = function(info, value) E.db.WindTools["Quest List Enhanced"][info[#info]] = value; E:StaticPopup_Show("PRIVATE_RL")end,
			args = {
				width = {
					order = 1,
					type = 'range',
					name = L["Tracker width"],
					min = 200, max = 300, step = 1,
				},
				iconshadow = {
					order = 2,
					type = "toggle",
					name = L["Icon with Shadow"],
				},
				frametitle = {
					order = 4,
					type = "toggle",
					name = L["Frame Title"],
				},
			},
		},
	}
	
	for k, v in pairs(Options) do
		E.Options.args.WindTools.args["Quest"].args["Quest List Enhanced"].args[k] = v
	end
end
WT.ToolConfigs["Quest List Enhanced"] = InsertOptions
E:RegisterModule(QuestListEnhanced:GetName())