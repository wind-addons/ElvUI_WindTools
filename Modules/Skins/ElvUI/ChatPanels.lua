local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("ElvUI_ChatPanels")
data.check = function()
	return (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.chatPanels)
end
local LO = E:GetModule("Layout")

local _G = _G

function S:ElvUI_ChatPanels()
	self:CreateBackdropShadow(_G.LeftChatPanel, true)
	self:CreateBackdropShadow(_G.RightChatPanel, true)
end

