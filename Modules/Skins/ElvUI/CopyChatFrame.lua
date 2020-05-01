local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:ElvUICopyChatFrame()
    if not E.db.chat.chatHistory then return end
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.chatCopyFrame) then return end

    S:CreateShadow(_G.CopyChatFrame)
end

S:AddCallback('ElvUICopyChatFrame')