local W, F, E, L, V, P, G = unpack(select(2, ...))
F.Animation = {}
local A = F.Animation

local pairs, type = pairs, type

---------------------------------------------------
-- 函数：创建动画框体
-- 可选参数
-- - name(string)     框体名
-- - parent(object)   父框体
-- - strata(string)   框体的显示层级
-- - level(string)    框体层级内的显示等级
-- - hidden(bool)     是否初始化为隐藏
-- - texture(string)  材质的文件路径
-- - isMirror(string) 是否翻转材质
-- 返回值
-- - (object)         生成的框体
---------------------------------------------------
function A.CreateAnimationFrame(name, parent, strata, level, hidden, texture, isMirror)
    local frame = CreateFrame("Frame", name, parent)
    if strata then
        frame:SetFrameStrata(strata)
    end
    if level then
        frame:SetFrameLevel(level)
    end
    if hidden then
        frame:SetAlpha(0);
        frame:Hide()
    end

    if texture then
        local tex = frame:CreateTexture()
        tex:SetTexture(texture)

        if isMirror then
            local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = tex:GetTexCoord() -- 沿 y 轴翻转素材
            tex:SetTexCoord(URx, URy, LRx, LRy, ULx, ULy, LLx, LLy)
        end

        tex:SetAllPoints()
        frame.texture = tex
    end

    return frame
end

---------------------------------------------------
-- 函数：创建动画组
-- 必要参数
-- - frame(object) 父框体
-- 可选参数
-- - name(string)  动画组名
-- 返回值
-- - (object)      生成的动画组
---------------------------------------------------
function A.CreateAnimationGroup(frame, name)
    if not frame then
        F.DebugMessage("动画", "[1]父框体缺失")
        return
    end
    name = name or "anime"
    local animationGroup = frame:CreateAnimationGroup()
    frame[name] = animationGroup
    return animationGroup
end

---------------------------------------------------
-- 函数：添加移动动画
-- 必要参数
-- - animationGroup(object) 从属动画组
-- - name(string)           动画索引名
---------------------------------------------------
function A.AddTranslation(animationGroup, name)
    if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
        return
    end
    if not name then
        F.DebugMessage("动画", "[1]动画名缺失")
        return
    end

    local animation = animationGroup:CreateAnimation("Translation")
    animation:SetParent(animationGroup)
    animationGroup[name] = animation
end

---------------------------------------------------
-- 函数：添加渐入动画
-- 必要参数
-- - animationGroup(object) 从属动画组
-- - name(string)           动画索引名
---------------------------------------------------
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

---------------------------------------------------
-- 函数：添加渐隐动画
-- 必要参数
-- - animationGroup(object) 从属动画组
-- - name(string)           动画索引名
---------------------------------------------------
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

---------------------------------------------------
-- 函数：设定动画随显示属性而播放
-- 必要参数
-- - frame(object)          动画框体
-- - animationGroup(object) 动画组
---------------------------------------------------
function A.PlayAnimationOnShow(frame, animationGroup)
    if not animationGroup or type(animationGroup) == "string" then
        animationGroup = self[animationGroup]
    end
    if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
        F.DebugMessage("动画", "[3]找不到动画组")
        return
    end

    frame:SetScript(
        "OnShow", function()
            animationGroup:Play()
        end
    )
end

---------------------------------------------------
-- 函数：设定动画结束时的操作
-- 必要参数
-- - frame(object)          动画框体
-- - animationGroup(object) 动画组
-- 可选参数
-- - endFunc(function)      结束时的回调
---------------------------------------------------
function A.CloseAnimationOnHide(frame, animationGroup, callback)
    if not animationGroup or type(animationGroup) == "string" then
        animationGroup = self[animationGroup]
    end
    if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
        F.DebugMessage("动画", "[3]找不到动画组")
        return
    end

    animationGroup:SetScript(
        "OnFinished", function()
            frame:Hide()
            if callback then
                callback()
            end
        end
    )
end

---------------------------------------------------
-- 函数：调整动画组速度
-- 必要参数
-- - animationGroup(object) 动画组
-- - speed(number)          速度（相较于原速度的倍数）
---------------------------------------------------
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
        if not animation.originalDuration then
            animation.originalDuration = animation:GetDuration()
        end
        if not animation.originalStartDelay then
            animation.originalStartDelay = animation:GetStartDelay()
        end
        animation:SetDuration(animation.originalDuration * durationTimer)
        animation:SetStartDelay(animation.originalStartDelay * durationTimer)
    end
end
