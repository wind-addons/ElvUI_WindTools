local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

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

	-- /ttpaste or /tomtompaste
	if _G.TomTomPaste then
		self:Proxy("HandleFrame", _G.TomTomPaste)
		self:CreateShadow(_G.TomTomPaste)
		self:BindShadowColorWithBorder(_G.TomTomPaste)

		for _, child in pairs({ _G.TomTomPaste:GetChildren() }) do
			local objectType = child.GetObjectType and child:GetObjectType()
			if objectType == "Button" then
				self:Proxy("HandleButton", child)
			end
		end
	end

	self:DisableAddOnSkin("TomTom")
end

S:AddCallbackForAddon("TomTom")
