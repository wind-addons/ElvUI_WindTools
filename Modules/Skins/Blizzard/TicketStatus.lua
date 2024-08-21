local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_TicketStatus()
	if not self:CheckDB("misc", "ticketStatus") then
		return
	end

	self:CreateShadow(_G.TicketStatusFrameButton)
end

S:AddCallback("Blizzard_TicketStatus")
