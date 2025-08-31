local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local M = W.Modules.Misc ---@class Misc

local CreateFrame = CreateFrame
local IsInInstance = IsInInstance

local C_CVar_SetCVar = C_CVar.SetCVar

local function toggleChatBubbles()
	C_CVar_SetCVar("chatBubbles", IsInInstance() and 1 or 0)
end

function M:AutoToggleChatBubble()
	if E.private.WT.misc.autoToggleChatBubble then
		local frame = CreateFrame("Frame")
		frame:SetScript("OnEvent", toggleChatBubbles)
		frame:RegisterEvent("PLAYER_ENTERING_WORLD")
		frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		frame:RegisterEvent("ZONE_CHANGED_INDOORS")
		frame:RegisterEvent("ZONE_CHANGED")

		toggleChatBubbles()
	end
end

M:AddCallback("AutoToggleChatBubble")
