local W, F, E, L = unpack(select(2, ...))
local LSM = E.Libs.LSM
local S = W.Modules.Skins
local ES = E.Skins

local WS = W:NewModule("WidgetSkins", "AceHook-3.0", "AceEvent-3.0")
S.Widgets = WS

local abs = abs
local pairs = pairs
local pcall = pcall
local strlower = strlower
local type = type

function WS.IsUglyYellow(...)
    local r, g, b = ...
    return abs(r - 1) + abs(g - 0.82) + abs(b) < 0.02
end

function WS.Animation(texture, aType, duration, data)
    local aType = strlower(aType)
    local group = texture:CreateAnimationGroup()

    if aType == "fade" then
        local alpha = data
        local anim = group:CreateAnimation("Alpha")
        group.anim = anim

        -- Set the default status is waiting to play enter animation
        anim.isEnterMode = true
        anim:SetFromAlpha(0)
        anim:SetToAlpha(alpha)
        anim:SetSmoothing("in")
        anim:SetDuration(duration)

        group:SetScript(
            "OnPlay",
            function()
                texture:SetAlpha(anim:GetFromAlpha())
            end
        )

        group:SetScript(
            "OnFinished",
            function()
                texture:SetAlpha(anim:GetToAlpha())
            end
        )

        local restart = function()
            if group:IsPlaying() then
                group:Pause()
                group:Restart()
            else
                group:Play()
            end
        end

        local onEnter = function()
            local remainingProgress = anim.isEnterMode and (1 - anim:GetProgress()) or anim:GetProgress()
            local remainingDuration = remainingProgress * duration

            anim:SetFromAlpha(alpha * (1 - remainingProgress))
            anim:SetToAlpha(alpha)
            anim:SetSmoothing("in")
            anim:SetDuration(remainingDuration)
            anim.isEnterMode = true
            restart()
        end

        local onLeave = function()
            local remainingProgress = anim.isEnterMode and anim:GetProgress() or (1 - anim:GetProgress())
            local remainingDuration = remainingProgress * duration

            anim:SetFromAlpha(alpha * remainingProgress)
            anim:SetToAlpha(0)
            anim:SetSmoothing("out")
            anim:SetDuration(remainingDuration)
            anim.isEnterMode = false
            restart()
        end

        return group, onEnter, onLeave
    elseif aType == "scale" then
    end
end

function WS:Ace3_RegisterAsWidget(_, widget)
    local widgetType = widget.type

    if not widgetType then
        return
    end

    if widgetType == "Button" or widgetType == "Button-ElvUI" then
        self:HandleButton(nil, widget)
    end
end

function WS:Ace3_RegisterAsContainer(_, widget)
    local widgetType = widget.type

    if not widgetType then
        return
    end

    if widgetType == "TreeGroup" then
        self:HandleTreeGroup(widget)
    end
end

WS:SecureHook(ES, "Ace3_RegisterAsWidget")
WS:SecureHook(ES, "Ace3_RegisterAsContainer")

WS.LazyLoadTable = {}

function WS:RegisterLazyLoad(frame, func)
    if not frame then
        F.DebugMessage(WS, "frame is nil.")
        return
    end

    if type(func) ~= "function" then
        if self[func] and type(self[func]) == "function" then
            func = self[func]
        else
            F.DebugMessage(WS, func .. " is not a function.")
            return
        end
    end

    self.LazyLoadTable[frame] = func
end

function WS:LazyLoad()
    for frame, func in pairs(self.LazyLoadTable) do
        if frame and func then
            pcall(func, self, frame)
        end
    end

    wipe(self.LazyLoadTable)
end

function WS:PLAYER_ENTERING_WORLD()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:LazyLoad()
end

WS:RegisterEvent("PLAYER_ENTERING_WORLD")
