local W, F, E, L, V, P, G = unpack((select(2, ...)))

local module = W:NewModule("TaskManager", "AceEvent-3.0")

local tinsert = tinsert
local type = type
local unpack = unpack
local wipe = wipe
local xpcall = xpcall

local InCombatLockdown = InCombatLockdown

F.TaskManager = {
	Types = {
		AfterCombat = 1,
	},
	Queue = {
		-- { callback, args }
		AfterCombat = {},
	},
}

function module:OnInitialize()
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

local function runTask(callback, args)
	if callback and type(callback) == "function" then
		xpcall(callback, F.Developer.ThrowError, unpack(args or {}))
	end
end

function module:PLAYER_REGEN_ENABLED()
	if #F.TaskManager.Queue.AfterCombat > 0 then
		for i = 1, #F.TaskManager.Queue.AfterCombat do
			F.Developer.LogDebug("Running queued task after combat")
			runTask(unpack(F.TaskManager.Queue.AfterCombat[i]))
		end
		wipe(F.TaskManager.Queue.AfterCombat)
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

	F.Developer.LogDebug("Queueing task for after combat")
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
		F.Developer.LogDebug("Running task immediately")
		runTask(callback, { ... })
	else
		self:AfterCombat(callback, ...)
	end
end
