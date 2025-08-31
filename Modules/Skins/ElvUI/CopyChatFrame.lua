local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local CH = E:GetModule("Chat")

function S:ElvUICopyChatFrame()
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.chatCopyFrame) then
		return
	end

	if CH and CH.CopyChatFrame then
		self:CreateShadow(CH.CopyChatFrame)
	end

	if CH and CH.CopyChatFrameEditBox then
		F.SetFontOutline(CH.CopyChatFrameEditBox)
	end
end

S:AddCallback("ElvUICopyChatFrame")
