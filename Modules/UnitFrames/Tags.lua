local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local Tags = W:NewModule("Tags") ---@class Tags: AceModule
local RangeCheck = E.Libs.RangeCheck
local C = W.Utilities.Color

local floor = floor
local format = format
local pairs = pairs
local select = select
local strlower = strlower

local GetClassColor = GetClassColor
local GetClassInfo = GetClassInfo
local GetNumClasses = GetNumClasses
local UnitClass = UnitClass
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
local UnitGetTotalHealAbsorbs = UnitGetTotalHealAbsorbs
local UnitHealthPercent = UnitHealthPercent
local UnitIsConnected = UnitIsConnected
local UnitIsUnit = UnitIsUnit
local UnitPower = UnitPower
local UnitPowerPercent = UnitPowerPercent
local UnitPowerType = UnitPowerType

local C_StringUtil_TruncateWhenZero = C_StringUtil.TruncateWhenZero
local CurveConstants_ScaleTo100 = CurveConstants.ScaleTo100
local Enum_PowerType_Mana = Enum.PowerType.Mana

local function GetClassColorString(class)
	local hexString = select(4, GetClassColor(class))
	return "|c" .. hexString
end

function Tags:AddTagInfo()
	local info = {
		perhp1f = {
			category = F.GetWindStyleText(L["Health"]),
			description = format(
				L["The percentage of health without percent sign and status"] .. " (%s = 1)",
				L["Decimal Length"]
			),
			order = 1,
		},
		perhp2f = {
			category = F.GetWindStyleText(L["Health"]),
			description = format(
				L["The percentage of health without percent sign and status"] .. " (%s = 2)",
				L["Decimal Length"]
			),
			order = 2,
		},
		perhp3f = {
			category = F.GetWindStyleText(L["Health"]),
			description = format(
				L["The percentage of health without percent sign and status"] .. " (%s = 3)",
				L["Decimal Length"]
			),
			order = 3,
		},
		["absorbs-autohide"] = {
			category = F.GetWindStyleText(L["Health"]),
			description = format(
				L["Just like %s, but it will be hidden when the amount is zero."],
				F.GetWindStyleText("[absorbs]")
			),
			order = 4,
		},
		["healabsorbs-autohide"] = {
			category = F.GetWindStyleText(L["Health"]),
			description = format(
				L["Just like %s, but it will be hidden when the amount is zero."],
				F.GetWindStyleText("[healabsorbs]")
			),
			order = 5,
		},
		["smart-power"] = {
			category = F.GetWindStyleText(L["Power"]),
			description = L["Automatically select the best format of power (e.g. Rogue is 120, Mage is 100%)"],
			order = 1,
		},
		["smart-power-nosign"] = {
			category = F.GetWindStyleText(L["Power"]),
			description = L["Automatically select the best format of power (e.g. Rogue is 120, Mage is 100)"],
			order = 2,
		},
		range = {
			category = F.GetWindStyleText(L["Range"]),
			description = L["Range"],
			order = 1,
		},
		["range:expectation"] = {
			category = F.GetWindStyleText(L["Range"]),
			description = L["Range Expectation"],
			order = 2,
		},
		["classcolor:player"] = {
			category = F.GetWindStyleText(L["Color"]),
			description = L["The color of the player's class"],
			order = 0,
		},
	}

	---@type table<ClassFile, string>
	local classNames = {
		WARRIOR = L["Warrior"],
		PALADIN = L["Paladin"],
		HUNTER = L["Hunter"],
		ROGUE = L["Rogue"],
		PRIEST = L["Priest"],
		DEATHKNIGHT = L["Deathknight"],
		SHAMAN = L["Shaman"],
		MAGE = L["Mage"],
		WARLOCK = L["Warlock"],
		MONK = L["Monk"],
		DRUID = L["Druid"],
		DEMONHUNTER = L["Demonhunter"],
		EVOKER = L["Evoker"],
	}

	for i = 1, GetNumClasses() do
		local classFile = select(2, GetClassInfo(i))
		info["classcolor:" .. strlower(classFile)] = {
			category = F.GetWindStyleText(L["Color"]),
			description = format(L["The color of %s"], C.StringWithClassColor(classNames[classFile], classFile)),
			order = i,
		}
	end

	for _, style in pairs(F.GetClassIconStyleList()) do
		info["classicon-" .. style] = {
			category = F.GetWindStyleText(L["Class Icon"]) .. " - " .. style,
			description = L["The class icon of the player's class"],
		}

		for i = 1, GetNumClasses() do
			local classFile = select(2, GetClassInfo(i))
			info["classicon-" .. style .. ":" .. strlower(classFile)] = {
				category = F.GetWindStyleText(L["Class Icon"]) .. " - " .. style,
				description = format(
					L["The class icon of %s"],
					C.StringWithClassColor(classNames[classFile], classFile)
				),
			}
		end
	end

	for tagName, tagInfo in pairs(info) do
		E:AddTagInfo(tagName, tagInfo.category, tagInfo.description, tagInfo.order, tagInfo.hidden)
	end
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
		return C_StringUtil_TruncateWhenZero(UnitGetTotalHealAbsorbs(unit))
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

	self:AddTagInfo()
end

W:RegisterModule(Tags:GetName())
