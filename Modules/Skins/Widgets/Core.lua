local W, F, E, L = unpack(select(2, ...))
local LSM = E.Libs.LSM
local S = W.Modules.Skins
local ES = E.Skins

local WS = W:NewModule("WidgetSkins", "AceHook-3.0")
S.Widgets = WS

local abs = abs
local strlower = strlower

function WS.EnterAnimation(frame)
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

function WS.LeaveAnimation(frame)
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

function WS.IsUglyYellow(...)
    local r, g, b = ...
    return abs(r - 1) + abs(g - 0.82) + abs(b) < 0.02
end

function WS.CreateAnimation(texture, aType, direction, duration, data)
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
