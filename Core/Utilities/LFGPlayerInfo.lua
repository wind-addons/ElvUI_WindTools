local W ---@class WindTools
local F, E, L ---@type Functions, ElvUI, table
W, F, E, L = unpack((select(2, ...)))

local format = format
local gsub = gsub
local ipairs = ipairs
local pairs = pairs
local select = select
local strsplit = strsplit
local tinsert = tinsert
local tonumber = tonumber
local tostring = tostring

local GetClassInfo = GetClassInfo
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID

local C_LFGList_GetActivityInfoTable = C_LFGList.GetActivityInfoTable
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetSearchResultPlayerInfo = C_LFGList.GetSearchResultPlayerInfo

local GROUP_FINDER_CATEGORY_ID_DUNGEONS = GROUP_FINDER_CATEGORY_ID_DUNGEONS
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE

---@cast F Functions

---@class LFGPlayerInfo
---Utility class for parsing and processing LFG (Looking For Group) player information.
---Provides functionality to extract role, class, and specialization data from group finder results.
W.Utilities.LFGPlayerInfo = {}

---Get the name identifier for this utility
---@return string name The name identifier for logging
function W.Utilities.LFGPlayerInfo:GetName()
	return "Utilities:LFGPlayerInfo"
end

F.Developer.InjectLogger(W.Utilities.LFGPlayerInfo)

local classIconStyle = "flat" ---@type ClassIconStyle

---Set the class icon style for rendering
---@param style ClassIconStyle The desired class icon styles
function W.Utilities.LFGPlayerInfo:SetClassIconStyle(style)
	if style then
		classIconStyle = style
	end
end

---Role priority order for display and processing
---@type ("TANK" | "HEALER" | "DAMAGER")[]
local roleOrder = { "TANK", "HEALER", "DAMAGER" }

---Get the role order array
---@return ("TANK" | "HEALER" | "DAMAGER")[] roleOrder Array of role names in priority order
function W.Utilities.LFGPlayerInfo.GetRoleOrder()
	return roleOrder
end

---Colored role names with appropriate visual styling
---@type table<string, string>
local coloredRoleName = {
	TANK = "|cff00a8ff" .. L["Tank"] .. "|r",
	HEALER = "|cff2ecc71" .. L["Healer"] .. "|r",
	DAMAGER = "|cffe74c3c" .. L["DPS"] .. "|r",
}

---Get colored role name for display
---@param role string The role name ("TANK", "HEALER", "DAMAGER")
---@return string coloredName The colored and formatted role name
function W.Utilities.LFGPlayerInfo.GetColoredRoleName(role)
	return coloredRoleName[role]
end

---Mapping from class file names to class IDs
---@type table<ClassFile, integer>
local classFileToID = {}

---Mapping from localized specialization names to specialization IDs by class
---@type table<ClassFile, table<string, integer>>
local localizedSpecNameToID = {}

---Mapping from localized specialization names to icon paths by class
---@type table<ClassFile, table<string, integer>>
local localizedSpecNameToIcon = {}

---Initialize class and specialization data mappings
---Scans all available classes and their specializations to build lookup tables
for classID = 1, 13 do
	-- Scan all specs and specilizations, 13 is Evoker
	local classFile = select(2, GetClassInfo(classID)) ---@type ClassFile|nil

	if classFile then
		classFileToID[classFile] = classID

		if not localizedSpecNameToID[classFile] then
			localizedSpecNameToID[classFile] = {}
		end

		if not localizedSpecNameToIcon[classFile] then
			localizedSpecNameToIcon[classFile] = {}
		end

		for specIndex = 1, 4 do
			local id, name, _, icon = GetSpecializationInfoForClassID(classID, specIndex)
			if id and name and icon then
				localizedSpecNameToID[classFile][name] = id
				localizedSpecNameToIcon[classFile][name] = icon
			end
		end
	end
end

---Get icon texture path for a specific class and specialization
---@param class string The class file name (e.g., "WARRIOR")
---@param spec string The localized specialization name
---@return any|nil iconPath The icon texture path, or nil if not found
function W.Utilities.LFGPlayerInfo.GetIconTextureWithClassAndSpecName(class, spec)
	return localizedSpecNameToIcon[class] and localizedSpecNameToIcon[class][spec]
end

---@class CompositionRoleCache
---@field totalAmount number Total number of players in this role
---@field playerList table<ClassFile, table<string, number>> Nested table of players organized by class and specializations

---@class CompositionRoleCacheManager
---@field TANK CompositionRoleCache Cache for tank role
---@field HEALER CompositionRoleCache Cache for healer role
---@field DAMAGER CompositionRoleCache Cache for damage dealer role
W.Utilities.LFGPlayerInfo.Composition = {}

---Clear the cache and initialize role structures
---Resets all role data to empty state with zero counts
function W.Utilities.LFGPlayerInfo.Composition:Clear()
	for _, role in ipairs(roleOrder) do
		self[role] = { totalAmount = 0, playerList = {} }
	end
end

---Add a player to the cache for a specific role, class, and specialization
---@param role string The player's role ("TANK", "HEALER", "DAMAGER")
---@param class string The player's class file name (e.g., "WARRIOR")
---@param spec string The player's specialization name
function W.Utilities.LFGPlayerInfo.Composition:AddPlayer(role, class, spec)
	if not self[role] then
		W.Utilities.LFGPlayerInfo:Log(
			"warning",
			format("cache not been initialized correctly, the role:%s is nil.", role)
		)
	end

	if not self[role].playerList[class] then
		self[role].playerList[class] = {}
	end

	if not self[role].playerList[class][spec] then
		self[role].playerList[class][spec] = 0
	end

	self[role].playerList[class][spec] = self[role].playerList[class][spec] + 1
	self[role].totalAmount = self[role].totalAmount + 1
end

---Update cache with player information from a LFG search result
---Processes all members in the group and categorizes them by role, class, and spec
---@param resultID number The LFG search result ID to process
function W.Utilities.LFGPlayerInfo:Update(resultID)
	local result = C_LFGList_GetSearchResultInfo(resultID)

	if not result then
		self:Log("debug", "cache not updated correctly, the number of results is nil.")
	end

	if not result.numMembers or result.numMembers == 0 then
		self:Log("debug", "cache not updated correctly, the number of result.numMembers is nil or 0.")
	end

	self.Composition:Clear()

	for i = 1, result.numMembers do
		local memberInfo = C_LFGList_GetSearchResultPlayerInfo(resultID, i)
		if memberInfo then
			local role, class, spec = memberInfo.assignedRole, memberInfo.classFilename, memberInfo.specName

			if not role then
				self:Log("debug", "cache not updated correctly, the role is nil.")
				return
			end

			if not class then
				self:Log("debug", "cache not updated correctly, the class is nil.")
				return
			end

			if not spec then
				self:Log("debug", "cache not updated correctly, the spec is nil.")
				return
			end

			self.Composition:AddPlayer(role, class, spec)
		end
	end
end

---Check if a search result is for dungeon content
---@param resultID number The LFG search result ID to check
---@return boolean isDungeon True if the result is for dungeon content
function W.Utilities.LFGPlayerInfo:IsIDDungeons(resultID)
	local result = C_LFGList_GetSearchResultInfo(resultID)
	local activity = C_LFGList_GetActivityInfoTable(result.activityIDs[1])
	return activity and activity.categoryID == GROUP_FINDER_CATEGORY_ID_DUNGEONS
end

---Conduct template rendering with player information
---Template system similar to React/Vue with mustache-style syntax
---Supports: {{classIcon}}, {{className}}, {{specIcon}}, {{specName}}, {{amount}}, etc.
---@param template string The template string with placeholder tags
---@param role string|nil The player's role
---@param class string|nil The player's class file name
---@param spec string|nil The player's specialization name
---@param amount number|nil The number of players with this role/class/spec
---@return string result The rendered template string
function W.Utilities.LFGPlayerInfo:Conduct(template, role, class, spec, amount)
	-- This function allow you do a very simple template rendering.
	-- The syntax like a mix of React and Vue.
	-- The field between `{{` and `}}` should NOT have any space.
	-- The {{tagStart}} and {{tagEnd}} is a tag pair like HTML tag, but it has been designed for matching latest close tag.
	-- [Sample]
	-- {{classIcon:14}}{{specIcon:14,18}} {{classColorStart}}{{className}}{{classColorEnd}}{{amountStart}} x {{amount}}{{amountEnd}}

	local result = template

	-- {{classIcon}}
	result = gsub(result, "{{classIcon:([0-9,]-)}}", function(sub)
		if not class then
			self:Log("warning", "className not found, class is not given.")
			return ""
		end

		local size = { strsplit(",", sub) }
		local height = size[1] and size[1] ~= "" and tonumber(size[1]) or 14
		local width = size[2] and size[2] ~= "" and tonumber(size[2]) or height

		return F.GetClassIconStringWithStyle(class, classIconStyle, width, height)
	end)

	-- {{className}}
	result = gsub(result, "{{className}}", function(sub)
		if not class then
			self:Log("warning", "className not found, class is not given.")
			return ""
		end

		return LOCALIZED_CLASS_NAMES_MALE[class]
	end)

	-- {{classId}}
	result = gsub(result, "{{classId}}", function(sub)
		if not class then
			self:Log("warning", "classId not found, class is not given.")
			return ""
		end

		local classID = classFileToID[class]

		return classID or ""
	end)

	-- {{specIcon}}
	result = gsub(result, "{{specIcon:([0-9,]-)}}", function(sub)
		if not spec then
			self:Log("warning", "specIcon not found, spec is not given.")
			return ""
		end

		if spec == "Initial" then
			return ""
		end

		local icon = localizedSpecNameToIcon[class] and localizedSpecNameToIcon[class][spec]

		local size = { strsplit(",", sub) }
		local height = size[1] and size[1] ~= "" and tonumber(size[1]) or 14
		local width = size[2] and size[2] ~= "" and tonumber(size[2]) or height

		return icon and F.GetIconString(icon, height, width, true) or ""
	end)

	-- {{specName}}
	result = gsub(result, "{{specName}}", function(sub)
		if not spec then
			self:Log("warning", "specName not found, spec is not given.")
			return ""
		end

		return spec
	end)

	-- {{specId}}
	result = gsub(result, "{{specId}}", function(sub)
		if not class then
			self:Log("warning", "specId not found, spec is not given.")
			return ""
		end

		local specID = localizedSpecNameToID[class] and localizedSpecNameToID[class][spec]

		return specID or ""
	end)

	-- {{classColorStart}} ... {{classColorEnd}}
	result = gsub(result, "{{classColorStart}}(.-){{classColorEnd}}", function(sub)
		if not class then
			self:Log("warning", "className not found, class is not given.")
			return ""
		end

		return F.CreateClassColorString(sub, class)
	end)

	-- {{amountStart}} ... {{amountEnd}}
	result = gsub(result, "{{amountStart}}(.-){{amountEnd}}", function(sub)
		if amount <= 1 then -- should not show amount if the amount is only one
			return ""
		else
			-- {{amount}}
			if not amount then
				self:Log("warning", "amount not found, amount is not given.")
				return ""
			end
			return gsub(sub, "{{amount}}", tostring(amount))
		end
	end)

	-- {{amount}}
	result = gsub(result, "{{amount}}", function()
		if not amount then
			self:Log("warning", "amount not found, amount is not given.")
			return ""
		end
		return tostring(amount)
	end)

	-- {{classColorStart}} ... {{classColorEnd}}
	result = gsub(result, "{{classColorStart}}(.-){{classColorEnd}}", function(sub)
		if not class then
			self:Log("warning", "className not found, class is not given.")
			return ""
		end
		return F.CreateClassColorString(sub, class)
	end)

	return result
end

---Generate a preview of template rendering using sample data
---Uses a Monk Brewmaster as sample data for demonstration
---@param template string|nil The template string to preview
---@return string result The rendered preview string, empty if template is nil
function W.Utilities.LFGPlayerInfo:ConductPreview(template)
	if not template then
		return ""
	end

	local specName = select(2, GetSpecializationInfoForClassID(10, 1)) -- Brewmaster

	return self:Conduct(template, "TANK", "MONK", specName, 2)
end

---Get formatted party information using the provided template
---Processes cached player data and renders it using the template system
---@param template string|nil The template string for formatting player info
---@return table<string, string[]>? dataTable Table organized by role containing formatted strings, nil if template is invalid
function W.Utilities.LFGPlayerInfo:GetPartyInfo(template)
	if not template then
		self:Log("warning", "template is nil.")
		return
	end

	local dataTable = {}

	for _, role in ipairs(roleOrder) do
		dataTable[role] = {}

		local members = self.Composition[role]

		for class, numberOfPlayersSortBySpec in pairs(members.playerList) do
			for spec, numberOfPlayers in pairs(numberOfPlayersSortBySpec) do
				local result = self:Conduct(template, role, class, spec, numberOfPlayers)
				tinsert(dataTable[role], result)
			end
		end
	end

	return dataTable
end
