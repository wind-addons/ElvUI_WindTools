local W, F, E, L = unpack((select(2, ...)))
local CH = W:NewModule("ClassHelper", "AceEvent-3.0", "AceHook-3.0")

local pairs = pairs
local type = type
local xpcall = xpcall

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

local eventHandlers = {}
local cleuHandlers = {}
local initFunctions = {}
local profileUpdateFunctions = {}
local checkRequirementFunctions = {}

function CH:EventHandler(event, ...)
	if not eventHandlers[event] then
		return
	end

	for _, func in pairs(eventHandlers[event]) do
		xpcall(func, F.Developer.ThrowError, self, event, ...)
	end
end

function CH:CLEUHandler()
	local params = { CombatLogGetCurrentEventInfo() }
	if params and params[2] and cleuHandlers[params[2]] then
		for _, func in pairs(cleuHandlers[params[2]]) do
			xpcall(func, F.Developer.ThrowError, self, params)
		end
	end
end

function CH:RegisterEvents()
	for event, _ in pairs(eventHandlers) do
		self:RegisterEvent(event, "EventHandler")
	end

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "CLEUHandler")
end

function CH:UnregisterEvents()
	for event, _ in pairs(eventHandlers) do
		self:UnregisterEvent(event)
	end

	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function CH:RegisterHelper(helper)
	if type(helper) == "string" then
		helper = self[helper]
		if not helper then
			self:Log("debug", "[RegisterHelper] Invalid helper name: " .. helper)
			return
		end
	end

	for event, callback in pairs(helper.eventHandlers) do
		if not eventHandlers[event] then
			eventHandlers[event] = {}
		end

		eventHandlers[event][helper.name] = callback
	end

	for subevent, callback in pairs(helper.cleuHandlers) do
		if not cleuHandlers[subevent] then
			cleuHandlers[subevent] = {}
		end

		cleuHandlers[subevent][helper.dbKey] = callback
	end

	if helper.init then
		initFunctions[helper.dbKey] = helper.init
	end

	if helper.profileUpdate then
		profileUpdateFunctions[helper.dbKey] = helper.profileUpdate
	end

	if helper.checkRequirements then
		checkRequirementFunctions[helper.dbKey] = helper.checkRequirements
	end
end

function CH:Initialize()
	self.db = E.db.WT.combat.classHelper
	if not self.db.enable then
		return
	end

	for dbKey, checkRequirements in pairs(checkRequirementFunctions) do
		if checkRequirements() then
			if initFunctions[dbKey] then
				xpcall(initFunctions[dbKey], F.Developer.ThrowError, self)
			end

			if profileUpdateFunctions[dbKey] then
				xpcall(profileUpdateFunctions[dbKey], F.Developer.ThrowError, self, self.db[dbKey])
			end
		end
	end

	self:RegisterEvents()

	self.initialized = true
end

F.Developer.DelayInit(CH, 2)

function CH:ProfileUpdate()
	self.db = E.db.WT.combat.classHelper
	if not self.db.enable then
		return
	end

	if not self.initialized then
		self:Initialize()
		return
	end

	for dbKey, func in pairs(profileUpdateFunctions) do
		xpcall(func, F.Developer.ThrowError, self, self.db[dbKey])
	end
end

function CH:UpdateHelper(dbKey)
	if not self.initialized then
		return
	end

	local func = profileUpdateFunctions[dbKey]
	if func then
		xpcall(func, F.Developer.ThrowError, self, self.db[dbKey])
	end
end

W:RegisterModule(CH:GetName())
