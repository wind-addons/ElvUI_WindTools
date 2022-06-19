local W, F, E, L, V, P, G = unpack(select(2, ...))

local _G = _G

local format = format
local next = next
local pairs = pairs
local print = print
local strlower = strlower
local strsub = strsub
local type = type
local wipe = wipe

local DisableAddOn = DisableAddOn
local EnableAddOn = EnableAddOn
local GetAddOnInfo = GetAddOnInfo
local GetNumAddOns = GetNumAddOns

local C_CVar_SetCVar = C_CVar.SetCVar
local C_UI_Reload = C_UI.Reload

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
        ["ElvUI_OptionsUI"] = true,
        ["ElvUI_CPU"] = true,
        ["ElvUI_WindTools"] = true,
        ["!BugGrabber"] = true,
        ["BugSack"] = true
    }

    W:AddCommand(
        "ERROR",
        "/wtdebug",
        function(msg)
            local switch = strlower(msg)
            if switch == "on" or switch == "1" then
                for i = 1, GetNumAddOns() do
                    local name = GetAddOnInfo(i)
                    if not AcceptableAddons[name] and E:IsAddOnEnabled(name) then
                        DisableAddOn(name, E.myname)
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
                    DisableAddOn("ElvUI_CPU")
                end

                if next(_G.ElvDB.WT.DisabledAddOns) then
                    for name in pairs(_G.ElvDB.WT.DisabledAddOns) do
                        EnableAddOn(name, E.myname)
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
        end
    )

    function W.PrintDebugEnviromentTip()
        F.PrintGradientLine()
        F.Print(L["Debug Enviroment"])
        print(L["You can use |cff00d1b2/wtdebug off|r command to exit debug mode."])
        print(format(L["After you stop debuging, %s will reenable the addons automatically."], W.Title))
        F.PrintGradientLine()
    end
end
