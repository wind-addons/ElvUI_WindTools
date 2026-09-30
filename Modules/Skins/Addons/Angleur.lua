local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local unpack = unpack

local function skinAngleurButton()
	local buttonFrame = _G.Angleur_Visual ---@type Button
	if not buttonFrame then
		return
	end
	buttonFrame:StripTextures()
	buttonFrame:SetTemplate("Transparent")
	S:Proxy("HandleButton", buttonFrame)
	S:CreateShadow(buttonFrame)

	local closeButtonFrame = _G.Angleur_Visual_CloseButton ---@type Button
	if closeButtonFrame then
		S:Proxy("HandleCloseButton", closeButtonFrame)
	end

	local overlayTex = buttonFrame.texture ---@type Texture?
	if overlayTex then
		local function applyVisualOverlayTexCoord()
			overlayTex:SetTexCoord(unpack(E.TexCoords))
		end
		applyVisualOverlayTexCoord()
		if not overlayTex.__windToolsAngleurTexCoordHook then
			hooksecurefunc(overlayTex, "SetTexture", applyVisualOverlayTexCoord)
			overlayTex.__windToolsAngleurTexCoordHook = true
		end
	end
end

function S:Angleur()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.angleur then
		return
	end

	skinAngleurButton()
end

S:AddCallbackForAddon("Angleur")
