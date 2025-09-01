local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local LSM = E.Libs.LSM
local S = W.Modules.Skins ---@type Skins
local WS = S.Widgets
local ES = E.Skins

local _G = _G
local unpack = unpack

function WS:HandleButton(_, button)
	if not button or button.windWidgetSkinned then
		return
	end

	if not self:IsReady() then
		self:RegisterLazyLoad(button, function()
			self:HandleButton(nil, button)
		end)
		return
	end

	if not E.private.WT.skins.enable or not E.private.WT.skins.widgets.button.enable then
		return
	end

	local db = E.private.WT and E.private.WT.skins and E.private.WT.skins.widgets and E.private.WT.skins.widgets.button

	if db.text.enable then
		local text = button.Text or button.GetName and button:GetName() and _G[button:GetName() .. "Text"]
		if text and text.GetTextColor then
			F.SetFontWithDB(text, db.text.font)
		end
	end

	if db.backdrop.enable and (button.template or button.backdrop) then
		local parentFrame = button.backdrop or button

		-- Create background
		local bg = parentFrame:CreateTexture()
		bg:SetInside(parentFrame, 1, 1)
		bg:SetAlpha(0)
		bg:SetTexture(LSM:Fetch("statusbar", db.backdrop.texture) or E.media.normTex)

		if parentFrame.Center then
			local layer, subLayer = parentFrame.Center:GetDrawLayer()
			subLayer = subLayer and subLayer + 1 or 0
			bg:SetDrawLayer(layer, subLayer)
		end

		F.SetVertexColorWithDB(bg, db.backdrop.classColor and E.myClassColor or db.backdrop.color)

		button.windAnimation = self.Animation(bg, db.backdrop.animation)
		self.SetAnimationMetadata(button, button.windAnimation)
		self:SecureHookScript(button, "OnEnter", button.windAnimation.OnEnter)
		self:SecureHookScript(button, "OnLeave", button.windAnimation.OnLeave)

		if button.Disable then
			self:SecureHook(button, "Disable", button.windAnimation.OnStatusChange)
		end

		if button.Enable then
			self:SecureHook(button, "Enable", button.windAnimation.OnStatusChange)
		end

		-- Avoid the hook is flushed
		self:SecureHook(button, "SetScript", function(frame, scriptType)
			if scriptType == "OnEnter" then
				self:Unhook(frame, "OnEnter")
				self:SecureHookScript(frame, "OnEnter", button.windAnimation.OnEnter)
			elseif scriptType == "OnLeave" then
				self:Unhook(frame, "OnLeave")
				self:SecureHookScript(frame, "OnLeave", button.windAnimation.OnLeave)
			end
		end)

		if db.backdrop.removeBorderEffect then
			parentFrame.SetBackdropBorderColor = E.noop
		end
	end

	button.windWidgetSkinned = true
end

function WS:ElvUI_Config_SetButtonColor(_, btn)
	if not E.private.WT or not E.private.WT.skins.enable then
		return
	end

	if not E.private.WT.skins.widgets.button.enable or not E.private.WT.skins.widgets.button.selected.enable then
		return
	end

	if not btn.SetBackdropColor then
		return
	end

	local db = E.private.WT.skins.widgets.button

	if btn:IsEnabled() then
		local r1, g1, b1 = unpack(E.media.backdropcolor)
		btn:SetBackdropColor(r1, g1, b1, 1)

		local r2, g2, b2 = unpack(E.media.bordercolor)
		btn:SetBackdropBorderColor(r2, g2, b2, 1)
	else
		local borderColor = db.selected.borderClassColor and E.myClassColor or db.selected.borderColor
		local backdropColor = db.selected.backdropClassColor and E.myClassColor or db.selected.backdropColor
		btn:SetBackdropBorderColor(borderColor.r, borderColor.g, borderColor.b, db.selected.borderAlpha)
		btn:SetBackdropColor(backdropColor.r, backdropColor.g, backdropColor.b, db.selected.backdropAlpha)
	end
end

WS:SecureHook(ES, "HandleButton")
WS:SecureHook(E, "Config_SetButtonColor", "ElvUI_Config_SetButtonColor")
