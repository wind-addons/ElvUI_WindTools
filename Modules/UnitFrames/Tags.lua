local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local Tags = W:NewModule("Tags") ---@class Tags: AceModule
local RangeCheck = E.Libs.RangeCheck

local floor = floor
local format = format
local pairs = pairs
local select = select
local strlower = strlower

local GetClassColor = GetClassColor
local GetClassInfo = GetClassInfo
local GetNumClasses = GetNumClasses
local UnitClass = UnitClass
local UnitHealthPercent = UnitHealthPercent
local UnitIsConnected = UnitIsConnected
local UnitIsUnit = UnitIsUnit
local UnitPower = UnitPower
local UnitPowerPercent = UnitPowerPercent
local UnitPowerType = UnitPowerType
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs

local C_StringUtil_TruncateWhenZero = C_StringUtil.TruncateWhenZero
local CurveConstants_ScaleTo100 = CurveConstants.ScaleTo100
local Enum_PowerType_Mana = Enum.PowerType.Mana

local function GetClassColorString(class)
	local hexString = select(4, GetClassColor(class))
	return "|c" .. hexString
end

function Tags:Initialize()
	if not E.private.WT.unitFrames.tags.enable then
		return
	end

	-- Health Percentage
	E:AddTag("perhp1f", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
		return format("%.1f", UnitHealthPercent(unit, true, CurveConstants_ScaleTo100) --[[@as number]])
	end)

	E:AddTag("perhp2f", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
		return format("%.2f", UnitHealthPercent(unit, true, CurveConstants_ScaleTo100) --[[@as number]])
	end)

	E:AddTag("perhp3f", "UNIT_HEALTH UNIT_MAXHEALTH", function(unit)
		return format("%.3f", UnitHealthPercent(unit, true, CurveConstants_ScaleTo100) --[[@as number]])
	end)

	-- Absorbs autohide
	E:AddTag("absorbs-autohide", "UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
		return C_StringUtil_TruncateWhenZero(UnitGetTotalAbsorbs(unit))
	end)

	E:AddTag("healabsorbs-autohide", "UNIT_ABSORB_AMOUNT_CHANGED", function(unit)
		return C_StringUtil_TruncateWhenZero(UnitGetTotalAbsorbs(unit))
	end)

	-- Range
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

	-- Smart power
	E:AddTag("smart-power", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER", function(unit)
		if UnitPowerType(unit) == Enum_PowerType_Mana then
			return format("%d%%", UnitPowerPercent(unit, nil, true, CurveConstants_ScaleTo100) --[[@as number]])
		end

		return UnitPower(unit)
	end)

	E:AddTag("smart-power-nosign", "UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER", function(unit)
		if UnitPowerType(unit) == Enum_PowerType_Mana then
			return format("%d", UnitPowerPercent(unit, nil, true, CurveConstants_ScaleTo100) --[[@as number]])
		end

		return UnitPower(unit)
	end)

	-- Class Color Color Prefixes
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

	-- Class Icons
	for _, style in pairs(F.GetClassIconStyleList()) do
		E:AddTag("classicon-" .. style, "UNIT_NAME_UPDATE", function(unit)
			local englishClass = select(2, UnitClass(unit))
			return englishClass and F.GetClassIconStringWithStyle(englishClass, style) or ""
		end)

		for i = 1, GetNumClasses() do
			local englishClass = select(2, GetClassInfo(i))
			if englishClass then
				E:AddTag("classicon-" .. style .. ":" .. strlower(englishClass), "UNIT_NAME_UPDATE", function()
					return F.GetClassIconStringWithStyle(englishClass, style) or ""
				end)
			end
		end
	end
end

W:RegisterModule(Tags:GetName())
