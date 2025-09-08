local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local LSM = E.Libs.LSM
local S = W.Modules.Skins ---@type Skins
local WS = S.Widgets
local ES = E.Skins

function WS:HandleSliderFrame(_, slider)
	if not self:IsReady() then
		self:RegisterLazyLoad(slider, function()
			self:HandleSliderFrame(nil, slider)
		end)
		return
	end

	local db = E.private.WT and E.private.WT.skins and E.private.WT.skins.widgets and E.private.WT.skins.widgets.slider

	if not slider or not db or not db.enable then
		return
	end

	if not slider.windWidgetSkinned and not slider.__StripTextures and not slider.__SetThumbTexture then
		slider:SetThumbTexture(LSM:Fetch("statusbar", db.texture) or E.media.normTex)
		F.InternalizeMethod(slider, "StripTextures", true)
		F.InternalizeMethod(slider, "SetThumbTexture", true)
		slider.windWidgetSkinned = true
	end

	F.SetVertexColorWithDB(slider:GetThumbTexture(), db.classColor and E.myClassColor or db.color)
end

WS:SecureHook(ES, "HandleSliderFrame")
