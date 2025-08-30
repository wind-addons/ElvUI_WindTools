local W ---@class WindTools
local F ---@type Functions
local E, L ---@type table, table
W, F, E, L = unpack((select(2, ...)))

local _G = _G

local format = format
local next = next
local pairs = pairs
local print = print
local strlower = strlower
local strsub = strsub
local type = type
local wipe = wipe

local C_AddOns_DisableAddOn = C_AddOns.DisableAddOn
local C_AddOns_EnableAddOn = C_AddOns.EnableAddOn
local C_AddOns_GetNumAddOns = C_AddOns.GetNumAddOns

local C_AddOns_GetAddOnInfo = C_AddOns.GetAddOnInfo
local C_CVar_SetCVar = C_CVar.SetCVar
local C_UI_Reload = C_UI.Reload

---Registers a new command with the WindTools addon system
---@param name string The name/identifier for the command
---@param keys string|table The command key(s) or aliases that will trigger this command
---@param func function The callback function to execute when the command is invoked
function W:AddCommand(name, keys, func)
	if not _G.SlashCmdList["WINDTOOLS_" .. name] then
		_G.SlashCmdList["WINDTOOLS_" .. name] = func

		if type(keys) == "table" then
			for i, key in next, keys do
				if strsub(key, 1, 1) ~= "/" then
					key = "/" .. key
				end
				_G["SLASH_WINDTOOLS_" .. name .. i] = key
			end
		else
			if strsub(keys, 1, 1) ~= "/" then
				keys = "/" .. keys
			end
			_G["SLASH_WINDTOOLS_" .. name .. "1"] = keys
		end
	end
end

do
	local AcceptableAddons = {
		["ElvUI"] = true,
		["ElvUI_Options"] = true,
		["ElvUI_Libraries"] = true,
		["ElvUI_CPU"] = true,
		["ElvUI_WindTools"] = true,
		["!BugGrabber"] = true,
		["BugSack"] = true,
	}

	W:AddCommand("ERROR", "/wtdebug", function(msg)
		local switch = strlower(msg)
		if switch == "on" or switch == "1" then
			for i = 1, C_AddOns_GetNumAddOns() do
				local name = C_AddOns_GetAddOnInfo(i)
				if not AcceptableAddons[name] and E:IsAddOnEnabled(name) then
					C_AddOns_DisableAddOn(name, E.myname)
					_G.ElvDB.WT.DisabledAddOns[name] = i
				end
			end

			C_CVar_SetCVar("scriptErrors", 1)
			C_UI_Reload()
		elseif switch == "off" or switch == "0" then
			C_CVar_SetCVar("scriptProfile", 0)
			C_CVar_SetCVar("scriptErrors", 0)
			E:Print("Lua errors off.")

			if E:IsAddOnEnabled("ElvUI_CPU") then
				C_AddOns_DisableAddOn("ElvUI_CPU")
			end

			if next(_G.ElvDB.WT.DisabledAddOns) then
				for name in pairs(_G.ElvDB.WT.DisabledAddOns) do
					C_AddOns_EnableAddOn(name, E.myname)
				end

				wipe(_G.ElvDB.WT.DisabledAddOns)
				C_UI_Reload()
			end
		else
			F.PrintGradientLine()
			F.Print(L["Usage"] .. ": /wtdebug [on|off]")
			print("on  ", L["Enable debug mode"])
			print("      ", format(L["Disable all other addons except ElvUI Core, ElvUI %s and BugSack."], W.Title))
			print("off ", L["Disable debug mode"])
			print("      ", L["Reenable the addons that disabled by debug mode."])
			F.PrintGradientLine()
		end
	end)

	function W.PrintDebugEnviromentTip()
		F.PrintGradientLine()
		F.Print(L["Debug Enviroment"])
		print(L["You can use |cff00d1b2/wtdebug off|r command to exit debug mode."])
		print(format(L["After you stop debuging, %s will reenable the addons automatically."], W.Title))
		F.PrintGradientLine()
	end
end
