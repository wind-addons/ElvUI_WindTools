local W, F, E, L, V, P, G = unpack(select(2, ...))
F.Animation = {}
local A = F.Animation

local pairs, type, unpack, getn = pairs, type, unpack, getn
local CreateFrame = CreateFrame

--[[
    创建动画窗体
    @param {string} [name] 动画窗体名
    @param {object} [parent=ElvUIParent] 父窗体
    @param {strata} [string] 窗体层级
    @param {level} [number] 窗体等级
    @param {hidden} [boolean] 窗体创建后隐藏
    @param {texture} [string] 材质路径
    @param {isMirror} [boolean] 使材质沿 y 轴翻折
    @returns object 创建的窗体
]]
function A.CreateAnimationFrame(name, parent, strata, level, hidden, texture, isMirror)
    parent = parent or E.UIParent

    local frame = CreateFrame("Frame", name, parent)

    if strata then
        frame:SetFrameStrata(strata)
    end

    if level then
        frame:SetFrameLevel(level)
    end

    if hidden then
        frame:SetAlpha(0)
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

--[[
    创建动画组
    @param {object} parent 父窗体
    @param {string} [name] 动画组名
    @returns object 生成的动画组
]]
function A.CreateAnimationGroup(frame, name)
    if not frame then
        F.DebugMessage("动画", "[1]父窗体缺失")
        return
    end

    name = name or "anime"

    local animationGroup = frame:CreateAnimationGroup()
    frame[name] = animationGroup

    return animationGroup
end

--[[
    添加移动动画
    @param {object} animationGroup 从属动画组
    @param {string} name 动画索引名
]]
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

--[[
    添加渐入动画
    @param {object} animationGroup 从属动画组
    @param {string} name 动画索引名
]]
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

--[[
    添加渐隐动画
    @param {object} animationGroup 从属动画组
    @param {string} name 动画索引名
]]
function A.AddFadeOut(animationGroup, name)
    if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
        F.DebugMessage("动画", "[2]找不到动画组")
        return
    end

    if not name then
        F.DebugMessage("动画", "[3]动画名缺失")
        return
    end

    local animation = animationGroup:CreateAnimation("Alpha")
    animation:SetFromAlpha(1)
    animation:SetToAlpha(0)
    animation:SetSmoothing("OUT")
    animation:SetParent(animationGroup)
    animationGroup[name] = animation
end

--[[
    添加缩放动画
    @param {object} animationGroup 从属动画组
    @param {string} name 动画索引名
    @param {number[2]} fromScale 原尺寸 x, y
    @param {number[2]} toScale 动画后尺寸 x, y
]]
function A.AddScale(animationGroup, name, fromScale, toScale)
    if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
        F.DebugMessage("动画", "[3]找不到动画组")
        return
    end

    if not name then
        F.DebugMessage("动画", "[4]动画名缺失")
        return
    end

    if not fromScale or type(fromScale) ~= "table" or getn(fromScale) < 2 then
        F.DebugMessage("动画", "[1]缩放动画初始x,y错误")
        return
    end

    if not toScale or type(toScale) ~= "table" or getn(toScale) < 2 then
        F.DebugMessage("动画", "[1]缩放动画目标x,y错误")
        return
    end

    local animation = animationGroup:CreateAnimation("Scale")
    animation:SetFromScale(unpack(fromScale))
    animation:SetToScale(unpack(toScale))
    animation:SetParent(animationGroup)
    animationGroup[name] = animation
end

--[[
    设定动画随显示属性而播放
    @param {object} frame 动画窗体
    @param {object} animationGroup 动画组
]]
function A.PlayAnimationOnShow(frame, animationGroup)
    if not animationGroup or type(animationGroup) == "string" then
        animationGroup = frame[animationGroup]
    end

    if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
        F.DebugMessage("动画", "[3]找不到动画组")
        return
    end

    frame:SetScript(
        "OnShow",
        function()
            animationGroup:Play()
        end
    )
end

--[[
    设定动画随显示属性而播放
    @param {object} frame 动画窗体
    @param {object} animationGroup 动画组
    @param {function} [callback] 结束时的回调
]]
function A.CloseAnimationOnHide(frame, animationGroup, callback)
    if not animationGroup or type(animationGroup) == "string" then
        animationGroup = frame[animationGroup]
    end

    if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
        F.DebugMessage("动画", "[3]找不到动画组")
        return
    end

    animationGroup:SetScript(
        "OnFinished",
        function()
            frame:Hide()
            if callback then
                callback()
            end
        end
    )
end

--[[
    调整动画组速度
    @param {object} animationGroup 动画组
    @param {number} speed 相较于原速度的倍数
]]
function A.SpeedAnimationGroup(animationGroup, speed)
    if not speed or type(speed) ~= "number" then
        F.DebugMessage("动画", "[1]找不到速度")
        return
    end

    if not (animationGroup and animationGroup:IsObjectType("AnimationGroup")) then
        F.DebugMessage("动画", "[4]找不到动画组")
        return
    end

    if not animationGroup.GetAnimations then
        F.DebugMessage("动画", "[1]无法找到动画组的子成员")
        return
    end

    local durationTimer = 1 / speed

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
