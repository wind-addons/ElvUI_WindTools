local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

local pairs = pairs

function S:ReskinWarpDepleteBars()
	for _, barFrame in pairs(_G.WarpDeplete.bars) do
		local bar = barFrame.bar
		if not bar.__windSkin then
			bar:SetTemplate("Transparent")
			self:CreateLowerShadow(bar)
			bar.__windSkin = true
		end
	end

	_G.WarpDeplete.forces.bar:SetTemplate("Transparent")
	self:CreateShadow(_G.WarpDeplete.forces.bar)
end

function S:WarpDeplete()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.warpDeplete then
		return
	end

	if not _G.WarpDeplete then
		return
	end

	if _G.WarpDeplete.bars then
		self:ReskinWarpDepleteBars()
	else
		self:SecureHook(
			_G.WarpDeplete,
			_G.WarpDeplete.InitDisplay and "InitDisplay" or "InitRender",
			"ReskinWarpDepleteBars"
		)
	end
end

S:AddCallbackForAddon("WarpDeplete")
