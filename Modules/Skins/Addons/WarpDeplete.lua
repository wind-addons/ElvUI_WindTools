local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("WarpDeplete")
data.check = function()
	return E.private.WT.skins.enable and E.private.WT.skins.addons.warpDeplete
end

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

