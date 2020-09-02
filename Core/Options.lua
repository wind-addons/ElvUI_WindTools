local W, F, E, L, V, P, G = unpack(select(2, ...))
local tinsert = tinsert

-- 移动框架添加 WindTools 分类
tinsert(E.ConfigModeLayouts, 'WINDTOOLS')
E.ConfigModeLocalizedStrings['WINDTOOLS'] = L["WindTools"]