local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

function S:RaidUtility()
	if not E.private.WT.skins.elvui.enable or not E.private.WT.skins.elvui.raidUtility then
		return
	end

	if not E.private.general.raidUtility then
		return
	end

	local frames = {
		_G.RaidUtilityPanel,
		_G.RaidUtility_ShowButton,
		_G.RaidUtility_CloseButton,
		_G.RaidUtilityRoleIcons,
		_G.RaidUtilityTargetIcons,
	}

	for _, frame in pairs(frames) do
		self:CreateShadow(frame)
	end
end

S:AddCallback("RaidUtility")
