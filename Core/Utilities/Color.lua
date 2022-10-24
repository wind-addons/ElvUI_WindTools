local W, F, E, L, V, P, G = unpack(select(2, ...))

W.Utilities.Color = {}
local U = W.Utilities.Color

local CreateColor = CreateColor

function U.CreateColorFromTable(colorTable)
    return CreateColor(colorTable.r, colorTable.g, colorTable.b, colorTable.a)
end

function U.ExtractColorFromTable(colorTable, override)
    local r = override and override.r or colorTable.r or 1
    local g = override and override.g or colorTable.g or 1
    local b = override and override.b or colorTable.b or 1
    local a = override and override.a or colorTable.a or 1
    return r, g, b, a
end

function U.IsRGBEqual(color1, color2)
    return color1.r == color2.r and color1.g == color2.g and color1.b == color2.b
end