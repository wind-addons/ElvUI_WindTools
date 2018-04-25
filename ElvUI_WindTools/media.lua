-- 自用素材包
-- 作者：houshuu
-- 素材来自于各个地方无法一一列举了
-- 可以自己複製對應語言的一行代碼來模仿添加自己的材質哦~！
local LSM = LibStub("LibSharedMedia-3.0")
local region = 128
if GetLocale() == 'zhCN' then region = 4 end
if GetLocale() == 'zhTW' then region = 8 end

-- English
LSM:Register("font", "Vistor", [[Interface\Addons\ElvUI_WindTools\Fonts\EN_Vistor.ttf]], region) 
LSM:Register("font", "BigNoodle", [[Interface\Addons\ElvUI_WindTools\Fonts\EN_BigNoodle.ttf]], region) 
LSM:Register("font", "US 101", [[Interface\Addons\ElvUI_WindTools\Fonts\EN_US_101.ttf]], region) 
LSM:Register("font", "VenturaEdding", [[Interface\Addons\ElvUI_WindTools\Fonts\EN_VenturaEdding.ttf]], region) 
LSM:Register("font", "FTY", [[Interface\Addons\ElvUI_WindTools\Fonts\EN_FTY.ttf]], region) 
LSM:Register("font", "Futura", [[Interface\Addons\ElvUI_WindTools\Fonts\EN_Futura_NO2_D.ttf]], region)
LSM:Register("font", "Accidental Presidency", [[Interface\Addons\ElvUI_WindTools\Fonts\EN_Accidental_Presidency.ttf]], region)
LSM:Register("font", "ElvUI PT Sans Narrow", [[Interface\Addons\ElvUI_WindTools\Fonts\EN_PT_Sans_Narrow.ttf]], region)
LSM:Register("font", "Magistral", [[Interface\Addons\ElvUI_WindTools\Fonts\EN_Magistral.ttf]], region) 
LSM:Register("font", "Roadway", [[Interface\Addons\ElvUI_WindTools\Fonts\EN_Roadway.ttf]], region) 
-- 简体
if region == 4 then
	LSM:Register("font", "思源黑体 Heavy", [[Interface\Addons\ElvUI_WindTools\Fonts\CN_Siyuan_Heavy.ttf]], region) 
	LSM:Register("font", "思源黑体 Bold", [[Interface\Addons\ElvUI_WindTools\Fonts\CN_Siyuan_Bold.ttf]], region)
	LSM:Register("font", "思源黑体 Medium", [[Interface\Addons\ElvUI_WindTools\Fonts\CN_Siyuan_Medium.ttf]], region)
	LSM:Register("font", "微软雅黑Myriad", [[Interface\Addons\ElvUI_WindTools\Fonts\CN_YaHei_myriadpro.ttf]], region)
end
-- 正體
if region == 8 then
	LSM:Register("font", "思源黑體 Heavy", [[Interface\Addons\ElvUI_WindTools\Fonts\CN_Siyuan_Heavy.ttf]], region) 
	LSM:Register("font", "思源黑體 Bold", [[Interface\Addons\ElvUI_WindTools\Fonts\CN_Siyuan_Bold.ttf]], region)
	LSM:Register("font", "思源黑體 Medium", [[Interface\Addons\ElvUI_WindTools\Fonts\CN_Siyuan_Medium.ttf]], region)
	LSM:Register("font", "微軟雅黑Myriad", [[Interface\Addons\ElvUI_WindTools\Fonts\CN_YaHei_myriadpro.ttf]], region)
	LSM:Register("font", "王漢宗綜藝", [[Interface\Addons\ElvUI_WindTools\Fonts\TW_Zongyi_Bold.ttf]], region)
	LSM:Register("font", "王漢宗粗圓", [[Interface\Addons\ElvUI_WindTools\Fonts\TW_Yuan_Bold.ttf]], region)
	LSM:Register("font", "王漢宗顏楷", [[Interface\Addons\ElvUI_WindTools\Fonts\TW_Yankai_Bold.ttf]], region)
	LSM:Register("font", "王漢宗粗鋼", [[Interface\Addons\ElvUI_WindTools\Fonts\TW_Gang_Bold.ttf]], region)
end

-- 状态条材质
-- ElvUI_CustomMedia
LSM:Register("statusbar", "ElvUI_01", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI A.tga]]) 
LSM:Register("statusbar", "ElvUI_02", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI B.tga]]) 
LSM:Register("statusbar", "ElvUI_03", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI C.tga]]) 
LSM:Register("statusbar", "ElvUI_04", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI D.tga]]) 
LSM:Register("statusbar", "ElvUI_05", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI E.tga]]) 
LSM:Register("statusbar", "ElvUI_06", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI F.tga]]) 
LSM:Register("statusbar", "ElvUI_07", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI G.tga]]) 
LSM:Register("statusbar", "ElvUI_08", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI H.tga]]) 
LSM:Register("statusbar", "ElvUI_09", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI I.tga]]) 
LSM:Register("statusbar", "ElvUI_10", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI J.tga]]) 
LSM:Register("statusbar", "ElvUI_11", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI K.tga]]) 
LSM:Register("statusbar", "ElvUI_12", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI L.tga]]) 
LSM:Register("statusbar", "ElvUI_13", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI M.tga]]) 
LSM:Register("statusbar", "ElvUI_14", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI N.tga]]) 
LSM:Register("statusbar", "ElvUI_15", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI O.tga]]) 
LSM:Register("statusbar", "ElvUI_16", [[Interface\Addons\ElvUI_WindTools\Statusbar\ElvUI P.tga]])
-- FreeUI.Fluffy
LSM:Register("statusbar", "ElvUI_17", [[Interface\Addons\ElvUI_WindTools\Statusbar\FF_Angelique.tga]]) 
LSM:Register("statusbar", "ElvUI_18", [[Interface\Addons\ElvUI_WindTools\Statusbar\FF_Antonia.tga]]) 
LSM:Register("statusbar", "ElvUI_19", [[Interface\Addons\ElvUI_WindTools\Statusbar\FF_Bettina.tga]]) 
LSM:Register("statusbar", "ElvUI_20", [[Interface\Addons\ElvUI_WindTools\Statusbar\FF_Jasmin.tga]]) 
LSM:Register("statusbar", "ElvUI_21", [[Interface\Addons\ElvUI_WindTools\Statusbar\FF_Larissa.tga]]) 
LSM:Register("statusbar", "ElvUI_22", [[Interface\Addons\ElvUI_WindTools\Statusbar\FF_Lisa.tga]])
LSM:Register("statusbar", "ElvUI_23", [[Interface\Addons\ElvUI_WindTools\Statusbar\FF_Sam.tga]])
LSM:Register("statusbar", "ElvUI_24", [[Interface\Addons\ElvUI_WindTools\Statusbar\FF_Stella.tga]])