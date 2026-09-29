local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("TalkingHead")
data.toggle = "talkinghead"
data.private = "talkingHead"

local _G = _G

function S:TalkingHead()
	if not E.db.general.talkingHeadFrameBackdrop then
		return
	end

	self:CreateShadow(_G.TalkingHeadFrame)
end

