---@meta

-- TinyLibs Library API Documentation
-- Comprehensive type definitions for all TinyLibs libraries

-- ============================================================================
-- LIBEVENT - Event Management Library
-- ============================================================================

---@class LibEvent.7000
---@field events table<string, LibEvent_Callback[]> Registered Blizzard event callbacks
---@field triggers table<string, LibEvent_Callback[]> Registered custom trigger callbacks
local LibEvent = {}

---@alias LibEvent_Callback fun(this: function, ...) Callback function that receives this (the callback itself) and event arguments

---Adds an event listener for Blizzard events
---@param event FrameEvent Event name (supports comma-separated multiple events)
---@param func LibEvent_Callback Callback function that receives this and event arguments
---@return LibEvent self
function LibEvent:addEventListener(event, func) end

---Adds a one-time event listener for Blizzard events
---@param event FrameEvent Event name (supports comma-separated multiple events)
---@param func LibEvent_Callback Callback function that receives this and event arguments
---@return LibEvent self
function LibEvent:addEventListenerOnce(event, func) end

---Removes an event listener for Blizzard events
---@param event FrameEvent Event name or function to remove
---@param func function? Callback function (if event is string)
---@return LibEvent self
function LibEvent:removeEventListener(event, func) end

---Adds a trigger listener for custom events
---@param event FrameEvent Event name (supports comma-separated multiple events)
---@param func LibEvent_Callback Callback function that receives this and event arguments
---@return LibEvent self
function LibEvent:addTriggerListener(event, func) end

---Adds a one-time trigger listener for custom events
---@param event FrameEvent Event name (supports comma-separated multiple events)
---@param func LibEvent_Callback Callback function that receives this and event arguments
---@return LibEvent self
function LibEvent:addTriggerListenerOnce(event, func) end

---Removes a trigger listener for custom events
---@param event FrameEvent Event name or function to remove
---@param func function? Callback function (if event is string)
---@return LibEvent self
function LibEvent:removeTriggerListener(event, func) end

---Removes all trigger listeners for an event
---@param event FrameEvent Event name
---@return LibEvent self
function LibEvent:removeAllTriggers(event) end

---Triggers a custom event (calls all registered trigger listeners)
---@param event FrameEvent Event name
---@param ... any Event arguments passed to callbacks
---@return LibEvent self
function LibEvent:trigger(event, ...) end

---Simulates a Blizzard event (calls all registered event listeners)
---@param event FrameEvent Event name
---@param ... any Event arguments passed to callbacks
---@return LibEvent self
function LibEvent:event(event, ...) end

-- Function aliases for backward compatibility
---@alias LibEvent_attachEvent fun(self: LibEvent, event: FrameEvent, func: LibEvent_Callback): LibEvent
---@alias LibEvent_attachEventOnce fun(self: LibEvent, event: FrameEvent, func: LibEvent_Callback): LibEvent
---@alias LibEvent_detachEvent fun(self: LibEvent, event: FrameEvent, func: function?): LibEvent
---@alias LibEvent_attachTrigger fun(self: LibEvent, event: FrameEvent, func: LibEvent_Callback): LibEvent
---@alias LibEvent_attachTriggerOnce fun(self: LibEvent, event: FrameEvent, func: LibEvent_Callback): LibEvent
---@alias LibEvent_detachTrigger fun(self: LibEvent, event: FrameEvent, func: function?): LibEvent
---@alias LibEvent_detachAllTriggers fun(self: LibEvent, event: FrameEvent): LibEvent

LibEvent.attachEvent = LibEvent.addEventListener
LibEvent.attachEventOnce = LibEvent.addEventListenerOnce
LibEvent.detachEvent = LibEvent.removeEventListener
LibEvent.attachTrigger = LibEvent.addTriggerListener
LibEvent.attachTriggerOnce = LibEvent.addTriggerListenerOnce
LibEvent.detachTrigger = LibEvent.removeTriggerListener
LibEvent.detachAllTriggers = LibEvent.removeAllTriggers

-- ============================================================================
-- LIBSCHEDULE - Task Scheduling Library
-- ============================================================================

---@class LibSchedule.7000
local LibSchedule = {}

---@class LibSchedule_Task
---@field identity string Unique task identifier (required)
---@field timer number? Initial timer value (default: 0)
---@field elasped number? Execution interval in seconds (default: 1)
---@field begined number? Start time point (default: 0)
---@field expired number? Expiration time point (default: 0)
---@field override boolean? Whether to override existing task with same identity (default: false)
---@field onStart (fun(self: LibSchedule_Task))? Called when task is added (default: empty function)
---@field onTimeout (fun(self: LibSchedule_Task))? Called when task expires (default: empty function)
---@field onExecute (fun(self: LibSchedule_Task): boolean?) Called periodically, return true to stop task (default: returns true)
---@field onRemove (fun(self: LibSchedule_Task))? Called when task is removed (default: empty function)
---@field data any? Custom data attached to the task
---@field unit string? Unit ID for unit-related tasks
--- When creating a task, only 'identity' is required. All other fields have defaults provided by metatable.
local Task = {}

---Adds a task to the scheduler
---@param item table|LibSchedule_Task Task object to add (only identity is required, other fields have defaults)
---@param override boolean? Whether to override existing task with same identity
---@return LibSchedule self
function LibSchedule:AddTask(item, override) end

---Removes a task from the scheduler
---@param identity string Task identity to remove
---@param useLike boolean? If true, use pattern matching for identity
---@return LibSchedule self
function LibSchedule:RemoveTask(identity, useLike) end

---Executes a task immediately
---@param identity string Task identity to execute
---@param useLike boolean? If true, use pattern matching for identity
---@return LibSchedule self
function LibSchedule:AwakeTask(identity, useLike) end

---Searches for tasks by identity
---@param identity string Task identity to search for
---@param useLike boolean? If true, use pattern matching for identity
---@return string[]|nil Array of matching task identities, or nil if none found
function LibSchedule:SearchTask(identity, useLike) end

-- ============================================================================
-- LIBITEMINFO - Item Information Library
-- ============================================================================

---@class LibItemInfo.7000
local LibItemInfo = {}

---@class ItemStats
---@field value number Stat value
---@field r number Red color component (0-1)
---@field g number Green color component (0-1)
---@field b number Blue color component (0-1)
local ItemStats = {}

---Checks if an item is cached locally
---@param item string|number Item link or item ID
---@return boolean True if item is cached locally
function LibItemInfo:HasLocalCached(item) end

---Extracts stats from a tooltip
---@param tip GameTooltip Tooltip to extract stats from
---@param stats ItemStats|table Table to store extracted stats
---@return ItemStats|table Stats table
function LibItemInfo:GetStatsViaTooltip(tip, stats) end

---Gets item information via tooltip
---@param link string Item link
---@param stats ItemStats|table? Table to store extracted stats
---@param withoutExtra boolean? If true, don't return extra item info
---@return number errorCode Error code (0 = success, 1 = not cached)
---@return number itemLevel Item level
---@return ... any Additional item info if withoutExtra is false
function LibItemInfo:GetItemInfo(link, stats, withoutExtra) end

---Gets item information via tooltip (alias)
---@param link string Item link
---@param stats ItemStats|table? Table to store extracted stats
---@return number errorCode Error code (0 = success, 1 = not cached)
---@return number itemLevel Item level
---@return ... any Additional item info
function LibItemInfo:GetItemInfoViaTooltip(link, stats) end

---Gets container item level
---@param bagID number Bag ID (negative for bank)
---@param slotID number Slot ID
---@return number errorCode Error code
---@return number itemLevel Item level
function LibItemInfo:GetContainerItemLevel(bagID, slotID) end

---Gets unit item information
---@param unit string Unit ID
---@param slotIndex number Equipment slot index
---@param stats ItemStats|table? Table to store extracted stats
---@return number errorCode Error code (0 = success, 1 = unit doesn't exist)
---@return number itemLevel Item level
---@return string itemName Item name
function LibItemInfo:GetUnitItemInfo(unit, slotIndex, stats) end

---Gets unit's average item level
---@param unit string Unit ID
---@param stats ItemStats|table? Table to store extracted stats
---@return number unknownCount Number of unknown items
---@return number averageLevel Average item level
---@return number totalLevel Total item level
---@return number maxWeaponLevel Maximum weapon level
---@return boolean isArtifact Whether unit has artifact weapon
---@return number maxLevel Maximum item level
function LibItemInfo:GetUnitItemLevel(unit, stats) end

---Gets quest item link
---@param questType string Quest type
---@param id number Quest item ID
---@return string itemLink Quest item link
function LibItemInfo:GetQuestItemlink(questType, id) end

-- ============================================================================
-- LIBITEMGEM - Item Gem Library
-- ============================================================================

---@class LibItemGem.7000
local LibItemGem = {}

---@class GemInfo
---@field name string Gem name
---@field link string|nil Gem item link
local GemInfo = {}

---Gets item gem information
---@param itemLink string Item link
---@return number totalGems Total number of gem slots
---@return GemInfo[] gemInfo Array of gem information
---@return number quality Item quality
function LibItemGem:GetItemGemInfo(itemLink) end

-- ============================================================================
-- LIBITEMENCHANT - Item Enchantment Library
-- ============================================================================

---@class LibItemEnchant.7000
local LibItemEnchant = {}

---Gets enchantment spell ID from item link
---@param itemLink string Item link
---@return number|nil spellID Enchantment spell ID, or nil if not found
---@return number|nil enchantID Enchantment ID, or nil if not found
function LibItemEnchant:GetEnchantSpellID(itemLink) end

---Gets enchantment item ID from item link
---@param itemLink string Item link
---@return number|nil itemID Enchantment item ID, or nil if not found
---@return number|nil enchantID Enchantment ID, or nil if not found
function LibItemEnchant:GetEnchantItemID(itemLink) end

-- ============================================================================
-- LIBRARY EXPORTS
-- ============================================================================

return {
    LibEvent = LibEvent,
    LibSchedule = LibSchedule,
    LibItemInfo = LibItemInfo,
    LibItemGem = LibItemGem,
    LibItemEnchant = LibItemEnchant
}
