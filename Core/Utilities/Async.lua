local W, F, E, L, V, P, G = unpack((select(2, ...)))

W.Utilities.Async = {}
local U = W.Utilities.Async

local ipairs = ipairs
local pairs = pairs
local type = type

local GetAchievementInfo = GetAchievementInfo
local Item = Item
local Spell = Spell

local C_Timer_After = C_Timer.After

local cache = {
	item = {},
	spell = {},
}

function U.WithItemID(itemID, callback)
	if type(itemID) ~= "number" then
		return
	end

	if not callback then
		callback = function(...) end
	end

	if type(callback) ~= "function" then
		return
	end

	if cache.item[itemID] then
		callback(cache.item[itemID])
		return cache.item[itemID]
	end

	local itemInstance = Item:CreateFromItemID(itemID)
	if itemInstance:IsItemEmpty() then
		F.Developer.LogDebug("Failed to create item instance for itemID: " .. itemID)
		return
	end

	itemInstance:ContinueOnItemLoad(function()
		callback(itemInstance)
	end)

	cache.item[itemID] = itemInstance

	return itemInstance
end

function U.WithSpellID(spellID, callback)
	if type(spellID) ~= "number" then
		return
	end

	if not callback then
		callback = function(...) end
	end

	if type(callback) ~= "function" then
		return
	end

	if cache.spell[spellID] then
		callback(cache.spell[spellID])
		return cache.spell[spellID]
	end

	local spellInstance = Spell:CreateFromSpellID(spellID)

	if spellInstance:IsSpellEmpty() then
		F.Developer.LogDebug("Failed to create spell instance for spellID: " .. spellID)
		return
	end

	spellInstance:ContinueOnSpellLoad(function()
		callback(spellInstance)
	end)

	cache.spell[spellID] = spellInstance

	return spellInstance
end

function U.WithItemIDTable(itemIDTable, tType, callback)
	if type(itemIDTable) ~= "table" then
		return
	end

	if not callback then
		callback = function(...) end
	end

	if type(callback) ~= "function" then
		return
	end

	if type(tType) ~= "string" then
		tType = "value"
	end

	if tType == "list" then
		for _, itemID in ipairs(itemIDTable) do
			U.WithItemID(itemID, callback)
		end
	end

	if tType == "value" then
		for _, itemID in pairs(itemIDTable) do
			U.WithItemID(itemID, callback)
		end
	end

	if tType == "key" then
		for itemID, _ in pairs(itemIDTable) do
			U.WithItemID(itemID, callback)
		end
	end
end

function U.WithSpellIDTable(spellIDTable, tType, callback)
	if type(spellIDTable) ~= "table" then
		return
	end

	if not callback then
		callback = function(...) end
	end

	if type(callback) ~= "function" then
		return
	end

	if type(tType) ~= "string" then
		tType = "value"
	end

	if tType == "list" then
		for _, spellID in ipairs(spellIDTable) do
			U.WithSpellID(spellID, callback)
		end
	end

	if tType == "value" then
		for _, spellID in pairs(spellIDTable) do
			U.WithSpellID(spellID, callback)
		end
	end

	if tType == "key" then
		for spellID, _ in pairs(spellIDTable) do
			U.WithSpellID(spellID, callback)
		end
	end
end

function U.WithItemSlotID(itemSlotID, callback)
	if type(itemSlotID) ~= "number" then
		return
	end

	if not callback then
		callback = function(...) end
	end

	if type(callback) ~= "function" then
		return
	end

	local itemInstance = Item:CreateFromEquipmentSlot(itemSlotID)
	if itemInstance:IsItemEmpty() then
		F.Developer.LogDebug("Failed to create item instance for itemSlotID: " .. itemSlotID)
		return
	end

	itemInstance:ContinueOnItemLoad(function()
		callback(itemInstance)
	end)

	return itemInstance
end

local function onAchievementInfoFetched(achievementID, callback, attempt)
	attempt = attempt or 1
	if attempt > 20 then
		return
	end

	if not callback then
		callback = function(...) end
	end

	if type(callback) ~= "function" then
		return
	end

	local result = { GetAchievementInfo(achievementID) }
	if not result or not result[1] or not result[2] or result[2] == "" or not result[10] then
		C_Timer_After(0.1, function()
			onAchievementInfoFetched(callback, attempt + 1)
		end)
		return
	end

	callback(result)
end

function U.WithAchievementID(achievementID, callback)
	if type(achievementID) ~= "number" then
		F.Developer.LogDebug("Invalid achievementID: " .. achievementID)
		return
	end

	if not callback then
		callback = function(...) end
	end

	if type(callback) ~= "function" then
		return
	end

	onAchievementInfoFetched(achievementID, callback)
end
