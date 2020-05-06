local W, F, E, L, V, P, G = unpack(select(2, ...))
local format, pairs, tonumber, type = format, pairs, tonumber, type

---------------------------------------------------
-- 函数：更换字体描边为 OUTLINE
-- 必要参数
-- - text(object) FontString 型 Object
-- 可选参数
-- - font(string) 字型路径，nil 时为当前字型
-- - size(number/string) 字体尺寸或是尺寸变化量字符串，nil 时为当前尺寸
---------------------------------------------------
function F.SetFontOutline(text, font, size)
    local fontName, fontHeight = text:GetFont()

    if size and type(size) == "string" then size = fontHeight + tonumber(size) end

    text:FontTemplate(font or fontName, size or fontHeight, "OUTLINE")
    text:SetShadowColor(0, 0, 0, 0)
    text.SetShadowColor = E.noop
end

---------------------------------------------------
-- 函数：更换框体内部字体描边为 OUTLINE
-- 必要参数
-- - frame(object) Frame 型 Object
-- 可选参数
-- - font(string) 字型路径，nil 时为当前字型
-- - size(number/string) 字体尺寸或是尺寸变化量字符串，nil 时为当前尺寸
---------------------------------------------------
function F.SetFrameFontOutline(frame, font, size)
    for _, region in pairs({frame:GetRegions()}) do
        if region:IsObjectType("FontString") then F.SetFontOutline(region, font, size) end
    end
end

---------------------------------------------------
-- 函数：输出 Debug 信息
-- 必要参数
-- - module(table, string) Ace3 模块或字符串
-- - text(string) 错误讯息
---------------------------------------------------
function F.DebugMessage(module, text)
    if type(module) ~= "string" then module = module:GetName() end
    local message = format("[WindUI - %s] %s", module, text)
    print(message)
end

---------------------------------------------------
-- 函数：获取媒体资源路径
-- 必要参数
-- - name(string) 资源名
-- 可选参数
-- - folder(string) 分类目录
---------------------------------------------------
function F.GetTexture(name, folder)
    local mediaPath = "Interface\\Addons\\ElvUI_WindUI\\Media\\"
    if folder then mediaPath = mediaPath .. folder .. "\\" end
    mediaPath = mediaPath .. name
    return mediaPath
end
