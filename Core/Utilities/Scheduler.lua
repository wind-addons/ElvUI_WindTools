local W ---@class WindTools
local F, E ---@type Functions, ElvUI
W, F, E = unpack((select(2, ...)))

local assert = assert
local ipairs = ipairs
local min = min
local tremove = tremove
local type = type
local unpack = unpack
local wipe = wipe

local Mixin = Mixin
local RunNextFrame = RunNextFrame

---@class SchedulerConfig Configuration for scheduler instance
---@field interval number Interval between batches (seconds or frames, default: 1)
---@field frameMode boolean Use frame-based timing instead of seconds (default: false)
---@field batchSize number Number of tasks to process per batch (default: 10)

---@class SchedulerTask Scheduler task entry
---@field func function Task function to execute
---@field args any[] Function arguments

---@class SchedulerStats Scheduler statistics
---@field totalAdded number Total number of tasks added
---@field totalExecuted number Total number of tasks executed
---@field totalSkipped number Total number of tasks skipped by validator

---@class Scheduler Task scheduler for batch processing
---@field config SchedulerConfig Scheduler configuration
---@field tasks SchedulerTask[] Array of pending tasks
---@field validator function? Optional validation function for tasks
---@field isProcessing boolean Whether scheduler is currently processing
---@field stats SchedulerStats Scheduler statistics

---Update task count statistics
---@param self Scheduler
---@param delta number Change in count (positive or negative)
local function updateStats(self, delta)
	self.stats.totalAdded = self.stats.totalAdded + delta
end

-- Forward declarations
local processBatch
local scheduleFrameBased
local scheduleTimeBased

---Execute a batch of tasks from the queue
---@param self Scheduler
processBatch = function(self)
	local tasksToExecute = min(self.config.batchSize, #self.tasks)

	for _ = 1, tasksToExecute do
		local task = tremove(self.tasks, 1)
		if task then
			if type(task.func) == "function" then
				task.func(unpack(task.args))
				self.stats.totalExecuted = self.stats.totalExecuted + 1
			end
		end
	end

	-- Continue processing if there are more tasks
	if #self.tasks > 0 then
		if self.config.frameMode then
			scheduleFrameBased(self)
		else
			scheduleTimeBased(self)
		end
	else
		self.isProcessing = false
	end
end

---Schedule next batch execution after specified frames
---@param self Scheduler
---@param currentFrame number? Current frame count (for recursion)
scheduleFrameBased = function(self, currentFrame)
	currentFrame = currentFrame or 0
	if currentFrame >= self.config.interval then
		processBatch(self)
	else
		RunNextFrame(function()
			scheduleFrameBased(self, currentFrame + 1)
		end)
	end
end

---Schedule next batch execution after time delay
---@param self Scheduler
scheduleTimeBased = function(self)
	E:Delay(self.config.interval, processBatch, self)
end

---Start processing tasks if not already running
---@param self Scheduler
local function startProcessing(self)
	if #self.tasks > 0 and not self.isProcessing then
		self.isProcessing = true
		if self.config.frameMode then
			scheduleFrameBased(self)
		else
			scheduleTimeBased(self)
		end
	end
end

---Scheduler prototype (holds all public instance methods)
---@class Scheduler
local SchedulerPrototype = {}

---Add a task to the scheduler queue
---@param func function Task function to execute
---@param ... any Arguments to pass to the function
function SchedulerPrototype:Add(func, ...)
	assert(type(func) == "function", "func must be a function")

	local args = { ... }
	local task = {
		func = func,
		args = args,
	}

	-- Validate task if validator is set
	if self.validator then
		if not self.validator(self.tasks, task) then
			self.stats.totalSkipped = self.stats.totalSkipped + 1
			return
		end
	end

	self.tasks[#self.tasks + 1] = task
	updateStats(self, 1)

	-- Start processing if not already running
	startProcessing(self)
end

---Add multiple tasks to the scheduler queue
---@param tasks table[] Array of tasks, each task is {func, arg1, arg2, ...}
function SchedulerPrototype:AddBatch(tasks)
	assert(type(tasks) == "table", "tasks must be a table")

	for _, task in ipairs(tasks) do
		assert(type(task) == "table" and #task > 0, "each task must be a non-empty table")
		local func = tremove(task, 1)
		self:Add(func, unpack(task))
	end
end

---Clear all pending tasks and stop processing
function SchedulerPrototype:Clear()
	wipe(self.tasks)
	self.isProcessing = false
end

---Get all pending tasks
---@return SchedulerTask[] tasks Array of pending tasks
function SchedulerPrototype:GetTasks()
	return self.tasks
end

---Get the number of pending tasks
---@return number count Number of pending tasks
function SchedulerPrototype:Size()
	return #self.tasks
end

---Check if scheduler is currently processing
---@return boolean isProcessing True if processing tasks
function SchedulerPrototype:IsProcessing()
	return self.isProcessing
end

---Set the batch size for task processing
---@param size number Number of tasks to process per batch
function SchedulerPrototype:SetBatchSize(size)
	assert(type(size) == "number" and size > 0, "size must be a positive number")
	self.config.batchSize = size
end

---Get the current batch size
---@return number batchSize Current batch size
function SchedulerPrototype:GetBatchSize()
	return self.config.batchSize
end

---Set the interval between task batches
---@param interval number Interval in seconds or frames
function SchedulerPrototype:SetInterval(interval)
	assert(type(interval) == "number" and interval >= 0, "interval must be a non-negative number")
	self.config.interval = interval
end

---Get the current interval
---@return number interval Current interval in seconds or frames
function SchedulerPrototype:GetInterval()
	return self.config.interval
end

---Set whether to use frame-based timing
---@param frameMode boolean True for frame-based, false for time-based
function SchedulerPrototype:SetFrameMode(frameMode)
	assert(type(frameMode) == "boolean", "frameMode must be a boolean")
	self.config.frameMode = frameMode
end

---Get the current frame mode setting
---@return boolean frameMode True if using frame-based timing
function SchedulerPrototype:GetFrameMode()
	return self.config.frameMode
end

---Set a validator function for tasks
---The validator receives (tasks, task) and should return true to accept the task
---@param validator function? Function to validate tasks before adding them, nil to remove validator
function SchedulerPrototype:SetValidator(validator)
	assert(validator == nil or type(validator) == "function", "validator must be a function or nil")
	self.validator = validator
end

---Get scheduler statistics
---@return SchedulerStats stats Current scheduler statistics
function SchedulerPrototype:GetStats()
	return {
		totalAdded = self.stats.totalAdded,
		totalExecuted = self.stats.totalExecuted,
		totalSkipped = self.stats.totalSkipped,
		pending = #self.tasks,
	}
end

---Reset scheduler statistics
function SchedulerPrototype:ResetStats()
	self.stats.totalAdded = 0
	self.stats.totalExecuted = 0
	self.stats.totalSkipped = 0
end

-- Scheduler module (public API with factory methods)
local Scheduler = {}

---Create a new task scheduler instance
---@param config SchedulerConfig? Configuration options (nil for defaults)
---@return Scheduler scheduler New task scheduler instance
function Scheduler.New(config)
	config = config or {}
	assert(type(config) == "table", "config must be a table or nil")

	-- Validate config fields
	if config.interval ~= nil then
		assert(type(config.interval) == "number" and config.interval >= 0, "interval must be a non-negative number")
	end
	if config.frameMode ~= nil then
		assert(type(config.frameMode) == "boolean", "frameMode must be a boolean")
	end
	if config.batchSize ~= nil then
		assert(type(config.batchSize) == "number" and config.batchSize > 0, "batchSize must be a positive number")
	end

	---@class Scheduler
	local instance = {
		config = {
			interval = config.interval or 1,
			frameMode = config.frameMode or false,
			batchSize = config.batchSize or 10,
		},
		tasks = {},
		validator = nil,
		isProcessing = false,
		stats = {
			totalAdded = 0,
			totalExecuted = 0,
			totalSkipped = 0,
		},
	}

	-- Mix in all instance methods from prototype
	Mixin(instance, SchedulerPrototype)

	return instance
end

W.Utilities.Scheduler = Scheduler
