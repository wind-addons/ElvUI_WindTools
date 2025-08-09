local W, F, E, L, V, P, G = unpack((select(2, ...)))
local LSM = E.Libs.LSM

local _G = _G
local abs = abs
local format = format
local min = min
local pairs = pairs
local pcall = pcall
local print = print
local select = select
local strfind = strfind
local strmatch = strmatch
local tonumber = tonumber
local tostring = tostring
local tremove = tremove
local type = type
local unpack = unpack

local GenerateFlatClosure = GenerateFlatClosure
local GetClassColor = GetClassColor
local GetInstanceInfo = GetInstanceInfo
local RunNextFrame = RunNextFrame

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

	if englishClass == "" then
		return text
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
	for _, region in pairs({ frame:GetRegions() }) do
		if region:IsObjectType("FontString") then
			F.SetFontOutline(region, font, size)
		end
	end
end

function F.PrintGradientLine()
	local HexToRGB = W.Utilities.Color.HexToRGB
	local r1, g1, b1 = HexToRGB("f0772f")
	local r2, g2, b2 = HexToRGB("f34a62")
	local r3, g3, b3 = HexToRGB("bb77ed")
	local r4, g4, b4 = HexToRGB("1cdce8")

	local gradientLine =
		E:TextGradient("----------------------------------", r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4)
	print(gradientLine)
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
		local result = { pcall(target, ...) }
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
			b = 0.008,
		},
		complete = {
			r = 0.180,
			g = 0.835,
			b = 0.451,
		},
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

		return { r = r, g = g, b = b }
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

function F.In(val, tbl)
	if not val or not tbl or type(tbl) ~= "table" then
		return false
	end

	for _, v in pairs(tbl) do
		if v == val then
			return true
		end
	end

	return false
end

function F.IsNaN(val)
	return tostring(val) == tostring(0 / 0)
end

function F.Or(val, default)
	if not val or F.IsNaN(val) then
		return default
	end
	return val
end

function F.DelvesEventFix(original, func)
	local isWaiting = false

	return function(...)
		local difficulty = select(3, GetInstanceInfo())
		if not difficulty or difficulty ~= 208 then
			return original(...)
		end

		if isWaiting then
			return
		end

		local f = GenerateFlatClosure(original, ...)

		RunNextFrame(function()
			if not isWaiting then
				isWaiting = true
				E:Delay(3, function()
					f()
					isWaiting = false
				end)
			end
		end)
	end
end

function F.WaitFor(condition, callback, interval, leftTimes)
	leftTimes = (leftTimes or 10) - 1
	interval = interval or 0.1

	if condition() then
		callback()
		return
	end

	if leftTimes and leftTimes <= 0 then
		return
	end

	E:Delay(interval, F.WaitFor, condition, callback, interval, leftTimes)
end

function F.MoveFrameWithOffset(frame, x, y)
	if not frame or not frame.ClearAllPoints then
		return
	end

	local setPoint = frame.__SetPoint or frame.SetPoint

	local pointsData = {}

	for i = 1, frame:GetNumPoints() do
		local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(i)
		pointsData[i] = { point, relativeTo, relativePoint, xOfs, yOfs }
	end

	frame:ClearAllPoints()

	for _, data in pairs(pointsData) do
		local point, relativeTo, relativePoint, xOfs, yOfs = unpack(data)
		setPoint(frame, point, relativeTo, relativePoint, xOfs + x, yOfs + y)
	end
end
