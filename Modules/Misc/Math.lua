local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local M = W.Modules.Misc ---@class Misc

function M:Math()
	if E.private.WT.misc.noKanjiMath then
		hooksecurefunc(E, "BuildAbbreviateConfigs", function()
			if not (E.db.general.numberPrefixStyle == "CHINESE" or E.db.general.numberPrefixStyle == "TCHINESE") then
				return
			end

			local asianUnits = {
				CHINESE = { { 1e12, "Z" }, { 1e8, "Y" }, { 1e4, "W" } },
				TCHINESE = { { 1e12, "Z" }, { 1e8, "Y" }, { 1e4, "W" } },
				KOREAN = E.ShortPrefixStyles.KOREAN,
			}

			local asianDivisors = { 1e11, 1e7, 1e3 }

			local short = { breakpoints = {} }
			local long = { long = true }

			E.Abbreviate.short = short
			E.Abbreviate.long = long

			local style = E.db.general.numberPrefixStyle
			local asian = asianUnits[style]
			local units = asian

			long.isAsian = asian
			short.isAsian = asian

			local decimal = E.db.general.decimalLength or 1
			if decimal > 3 then
				decimal = 3
			end

			for i = 1, 3 do
				local unit = units[i]

				short.breakpoints[i] = {
					breakpoint = unit[1],
					abbreviation = unit[2],
					significandDivisor = asianDivisors[i],
					fractionDivisor = 10,
					abbreviationIsGlobal = false,
				}
			end

			if CreateAbbreviateConfig then
				short.config = CreateAbbreviateConfig(short.breakpoints)

				wipe(short.breakpoints)
			end
		end)

		E:BuildAbbreviateConfigs()
	end
end

M:AddCallback("Math")
