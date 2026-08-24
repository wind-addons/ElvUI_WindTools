local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local ET = E:GetModule("Tooltip")
local T = W.Modules.Tooltips

local _G = _G
local format = format
local ipairs = ipairs
local strfind = strfind

local GetCreatureDifficultyColor = GetCreatureDifficultyColor
local GetGuildInfo = GetGuildInfo
local UnitEffectiveLevel = UnitEffectiveLevel
local UnitClass = UnitClass
local UnitLevel = UnitLevel
local UnitRace = UnitRace
local UnitSex = UnitSex

local RAID_CLASS_COLORS_PRIEST = RAID_CLASS_COLORS.PRIEST

local genderTable = { _G.UNKNOWN .. " ", _G.MALE .. " ", _G.FEMALE .. " " }

function T:SetUnitText(_, tt, unit, isPlayerUnit)
	if not tt or (tt.IsForbidden and tt:IsForbidden()) or not isPlayerUnit then
		return
	end

	local etdb = self.profiledb and self.profiledb.elvUITweaks
	if not etdb or not etdb.specIcon.enable and not etdb.raceIcon.enable then -- No need to do anything
		return
	end

	local guildName = GetGuildInfo(unit)
	if E:IsSecretValue(guildName) then
		guildName = nil
	end
	local levelLine, specLine = ET:GetLevelLine(tt, (guildName and 2) or 1)
	local level, realLevel = UnitEffectiveLevel(unit), UnitLevel(unit)

	if levelLine then
		local diffColor = GetCreatureDifficultyColor(level)
		local race, englishRace = UnitRace(unit)
		if E:IsSecretValue(race) or E:IsSecretValue(englishRace) then
			race = nil
			englishRace = nil
		end
		local gender = UnitSex(unit)
		if E:IsSecretValue(gender) then
			gender = nil
		end
		local _, localizedFaction = E:GetUnitBattlefieldFaction(unit)
		if localizedFaction and (englishRace == "Pandaren" or englishRace == "Dracthyr") then
			race = localizedFaction .. " " .. race
		end
		local hexColor = E:RGBToHex(diffColor.r, diffColor.g, diffColor.b)
		local unitGender = ET.db.gender and gender and genderTable[gender]

		if etdb.raceIcon.enable and englishRace then
			local raceIcon = F.GetRaceAtlasString(englishRace, gender or 1, etdb.raceIcon.height, etdb.raceIcon.width)
			if raceIcon then
				race = raceIcon .. " " .. (race or "")
			end
		end

		local levelText
		if level < realLevel then
			levelText = format(
				"%s%s|r |cffFFFFFF(%s)|r %s%s",
				hexColor,
				level > 0 and level or "??",
				realLevel,
				unitGender or "",
				race or ""
			)
		else
			levelText = format("%s%s|r %s%s", hexColor, level > 0 and level or "??", unitGender or "", race or "")
		end

		local specText = specLine and specLine:GetText()
		if E:NotSecretValue(specText) and specText then
			local localeClass, class, classID = UnitClass(unit)
			if
				E:NotSecretValue(localeClass)
				and E:NotSecretValue(class)
				and E:NotSecretValue(classID)
				and localeClass
				and class
			then
				local nameColor = E:ClassColor(class) or RAID_CLASS_COLORS_PRIEST

				local specIcon

				-- Because inspect need some extra time, we can extract the sepcialization info just from the text
				if etdb.specIcon.enable and classID and W.SpecializationInfo[classID] then
					for _, spec in ipairs(W.SpecializationInfo[classID]) do
						if strfind(specText, spec.name) then
							specIcon = spec.icon
							break
						end
					end
				end

				if specIcon then
					local iconString = F.GetIconString(specIcon, etdb.specIcon.height, etdb.specIcon.width, true)
					specText = iconString .. " " .. specText
				end

				specLine:SetFormattedText("|c%s%s|r", nameColor.colorStr, specText)
			end
		end

		levelLine:SetFormattedText(levelText)
	end
end
