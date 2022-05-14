local W, F, E, L = unpack(select(2, ...))
local LSM = E.Libs.LSM
local S = W.Modules.Skins
local ES = E.Skins

local WS = W:NewModule("WidgetSkins", "AceHook-3.0", "AceEvent-3.0")

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

function WS:HandleButton(
    _,
    button,
    strip,
    isDecline,
    noStyle,
    createBackdrop,
    template,
    noGlossTex,
    overrideTex,
    frameLevel,
    regionsKill,
    regionsZero)
    if not E.private.WT.skins.enable or not button or button.windWidgetSkin then
        return
    end

    if not E.private.WT.skins.widgets.enable or not E.private.WT.skins.widgets.button.enable then
        return
    end

    local db = E.private.WT.skins.widgets.button

    if db.text.enable then
        local text = button.Text or button:GetName() and _G[button:GetName() .. "Text"]
        if text and text.GetTextColor then
            F.SetFontWithDB(text, db.text.font)
        end
    end

    if db.backdrop.enable then
        -- Create background
        local bg = button:CreateTexture()
        bg:SetInside(button, 1, 1)
        bg:SetAlpha(0)
        bg:SetTexture(LSM:Fetch("statusbar", db.backdrop.texture) or E.media.normTex)
        F.SetVertexColorWithDB(bg, db.backdrop.color)

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
        button.SetBackdropBorderColor = E.noop
    end
end

function WS:HandleTab(_, tab, noBackdrop, template)
end

WS:SecureHook(ES, "HandleButton")
WS:SecureHook(ES, "HandleTab")
