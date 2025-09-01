local W ---@class WindTools
local F, E, L ---@type Functions, ElvUI, table
W, F, E, L = unpack((select(2, ...)))

local _G = _G
local format = format
local gmatch = gmatch
local pairs = pairs
local pcall = pcall
local strmatch = strmatch
local strsub = strsub
local tinsert = tinsert
local tonumber = tonumber
local unpack = unpack
local xpcall = xpcall

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local GetCurrentCombatTextEventInfo = GetCurrentCombatTextEventInfo
local InCombatLockdown = InCombatLockdown

local C_PartyInfo_InviteUnit = C_PartyInfo.InviteUnit
local C_UI_Reload = C_UI.Reload

---@diagnostic disable-next-line: undefined-field
local ACCEPT, CANCEL = _G.ACCEPT, _G.CANCEL

---@cast F Functions

W.RegisteredModules = {}
W.Changelog = {}

W:InitializeMetadata()

-- Alerts
E.PopupDialogs.WINDTOOLS_ELVUI_OUTDATED = {
	text = format(
		"%s %s",
		format(L["%s not been loaded since you are using an outdated version of ElvUI."], W.Title),
		format(L["Please upgrade your ElvUI to %2.2f or newer version!"], W.SupportElvUIVersion)
	),
	button1 = ACCEPT,
	hideOnEscape = 1,
}

E.PopupDialogs.WINDTOOLS_OPEN_CHANGELOG = {
	text = format(L["Welcome to %s %s!"], W.Title, W.DisplayVersion),
	button1 = L["Open Changelog"],
	button2 = format("|cffaaaaaa%s|r", L["Next Time"]),
	OnAccept = function(self)
		E:ToggleOptions("WindTools,information,changelog")
	end,
	hideOnEscape = 1,
}

E.PopupDialogs.WINDTOOLS_BUTTON_FIX_RELOAD = {
	text = format(
		"%s\n%s\n\n|cffaaaaaa%s|r",
		format(L["%s detects CVar %s has been changed."], W.Title, "|cff209ceeActionButtonUseKeyDown|r"),
		L["It will cause some buttons not to work properly before UI reloading."],
		format(L["You can disable this alert in [%s]-[%s]-[%s]"], W.Title, L["Advanced"], L["Game Fix"])
	),
	button1 = L["Reload UI"],
	button2 = CANCEL,
	OnAccept = C_UI_Reload,
}

-- Keybinds
_G.BINDING_CATEGORY_ELVUI_WINDTOOLS = W.Title
for i = 1, 5 do
	_G["BINDING_HEADER_WTEXTRAITEMSBAR" .. i] =
		F.CreateColorString(L["Extra Items Bar"] .. " " .. i, E.db.general.valuecolor)
	for j = 1, 12 do
		_G[format("BINDING_NAME_CLICK WTExtraItemsBar%dButton%d:LeftButton", i, j)] = L["Button"] .. " " .. j
	end
end

_G.BINDING_CATEGORY_ELVUI_WINDTOOLS_EXTRA = W.Title .. " - " .. L["Extra"]
_G.BINDING_HEADER_WTEXTRABUTTONS = L["Extra Buttons"]
_G["BINDING_NAME_CLICK WTExtraBindingButtonLogout:LeftButton"] = L["Logout"]
_G["BINDING_NAME_CLICK WTExtraBindingButtonLeaveGroup:LeftButton"] = L["Leave Party"]
_G["BINDING_NAME_CLICK WTExtraBindingButtonLeaveDelve:LeftButton"] = L["Leave Delve"]

-- WindTools Link Operations
-- 1. Print "|Hwtlink:feature:arg1:arg2:arg3:..." in the chat
-- 2. Click the link, it will trigger the corresponding function with the provided arguments
-- => W.LinkOperations[feature](arg1, arg2, arg3, ...)
W.LinkOperations = {
	["changelog"] = E.PopupDialogs.WINDTOOLS_OPEN_CHANGELOG.OnAccept,
	["invite"] = function(name)
		if name then
			C_PartyInfo_InviteUnit(name)
		end
	end,
}

---Registers a link operation function for a specific feature.
---
---**WindTools Link Operations**
---1. Print `|Hwtlink:feature:arg1:arg2:arg3:...` in the chat
---2. Click the link, it will trigger the corresponding function with the provided arguments
---```
---local func = W.LinkOperations[feature]
---func(arg1, arg2, arg3, ...)
---```
---
---@param feature string|nil The name/identifier of the feature registering the operation
---@param func function|nil The function to be called when the link operation is triggered
function W:RegisterLinkOperation(feature, func)
	if not feature or not func then
		return
	end

	W.LinkOperations[feature] = func
end

function W:ItemRefTooltip_SetHyperlink(_, data)
	if strsub(data, 1, 6) ~= "wtlink" then
		return
	end

	local feature, argsString = strmatch(data, "^wtlink:([^:]+)(.*)$")
	if not feature then
		return
	end

	local args = {}
	if argsString and argsString ~= "" then
		argsString = strsub(argsString, 2)
		for arg in gmatch(argsString, "[^:]+") do
			tinsert(args, arg)
		end
	end

	if feature and W.LinkOperations[feature] then
		W.LinkOperations[feature](unpack(args))
	end
end

function W:AddCustomLinkSupport()
	if not W:IsHooked(_G.ItemRefTooltip, "SetHyperlink") then
		W:Hook(_G.ItemRefTooltip, "SetHyperlink", "ItemRefTooltip_SetHyperlink", true)
	end
end

---Register a new module
---@param name string The name of the module
function W:RegisterModule(name)
	if not name then
		F.Developer.ThrowError("The name of module is required!")
		return
	end
	if self.initialized then
		self:GetModule(name):Initialize()
	else
		tinsert(self.RegisteredModules, name)
	end
end

-- WindTools module initialization
function W:InitializeModules()
	for _, moduleName in pairs(W.RegisteredModules) do
		local module = self:GetModule(moduleName)
		if module.Initialize then
			xpcall(module.Initialize, F.Developer.LogDebug, module)
		end
	end
end

-- WindTools module update after profile switch
function W:UpdateModules()
	self:UpdateScripts()
	for _, moduleName in pairs(self.RegisteredModules) do
		local module = W:GetModule(moduleName)
		if module.ProfileUpdate then
			pcall(module.ProfileUpdate, module)
		end
	end
end

-- Check ElvUI version, if not matched, show a popup to user
function W:CheckElvUIVersion()
	if W.SupportElvUIVersion > E.version then
		if E.global.WT.core.elvUIVersionPopup then
			E:StaticPopup_Show("WINDTOOLS_ELVUI_OUTDATED")
		else
			F.Print(E.PopupDialogs.WINDTOOLS_ELVUI_OUTDATED.text)
		end
		return false
	end
	return true
end

-- Check install version, show changelog and run update scripts
function W:ChangelogReadAlert()
	local readVer = E.global.WT.changelogRead and tonumber(E.global.WT.changelogRead) or 0
	local currentVer = tonumber(W.Version)
	if readVer < currentVer then
		if E.global.WT.core.changlogPopup and not InCombatLockdown() then
			E:StaticPopup_Show("WINDTOOLS_OPEN_CHANGELOG")
		else
			F.Print(
				format(
					"%s %s",
					format(L["Welcome to version %s!"], W.Utilities.Color.StringByTemplate(W.Version, "primary")),
					format("|cff71d5ff|Hwtlink:changelog::|h[%s]|h|r", L["Open Changelog"])
				)
			)
		end
	end
end

function W:EventTraceLogEvent(trace, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" or event == "COMBAT_LOG_EVENT" then
		self.hooks[_G.EventTrace].LogEvent(trace, event, CombatLogGetCurrentEventInfo())
	elseif event == "COMBAT_TEXT_UPDATE" then
		self.hooks[_G.EventTrace].LogEvent(trace, event, (...), GetCurrentCombatTextEventInfo())
	else
		self.hooks[_G.EventTrace].LogEvent(trace, event, ...)
	end
end

function W:TryReplaceEventTraceLogEvent()
	if _G.EventTrace and _G.EventTrace.LogEvent and not self:IsHooked(_G.EventTrace, "LogEvent") then
		W:RawHook(_G.EventTrace, "LogEvent", "EventTraceLogEvent", true)
	end
end

function W:GameFixing()
	if E.global.WT.core.cvarAlert then
		self:RegisterEvent("CVAR_UPDATE", function(_, cvar, value)
			if cvar == "ActionButtonUseKeyDown" and W.UseKeyDown ~= (value == "1") then
				E:StaticPopup_Show("WINDTOOLS_BUTTON_FIX_RELOAD")
			end
		end)
	end

	if E.global.WT.core.advancedCLEUEventTrace then
		if _G.EventTrace then
			self:TryReplaceEventTraceLogEvent()
		else
			self:RegisterEvent("ADDON_LOADED")
		end
	end
end

function W:ADDON_LOADED(event, addOnName)
	if addOnName ~= "Blizzard_EventTrace" then
		return
	end

	self:UnregisterEvent("ADDON_LOADED")

	if E.global.WT.core.advancedCLEUEventTrace then
		self:TryReplaceEventTraceLogEvent()
	end
end
