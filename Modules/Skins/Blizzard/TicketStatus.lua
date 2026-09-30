local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallback("Blizzard_TicketStatus", "misc", "ticketStatus")

function S:Blizzard_TicketStatus()
	self:CreateShadow(_G.TicketStatusFrameButton)
end
