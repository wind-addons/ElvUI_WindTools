local W = unpack((select(2, ...))) ---@class WindTools

local assert = assert
local ipairs = ipairs
local pairs = pairs
local time = time
local type = type
local wipe = wipe

local Mixin = Mixin

local C_Timer_NewTicker = C_Timer.NewTicker

---@class CacheConfig Configuration for cache instance
---@field defaultTTL number Default time-to-live in seconds (0 = no expiration)
---@field maxLength number? Maximum cache entries (nil = unlimited)
---@field autoCleanup boolean Whether to enable automatic periodic cleanup
---@field cleanupInterval number? Cleanup interval in seconds (default: 60)

---@class CacheEntry Cache entry with metadata
---@field value any The cached value
---@field expireAt number Expiration timestamp (0 = never expires)
---@field key string The cache key

---@class CacheStatsBase Cache statistics base
---@field hits number Number of cache hits
---@field misses number Number of cache misses
---@field expired number Number of expired entries removed
---@field evicted number Number of entries evicted due to size limit

---@class CacheStats : CacheStatsBase Cache statistics
---@field hitRate number Cache hit rate (hits / total requests)

---@class Cache Generic cache with TTL and size management
---@field config CacheConfig Cache configuration
---@field data table<string, CacheEntry> Cache storage
---@field cleanupTimer? table Timer handle for auto cleanup
---@field persistenceTable? table Bound persistence table (if using Persistence binding)
---@field count number Current number of entries in cache
---@field stats CacheStatsBase Cache statistics


---Copy configuration from source to destination
---@param source CacheConfig
---@param destination table
local function copyConfig(source, destination)
	destination.defaultTTL = source.defaultTTL
	destination.maxLength = source.maxLength
	destination.autoCleanup = source.autoCleanup
	destination.cleanupInterval = source.cleanupInterval
end

---Update cache entry count
---@param self Cache
---@param delta number Change in count (positive or negative)
local function updateCount(self, delta)
	self.count = self.count + delta
	if self.count < 0 then
		self.count = 0
	end
end

---Internal cleanup method - removes expired entries
---@param self Cache
local function cleanup(self)
	local currentTime = time()
	local keysToRemove = {}

	-- Find expired entries
	for key, entry in pairs(self.data) do
		if entry.expireAt > 0 and entry.expireAt <= currentTime then
			keysToRemove[#keysToRemove + 1] = key
		end
	end

	-- Remove expired entries
	for _, key in ipairs(keysToRemove) do
		self.data[key] = nil
		updateCount(self, -1)
		self.stats.expired = self.stats.expired + 1
	end
end

---Check if entry should be replaced in removal list
---@param newEntry CacheEntry
---@param existingEntry CacheEntry
---@return boolean shouldReplace
local function shouldReplaceEntry(newEntry, existingEntry)
	if newEntry.expireAt == 0 and existingEntry.expireAt == 0 then
		return false
	elseif newEntry.expireAt == 0 then
		return false
	elseif existingEntry.expireAt == 0 then
		return true
	end
	return newEntry.expireAt < existingEntry.expireAt
end

---Enforce max length limit by removing entries with shortest TTL
---@param self Cache
local function enforceMaxLength(self)
	if not self.config.maxLength or self.count <= self.config.maxLength then
		return
	end

	-- Find entries to remove (those expiring soonest)
	local entriesToRemove = {}
	local toRemove = self.count - self.config.maxLength

	-- First pass: find entries that expire soonest
	for _, entry in pairs(self.data) do
		if #entriesToRemove < toRemove then
			entriesToRemove[#entriesToRemove + 1] = entry
		else
			-- Find if this entry expires sooner than any in the removal list
			for i, existingEntry in ipairs(entriesToRemove) do
				if shouldReplaceEntry(entry, existingEntry) then
					entriesToRemove[i] = entry
					break
				end
			end
		end
	end

	-- Remove entries
	for _, entry in ipairs(entriesToRemove) do
		self.data[entry.key] = nil
		updateCount(self, -1)
		self.stats.evicted = self.stats.evicted + 1
	end
end

---Start automatic cleanup timer
---@param self Cache
local function startAutoCleanup(self)
	if self.cleanupTimer then
		self.cleanupTimer:Cancel()
	end

	self.cleanupTimer = C_Timer_NewTicker(self.config.cleanupInterval, function()
		cleanup(self)
	end)
end

---Stop automatic cleanup timer
---@param self Cache
local function stopAutoCleanup(self)
	if self.cleanupTimer then
		self.cleanupTimer:Cancel()
		self.cleanupTimer = nil
	end
end

---Sync config to persistence table (if bound)
---@param self Cache
local function syncConfigToPersistence(self)
	if not self.persistenceTable then
		return
	end

	copyConfig(self.config, self.persistenceTable.config)
end

---Cache prototype (holds all public instance methods)
---@generic T
---@class Cache
local CachePrototype = {}

---Set a value in the cache
---@generic T
---@param key string Cache key
---@param value T Value to cache
---@param ttl? number Optional custom TTL in seconds (overrides defaultTTL)
function CachePrototype:Set(key, value, ttl)
	assert(type(key) == "string", "key must be a string")

	local effectiveTTL = ttl or self.config.defaultTTL
	assert(type(effectiveTTL) == "number" and effectiveTTL >= 0, "ttl must be a non-negative number")

	local expireAt = effectiveTTL > 0 and (time() + effectiveTTL) or 0
	local isNewEntry = self.data[key] == nil

	self.data[key] = {
		value = value,
		expireAt = expireAt,
		key = key,
	}

	-- Update count if this is a new entry
	if isNewEntry then
		updateCount(self, 1)
	end

	-- Enforce max length after adding
	enforceMaxLength(self)
end

---Get a value from the cache
---@generic T
---@param key string Cache key
---@return T|nil value Cached value or nil if not found/expired
function CachePrototype:Get(key)
	assert(type(key) == "string", "key must be a string")

	-- If auto cleanup is disabled, clean up on each get
	if not self.config.autoCleanup then
		cleanup(self)
	end

	local entry = self.data[key]
	if not entry then
		self.stats.misses = self.stats.misses + 1
		return nil
	end

	-- Check expiration
	if entry.expireAt > 0 and entry.expireAt <= time() then
		self.data[key] = nil
		updateCount(self, -1)
		self.stats.expired = self.stats.expired + 1
		self.stats.misses = self.stats.misses + 1
		return nil
	end

	self.stats.hits = self.stats.hits + 1
	return entry.value
end

---Clear all cache entries
function CachePrototype:Clear()
	wipe(self.data)
	self.count = 0
end

---Bind cache to a table for auto-sync (persistence)
---This will wipe the table and set it up with current cache data and config.
---All subsequent operations will automatically update this table.
---@param targetTable table The table to bind to (e.g., A.db.questCache)
function CachePrototype:Bind(targetTable)
	assert(type(targetTable) == "table", "targetTable must be a table")

	-- Clean up expired entries before binding
	cleanup(self)

	-- Wipe the target table
	wipe(targetTable)

	-- Set up the structure
	targetTable.config = {}
	copyConfig(self.config, targetTable.config)
	targetTable.data = {}

	-- Copy current data to target table
	for key, entry in pairs(self.data) do
		targetTable.data[key] = {
			value = entry.value,
			expireAt = entry.expireAt,
			key = entry.key,
		}
	end

	-- Switch to use the target table's data
	self.data = targetTable.data
	self.persistenceTable = targetTable
end

---Check if cache is bound to a table
---@return boolean isBound True if cache is bound to a table
function CachePrototype:IsBound()
	return self.persistenceTable ~= nil
end

---Unbind from bound table (switch back to internal storage)
function CachePrototype:Unbind()
	if not self.persistenceTable then
		return
	end

	-- Copy data back to internal storage
	local newData = {}
	for key, entry in pairs(self.data) do
		newData[key] = {
			value = entry.value,
			expireAt = entry.expireAt,
			key = entry.key,
		}
	end

	self.data = newData
	self.persistenceTable = nil
end

---Get current cache size
---@return number count Number of entries in cache
function CachePrototype:Size()
	return self.count
end

---Check if cache has a key
---@param key string Cache key
---@return boolean exists True if key exists and is not expired
function CachePrototype:Has(key)
	return self:Get(key) ~= nil
end

---Enable or disable auto cleanup
---@param enabled boolean Enable auto cleanup
function CachePrototype:SetAutoCleanup(enabled)
	assert(type(enabled) == "boolean", "enabled must be a boolean")

	self.config.autoCleanup = enabled

	if enabled then
		startAutoCleanup(self)
	else
		stopAutoCleanup(self)
	end

	-- Sync to persistence if bound
	syncConfigToPersistence(self)
end

---Update cleanup interval (only applies if auto cleanup is enabled)
---@param interval number Cleanup interval in seconds
function CachePrototype:SetCleanupInterval(interval)
	assert(type(interval) == "number" and interval > 0, "interval must be a positive number")

	self.config.cleanupInterval = interval

	-- Restart timer with new interval if auto cleanup is enabled
	if self.config.autoCleanup then
		startAutoCleanup(self)
	end

	-- Sync to persistence if bound
	syncConfigToPersistence(self)
end

---Set multiple values in the cache
---@generic T
---@param entries table<string, T> Table of key-value pairs to cache
---@param ttl? number Optional custom TTL in seconds (overrides defaultTTL)
function CachePrototype:SetBatch(entries, ttl)
	assert(type(entries) == "table", "entries must be a table")

	for key, value in pairs(entries) do
		self:Set(key, value, ttl)
	end
end

---Get multiple values from the cache
---@param keys string[] Array of keys to retrieve
---@return table<string, any> results Table of key-value pairs for found entries
function CachePrototype:GetBatch(keys)
	assert(type(keys) == "table", "keys must be a table")

	local results = {}
	for _, key in ipairs(keys) do
		local value = self:Get(key)
		if value ~= nil then
			results[key] = value
		end
	end
	return results
end

---Get cache statistics
---@return CacheStats stats Current cache statistics
function CachePrototype:GetStats()
	return {
		hits = self.stats.hits,
		misses = self.stats.misses,
		expired = self.stats.expired,
		evicted = self.stats.evicted,
		hitRate = self.stats.hits + self.stats.misses > 0 and (self.stats.hits / (self.stats.hits + self.stats.misses))
			or 0,
	}
end

---Reset cache statistics
function CachePrototype:ResetStats()
	self.stats.hits = 0
	self.stats.misses = 0
	self.stats.expired = 0
	self.stats.evicted = 0
end

---Iterator for cache entries (only returns valid, non-expired entries)
---Usage: for key, value in cache:Iterate() do ... end
---@generic T
---@param self Cache<T>
---@return fun(state: Cache, control: any): string?, T? iterator Iterator function that returns key and value
---@return Cache state The cache instance itself (state for iterator)
---@return nil control Control variable (unused, required by Lua iterator protocol)
function CachePrototype:Iterate()
	-- If auto cleanup is disabled, clean up before iterating
	if not self.config.autoCleanup then
		cleanup(self)
	end

	local currentTime = time()
	local keysToRemove = {}
	local lastKey = nil

	local function iterator(state, _)
		local key, entry = next(state.data, lastKey)

		while key do
			entry = state.data[key] -- Re-get entry in case it was modified
			if not entry then
				-- Entry was removed, get next
				key, entry = next(state.data, key)
			elseif entry.expireAt > 0 and entry.expireAt <= currentTime then
				-- Mark for removal and skip to next entry
				keysToRemove[#keysToRemove + 1] = key
				lastKey = key
				key, entry = next(state.data, key)
			else
				-- Valid entry found
				lastKey = key
				return key, entry.value
			end
		end

		-- Iteration complete, cleanup expired entries if any were found
		if #keysToRemove > 0 then
			for _, k in ipairs(keysToRemove) do
				state.data[k] = nil
				updateCount(state, -1)
				state.stats.expired = state.stats.expired + 1
			end
		end

		return nil
	end

	return iterator, self, nil
end

-- Cache module (public API with factory methods)
local Cache = {}

---Create a new cache instance
---@param config CacheConfig Configuration options
---@return Cache cache New cache instance
function Cache.New(config)
	assert(type(config) == "table", "config must be a table")
	assert(type(config.defaultTTL) == "number" and config.defaultTTL >= 0, "defaultTTL must be a non-negative number")
	assert(
		config.maxLength == nil or (type(config.maxLength) == "number" and config.maxLength > 0),
		"maxLength must be nil or a positive number"
	)
	assert(type(config.autoCleanup) == "boolean", "autoCleanup must be a boolean")
	assert(
		config.cleanupInterval == nil or (type(config.cleanupInterval) == "number" and config.cleanupInterval > 0),
		"cleanupInterval must be nil or a positive number"
	)

	---@class Cache
	local instance = {
		config = {
			defaultTTL = config.defaultTTL,
			maxLength = config.maxLength,
			autoCleanup = config.autoCleanup,
			cleanupInterval = config.cleanupInterval or 60,
		},
		data = {},
		cleanupTimer = nil,
		persistenceTable = nil,
		count = 0,
		stats = {
			hits = 0,
			misses = 0,
			expired = 0,
			evicted = 0,
		},
	}

	-- Mix in all instance methods from prototype
	Mixin(instance, CachePrototype)

	if instance.config.autoCleanup then
		startAutoCleanup(instance)
	end

	return instance
end

---Restore cache from persisted data
---@param persistedData table Persisted cache data (must have config and data fields)
---@param bind? boolean If true, bind to the persistedData table for auto-sync (default: false)
---@return Cache cache Restored cache instance
function Cache.Restore(persistedData, bind)
	assert(type(persistedData) == "table", "persistedData must be a table")
	assert(type(persistedData.config) == "table", "persistedData.config must be a table")
	assert(type(persistedData.data) == "table", "persistedData.data must be a table")

	local cache = Cache.New(persistedData.config)

	if bind then
		-- Bind mode: use the existing data table directly
		cache.data = persistedData.data
		cache.persistenceTable = persistedData

		-- Count entries and clean up expired ones
		local currentTime = time()
		local count = 0
		for key, entry in pairs(persistedData.data) do
			if entry.expireAt == 0 or entry.expireAt > currentTime then
				count = count + 1
			else
				-- Remove expired entries
				persistedData.data[key] = nil
			end
		end
		cache.count = count

		-- Sync config back to persistence table
		syncConfigToPersistence(cache)
	else
		-- Copy mode: copy data to new cache
		local currentTime = time()
		local count = 0
		for key, entry in pairs(persistedData.data) do
			-- Only restore non-expired entries
			if entry.expireAt == 0 or entry.expireAt > currentTime then
				cache.data[key] = {
					value = entry.value,
					expireAt = entry.expireAt,
					key = key,
				}
				count = count + 1
			end
		end
		cache.count = count
	end

	return cache
end

W.Utilities.Cache = Cache
