local W, F, E, L = unpack(select(2, ...))
local M = W:GetModule("Misc")
local RC = E.Libs.RC

local function GetClassColorString(class)
	local hexString = select(4, GetClassColor(class))
	return "|c" .. hexString
end

function M:Tags()
	if not E.private.WT.misc.tags then
		return
	end

	-- 距离 (4 - 6)
	E.oUF.Tags.Methods["range"] = function(unit)
		if not unit then
			return
		end
		return format("%s - %s", RC:GetRange(unit))
	end

	-- 距离预测中值 (5)
	E.oUF.Tags.Methods["range:expectation"] = function(unit)
		if not unit then
			return
		end
		local min, max = RC:GetRange(unit)
		return format("%s", floor((min + max) / 2))
	end

	-- 职业颜色
	E.oUF.Tags.Methods["classcolor:player"] = function()
		return GetClassColorString(E.myclass)
	end

	E.oUF.Tags.Methods["classcolor:hunter"] = function()
		return GetClassColorString("HUNTER")
	end

	E.oUF.Tags.Methods["classcolor:warrior"] = function()
		return GetClassColorString("WARRIOR")
	end

	E.oUF.Tags.Methods["classcolor:paladin"] = function()
		return GetClassColorString("PALADIN")
	end

	E.oUF.Tags.Methods["classcolor:mage"] = function()
		return GetClassColorString("MAGE")
	end

	E.oUF.Tags.Methods["classcolor:priest"] = function()
		return GetClassColorString("PRIEST")
	end

	E.oUF.Tags.Methods["classcolor:warlock"] = function()
		return GetClassColorString("WARLOCK")
	end

	E.oUF.Tags.Methods["classcolor:shaman"] = function()
		return GetClassColorString("SHAMAN")
	end

	E.oUF.Tags.Methods["classcolor:deathknight"] = function()
		return GetClassColorString("DEATHKNIGHT")
	end

	E.oUF.Tags.Methods["classcolor:demonhunter"] = function()
		return GetClassColorString("DEMONHUNTER")
	end

	E.oUF.Tags.Methods["classcolor:druid"] = function()
		return GetClassColorString("DRUID")
	end

	E.oUF.Tags.Methods["classcolor:monk"] = function()
		return GetClassColorString("MONK")
	end

	E.oUF.Tags.Methods["classcolor:rogue"] = function()
		return GetClassColorString("ROGUE")
	end

	-- 血量百分比 去除百分号
	E.oUF.Tags.Events["health:percent-nosymbol"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
	E.oUF.Tags.Methods["health:percent-nosymbol"] = function(unit)
		local originalString = E.oUF.Tags.Methods["health:percent"](unit)
		local length = strlen(originalString)
		if strsub(originalString, length, length) == "%" then
			return strsub(originalString, 1, length - 1)
		else
			return originalString
		end
	end

	-- 无状态血量百分比 去除百分号
	E.oUF.Tags.Events["health:percent-nostatus-nosymbol"] = "UNIT_HEALTH UNIT_MAXHEALTH"
	E.oUF.Tags.Methods["health:percent-nostatus-nosymbol"] = function(unit)
		local originalString = E.oUF.Tags.Methods["health:percent-nostatus"](unit)
		local length = strlen(originalString)
		if strsub(originalString, length, length) == "%" then
			return strsub(originalString, 1, length - 1)
		else
			return originalString
		end
	end

	-- 能量百分比 去除百分号
	E.oUF.Tags.Events["power:percent-nosymbol"] = "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER"
	E.oUF.Tags.Methods["power:percent-nosymbol"] = function(unit)
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
end

M:AddCallback("Tags")
