-- 作者：houshuu
local E, L, V, P, G = unpack(ElvUI)

P["WindTools"]["Close Quest Voice"] = {
	["enabled"] = false,
}

hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
	if E.db.WindTools["Close Quest Voice"]["enabled"] then
		local name = GetInstanceInfo()
		TalkingHeadFrame_CloseImmediately()
	end
end)
