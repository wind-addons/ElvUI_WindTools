local W, F, E, L = unpack((select(2, ...)))
local M = W.Modules.Misc
local RangeCheck = E.Libs.RangeCheck

local floor = floor
local format = format
local pairs = pairs
local select = select
local strlen = strlen
local strlower = strlower
local strsub = strsub

local GetClassColor = GetClassColor
local GetClassInfo = GetClassInfo
local GetNumClasses = GetNumClasses
local UnitClass = UnitClass
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsConnected = UnitIsConnected
local UnitIsUnit = UnitIsUnit
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax

local function GetClassColorString(class)
	local hexString = select(4, GetClassColor(class))
	return "|c" .. hexString
end

local function GetHealthPercent(unit, formatString)
	local healthMax = UnitHealthMax(unit)
	if healthMax == 0 then
		return ""
	end
	return format(formatString, UnitHealth(unit) / healthMax * 100)
end

local function GetAbsorbPercent(unit, formatString)
	local healthMax = UnitHealthMax(unit)
	if healthMax == 0 then
		return ""
	end
	local absorb = UnitGetTotalAbsorbs(unit) or 0
	if absorb ~= 0 then
		return format(formatString, absorb / healthMax * 100)
	end
end

function M:Tags()
	if not E.private.WT.misc.tags then
		return
	end

	E:AddTag("absorbs-long", "UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
		local absorb = UnitGetTotalAbsorbs(unit) or 0
		return absorb ~= 0 and absorb or ""
	end)

	E:AddTag("absorbs:percent-0", "UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
		local absorb = UnitGetTotalAbsorbs(unit) or 0
		if absorb ~= 0 then
			return GetAbsorbPercent(unit, "%d%%")
		end
	end)

	E:AddTag("absorbs:percent-1", "UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
		local absorb = UnitGetTotalAbsorbs(unit) or 0
		if absorb ~= 0 then
			return GetAbsorbPercent(unit, "%.1f%%")
		end
	end)

	E:AddTag("absorbs:percent-2", "UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
		local absorb = UnitGetTotalAbsorbs(unit) or 0
		if absorb ~= 0 then
			return GetAbsorbPercent(unit, "%.2f%%")
		end
	end)

	E:AddTag("absorbs:percent-3", "UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
		local absorb = UnitGetTotalAbsorbs(unit) or 0
		if absorb ~= 0 then
			return GetAbsorbPercent(unit, "%.3f%%")
		end
	end)

	E:AddTag("absorbs:percent-nosign-0", "UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
		local absorb = UnitGetTotalAbsorbs(unit) or 0
		if absorb ~= 0 then
			return GetAbsorbPercent(unit, "%d")
		end
	end)

	E:AddTag("absorbs:percent-nosign-1", "UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
		local absorb = UnitGetTotalAbsorbs(unit) or 0
		if absorb ~= 0 then
			return GetAbsorbPercent(unit, "%.1f")
		end
	end)

	E:AddTag("absorbs:percent-nosign-2", "UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
		local absorb = UnitGetTotalAbsorbs(unit) or 0
		if absorb ~= 0 then
			return GetAbsorbPercent(unit, "%.2f")
		end
	end)

	E:AddTag("range", 0.1, function(unit)
		if UnitIsConnected(unit) and not UnitIsUnit(unit, "player") then
			local minRange, maxRange = RangeCheck:GetRange(unit, true)
			return minRange and maxRange and format("%s - %s", minRange, maxRange) or ""
		end
	end)

	E:AddTag("range:expectation", 0.1, function(unit)
		if UnitIsConnected(unit) and not UnitIsUnit(unit, "player") then
			local minRange, maxRange = RangeCheck:GetRange(unit, true)
			return minRange and maxRange and format("%s", floor((minRange + maxRange) / 2)) or ""
		end
	end)

	-- 职业颜色
	E:AddTag("classcolor:player", 1e10, function()
		return GetClassColorString(E.myclass)
	end)

	for i = 1, GetNumClasses() do
		local upperText = select(2, GetClassInfo(i))
		local tag = "classcolor:" .. strlower(upperText)
		E:AddTag(tag, 1e10, function()
			return GetClassColorString(upperText)
		end)
	end

	-- 血量百分比 去除百分号
	E:AddTag("health:percent-nosign", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
		local originalString = E.oUF.Tags.Methods["health:percent"](unit)
		local length = strlen(originalString)
		if strsub(originalString, length, length) == "%" then
			return strsub(originalString, 1, length - 1)
		else
			return originalString
		end
	end)

	-- 无状态血量百分比 去除百分号
	E:AddTag("health:percent-nostatus-nosign", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
		local originalString = E.oUF.Tags.Methods["health:percent-nostatus"](unit)
		local length = strlen(originalString)
		if strsub(originalString, length, length) == "%" then
			return strsub(originalString, 1, length - 1)
		else
			return originalString
		end
	end)

	-- Custom Decimal Length Health Tags
	E:AddTag("health:percent-nostatus-0", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
		return GetHealthPercent(unit, "%d%%")
	end)

	E:AddTag("health:percent-nostatus-1", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
		return GetHealthPercent(unit, "%.1f%%")
	end)

	E:AddTag("health:percent-nostatus-2", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
		return GetHealthPercent(unit, "%.2f%%")
	end)

	E:AddTag("health:percent-nostatus-3", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
		return GetHealthPercent(unit, "%.3f%%")
	end)

	E:AddTag("health:percent-nostatus-nosign-0", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
		return GetHealthPercent(unit, "%d")
	end)

	E:AddTag("health:percent-nostatus-nosign-1", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
		return GetHealthPercent(unit, "%.1f")
	end)

	E:AddTag("health:percent-nostatus-nosign-2", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
		return GetHealthPercent(unit, "%.2f")
	end)

	E:AddTag("health:percent-nostatus-nosign-3", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
		return GetHealthPercent(unit, "%.3f")
	end)

	-- 能量百分比 去除百分号
	E:AddTag("power:percent-nosign", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER", function(unit)
		local originalString = E.oUF.Tags.Methods["power:percent"](unit)
		if originalString then
			local length = strlen(originalString)
			if strsub(originalString, length, length) == "%" then
				return strsub(originalString, 1, length - 1)
			else
				return originalString
			end
		end
	end)

	-- Smart power
	E:AddTag("smart-power", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER", function(unit)
		local maxPower = UnitPowerMax(unit)
		local currentPower = UnitPower(unit)

		if not currentPower then
			return ""
		end

		if not maxPower or maxPower < 1000 then
			return currentPower
		else
			return currentPower and format("%d%%", floor(currentPower / maxPower * 100 + 0.5))
		end
	end)

	-- Smart power without %
	E:AddTag("smart-power-nosign", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER", function(unit)
		local maxPower = UnitPowerMax(unit)
		local currentPower = UnitPower(unit)

		if not currentPower then
			return ""
		end

		if not maxPower or maxPower < 1000 then
			return currentPower
		else
			return currentPower and format("%d", floor(currentPower / maxPower * 100 + 0.5))
		end
	end)

	-- Class Icons
	for index, style in pairs(F.GetClassIconStyleList()) do
		E:AddTag("classicon-" .. style, "UNIT_NAME_UPDATE", function(unit)
			local englishClass = select(2, UnitClass(unit))
			return englishClass and F.GetClassIconStringWithStyle(englishClass, style)
		end)
		for i = 1, GetNumClasses() do
			local englishClass = select(2, GetClassInfo(i))
			if englishClass then
				E:AddTag("classicon-" .. style .. ":" .. strlower(englishClass), "UNIT_NAME_UPDATE", function()
					return F.GetClassIconStringWithStyle(englishClass, style)
				end)
			end
		end
	end
end

M:AddCallback("Tags")
