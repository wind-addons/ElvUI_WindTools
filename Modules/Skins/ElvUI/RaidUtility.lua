local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

S:AddCallback("RaidUtility", function()
	return E.private.WT.skins.elvui.enable
			and E.private.WT.skins.elvui.raidUtility
			and E.private.general.raidUtility
			and true
		or false
end)

function S:RaidUtility()
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
