local W, F, E, L, V, P, G = unpack((select(2, ...)))

local _G = _G
local format = format
local pairs = pairs
local pcall = pcall
local strmatch = strmatch
local strsub = strsub
local tinsert = tinsert
local tonumber = tonumber

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local CreateFrame = CreateFrame
local GetCurrentCombatTextEventInfo = GetCurrentCombatTextEventInfo
local InCombatLockdown = InCombatLockdown

local C_UI_Reload = C_UI.Reload

local ACCEPT = _G.ACCEPT
local CANCEL = _G.CANCEL

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

W.LinkOperations = {
	["changelog"] = E.PopupDialogs.WINDTOOLS_OPEN_CHANGELOG.OnAccept,
}

function W:AddCustomLinkSupport()
	local ItemRefTooltip_SetHyperlink = _G.ItemRefTooltip.SetHyperlink
	function _G.ItemRefTooltip.SetHyperlink(tt, data, ...)
		if strsub(data, 1, 6) == "wtlink" then
			local pattern = "wtlink:([%w,;%.]+):([%w,;%.]*):"
			local feature_name, context_string = strmatch(data, pattern)
			if feature_name and W.LinkOperations[feature_name] then
				W.LinkOperations[feature_name](context_string)
			end
		end
		ItemRefTooltip_SetHyperlink(tt, data, ...)
	end
end

--[[
    WindTools module registration
    @param {string} name The name of module
]]
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
			pcall(module.Initialize, module)
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

function W:GameFixing()
	if E.global.WT.core.cvarAlert then
		self:RegisterEvent("CVAR_UPDATE", function(_, cvar, value)
			if cvar == "ActionButtonUseKeyDown" and W.UseKeyDown ~= (value == "1") then
				E:StaticPopup_Show("WINDTOOLS_BUTTON_FIX_RELOAD")
			end
		end)
	end

	if E.global.WT.core.advancedCLEUEventTrace then
		local function LogEvent(trace, event, ...)
			if event == "COMBAT_LOG_EVENT_UNFILTERED" or event == "COMBAT_LOG_EVENT" then
				trace:LogEvent_Original(event, CombatLogGetCurrentEventInfo())
			elseif event == "COMBAT_TEXT_UPDATE" then
				trace:LogEvent_Original(event, (...), GetCurrentCombatTextEventInfo())
			else
				trace:LogEvent_Original(event, ...)
			end
		end

		local function OnEventTraceLoaded()
			_G.EventTrace.LogEvent_Original = _G.EventTrace.LogEvent
			_G.EventTrace.LogEvent = LogEvent
		end

		if _G.EventTrace then
			OnEventTraceLoaded()
		else
			local frame = CreateFrame("Frame")
			frame:RegisterEvent("ADDON_LOADED")
			frame:SetScript("OnEvent", function(f, event, ...)
				if event == "ADDON_LOADED" and (...) == "Blizzard_EventTrace" then
					OnEventTraceLoaded()
					f:UnregisterAllEvents()
				end
			end)
		end
	end
end
