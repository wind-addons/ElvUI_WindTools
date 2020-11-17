local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_Calendar()
    if not self:CheckDB("calendar") then
        return
    end

    self:CreateBackdropShadow(_G.CalendarFrame)
    self:CreateBackdropShadow(_G.CalendarViewHolidayFrame)
end

S:AddCallbackForAddon("Blizzard_Calendar")
