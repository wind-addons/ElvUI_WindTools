local W, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.Libs.LSM

local _G = _G
local abs = abs
local format = format
local min = min
local pairs = pairs
local pcall = pcall
local print = print
local strfind = strfind
local strmatch = strmatch
local tonumber = tonumber
local tremove = tremove
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
        F.Developer.LogDebug("Functions.SetFontWithDB: text not found")
        return
    end

    if not db or type(db) ~= "table" then
        F.Developer.LogDebug("Functions.SetFontWithDB: db not found")
        return
    end

    local fontName, fontHeight = text:GetFont()

    text:FontTemplate(db.name and LSM:Fetch("font", db.name) or fontName, db.size or fontHeight, db.style or "NONE")
end

--[[
    从数据库设定字体颜色
    @param {object} text FontString 型对象
    @param {table} db 字体颜色数据库
]]
function F.SetFontColorWithDB(text, db)
    if not text or not text.GetFont then
        F.Developer.LogDebug("Functions.SetFontColorWithDB: text not found")
        return
    end
    if not db or type(db) ~= "table" then
        F.Developer.LogDebug("Functions.SetFontColorWithDB: db not found")
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
        F.Developer.LogDebug("Functions.SetFontOutline: text not found")
        return
    end
    local fontName, fontHeight = text:GetFont()

    if size and type(size) == "string" then
        size = fontHeight + tonumber(size)
    end

    if font and not strfind(font, "%.ttf") and not strfind(font, "%.otf") then
        font = LSM:Fetch("font", font)
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
        F.Developer.LogDebug("Functions.CreateColorString: text not found")
        return
    end

    if not db or type(db) ~= "table" then
        F.Developer.LogDebug("Functions.CreateColorString: db not found")
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
        F.Developer.LogDebug("Functions.CreateClassColorString: text not found")
        return
    end
    if not englishClass or type(englishClass) ~= "string" then
        F.Developer.LogDebug("Functions.CreateClassColorString: class not found")
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
        F.Developer.LogDebug("Functions.SetFrameFontOutline: frame not found")
        return
    end
    for _, region in pairs({frame:GetRegions()}) do
        if region:IsObjectType("FontString") then
            F.SetFontOutline(region, font, size)
        end
    end
end

do
    local gradientLine =
        E:TextGradient(
        "----------------------------------",
        0.910,
        0.314,
        0.357,
        0.976,
        0.835,
        0.431,
        0.953,
        0.925,
        0.761,
        0.078,
        0.694,
        0.671
    )

    function F.PrintGradientLine()
        print(gradientLine)
    end
end

--[[
    打印信息
    @param {string} text 文本
]]
function F.Print(text)
    if not text then
        return
    end

    local message = format("%s: %s", W.Title, text)
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
            F.Developer.LogDebug("Functions.DelayUnhookAll: AceHook class not found!")
        end
    else
        F.Developer.LogDebug("Functions.DelayUnhookAll: Module not found!")
    end
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

    E:Delay(0.1, F.SetCallback, callback, target, times + 1, ...)
end

do
    local pattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)")
    function F.GetRealItemLevelByLink(link)
        E.ScanTooltip:SetOwner(_G.UIParent, "ANCHOR_NONE")
        E.ScanTooltip:ClearLines()
        E.ScanTooltip:SetHyperlink(link)

        for i = 2, 5 do
            local leftText = _G[E.ScanTooltip:GetName() .. "TextLeft" .. i]
            if leftText then
                local text = leftText:GetText() or ""
                local level = strmatch(text, pattern)
                if level then
                    return level
                end
            end
        end
    end
end

do
    local color = {
        start = {
            r = 1.000,
            g = 0.647,
            b = 0.008
        },
        complete = {
            r = 0.180,
            g = 0.835,
            b = 0.451
        }
    }

    function F.GetProgressColor(progress)
        local r = (color.complete.r - color.start.r) * progress + color.start.r
        local g = (color.complete.g - color.start.g) * progress + color.start.g
        local b = (color.complete.r - color.start.b) * progress + color.start.b

        -- algorithm to let the color brighter
        local addition = 0.35
        r = min(r + abs(0.5 - progress) * addition, r)
        g = min(g + abs(0.5 - progress) * addition, g)
        b = min(b + abs(0.5 - progress) * addition, b)

        return {r = r, g = g, b = b}
    end
end

function F.SetVertexColorWithDB(tex, db)
    if not tex or not tex.GetVertexColor then
        F.Developer.LogDebug("Functions.SetVertexColorWithDB: No texture to handling")
        return
    end
    if not db or type(db) ~= "table" then
        F.Developer.LogDebug("Functions.SetVertexColorWithDB: No texture color database")
        return
    end

    tex:SetVertexColor(db.r, db.g, db.b, db.a)
end

function F.GetWindStyleText(text)
    return E:TextGradient(text, 0.32941, 0.52157, 0.93333, 0.29020, 0.70980, 0.89412, 0.25882, 0.84314, 0.86667)
end
