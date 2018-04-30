-- 作者：houshuu
local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local CQV = E:NewModule('CloseQuestVoice', 'AceHook-3.0');

P["WindTools"]["Close Quest Voice"] = {
	["enabled"] = false,
}

local function CloseVoice(event, addon)
	--Check if the talkinghead addon is being loaded
	if addon == "Blizzard_TalkingHeadUI" then
		hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
				TalkingHeadFrame_CloseImmediately()
		end)
		self:UnregisterEvent(event)
	end
end

function CQV:Initialize()
	if not E.db.WindTools["Close Quest Voice"]["enabled"] then return end

	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", CloseVoice)
end

E:RegisterModule(CQV:GetName())