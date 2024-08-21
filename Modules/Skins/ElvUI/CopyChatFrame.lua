local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local CH = E:GetModule("Chat")

local _G = _G

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
