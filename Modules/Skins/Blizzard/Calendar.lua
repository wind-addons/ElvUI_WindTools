local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:Blizzard_Calendar()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.calendar) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.calendar) then return end

    S:CreateShadow(_G.CalendarFrame)
    S:CreateShadow(_G.CalendarViewHolidayFrame)
end

S:AddCallbackForAddon('Blizzard_Calendar')