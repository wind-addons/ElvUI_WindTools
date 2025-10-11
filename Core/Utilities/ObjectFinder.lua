local W ---@class WindTools
local F ---@type Functions
W, F = unpack((select(2, ...)))

local _G = _G
local assert = assert
local coroutine = coroutine
local ipairs = ipairs
local math = math
local pcall = pcall
local setmetatable = setmetatable
local tinsert = tinsert
local type = type
local xpcall = xpcall

local RunNextFrame = RunNextFrame

---@cast F Functions

---@class ObjectFinder
---Asynchronous UI object finder utility for efficiently searching through UI hierarchies.
---Uses coroutines to process objects over multiple frames to prevent UI freezing.
local ObjectFinder = {} ---@class ObjectFinder
ObjectFinder.__index = ObjectFinder

---Create a new ObjectFinder instance
---@param parent Frame|nil Parent object to search within (defaults to UIParent)
---@return ObjectFinder instance New ObjectFinder instance
function ObjectFinder:New(parent)
	---@class ObjectFinder
	---@field parent Frame Parent frame to search within
	---@field requests table[] Array of search requests
	---@field found table<number, Frame> Map of found objects by request index
	---@field objectsPerFrame number Maximum objects to process per frame
	---@field isRunning boolean Whether search is currently active
	---@field coroutine thread|nil Active coroutine for processing
	local o = setmetatable({}, ObjectFinder)

	-- Initialize properties with proper defaults
	o.parent = parent or _G.UIParent
	o.requests = {}
	o.found = {}
	o.objectsPerFrame = 8
	o.isRunning = false
	o.coroutine = nil

	assert(o.parent and o.parent.GetChildren, "Parent must be a valid Frame with GetChildren method")

	return o
end

---Add a search request to the queue
---@param objectType? string Type of UI object to find (e.g., "Frame", "Texture", "Button") or nil for any type
---@param match fun(obj: Frame): boolean Callback to check if object matches criteria
---@param callback fun(obj: Frame) Callback to execute when match is found
function ObjectFinder:Find(objectType, match, callback)
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

	assert(type(objectType) == "string" or objectType == nil, "objectType must be a string or nil")
	assert(type(match) == "function", "match must be a function")
	assert(type(callback) == "function" or callback == nil, "callback must be a function or nil")

	tinsert(self.requests, {
		objectType = objectType,
		match = match,
		callback = callback,
	})
end

---Set maximum number of objects to process per frame
---@param value number Positive integer specifying objects per frame
function ObjectFinder:SetObjectsPerFrame(value)
	if type(value) == "number" and value > 0 then
		self.objectsPerFrame = math.floor(value)
	end
end

---Internal coroutine resumption handler
---Manages frame-by-frame processing to prevent UI blocking
---@param self ObjectFinder The ObjectFinder instance
local function processNextFrame(self)
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

---Start processing queued search requests
---Creates a coroutine to search through UI objects over multiple frames
function ObjectFinder:Start()
	if self.isRunning then
		return
	end

	self.isRunning = true
	self.found = {}

	self.coroutine = coroutine.create(function()
		local allObjects = { self.parent:GetChildren() }
		local totalObjects = #allObjects
		local checkedObjects = 0
		local totalRequests = #self.requests

		while self.isRunning and checkedObjects < totalObjects and #self.found < totalRequests do
			local endIndex = math.min(checkedObjects + self.objectsPerFrame, totalObjects)

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

			if self.isRunning and checkedObjects < totalObjects and #self.found < totalRequests then
				coroutine.yield()
			end
		end
	end)

	processNextFrame(self)
end

---Immediately stop active search and clear state
---Terminates the search coroutine and resets the running state
function ObjectFinder:Stop()
	self.isRunning = false
	self.coroutine = nil -- Break execution chain
end

W.Utilities.ObjectFinder = ObjectFinder
