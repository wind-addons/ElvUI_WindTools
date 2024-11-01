local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local next = next

local CLASS_SORT_ORDER = CLASS_SORT_ORDER

function S:Blizzard_Calendar()
	if not self:CheckDB("calendar") then
		return
	end

	self:CreateBackdropShadow(_G.CalendarFrame)

	self:CreateShadow(_G.CalendarViewRaidFrame)
	self:CreateShadow(_G.CalendarViewHolidayFrame)
	self:CreateShadow(_G.CalendarMassInviteFrame)
	self:CreateShadow(_G.CalendarViewEventFrame)
	self:CreateShadow(_G.CalendarCreateEventFrame)

	for index in next, CLASS_SORT_ORDER do
		local button = _G["CalendarClassButton" .. index]

		if button then
			if not button.backdrop then
				button:CreateBackdrop()
			end
			self:CreateBackdropShadow(button)
		end

		if index == 1 then
			F.MoveFrameWithOffset(button, 10, -5)
		end
	end

	self:CreateShadow(_G.CalendarClassTotalsButton)
end

S:AddCallbackForAddon("Blizzard_Calendar")
