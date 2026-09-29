local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("ElvUICopyChatFrame")
data.check = function()
	return (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.chatCopyFrame)
end
local CH = E:GetModule("Chat")

function S:ElvUICopyChatFrame()
	if CH and CH.CopyChatFrame then
		self:CreateShadow(CH.CopyChatFrame)
	end

	if CH and CH.CopyChatFrameEditBox then
		F.SetFont(CH.CopyChatFrameEditBox)
	end
end

