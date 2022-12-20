local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_Calendar()
    if not self:CheckDB("calendar") then
        return
    end

    self:CreateBackdropShadow(_G.CalendarFrame)

    self:CreateShadow(_G.CalendarViewRaidFrame)
    self:CreateShadow(_G.CalendarViewHolidayFrame)
    self:CreateShadow(_G.CalendarMassInviteFrame)

    self:CreateShadow(_G.CalendarViewEventFrame)

    for index in next, CLASS_SORT_ORDER do
        local button = _G["CalendarClassButton" .. index]
        if button then
            self:CreateShadow(button)
        end
    end

    self:CreateShadow(_G.CalendarClassTotalsButton)
end

S:AddCallbackForAddon("Blizzard_Calendar")
