-- 一部分代码灵感来自 BeQuiet
-- 哪天有时间再继续强化一下
-- 作者：houshuu
local E, L, V, P, G = unpack(ElvUI)

P["WindTools"]["BeQuiet"] = {
	["enabled"] = false,
}

function HideTalkingHead(event, addon)
	if not E.db.WindTools["BeQuiet"]["enabled"] then return end

	hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
	TalkingHeadFrame:Hide()
	end)
end
