local W, F, E, L = unpack(select(2, ...))
local ST = W:NewModule("SuperTracker", "AceEvent-3.0", "AceHook-3.0")

local _G = _G

local tonumber = tonumber
local tinsert = tinsert

local IsAddOnLoaded = IsAddOnLoaded

local C_Map_ClearUserWaypoint = C_Map.ClearUserWaypoint
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_Map_HasUserWaypoint = C_Map.HasUserWaypoint
local C_Map_CanSetUserWaypointOnMap = C_Map.CanSetUserWaypointOnMap
local C_Navigation_GetDistance = C_Navigation.GetDistance
local C_SuperTrack_SetSuperTrackedUserWaypoint = C_SuperTrack.SetSuperTrackedUserWaypoint
local UiMapPoint_CreateFromCoordinates = UiMapPoint.CreateFromCoordinates
local C_Map_SetUserWaypoint = C_Map.SetUserWaypoint

function ST:ReskinDistanceText()
    if not _G.SuperTrackedFrame or not _G.SuperTrackedFrame.DistanceText then
        return
    end

    if not self.db or not self.db.distanceText or not self.db.distanceText.enable then
        return
    end

    F.SetFontWithDB(_G.SuperTrackedFrame.DistanceText, self.db.distanceText)
    _G.SuperTrackedFrame.DistanceText:SetTextColor(
        self.db.distanceText.color.r,
        self.db.distanceText.color.g,
        self.db.distanceText.color.b
    )
end

function ST:HookPin()
    if not self.db or not self.db.rightClickToClear then
        return
    end

    if _G.WorldMapFrame:GetNumActivePinsByTemplate("WaypointLocationPinTemplate") ~= 0 then
        for pin in _G.WorldMapFrame:EnumeratePinsByTemplate("WaypointLocationPinTemplate") do
            if not self:IsHooked(pin, "OnMouseClickAction") then
                self:SecureHook(
                    pin,
                    "OnMouseClickAction",
                    function(_, button)
                        if button == "RightButton" then
                            C_Map_ClearUserWaypoint()
                        end
                    end
                )
            end
        end
    end
end

function ST:NoLimit()
    if not _G.SuperTrackedFrame then
        return
    end

    if not self.db or not self.db.noLimit then
        return
    end

    self:RawHook(
        _G.SuperTrackedFrame,
        "GetTargetAlphaBaseValue",
        function(frame)
            if C_Navigation_GetDistance() > 999 then
                return 1
            else
                return self.hooks[_G.SuperTrackedFrame]["GetTargetAlphaBaseValue"](frame)
            end
        end,
        true
    )
end

function ST.commandHandler(msg)
    msg =
        F.Strings.Replace(
        msg,
        {
            ["　"] = " ",
            ["．"] = ".",
            [","] = " ",
            ["，"] = " ",
            ["/"] = " ",
            ["＂"] = " ",
            ["'"] = " ",
            ['"'] = " ",
            ["["] = " ",
            ["]"] = " ",
            ["("] = " ",
            [")"] = " ",
            ["（"] = " ",
            ["）"] = " ",
            ["的"] = " ",
            ["在"] = " ",
            ["于"] = " "
        }
    )

    local numbers = {}
    local words = {F.Strings.Split(msg.." ", " ")}

    if #words < 3 then
        F.Print(L["The argument is invalid."])
        return
    end

    for _, n in ipairs(words) do
        local num = tonumber(n)

        if not strmatch(n, "%.$") and num then
            tinsert(numbers, num)
        end
    end

    if #numbers < 2 then
        F.Print(L["The argument is invalid."])
        return
    end

    ST:SetWaypoint(unpack(numbers))
end

function ST:SetWaypoint(x, y, z)
    local mapID = C_Map_GetBestMapForUnit("player")

    -- colored waypoint string
    local waypointString = "|cff209cee(" .. x .. ", " .. y
    if z then
        waypointString = waypointString .. ", " .. z
    end
    waypointString = waypointString .. ")|r"

    -- if not scaled, just do it here
    if x > 1 and y > 1 then
        x = x / 100
        y = y / 100
        z = z and z / 100
    end

    if C_Map_CanSetUserWaypointOnMap(mapID) then
        C_Map_SetUserWaypoint(UiMapPoint_CreateFromCoordinates(mapID, x, y, z))
        F.Print(format(L["Waypoint %s has been set."], waypointString))
    else
        self:Log("warning", L["Can not set waypoint on this map."])
    end
end

function ST:USER_WAYPOINT_UPDATED()
    if C_Map_HasUserWaypoint() then
        if self.db and self.db.autoTrackWaypoint then
            E:Delay(0.1, C_SuperTrack_SetSuperTrackedUserWaypoint, true)
        end
        E:Delay(0.15, self.HookPin, self)
    end
end

function ST:ADDON_LOADED(_, addon)
    if addon == "Blizzard_QuestNavigation" then
        self:UnregisterEvent("ADDON_LOADED")
        self:NoLimit()
        self:ReskinDistanceText()
    end
end

function ST:Initialize()
    self.db = E.private.WT.maps.superTracker

    if not self.db or not self.db.enable then
        return
    end

    if self.db.rightClickToClear then
        self:SecureHook(_G.WorldMapFrame, "Show", "HookPin")
    end

    if self.db.autoTrackWaypoint or self.db.rightClickToClear then
        self:RegisterEvent("USER_WAYPOINT_UPDATED")
        self:USER_WAYPOINT_UPDATED()
    end

    if not IsAddOnLoaded("Blizzard_QuestNavigation") then
        self:RegisterEvent("ADDON_LOADED")
        return
    end

    self:NoLimit()
    self:ReskinDistanceText()

    if self.db.command.enable then
        W:AddCommand("SUPER_TRACKER", self.db.command.keys, self.commandHandler)
    end
end

W:RegisterModule(ST:GetName())
