local W, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.Libs.LSM

local format = format
local pairs = pairs
local pcall = pcall
local print = print
local strbyte = strbyte
local strfind = strfind
local strlen = strlen
local strsub = strsub
local tinsert = tinsert
local tremove = tremove
local tonumber = tonumber
local type = type
local unpack = unpack

local GetClassColor = GetClassColor

--[[
    从数据库设定字体样式
    @param {object} text FontString 型对象
    @param {table} db 字体样式数据库
]]
function F.SetFontWithDB(text, db)
    if not text or not text.GetFont then
        F.DebugMessage("函数", "[1]找不到处理字体风格的字体")
        return
    end
    if not db or type(db) ~= "table" then
        F.DebugMessage("函数", "[1]找不到字体风格数据库")
        return
    end

    text:FontTemplate(LSM:Fetch("font", db.name), db.size, db.style)
end

--[[
    从数据库设定字体颜色
    @param {object} text FontString 型对象
    @param {table} db 字体颜色数据库
]]
function F.SetFontColorWithDB(text, db)
    if not text or not text.GetFont then
        F.DebugMessage("函数", "[2]找不到处理字体风格的字体")
        return
    end
    if not db or type(db) ~= "table" then
        F.DebugMessage("函数", "[1]找不到字体颜色数据库")
        return
    end

    text:SetTextColor(db.r, db.g, db.b, db.a)
end

--[[
    更换字体描边为轮廓
    @param {object} text FontString 型对象
    @param {string} [font] 字型路径
    @param {number|string} [size] 字体尺寸或是尺寸变化量字符串
]]
function F.SetFontOutline(text, font, size)
    if not text or not text.GetFont then
        F.DebugMessage("函数", "[3]找不到处理字体风格的字体")
        return
    end
    local fontName, fontHeight = text:GetFont()

    if size and type(size) == "string" then
        size = fontHeight + tonumber(size)
    end

    if font and not strfind(font, "%.ttf") and not strfind(font, "%.otf") then
        font = LSM:Fetch('font', font)
    end

    text:FontTemplate(font or fontName, size or fontHeight, "OUTLINE")
    text:SetShadowColor(0, 0, 0, 0)
    text.SetShadowColor = E.noop
end

--[[
    从数据库创建彩色字符串
    @param {string} text 文字
    @param {table} db 字体颜色数据库
]]
function F.CreateColorString(text, db)
    if not text or not type(text) == "string" then
        F.DebugMessage("函数", "[4]找不到处理字体风格的字体")
        return
    end

    if not db or type(db) ~= "table" then
        F.DebugMessage("函数", "[2]找不到字体颜色数据库")
        return
    end

    local hex = db.r and db.g and db.b and E:RGBToHex(db.r, db.g, db.b) or "|cffffffff"

    return hex .. text .. "|r"
end

--[[
    创建职业色字符串
    @param {string} text 文字
    @param {string} englishClass 职业名
]]
function F.CreateClassColorString(text, englishClass)
    if not text or not type(text) == "string" then
        F.DebugMessage("函数", "[5]找不到处理字体风格的字体")
        return
    end
    if not englishClass or type(englishClass) ~= "string" then
        F.DebugMessage("函数", "[3]职业错误")
        return
    end

    local r, g, b = GetClassColor(englishClass)
    local hex = r and g and b and E:RGBToHex(r, g, b) or "|cffffffff"

    return hex .. text .. "|r"
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
    if not (E.private and E.private.WT and E.private.WT.core.debugMode) then
        return
    end

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

    E:Delay(0.1, print, message)
end

--[[
    打印信息
    @param {string} text 文本
]]
function F.Print(text)
    if not text then
        return
    end

    local message = format("%s: %s", L["WindTools"], text)
    print(message)
end

--[[
    延迟去除全部模块函数钩子
    @param {table/string} module Ace3 模块或自定义字符串
]]
function F.DelayUnhookAll(module)
    if type(module) == "string" then
        module = W:GetModule(module)
    end

    if module then
        if module.UnhookAll then
            E:Delay(1, module.UnhookAll, module)
        else
            F.DebugMessage(module, "无 AceHook 库函数！")
        end
    else
        F.DebugMessage(nil, "找不到模块！")
    end
end

--[[
    分割 CJK 字符串
    @param {string} delimiter 分割符
    @param {string} subject 待分割字符串
    @return {table/string} 分割结果
]]
function F.SplitCJKString(delimiter, subject)
    if not subject or subject == "" then
        return {}
    end

    local length = strlen(delimiter)
    local results = {}

    local i = 0
    local j = 0

    while true do
        j = strfind(subject, delimiter, i + length)
        if strlen(subject) == i then
            break
        end

        if j == nil then
            tinsert(results, strsub(subject, i))
            break
        end

        tinsert(results, strsub(subject, i, j - 1))
        i = j + length
    end

    return unpack(results)
end

function F.Round(number, decimals)
    return format(format("%%.%df", decimals), number)
end

function F.SetCallback(callback, target, times, ...)
    times = times or 0
    if times >= 10 then
        return
    end

    if times < 10 then
        local result = {pcall(target, ...)}
        if result and result[1] == true then
            tremove(result, 1)
            if callback(unpack(result)) then
                return
            end
        end
    end

    E:Delay(0.1, F.SetCallback, callback, target, times+1, ...)
end