local W, F, E, L = unpack((select(2, ...)))
local M = W.Modules.Misc

function M:Math()
	if E.private.WT.misc.noKanjiMath then
		E.ShortPrefixStyles.CHINESE = { { 1e8, "Y" }, { 1e4, "W" } }
		E.ShortPrefixStyles.TCHINESE = { { 1e8, "Y" }, { 1e4, "W" } }

		E:BuildPrefixValues()
	end
end

M:AddCallback("Math")
