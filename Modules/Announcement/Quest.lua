local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local A = W:GetModule("Announcement") ---@class Announcement
local QP = W:GetModule("QuestProgress") ---@class QuestProgress

local tostring = tostring
local UnitLevel = UnitLevel

---@cast QP QuestProgress

---@class QuestAnnounceEventType : number

---@type table<string, QuestAnnounceEventType>
A.QUEST_EVENT = {
	ACCEPTED = 1,
	COMPLETED = 2,
	OBJECTIVE_COMPLETED = 3,
	PROGRESS_UPDATE = 4,
}

---Announce quest progress to chat
---@param eventType QuestAnnounceEventType Event type
---@param context QuestProgressContext Context tables (plain text contexts)
function A:AnnounceQuestProgress(eventType, context)
	if not self.db or not self.db.enable or not self.db.quest or not self.db.quest.enable then
		return
	end

	local config = self.db.quest

	-- Check if paused (controlled by SwitchButtons module)
	if E.db.WT.quest.switchButtons.enable and config.paused then
		return
	end

	-- Determine if we should announce based on event type and settings
	local shouldAnnounce = false

	if eventType == self.QUEST_EVENT.ACCEPTED then
		shouldAnnounce = true
	elseif eventType == self.QUEST_EVENT.COMPLETED then
		shouldAnnounce = true
	elseif eventType == self.QUEST_EVENT.OBJECTIVE_COMPLETED then
		shouldAnnounce = true
	elseif eventType == self.QUEST_EVENT.PROGRESS_UPDATE then
		-- Only announce progress if includeDetails is enabled
		shouldAnnounce = config.includeDetails
	end

	if not shouldAnnounce then
		return
	end

	if context.level then
		if
			config.hideLevelOnMaxLevel and context.level == tostring(W.MaxLevelForPlayerExpansion)
			or config.hideLevelIfSameAsPlayer and context.level == tostring(UnitLevel("player"))
		then
			context.level = nil
		end
	end

	-- Render message using template and contexts
	local message = QP:RenderTemplate(config.template, context)

	if message and message ~= "" then
		self:SendMessage(message, self:GetChannel(config.channel))
	end
end
