local W, F, E, L, V, P, G = unpack(select(2, ...))
local format, pairs, tonumber, type = format, pairs, tonumber, type

--[[
    更换字体描边为轮廓
    @param {object} text FontString 型对象
    @param {string} [font] 字型路径
    @param {number|string} [size] 字体尺寸或是尺寸变化量字符串
]]
function F.SetFontOutline(text, font, size)
    if not text or not text.GetFont then
        F.DebugMessage("函数", "找不到处理字体风格的字体")
        return
    end
    local fontName, fontHeight = text:GetFont()

    if size and type(size) == "string" then
        size = fontHeight + tonumber(size)
    end

    text:FontTemplate(font or fontName, size or fontHeight, "OUTLINE")
    text:SetShadowColor(0, 0, 0, 0)
    text.SetShadowColor = E.noop
end

--[[
    更换窗体内部字体描边为轮廓
    @param {object} frame 窗体
    @param {string} [font] 字型路径
    @param {number|string} [size] 字体尺寸或是尺寸变化量字符串
]]
function F.SetFrameFontOutline(frame, font, size)
    if not frame or not frame.GetRegions then
        F.DebugMessage("函数", "找不到处理字体风格的窗体")
        return
    end
    for _, region in pairs({frame:GetRegions()}) do
        if region:IsObjectType("FontString") then
            F.SetFontOutline(region, font, size)
        end
    end
end

--[[
    输出 Debug 信息
    @param {table/string} module Ace3 模块或自定义字符串
    @param {string} text 错误讯息
]]
function F.DebugMessage(module, text)
    if not text then
        return
    end

    if not module then
        module = "函数"
        text = "无模块名>" .. text
    end
    if type(module) ~= "string" and module.GetName then
        module = module:GetName()
    end
    local message = format("[WT - %s] %s", module, text)
    print(message)
end

--[[
    获取媒体资源路径
    @param {string} name 资源名
    @param {string} folder 分类目录
]]
function F.GetTexture(name, folder)
    local mediaPath = "Interface\\Addons\\ElvUI_WindUI\\Media\\"
    if folder then
        mediaPath = mediaPath .. folder .. "\\"
    end
    mediaPath = mediaPath .. name
    return mediaPath
end
