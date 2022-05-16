local W, F, E, L, V, P, G = unpack(select(2, ...))

local _G = _G

local type = type
local strsub = strsub

local function AddCommand(name, keys, func)
    if not _G.SlashCmdList[name] then
        _G.SlashCmdList[name] = func

        if type(keys) == "table" then
            for i, key in next, keys do
                if strsub(key, 1, 1) ~= "/" then
                    key = "/" .. key
                end
                _G["SLASH_" .. name .. i] = key
            end
        else
            if strsub(keys, 1, 1) ~= "/" then
                keys = "/" .. keys
            end
            _G["SLASH_" .. name .. "1"] = keys
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

    AddCommand(
        "WINDTOOLS_ERROR",
        "/wtdebug",
        function(msg)
            local switch = strlower(msg)
            if switch == "on" or switch == "1" then
                for i = 1, GetNumAddOns() do
                    local name = GetAddOnInfo(i)
                    if not AcceptableAddons[name] and E:IsAddOnEnabled(name) then
                        DisableAddOn(name, E.myname)
                        ElvDB.WT.DisabledAddOns[name] = i
                    end
                end

                SetCVar("scriptErrors", 1)
                ReloadUI()
            elseif switch == "off" or switch == "0" then
                SetCVar("scriptProfile", 0)
                SetCVar("scriptErrors", 0)
                E:Print("Lua errors off.")

                if E:IsAddOnEnabled("ElvUI_CPU") then
                    DisableAddOn("ElvUI_CPU")
                end

                if next(ElvDB.WT.DisabledAddOns) then
                    for name in pairs(ElvDB.WT.DisabledAddOns) do
                        EnableAddOn(name, E.myname)
                    end

                    wipe(ElvDB.WT.DisabledAddOns)
                    ReloadUI()
                end
            else
                F.Print("/wtdebug on - /wtdebug off")
            end
        end
    )
end
