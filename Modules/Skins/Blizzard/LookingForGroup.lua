local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local pairs = pairs

function S:LookingForGroupFrames()
	if not self:CheckDB("lfg", "lookingForGroup") then
		return
	end

	local frames = {
		_G.PVEFrame,
		_G.LFGDungeonReadyDialog,
		_G.LFGDungeonReadyStatus,
		_G.LFDRoleCheckPopup,
		_G.ReadyCheckFrame,
		_G.QueueStatusFrame,
		_G.LFDReadyCheckPopup,
		_G.LFGListInviteDialog,
		_G.LFGListApplicationDialog,
	}

	for _, frame in pairs(frames) do
		self:CreateShadow(frame)
	end

	for i = 1, 4 do
		self:ReskinTab(_G["PVEFrameTab" .. i])
	end

	if _G.LFDQueueFrameRandomScrollFrameChildFrame then
		local frame = _G.LFDQueueFrameRandomScrollFrameChildFrame
		F.SetFontOutline(frame.title, E.db.general.font)
		F.SetFontOutline(frame.description, E.db.general.font)
		F.SetFontOutline(frame.rewardsLabel, E.db.general.font)
		F.SetFontOutline(frame.rewardsDescription, E.db.general.font)
	end

	-- if no party found, the button also need skin
	S:Proxy("HandleButton", _G.LFGListFrame.SearchPanel.ScrollBox.StartGroupButton)

	_G.LFGListFrame.SearchPanel.FilterButton:SetWidth(93)
	_G.LFGListFrame.SearchPanel.FilterButton.SetWidth = E.noop
end

S:AddCallback("LookingForGroupFrames")
