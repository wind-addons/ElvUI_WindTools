local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local LSM = E.Libs.LSM
local S = W.Modules.Skins ---@type Skins
local WS = S.Widgets

local _G = _G
local abs = abs
local type = type

function WS:HandleTreeGroup(widget)
	if not E.private.WT.skins.enable or not E.private.WT.skins.widgets.treeGroupButton.enable then
		return
	end

	if not self:IsReady() then
		self:RegisterLazyLoad(widget, "HandleTreeGroup")
		return
	end

	local db = E.private.WT
		and E.private.WT.skins
		and E.private.WT.skins.widgets
		and E.private.WT.skins.widgets.treeGroupButton

	if widget.CreateButton and not widget.CreateButton_ then
		widget.CreateButton_ = widget.CreateButton
		widget.CreateButton = function(...)
			local button = widget.CreateButton_(...)

			button:SetPushedTextOffset(0, 0)

			if db.text.enable then
				local textObj = button.text
					or button.Text
					or button.GetName and button:GetName() and _G[button:GetName() .. "Text"]
				if textObj and textObj.GetTextColor then
					F.SetFontWithDB(textObj, db.text.font)
					F.InternalizeMethod(textObj, "SetPoint")
					textObj.SetPoint = function(text, point, arg1, arg2, arg3, arg4)
						if point == "LEFT" and type(arg2) == "number" and abs(arg2 - 2) < 0.1 then
							arg2 = -1
						end

						F.CallMethod(text, "SetPoint", point, arg1, arg2, arg3, arg4)
					end

					button.windWidgetText = textObj
				end
			end

			if db.backdrop.enable then
				-- Clear original highlight texture
				button:SetHighlightTexture("")
				if button.highlight then
					button.highlight:SetTexture("")
					button.highlight:Hide()
				end

				-- Create background
				local bg = button:CreateTexture()
				bg:SetInside(button, 2, 0)
				bg:SetAlpha(0)
				bg:SetTexture(LSM:Fetch("statusbar", db.backdrop.texture) or E.media.normTex)

				if button.Center then
					local layer, subLayer = button.Center:GetDrawLayer()
					subLayer = subLayer and subLayer + 1 or 0
					bg:SetDrawLayer(layer, subLayer)
				end

				F.SetVertexColorWithDB(bg, db.backdrop.classColor and E.myClassColor or db.backdrop.color)

				button.windAnimation = self.Animation(bg, db.backdrop.animation)
				self.SetAnimationMetadata(button, button.windAnimation)
				self:SecureHookScript(button, "OnEnter", button.windAnimation.OnEnter)
				self:SecureHookScript(button, "OnLeave", button.windAnimation.OnLeave)
				self:SecureHook(button, "Disable", button.windAnimation.OnStatusChange)
				self:SecureHook(button, "Enable", button.windAnimation.OnStatusChange)

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
			end

			if db.selected.enable then
				button:CreateBackdrop(
					nil,
					LSM:Fetch("statusbar", db.selected.texture) or E.media.glossTex,
					nil,
					nil,
					nil,
					nil,
					nil,
					nil,
					true
				)
				button.backdrop:SetInside(button, 2, 0)
				local borderColor = db.selected.borderClassColor and E.myClassColor or db.selected.borderColor
				local backdropColor = db.selected.backdropClassColor and E.myClassColor or db.selected.backdropColor
				button.backdrop:SetBackdropBorderColor(
					borderColor.r,
					borderColor.g,
					borderColor.b,
					db.selected.borderAlpha
				)
				button.backdrop:SetBackdropColor(
					backdropColor.r,
					backdropColor.g,
					backdropColor.b,
					db.selected.backdropAlpha
				)
				button.backdrop:Hide()
			end

			if db.selected.enable or db.text.enable then
				button.LockHighlight_ = button.LockHighlight
				button.LockHighlight = function(frame)
					if frame.backdrop then
						frame.backdrop:Show()
					end

					if frame.windWidgetText then
						local color = db.text.selectedClassColor and E.myClassColor or db.text.selectedColor
						frame.windWidgetText:SetTextColor(color.r, color.g, color.b)
					end
				end
				button.__UnlockHighlight = button.UnlockHighlight
				button.UnlockHighlight = function(frame)
					if frame.backdrop then
						frame.backdrop:Hide()
					end

					if frame.windWidgetText then
						local color = db.text.normalClassColor and E.myClassColor or db.text.normalColor
						frame.windWidgetText:SetTextColor(color.r, color.g, color.b)
					end
				end
			end

			button.windWidgetSkinned = true
			return button
		end
	end
end
