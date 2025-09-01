local W ---@class WindTools
local F ---@type Functions
local E ---@type ElvUI
W, F, E = unpack((select(2, ...)))

local min = min
local select = select
local setmetatable = setmetatable
local tinsert = tinsert
local tremove = tremove
local type = type
local unpack = unpack

local RunNextFrame = RunNextFrame

---@cast F Functions

---@class TaskSchedulerUtility Utility namespace for task scheduler
W.Utilities.TaskScheduler = {}

---@class TaskScheduler Task scheduler for batch processing
---@field tasks table[] Array of pending tasks
---@field frameMode boolean Whether to use frame-based timing
---@field interval number Interval between batches (seconds or frames)
---@field batchSize number Number of tasks to process per batch
---@field doing boolean Whether scheduler is currently processing
---@field count number Total number of tasks added
---@field validator function? Optional validation function for tasks
local TaskScheduler = {}
TaskScheduler.__index = TaskScheduler

---Create a new task scheduler instance
---@param interval number? Interval between batches (default: 1)
---@param frameMode boolean? Use frame-based timing instead of seconds (default: false)
---@param batchSize number? Number of tasks per batch (default: 10)
---@return TaskScheduler scheduler New task scheduler instance
function TaskScheduler.new(interval, frameMode, batchSize)
	return setmetatable({
		tasks = {},
		frameMode = frameMode or false,
		interval = interval or 1,
		batchSize = batchSize or 10,
		doing = false,
		count = 0,
	}, TaskScheduler)
end

---Add a task to the scheduler queue
---@param ... any Task function and its arguments (first argument must be function)
function TaskScheduler:Add(...)
	self.count = self.count + 1
	local args = { ... }

	if self.validator and self.validator(self.tasks, args) then
		tinsert(self.tasks, { ... })
	end

	if #self.tasks > 0 and not self.doing then
		self.doing = true
		if #self.tasks > 0 then
			if self.frameMode then
				self:DoAfterFrames()
			else
				self:DoAfterSeconds()
			end
		end
	end
end

---Execute a batch of tasks from the queue
function TaskScheduler:Do()
	local tasksToExecute = min(self.batchSize, #self.tasks)

	for _ = 1, tasksToExecute do
		local task = tremove(self.tasks, 1)
		if task then
			local func = task[1]
			if type(func) == "function" then
				func(select(2, unpack(task)))
			end
		end
	end

	if #self.tasks > 0 then
		if self.frameMode then
			self:DoAfterFrames()
		else
			self:DoAfterSeconds()
		end
	else
		self.doing = false
	end
end

---Execute tasks after a specified number of frames
---@param currentFrame number? Current frame count (internal use)
function TaskScheduler:DoAfterFrames(currentFrame)
	currentFrame = currentFrame or 0
	if currentFrame >= self.interval then
		self:Do()
	else
		RunNextFrame(function()
			---Recursively wait for next frame
			self:DoAfterFrames(currentFrame + 1)
		end)
	end
end

---Execute tasks after a time delay in seconds
function TaskScheduler:DoAfterSeconds()
	E:Delay(self.interval, self.Do, self)
end

---Set the batch size for task processing
---@param size number Number of tasks to process per batch
function TaskScheduler:SetBatchSize(size)
	self.batchSize = size
end

---Get the current batch size
---@return number batchSize Current batch size
function TaskScheduler:GetBatchSize()
	return self.batchSize
end

---Set the interval between task batches
---@param size number Interval in seconds or frames
function TaskScheduler:SetInterval(size)
	self.interval = size
end

---Get the current interval
---@return number interval Current interval in seconds or frames
function TaskScheduler:GetInterval()
	return self.interval
end

---Set whether to use frame-based timing
---@param frameMode boolean True for frame-based, false for time-based
function TaskScheduler:SetFrameMode(frameMode)
	self.frameMode = frameMode
end

---Get the current frame mode setting
---@return boolean frameMode True if using frame-based timing
function TaskScheduler:GetFrameMode()
	return self.frameMode
end

---Set a validator function for tasks
---@param validator function Function to validate tasks before adding them
function TaskScheduler:SetValidator(validator)
	self.validator = validator
end

---Clear all pending tasks and stop processing
function TaskScheduler:Clear()
	self.tasks = {}
	self.doing = false
end

---Get all pending tasks
---@return table[] tasks Array of pending tasks
function TaskScheduler:GetTasks()
	return self.tasks
end

---Create a new task scheduler instance
---@param interval number? Interval between batches (default: 1)
---@param frameMode boolean? Use frame-based timing instead of seconds (default: false)
---@param batchSize number? Number of tasks per batch (default: 10)
---@return TaskScheduler scheduler New task scheduler instance
function W.Utilities.TaskScheduler.New(interval, frameMode, batchSize)
	return TaskScheduler.new(interval, frameMode, batchSize)
end
