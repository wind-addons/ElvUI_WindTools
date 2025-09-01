local W ---@type WindTools
local F ---@class Functions
W, F = unpack((select(2, ...)))

local module = W:NewModule("TaskManager", "AceEvent-3.0")

local tinsert = tinsert
local type = type
local unpack = unpack
local wipe = wipe
local xpcall = xpcall

local InCombatLockdown = InCombatLockdown
local hasEnteredWorld = false

---@cast F Functions

---@class Task
---@field callback function The function to call
---@field args table The arguments to pass to the function

---@class TaskManager Task queue management system
---@field Types table Task type constants
---@field Queue table Task queues organized by type
F.TaskManager = {
	Types = {
		AfterCombat = 1,
		AfterLogin = 2,
	},
	Queue = {
		AfterCombat = {},
		AfterLogin = {},
	},
}

---Initialize the TaskManager module
function module:OnInitialize()
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

---Run a single task with error handling
---@param callback function The callback function to execute
---@param args table? Arguments to pass to the callback
local function runTask(callback, args)
	if callback and type(callback) == "function" then
		xpcall(callback, F.Developer.ThrowError, unpack(args or {}))
	end
end

---Event handler for leaving combat - runs queued after-combat tasks
function module:PLAYER_REGEN_ENABLED()
	if #F.TaskManager.Queue.AfterCombat > 0 then
		for i = 1, #F.TaskManager.Queue.AfterCombat do
			runTask(unpack(F.TaskManager.Queue.AfterCombat[i]))
		end
		wipe(F.TaskManager.Queue.AfterCombat)
	end
end

---Event handler for entering world - runs queued after-login tasks
function module:PLAYER_ENTERING_WORLD()
	hasEnteredWorld = true

	if #F.TaskManager.Queue.AfterLogin > 0 then
		for i = 1, #F.TaskManager.Queue.AfterLogin do
			runTask(unpack(F.TaskManager.Queue.AfterLogin[i]))
		end
		wipe(F.TaskManager.Queue.AfterLogin)
	end
end

---Add a task to be executed after combat ends.
---@param callback function the function to call after combat ends
---@param ... any optional arguments to pass to the callback
function F.TaskManager:AfterCombat(callback, ...)
	if type(callback) ~= "function" then
		F.Developer.LogDebug("Invalid callback type, expected function")
		return
	end
	tinsert(self.Queue.AfterCombat, { callback, { ... } })
end

---Add a task to be executed out of combat.
---If not in combat, the callback is executed immediately.
---@param callback function the function to call after combat ends
---@param ... any optional arguments to pass to the callback
function F.TaskManager:OutOfCombat(callback, ...)
	if type(callback) ~= "function" then
		F.Developer.LogDebug("Invalid callback type, expected function")
		return
	end

	if not InCombatLockdown() then
		runTask(callback, { ... })
	else
		self:AfterCombat(callback, ...)
	end
end

---Add a task to be executed after login.
---@param callback function the function to call after login
---@param ... any optional arguments to pass to the callback
function F.TaskManager:AfterLogin(callback, ...)
	if type(callback) ~= "function" then
		F.Developer.LogDebug("Invalid callback type, expected function")
		return
	end

	if hasEnteredWorld then
		runTask(callback, { ... })
	else
		tinsert(self.Queue.AfterLogin, { callback, { ... } })
	end
end
