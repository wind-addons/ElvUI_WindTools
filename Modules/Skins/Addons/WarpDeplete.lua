local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

local pairs = pairs

local data = S:AddCallbackForAddon("WarpDeplete", nil, S:CreateAddonCheck("warpDeplete"))

function data:ReskinBars() -- self is WarpDeplete when hooked, not data
	for _, barFrame in pairs(_G.WarpDeplete.bars) do
		local bar = barFrame.bar
		if not bar.__windSkin then
			bar:SetTemplate("Transparent")
			S:CreateLowerShadow(bar)
			bar.__windSkin = true
		end
	end

	_G.WarpDeplete.forces.bar:SetTemplate("Transparent")
	S:CreateShadow(_G.WarpDeplete.forces.bar)
end

function S:WarpDeplete()
	if not _G.WarpDeplete then
		return
	end

	if _G.WarpDeplete.bars then
		data:ReskinBars()
	else
		self:SecureHook(_G.WarpDeplete, _G.WarpDeplete.InitDisplay and "InitDisplay" or "InitRender", data.ReskinBars)
	end
end
