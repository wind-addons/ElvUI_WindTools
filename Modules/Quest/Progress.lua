local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local QP = W:GetModule("QuestProgress") ---@class QuestProgress : AceModule, AceEvent-3.0
local A = W:GetModule("Announcement")
local C = W.Utilities.Color
---@cast A Announcement

local _G = _G
local assert = assert
local format = format
local gsub = gsub
local pairs = pairs
local select = select
local strfind = strfind
local tCompare = tCompare
local tinsert = tinsert
local tonumber = tonumber
local tostring = tostring

local GetQuestLink = GetQuestLink
local UIErrorsFrame = _G.UIErrorsFrame

local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetQuestObjectives = C_QuestLog.GetQuestObjectives
local C_QuestLog_GetQuestTagInfo = C_QuestLog.GetQuestTagInfo

local cachedQuests ---@type table<number, QuestProgressData>

local ignoreTagIDs = {
	[128] = true, -- Emissary
	[265] = true, -- Hidden
}

---@class QuestProgressData
---@field questID number Quest ID
---@field title string Quest title
---@field link string Quest link
---@field level number Quest level
---@field suggestedGroup number Suggested group size
---@field isComplete boolean Quest completion status
---@field frequency? number Quest frequency (1=Daily, 2=Weekly)
---@field tag? string Quest tag name
---@field worldQuestType? number World quest type ID
---@field objectives QuestObjectiveData[] List of quest objectives

---@class QuestObjectiveData
---@field item string
---@field finished boolean
---@field numFulfilled number
---@field numRequired number

---@alias QuestProgressContext table<string, string?>

---Get all current quest progress data
---@return table<number, QuestProgressData> quests
local function fetchAllQuestProgressData()
	local quests = {} ---@type table<number, QuestProgressData>

	for questIndex = 1, C_QuestLog_GetNumQuestLogEntries() do
		local questInfo = C_QuestLog_GetInfo(questIndex)
		if questInfo then
			-- isHeader: Quest category header (e.g., "Highmountain-Highmountain Tribe" quests, "Highmountain" should be excluded)
			-- isBounty: Bounty quests (e.g., "The Nightfallen" quests)
			-- isHidden: Auto-accepted weekly quests (e.g., "Conqueror's Reward" weekly PvP quest)
			local skip = questInfo.isHeader or questInfo.isBounty or questInfo.isHidden
			local tagInfo = C_QuestLog_GetQuestTagInfo(questInfo.questID)

			if tagInfo and ignoreTagIDs[tagInfo.tagID] then
				skip = true
			end

			if questInfo.isOnMap and tagInfo and tagInfo.worldQuestType then
				skip = false
			end

			if questInfo.isOnMap and tagInfo and tagInfo.tagID ~= 265 then
				skip = false
			end

			if not skip then
				local objectiveData = {}
				for _, objective in pairs(C_QuestLog_GetQuestObjectives(questInfo.questID)) do
					local numFulfilled, numRequired, itemName = select(3, strfind(objective.text, "(%d+)/(%d+) ?(.*)"))
					tinsert(objectiveData, {
						item = itemName,
						finished = objective.finished,
						numFulfilled = numFulfilled,
						numRequired = numRequired,
					})
				end

				quests[questInfo.questID] = {
					title = questInfo.title,
					questID = questInfo.questID,
					level = questInfo.level,
					suggestedGroup = questInfo.suggestedGroup,
					isComplete = questInfo.isComplete,
					frequency = questInfo.frequency,
					tag = tagInfo and tagInfo.tagName,
					worldQuestType = tagInfo and tagInfo.worldQuestType,
					link = GetQuestLink(questInfo.questID),
					objectives = objectiveData,
				}
			end
		end
	end

	return quests
end

---Apply color to placeholder text
---@param text? string|number
---@param template string
---@param color { left: RGB, right: RGB }
---@return  string? plainText
---@return  string? coloredText
local function render(text, template, color)
	if not text then
		return
	end
	text = format(template, tostring(text))
	return text, C.GradientStringByRGB(text, color.left, color.right)
end

---Render template with contexts
---@param template string
---@param context QuestProgressContext
---@return string
function QP:RenderTemplate(template, context)
	local result = gsub(template, "{{(%w+)}}", function(key)
		return context[key] or ""
	end)

	result = gsub(result, "%s+", " ")
	result = gsub(result, "^%s+", "")
	result = gsub(result, "%s+$", "")

	return result
end

---@param data QuestProgressData
---@return QuestProgressContext plainContext
---@return QuestProgressContext coloredContext
function QP:BuildQuestContext(data)
	local db = self.db
	local plainContext, coloredContext = {}, {}

	plainContext.tag, coloredContext.tag = render(data.tag, db.tag.template, db.tag.color)
	plainContext.title, coloredContext.title = render(data.title, db.title.template, db.title.color)
	plainContext.level, coloredContext.level = render(data.level, db.level.template, db.level.color)
	plainContext.link, coloredContext.link = data.link, data.link

	if data.frequency then
		if data.frequency == 1 then
			plainContext.daily, coloredContext.daily = render(data.link, db.daily.template, db.daily.color)
		elseif data.frequency == 2 then
			plainContext.weekly, coloredContext.weekly = render(data.link, db.weekly.template, db.weekly.color)
		end
	end

	if data.suggestedGroup > 1 then
		plainContext.suggestedGroup, coloredContext.suggestedGroup =
			render(data.suggestedGroup, db.suggestedGroup.template, db.suggestedGroup.color)
	end

	if data.level ~= E.mylevel then
		plainContext.autoHideLevel, coloredContext.autoHideLevel = plainContext.level, coloredContext.level
	end

	return plainContext, coloredContext
end

function QP:ProcessQuestUpdate()
	local currentQuests = fetchAllQuestProgressData()

	if not cachedQuests then
		cachedQuests = currentQuests
		return
	end

	for id, questData in pairs(currentQuests) do
		local previousQuestData = cachedQuests[id]
		if not previousQuestData then
			if not questData.worldQuestType then
				self:HandleQuestProgress("accepted", questData)
			end
		elseif not previousQuestData.isComplete then
			if questData.isComplete then
				self:HandleQuestProgress("complete", questData)
			elseif #previousQuestData.objectives > 0 and #questData.objectives > 0 then
				for objectiveIndex = 1, #questData.objectives do
					local objectiveData = questData.objectives[objectiveIndex]
					local previousObjectiveData = previousQuestData.objectives[objectiveIndex]
					if not previousObjectiveData or not tCompare(objectiveData, previousObjectiveData) then
						if objectiveData.numFulfilled and tonumber(objectiveData.numFulfilled) > 0 then
							self:HandleQuestProgress("update", questData, objectiveData)
						end
					end
				end
			end
		end
	end

	cachedQuests = currentQuests
end

---@param context QuestProgressContext
---@return QuestProgressContext
function QP:FilterContext(context)
	-- Use autoHideLevel for level if hideOnCharacterLevel is enabled
	if self.db.level.hideOnCharacterLevel and context.level then
		context.level = context.autoHideLevel
	end

	context.autoHideLevel = nil

	return context
end

---Handle quest progress update event
---@param status "accepted" | "update" | "complete"
---@param questData QuestProgressData
---@param objectiveData? QuestObjectiveData
function QP:HandleQuestProgress(status, questData, objectiveData)
	local plainContext, coloredContext = self:BuildQuestContext(questData)
	if status == "accepted" then
		local db = self.db.progress.accepted
		plainContext.progress, coloredContext.progress = render(L["Accepted"], db.template, db.color)
		coloredContext.icon = format("|T%s:0|t", W.Media.Icons.accept)
	elseif status == "complete" then
		local db = self.db.progress.complete
		plainContext.progress, coloredContext.progress = render(L["Complete"], db.template, db.color)
	elseif status == "update" then
		assert(objectiveData, "Objective data is required for progress update")
		local db = self.db.progress.objective
		local objectiveText, coloredObjectiveText = render(objectiveData.item, "%s", db.color)
		local progressText = format(db.detailTemplate, objectiveData.numFulfilled, objectiveData.numRequired)
		local progressColor = F.GetProgressColor(objectiveData.numFulfilled / objectiveData.numRequired)
		local coloredProgressText = C.StringWithRGB(progressText, progressColor)
		plainContext.progress = format("%s %s", objectiveText, progressText)
		coloredContext.progress = format("%s %s", coloredObjectiveText, coloredProgressText)
		coloredContext.icon = objectiveData.finished and format("|T%s:0|t", W.Media.Icons.complete) or ""
	end

	-- Send to UIErrorsFrame
	if self.db.enable then
		local message = self:RenderTemplate(self.db.displayTemplate, self:FilterContext(coloredContext))
		UIErrorsFrame:AddMessage(message)
	end

	-- Send to announcement module
	local event ---@type QuestAnnounceEventType
	if status == "accepted" then
		event = A.QUEST_EVENT.ACCEPTED
	elseif status == "complete" then
		event = A.QUEST_EVENT.COMPLETED
	elseif status == "update" then
		if objectiveData and objectiveData.finished then
			event = A.QUEST_EVENT.OBJECTIVE_COMPLETED
		else
			event = A.QUEST_EVENT.PROGRESS_UPDATE
		end
	end

	A:AnnounceQuestProgress(event, plainContext)
end

do
	local ERR_QUEST_ADD_ITEM_SII = ERR_QUEST_ADD_ITEM_SII
	local ERR_QUEST_ADD_FOUND_SII = ERR_QUEST_ADD_FOUND_SII
	local ERR_QUEST_ADD_KILL_SII = ERR_QUEST_ADD_KILL_SII
	local ERR_QUEST_UNKNOWN_COMPLETE = ERR_QUEST_UNKNOWN_COMPLETE
	local ERR_QUEST_OBJECTIVE_COMPLETE_S = ERR_QUEST_OBJECTIVE_COMPLETE_S

	function QP:UpdateBlizzardQuestMessage()
		local disabled = not (self.db and self.db.enable)
		_G.ERR_QUEST_ADD_ITEM_SII = disabled and ERR_QUEST_ADD_ITEM_SII or W.UIERRORFRAME_IGNORE_PATTERN
		_G.ERR_QUEST_ADD_FOUND_SII = disabled and ERR_QUEST_ADD_FOUND_SII or W.UIERRORFRAME_IGNORE_PATTERN
		_G.ERR_QUEST_ADD_KILL_SII = disabled and ERR_QUEST_ADD_KILL_SII or W.UIERRORFRAME_IGNORE_PATTERN
		_G.ERR_QUEST_UNKNOWN_COMPLETE = disabled and ERR_QUEST_UNKNOWN_COMPLETE or W.UIERRORFRAME_IGNORE_PATTERN
		_G.ERR_QUEST_OBJECTIVE_COMPLETE_S = disabled and ERR_QUEST_OBJECTIVE_COMPLETE_S or W.UIERRORFRAME_IGNORE_PATTERN
	end
end

function QP:QUEST_LOG_UPDATE()
	F.TaskManager:AfterLogin(self.ProcessQuestUpdate, self)
end

---Fetch the context for preview or test
---@return QuestProgressContext plainContext
---@return QuestProgressContext coloredContext
function QP:GetTestContext()
	return self:BuildQuestContext({
		questID = 39987,
		title = L["Test Quest Name"],
		level = 99,
		suggestedGroup = 30,
		isComplete = false,
		frequency = 1,
		tag = L["Test Series"],
		link = format("|cffffff00|Hquest:39987:335|h[%s]|h|r", L["Test Quest Name"]),
		objectives = {},
	})
end

function QP:Initialize()
	self.db = E.db.WT.quest.progress

	if not self.db.enable then
		if self.initialized then
			self:UpdateBlizzardQuestMessage()
		end
		return
	end

	if not self.initialized then
		self:RegisterEvent("QUEST_LOG_UPDATE")
		self.initialized = true
	end

	F.TaskManager:AfterLogin(self.UpdateBlizzardQuestMessage, self)
end

QP.ProfileUpdate = QP.Initialize

W:RegisterModule(QP:GetName())
