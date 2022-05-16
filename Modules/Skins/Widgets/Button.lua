local W, F, E, L = unpack(select(2, ...))
local LSM = E.Libs.LSM
local S = W.Modules.Skins
local WS = S.Widgets
local ES = E.Skins

function WS:HandleButton(_, button)
    if not button or button.windWidgetSkinned then
        return
    end

    if not E.private.WT.skins.enable or not E.private.WT.skins.widgets.button.enable then
        return
    end

    local db = E.private.WT.skins.widgets.button

    if db.text.enable then
        local text = button.Text or button.GetName and button:GetName() and _G[button:GetName() .. "Text"]
        if text and text.GetTextColor then
            F.SetFontWithDB(text, db.text.font)
        end
    end

    if button.template and db.backdrop.enable then
        -- Create background
        local bg = button:CreateTexture()
        bg:SetInside(button, 1, 1)
        bg:SetAlpha(0)
        bg:SetTexture(LSM:Fetch("statusbar", db.backdrop.texture) or E.media.normTex)

        if button.Center then
            local layer, subLayer = button.Center:GetDrawLayer()
            subLayer = subLayer and subLayer + 1 or 0
            bg:SetDrawLayer(layer, subLayer)
        end

        F.SetVertexColorWithDB(bg, db.backdrop.classColor and W.ClassColor or db.backdrop.color)

        -- Animations
        button.windAnimation = {
            bg = bg,
            bgOnEnter = self.CreateAnimation(
                bg,
                db.backdrop.animationType,
                "in",
                db.backdrop.animationDuration,
                {0, db.backdrop.alpha}
            ),
            bgOnLeave = self.CreateAnimation(
                bg,
                db.backdrop.animationType,
                "out",
                db.backdrop.animationDuration,
                {db.backdrop.alpha, 0}
            )
        }

        self:SecureHookScript(button, "OnEnter", WS.EnterAnimation)
        self:SecureHookScript(button, "OnLeave", WS.LeaveAnimation)

        -- Avoid the hook is flushed
        self:SecureHook(
            button,
            "SetScript",
            function(frame, scriptType)
                if scriptType == "OnEnter" then
                    self:Unhook(frame, "OnEnter")
                    self:SecureHookScript(frame, "OnEnter", WS.EnterAnimation)
                elseif scriptType == "OnLeave" then
                    self:Unhook(frame, "OnLeave")
                    self:SecureHookScript(frame, "OnLeave", WS.LeaveAnimation)
                end
            end
        )

        if db.backdrop.removeBorderEffect then
            button.SetBackdropBorderColor = E.noop
        end
    end

    button.windWidgetSkinned = true
end

do
    ES.Ace3_RegisterAsWidget_ = ES.Ace3_RegisterAsWidget
    function ES:Ace3_RegisterAsWidget(widget)
        ES:Ace3_RegisterAsWidget_(widget)
        WS:HandleButton(nil, widget)
    end
end

WS:SecureHook(ES, "HandleButton")
