local W, F, E, L = unpack(select(2, ...))
local ST = W:NewModule("SuperTracker", "AceEvent-3.0", "AceHook-3.0")

local _G = _G

local IsAddOnLoaded = IsAddOnLoaded

local C_Map_ClearUserWaypoint = C_Map.ClearUserWaypoint
local C_Map_HasUserWaypoint = C_Map.HasUserWaypoint
local C_Navigation_GetDistance = C_Navigation.GetDistance
local C_SuperTrack_SetSuperTrackedUserWaypoint = C_SuperTrack.SetSuperTrackedUserWaypoint

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

    if self.db.distanceText.onlyNumber then
        _G.IN_GAME_NAVIGATION_RANGE = "%d"
    end
end

function ST:HookPin()
    if not self.db or not self.db.rightClickToClear then
        return
    end

    local EnumerateAllPins = _G.WorldMapFrame:EnumerateAllPins()
    local pin = EnumerateAllPins()
    while pin do
        if pin.pinTemplate and pin.pinTemplate == "WaypointLocationPinTemplate" then
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
            break
        end
        pin = EnumerateAllPins()
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
end

W:RegisterModule(ST:GetName())
