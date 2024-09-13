local W, F, E = unpack((select(2, ...)))

local min = min
local select = select
local setmetatable = setmetatable
local tinsert = tinsert
local tremove = tremove
local type = type
local unpack = unpack

local RunNextFrame = RunNextFrame

W.Utilities.TaskScheduler = {}
local U = W.Utilities.TaskScheduler

local TaskScheduler = {}
TaskScheduler.__index = TaskScheduler

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

function TaskScheduler:DoAfterFrames(currentFrame)
	currentFrame = currentFrame or 0
	if currentFrame >= self.interval then
		self:Do()
	else
		RunNextFrame(function()
			self:DoAfterFrames(currentFrame + 1)
		end)
	end
end

function TaskScheduler:DoAfterSeconds()
	E:Delay(self.interval, self.Do, self)
end

function TaskScheduler:SetBatchSize(size)
	self.batchSize = size
end

function TaskScheduler:GetBatchSize()
	return self.batchSize
end

function TaskScheduler:SetInterval(size)
	self.interval = size
end

function TaskScheduler:GetInterval()
	return self.interval
end

function TaskScheduler:SetFrameMode(frameMode)
	self.frameMode = frameMode
end

function TaskScheduler:GetFrameMode()
	return self.frameMode
end

function TaskScheduler:SetValidator(validator)
	self.validator = validator
end

function TaskScheduler:Clear()
	self.tasks = {}
	self.doing = false
end

function TaskScheduler:GetTasks()
	return self.tasks
end

function U.New(interval, frameMode, batchSize)
	return TaskScheduler.new(interval, frameMode, batchSize)
end
