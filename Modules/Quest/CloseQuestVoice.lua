-- 作者：houshuu
local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local WT = E:GetModule("WindTools")
local CQV = E:NewModule('Wind_CloseQuestVoice', 'AceHook-3.0');


local function CloseVoice()
	hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
		TalkingHeadFrame_CloseImmediately()
	end)
end

function CQV:Initialize()

	if not E.db.WindTools["Quest"]["Close Quest Voice"]["enabled"] then return end

	if TalkingHeadFrame then
    	CloseVoice()
	else
	    hooksecurefunc('TalkingHead_LoadUI', CloseVoice)
	end
	
end

local function InitializeCallback()
	CQV:Initialize()
end
E:RegisterModule(CQV:GetName(), InitializeCallback)