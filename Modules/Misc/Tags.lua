local W, F, E, L = unpack(select(2, ...))
local M = W:GetModule("Misc")
local RC = E.Libs.RC

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

local function GetClassColorString(class)
	local hexString = select(4, GetClassColor(class))
	return "|c" .. hexString
end

function M:Tags()
	if not E.private.WT.misc.tags then
		return
	end

	-- 距离 (4 - 6)
	E:AddTag(
		"range",
		0.1,
		function(unit)
			if not unit then
				return
			end

			local min, max = RC:GetRange(unit)
			if min and max then
				return format("%s - %s", RC:GetRange(unit))
			end

			return ""
		end
	)

	-- 距离预测中值 (5)
	E:AddTag(
		"range:expectation",
		0.1,
		function(unit)
			if not unit then
				return
			end

			local min, max = RC:GetRange(unit)
			if min and max then
				return format("%s", floor((min + max) / 2))
			end

			return ""
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
