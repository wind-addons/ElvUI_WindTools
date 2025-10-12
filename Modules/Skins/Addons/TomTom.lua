local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:TomTom()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.tomTom then
		return
	end

	if not _G.TomTom then
		return
	end

	if _G.TomTomBlock then
		self:Proxy("HandleFrame", _G.TomTomBlock)
		self:CreateShadow(_G.TomTomBlock)
		self:BindShadowColorWithBorder(_G.TomTomBlock)

		if _G.TomTomBlock.Text then
			F.SetFont(_G.TomTomBlock.Text, E.db.general.font)
		end
	end

	self:DisableAddOnSkin("TomTom")
end

S:AddCallbackForAddon("TomTom")
