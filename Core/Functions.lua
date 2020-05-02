local W, F, E, L, V, P, G = unpack(select(2, ...))

function F.SetFontOutline(text, font, size)
    local fontName, fontHeight = text:GetFont()
    text:FontTemplate(font or fontName, size or fontHeight, "OUTLINE")
end