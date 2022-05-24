local W, F, E, L = unpack(select(2, ...))
local LSM = E.Libs.LSM
local S = W.Modules.Skins
local WS = S.Widgets
local ES = E.Skins

local _G = _G
local abs = abs
local type = type

function WS:HandleTreeGroup(widget)
    if not E.private.WT.skins.enable or not E.private.WT.skins.widgets.treeGroupButton.enable then
        return
    end

    if not E.private.WT.skins.widgets then
        self:RegisterLazyLoad(widget, "HandleTreeGroup")
        return
    end

    local db = E.private.WT.skins.widgets.treeGroupButton

    if widget.CreateButton then
        widget.CreateButton_ = widget.CreateButton
        widget.CreateButton = function(...)
            local button = widget.CreateButton_(...)

            if db.text.enable then
                local text =
                    button.text or button.Text or button.GetName and button:GetName() and _G[button:GetName() .. "Text"]
                if text and text.GetTextColor then
                    F.SetFontWithDB(text, db.text.font)

                    text.SetPoint_ = text.SetPoint
                    text.SetPoint = function(text, point, arg1, arg2, arg3, arg4)
                        if point == "LEFT" and type(arg2) == "number" and abs(arg2 - 2) < 0.1 then
                            arg2 = 0
                        end

                        text.SetPoint_(text, point, arg1, arg2, arg3, arg4)
                    end

                    button.windWidgetText = text
                end
            end

            if db.backdrop.enable then
                -- Create background
                button:SetHighlightTexture("")

                local bg = button:CreateTexture()
                bg:SetInside(button, 2, 0)
                bg:SetAlpha(0)
                bg:SetTexture(LSM:Fetch("statusbar", db.backdrop.texture) or E.media.normTex)

                if button.Center then
                    local layer, subLayer = button.Center:GetDrawLayer()
                    subLayer = subLayer and subLayer + 1 or 0
                    bg:SetDrawLayer(layer, subLayer)
                end

                F.SetVertexColorWithDB(bg, db.backdrop.classColor and W.ClassColor or db.backdrop.color)

                local group, onEnter, onLeave =
                    self.Animation(bg, db.backdrop.animationType, db.backdrop.animationDuration, db.backdrop.alpha)
                button.windAnimation = {
                    bg = bg,
                    group = group,
                    onEnter = onEnter,
                    onLeave = onLeave
                }

                self:SecureHookScript(button, "OnEnter", onEnter)
                self:SecureHookScript(button, "OnLeave", onLeave)

                -- Avoid the hook is flushed
                self:SecureHook(
                    button,
                    "SetScript",
                    function(frame, scriptType)
                        if scriptType == "OnEnter" then
                            self:Unhook(frame, "OnEnter")
                            self:SecureHookScript(frame, "OnEnter", onEnter)
                        elseif scriptType == "OnLeave" then
                            self:Unhook(frame, "OnLeave")
                            self:SecureHookScript(frame, "OnLeave", onLeave)
                        end
                    end
                )
            end

            if db.selected.enable then
                button:CreateBackdrop()
                button.backdrop:SetInside(button, 2, 0)
                local borderColor = db.selected.borderClassColor and W.ClassColor or db.selected.borderColor
                local backdropColor = db.selected.backdropClassColor and W.ClassColor or db.selected.backdropColor
                button.backdrop.Center:SetTexture(LSM:Fetch("statusbar", db.selected.texture) or E.media.glossTex)
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
                        local color = db.text.selectedClassColor and W.ClassColor or db.text.selectedColor
                        frame.windWidgetText:SetTextColor(color.r, color.g, color.b)
                    end
                end
                button.UnlockHighlight_ = button.UnlockHighlight
                button.UnlockHighlight = function(frame)
                    if frame.backdrop then
                        frame.backdrop:Hide()
                    end

                    if frame.windWidgetText then
                        local color = db.text.normalClassColor and W.ClassColor or db.text.normalColor
                        frame.windWidgetText:SetTextColor(color.r, color.g, color.b)
                    end
                end
            end

            button.windWidgetSkinned = true
            return button
        end
    end
end
