local W, F, E, L = unpack(select(2, ...))
local M = W.Modules.Misc
local RangeCheck = E.Libs.RangeCheck

local floor = floor
local format = format
local select = select
local strlen = strlen
local strlower = strlower
local strsub = strsub
local tonumber = tonumber

local GetClassColor = GetClassColor
local GetClassInfo = GetClassInfo
local GetNumClasses = GetNumClasses
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsConnected = UnitIsConnected
local UnitIsUnit = UnitIsUnit

local function GetClassColorString(class)
	local hexString = select(4, GetClassColor(class))
	return "|c" .. hexString
end

local function GetHealthPercent(unit, formatString)
	return format(formatString, UnitHealth(unit) / UnitHealthMax(unit) * 100)
end

function M:Tags()
	if not E.private.WT.misc.tags then
		return
	end

	-- 距离预测中值 (5)
	E:AddTag(
		"range:expectation",
		0.1,
		function(unit)
			if UnitIsConnected(unit) and not UnitIsUnit(unit, "player") then
				local minRange, maxRange = RangeCheck:GetRange(unit, true)
				if minRange and maxRange then
					return format("%s", floor((minRange + maxRange) / 2))
				end
				return ""
			end
		end
	)

	-- 职业颜色
	E:AddTag(
		"classcolor:player",
		1e10,
		function()
			return GetClassColorString(E.myclass)
		end
	)

	for i = 1, GetNumClasses() do
		local upperText = select(2, GetClassInfo(i))
		local tag = "classcolor:" .. strlower(upperText)
		E:AddTag(
			tag,
			1e10,
			function()
				return GetClassColorString(upperText)
			end
		)
	end

	-- 血量百分比 去除百分号
	E:AddTag(
		"health:percent-nosign",
		"UNIT_HEALTH UNIT_MAXHEALTH",
		function(unit)
			local originalString = E.oUF.Tags.Methods["health:percent"](unit)
			local length = strlen(originalString)
			if strsub(originalString, length, length) == "%" then
				return strsub(originalString, 1, length - 1)
			else
				return originalString
			end
		end
	)

	-- 无状态血量百分比 去除百分号
	E:AddTag(
		"health:percent-nostatus-nosign",
		"UNIT_HEALTH UNIT_MAXHEALTH",
		function(unit)
			local originalString = E.oUF.Tags.Methods["health:percent-nostatus"](unit)
			local length = strlen(originalString)
			if strsub(originalString, length, length) == "%" then
				return strsub(originalString, 1, length - 1)
			else
				return originalString
			end
		end
	)

	-- Custom Decimal Length Health Tags
	E:AddTag(
		"health:percent-nostatus-0",
		"UNIT_HEALTH UNIT_MAXHEALTH",
		function(unit)
			return GetHealthPercent(unit, "%d%%")
		end
	)

	E:AddTag(
		"health:percent-nostatus-1",
		"UNIT_HEALTH UNIT_MAXHEALTH",
		function(unit)
			return GetHealthPercent(unit, "%.1f%%")
		end
	)

	E:AddTag(
		"health:percent-nostatus-2",
		"UNIT_HEALTH UNIT_MAXHEALTH",
		function(unit)
			return GetHealthPercent(unit, "%.2f%%")
		end
	)

	E:AddTag(
		"health:percent-nostatus-3",
		"UNIT_HEALTH UNIT_MAXHEALTH",
		function(unit)
			return GetHealthPercent(unit, "%.3f%%")
		end
	)

	E:AddTag(
		"health:percent-nostatus-nosign-0",
		"UNIT_HEALTH UNIT_MAXHEALTH",
		function(unit)
			return GetHealthPercent(unit, "%d")
		end
	)

	E:AddTag(
		"health:percent-nostatus-nosign-1",
		"UNIT_HEALTH UNIT_MAXHEALTH",
		function(unit)
			return GetHealthPercent(unit, "%.1f")
		end
	)

	E:AddTag(
		"health:percent-nostatus-nosign-2",
		"UNIT_HEALTH UNIT_MAXHEALTH",
		function(unit)
			return GetHealthPercent(unit, "%.2f")
		end
	)

	E:AddTag(
		"health:percent-nostatus-nosign-3",
		"UNIT_HEALTH UNIT_MAXHEALTH",
		function(unit)
			return GetHealthPercent(unit, "%.3f")
		end
	)

	-- 能量百分比 去除百分号
	E:AddTag(
		"power:percent-nosign",
		"UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER",
		function(unit)
			local originalString = E.oUF.Tags.Methods["power:percent"](unit)
			if originalString then
				local length = strlen(originalString)
				if strsub(originalString, length, length) == "%" then
					return strsub(originalString, 1, length - 1)
				else
					return originalString
				end
			end
		end
	)

	-- Smart power
	E:AddTag(
		"smart-power",
		"UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER",
		function(unit)
			local maxPower = E.oUF.Tags.Methods["maxpp"](unit)
			local power = tonumber(maxPower)
			if power and power < 1000 then
				return E.oUF.Tags.Methods["power:current"](unit)
			else
				return E.oUF.Tags.Methods["power:percent"](unit)
			end
		end
	)

	-- Smart power without %
	E:AddTag(
		"smart-power-nosign",
		"UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER",
		function(unit)
			local maxPower = E.oUF.Tags.Methods["maxpp"](unit)
			local power = tonumber(maxPower)
			if power and power < 1000 then
				return E.oUF.Tags.Methods["power:current"](unit)
			else
				return E.oUF.Tags.Methods["power:percent-nosign"](unit)
			end
		end
	)
end

M:AddCallback("Tags")
