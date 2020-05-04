local W, F, E, L, V, P, G = unpack(select(2, ...))

local format = format

function F.SetFontOutline(text, font, size)
    local fontName, fontHeight = text:GetFont()
    text:FontTemplate(font or fontName, size or fontHeight, "OUTLINE")
    text:SetShadowColor(0, 0, 0, 0)
    text.SetShadowColor = E.noop
end

function F.DebugMessage(module, text)
    local moduleName = module:GetName()
    local message = format("[WindUI - %s] %s", moduleName, text)
    print(message)
end

function F.GetTexture(name, folder)
    local mediaPath = "Interface\\Addons\\ElvUI_WindUI\\Media\\"
    if folder then mediaPath = mediaPath .. folder .. "\\" end
    mediaPath = mediaPath .. name
    print(mediaPath)
    return mediaPath
end
