local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

function S:ElvUICopyChatFrame()
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.chatCopyFrame) then
        return
    end

    self:CreateShadow(_G.CopyChatFrame)
    F.SetFontOutline(_G.CopyChatFrameEditBox)
end

S:AddCallback("ElvUICopyChatFrame")
