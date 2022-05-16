local W, F, E, L = unpack(select(2, ...))
local LSM = E.Libs.LSM
local S = W.Modules.Skins
local ES = E.Skins

local WS = W:NewModule("WidgetSkins", "AceHook-3.0", "AceEvent-3.0")
S.Widgets = WS

local function IsUglyYellow(...)
    local r, g, b = ...
    return abs(r - 1) + abs(g - 0.82) + abs(b) < 0.02
end

local function Frame_OnEnter(frame)
    if not frame:IsEnabled() or not frame.windAnimation then
        return
    end

    if not frame.selected then
        if frame.windAnimation.bgOnLeave:IsPlaying() then
            frame.windAnimation.bgOnLeave:Stop()
        end
        frame.windAnimation.bgOnEnter:Play()
    end
end

local function Frame_OnLeave(frame)
    if not frame:IsEnabled() or not frame.windAnimation then
        return
    end

    if not frame.selected then
        if frame.windAnimation.bgOnEnter:IsPlaying() then
            frame.windAnimation.bgOnEnter:Stop()
        end
        frame.windAnimation.bgOnLeave:Play()
    end
end

local function CreateAnimation(texture, aType, direction, duration, data)
    local aType = strlower(aType)
    local group = texture:CreateAnimationGroup()
    local event = direction == "in" and "OnPlay" or "OnFinished"

    local startAlpha = data and data[1] or (direction == "in" and 0 or 1)
    local endAlpha = data and data[2] or (direction == "in" and 1 or 0)

    if aType == "fade" then
        group.anim = group:CreateAnimation("Alpha")
        group.anim:SetFromAlpha(startAlpha)
        group.anim:SetToAlpha(endAlpha)
        group.anim:SetSmoothing(direction == "in" and "IN" or "OUT")
        group.anim:SetDuration(duration)
    elseif aType == "scale" then
    end

    if group.anim then
        group:SetScript(
            event,
            function()
                texture:SetAlpha(endAlpha)
            end
        )
        group.anim:SetDuration(duration)
        return group
    end
end

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
        F.SetVertexColorWithDB(bg, db.backdrop.classColor and W.ClassColor or db.backdrop.color)

        -- Animations
        button.windAnimation = {
            bg = bg,
            bgOnEnter = CreateAnimation(
                bg,
                db.backdrop.animationType,
                "in",
                db.backdrop.animationDuration,
                {0, db.backdrop.alpha}
            ),
            bgOnLeave = CreateAnimation(
                bg,
                db.backdrop.animationType,
                "out",
                db.backdrop.animationDuration,
                {db.backdrop.alpha, 0}
            )
        }

        button:HookScript("OnEnter", Frame_OnEnter)
        button:HookScript("OnLeave", Frame_OnLeave)

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

function WS:HandleAce3CheckBox(check)
    if not E.private.skins.checkBoxSkin then
        return
    end

    local db = E.private.WT.skins.widgets.checkBox

    if not check or not db or not db.enable then
        return
    end

    if not check.windWidgetSkinned then
        check:SetTexture(LSM:Fetch("statusbar", db.elvUISkin.texture) or E.media.normTex)
        check.SetTexture = E.noop
        check.windWidgetSkinned = true
    end

    if IsUglyYellow(check:GetVertexColor()) then
        F.SetVertexColorWithDB(check, db.elvUISkin.classColor and W.ClassColor or db.elvUISkin.color)
    end
end

do
    ES.Ace3_CheckBoxSetDesaturated_ = ES.Ace3_CheckBoxSetDesaturated
    function ES.Ace3_CheckBoxSetDesaturated(check, value)
        ES.Ace3_CheckBoxSetDesaturated_(check, value)
        WS:HandleAce3CheckBox(check)
    end
end

function WS:HandleCheckBox(_, check)
    if not E.private.skins.checkBoxSkin then
        return
    end

    local db = E.private.WT.skins.widgets.checkBox
    if not check or not db or not db.enable then
        return
    end

    if not check.windWidgetSkinned then
        if check.GetCheckedTexture then
            local tex = check:GetCheckedTexture()
            if tex then
                tex:SetTexture(LSM:Fetch("statusbar", db.elvUISkin.texture) or E.media.normTex)
                tex.SetTexture = E.noop
                F.SetVertexColorWithDB(tex, db.elvUISkin.classColor and W.ClassColor or db.elvUISkin.color)
                tex.SetVertexColor_ = tex.SetVertexColor
                tex.SetVertexColor = function(tex, ...)
                    if IsUglyYellow(...) then
                        local color = db.elvUISkin.classColor and W.ClassColor or db.elvUISkin.color
                        tex:SetVertexColor_(color.r, color.g, color.b, color.a)
                    else
                        tex:SetVertexColor_(...)
                    end
                end
            end
        end

        if check.GetDisabledTexture then
            local tex = check:GetDisabledTexture()
            if tex then
                tex.SetTexture_ = tex.SetTexture
                tex.SetTexture = function(tex, texPath)
                    if not texPath then
                        return
                    end

                    if texPath == "" then
                        tex:SetTexture_("")
                    else
                        tex:SetTexture_(LSM:Fetch("statusbar", db.elvUISkin.texture) or E.media.normTex)
                    end
                end
            end
        end

        check.windWidgetSkinned = true
    end
end

function WS:HandleTab(_, tab, noBackdrop, template)
end

WS:SecureHook(ES, "HandleButton")
WS:SecureHook(ES, "HandleCheckBox")
WS:SecureHook(ES, "HandleTab")
