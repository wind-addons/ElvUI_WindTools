local W ---@class WindTools
local F ---@type Functions
W, F = unpack((select(2, ...)))

local _G = _G
local assert = assert
local coroutine = coroutine
local floor = floor
local ipairs = ipairs
local pcall = pcall
local type = type
local wipe = wipe
local xpcall = xpcall

local Mixin = Mixin
local RunNextFrame = RunNextFrame

---@class ObjectFinderConfig Configuration for ObjectFinder instance
---@field parent Frame Parent frame to search within (default: UIParent)
---@field objectsPerFrame number Maximum objects to process per frame (default: 8)

---@class ObjectFinderRequest Search request entry
---@field objectType string? Type of UI object to find (e.g., "Frame", "Texture", "Button")
---@field match fun(obj: Frame): boolean Callback to check if object matches criteria
---@field callback fun(obj: Frame)? Callback to execute when match is found

---@class ObjectFinderStats ObjectFinder statistics
---@field totalRequests number Total number of search requests
---@field foundCount number Number of objects found
---@field objectsChecked number Total objects checked
---@field objectsTotal number Total objects to check

---@class ObjectFinder Asynchronous UI object finder utility
---@field config ObjectFinderConfig Finder configuration
---@field requests ObjectFinderRequest[] Array of search requests
---@field found table<number, Frame> Map of found objects by request index
---@field isRunning boolean Whether search is currently active
---@field coroutine thread? Active coroutine for processing
---@field stats ObjectFinderStats Finder statistics

-- Forward declaration
local processNextFrame

---Start the coroutine processing
---@param self ObjectFinder
local function startProcessing(self)
	if self.isRunning then
		return
	end

	self.isRunning = true
	wipe(self.found)
	self.stats.objectsChecked = 0
	self.stats.objectsTotal = 0
	self.stats.foundCount = 0
	self.stats.totalRequests = #self.requests

	self.coroutine = coroutine.create(function()
		local allObjects = { self.config.parent:GetChildren() }
		local totalObjects = #allObjects
		local checkedObjects = 0
		local totalRequests = #self.requests

		self.stats.objectsTotal = totalObjects

		while self.isRunning and checkedObjects < totalObjects and self.stats.foundCount < totalRequests do
			local endIndex = floor(checkedObjects + self.config.objectsPerFrame)
			if endIndex > totalObjects then
				endIndex = totalObjects
			end

			for i = checkedObjects + 1, endIndex do
				local obj = allObjects[i]
				if obj then
					local success, objType = pcall(function()
						return obj.GetObjectType and obj:GetObjectType()
					end)

					if success and objType then
						for requestIndex, request in ipairs(self.requests) do
							if
								not self.found[requestIndex]
								and (request.objectType == nil or objType == request.objectType)
								and request.match(obj)
							then
								self.found[requestIndex] = obj
								self.stats.foundCount = self.stats.foundCount + 1

								if request.callback then
									RunNextFrame(function()
										xpcall(request.callback, F.Developer.ThrowError, obj)
									end)
								end
							end
						end
					end
				end
				checkedObjects = i
			end

			self.stats.objectsChecked = checkedObjects

			if self.isRunning and checkedObjects < totalObjects and self.stats.foundCount < totalRequests then
				coroutine.yield()
			end
		end
	end)

	processNextFrame(self)
end

---Internal coroutine resumption handler
---Manages frame-by-frame processing to prevent UI blocking
---@param self ObjectFinder
processNextFrame = function(self)
	if not self.isRunning or not self.coroutine then
		return
	end

	local success, errorMessage = coroutine.resume(self.coroutine)
	if not success then
		self.isRunning = false
		self.coroutine = nil
		F.Developer.ThrowError(errorMessage)
		return
	end

	if coroutine.status(self.coroutine) ~= "dead" and self.isRunning then
		RunNextFrame(function()
			processNextFrame(self)
		end)
	else
		self.isRunning = false
		self.coroutine = nil
	end
end

---ObjectFinder prototype (holds all public instance methods)
---@class ObjectFinder
local ObjectFinderPrototype = {}

---Add a search request to the queue
---@param objectType string? Type of UI object to find (e.g., "Frame", "Texture", "Button") or nil for any type
---@param match fun(obj: Frame): boolean Callback to check if object matches criteria
---@param callback fun(obj: Frame)? Callback to execute when match is found
function ObjectFinderPrototype:Find(objectType, match, callback)
	assert(objectType == nil or type(objectType) == "string", "objectType must be a string or nil")
	assert(type(match) == "function", "match must be a function")
	assert(callback == nil or type(callback) == "function", "callback must be a function or nil")

	-- Prevent duplicate requests using reference comparison
	for _, existingRequest in ipairs(self.requests) do
		if
			existingRequest.objectType == objectType
			and existingRequest.match == match
			and existingRequest.callback == callback
		then
			return
		end
	end

	self.requests[#self.requests + 1] = {
		objectType = objectType,
		match = match,
		callback = callback,
	}
end

---Add multiple search requests to the queue
---@param requests ObjectFinderRequest[] Array of search requests
function ObjectFinderPrototype:FindBatch(requests)
	assert(type(requests) == "table", "requests must be a table")

	for _, request in ipairs(requests) do
		assert(type(request) == "table", "each request must be a table")
		self:Find(request.objectType, request.match, request.callback)
	end
end

---Clear all pending requests and reset found objects
function ObjectFinderPrototype:Clear()
	wipe(self.requests)
	wipe(self.found)
	self.stats.totalRequests = 0
	self.stats.foundCount = 0
end

---Get all found objects
---@return table<number, Frame> found Map of found objects by request index
function ObjectFinderPrototype:GetFound()
	return self.found
end

---Get the number of pending requests
---@return number count Number of pending requests
function ObjectFinderPrototype:Size()
	return #self.requests
end

---Check if finder is currently running
---@return boolean isRunning True if finder is processing
function ObjectFinderPrototype:IsRunning()
	return self.isRunning
end

---Set maximum number of objects to process per frame
---@param value number Positive number specifying objects per frame
function ObjectFinderPrototype:SetObjectsPerFrame(value)
	assert(type(value) == "number" and value > 0, "value must be a positive number")
	self.config.objectsPerFrame = floor(value)
end

---Get the current objects per frame setting
---@return number objectsPerFrame Current objects per frame
function ObjectFinderPrototype:GetObjectsPerFrame()
	return self.config.objectsPerFrame
end

---Set the parent frame to search within
---@param parent Frame Parent frame to search within
function ObjectFinderPrototype:SetParent(parent)
	assert(parent and parent.GetChildren, "parent must be a valid Frame with GetChildren method")
	self.config.parent = parent
end

---Get the current parent frame
---@return Frame parent Current parent frame
function ObjectFinderPrototype:GetParent()
	return self.config.parent
end

---Get finder statistics
---@return ObjectFinderStats stats Current finder statistics
function ObjectFinderPrototype:GetStats()
	return {
		totalRequests = self.stats.totalRequests,
		foundCount = self.stats.foundCount,
		objectsChecked = self.stats.objectsChecked,
		objectsTotal = self.stats.objectsTotal,
		progress = self.stats.objectsTotal > 0 and (self.stats.objectsChecked / self.stats.objectsTotal) or 0,
	}
end

---Reset finder statistics
function ObjectFinderPrototype:ResetStats()
	self.stats.totalRequests = 0
	self.stats.foundCount = 0
	self.stats.objectsChecked = 0
	self.stats.objectsTotal = 0
end

---Start processing queued search requests
---Creates a coroutine to search through UI objects over multiple frames
function ObjectFinderPrototype:Start()
	startProcessing(self)
end

---Immediately stop active search and clear state
---Terminates the search coroutine and resets the running state
function ObjectFinderPrototype:Stop()
	self.isRunning = false
	self.coroutine = nil
end

-- ObjectFinder module (public API with factory methods)
local ObjectFinder = {}

---Create a new ObjectFinder instance
---@param config ObjectFinderConfig? Configuration options (nil for defaults)
---@return ObjectFinder finder New ObjectFinder instance
function ObjectFinder.New(config)
	config = config or {}
	assert(type(config) == "table", "config must be a table or nil")

	-- Validate config fields
	if config.parent ~= nil then
		assert(config.parent.GetChildren, "parent must be a valid Frame with GetChildren method")
	end
	if config.objectsPerFrame ~= nil then
		assert(
			type(config.objectsPerFrame) == "number" and config.objectsPerFrame > 0,
			"objectsPerFrame must be a positive number"
		)
	end

	---@class ObjectFinder
	local instance = {
		config = {
			parent = config.parent or _G.UIParent,
			objectsPerFrame = config.objectsPerFrame or 8,
		},
		requests = {},
		found = {},
		isRunning = false,
		coroutine = nil,
		stats = {
			totalRequests = 0,
			foundCount = 0,
			objectsChecked = 0,
			objectsTotal = 0,
		},
	}

	-- Mix in all instance methods from prototype
	Mixin(instance, ObjectFinderPrototype)

	return instance
end

W.Utilities.ObjectFinder = ObjectFinder
