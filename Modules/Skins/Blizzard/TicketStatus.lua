local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("Blizzard_TicketStatus")
data.toggle = "misc"
data.private = "ticketStatus"

local _G = _G

function S:Blizzard_TicketStatus()
	self:CreateShadow(_G.TicketStatusFrameButton)
end

