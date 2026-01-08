local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local M = W.Modules.Misc ---@class Misc

local _G = _G
local ipairs = ipairs

local function UpdateEditBoxText(editBox, userInput)
	local text = editBox:GetText()
	if userInput and text == "、" then
		editBox:SetText("/")
	end
end

function M:PauseToSlash()
	if not E.private.WT.misc.pauseToSlash then
		return
	end

	for _, frameName in ipairs(_G.CHAT_FRAMES) do
		local chat = _G[frameName]
		if chat and chat.editBox then
			chat.editBox:HookScript("OnTextChanged", UpdateEditBoxText)
		end
	end
end

M:AddCallback("PauseToSlash")
