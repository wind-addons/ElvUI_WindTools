local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_TicketStatus()
	if not self:CheckDB("misc", "ticketStatus") then
		return
	end

	self:CreateShadow(_G.TicketStatusFrameButton)
end

S:AddCallback("Blizzard_TicketStatus")
