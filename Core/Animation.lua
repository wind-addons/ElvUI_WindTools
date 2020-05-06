local W, F, E, L, V, P, G = unpack(select(2, ...))
F.Animation = {}
local A = F.Animation

local pairs, type = pairs, type

function A.CreateAnimationFrame(name, parent, strata, level, hidden, texture, isMirror)
    local frame = CreateFrame("Frame", name, parent)
    if strata then frame:SetFrameStrata(strata) end
    if level then frame:SetFrameLevel(level) end
    if hidden then
        frame:SetAlpha(0);
        frame:Hide()
    end

    local tex = frame:CreateTexture()
    tex:SetTexture(texture)

    if isMirror then
        local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = tex:GetTexCoord() -- 沿 y 轴翻转素材
        tex:SetTexCoord(URx, URy, LRx, LRy, ULx, ULy, LLx, LLy)
    end

    tex:SetAllPoints()

    return frame
end

function A.CreateAnimationGroup(frame, name)
    if not frame then return end
    name = name or "WindAnime"
    local animationGroup = frame:CreateAnimationGroup()
    frame[name] = animationGroup
    return animationGroup
end

function A.AddTranslation(animationGroup, name)
    if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then return end
    if not name then
        F.DebugMessage("动画", "[1]动画名缺失")
        return
    end

    local animation = animationGroup:CreateAnimation("Translation")
    animation:SetParent(animationGroup)
    animationGroup[name] = animation
end

function A.AddFadeIn(animationGroup, name)
    if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
        F.DebugMessage("动画", "[1]找不到动画组")
        return
    end
    if not name then
        F.DebugMessage("动画", "[2]动画名缺失")
        return
    end

    local animation = animationGroup:CreateAnimation("Alpha")
    animation:SetFromAlpha(0)
    animation:SetToAlpha(1)
    animation:SetSmoothing("IN")
    animation:SetParent(animationGroup)
    animationGroup[name] = animation
end

function A.AddFadeOut(animationGroup, name)
    if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
        F.DebugMessage("动画", "[2]找不到动画组")
        return
    end
    if not name then
        F.DebugMessage("动画", "动画名缺失")
        return
    end

    local animation = animationGroup:CreateAnimation("Alpha")
    animation:SetFromAlpha(1)
    animation:SetToAlpha(0)
    animation:SetSmoothing("OUT")
    animation.aType = "Alpha"
    animation:SetParent(animationGroup)
    animationGroup[name] = animation
end

function A.SetAnimationWhileShowing(frame, animationGroup)
    if not animationGroup or type(animationGroup) == "string" then animationGroup = self[animationGroup] end
    if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
        F.DebugMessage("动画", "[3]找不到动画组")
        return
    end

    frame:SetScript("OnShow", function() animationGroup:Play() end)
    animationGroup:SetScript("OnFinished", function() frame:Hide() end)
end

function A.SpeedAnimationGroup(animationGroup, speed)
    if not speed or type(speed) ~= "number" then
        F.DebugMessage("动画", "[1]找不到速度")
        return
    end
    if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
        F.DebugMessage("动画", "[4]找不到动画组")
        return
    end
    local durationTimer = 1 / speed

    if not animationGroup.GetAnimations then
        F.DebugMessage("动画", "[1]无法找到动画组的子成员")
        return
    end
    for _, animation in pairs({animationGroup:GetAnimations()}) do
        if not animation.originalDuration then animation.originalDuration = animation:GetDuration() end
            if not animation.originalStartDelay then animation.originalStartDelay = animation:GetStartDelay() end
            animation:SetDuration(animation.originalDuration * durationTimer)
            animation:SetStartDelay(animation.originalStartDelay * durationTimer)
    end
end
