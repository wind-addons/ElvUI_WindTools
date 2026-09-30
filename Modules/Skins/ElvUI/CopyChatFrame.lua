local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local CH = E:GetModule("Chat")

S:AddCallback("ElvUICopyChatFrame", S:CreateElvUICheck("chatCopyFrame"))

function S:ElvUICopyChatFrame()
	if CH and CH.CopyChatFrame then
		self:CreateShadow(CH.CopyChatFrame)
	end

	if CH and CH.CopyChatFrameEditBox then
		F.SetFont(CH.CopyChatFrameEditBox)
	end
end
