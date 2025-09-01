local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local LSM = E.Libs.LSM
local S = W.Modules.Skins ---@type Skins
local WS = S.Widgets
local ES = E.Skins

local _G = _G
local unpack = unpack

local RaiseFrameLevel = RaiseFrameLevel
local LowerFrameLevel = LowerFrameLevel

function WS:HandleTab(_, tab, noBackdrop, template)
	if noBackdrop then
		return
	end

	if not tab or tab.windWidgetSkinned then
		return
	end

	if not self:IsReady() then
		self:RegisterLazyLoad(tab, function()
			self:HandleTab(nil, tab)
		end)
		return
	end

	if not E.private.WT.skins.enable or not E.private.WT.skins.widgets.tab.enable then
		return
	end

	local db = E.private.WT and E.private.WT.skins and E.private.WT.skins.widgets and E.private.WT.skins.widgets.tab

	if db.text.enable then
		local text = tab.text or tab.Text or tab.GetName and tab:GetName() and _G[tab:GetName() .. "Text"]
		if text and text.GetTextColor then
			F.SetFontWithDB(text, db.text.font)
			tab.windWidgetText = text
		end
	end

	if db.backdrop.enable and (tab.template or tab.backdrop) then
		local parentFrame = tab.backdrop or tab

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

		tab.windAnimation = self.Animation(bg, db.backdrop.animation)
		tab.__windAnimationIsTab = true
		self.SetAnimationMetadata(tab, tab.windAnimation)
		self:SecureHookScript(tab, "OnEnter", tab.windAnimation.OnEnter)
		self:SecureHookScript(tab, "OnLeave", tab.windAnimation.OnLeave)

		if tab.Disable and tab.Enable then
			self:SecureHook(tab, "Disable", tab.windAnimation.OnStatusChange)
			self:SecureHook(tab, "Enable", tab.windAnimation.OnStatusChange)
		end

		-- Avoid the hook is flushed
		if tab.SetScript then
			self:SecureHook(tab, "SetScript", function(frame, scriptType)
				if scriptType == "OnEnter" then
					self:Unhook(frame, "OnEnter")
					self:SecureHookScript(frame, "OnEnter", tab.windAnimation.OnEnter)
				elseif scriptType == "OnLeave" then
					self:Unhook(frame, "OnLeave")
					self:SecureHookScript(frame, "OnLeave", tab.windAnimation.OnLeave)
				end
			end)
		end
	end

	tab.windWidgetSkinned = true
end

do
	ES.Ace3_TabSetSelected_ = ES.Ace3_TabSetSelected
	function ES.Ace3_TabSetSelected(tab, selected)
		if not tab or not tab.backdrop then
			return ES.Ace3_TabSetSelected_(tab, selected)
		end

		if tab.windAnimation then
			tab.__windAnimationIsSelected = selected
			tab.windAnimation.OnStatusChange(tab)
		end

		if not E.private.WT.skins.enable or not E.private.WT.skins.widgets.tab.enable then
			return ES.Ace3_TabSetSelected_(tab, selected)
		end

		local db = E.private.WT.skins.widgets.tab

		if db.text.enable and tab.windWidgetText then
			local color
			if selected then
				color = db.text.selectedClassColor and E.myClassColor or db.text.selectedColor
			else
				color = db.text.normalClassColor and E.myClassColor or db.text.normalColor
			end
			tab.windWidgetText:SetTextColor(color.r, color.g, color.b)
		end

		if not db.selected.enable then
			return ES.Ace3_TabSetSelected_(tab, selected)
		end

		local borderColor = db.selected.borderClassColor and E.myClassColor or db.selected.borderColor
		local backdropColor = db.selected.backdropClassColor and E.myClassColor or db.selected.backdropColor
		if selected then
			tab.backdrop.Center:SetTexture(LSM:Fetch("statusbar", db.selected.texture) or E.media.glossTex)
			tab.backdrop:SetBackdropBorderColor(borderColor.r, borderColor.g, borderColor.b, db.selected.borderAlpha)
			tab.backdrop:SetBackdropColor(backdropColor.r, backdropColor.g, backdropColor.b, db.selected.backdropAlpha)

			if not tab.wasRaised then
				RaiseFrameLevel(tab)
				tab.wasRaised = true
			end
		else
			tab.backdrop.Center:SetTexture(E.media.glossTex)
			local r, g, b = unpack(E.media.bordercolor)
			tab.backdrop:SetBackdropBorderColor(r, g, b, 1)
			r, g, b = unpack(E.media.backdropcolor)
			tab.backdrop:SetBackdropColor(r, g, b, 1)

			if tab.wasRaised then
				LowerFrameLevel(tab)
				tab.wasRaised = nil
			end
		end
	end
end

WS:SecureHook(ES, "HandleTab")
WS:SecureHook(ES, "Ace3_SkinTab", "HandleTab")
